--answer 18
{{ config(materialized='table') }}

SELECT
    channel,

    COUNT(*)                                                        AS total_transactions,
    COUNT(*) FILTER (WHERE status = 'failed')                       AS failed_transactions,

    ROUND(
        COUNT(*) FILTER (WHERE status = 'failed') * 100.0 / COUNT(*),
        2
    )                                                               AS failed_rate_pct

FROM {{ ref('transactions') }}

WHERE channel IS NOT NULL

GROUP BY channel

ORDER BY failed_rate_pct DESC