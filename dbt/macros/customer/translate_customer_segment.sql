{% macro translate_customer_segment(column_name) %}
    case {{ column_name }}
        when 'minorista' then 'retail'
        when 'pyme' then 'sme'
        when 'banca_privada' then 'private_banking'
        else {{ column_name }}
    end
{% endmacro %}