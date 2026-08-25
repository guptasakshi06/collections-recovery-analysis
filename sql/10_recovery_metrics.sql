-- ============================================================
-- 10_recovery_metrics.sql
-- Core recovery metrics
-- ============================================================


-- 1. Monthly recovery

SELECT
    month,
    COUNT(DISTINCT account_id) AS accounts,
    SUM(payment_count) AS payments,
    SUM(successful_payment_count) AS successful_payments,
    ROUND(SUM(successful_payment_amount), 2)
        AS successful_recovery,
    ROUND(
        100.0 * SUM(successful_payment_count)
        / NULLIF(SUM(payment_count), 0),
        2
    ) AS payment_success_rate
FROM account_month
GROUP BY month
ORDER BY month;


-- 2. Overall recovery

SELECT
    COUNT(DISTINCT account_id) AS accounts,
    SUM(successful_payment_count) AS successful_payments,
    ROUND(SUM(successful_payment_amount), 2)
        AS successful_recovery,
    ROUND(
        SUM(successful_payment_amount)
        / COUNT(DISTINCT account_id),
        2
    ) AS recovery_per_account
FROM account_month;


-- 3. Recovery by risk

SELECT
    risk_segment,
    COUNT(DISTINCT account_id) AS accounts,
    ROUND(SUM(successful_payment_amount), 2)
        AS successful_recovery,
    ROUND(
        SUM(successful_payment_amount)
        / COUNT(DISTINCT account_id),
        2
    ) AS recovery_per_account
FROM account_month
GROUP BY risk_segment
ORDER BY successful_recovery DESC;


-- 4. Reported 11% benchmark comparison
--
-- Benchmark = 11% of total principal.
-- Our reconstructed recovery = successful payments.

WITH totals AS (
    SELECT
        (SELECT SUM(principal_amount)
         FROM accounts) AS total_principal,

        (SELECT SUM(amount)
         FROM payments
         WHERE payment_status = 'SUCCESS')
         AS actual_recovery
)

SELECT
    ROUND(total_principal, 2) AS total_principal,
    ROUND(actual_recovery, 2) AS actual_recovery,

    ROUND(
        100.0 * actual_recovery / total_principal,
        2
    ) AS reconstructed_recovery_rate,

    ROUND(
        11.0,
        2
    ) AS reported_recovery_rate,

    ROUND(
        100.0 * actual_recovery / total_principal - 11.0,
        2
    ) AS difference_percentage_points

FROM totals;
