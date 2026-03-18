-- FILE: 00_database_setup.sql
-- PROJECT: SuperStore Sales Analytics with SQL and Python
-- 
-- This file documents the star schema built from the raw SuperStore CSV in the Jupyter notebook 01_load_data.ipynb

-- Following is the Schema structure:
--   dim_customers  ──┐
--                    ├──▶ fact_orders ◀── dim_products
--   dim_locations  ──┘


-- Dimension table: customers
-- Primary key: customer_name
CREATE TABLE "dim_customers" (
"customer_name" TEXT,
  "segment" TEXT
);


-- Dimension table: products
-- Primary key: product_id
CREATE TABLE "dim_products" (
"product_id" TEXT,
  "product_name" TEXT,
  "category" TEXT,
  "sub_category" TEXT
);


-- Dimension table: locations
-- Primary key: location_id (surrogate key — generated in the notebook)
CREATE TABLE "dim_locations" (
"location_id" INTEGER,
  "state" TEXT,
  "country" TEXT,
  "market" TEXT,
  "region" TEXT
);


-- Fact table: orders
-- One row per order line item
-- Foreign keys: customer_name → dim_customers
--               product_id   → dim_products
--               location_id  → dim_locations
CREATE TABLE "fact_orders" (
"order_id" TEXT,
  "order_date" TEXT,
  "ship_date" TEXT,
  "ship_mode" TEXT,
  "sales" REAL,
  "quantity" INTEGER,
  "discount" REAL,
  "profit" REAL,
  "shipping_cost" REAL,
  "order_priority" TEXT,
  "year" INTEGER,
  "customer_name" TEXT,
  "product_id" TEXT,
  "location_id" INTEGER
);