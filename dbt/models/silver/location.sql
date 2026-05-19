{{ config(materialized='table') }}

SELECT DISTINCT

    {{ dbt_utils.generate_surrogate_key([
        'city',
        'country'
    ]) }} AS location_id,

    {{ remove_spaces('city') }} AS city,
    country AS short_country,
    {{ country_name('country') }} AS country_name


FROM {{ source('silver_layer', 'stg_customer') }}