SELECT 
    t.product_category_name_english AS category,
    COUNT(*) AS cancellation_count
FROM 
    orders AS o
INNER JOIN 
    order_items AS i ON o.order_id = i.order_id
INNER JOIN 
    products AS p ON i.product_id = p.product_id
INNER JOIN 
    product_category_name_translation AS t ON p.product_category_name = t.product_category_name
WHERE 
    o.order_status = 'canceled'
GROUP BY 
    category
ORDER BY 
    cancellation_count DESC
LIMIT 10;