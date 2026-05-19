

SELECT DISTINCT

    md5(cast(coalesce(cast(city as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(country as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS location_id,

    

    trim(city)

 AS city,
    country AS short_country,
    

CASE country

    WHEN 'CO' THEN 'Colombia'
    WHEN 'AR' THEN 'Argentina'
    WHEN 'CL' THEN 'Chile'
    WHEN 'UY' THEN 'Uruguay'
    WHEN 'BR' THEN 'Brazil'
    WHEN 'PE' THEN 'Peru'
    WHEN 'MX' THEN 'Mexico'

    ELSE 'Unknown'

END

 AS country_name


FROM "qversity"."silver"."stg_customer"