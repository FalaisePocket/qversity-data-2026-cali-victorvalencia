-- models/marts/facts/fact_loans.sql

{{ config(materialized='table') }}

SELECT
    l.customer_id,
    l.loan_id,

    {{ lower_column('l.type') }} AS type,

    currency_dim.currency_id,

    l.principal,
    l.outstanding_balance,
    l.interest_rate,
    l.term_months,
    l.monthly_payment,

    CAST(
        TO_CHAR(
            {{ standardize_date('l.start_date') }},
            'YYYYMMDD'
        ) AS INT
    ) AS start_date_id,

    CAST(
        TO_CHAR(
            {{ standardize_date('l.end_date') }},
            'YYYYMMDD'
        ) AS INT
    ) AS end_date_id,

    {{ lower_column('l.status') }} AS status,

    l.days_past_due,

    {{ normalize_na('l.collateral_type') }} AS collateral_type

FROM {{ source('silver_layer', 'stg_loans') }} l

LEFT JOIN {{ ref('currency') }} currency_dim
    ON upper(trim(l.currency)) = currency_dim.currency_code