-- answer 1 and 3
{{ config(materialized='table') }}

SELECT
    cs.customer_segment,
    cur.currency_code,
    t.channel,
    
    COUNT(DISTINCT c.customer_id)                                                AS total_customers,
    COUNT(t.transaction_id)                                                      AS total_transactions,
    
    SUM(t.amount * a.interest_rate)                                              AS total_revenue,
    
    SUM(t.amount * a.interest_rate)
        / NULLIF(COUNT(DISTINCT c.customer_id), 0)                               AS avg_revenue_per_customer

FROM {{ ref('transactions') }} t

JOIN {{ ref('accounts') }} a
    ON t.account_id = a.account_id

JOIN {{ ref('customer') }} c
    ON t.customer_id = c.customer_id

JOIN {{ ref('customer_segmentation') }} cs
    ON c.segmentation_id = cs.segmentation_id

JOIN {{ ref('currency') }} cur
    ON t.currency_id = cur.currency_id

WHERE t.status = 'completed'

GROUP BY
    cs.customer_segment,
    cur.currency_code,
    t.channel

ORDER BY
    cs.customer_segment,
    total_revenue DESC