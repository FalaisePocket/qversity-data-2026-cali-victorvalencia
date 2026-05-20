{% macro normalize_na(column_name) %}

    case
        when {{ column_name }} is null then 'N/A'
        when trim({{ column_name }}) = '' then 'N/A'
        when upper(trim({{ column_name }})) in ('NA', 'N/A') then 'N/A'
        else {{ column_name }}
    end

{% endmacro %}