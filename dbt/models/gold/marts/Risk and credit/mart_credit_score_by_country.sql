--answer 6

{{ config(materialized='table') }}

WITH base AS (
    SELECT
        l.country_name,
        l.short_country,
        ci.credit_score
    FROM {{ ref('credit_info') }} ci
    LEFT JOIN {{ ref('customer') }} c
        ON ci.customer_id = c.customer_id
    LEFT JOIN {{ ref('location') }} l
        ON c.location_id = l.location_id
    WHERE ci.credit_score IS NOT NULL
)

SELECT
    country_name,
    short_country,

    COUNT(*)                                    AS total_customers,

    -- Estadísticos descriptivos
    ROUND(AVG(credit_score), 2)                 AS avg_credit_score,
    PERCENTILE_CONT(0.50) WITHIN GROUP
        (ORDER BY credit_score)                 AS median_credit_score,
    MIN(credit_score)                           AS min_credit_score,
    MAX(credit_score)                           AS max_credit_score,
    ROUND(STDDEV(credit_score), 2)              AS stddev_credit_score,

    -- Distribución por buckets (rango 300–850 según el clamp en credit_info)
    COUNT(*) FILTER (WHERE credit_score < 580)  AS poor,        -- 300–579
    COUNT(*) FILTER (WHERE credit_score BETWEEN 580 AND 669) AS fair,   -- 580–669
    COUNT(*) FILTER (WHERE credit_score BETWEEN 670 AND 739) AS good,   -- 670–739
    COUNT(*) FILTER (WHERE credit_score BETWEEN 740 AND 799) AS very_good, -- 740–799
    COUNT(*) FILTER (WHERE credit_score >= 800)  AS exceptional  -- 800–850

FROM base

GROUP BY country_name, short_country
ORDER BY country_name