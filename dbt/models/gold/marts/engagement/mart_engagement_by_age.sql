--answer 21
-- Answers: What is the digital vs branch preference by age group?
--
-- Strategy:
--   1. Pull each customer's age_bucket and their declared preferred_channel
--      from digital_engagement.
--   2. Classify every channel as "digital" or "branch".
--   3. Count customers per age_bucket × channel_type, then calculate
--      the share of each type within every bucket.

{{ config(materialized='table') }}

WITH customer_channel AS (

    SELECT
        c.customer_id,
        c.age_bucket,

        -- Declared preferred channel from digital engagement profile
        de.preferred_channel,

        -- Classify the preferred channel into two broad groups
        CASE
            WHEN lower(de.preferred_channel) IN ('mobile', 'web')
                THEN 'digital'
            WHEN lower(de.preferred_channel) IN ('branch', 'atm', 'pos')
                THEN 'branch_physical'
            ELSE 'other'
        END AS channel_type,

        -- Registration flags for supplementary context
        de.mobile_app_registered,
        de.web_banking_registered

    FROM {{ ref('customer') }}       c
    LEFT JOIN {{ ref('digital_engagement') }} de
        ON c.customer_id = de.customer_id

    WHERE c.age_bucket IS NOT NULL

),

aggregated AS (

    SELECT
        age_bucket,
        channel_type,
        COUNT(*)                                          AS customer_count
    FROM customer_channel
    WHERE channel_type != 'other'          -- exclude unknowns / nulls
    GROUP BY age_bucket, channel_type

),

totals AS (

    SELECT
        age_bucket,
        SUM(customer_count) AS total_customers
    FROM aggregated
    GROUP BY age_bucket

)

SELECT
    a.age_bucket,
    a.channel_type,
    a.customer_count,
    t.total_customers,

    ROUND(
        100.0 * a.customer_count / NULLIF(t.total_customers, 0),
        2
    )                                                    AS pct_of_age_group,

    -- Convenience pivoted columns (useful for BI tools / charting)
    SUM(CASE WHEN a.channel_type = 'digital'          THEN a.customer_count ELSE 0 END)
        OVER (PARTITION BY a.age_bucket)                 AS digital_customers,

    SUM(CASE WHEN a.channel_type = 'branch_physical'  THEN a.customer_count ELSE 0 END)
        OVER (PARTITION BY a.age_bucket)                 AS branch_customers

FROM aggregated   a
JOIN totals       t USING (age_bucket)

ORDER BY
    -- Sort age buckets chronologically (assumes labels like "18-25", "26-35", …)
    a.age_bucket,
    a.channel_type