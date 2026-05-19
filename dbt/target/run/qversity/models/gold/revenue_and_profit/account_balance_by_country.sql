
  
    

  create  table "qversity"."public_gold"."account_balance_by_country__dbt_tmp"
  
  
    as
  
  (
    SELECT
    l.country_name,
    l.short_country,
    cur.currency_code,
    COUNT(DISTINCT a.account_id)                        AS num_accounts,
    COUNT(DISTINCT c.customer_id)                       AS num_customers,
    ROUND(SUM(a.balance)::numeric, 2)                   AS total_balance,
    ROUND(AVG(a.balance)::numeric, 2)                   AS avg_balance_per_account
FROM "qversity"."public_silver"."accounts" a
JOIN "qversity"."public_silver"."customer" c
    ON a.customer_id = c.customer_id
JOIN "qversity"."public_silver"."location" l
    ON c.location_id = l.location_id
JOIN "qversity"."public_silver"."currency" cur
    ON a.currency_id = cur.currency_id
GROUP BY
    l.country_name,
    l.short_country,
    cur.currency_code
ORDER BY
    l.country_name,
    cur.currency_code
  );
  