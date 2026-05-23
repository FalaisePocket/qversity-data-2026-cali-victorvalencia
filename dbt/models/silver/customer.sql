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
    s.segmentation_id,
    {{ normalize_na('relationship_manager') }} AS relationship_manager,

    {{ calculate_age('date_of_birth') }} AS age,
    {{ calculate_age_bucket('date_of_birth') }} AS age_bucket,
    {{ calculate_age('registration_date') }} AS tenure_years,
    {{ calculate_tenure_bucket('registration_date') }} AS tenure_bucket

FROM {{ source('silver_layer', 'stg_customer') }} c

LEFT JOIN {{ ref('location') }} l
ON 
    {{ normalize_city(remove_spaces('c.city')) }} = {{ normalize_city('l.city') }}
    
    AND c.country = l.short_country

LEFT JOIN {{ ref('customer_segmentation') }} s
ON
    {{ translate_customer_segment(lower_column('c.customer_segment')) }}
        = s.customer_segment

    AND {{ translate_status(lower_column('c.status')) }}
        = s.status

    AND {{ lower_column('c.kyc_status') }}
        = s.kyc_status

    AND {{ risk_bucket('c.risk_score') }}
        = s.risk_bucket
WHERE c.email IS NOT NULL