-- ============================================================
-- 08_recovery_by_risk.sql
-- Recovery performance by account risk segment
-- ============================================================


-- 1. Payment performance by risk segment

SELECT
    a.risk_segment,
    COUNT(p.payment_id) AS total_payments,

    SUM(
        CASE
            WHEN p.payment_status = 'SUCCESS'
            THEN 1
            ELSE 0
        END
    ) AS successful_payments,

    ROUND(
        SUM(
            CASE
                WHEN p.payment_status = 'SUCCESS'
                THEN p.amount
                ELSE 0
            END
        ),
        2
    ) AS successful_recovery_amount,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN p.payment_status = 'SUCCESS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(p.payment_id),
        2
    ) AS success_rate_percent

FROM accounts a
JOIN payments p
    ON a.account_id = p.account_id

GROUP BY a.risk_segment

ORDER BY success_rate_percent DESC;


-- 2. Recovery by DPD bucket

SELECT
    CASE
        WHEN a.dpd = 0 THEN '0'
        WHEN a.dpd BETWEEN 1 AND 30 THEN '1-30'
        WHEN a.dpd BETWEEN 31 AND 60 THEN '31-60'
        WHEN a.dpd BETWEEN 61 AND 90 THEN '61-90'
        ELSE '90+'
    END AS dpd_bucket,

    COUNT(p.payment_id) AS total_payments,

    SUM(
        CASE
            WHEN p.payment_status = 'SUCCESS'
            THEN 1
            ELSE 0
        END
    ) AS successful_payments,

    ROUND(
        SUM(
            CASE
                WHEN p.payment_status = 'SUCCESS'
                THEN p.amount
                ELSE 0
            END
        ),
        2
    ) AS successful_recovery_amount,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN p.payment_status = 'SUCCESS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(p.payment_id),
        2
    ) AS success_rate_percent

FROM accounts a
JOIN payments p
    ON a.account_id = p.account_id

GROUP BY dpd_bucket

ORDER BY
    CASE dpd_bucket
        WHEN '0' THEN 1
        WHEN '1-30' THEN 2
        WHEN '31-60' THEN 3
        WHEN '61-90' THEN 4
        WHEN '90+' THEN 5
    END;
