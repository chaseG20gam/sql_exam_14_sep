
-- index part, intended for optimizing frequent or common queries
-- 1 indexes on dimensions

CREATE INDEX idx_dim_category_value
  ON dw.dim_category(category);
-- why: makes queries easier, category filters (ex. sales by category)

CREATE INDEX idx_dim_brand_value
  ON dw.dim_brand(brand);
-- why: speeds up queries of sales grouped by brand

CREATE INDEX idx_dim_country_value
  ON dw.dim_country(country);
-- why: supports queries by country as well as clients analysis and rsales by region

CREATE INDEX idx_dim_city_value
  ON dw.dim_city(city);
--why: useful to add segmentations to sales and customers at city level

CREATE INDEX idx_dim_shipping_method_value
  ON dw.dim_shipping_method(shipping_method);
-- why: improved filteriing by shipping method type of queries

CREATE INDEX idx_dim_order_status_value
  ON dw.dim_order_status(order_status);
-- speeds up queries filtering by order status


-- 2 fact tables indexes

CREATE INDEX idx_fact_customer
  ON dw.fact_order_item(customer_id);
-- speeds up queries of custoer order history

CREATE INDEX idx_fact_product
  ON dw.fact_order_item(product_id);
--improves sales and quantities selled by product type of queries

CREATE INDEX idx_fact_order_date
  ON dw.fact_order_item(order_date);
-- essential for time analysis

CREATE INDEX idx_fact_country
  ON dw.fact_order_item(country_id);
-- supports queries grouped by countries

CREATE INDEX idx_fact_city
  ON dw.fact_order_item(city_id);


CREATE INDEX idx_fact_unit_price
  ON dw.fact_order_item(unit_price);


CREATE INDEX idx_fact_extended_price
  ON dw.fact_order_item(extended_price);
-- overall optimization

-- =======================================================
-- 3 pure identity

CREATE INDEX idx_fact_order_status
  ON dw.fact_order_item(order_status_id);

CREATE INDEX idx_fact_shipping_method
  ON dw.fact_order_item(shipping_method_id);

-- end