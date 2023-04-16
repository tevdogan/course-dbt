{{
    config(
    materialized = 'table'
    )
}}

with source as (
    select * from {{source('postgres', 'order_items') }}
)

select
    order_id
    , product_id
    , quantity
from source