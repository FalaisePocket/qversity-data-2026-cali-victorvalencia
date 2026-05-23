-- answer 11

SELECT
    s.customer_segment,
    c.age_bucket,
    COUNT(*) AS customer_count,
    ROUND(AVG(c.age), 1) AS avg_age,
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY s.customer_segment) AS pct_within_segment
FROM {{ ref('customer') }} c
JOIN {{ ref('customer_segmentation') }} s
    ON c.segmentation_id = s.segmentation_id
GROUP BY
    s.customer_segment,
    c.age_bucket
ORDER BY
    s.customer_segment,
    c.age_bucket