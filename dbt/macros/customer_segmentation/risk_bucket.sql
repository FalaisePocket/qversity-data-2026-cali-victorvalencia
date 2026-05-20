{% macro risk_bucket(column_name) %}

CASE
    WHEN {{ column_name }} < 20 THEN 'Very Low'
    WHEN {{ column_name }} < 40 THEN 'Low'
    WHEN {{ column_name }} < 60 THEN 'Medium'
    WHEN {{ column_name }} < 80 THEN 'High'
    ELSE 'Very High'
END

{% endmacro %}