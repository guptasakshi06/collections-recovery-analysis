-- ============================================================
-- 04_ptp_analysis.sql
-- Promise-to-Pay and recovery analysis
-- ============================================================


-- 1. PTP status distribution

SELECT
    status,
    COUNT(*) AS ptp_count
FROM promises_to_pay
GROUP BY status
ORDER BY ptp_count DESC;


-- 2. Payments matched to the most recent PTP
--
-- A payment is matched to the latest PTP for the same account
-- that occurred before or at the payment event time.

WITH payment_ptp AS (
    SELECT
        p.payment_id,
        p.account_id,
        p.event_at AS payment_event_at,
        p.amount,
        p.payment_status,
        ptp.ptp_id,
        ptp.event_at AS ptp_event_at,
        ptp.promised_amount,
        ptp.status AS ptp_status,
        ROW_NUMBER() OVER (
            PARTITION BY p.payment_id
            ORDER BY ptp.event_at DESC
        ) AS rn
    FROM payments p
    JOIN promises_to_pay ptp
        ON p.account_id = ptp.account_id
       AND ptp.event_at <= p.event_at
)

SELECT
    COUNT(*) AS matched_payments
FROM payment_ptp
WHERE rn = 1;


-- 3. Payment outcomes after KEPT PTP

WITH payment_ptp AS (
    SELECT
        p.payment_id,
        p.amount,
        p.payment_status,
        ptp.ptp_id,
        ptp.status AS ptp_status,
        ROW_NUMBER() OVER (
            PARTITION BY p.payment_id
            ORDER BY ptp.event_at DESC
        ) AS rn
    FROM payments p
    JOIN promises_to_pay ptp
        ON p.account_id = ptp.account_id
       AND ptp.event_at <= p.event_at
)

SELECT
    payment_status,
    COUNT(*) AS payment_count,
    ROUND(SUM(amount), 2) AS total_amount
FROM payment_ptp
WHERE rn = 1
  AND ptp_status = 'KEPT'
GROUP BY payment_status
ORDER BY payment_count DESC;


-- 4. Successful recovery after KEPT PTP

WITH payment_ptp AS (
    SELECT
        p.payment_id,
        p.amount,
        p.payment_status,
        ptp.ptp_id,
        ptp.status AS ptp_status,
        ROW_NUMBER() OVER (
            PARTITION BY p.payment_id
            ORDER BY ptp.event_at DESC
        ) AS rn
    FROM payments p
    JOIN promises_to_pay ptp
        ON p.account_id = ptp.account_id
       AND ptp.event_at <= p.event_at
)

SELECT
    COUNT(*) AS successful_payments,
    ROUND(SUM(amount), 2) AS recovered_amount
FROM payment_ptp
WHERE rn = 1
  AND ptp_status = 'KEPT'
  AND payment_status = 'SUCCESS';


-- 5. Number of KEPT PTPs

SELECT
    COUNT(*) AS kept_ptps
FROM promises_to_pay
WHERE status = 'KEPT';


-- 6. Unique KEPT PTPs that resulted in a successful payment

WITH payment_ptp AS (
    SELECT
        p.payment_id,
        p.payment_status,
        ptp.ptp_id,
        ptp.status AS ptp_status,
        ROW_NUMBER() OVER (
            PARTITION BY p.payment_id
            ORDER BY ptp.event_at DESC
        ) AS rn
    FROM payments p
    JOIN promises_to_pay ptp
        ON p.account_id = ptp.account_id
       AND ptp.event_at <= p.event_at
),

successful_kept_ptps AS (
    SELECT DISTINCT
        ptp_id
    FROM payment_ptp
    WHERE rn = 1
      AND ptp_status = 'KEPT'
      AND payment_status = 'SUCCESS'
)

SELECT
    COUNT(*) AS kept_ptps_with_successful_payment,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*)
         FROM promises_to_pay
         WHERE status = 'KEPT'),
        2
    ) AS ptp_conversion_rate_percent
FROM successful_kept_ptps;
