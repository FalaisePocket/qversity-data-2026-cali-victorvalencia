
SELECT
    customer_id,
    mobile_app_registered,
    web_banking_registered,
    CAST(TO_CHAR(

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

, 'YYYYMMDD') AS INT) AS last_login_date_id,
    avg_monthly_logins,
    preferred_channel,
    

    CASE
        WHEN push_notifications IS NULL
             OR trim(push_notifications::text) = ''
        THEN false
        ELSE push_notifications
    END

 AS push_notifications,
    

    CASE
        WHEN paperless_statements IS NULL
             OR trim(paperless_statements::text) = ''
        THEN false
        ELSE paperless_statements
    END

 AS paperless_statements
FROM "qversity"."public_silver"."stg_digital_engagement"