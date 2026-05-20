{% macro clean_phone(column_name) %}

    regexp_replace({{ column_name }}, '[\-\(\)\s]', '', 'g')

{% endmacro %}s