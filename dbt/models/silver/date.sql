{{ config(materialized='table') }}

WITH all_dates AS (
    SELECT {{ standardize_date('opened_date') }} AS date_day FROM {{ source('silver_layer', 'stg_accounts') }}
    UNION
    SELECT {{ standardize_date('date_of_birth') }} AS date_day FROM {{ source('silver_layer', 'stg_customer') }}
    UNION
    SELECT {{ standardize_date('registration_date') }} AS date_day FROM {{ source('silver_layer', 'stg_customer') }}
    UNION
    SELECT {{ standardize_date('last_login_date') }} AS date_day FROM {{ ref('stg_digital_engagement') }}
    UNION
    SELECT {{ standardize_date('start_date') }} AS date_day FROM {{ source('silver_layer', 'stg_loans') }}
    UNION
    SELECT {{ standardize_date('end_date') }} AS date_day FROM {{ source('silver_layer', 'stg_loans') }}
    UNION
    SELECT {{ standardize_date('date') }} AS date_day FROM {{ source('silver_layer', 'stg_transactions') }}
),

unique_dates AS (
    SELECT DISTINCT date_day 
    FROM all_dates 
    WHERE date_day IS NOT NULL
)

SELECT
    -- El ID/FK puede ser la misma fecha en formato entero (YYYYMMDD) o un hash. El formato entero es estándar y muy eficiente.
    CAST(TO_CHAR(date_day, 'YYYYMMDD') AS INT) AS date_id,
    date_day AS full_date,
    EXTRACT(YEAR FROM date_day) AS year,
    EXTRACT(MONTH FROM date_day) AS month,
    EXTRACT(DAY FROM date_day) AS day,
    EXTRACT(QUARTER FROM date_day) AS quarter,
    
    TO_CHAR(date_day, 'Mon') AS short_month,
    TO_CHAR(date_day, 'FMMonth') AS month_name,

    TO_CHAR(date_day, 'Dy') AS short_day_name,
    TO_CHAR(date_day, 'FMDay') AS day_name


FROM unique_dates





