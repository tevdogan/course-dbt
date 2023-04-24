{{ 
    config(
        materialized='table'
) 
}}

WITH events AS (
    SELECT * FROM {{ ref('stg_postgres_events') }}
)

SELECT 
 user_id
, DATE(created_at) AS created_day
, SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS checkout
, SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) AS package_shipped
FROM events
GROUP BY 1,2