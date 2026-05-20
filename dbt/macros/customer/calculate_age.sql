{% macro calculate_age(column_name) %}

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        {{ standardize_date(column_name) }}
    )
)

{% endmacro %}