
  
    

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
        when trim(cast(gender as text)) = '' then 'N/A'
        when upper(trim(cast(gender as text))) in ('NA', 'N/A', 'NULL','null','none') then 'N/A'
        else trim(cast(gender as text))
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
    s.segmentation_id,
    

    case
        when relationship_manager is null then 'N/A'
        when trim(cast(relationship_manager as text)) = '' then 'N/A'
        when upper(trim(cast(relationship_manager as text))) in ('NA', 'N/A', 'NULL','null','none') then 'N/A'
        else trim(cast(relationship_manager as text))
    end

 AS relationship_manager,

    

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 AS age,
    

CASE
    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 < 18
        THEN 'Under 18'

    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 BETWEEN 18 AND 24
        THEN '18-24'

    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 BETWEEN 25 AND 34
        THEN '25-34'

    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 BETWEEN 35 AND 44
        THEN '35-44'

    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 BETWEEN 45 AND 54
        THEN '45-54'

    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 BETWEEN 55 AND 64
        THEN '55-64'

    ELSE '65+'
END

 AS age_bucket,
    

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 AS tenure_years,
    

CASE
    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 < 1
        THEN '<1 year'

    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 BETWEEN 1 AND 2
        THEN '1-2 years'

    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 BETWEEN 3 AND 5
        THEN '3-5 years'

    WHEN 

EXTRACT(
    YEAR FROM AGE(
        CURRENT_DATE,
        

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


    )
)

 BETWEEN 6 AND 10
        THEN '6-10 years'

    ELSE '10+ years'
END

 AS tenure_bucket

FROM "qversity"."silver"."stg_customer" c

LEFT JOIN "qversity"."public_silver"."location" l
ON 
    

CASE LOWER(TRIM(

    trim(c.city)

))

    -- Mexico
    WHEN 'ciudad de mexico' THEN 'Ciudad de Mexico'
    WHEN 'ciudd de mexico' THEN 'Ciudad de Mexico'

    -- Colombia
    WHEN 'bogta' THEN 'Bogota'
    WHEN 'bogota' THEN 'Bogota'
    WHEN 'medelin' THEN 'Medellin'
    WHEN 'medellin' THEN 'Medellin'
    WHEN 'barranquila' THEN 'Barranquilla'
    WHEN 'barranquilla' THEN 'Barranquilla'
    WHEN 'cartagna' THEN 'Cartagena'
    WHEN 'cartagena' THEN 'Cartagena'
    WHEN 'cai' THEN 'Cali'
    WHEN 'cali' THEN 'Cali'
    WHEN 'arequpa' THEN 'Arequipa'
    WHEN 'arequipa' THEN 'Arequipa'

    -- Peru
    WHEN 'lma' THEN 'Lima'
    WHEN 'lima' THEN 'Lima'
    WHEN 'cusco' THEN 'Cusco'
    WHEN 'cusc' THEN 'Cusco'
    WHEN 'piua' THEN 'Piura'
    WHEN 'piura' THEN 'Piura'
    WHEN 'trujllo' THEN 'Trujillo'
    WHEN 'trujillo' THEN 'Trujillo'

    -- Chile
    WHEN 'santiago' THEN 'Santiago'
    WHEN 'santiag' THEN 'Santiago'
    WHEN 'valparaiso' THEN 'Valparaiso'
    WHEN 'temuco' THEN 'Temuco'
    WHEN 'temco' THEN 'Temuco'
    WHEN 'concepcion' THEN 'Concepcion'
    WHEN 'concepcin' THEN 'Concepcion'
    WHEN 'la serna' THEN 'La Serena'
    WHEN 'la serena' THEN 'La Serena'

    -- Argentina
    WHEN 'tucuman' THEN 'Tucuman'
    WHEN 'tucman' THEN 'Tucuman'
    WHEN 'rosaro' THEN 'Rosario'
    WHEN 'rosario' THEN 'Rosario'
    WHEN 'cordoba' THEN 'Cordoba'
    WHEN 'cordba' THEN 'Cordoba'
    WHEN 'mendoza' THEN 'Mendoza'
    WHEN 'mendza' THEN 'Mendoza'
    WHEN 'buenos aires' THEN 'Buenos Aires'
    WHEN 'buenos aire' THEN 'Buenos Aires'

    -- Brazil
    WHEN 'sao paulo' THEN 'Sao Paulo'
    WHEN 'sao paulp' THEN 'Sao Paulo'
    WHEN 'brasilia' THEN 'Brasilia'
    WHEN 'brasila' THEN 'Brasilia'
    WHEN 'fortaleza' THEN 'Fortaleza'
    WHEN 'fortalza' THEN 'Fortaleza'

    -- Uruguay
    WHEN 'montevideo' THEN 'Montevideo'
    WHEN 'montevide' THEN 'Montevideo'
    WHEN 'salto' THEN 'Salto'
    WHEN 'saltp' THEN 'Salto'
    WHEN 'rivera' THEN 'Rivera'
    WHEN 'rivra' THEN 'Rivera'
    WHEN 'paysandu' THEN 'Paysandu'
    WHEN 'paysand' THEN 'Paysandu'
    WHEN 'maldonado' THEN 'Maldonado'
    WHEN 'maldonad' THEN 'Maldonado'

    -- fallback
    ELSE INITCAP(TRIM(

    trim(c.city)

))

END

 = 

CASE LOWER(TRIM(l.city))

    -- Mexico
    WHEN 'ciudad de mexico' THEN 'Ciudad de Mexico'
    WHEN 'ciudd de mexico' THEN 'Ciudad de Mexico'

    -- Colombia
    WHEN 'bogta' THEN 'Bogota'
    WHEN 'bogota' THEN 'Bogota'
    WHEN 'medelin' THEN 'Medellin'
    WHEN 'medellin' THEN 'Medellin'
    WHEN 'barranquila' THEN 'Barranquilla'
    WHEN 'barranquilla' THEN 'Barranquilla'
    WHEN 'cartagna' THEN 'Cartagena'
    WHEN 'cartagena' THEN 'Cartagena'
    WHEN 'cai' THEN 'Cali'
    WHEN 'cali' THEN 'Cali'
    WHEN 'arequpa' THEN 'Arequipa'
    WHEN 'arequipa' THEN 'Arequipa'

    -- Peru
    WHEN 'lma' THEN 'Lima'
    WHEN 'lima' THEN 'Lima'
    WHEN 'cusco' THEN 'Cusco'
    WHEN 'cusc' THEN 'Cusco'
    WHEN 'piua' THEN 'Piura'
    WHEN 'piura' THEN 'Piura'
    WHEN 'trujllo' THEN 'Trujillo'
    WHEN 'trujillo' THEN 'Trujillo'

    -- Chile
    WHEN 'santiago' THEN 'Santiago'
    WHEN 'santiag' THEN 'Santiago'
    WHEN 'valparaiso' THEN 'Valparaiso'
    WHEN 'temuco' THEN 'Temuco'
    WHEN 'temco' THEN 'Temuco'
    WHEN 'concepcion' THEN 'Concepcion'
    WHEN 'concepcin' THEN 'Concepcion'
    WHEN 'la serna' THEN 'La Serena'
    WHEN 'la serena' THEN 'La Serena'

    -- Argentina
    WHEN 'tucuman' THEN 'Tucuman'
    WHEN 'tucman' THEN 'Tucuman'
    WHEN 'rosaro' THEN 'Rosario'
    WHEN 'rosario' THEN 'Rosario'
    WHEN 'cordoba' THEN 'Cordoba'
    WHEN 'cordba' THEN 'Cordoba'
    WHEN 'mendoza' THEN 'Mendoza'
    WHEN 'mendza' THEN 'Mendoza'
    WHEN 'buenos aires' THEN 'Buenos Aires'
    WHEN 'buenos aire' THEN 'Buenos Aires'

    -- Brazil
    WHEN 'sao paulo' THEN 'Sao Paulo'
    WHEN 'sao paulp' THEN 'Sao Paulo'
    WHEN 'brasilia' THEN 'Brasilia'
    WHEN 'brasila' THEN 'Brasilia'
    WHEN 'fortaleza' THEN 'Fortaleza'
    WHEN 'fortalza' THEN 'Fortaleza'

    -- Uruguay
    WHEN 'montevideo' THEN 'Montevideo'
    WHEN 'montevide' THEN 'Montevideo'
    WHEN 'salto' THEN 'Salto'
    WHEN 'saltp' THEN 'Salto'
    WHEN 'rivera' THEN 'Rivera'
    WHEN 'rivra' THEN 'Rivera'
    WHEN 'paysandu' THEN 'Paysandu'
    WHEN 'paysand' THEN 'Paysandu'
    WHEN 'maldonado' THEN 'Maldonado'
    WHEN 'maldonad' THEN 'Maldonado'

    -- fallback
    ELSE INITCAP(TRIM(l.city))

END


    
    AND c.country = l.short_country

LEFT JOIN "qversity"."public_silver"."customer_segmentation" s
ON
    
    case 

    lower(c.customer_segment)


        when 'minorista' then 'retail'
        when 'pyme' then 'sme'
        when 'banca_privada' then 'private_banking'
        else 

    lower(c.customer_segment)


    end

        = s.customer_segment

    AND 

case
    when 

    lower(c.status)

 = 'activo' then 'active'
    when 

    lower(c.status)

 = 'inactivo' then 'inactive'
    when 

    lower(c.status)

 = 'cerrado' then 'closed'
    when 

    lower(c.status)

 = 'suspendido' then 'suspended'

    -- por si ya vienen en inglés
    when 

    lower(c.status)

 in ('active', 'inactive', 'closed', 'suspended')
        then 

    lower(c.status)



    else 'N/A'
end


        = s.status

    AND 

    lower(c.kyc_status)


        = s.kyc_status

    AND 

CASE
    WHEN c.risk_score < 20 THEN 'Very Low'
    WHEN c.risk_score < 40 THEN 'Low'
    WHEN c.risk_score < 60 THEN 'Medium'
    WHEN c.risk_score < 80 THEN 'High'
    ELSE 'Very High'
END


        = s.risk_bucket
  );
  