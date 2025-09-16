
-- 1. create all label dimension tables and populate them

-- category dim
DROP TABLE IF EXISTS dw.dim_category CASCADE;
CREATE TABLE dw.dim_category (
    category_id SERIAL PRIMARY KEY,
    category    TEXT NOT NULL UNIQUE
);

INSERT INTO dw.dim_category (category)
SELECT DISTINCT LOWER(TRIM(category))
FROM dw.raw_products
WHERE category IS NOT NULL AND TRIM(category) <> '';

DROP TABLE IF EXISTS dw.dim_brand CASCADE;
CREATE TABLE dw.dim_brand (
    brand_id SERIAL PRIMARY KEY,
    brand    TEXT NOT NULL UNIQUE
);

-- brand dim
INSERT INTO dw.dim_brand (brand)
SELECT DISTINCT LOWER(TRIM(brand))
FROM dw.raw_products
WHERE brand IS NOT NULL AND TRIM(brand) <> '';

DROP TABLE IF EXISTS dw.dim_country CASCADE;
CREATE TABLE dw.dim_country (
    country_id SERIAL PRIMARY KEY,
    country    TEXT NOT NULL UNIQUE
);

INSERT INTO dw.dim_country (country)
SELECT DISTINCT LOWER(TRIM(country))
FROM dw.raw_customers
WHERE country IS NOT NULL AND TRIM(country) <> '';

DROP TABLE IF EXISTS dw.dim_city CASCADE;
CREATE TABLE dw.dim_city (
    city_id SERIAL PRIMARY KEY,
    city    TEXT NOT NULL UNIQUE
);

-- city dim
INSERT INTO dw.dim_city (city)
SELECT DISTINCT LOWER(TRIM(city))
FROM dw.raw_customers
WHERE city IS NOT NULL AND TRIM(city) <> '';

DROP TABLE IF EXISTS dw.dim_shipping_method CASCADE;
CREATE TABLE dw.dim_shipping_method (
    shipping_method_id SERIAL PRIMARY KEY,
    shipping_method    TEXT NOT NULL UNIQUE
);

INSERT INTO dw.dim_shipping_method (shipping_method)
SELECT DISTINCT LOWER(TRIM(shipping_method))
FROM dw.raw_orders
WHERE shipping_method IS NOT NULL AND TRIM(shipping_method) <> '';

-- order status dim
DROP TABLE IF EXISTS dw.dim_order_status CASCADE;
CREATE TABLE dw.dim_order_status (
    order_status_id SERIAL PRIMARY KEY,
    order_status    TEXT NOT NULL UNIQUE
);

INSERT INTO dw.dim_order_status (order_status)
SELECT DISTINCT LOWER(TRIM(order_status))
FROM dw.raw_orders
WHERE order_status IS NOT NULL AND TRIM(order_status) <> '';

-------------------------------------------------------
-- dimensions with its origin key

-- costumers
DROP TABLE IF EXISTS dw.dim_customer CASCADE;
CREATE TABLE dw.dim_customer (
    customer_id SERIAL PRIMARY KEY,
    src_customer_id TEXT NOT NULL UNIQUE,
    name TEXT,
    email TEXT,
    signup_date DATE,
    country_id INT NOT NULL REFERENCES dw.dim_country(country_id),
    city_id INT NOT NULL REFERENCES dw.dim_city(city_id)
);

INSERT INTO dw.dim_customer (src_customer_id, name, email, signup_date, country_id, city_id)
SELECT DISTINCT
    c.customer_id,
    TRIM(c.name),
    LOWER(TRIM(c.email)),
    NULLIF(c.signup_date, '')::DATE,
    cn.country_id,
    ci.city_id
FROM dw.raw_customers c
JOIN dw.dim_country cn ON LOWER(TRIM(c.country)) = cn.country
JOIN dw.dim_city ci ON LOWER(TRIM(c.city)) = ci.city
WHERE c.customer_id IS NOT NULL AND TRIM(c.customer_id) <> '';

-------------------------------------------------------

-- products
DROP TABLE IF EXISTS dw.dim_product CASCADE;
CREATE TABLE dw.dim_product (
    product_id SERIAL PRIMARY KEY,
    src_product_id TEXT NOT NULL UNIQUE,
    sku TEXT,
    product_name TEXT,
    category_id INT NOT NULL REFERENCES dw.dim_category(category_id),
    brand_id INT NOT NULL REFERENCES dw.dim_brand(brand_id),
    price dw.dom_money,
    list_price dw.dom_money
);

INSERT INTO dw.dim_product (src_product_id, sku, product_name, category_id, brand_id, price, list_price)
SELECT DISTINCT
    p.product_id,
    TRIM(p.sku),
    TRIM(p.product_name),
    c.category_id,
    b.brand_id,
    REPLACE(REPLACE(TRIM(p.price), '€',''), ',','.')::NUMERIC(12,2),
    REPLACE(REPLACE(TRIM(p.list_price), '€',''), ',','.')::NUMERIC(12,2). -- basic conversion of momney
FROM dw.raw_products p
JOIN dw.dim_category c ON LOWER(TRIM(p.category)) = c.category
JOIN dw.dim_brand b ON LOWER(TRIM(p.brand)) = b.brand
WHERE p.product_id IS NOT NULL AND TRIM(p.product_id) <> '';

-- end
