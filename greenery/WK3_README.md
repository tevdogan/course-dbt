*1. What is the conversion rate overall?*
62,4%
```
SELECT 
count(distinct case when checkout > 0 then session_id end) as checkouts_count,
count(distinct session_id) as session_counts,
checkouts_count/session_counts AS conversion_rate
FROM dev_db.dbt_tevhidedoganmolliecom.fact_sessions 
```

*1. What is the conversion rate by product?*
```
select
product_id,
sum(total_daily_orders) as orders_total,
sum(page_view) as views_totals,
orders_total/views_totals as product_conversion
from DEV_DB.DBT_TEVHIDEDOGANMOLLIECOM.FACT_PRODUCTS 
group by product_id
```

*2. Macro*
Created a macro for aggregation on event type: 
```
{% macro event_types_agg() %} 

 {% set event_types = dbt_utils.get_column_values(
    table=ref('stg_events')
    , column='event_type'
 ) %}

  {% for event_type in event_types  %}
      , SUM(CASE WHEN event_type = '{{ event_type }}' THEN 1 ELSE 0 END)  AS total_{{ event_type }}s
  {% endfor %}

{% endmacro %} 
```

With this macro I changed the fact sessions table (from part1) to:
```
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
```

*3. Post hook*
First added the macro as a sql file to the macro folder.
```
{% macro grant(role) %}

    {% set sql %}
      GRANT USAGE ON SCHEMA {{ schema }} TO ROLE {{ role }};
      GRANT SELECT ON {{ this }} TO ROLE {{ role }};
    {% endset %}

    {% set table = run_query(sql) %}

{% endmacro %}
```
Then updated the dbt_project.yml with:

```
models:
  greenery:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: view
    staging:
      +materialized: table
    marts:
      +materialized: table
  post-hook:
    - "GRANT SELECT ON {{ this }} TO reporting"
on-run-end:
  - "GRANT USAGE ON SCHEMA {{ schema }} TO reporting"
  ```

*4. Macro*
Using get_column_values from dbt_utils in the macro described in part 1. This will be useful to avoid hardcoding of events an as we would like to have all events, with this macro we make sure to get always all events.

*5. DAG*
See screenshot

*6. Snapshot*
- ZZ Plant: 89 -> 53
- Monstera: 64 -> 50
- Bamboo: 56 → 44
- Philodendron 25 -> 15
- String of pearls 10 -> 0
- Pothos 20 -> 0