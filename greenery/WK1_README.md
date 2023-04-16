
*1. How many users do we have?*
130 distinct users.

```
select
    count(distinc user_id) AS distinct_users_count
from
    dev_db.dbt_tevhidedoganmolliecom.stg_postgres_users
```

*2. On average, how many orders do we receive per hour?*

8 order per hour on average (rounded to int.)

```
with orders_per_hour as (
    select
      date_trunc(hour, created_at) as created_date_hour,  
      count(distinct order_id) as distinct_orders_count
    from dev_db.dbt_tevhidedoganmolliecom.stg_postgres_orders
    group by 1
  )

select
  round(avg(distinct_orders_count),0) as average_orders_per_hour
from orders_per_hour
```

*3. On average, how long does an order take from being placed to being delivered?*

3,89 days on average

```
select 
    avg(datediff(day, created_at, delivered_at)) as average_order_duration_days
    , avg(datediff(hour, created_at, delivered_at)) as average_order_duration_hours
from dev_db.dbt_tevhidedoganmolliecom.stg_postgres_orders
where delivered_at is not null
```

*4. How many users have only made one purchase? Two purchases? Three+ purchases?*

|ORDER_PURCHASES | NUMBER_OF_USERS |
| ------------- | ----------- |
| 1             | 25          |
| 2             | 28          |
| 3+            | 71          |


```
with orders_per_user as (
select 
    user_id
    , count(distinct order_id) as order_count
from dev_db.dbt_tevhidedoganmolliecom.stg_postgres_orders
group by user_id
), 

all_order_count as(
select 
    order_count
    , COUNT(user_id) AS number_of_users
from orders_per_user
group by order_count
order by 1)

select 
case order_count
    when 1 then '1'
    when 2 then '2'
    else '3+'
end as order_purchases
, sum(number_of_users) as number_of_users
from all_order_count
group by 1
```

*5. On average, how many unique sessions do we have per hour?*

16 sessions on average (rounded to int.)

```
with sessions_per_hour as (
select 
    date_trunc(hour,created_at) as created_date_hour
    , count(distinct session_id) as unique_sessions_count
from dev_db.dbt_tevhidedoganmolliecom.stg_postgres_events
group by 1
)

select 
round(avg(unique_sessions_count),0) AS average_unique_sessions
from sessions_per_hour
```