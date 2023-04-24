{{ 
    config(
        materialized='table'
) 
}}

WITH page_views_products AS (
   SELECT * FROM {{ ref('int_page_view_products') }}
), 


orders_products AS (
    SELECT * FROM {{ ref('int_daily_orders_product') }}
)

SELECT 
page_views_products.product_id
, page_views_products.created_day
, page_views_products.page_view
, page_views_products.add_to_cart
, orders_products.total_daily_orders
FROM page_views_products
LEFT JOIN orders_products 
    ON page_views_products.product_id = orders_products.product_id 
    AND page_views_products.created_day = orders_products.created_day
