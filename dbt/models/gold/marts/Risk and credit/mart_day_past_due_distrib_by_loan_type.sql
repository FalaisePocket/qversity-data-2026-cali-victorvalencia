-- answer 8

WITH loan_distribution AS (

    SELECT
        type AS loan_type,
        days_past_due,
        outstanding_balance,

        CASE 
            WHEN days_past_due = 0 THEN '00. Vigente (0 dpd)'
            WHEN days_past_due BETWEEN 1 AND 30 THEN '01. Mora Temprana (1-30 dpd)'
            WHEN days_past_due BETWEEN 31 AND 60 THEN '02. Mora Media (31-60 dpd)'
            WHEN days_past_due BETWEEN 61 AND 90 THEN '03. Mora Avanzada (61-90 dpd)'
            ELSE '04. Cartera Castigada / Default (>90 dpd)'
        END AS dpd_bucket

    FROM {{ ref('loans') }}

),

aggregated AS (

    SELECT
        loan_type,
        dpd_bucket,
        COUNT(*) AS total_loans,
        SUM(outstanding_balance) AS total_outstanding_balance

    FROM loan_distribution

    GROUP BY
        loan_type,
        dpd_bucket
)

SELECT
    loan_type,
    dpd_bucket,
    total_loans,
    total_outstanding_balance,

    ROUND(
        (
            100.0 * total_loans
            / SUM(total_loans) OVER (PARTITION BY loan_type)
        )::numeric,
        2
    ) AS pct_of_loans_by_type

FROM aggregated

ORDER BY
    loan_type,
    dpd_bucket