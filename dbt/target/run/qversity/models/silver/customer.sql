
  
    

  create  table "qversity"."public_silver"."customer__dbt_tmp"
  
  
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
        CASE c.country
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
    CAST(TO_CHAR(

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

, 'YYYYMMDD') AS INT) AS date_of_birth_id,
    

    case
        when gender is null then 'N/A'
        when trim(gender) = '' then 'N/A'
        when upper(trim(gender)) in ('NA', 'N/A') then 'N/A'
        else gender
    end

 AS gender,
    nationality,
    l.location_id,
    address,
    

    case
        when lat < -90 then -90
        when lat > 90 then 90
        else lat
    end

 AS lat,
    

    case
        when lon < -180 then -180
        when lon > 90 then 90
        else lon
    end

 AS lon,
    CAST(TO_CHAR(

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

, 'YYYYMMDD') AS INT) AS registration_date_id,
    

    lower(kyc_status)

 AS kyc_status,
    

    case
        when risk_score < 0 then 0
        when risk_score > 100 then 100
        else risk_score
    end

 AS risk_score,
    
    case 

    lower(customer_segment)


        when 'minorista' then 'retail'
        when 'pyme' then 'sme'
        when 'banca_privada' then 'private_banking'
        else 

    lower(customer_segment)


    end
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

FROM "qversity"."silver"."stg_customer" c

LEFT JOIN "qversity"."public_silver"."location" l
ON
    

    trim(c.city)

 = l.city
    AND c.country = l.short_country
  );
  