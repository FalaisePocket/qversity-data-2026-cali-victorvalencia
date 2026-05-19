-- models/marts/facts/fact_accounts.sql

{{ config(materialized='table') }}

SELECT
    a.account_id,

    {{ remove_spaces('a.account_type') }} AS account_type,

    currency_dim.currency_id,

    a.balance,
    a.credit_limit,
    a.interest_rate,

    CAST(
        TO_CHAR(
            {{ standardize_date('a.opened_date') }},
            'YYYYMMDD'
        ) AS INT
    ) AS opened_date_id,

    {{ lower_column('a.status') }} AS status,

    {{ normalize_na('a.branch_code') }} AS branch_code

FROM {{ source('silver_layer', 'stg_accounts') }} a

LEFT JOIN {{ ref('currency') }} currency_dim
    ON upper(trim(a.currency)) = currency_dim.currency_code