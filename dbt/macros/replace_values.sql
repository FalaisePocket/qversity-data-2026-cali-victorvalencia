{% macro replace_values(column_name, old_value, new_value) %}

    replace({{ column_name }}, '{{ old_value }}', '{{ new_value }}')

{% endmacro %}