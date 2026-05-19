{% macro remove_spaces(column_name) %}

    trim({{ column_name }})

{% endmacro %}