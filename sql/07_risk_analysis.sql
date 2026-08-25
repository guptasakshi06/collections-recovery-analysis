-- ============================================================
-- 07_risk_analysis.sql
-- Account risk and outstanding balance analysis
-- ============================================================


-- 1. Accounts by risk segment

SELECT
    risk_segment,
    COUNT(*) AS account_count,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding,
    ROUND(AVG(outstanding_amount), 2) AS avg_outstanding,
    ROUND(AVG(dpd), 2) AS avg_dpd
FROM accounts
GROUP BY risk_segment
ORDER BY total_outstanding DESC;


-- 2. Accounts by DPD bucket

SELECT
    CASE
        WHEN dpd = 0 THEN '0'
        WHEN dpd BETWEEN 1 AND 30 THEN '1-30'
        WHEN dpd BETWEEN 31 AND 60 THEN '31-60'
        WHEN dpd BETWEEN 61 AND 90 THEN '61-90'
        ELSE '90+'
    END AS dpd_bucket,
    COUNT(*) AS account_count,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding,
    ROUND(AVG(outstanding_amount), 2) AS avg_outstanding
FROM accounts
GROUP BY dpd_bucket
ORDER BY
    CASE dpd_bucket
        WHEN '0' THEN 1
        WHEN '1-30' THEN 2
        WHEN '31-60' THEN 3
        WHEN '61-90' THEN 4
        WHEN '90+' THEN 5
    END;


-- 3. Accounts by loan type

SELECT
    loan_type,
    COUNT(*) AS account_count,
    ROUND(SUM(principal_amount), 2) AS total_principal,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding,
    ROUND(AVG(dpd), 2) AS avg_dpd
FROM accounts
GROUP BY loan_type
ORDER BY total_outstanding DESC;


-- 4. High-risk accounts with large outstanding balances

SELECT
    account_id,
    borrower_id,
    risk_segment,
    dpd,
    loan_type,
    ROUND(principal_amount, 2) AS principal_amount,
    ROUND(outstanding_amount, 2) AS outstanding_amount
FROM accounts
WHERE risk_segment IN ('HIGH', 'NPA')
ORDER BY outstanding_amount DESC
LIMIT 20;
