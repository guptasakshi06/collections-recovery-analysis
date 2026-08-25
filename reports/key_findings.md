# Collections Analysis — Key Findings

## Executive Summary

The analysis reconstructed collections recovery from the cleaned transaction-level
data across 30,000 accounts and 25,000 payment records.

The reported 11% recovery rate is broadly supported. The independently reconstructed
recovery rate is 10.87%, compared with the reported 11%, a difference of only
0.13 percentage points.

However, the claim that recovery improved by 11% month-on-month is not supported
as a sustained trend. Monthly recovery fluctuated, with only March showing an
approximately 11% increase (+11.03%).

## Key Metrics

- Accounts: 30,000
- Payments: 25,000
- Successful payments: 17,534
- Successful recovery: ₹131.56 crore
- Payment success rate: 70.14%
- Reconstructed recovery rate: 10.87%
- Reported recovery rate: 11.00%
- Difference: -0.13 percentage points
- KEPT PTPs: 4,489
- KEPT PTPs followed by successful payment: 928
- PTP-to-successful-payment rate: 20.67%

## Month-on-Month Recovery

| Month | Recovery | MoM Change |
|---|---:|---:|
| 2026-01 | ₹18.72 Cr | — |
| 2026-02 | ₹17.01 Cr | -9.13% |
| 2026-03 | ₹18.89 Cr | +11.03% |
| 2026-04 | ₹17.51 Cr | -7.29% |
| 2026-05 | ₹18.43 Cr | +5.20% |
| 2026-06 | ₹17.56 Cr | -4.72% |
| 2026-07 | ₹18.72 Cr | +6.65% |
| 2026-08 | ₹4.71 Cr | -74.84%* |

*August is a partial month and should not be compared directly with full months.*

## Targeting

SMS had the highest observed contact rate at 25.15%, followed by WhatsApp
(25.06%), Field (25.01%) and Voice (24.82%).

The differences are small, so contact rate alone is not sufficient evidence for
large channel investment decisions.

## Risk and Delinquency

Payment success rates were very similar across risk segments:

- Medium: 70.81%
- High: 70.09%
- NPA: 69.85%
- Low: 69.80%

The 1–30 DPD bucket contained the largest outstanding balance and generated the
largest successful recovery amount.

## Data Quality

Important data-quality issues were identified rather than silently corrected.

Examples include:

- Duplicate payment/event records
- Missing borrower IDs
- Missing call agent IDs
- Agent identity conflicts
- Timestamp inconsistencies
- Account-status recording timestamps occurring before event timestamps
- Accounts where outstanding amount exceeded principal amount

These issues were preserved as documented data-quality findings where a reliable
correction could not be justified.

## Interpretation

The evidence supports the reported overall recovery rate of approximately 11%,
but does not support the stronger claim of a sustained 11% month-on-month
improvement.

The major operational opportunity appears to be improving conversion after
customer commitment. Only 20.67% of KEPT PTPs were associated with a successful
payment under the reconstructed chronological attribution logic.

## Limitations

The payment-to-PTP relationship is reconstructed using account and event timing
because payments do not contain a direct PTP identifier.

The analysis is observational and should not be interpreted as causal evidence
without a controlled experiment.

August is a partial month and should be excluded from direct full-month trend
comparisons.
