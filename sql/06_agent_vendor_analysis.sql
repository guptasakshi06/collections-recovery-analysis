-- ============================================================
-- 06_agent_vendor_analysis.sql
-- Agent and vendor performance analysis
-- ============================================================


-- 1. Call outcomes by agent

SELECT
    agent_id,
    COUNT(*) AS total_calls,
    SUM(CASE
        WHEN call_status = 'ANSWERED' THEN 1
        ELSE 0
    END) AS answered_calls,
    ROUND(
        100.0 * SUM(CASE
            WHEN call_status = 'ANSWERED' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS answer_rate_percent
FROM calls
WHERE agent_id IS NOT NULL
GROUP BY agent_id
ORDER BY answer_rate_percent DESC
LIMIT 20;


-- 2. Call outcomes by vendor

SELECT
    vendor_id,
    COUNT(*) AS total_calls,
    SUM(CASE
        WHEN call_status = 'ANSWERED' THEN 1
        ELSE 0
    END) AS answered_calls,
    ROUND(
        100.0 * SUM(CASE
            WHEN call_status = 'ANSWERED' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS answer_rate_percent
FROM calls
WHERE vendor_id IS NOT NULL
GROUP BY vendor_id
ORDER BY answer_rate_percent DESC;


-- 3. Average call duration by vendor

SELECT
    vendor_id,
    COUNT(*) AS total_calls,
    ROUND(AVG(duration_sec), 2) AS avg_duration_sec
FROM calls
WHERE vendor_id IS NOT NULL
GROUP BY vendor_id
ORDER BY avg_duration_sec DESC;


-- 4. Agent session duration

SELECT
    agent_id,
    COUNT(*) AS sessions,
    ROUND(
        AVG(
            (julianday(logout_at) - julianday(login_at))
            * 86400
        ),
        2
    ) AS avg_session_seconds
FROM agent_sessions
GROUP BY agent_id
ORDER BY avg_session_seconds DESC
LIMIT 20;



-- 5. Agent performance with minimum call volume

SELECT
    agent_id,
    COUNT(*) AS total_calls,
    SUM(
        CASE
            WHEN call_status = 'ANSWERED' THEN 1
            ELSE 0
        END
    ) AS answered_calls,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN call_status = 'ANSWERED' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS answer_rate_percent
FROM calls
WHERE agent_id IS NOT NULL
GROUP BY agent_id
HAVING COUNT(*) >= 50
ORDER BY answer_rate_percent DESC;
