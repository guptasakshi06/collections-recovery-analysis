-- ============================================================
-- 11_claim_test.sql
-- Test the business claim:
-- "Recovery has improved by 11% month-on-month"
-- ============================================================

WITH monthly AS (
    SELECT
        month,
        SUM(successful_payment_amount) AS recovery,
        SUM(payment_amount) AS total_payment_amount,
        SUM(successful_payment_count) AS successful_payments,
        SUM(payment_count) AS total_payments
    FROM account_month
    GROUP BY month
),

with_previous AS (
    SELECT
        month,
        recovery,
        successful_payments,
        total_payments,

        LAG(recovery) OVER (
            ORDER BY month
        ) AS previous_recovery

    FROM monthly
)

SELECT
    month,
    ROUND(recovery, 2) AS recovery,
    ROUND(previous_recovery, 2) AS previous_recovery,

    CASE
        WHEN previous_recovery IS NULL THEN NULL
        ELSE ROUND(
            100.0 * (recovery - previous_recovery)
            / previous_recovery,
            2
        )
    END AS recovery_mom_change_percent

FROM with_previous
ORDER BY month;


-- ------------------------------------------------------------
-- Recovery rate by month
-- ------------------------------------------------------------

WITH monthly AS (
    SELECT
        month,
        SUM(successful_payment_amount) AS successful_recovery,
        SUM(
            (SELECT SUM(principal_amount)
             FROM accounts)
        ) AS dummy
    FROM account_month
    GROUP BY month
)

SELECT
    month,
    ROUND(successful_recovery, 2) AS successful_recovery
FROM monthly
ORDER BY month;
