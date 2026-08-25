# Metric Dictionary — Collections Recovery Analytics
Single source of truth for every KPI used in the dashboard. All metrics are computed from the **golden layer** (deduplicated `payments`, joined against `accounts`, `calls`, `promises_to_pay`, `daily_targeting`, `agents`, `agent_sessions` in `sql/collections_analysis.db`).

---

### Contact Rate
- **Definition:** Share of calls that were answered.
- **SQL:** `100.0 * SUM(call_status='ANSWERED') / COUNT(*)` over `calls`, grouped by month.
- **Numerator:** Answered calls. **Denominator:** All calls.
- **Grain:** Month. **Time window:** Calendar month of `calls.event_at`.
- **Exclusions:** None.
- **Limitation:** Does not confirm the answering party was the borrower (see RPC).

### RPC — Right-Party Contact Rate
- **Definition:** Share of call dispositions that represent an actual conversation with a contactable party (excludes `NO_CONTACT`, `WRONG_NUMBER`).
- **SQL:** `100.0 * COUNT(disposition_code NOT IN ('NO_CONTACT','WRONG_NUMBER')) / COUNT(*)` over `call_dispositions`, grouped by month.
- **Limitation (important):** The raw data has **no explicit "right party" flag**. This is a documented proxy/assumption, not a ground-truth field. Treat as directional.

### PTP Rate
- **Definition:** Promises-to-pay made per right-party contact.
- **SQL:** `100.0 * COUNT(promises_to_pay) / COUNT(rpc_dispositions)`, grouped by month.
- **Limitation:** PTPs and dispositions are not joined 1:1 by call_id in the source data; counts are compared at the monthly aggregate level, not the individual-interaction level.

### PTP Kept Rate
- **Definition:** Share of PTPs that were ultimately kept.
- **Two versions reported:**
  - *All PTPs*: `KEPT / (KEPT+BROKEN+CANCELLED+OPEN)` — headline number.
  - *Resolved only*: `KEPT / (KEPT+BROKEN)` — excludes still-open/cancelled PTPs, better reflects true keep behavior.
- **Grain:** Month, by `promises_to_pay.event_at`.

### Recovery Rate
- **Definition:** Successful payment value recovered as a % of total portfolio outstanding.
- **SQL:** `100.0 * SUM(amount WHERE payment_status='SUCCESS') / (SELECT SUM(outstanding_amount) FROM accounts)`, grouped by month.
- **Denominator:** Held constant (total portfolio outstanding, ₹1,048.9 Cr) across all months so the ratio isolates changes in recovery, not portfolio size. This is a deliberate design choice — an alternative (month-specific outstanding) is not computable because `accounts` is a current snapshot, not a monthly history.

### Recovery / Account
- **Definition:** Average successful recovery per account that made at least one successful payment that month.
- **SQL:** `SUM(amount WHERE SUCCESS) / COUNT(DISTINCT account_id WHERE SUCCESS)`, grouped by month.
- **Note:** Denominator is *paying* accounts, not all 30,000 accounts — this measures ticket size, not overall portfolio yield (that's Recovery Rate).

### Recovery / Agent-Hour
- **Definition:** Successful recovery value per hour of logged agent session time.
- **SQL:** `SUM(amount WHERE SUCCESS) / SUM(hours)` from `agent_sessions` (login→logout), grouped by month.
- **Exclusions:** Sessions with non-positive or >24hr duration (data errors) excluded (a handful of rows).

### Cost / ₹ Recovered
- **Status: NOT COMPUTABLE.** No cost, salary, campaign-spend, or vendor-pricing field exists in any of the 17 source tables. Do not let any dashboard or report imply this has been calculated — it has not.

### Channel Conversion
- **Definition:** Successful payment value per contacted target, by `daily_targeting.recommended_channel`.
- **Method:** Payments matched via `merge_asof` (backward) to the most recent targeting event per account, restricted to a **30-day attribution window** (chosen for consistency; see sensitivity table in Driver tab — results are window-dependent).
- **Limitation:** 56.7% of targeted accounts touch multiple campaigns; a different window changes matched-payment counts by up to 7x.

---

## Golden dataset construction rules (applied)
1. `payments`: deduplicated on `payment_id`, keep first occurrence (removes 500 duplicate IDs / 486 exact-duplicate rows / ₹2.59 Cr of double-counted SUCCESS value).
2. `payment_status = 'SUCCESS'` is the only status counted as realized recovery. FAILED/PENDING/REVERSED excluded.
3. Records with payment↔account borrower_id conflicts (2,034 rows, ~₹10.85 Cr SUCCESS value) are **flagged, not deleted or silently reassigned** — excluded from borrower-level cuts, included in account/portfolio-level totals.
4. `accounts.outstanding_amount > principal_amount` (13,029 accounts) is flagged but not corrected — no business rule was available to interpret it (could be legitimate fees/penalties).
5. Agent/vendor attributes are **not** effective-dated in the current `account_month` table — this is a known limitation; agent-level and vendor-level cuts should be treated as directional until an effective-dated join is built.

## Rule: one definition, everywhere
Every dashboard page reads from this same set of definitions. If a number looks different from a source SQL script in `sql/`, that script has not yet been reconciled to this dictionary — flag it rather than trusting the older number.
