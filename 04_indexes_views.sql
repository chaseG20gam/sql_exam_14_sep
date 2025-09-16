--create fact tablees

DROP TABLE IF EXISTS dw.fact_order_item CASCADE;
CREATE TABLE dw.fact_order_item (
    fact_id BIGSERIAL PRIMARY KEY,
    src_order_id TEXT NOT NULL,
    order_date DATE,
    ship_date DATE,
    customer_id INT,
    product_id INT,
    shipping_method_id INT,
    order_status_id INT,
    country_id INT,
    city_id INT,
    qty dw.dom_qty,
    unit_price dw.dom_money,
    discount dw.dom_money,
    extended_price dw.dom_money,
    -- checks
    CHECK (extended_price >= 0),
    CHECK (discount <= unit_price)
);
-- 2 insert data in fact tables, test with dimension IDs 

INSERT INTO dw.fact_order_item (
    src_order_id, order_date, ship_date,
    customer_id, product_id, shipping_method_id,
    order_status_id, country_id, city_id,
    qty, unit_price, discount, extended_price
)
SELECT
    oi.order_id,
    NULLIF(o.order_date, '')::DATE,
    NULLIF(o.ship_date, '')::DATE,
    dc.customer_id,
    dp.product_id,
    sm.shipping_method_id,
    st.order_status_id,
    dc.country_id,
    dc.city_id,
    -- measurements
    NULLIF(REPLACE(oi.quantity, ',', '.'), '')::NUMERIC(12,2)::INT,
    REPLACE(REPLACE(NULLIF(oi.unit_price, ''), '€',''), ',', '.')::NUMERIC(12,2),
    COALESCE(REPLACE(REPLACE(NULLIF(oi.discount, ''), '€',''), ',', '.')::NUMERIC(12,2), 0),
    (
      (NULLIF(REPLACE(oi.quantity, ',', '.'), '')::NUMERIC(12,2)::INT) *
      (REPLACE(REPLACE(NULLIF(oi.unit_price, ''), '€',''), ',', '.')::NUMERIC(12,2)
       - COALESCE(REPLACE(REPLACE(NULLIF(oi.discount, ''), '€',''), ',', '.')::NUMERIC(12,2), 0))
    )::NUMERIC(12,2)
FROM dw.raw_order_items oi
LEFT JOIN dw.raw_orders o
       ON oi.order_id = o.order_id
LEFT JOIN dw.dim_product dp
       ON dp.src_product_id = oi.product_id
LEFT JOIN dw.dim_customer dc
       ON dc.src_customer_id = o.customer_id
LEFT JOIN dw.dim_shipping_method sm
       ON sm.shipping_method = LOWER(TRIM(o.shipping_method))
LEFT JOIN dw.dim_order_status st
       ON st.order_status = LOWER(TRIM(o.order_status));


-- 3 add the foreign keys (breathe...)

ALTER TABLE dw.fact_order_item
    ADD CONSTRAINT fk_fact_customer FOREIGN KEY (customer_id)
        REFERENCES dw.dim_customer(customer_id);

ALTER TABLE dw.fact_order_item
    ADD CONSTRAINT fk_fact_product FOREIGN KEY (product_id)
        REFERENCES dw.dim_product(product_id);

ALTER TABLE dw.fact_order_item
    ADD CONSTRAINT fk_fact_shipping FOREIGN KEY (shipping_method_id)
        REFERENCES dw.dim_shipping_method(shipping_method_id);

ALTER TABLE dw.fact_order_item
    ADD CONSTRAINT fk_fact_status FOREIGN KEY (order_status_id)
        REFERENCES dw.dim_order_status(order_status_id);

ALTER TABLE dw.fact_order_item
    ADD CONSTRAINT fk_fact_country FOREIGN KEY (country_id)
        REFERENCES dw.dim_country(country_id);

ALTER TABLE dw.fact_order_item
    ADD CONSTRAINT fk_fact_city FOREIGN KEY (city_id)
        REFERENCES dw.dim_city(city_id);

-- pretty extense, tedious. had to search up for references (references at README)
-- debugging with the duck (mostly) and copilot (last resort to mantain some sanity)
-- checked the scrips integrity, seems to work fine (yay!)
-- end (finally)