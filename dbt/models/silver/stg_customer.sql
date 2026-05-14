{{ config(materialized='table') }}
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone_number,
    date_of_birth,
    gender,
    nationality,
    city,
    country,
    adress,
    lat,
    lon,
    registration_date,
    kyc_status,
    risk_score,
    customer_segment,
    relationship_manager,
    status

FROM {{ source('silver_layer', 'stg_customer') }}