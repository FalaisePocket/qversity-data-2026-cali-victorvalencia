
  
    

  create  table "qversity"."public_silver"."stg_customer__dbt_tmp"
  
  
    as
  
  (
    
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    

CASE
    WHEN length(regexp_replace(

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')

, '[^0-9]', '', 'g')) = 10 THEN
        CASE country
            WHEN 'CO' THEN '+57' || 

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


            WHEN 'UY' THEN '+598' || 

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


            WHEN 'AR' THEN '+54' || 

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


            WHEN 'MX' THEN '+52' || 

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


            WHEN 'CL' THEN '+56' || 

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


            WHEN 'PE' THEN '+51' || 

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


            WHEN 'BR' THEN '+55' || 

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


            ELSE 

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


        END

    WHEN length(regexp_replace(

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')

, '[^0-9]', '', 'g')) > 10 THEN
        

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')



    ELSE
        

    regexp_replace(phone_number, '[\-\(\)\s]', '', 'g')


END

 AS phone_number,
    date_of_birth,
    

    case
        when gender is null then 'N/A'
        when trim(gender) = '' then 'N/A'
        when upper(trim(gender)) in ('NA', 'N/A') then 'N/A'
        else gender
    end

 AS gender,
    nationality,
    

    trim(city)

 AS city,
    country,
    address,
    lat,
    lon,
    registration_date,
    

    lower(kyc_status)

 AS kyc_status,
    risk_score,
    

    lower(customer_segment)

 AS customer_segment,
    

    case
        when relationship_manager is null then 'N/A'
        when trim(relationship_manager) = '' then 'N/A'
        when upper(trim(relationship_manager)) in ('NA', 'N/A') then 'N/A'
        else relationship_manager
    end

 AS relationship_manager,
    

case
    when 

    lower(status)

 = 'activo' then 'active'
    when 

    lower(status)

 = 'inactivo' then 'inactive'
    when 

    lower(status)

 = 'cerrado' then 'closed'
    when 

    lower(status)

 = 'suspendido' then 'suspended'

    -- por si ya vienen en inglés
    when 

    lower(status)

 in ('active', 'inactive', 'closed', 'suspended')
        then 

    lower(status)



    else 'N/A'
end

 AS status

FROM "qversity"."silver"."stg_customer"
  );
  