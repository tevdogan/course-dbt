*What is the repeat rate?*
79.84%

```
WITH users_order_counts AS (
    SELECT user_id, 
    COUNT(*) AS order_count
    FROM dev_db.dbt_tevhidedoganmolliecom.stg_postgres_orders 
    GROUP BY 1

)
SELECT
COUNT(CASE WHEN order_count>=2 THEN 1 ELSE NULL END) / COUNT(user_id) AS repeat_rate 
FROM users_order_counts
```

*What are good indicators of a user who will likely purchase again?*
- Number of orders
- Number of user sessions
- Time between orders
- Time spent on website
- Access to promo code

*What about indicators of users who are likely NOT to purchase again?* 
- Unstatisfactory customer experience like: 
    - Late delivery
    - Out of stock
    - Order cancellation

*If you had more data, what features would you want to look into to answer this question?*
- Returns
- Items added to favorite / basket

*Product marts*
Added the intermediate models to have the daily events per product ( as well as per user, only not used further. To be used in a marketing model).
Combined with the product data, to have a final fact table with number of views and orders per day per product

*Tests*
Added for now only the test on the page views for positive values. It should not be possible to have a record for a product without a view in the fact table per this setup.

*Snapshot*
The following products are updated:
- Pothos
- Philodendron
- Monstera
- String of pearls


```
select distinct name from dev_db.dbt_tevhidedoganmolliecom.products_snapshot
```