
  
    

  create  table "qversity"."public_silver"."digital_engagement__dbt_tmp"
  
  
    as
  
  (
    
SELECT
    customer_id,

    (digital_engagement::jsonb ->> 'mobile_app_registered')::boolean AS mobile_app_registered,

    (digital_engagement::jsonb ->> 'web_banking_registered')::boolean AS web_banking_registered,

    digital_engagement::jsonb ->> 'last_login_date' AS last_login_date,

    (digital_engagement::jsonb ->> 'avg_monthly_logins')::integer AS avg_monthly_logins,

    digital_engagement::jsonb ->> 'preferred_channel' AS preferred_channel,

    (digital_engagement::jsonb ->> 'push_notifications')::boolean AS push_notifications,

    (digital_engagement::jsonb ->> 'paperless_statements')::boolean AS paperless_statements

FROM "qversity"."silver"."stg_customer"
WHERE digital_engagement IS NOT NULL
  );
  