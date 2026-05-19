{% macro calculate_age_bucket(column_name) %}

CASE
    WHEN {{ calculate_age(column_name) }} < 18
        THEN 'Under 18'

    WHEN {{ calculate_age(column_name) }} BETWEEN 18 AND 24
        THEN '18-24'

    WHEN {{ calculate_age(column_name) }} BETWEEN 25 AND 34
        THEN '25-34'

    WHEN {{ calculate_age(column_name) }} BETWEEN 35 AND 44
        THEN '35-44'

    WHEN {{ calculate_age(column_name) }} BETWEEN 45 AND 54
        THEN '45-54'

    WHEN {{ calculate_age(column_name) }} BETWEEN 55 AND 64
        THEN '55-64'

    ELSE '65+'
END

{% endmacro %}