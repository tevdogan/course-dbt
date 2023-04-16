{{
    config(
    materialized = 'table'
    )
}}

with source as (
    select * from {{source('postgres', 'products') }}
)

select
    product_id
    , name 
    , price
    , inventory
from source