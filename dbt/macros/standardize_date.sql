{% macro standardize_date(column_name) %}

CASE

    -- YYYYMMDD (20200609)
    WHEN {{ column_name }} ~ '^\d{8}$' THEN
        to_date({{ column_name }}, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN {{ column_name }} ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date({{ column_name }}, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN {{ column_name }} ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date({{ column_name }}, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN {{ column_name }} ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date({{ column_name }}, 'DD/MM/YYYY')

    ELSE NULL

END

{% endmacro %}