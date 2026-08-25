.headers on
.mode csv

.output ../dashboards/monthly_recovery.csv

SELECT
    month,
    ROUND(SUM(successful_payment_amount), 2) AS successful_recovery,
    SUM(successful_payment_count) AS successful_payments,
    SUM(payment_count) AS total_payments,
    ROUND(
        100.0 * SUM(successful_payment_count)
        / NULLIF(SUM(payment_count), 0),
        2
    ) AS payment_success_rate
FROM account_month
GROUP BY month
ORDER BY month;

.output stdout
