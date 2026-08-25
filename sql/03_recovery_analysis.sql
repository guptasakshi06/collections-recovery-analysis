-- ============================================================
-- 03_recovery_analysis.sql
-- Payment and recovery analysis
-- ============================================================


-- 1. Overall payment status distribution
SELECT
    payment_status,
    COUNT(*) AS payment_count,
    ROUND(SUM(amount), 2) AS total_amount
FROM payments
GROUP BY payment_status
ORDER BY total_amount DESC;


-- 2. Successful recovery
SELECT
    COUNT(*) AS successful_payments,
    ROUND(SUM(amount), 2) AS successful_recovery_amount
FROM payments
WHERE payment_status = 'SUCCESS';


-- 3. Failed payment amount
SELECT
    COUNT(*) AS failed_payments,
    ROUND(SUM(amount), 2) AS failed_payment_amount
FROM payments
WHERE payment_status = 'FAILED';


-- 4. Pending payment amount
SELECT
    COUNT(*) AS pending_payments,
    ROUND(SUM(amount), 2) AS pending_payment_amount
FROM payments
WHERE payment_status = 'PENDING';


-- 5. Reversed payment amount
SELECT
    COUNT(*) AS reversed_payments,
    ROUND(SUM(amount), 2) AS reversed_payment_amount
FROM payments
WHERE payment_status = 'REVERSED';


-- 6. Recovery rate by payment count
SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN payment_status = 'SUCCESS' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS recovery_rate_percent
FROM payments;
