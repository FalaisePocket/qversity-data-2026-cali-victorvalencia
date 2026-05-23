{% macro normalize_na(column_name) %}

    case
        when {{ column_name }} is null then 'N/A'
        when trim(cast({{ column_name }} as text)) = '' then 'N/A'
        when upper(trim(cast({{ column_name }} as text))) in ('NA', 'N/A', 'NULL','null','none') then 'N/A'
        else trim(cast({{ column_name }} as text))
    end

{% endmacro %}