-- models/marts/facts/fact_transactions.sql



SELECT
    t.transaction_id,
    t.account_id,

    CAST(
        TO_CHAR(
            

CASE

    -- YYYYMMDD (20200609)
    WHEN t.date ~ '^\d{8}$' THEN
        to_date(t.date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN t.date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(t.date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN t.date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(t.date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN t.date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(t.date, 'DD/MM/YYYY')

    ELSE NULL

END

,
            'YYYYMMDD'
        ) AS INT
    ) AS date_id,

    t.amount,

    currency_dim.currency_id,

    
    case trim(

    lower(t.type)

)
        when 'reembolso' then 'refund'
        when 'transferencia' then 'transfer'
        when 'retiro' then 'withdrawal'
        when 'comision' then 'fee'
        when 'deposito' then 'deposit'
        when 'pago' then 'payment'
        else lower(trim(

    lower(t.type)

))
    end
 AS type,

    

    case
        when 

    trim(t.category)

 is null then 'N/A'
        when trim(

    trim(t.category)

) = '' then 'N/A'
        when upper(trim(

    trim(t.category)

)) in ('NA', 'N/A') then 'N/A'
        else 

    trim(t.category)


    end

 AS category,

    

    case
        when t.merchant is null then 'N/A'
        when trim(t.merchant) = '' then 'N/A'
        when upper(trim(t.merchant)) in ('NA', 'N/A') then 'N/A'
        else t.merchant
    end

 AS merchant,

    t.channel,

    

    lower(t.status)

 AS status,

    t.description

FROM "qversity"."silver"."stg_transactions" t

LEFT JOIN "qversity"."public_silver"."currency" currency_dim
    ON upper(trim(t.currency)) = currency_dim.currency_code