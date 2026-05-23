--answer 19

{{ config(materialized='table') }}



WITH international_transfers AS (

    SELECT
        -- Dimensiones de cliente / ubicación
        c.customer_id,
        l.short_country          AS customer_country,
        l.country_name           AS customer_country_name,

        -- Dimensiones de moneda / destino
        cur.currency_code,
        cur.currency_from_country,

        -- Dimensiones de transacción
        t.type,
        t.channel,
        t.status,

        -- Métricas base
        t.amount,
        t.date_id

    FROM {{ ref('transactions') }} t

    -- Moneda de la transacción
    INNER JOIN {{ ref('currency') }} cur
        ON t.currency_id = cur.currency_id

    -- Cliente propietario de la cuenta
    INNER JOIN {{ ref('customer') }} c
        ON t.customer_id = c.customer_id

    -- Ubicación del cliente
    INNER JOIN {{ ref('location') }} l
        ON c.location_id = l.location_id

    -- Filtro de internacionalidad:
    -- el país del cliente NO coincide con el país de origen de la moneda
    WHERE l.short_country != cur.currency_from_country

      -- Solo transferencias completadas (excluye reversadas / fallidas)
      AND t.status = 'completed'

)

SELECT
    -- Agrupadores
    customer_country,
    customer_country_name,
    currency_code,
    currency_from_country,
    type,
    channel,

    -- Volumen
    COUNT(*)                                    AS num_transfers,
    COUNT(DISTINCT customer_id)                 AS num_unique_customers,

    -- Monto
    SUM(amount)                                 AS total_amount,
    AVG(amount)                                 AS avg_amount,
    MIN(amount)                                 AS min_amount,
    MAX(amount)                                 AS max_amount,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY amount)          AS median_amount,

    -- Periodo de actividad
    MIN(date_id)                                AS first_transfer_date_id,
    MAX(date_id)                                AS last_transfer_date_id

FROM international_transfers

GROUP BY
    customer_country,
    customer_country_name,
    currency_code,
    currency_from_country,
    type,
    channel

ORDER BY
    total_amount DESC