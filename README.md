# Collections Recovery Analysis

**Question this project answers:** the business reported that collections
recovery improved 11% month-on-month. Is that true, why did it (or didn't
it) happen, and where should the ₹10 crore investment decision go?

**Short answer:** No — the +11% is a real number, but it's one favorable
month-pair (Feb→Mar) presented as a trend. Across the full 7-month window
(Jan–Jul 2026), recovery is flat: ₹18.72 Cr in January, ₹18.72 Cr in July
(+0.01% net), with no statistically detectable trend (R² = 0.004). Full
reasoning is in [`reports/executive_memo.md`](reports/executive_memo.md).

## Start here

| If you want... | Go to... |
|---|---|
| The 2-minute version | [`reports/executive_memo.md`](reports/executive_memo.md) |
| Every number, laid out with confidence levels | [`reports/key_findings.md`](reports/key_findings.md) |
| The interactive audit — click through the claim, drivers, data quality, investment case | [`dashboards/collections_recovery_dashboard.html`](dashboards/collections_recovery_dashboard.html) *(open directly in a browser)* |
| The same figures in Excel | [`dashboards/collections_dashboard.xlsx`](dashboards/collections_dashboard.xlsx) |
| The ₹10 Cr recommendation | [`reports/investment_recommendation.md`](reports/investment_recommendation.md) |
| Exactly how each metric is defined and computed | [`reports/metric_dictionary.md`](reports/metric_dictionary.md) |
| How data flows from raw CSVs to these numbers | [`architecture/architecture.md`](architecture/architecture.md) |

## What's actually in the data

30,000 accounts, ~25,500 payment records, and 15 other tables (calls, PTPs,
targeting, campaigns, field visits, complaints, SMS/WhatsApp events, agent
sessions, etc.) covering Jan–Aug 2026. August is partial (8 of 31 days) and
excluded from all trend statistics.

The dataset is synthetic and was built with deliberate mess baked in —
duplicate payment IDs, conflicting borrower/agent identities, backdated
timestamps, an attribution window that changes campaign results 7x
depending on the choice. Finding and documenting that mess, rather than
quietly working around it, is a core part of this analysis. See
[`reports/key_findings.md` § Data Quality](reports/key_findings.md) and the
**Data Quality** tab of the dashboard for the full list.

## Headline numbers (7-month average, Jan–Jul 2026)

| Metric | Value |
|---|---|
| Successful recovery | ₹131.56 Cr |
| Reconstructed recovery rate | 10.87% (reported: 11.00%) |
| Payment success rate | 70.14% |
| Kept PTPs → successful payment | 20.67% |
| Jan → Jul recovery, net change | +0.01% |
| 7-month trend strength | R² = 0.004 (no signal) |

## Project layout

```
data/
  raw/            original 17-table export (as received, untouched)
  processed/      cleaned CSVs, one per raw table (_clean.csv)
sql/
  collections_analysis.db   SQLite database — raw + golden (account_month) tables
  01-12_*.sql                analysis pipeline, run in numeric order (see architecture/)
  13_dashboard_workbook.py   regenerates dashboards/collections_dashboard.xlsx
notebooks/
  01_data_profiling.ipynb    exploratory profiling that drove every cleaning decision
  02_load_sqlite.py          loads data/processed/*.csv into collections_analysis.db
dashboards/
  collections_recovery_dashboard.html   primary interactive dashboard (no server needed)
  collections_dashboard.xlsx            same figures, Excel format
  monthly_recovery.csv                  monthly KPI export
reports/
  executive_memo.md              the audit finding, for leadership
  key_findings.md                full results with confidence classifications
  investment_recommendation.md   the ₹10 Cr recommendation and proposed experiment
  metric_dictionary.md           single source of truth for every KPI definition
architecture/
  architecture.md    how raw data becomes golden data becomes dashboard numbers
```

## How to reproduce this

```bash
# clean raw → processed, load into SQLite, run the SQL pipeline —
# full step-by-step in architecture/architecture.md
jupyter nbconvert --to notebook --execute notebooks/01_data_profiling.ipynb
python notebooks/02_load_sqlite.py
# then run sql/02 through sql/12 in order against collections_analysis.db

# rebuild the Excel dashboard from the golden layer
cd sql && python3 13_dashboard_workbook.py
```

The HTML dashboard's data is embedded as JSON at build time (from
`sql/12_dashboard_data.sql`); regenerate that query's output and paste it
into the `<script id="dashboard-data">` block to refresh the HTML view.

## Ground rules this analysis followed

1. **Nothing is fabricated.** Where the data can't answer a question (there
   is no cost/spend/salary field anywhere in the 17 source tables, so ROI
   and cost-per-₹-recovered are not computable), the reports say so
   explicitly rather than assuming a plausible-sounding number.
2. **Ambiguous data problems are flagged, not silently resolved.** A
   conflict without a clear business rule (e.g. `outstanding_amount >
   principal_amount`) is documented and excluded from the affected cut,
   not guessed at.
3. **One definition per metric, everywhere.** `reports/metric_dictionary.md`
   is authoritative; every dashboard and report number traces back to it.
4. **Correlation is labeled as correlation.** Every finding carries a
   confidence tag — Fact / Strong evidence / Correlation / Hypothesis — so
   a reader can tell what's proven from what's a reasonable guess.
