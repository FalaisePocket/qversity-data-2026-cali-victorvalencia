--answer 23

{{ config(materialized='table') }}

WITH base AS (

    SELECT
        type,
        status,
        outstanding_balance

    FROM {{ ref('loans') }}

    WHERE outstanding_balance IS NOT NULL

),

aggregated AS (

    SELECT
        type,
        status,
        COUNT(*)                        AS num_loans,
        SUM(outstanding_balance)        AS total_outstanding_balance,
        AVG(outstanding_balance)        AS avg_outstanding_balance,
        MIN(outstanding_balance)        AS min_outstanding_balance,
        MAX(outstanding_balance)        AS max_outstanding_balance

    FROM base

    GROUP BY
        type,
        status

),

totals AS (

    SELECT SUM(outstanding_balance) AS grand_total_outstanding_balance
    FROM base

)

SELECT
    a.type,
    a.status,
    a.num_loans,
    a.total_outstanding_balance,
    a.avg_outstanding_balance,
    a.min_outstanding_balance,
    a.max_outstanding_balance,

    -- Participation percentage of each type+status combination over total portfolio
    
    100.0 * a.total_outstanding_balance / NULLIF(t.grand_total_outstanding_balance, 0) AS pct_of_total_portfolio

FROM aggregated a
CROSS JOIN totals t

ORDER BY
    a.type,
    a.status