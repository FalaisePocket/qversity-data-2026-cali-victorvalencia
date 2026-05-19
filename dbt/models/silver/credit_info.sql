-- models/marts/facts/fact_credit_info.sql

{{ config(materialized='table') }}

SELECT
    c.customer_id,

    {{ clamp_values('c.credit_score', 300, 850 ) }} AS credit_score,

    currency_dim.currency_id,

    {{ clamp_values('c.utilization_pct',0.00,100.00) }} AS utilization_pct,

    c.total_limit,
    c.total_used,
    c.num_credit_accounts,
    c.oldest_account_age_months,
    c.late_payments_12m,
    c.inquiries_6m,

    {{ empty_to_false('c.bankruptcy_flag') }} AS bankruptcy_flag

FROM {{ ref('stg_credit_info') }} c

LEFT JOIN {{ ref('currency') }} currency_dim
    ON upper(trim(c.currency)) = currency_dim.currency_code