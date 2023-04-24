{{ 
    config(
        materialized='table'
) 
}}

WITH events AS (
    SELECT * FROM {{ ref('stg_postgres_events') }}
)

SELECT 
 product_id
, DATE(created_at) AS created_day
, SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart
, SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS page_view
FROM events
GROUP BY 1,2