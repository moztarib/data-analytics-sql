-- PROJECT: Sales & Profitability Analysis with SQL and Python 
-- FILE: 07_reports.sql
-- OBJECT: We will consolidate all analysis into two reusable views — one for products and one for customers — that can be queried 
-- instantly without rewriting complex joins and aggregations every time..

-- Author: Faris Beg
----------------------------------------------------------------------------------------------------------------------------------
-- 1. report_products VIEW

CREATE VIEW IF NOT EXISTS report_products AS

WITH product_summary AS (
    SELECT
        p.product_name,
        p.category,
        p.sub_category,
        COUNT(DISTINCT f.order_id)   AS total_orders,
        ROUND(SUM(f.sales), 2)       AS total_revenue,
        ROUND(SUM(f.profit), 2)      AS total_profit,
        ROUND(SUM(f.profit) /
              SUM(f.sales) * 100, 2) AS profit_margin_pct,
        MIN(f.order_date)            AS first_order,
        MAX(f.order_date)            AS last_order
    FROM fact_orders f
    JOIN dim_products p ON f.product_id = p.product_id
    GROUP BY p.product_name, p.product_category
)
SELECT
    product_name,
    product_category,
    sub_category,
    total_orders,
    total_revenue,
    total_profit,
    profit_margin_pct,
    first_order,
    last_order,
    CASE
        WHEN total_profit > 10000 THEN 'High Performer'
        WHEN total_profit > 5000  THEN 'Mid Performer'
        WHEN total_profit > 1000  THEN 'Low performer'
        ELSE 'Losing Money'
    END AS product_segment
FROM product_summary
ORDER BY total_profit DESC;


---2. report_customers VIEW
CREATE VIEW IF NOT EXISTS report_customers AS

WITH customer_summary AS (
    SELECT
        c.customer_name,
        c.segment,
        COUNT(DISTINCT f.order_id)   AS total_orders,
        ROUND(SUM(f.sales), 2)       AS total_revenue,
        ROUND(SUM(f.profit), 2)      AS total_profit,
        ROUND(SUM(f.profit) /
              SUM(f.sales) * 100, 2) AS profit_margin_pct,
        MIN(f.order_date)            AS first_order,
        MAX(f.order_date)            AS last_order
    FROM fact_orders f
    JOIN dim_customers c ON f.customer_name = c.customer_name
    GROUP BY c.customer_name, c.segment
)
SELECT
    customer_name,
    segment,
    total_orders,
    total_revenue,
    total_profit,
    profit_margin_pct,
    first_order,
    last_order,
    CASE
        WHEN total_revenue > 10000 THEN 'VIP'
        WHEN total_revenue > 5000  THEN 'Loyal'
        WHEN total_revenue > 1000  THEN 'Regular'
        ELSE 'Occasional'
    END AS customer_segment
FROM customer_summary
ORDER BY total_revenue DESC;




