{% macro clamp_values(column_name, min_value, max_value) %}

    case
        when {{ column_name }} < {{ min_value }} then {{ min_value }}
        when {{ column_name }} > {{ max_value }} then {{ max_value }}
        else {{ column_name }}
    end

{% endmacro %}