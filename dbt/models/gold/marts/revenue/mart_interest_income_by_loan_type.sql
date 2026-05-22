-- answer 4
{{ config(materialized='table') }}

SELECT
    l.type  AS loan_type,
    c.currency_code,

    COUNT(l.loan_id) AS num_loans,

    SUM(l.principal * l.interest_rate / 100) AS gross_interest_income,

    SUM(l.outstanding_balance * l.interest_rate / 100)  AS current_interest_income,

    
    AVG(l.interest_rate)  AS avg_interest_rate,
    SUM(l.principal)  AS total_principal,
    SUM(l.outstanding_balance)  AS total_outstanding

FROM {{ ref('loans') }} l
LEFT JOIN {{ ref('currency') }} c
    ON l.currency_id = c.currency_id



GROUP BY l.type, c.currency_code
ORDER BY gross_interest_income DESC