
  
    

  create  table "qversity"."public_gold"."revenue_per_customer_by_segmente__dbt_tmp"
  
  
    as
  
  (
    WITH revenue_per_customer AS (
    SELECT
        t.customer_id,
        cur.currency_code,
        SUM(t.amount) AS total_revenue
    FROM "qversity"."public_silver"."transactions" t
    JOIN "qversity"."public_silver"."currency" cur
        ON t.currency_id = cur.currency_id
    WHERE t.status = 'completed'
    GROUP BY
        t.customer_id,
        cur.currency_code
)

SELECT
    cs.customer_segment,
    r.currency_code,
    COUNT(DISTINCT c.customer_id)                           AS num_customers,
    ROUND(AVG(r.total_revenue)::NUMERIC, 2)                AS avg_revenue_per_customer,
    ROUND(SUM(r.total_revenue)::NUMERIC, 2)                AS total_revenue,
    ROUND(MIN(r.total_revenue)::NUMERIC, 2)                AS min_revenue,
    ROUND(MAX(r.total_revenue)::NUMERIC, 2)                AS max_revenue
FROM "qversity"."public_silver"."customer" c
JOIN revenue_per_customer r
    ON c.customer_id = r.customer_id
JOIN "qversity"."public_silver"."customer_segmentation" cs
    ON c.segmentation_id = cs.segmentation_id
GROUP BY
    cs.customer_segment,
    cs.status,
    cs.risk_bucket,
    r.currency_code
ORDER BY
    cs.customer_segment,
    r.currency_code,
    avg_revenue_per_customer DESC
  );
  