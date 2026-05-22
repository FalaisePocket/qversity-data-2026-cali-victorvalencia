-- answer 20
{{ config(materialized='table') }}

/*
  Mobile App Adoption Rate by Customer Segment
  
  Joins customer dimension with digital_engagement to calculate:
  - Total customers per segment
  - Customers with mobile app registered
  - Adoption rate (%)
*/

WITH base AS (

    SELECT
        c.customer_id,
        s.customer_segment,
        de.mobile_app_registered

    FROM {{ ref('customer') }} c

    LEFT JOIN {{ ref('customer_segmentation') }} s
        ON c.segmentation_id = s.segmentation_id

    LEFT JOIN {{ ref('digital_engagement') }} de
        ON c.customer_id = de.customer_id

    WHERE s.customer_segment IS NOT NULL

)

SELECT
    customer_segment,

    COUNT(customer_id)                                              AS total_customers,

    COUNT(CASE WHEN mobile_app_registered = TRUE THEN 1 END)       AS mobile_app_users,

    ROUND(
        COUNT(CASE WHEN mobile_app_registered = TRUE THEN 1 END)
        * 100.0
        / NULLIF(COUNT(customer_id), 0),
        2
    )                                                               AS adoption_rate_pct

FROM base

GROUP BY customer_segment

ORDER BY adoption_rate_pct DESC