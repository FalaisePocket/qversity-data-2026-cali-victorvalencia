--answer 7
{{ config(
    materialized='table',
    schema='gold'
) }}

WITH credit_data AS (
    SELECT
        customer_id,
        credit_score,
        utilization_pct,
        total_limit,
        total_used,
        bankruptcy_flag,
        -- Transformación analítica: Buckets de utilización
        CASE 
            WHEN utilization_pct = 0 THEN '00) No Use'
            WHEN utilization_pct > 0   AND utilization_pct <= 20  THEN '01) 1% - 20%'
            WHEN utilization_pct > 20  AND utilization_pct <= 40  THEN '02) 21% - 40%'
            WHEN utilization_pct > 40  AND utilization_pct <= 60  THEN '03) 41% - 60%'
            WHEN utilization_pct > 60  AND utilization_pct <= 80  THEN '04) 61% - 80%'
            WHEN utilization_pct > 80  AND utilization_pct <= 100 THEN '05) 81% - 100%'
            ELSE '06) Over-utilized (>100%)'
        END AS credit_utilization_bucket
    FROM {{ ref('credit_info') }}
),

loan_summary AS (
    SELECT
        customer_id,
        COUNT(loan_id) AS total_active_loans,
        SUM(principal) AS total_loan_principal,
        SUM(outstanding_balance) AS total_loan_outstanding,
        -- Guardamos el máximo de días en mora
        MAX(days_past_due) AS max_days_past_due,
        -- Flag de morosidad basado en el status
        MAX(CASE WHEN status = 'delinquent' THEN 1 ELSE 0 END) AS is_currently_delinquent
    FROM {{ ref('loans') }}
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    
    -- Métricas de Crédito (origen credit_info)
    c.credit_score,
    c.utilization_pct,
    c.credit_utilization_bucket,
    c.bankruptcy_flag,
    
    -- Métricas de Préstamos (origen loans)
    COALESCE(l.total_active_loans, 0) AS total_active_loans,
    COALESCE(l.total_loan_outstanding, 0) AS total_loan_outstanding,
    COALESCE(l.max_days_past_due, 0) AS max_days_past_due,
    COALESCE(l.is_currently_delinquent, 0) AS is_currently_delinquent,
    
    -- Indicador combinado (KPI de Negocio)
    CASE 
        WHEN COALESCE(l.is_currently_delinquent, 0) = 1 THEN 'Red (Delinquent)'
        WHEN c.utilization_pct > 80 OR c.credit_score < 500 THEN 'Orange (High Risk)'
        WHEN c.utilization_pct > 40 THEN 'Yellow (Medium Risk)'
        ELSE 'Green (Low Risk)'
    END AS risk_segment

FROM credit_data c
LEFT JOIN loan_summary l 
    ON c.customer_id = l.customer_id