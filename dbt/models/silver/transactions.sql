-- models/marts/facts/fact_transactions.sql

{{ config(materialized='table') }}

SELECT
    t.customer_id,
    t.transaction_id,
    t.account_id,

    CAST(
        TO_CHAR(
            {{ standardize_date('t.date') }},
            'YYYYMMDD'
        ) AS INT
    ) AS date_id,

    t.amount,

    currency_dim.currency_id,

    {{ translate_transactions_type(lower_column('t.type')) }} AS type,

    {{ normalize_na(remove_spaces('t.category')) }} AS category,

    {{ normalize_na('t.merchant') }} AS merchant,

    t.channel,

    {{ lower_column('t.status') }} AS status,

    t.description

FROM {{ source('silver_layer', 'stg_transactions') }} t

LEFT JOIN {{ ref('currency') }} currency_dim
    ON upper(trim(t.currency)) = currency_dim.currency_code