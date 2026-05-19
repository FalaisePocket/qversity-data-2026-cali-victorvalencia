{% macro empty_to_false(column_name) %}

    CASE
        WHEN {{ column_name }} IS NULL
             OR trim({{ column_name }}::text) = ''
        THEN false
        ELSE {{ column_name }}
    END

{% endmacro %}