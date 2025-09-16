# Mini E-Commerce Data Warehouse

This project builds a small e-commerce Data Warehouse in PostgreSQL (Docker + pgAdmin).  

**Key Ideas & Decisions:**  
- All CSVs may be messy (extra spaces, mixed cases, currency symbols).  
- A dedicated `dw` schema keeps things organized.  
- Domains ensure minimal quality for money, quantity, and clean text.  
- Dimensions have unique, non-null values; fact table links to them via foreign keys.  
- Inline normalization (`LOWER`, `TRIM`, `REPLACE`) cleans data during loading.  
- Fact table stores quantities, prices, discounts, and extended price, with basic checks.  

**Indexes & Views:**  
- Indexed dimension values and key fact columns for fast queries.  
- `v_order_item` shows human-readable order info; `v_sales_by_category_month` provides monthly sales, revenue, and median ticket by category.  

**How to Run:**  
1. `01_schema_domains.sql` → create schema & domains  
2. `02_staging_copy.sql` → create RAW tables & load CSVs  
3. `03_dims_fact.sql` → build dimensions & fact table  
4. `04_indexes_views.sql` → create indexes & views  

## References
- [PostgreSQL Documentation](https://www.postgresql.org/docs)
- [Stack Overflow](https://stackoverflow.com)
- [PostgreSQL Subreddit] (https://www.reddit.com/r/PostgreSQL)
- Thanks to my rubber duck.
- Thanks to Oscar for the attention.