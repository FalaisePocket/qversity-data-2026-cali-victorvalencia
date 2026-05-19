{{ config(materialized='table') }}
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    {{ add_country_code(clean_phone('phone_number'), 'c.country') }} AS phone_number,
    CAST(TO_CHAR({{ standardize_date('date_of_birth') }}, 'YYYYMMDD') AS INT) AS date_of_birth_id,
    {{ normalize_na('gender') }} AS gender,
    nationality,
    l.location_id,
    address,
    {{ clamp_values('lat', -90,90) }} AS lat,
    {{ clamp_values('lon', -180, 90 ) }} AS lon,
    CAST(TO_CHAR({{ standardize_date('registration_date') }}, 'YYYYMMDD') AS INT) AS registration_date_id,
    {{ lower_column('kyc_status') }} AS kyc_status,
    {{ clamp_values('risk_score', 0, 100) }} AS risk_score,
    {{ translate_customer_segment(lower_column('customer_segment')) }} AS customer_segment,
    {{ normalize_na('relationship_manager') }} AS relationship_manager,
    {{ translate_status(lower_column('status')) }} AS status

FROM {{ source('silver_layer', 'stg_customer') }} c

LEFT JOIN {{ ref('location') }} l
ON
    {{ remove_spaces('c.city') }} = l.city
    AND c.country = l.short_country
