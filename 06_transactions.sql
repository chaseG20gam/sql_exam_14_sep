-- 4 views
-- with the last indexes, the views appear more friendly and analytics focused

-- detailed view od order items with clear labels
DROP VIEW IF EXISTS dw.v_order_item CASCADE;
CREATE VIEW dw.v_order_item AS
SELECT
    f.fact_id,
    f.src_order_id,
    f.order_date,
    f.ship_date,
    c.name AS customer_name,
    c.email AS customer_email,
    cat.category AS category,
    b.brand AS brand,
    p.product_name AS product_name,
    cn.country AS country,
    ci.city AS city,
    sm.shipping_method,
    st.order_status,
    f.qty,
    f.unit_price,
    f.discount,
    f.extended_price
FROM dw.fact_order_item f
LEFT JOIN dw.dim_customer c ON f.customer_id = c.customer_id
LEFT JOIN dw.dim_product p ON f.product_id = p.product_id
LEFT JOIN dw.dim_category cat ON p.category_id = cat.category_id
LEFT JOIN dw.dim_brand b ON p.brand_id = b.brand_id
LEFT JOIN dw.dim_country cn ON f.country_id = cn.country_id
LEFT JOIN dw.dim_city ci ON f.city_id = ci.city_id
LEFT JOIN dw.dim_shipping_method sm ON f.shipping_method_id = sm.shipping_method_id
LEFT JOIN dw.dim_order_status st ON f.order_status_id = st.order_status_id;

-- why: gives the facts table with descriptive labels and ready for queries without manual joins needed

-------------------------------------------------------

-- view of monthly sells by category
DROP VIEW IF EXISTS dw.v_sales_by_category_month CASCADE;
CREATE VIEW dw.v_sales_by_category_month AS
SELECT
    cat.category,
    TO_CHAR(DATE_TRUNC('month', f.order_date), 'YYYY-MM') AS yyyymm,
    COUNT(DISTINCT f.src_order_id) AS n_orders,
    SUM(f.extended_price) AS revenue,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY f.extended_price) 
        AS median_ticket
FROM dw.fact_order_item f
JOIN dw.dim_product p ON f.product_id = p.product_id
JOIN dw.dim_category cat ON p.category_id = cat.category_id
WHERE f.order_date IS NOT NULL
GROUP BY cat.category, TO_CHAR(DATE_TRUNC('month', f.order_date), 'YYYY-MM')
ORDER BY cat.category, yyyymm;

-- why: allows monthly analysis of sells by category, including order count and total revenue
-- duck really helped me out in this one...

-- end

