-- ============================================================
-- 02_data_quality.sql
-- Data quality checks for the collections analytics database
-- ============================================================


-- 1. Missing borrower IDs in accounts
SELECT
    COUNT(*) AS missing_borrower_ids
FROM accounts
WHERE borrower_id IS NULL;


-- 2. Accounts where outstanding amount exceeds principal
SELECT
    COUNT(*) AS outstanding_gt_principal
FROM accounts
WHERE outstanding_amount > principal_amount;


-- 3. Missing agent IDs in calls
SELECT
    COUNT(*) AS missing_agent_ids
FROM calls
WHERE agent_id IS NULL;
