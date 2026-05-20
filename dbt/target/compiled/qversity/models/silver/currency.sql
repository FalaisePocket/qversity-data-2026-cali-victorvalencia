

WITH all_currencies AS (

    SELECT currency
    FROM "qversity"."silver"."stg_transactions"

    UNION

    SELECT currency
    FROM "qversity"."silver"."stg_loans"

    UNION

    SELECT currency
    FROM "qversity"."public_silver"."stg_credit_info"

    UNION

    SELECT currency
    FROM "qversity"."silver"."stg_accounts"

),

cleaned AS (

    SELECT DISTINCT
        upper(trim(currency)) AS currency
    FROM all_currencies
    WHERE currency IS NOT NULL
)

SELECT
    md5(cast(coalesce(cast(currency as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS currency_id,
    currency AS currency_code,
    

CASE UPPER(TRIM(currency))

    WHEN 'UYU' THEN 'UY'
    WHEN 'CLP' THEN 'CL'
    WHEN 'COP' THEN 'CO'
    WHEN 'ARS' THEN 'AR'
    WHEN 'PEN' THEN 'PE'
    WHEN 'BRL' THEN 'BR'
    WHEN 'MXN' THEN 'MX'

    ELSE 'OTHER'

END

 AS currency_from_country

FROM cleaned