TRUNCATE TABLE customers CASCADE;
\copy customers FROM 'csv_tables/olist_customers_dataset.csv' DELIMITER ',' CSV HEADER;

TRUNCATE TABLE geolocation CASCADE;
\copy geolocation FROM 'csv_tables/olist_geolocation_dataset.csv' DELIMITER ',' CSV HEADER;

TRUNCATE TABLE orders CASCADE;
\copy orders FROM 'csv_tables/olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;

TRUNCATE TABLE order_items CASCADE;
\copy order_items FROM 'csv_tables/olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;

TRUNCATE TABLE order_payments CASCADE;
\copy order_payments FROM 'csv_tables/olist_order_payments_dataset.csv' DELIMITER ',' CSV HEADER;

-- В order_reviews были дубликаты, по этой причине требовалось создать временную таблицу
TRUNCATE TABLE order_reviews CASCADE;

BEGIN;
CREATE TEMP TABLE tmp_table 
(LIKE order_reviews INCLUDING DEFAULTS)
ON COMMIT DROP;
    
\copy tmp_table FROM 'csv_tables/olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;
    
INSERT INTO order_reviews
SELECT *
FROM tmp_table
ON CONFLICT DO NOTHING;
COMMIT;

TRUNCATE TABLE products CASCADE;
\copy products FROM 'csv_tables/olist_products_dataset.csv' DELIMITER ',' CSV HEADER;

TRUNCATE TABLE sellers CASCADE;
\copy sellers FROM 'csv_tables/olist_sellers_dataset.csv' DELIMITER ',' CSV HEADER;

TRUNCATE TABLE product_category_name_translation CASCADE;
\copy product_category_name_translation FROM 'csv_tables/product_category_name_translation.csv' DELIMITER ',' CSV HEADER;