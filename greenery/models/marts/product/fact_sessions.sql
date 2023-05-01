
{{ 
    config(
        materialized='table'
) 
}}

WITH events AS (
   SELECT * FROM {{ ref('stg_postgres_events') }}
)


SELECT 
SESSION_ID
{{ event_types_agg() }}
--, SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS page_view
--, SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart
--, SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS checkout
--, SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) AS package_shipped
FROM events
GROUP BY SESSION_ID