{{ config(materialized='table') }}

WITH cleaned AS (

    SELECT

        {{ translate_customer_segment(lower_column('customer_segment')) }}
            AS customer_segment,

        {{ translate_status(lower_column('status')) }}
            AS status,

        {{ lower_column('kyc_status') }}
            AS kyc_status,

        {{ risk_bucket('risk_score') }}
            AS risk_bucket

    FROM {{ source('silver_layer', 'stg_customer') }}

)

SELECT DISTINCT

    {{ dbt_utils.generate_surrogate_key([
        "customer_segment",
        "status",
        "kyc_status",
        "risk_bucket"
    ]) }} AS segmentation_id,

    customer_segment,
    status,
    kyc_status,
    risk_bucket

FROM cleaned