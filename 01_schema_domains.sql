
-- 01_schema_domains.sql
-- 1 delete public schema if exists
DROP SCHEMA IF EXISTS public CASCADE;

-- 2 create new schema for the ecommerce 
CREATE SCHEMA IF NOT EXISTS dw;

-- 3 define reusable domains to better access data in the futire 

-- money: positive money values with two decimals
CREATE DOMAIN dw.dom_money AS NUMERIC(12,2)
  CHECK (VALUE >= 0);

-- quantity: positive integers or zero
CREATE DOMAIN dw.dom_qty AS INT
  CHECK (VALUE >= 0);

-- clean text: without whitespaces
-- cant figure out how to do it simply with a check so im just gonna set a trim restriction (at least)
CREATE DOMAIN dw.dom_text_clean AS TEXT
  CHECK (VALUE IS NULL OR char_length(trim(VALUE)) > 0);

-- end