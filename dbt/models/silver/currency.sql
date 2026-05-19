{{ config(materialized='table') }}

WITH all_currencies AS (

    SELECT currency
    FROM {{ source('silver_layer', 'stg_transactions') }}

    UNION

    SELECT currency
    FROM {{ source('silver_layer', 'stg_loans') }}

    UNION

    SELECT currency
    FROM {{ ref('stg_credit_info') }}

    UNION

    SELECT currency
    FROM {{ source('silver_layer', 'stg_accounts') }}

),

cleaned AS (

    SELECT DISTINCT
        upper(trim(currency)) AS currency
    FROM all_currencies
    WHERE currency IS NOT NULL
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['currency']) }} AS currency_id,
    currency AS currency_code,
    {{ currency_from_country('currency') }} AS currency_from_country

FROM cleaned