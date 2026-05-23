--answer 13

{{ config(materialized='table') }}

WITH status_counts AS (

    SELECT
        s.status,
        COUNT(c.customer_id) AS customer_count

    FROM {{ ref('customer') }} c

    JOIN {{ ref('customer_segmentation') }} s
        ON c.segmentation_id = s.segmentation_id

    GROUP BY
        s.status
)

SELECT
    status,
    customer_count,

    
    (100.0 * customer_count / SUM(customer_count) OVER ()) AS pct_total

FROM status_counts

ORDER BY
    customer_count DESC