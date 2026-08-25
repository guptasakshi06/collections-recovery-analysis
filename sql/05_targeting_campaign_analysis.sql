-- ============================================================
-- 05_targeting_campaign_analysis.sql
-- Campaign and collection targeting analysis
-- ============================================================


-- 1. Targeting performance by recommended channel

SELECT
    recommended_channel,
    COUNT(*) AS targets,
    SUM(CASE
        WHEN status = 'CONTACTED' THEN 1
        ELSE 0
    END) AS contacted,
    ROUND(
        100.0 * SUM(CASE
            WHEN status = 'CONTACTED' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS contact_rate_percent
FROM daily_targeting
GROUP BY recommended_channel
ORDER BY contact_rate_percent DESC;


-- 2. Targeting performance by priority

SELECT
    priority,
    COUNT(*) AS targets,
    SUM(CASE
        WHEN status = 'CONTACTED' THEN 1
        ELSE 0
    END) AS contacted,
    ROUND(
        100.0 * SUM(CASE
            WHEN status = 'CONTACTED' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS contact_rate_percent
FROM daily_targeting
GROUP BY priority
ORDER BY priority;


-- 3. Campaign distribution by channel

SELECT
    channel,
    COUNT(*) AS campaign_count
FROM campaigns
GROUP BY channel
ORDER BY campaign_count DESC;


-- 4. Targeting volume by campaign

SELECT
    campaign_id,
    COUNT(*) AS target_count
FROM daily_targeting
GROUP BY campaign_id
ORDER BY target_count DESC
LIMIT 10;


-- 5. Targeting status distribution

SELECT
    status,
    COUNT(*) AS target_count,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM daily_targeting),
        2
    ) AS percentage
FROM daily_targeting
GROUP BY status
ORDER BY target_count DESC;
