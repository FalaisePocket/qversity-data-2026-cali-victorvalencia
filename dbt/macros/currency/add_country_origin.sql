{% macro currency_from_country(country_column) %}

CASE UPPER(TRIM({{ country_column }}))

    WHEN 'UYU' THEN 'UY'
    WHEN 'CLP' THEN 'CL'
    WHEN 'COP' THEN 'CO'
    WHEN 'ARS' THEN 'AR'
    WHEN 'PEN' THEN 'PE'
    WHEN 'BRL' THEN 'BR'
    WHEN 'MXN' THEN 'MX'

    ELSE 'OTHER'

END

{% endmacro %}