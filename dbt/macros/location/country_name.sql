{% macro country_name(column_name) %}

CASE {{ column_name }}

    WHEN 'CO' THEN 'Colombia'
    WHEN 'AR' THEN 'Argentina'
    WHEN 'CL' THEN 'Chile'
    WHEN 'UY' THEN 'Uruguay'
    WHEN 'BR' THEN 'Brazil'
    WHEN 'PE' THEN 'Peru'
    WHEN 'MX' THEN 'Mexico'

    ELSE 'Unknown'

END

{% endmacro %}