--answer 15 and 16

{{ config(materialized='table') }}

WITH base AS (

    SELECT
        t.category,
        t.currency_id,
        cur.currency_code,
        cur.currency_from_country,
        t.amount,
        t.status,

        -- Day of week from the date dimension
        d.day_name,
        d.short_day_name,

        -- Numeric day of week for deterministic ordering (ISO: 1=Monday … 7=Sunday)
        EXTRACT(ISODOW FROM d.full_date) AS day_of_week_num

    FROM {{ ref('transactions') }} t

    LEFT JOIN {{ ref('currency') }} cur
        ON t.currency_id = cur.currency_id

    LEFT JOIN {{ ref('date') }} d
        ON t.date_id = d.date_id

    -- Focus on completed transactions only; adjust if pending/reversed should be included
    WHERE lower(t.status) = 'completed'
      AND t.category IS NOT NULL

),

aggregated AS (

    SELECT
        category,
        currency_code,
        currency_from_country,
        day_of_week_num,
        short_day_name,
        day_name,

        -- Volume: number of transactions
        COUNT(*)        AS transaction_count,

        -- Value: total and average amount
        SUM(amount)     AS total_amount,
        AVG(amount)     AS avg_amount,
        MIN(amount)     AS min_amount,
        MAX(amount)     AS max_amount

    FROM base

    GROUP BY
        category,
        currency_code,
        currency_from_country,
        day_of_week_num,
        short_day_name,
        day_name

)


SELECT
    category,
    currency_code,
    currency_from_country,
    day_of_week_num,
    short_day_name,
    day_name,
    transaction_count,
    total_amount,
    avg_amount,
    min_amount,
    max_amount


FROM aggregated

ORDER BY
    currency_code,
    day_of_week_num