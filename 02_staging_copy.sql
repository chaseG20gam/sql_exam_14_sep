-- 02_staging_copy.sql
-- 1 create the raw tables for each dataset
-- customers
DROP TABLE IF EXISTS dw.raw_customers CASCADE;
CREATE TABLE dw.raw_customers (
    customer_id TEXT,
    name TEXT,
    email TEXT,
    signup_date TEXT,
    country TEXT,
    city TEXT,
    postal_code TEXT
);

-- products
DROP TABLE IF EXISTS dw.raw_products CASCADE;
CREATE TABLE dw.raw_products (
    product_id TEXT,
    sku TEXT,
    product_name TEXT,
    category TEXT,
    brand TEXT,
    price TEXT,
    list_price TEXT
);

-- orders
DROP TABLE IF EXISTS dw.raw_orders CASCADE;
CREATE TABLE dw.raw_orders (
    order_id TEXT,
    customer_id TEXT,
    order_date TEXT,
    ship_date TEXT,
    shipping_method TEXT,
    order_status TEXT
);

-- order items
DROP TABLE IF EXISTS dw.raw_order_items CASCADE;
CREATE TABLE dw.raw_order_items (
    order_id TEXT,
    product_id TEXT,
    quantity TEXT,
    unit_price TEXT,
    discount TEXT
);

-- 2 copy the csv files to their own tables
-- customers
COPY dw.raw_customers
	FROM '/backups/75EP2176_2_Prueba_practica_UF2176/customers.csv' 
	CSV HEADER 
	DELIMITER ',' 
	ESCAPE '\';

-- products
COPY dw.raw_products
	FROM '/backups/75EP2176_2_Prueba_practica_UF2176/products.csv' 
	CSV HEADER 
	DELIMITER ',' 
	ESCAPE '\';

-- orders
COPY dw.raw_orders
	FROM '/backups/75EP2176_2_Prueba_practica_UF2176/orders.csv' 
	CSV HEADER 
	DELIMITER ',' 
	ESCAPE '\';

-- order items
COPY dw.raw_order_items
	FROM '/backups/75EP2176_2_Prueba_practica_UF2176/order_items.csv' 
	CSV HEADER 
	DELIMITER ',' 
	ESCAPE '\';

-- 3 row count of each raw table to ensure table integrity
SELECT 'raw_customers' AS table_name, COUNT(*) AS row_count FROM dw.raw_customers
UNION ALL
SELECT 'raw_products', COUNT(*) FROM dw.raw_products
UNION ALL
SELECT 'raw_orders', COUNT(*) FROM dw.raw_orders
UNION ALL
SELECT 'raw_order_items', COUNT(*) FROM dw.raw_order_items;

-- end