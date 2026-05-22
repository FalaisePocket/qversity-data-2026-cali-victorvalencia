--answer 9

{{ config(materialized='table') }}

WITH customer_segments AS (
    SELECT
        c.customer_id,
        -- Traemos el risk_bucket directamente desde la dimensión intermedia
        s.risk_bucket
    FROM {{ ref('customer') }} c
    LEFT JOIN {{ ref('customer_segmentation') }} s
        ON c.segmentation_id = s.segmentation_id
)

SELECT
    risk_bucket AS risk_segment,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0 / SUM(COUNT(DISTINCT customer_id)) OVER(), 
        2
    ) AS percentage_share
FROM customer_segments
WHERE risk_bucket IS NOT NULL
GROUP BY 1
ORDER BY 
    CASE risk_bucket
        WHEN 'low' THEN 1
        WHEN 'medium' THEN 2
        WHEN 'high' THEN 3
        WHEN 'critical' THEN 4
    END