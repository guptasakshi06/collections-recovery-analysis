# Executive Memo — Is the 11% Recovery Improvement Real?
**To:** Leadership · **From:** Collections Analytics · **Re:** Independent audit of the reported "+11% MoM recovery" claim and the ₹10 Cr allocation decision

---

## What happened
Over the 7 complete months of data available (Jan–Jul 2026), successful recovery moved from **₹18.72 Cr (Jan) to ₹18.72 Cr (Jul) — a net change of +0.01%**. In between, recovery swung month to month by as much as **±11%**, with no consistent direction (−9.1%, +11.0%, −7.3%, +5.2%, −4.7%, +6.7%). A trend line fit to the monthly series explains essentially none of the variance (R² = 0.004). Portfolio mix (risk segment share of recovered value) was stable throughout, so this is not a mix-shift effect — it is month-to-month noise around a flat baseline.

## Why
No driver tested — channel, DPD bucket, agent tenure, or targeting priority — shows a statistically meaningful relationship with the month-to-month swings. Channel-level recovery-per-target ranges only ₹73.9k–₹76.2k across four channels, well within one standard error of each other. The one structural issue that *does* move the numbers materially is **attribution**: 56.7% of targeted accounts are touched by more than one campaign, and the number of payments matchable to a prior campaign ranges from 1,338 (7-day window) to 9,505 (90-day window) — a 7x swing depending on an analytical choice, not a business change.

## Is the 11% claim real?
**No — not as a sustained trend.** The reported figure matches almost exactly one specific month pair (Feb→Mar: +11.03%) out of six available pairs. Presented as "the" trend, it substitutes a single favorable data point for the actual 7-month picture, which is flat. We recommend the claim be retracted or rescoped to something defensible, e.g. *"recovery was flat over H1 2026, with normal month-to-month volatility of roughly ±8 points and no identified structural driver of improvement."*

## Confidence
| Conclusion | Classification |
|---|---|
| Jan and Jul recovery are effectively equal (+0.01%) | **Fact** |
| 7-month trend has no statistical signal (R²=0.004) | **Fact** |
| The reported 11% matches the Feb→Mar month pair | **Fact** |
| Risk-segment mix is stable across months | **Fact** |
| Channel/DPD/tenure show no meaningful driver effect | **Strong evidence** |
| Campaign attribution is materially window-dependent | **Fact** |
| A mid-year targeting-strategy change occurred | **Hypothesis — not detected** in targeting volume, priority, or channel-mix data; the assignment brief assumes this, but no break-point was found |
| Agent/vendor identity requires effective-dated joins | **Strong evidence** (100% of agent_ids show conflicting historical attributes) |

## What should we do
1. **Correct the internal narrative** — stop reporting +11% as a trend.
2. **Fix attribution before spending on channels or targeting** — define one attribution window/rule; it's cheap and it's currently the single biggest source of "driver" noise in existing reports.
3. **Do not commit the full ₹10 Cr on the current evidence.** No cost data exists for any of the six investment options, and no driver shows a proven edge. Recommend a funded 2–3 month controlled pilot (randomized channel/staffing allocation, cost tracked from day one) sized well below ₹10 Cr, to generate the evidence a full commitment would need.
4. **Fix identified data-quality issues** at source: 500 duplicate payment IDs (₹2.59 Cr), 2,034 payment/account borrower conflicts (~₹10.85 Cr), and agent/vendor identity resolution (currently unusable for confident agent-level ranking).

## Expected financial impact of these recommendations
Not independently estimable with the data provided — see the Investment tab of the dashboard for the specific data/experiments needed to produce a defensible ROI case. What we can say with confidence: continuing to allocate capital against an unverified +11% narrative risks measuring success against a number that was never real.

---
*Full detail, all supporting numbers, and the interactive breakdowns behind every claim above are in `collections_recovery_dashboard.html` and `metric_dictionary.md`.*
