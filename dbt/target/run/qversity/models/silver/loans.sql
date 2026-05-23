
  
    

  create  table "qversity"."public_silver"."loans__dbt_tmp"
  
  
    as
  
  (
    -- models/marts/facts/fact_loans.sql



SELECT
    l.customer_id,
    l.loan_id,

    

    lower(l.type)

 AS type,

    currency_dim.currency_id,

    l.principal,
    l.outstanding_balance,
    l.interest_rate,
    l.term_months,
    l.monthly_payment,

    CAST(
        TO_CHAR(
            

CASE

    -- YYYYMMDD (20200609)
    WHEN l.start_date ~ '^\d{8}$' THEN
        to_date(l.start_date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN l.start_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(l.start_date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN l.start_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(l.start_date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN l.start_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(l.start_date, 'DD/MM/YYYY')

    ELSE NULL

END

,
            'YYYYMMDD'
        ) AS INT
    ) AS start_date_id,

    CAST(
        TO_CHAR(
            

CASE

    -- YYYYMMDD (20200609)
    WHEN l.end_date ~ '^\d{8}$' THEN
        to_date(l.end_date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN l.end_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(l.end_date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN l.end_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(l.end_date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN l.end_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(l.end_date, 'DD/MM/YYYY')

    ELSE NULL

END

,
            'YYYYMMDD'
        ) AS INT
    ) AS end_date_id,

    

    lower(l.status)

 AS status,

    l.days_past_due,

    

    case
        when l.collateral_type is null then 'N/A'
        when trim(cast(l.collateral_type as text)) = '' then 'N/A'
        when upper(trim(cast(l.collateral_type as text))) in ('NA', 'N/A', 'NULL','null','none') then 'N/A'
        else trim(cast(l.collateral_type as text))
    end

 AS collateral_type

FROM "qversity"."silver"."stg_loans" l

LEFT JOIN "qversity"."public_silver"."currency" currency_dim
    ON upper(trim(l.currency)) = currency_dim.currency_code
  );
  