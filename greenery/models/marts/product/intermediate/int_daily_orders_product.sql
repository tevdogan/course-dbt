{{ 
    config(
        materialized='table'
) 
}}

WITH events AS (
    SELECT * FROM {{ ref('stg_postgres_events') }}
)

, order_items as (
    SELECT * FROM {{ ref('stg_postgres_order_items')}}
)

SELECT 
    order_items.product_id
    , DATE(created_at) AS created_day
    , COUNT(DISTINCT order_items.order_id) as total_daily_orders
FROM events
LEFT JOIN order_items
    ON events.order_id = order_items.order_id
GROUP BY 1, 2