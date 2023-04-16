{{
    config(
    materialized = 'table'
    )
}}

with source as (
    select * from {{source('postgres', 'promos') }}
)

select
    promo_id
    , discount
    , status 
from source