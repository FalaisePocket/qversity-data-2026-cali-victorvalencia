{% macro translate_status(column_name) %}

case
    when {{ column_name }} = 'activo' then 'active'
    when {{ column_name }} = 'inactivo' then 'inactive'
    when {{ column_name }} = 'cerrado' then 'closed'
    when {{ column_name }} = 'suspendido' then 'suspended'

    -- por si ya vienen en inglés
    when {{ column_name }} in ('active', 'inactive', 'closed', 'suspended')
        then {{ column_name }}

    else 'N/A'
end

{% endmacro %}