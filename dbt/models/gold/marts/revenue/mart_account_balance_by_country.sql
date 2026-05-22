--answers 2 and 22
SELECT
    l.country_name,
    l.short_country,
    cur.currency_code,
    a.account_type,
    COUNT(DISTINCT a.account_id)                        AS num_accounts,
    COUNT(DISTINCT c.customer_id)                       AS num_customers,
    SUM(a.balance)                                      AS total_balance,
    AVG(a.balance)                                      AS avg_balance_per_account
FROM {{ ref('accounts') }} a
JOIN {{ ref('customer') }} c
    ON a.customer_id = c.customer_id
JOIN {{ ref('location') }} l
    ON c.location_id = l.location_id
JOIN {{ ref('currency') }} cur
    ON a.currency_id = cur.currency_id


GROUP BY
    l.country_name,
    l.short_country,
    a.account_type,
    cur.currency_code

ORDER BY
    l.country_name,
    cur.currency_code