
  
    

  create  table "qversity"."public_silver"."accounts__dbt_tmp"
  
  
    as
  
  (
    -- models/marts/facts/fact_accounts.sql



SELECT
    a.account_id,
    a.customer_id,
    

    trim(a.account_type)

 AS account_type,

    currency_dim.currency_id,

    a.balance,
    a.credit_limit,
    a.interest_rate,

    CAST(
        TO_CHAR(
            

CASE

    -- YYYYMMDD (20200609)
    WHEN a.opened_date ~ '^\d{8}$' THEN
        to_date(a.opened_date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN a.opened_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(a.opened_date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN a.opened_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(a.opened_date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN a.opened_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(a.opened_date, 'DD/MM/YYYY')

    ELSE NULL

END

,
            'YYYYMMDD'
        ) AS INT
    ) AS opened_date_id,

    

CASE
    WHEN LOWER(

    lower(a.status)

) IN ('frozen', 'congelado') THEN 'frozen'
    WHEN LOWER(

    lower(a.status)

) IN ('closed', 'cerrado') THEN 'closed'
    WHEN LOWER(

    lower(a.status)

) IN ('active', 'activo') THEN 'active'
    ELSE 'unknown'
END

 AS status,

    

    case
        when a.branch_code is null then 'N/A'
        when trim(cast(a.branch_code as text)) = '' then 'N/A'
        when upper(trim(cast(a.branch_code as text))) in ('NA', 'N/A', 'NULL','null','none') then 'N/A'
        else trim(cast(a.branch_code as text))
    end

 AS branch_code

FROM "qversity"."silver"."stg_accounts" a

LEFT JOIN "qversity"."public_silver"."currency" currency_dim
    ON upper(trim(a.currency)) = currency_dim.currency_code
  );
  