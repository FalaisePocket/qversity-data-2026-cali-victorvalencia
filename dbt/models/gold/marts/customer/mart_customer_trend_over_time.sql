--answer 12

{{ config(materialized='table') }}

WITH monthly_customers AS (

    SELECT
        d.year,
        d.month,
        d.short_month,
        d.month_name,

        COUNT(c.customer_id) AS new_customers

    FROM {{ ref('customer') }} c

    JOIN {{ ref('date') }} d
        ON c.registration_date_id = d.date_id

    GROUP BY
        d.year,
        d.month,
        d.short_month,
        d.month_name
)

SELECT
    year,
    month,
    month_name,
    new_customers,

    (100.0 *(new_customers- LAG(new_customers) OVER (ORDER BY year, month))/NULLIF(LAG(new_customers) OVER (ORDER BY year, month),0)) AS mom_pct_change

FROM monthly_customers

ORDER BY
    year,
    month