WITH brasilia_orders AS (
    SELECT o.order_id
    FROM orders AS o
    INNER JOIN customers AS c ON o.customer_id = c.customer_id
    WHERE c.customer_state = 'DF' -- https://en.wikipedia.org/wiki/Federal_District_(Brazil)
)

SELECT 
    t.product_category_name_english AS product_category_name,
    COUNT(r.review_id) AS review_count
FROM order_reviews AS r
INNER JOIN orders AS o 
    ON r.order_id = o.order_id
INNER JOIN order_items AS i 
    ON o.order_id = i.order_id
INNER JOIN products AS p 
    ON i.product_id = p.product_id
INNER JOIN product_category_name_translation AS t 
    ON p.product_category_name = t.product_category_name
WHERE o.order_id IN (SELECT order_id FROM brasilia_orders)
GROUP BY 
    t.product_category_name_english
ORDER BY 
    review_count DESC
LIMIT 10;