SELECT 
    c.customer_state AS state,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value
FROM 
    order_payments AS p
JOIN 
    orders AS o ON p.order_id = o.order_id
JOIN 
    customers AS c ON o.customer_id = c.customer_id
GROUP BY 
    c.customer_state
ORDER BY 
    avg_order_value DESC;

-- Суммы заказов по штату PB (наибольший средний чек)
SELECT 
    p.payment_value
FROM 
    orders AS o
INNER JOIN 
    order_payments AS p ON o.order_id = p.order_id
INNER JOIN 
    customers AS c ON o.customer_id = c.customer_id
INNER JOIN 
    order_items AS oi ON o.order_id = oi.order_id
INNER JOIN 
    products AS pr ON oi.product_id = pr.product_id
WHERE 
    c.customer_state = 'PB'
ORDER BY 
    o.order_purchase_timestamp DESC;