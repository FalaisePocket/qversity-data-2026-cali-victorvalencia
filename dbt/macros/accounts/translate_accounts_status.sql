{% macro translate_account_status(column_name) %}

CASE
    WHEN LOWER({{ column_name }}) IN ('frozen', 'congelado') THEN 'frozen'
    WHEN LOWER({{ column_name }}) IN ('closed', 'cerrado') THEN 'closed'
    WHEN LOWER({{ column_name }}) IN ('active', 'activo') THEN 'active'
    ELSE 'unknown'
END

{% endmacro %}