-- answer 14

{{ config(materialized='table') }}

SELECT
    s.kyc_status,
    COUNT(c.customer_id) AS customer_count,
    ROUND(
        100.0 * COUNT(c.customer_id)
        / SUM(COUNT(c.customer_id)) OVER (),
        2
    ) AS pct_total
FROM {{ ref('customer') }} c
JOIN {{ ref('customer_segmentation') }} s
    ON c.segmentation_id = s.segmentation_id
GROUP BY
    s.kyc_status
ORDER BY
    customer_count DESC