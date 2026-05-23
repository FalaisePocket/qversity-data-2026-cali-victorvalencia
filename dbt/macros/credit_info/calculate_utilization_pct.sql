{% macro fill_null_utilization(existing_value, total_used, total_limit) %}

    case 
        when {{ existing_value }} is not null then {{ existing_value }}
        when coalesce({{ total_limit }}, 0) = 0 then 0
        else (coalesce({{ total_used }}, 0) * 100.0) 
             / coalesce({{ total_limit }}, 0)
    end

{% endmacro %}