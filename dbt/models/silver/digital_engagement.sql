{{ config(materialized='table') }}
SELECT
    customer_id,
    mobile_app_registered,
    web_banking_registered,
    CAST(TO_CHAR({{ standardize_date('last_login_date') }}, 'YYYYMMDD') AS INT) AS last_login_date_id,
    avg_monthly_logins,
    preferred_channel,
    {{ empty_to_false('push_notifications') }} AS push_notifications,
    {{ empty_to_false('paperless_statements') }} AS paperless_statements
FROM {{ ref('stg_digital_engagement') }}
