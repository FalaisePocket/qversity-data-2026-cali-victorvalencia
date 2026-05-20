{% macro translate_transactions_type(column_name) %}
    case trim({{ column_name }})
        when 'reembolso' then 'refund'
        when 'transferencia' then 'transfer'
        when 'retiro' then 'withdrawal'
        when 'comision' then 'fee'
        when 'deposito' then 'deposit'
        when 'pago' then 'payment'
        else lower(trim({{ column_name }}))
    end
{% endmacro %}