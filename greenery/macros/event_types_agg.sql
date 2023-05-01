{% macro event_types_agg() %} 

 {% set event_types = dbt_utils.get_column_values(
    table=ref('stg_postgres_events')
    , column='event_type'
 ) %}

  {% for event_type in event_types  %}
      , SUM(CASE WHEN event_type = '{{ event_type }}' THEN 1 ELSE 0 END)  AS total_{{ event_type }}s
  {% endfor %}

{% endmacro %} 