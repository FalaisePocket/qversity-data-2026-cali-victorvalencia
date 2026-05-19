WITH cleaned AS (

    SELECT DISTINCT
        {{ normalize_city(remove_spaces('city')) }} AS city,
        country AS short_country,
        {{ country_name('country') }} AS country_name

    FROM {{ source('silver_layer', 'stg_customer') }}

)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'city',
        'short_country'
    ]) }} AS location_id,
    city,
    short_country,
    country_name

FROM cleaned