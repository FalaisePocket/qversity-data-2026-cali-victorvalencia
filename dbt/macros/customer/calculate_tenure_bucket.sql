{% macro calculate_tenure_bucket(column_name) %}

CASE
    WHEN {{ calculate_age(column_name) }} < 1
        THEN '<1 year'

    WHEN {{ calculate_age(column_name) }} BETWEEN 1 AND 2
        THEN '1-2 years'

    WHEN {{ calculate_age(column_name) }} BETWEEN 3 AND 5
        THEN '3-5 years'

    WHEN {{ calculate_age(column_name) }} BETWEEN 6 AND 10
        THEN '6-10 years'

    ELSE '10+ years'
END

{% endmacro %}