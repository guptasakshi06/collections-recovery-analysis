-- ============================================================
-- 09_account_month.sql
-- Golden analytical account-month table
-- ============================================================

DROP TABLE IF EXISTS account_month;

CREATE TABLE account_month AS

WITH months AS (
    SELECT DISTINCT month
    FROM payments
),

base AS (
    SELECT
        a.account_id,
        a.borrower_id,
        a.risk_segment,
        a.dpd,
        a.loan_type,
        m.month
    FROM accounts a
    CROSS JOIN months m
),

payment_metrics AS (
    SELECT
        account_id,
        month,
        COUNT(*) AS payment_count,
        SUM(amount) AS payment_amount,
        SUM(
            CASE
                WHEN payment_status = 'SUCCESS'
                THEN 1 ELSE 0
            END
        ) AS successful_payment_count,
        SUM(
            CASE
                WHEN payment_status = 'SUCCESS'
                THEN amount ELSE 0
            END
        ) AS successful_payment_amount
    FROM payments
    GROUP BY account_id, month
),

call_metrics AS (
    SELECT
        account_id,
        strftime('%Y-%m', event_at) AS month,
        COUNT(*) AS call_attempts,
        SUM(
            CASE
                WHEN call_status = 'ANSWERED'
                THEN 1 ELSE 0
            END
        ) AS answered_calls
    FROM calls
    GROUP BY account_id, strftime('%Y-%m', event_at)
),

ptp_metrics AS (
    SELECT
        account_id,
        strftime('%Y-%m', event_at) AS month,
        COUNT(*) AS ptp_count,
        SUM(
            CASE
                WHEN status = 'KEPT'
                THEN 1 ELSE 0
            END
        ) AS kept_ptp_count
    FROM promises_to_pay
    GROUP BY account_id, strftime('%Y-%m', event_at)
),

complaint_metrics AS (
    SELECT
        account_id,
        strftime('%Y-%m', event_at) AS month,
        COUNT(*) AS complaint_count
    FROM complaints
    GROUP BY account_id, strftime('%Y-%m', event_at)
)

SELECT
    b.account_id,
    b.borrower_id,
    b.month,
    b.risk_segment,
    b.dpd,
    b.loan_type,

    COALESCE(p.payment_count, 0) AS payment_count,
    COALESCE(p.payment_amount, 0) AS payment_amount,
    COALESCE(p.successful_payment_count, 0)
        AS successful_payment_count,
    COALESCE(p.successful_payment_amount, 0)
        AS successful_payment_amount,

    COALESCE(c.call_attempts, 0) AS call_attempts,
    COALESCE(c.answered_calls, 0) AS answered_calls,

    COALESCE(ptp.ptp_count, 0) AS ptp_count,
    COALESCE(ptp.kept_ptp_count, 0) AS kept_ptp_count,

    COALESCE(cm.complaint_count, 0) AS complaint_count

FROM base b

LEFT JOIN payment_metrics p
    ON b.account_id = p.account_id
   AND b.month = p.month

LEFT JOIN call_metrics c
    ON b.account_id = c.account_id
   AND b.month = c.month

LEFT JOIN ptp_metrics ptp
    ON b.account_id = ptp.account_id
   AND b.month = ptp.month

LEFT JOIN complaint_metrics cm
    ON b.account_id = cm.account_id
   AND b.month = cm.month;
