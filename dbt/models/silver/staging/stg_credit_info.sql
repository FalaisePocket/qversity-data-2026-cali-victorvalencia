{{ config(materialized='view') }}

SELECT
    customer_id,

    (credit_info::jsonb ->> 'credit_score')::integer AS credit_score,
    credit_info::jsonb ->> 'currency' AS currency,
    (credit_info::jsonb ->> 'utilization_pct')::float AS utilization_pct,
    (credit_info::jsonb ->> 'total_limit')::float AS total_limit,
    (credit_info::jsonb ->> 'total_used')::float AS total_used,
    (credit_info::jsonb ->> 'num_credit_accounts')::integer AS num_credit_accounts,
    (credit_info::jsonb ->> 'oldest_account_age_months')::integer AS oldest_account_age_months,
    (credit_info::jsonb ->> 'late_payments_12m')::integer AS late_payments_12m,
    (credit_info::jsonb ->> 'inquiries_6m')::integer AS inquiries_6m,
    (credit_info::jsonb ->> 'bankruptcy_flag')::boolean AS bankruptcy_flag

FROM {{ source('silver_layer', 'stg_customer') }}
WHERE credit_info IS NOT NULL