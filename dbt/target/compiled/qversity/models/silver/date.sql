

WITH all_dates AS (
    SELECT 

CASE

    -- YYYYMMDD (20200609)
    WHEN opened_date ~ '^\d{8}$' THEN
        to_date(opened_date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN opened_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(opened_date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN opened_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(opened_date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN opened_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(opened_date, 'DD/MM/YYYY')

    ELSE NULL

END

 AS date_day FROM "qversity"."silver"."stg_accounts"
    UNION
    SELECT 

CASE

    -- YYYYMMDD (20200609)
    WHEN date_of_birth ~ '^\d{8}$' THEN
        to_date(date_of_birth, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN date_of_birth ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(date_of_birth, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN date_of_birth ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(date_of_birth, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN date_of_birth ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(date_of_birth, 'DD/MM/YYYY')

    ELSE NULL

END

 AS date_day FROM "qversity"."silver"."stg_customer"
    UNION
    SELECT 

CASE

    -- YYYYMMDD (20200609)
    WHEN registration_date ~ '^\d{8}$' THEN
        to_date(registration_date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN registration_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(registration_date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN registration_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(registration_date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN registration_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(registration_date, 'DD/MM/YYYY')

    ELSE NULL

END

 AS date_day FROM "qversity"."silver"."stg_customer"
    UNION
    SELECT 

CASE

    -- YYYYMMDD (20200609)
    WHEN last_login_date ~ '^\d{8}$' THEN
        to_date(last_login_date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN last_login_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(last_login_date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN last_login_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(last_login_date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN last_login_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(last_login_date, 'DD/MM/YYYY')

    ELSE NULL

END

 AS date_day FROM "qversity"."public_silver"."stg_digital_engagement"
    UNION
    SELECT 

CASE

    -- YYYYMMDD (20200609)
    WHEN start_date ~ '^\d{8}$' THEN
        to_date(start_date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN start_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(start_date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN start_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(start_date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN start_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(start_date, 'DD/MM/YYYY')

    ELSE NULL

END

 AS date_day FROM "qversity"."silver"."stg_loans"
    UNION
    SELECT 

CASE

    -- YYYYMMDD (20200609)
    WHEN end_date ~ '^\d{8}$' THEN
        to_date(end_date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN end_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(end_date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN end_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(end_date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN end_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(end_date, 'DD/MM/YYYY')

    ELSE NULL

END

 AS date_day FROM "qversity"."silver"."stg_loans"
    UNION
    SELECT 

CASE

    -- YYYYMMDD (20200609)
    WHEN date ~ '^\d{8}$' THEN
        to_date(date, 'YYYYMMDD')

    -- YYYY-MM-DD (2023-05-09)
    WHEN date ~ '^\d{4}-\d{2}-\d{2}$' THEN
        to_date(date, 'YYYY-MM-DD')

    -- MM-DD-YYYY (12-21-2025)
    WHEN date ~ '^\d{2}-\d{2}-\d{4}$' THEN
        to_date(date, 'MM-DD-YYYY')

    -- DD/MM/YYYY (06/09/2023)
    WHEN date ~ '^\d{2}/\d{2}/\d{4}$' THEN
        to_date(date, 'DD/MM/YYYY')

    ELSE NULL

END

 AS date_day FROM "qversity"."silver"."stg_transactions"
),

unique_dates AS (
    SELECT DISTINCT date_day 
    FROM all_dates 
    WHERE date_day IS NOT NULL
)

SELECT
    -- El ID/FK puede ser la misma fecha en formato entero (YYYYMMDD) o un hash. El formato entero es estándar y muy eficiente.
    CAST(TO_CHAR(date_day, 'YYYYMMDD') AS INT) AS date_id,
    date_day AS full_date,
    EXTRACT(YEAR FROM date_day) AS year,
    EXTRACT(MONTH FROM date_day) AS month,
    EXTRACT(DAY FROM date_day) AS day,
    EXTRACT(QUARTER FROM date_day) AS quarter,
    
    TO_CHAR(date_day, 'Mon') AS short_month,
    TO_CHAR(date_day, 'FMMonth') AS month_name,

    TO_CHAR(date_day, 'Dy') AS short_day_name,
    TO_CHAR(date_day, 'FMDay') AS day_name


FROM unique_dates