

WITH cleaned AS (

    SELECT

        
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


            AS status,

        

    lower(kyc_status)


            AS kyc_status,

        

CASE
    WHEN risk_score < 20 THEN 'Very Low'
    WHEN risk_score < 40 THEN 'Low'
    WHEN risk_score < 60 THEN 'Medium'
    WHEN risk_score < 80 THEN 'High'
    ELSE 'Very High'
END


            AS risk_bucket

    FROM "qversity"."silver"."stg_customer"

)

SELECT DISTINCT

    md5(cast(coalesce(cast(customer_segment as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(status as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(kyc_status as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(risk_bucket as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS segmentation_id,

    customer_segment,
    status,
    kyc_status,
    risk_bucket

FROM cleaned