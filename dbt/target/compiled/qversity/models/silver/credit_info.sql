-- models/marts/facts/fact_credit_info.sql



SELECT
    c.customer_id,

    

    case
        when c.credit_score < 300 then 300
        when c.credit_score > 850 then 850
        else c.credit_score
    end

 AS credit_score,

    currency_dim.currency_id,

    

    case
        when 

    case 
        when c.utilization_pct is not null then c.utilization_pct
        when coalesce(c.total_used, 0) = 0 then 0
        else (coalesce(c.total_limit, 0) * 100.0) 
             / coalesce(c.total_used, 0)
    end

 < 0.0 then 0.0
        when 

    case 
        when c.utilization_pct is not null then c.utilization_pct
        when coalesce(c.total_used, 0) = 0 then 0
        else (coalesce(c.total_limit, 0) * 100.0) 
             / coalesce(c.total_used, 0)
    end

 > 100.0 then 100.0
        else 

    case 
        when c.utilization_pct is not null then c.utilization_pct
        when coalesce(c.total_used, 0) = 0 then 0
        else (coalesce(c.total_limit, 0) * 100.0) 
             / coalesce(c.total_used, 0)
    end


    end

 AS utilization_pct,

    

    coalesce(c.total_limit, 0)

 AS total_limit,
    

    coalesce(c.total_used, 0)

 AS total_used,
    c.num_credit_accounts,
    c.oldest_account_age_months,
    c.late_payments_12m,
    c.inquiries_6m,

    

    CASE
        WHEN c.bankruptcy_flag IS NULL
             OR trim(c.bankruptcy_flag::text) = ''
        THEN false
        ELSE c.bankruptcy_flag
    END

 AS bankruptcy_flag

FROM "qversity"."public_silver"."stg_credit_info" c

LEFT JOIN "qversity"."public_silver"."currency" currency_dim
    ON upper(trim(c.currency)) = currency_dim.currency_code