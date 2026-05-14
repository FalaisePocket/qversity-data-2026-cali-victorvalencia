
  
    

  create  table "qversity"."public_silver"."stg_customer__dbt_tmp"
  
  
    as
  
  (
    
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone_number,
    date_of_birth,
    gender,
    nationality,
    city,
    country,
    adress,
    lat,
    lon,
    registration_date,
    kyc_status,
    risk_score,
    customer_segment,
    relationship_manager,
    status

FROM "qversity"."silver"."stg_customer"
  );
  