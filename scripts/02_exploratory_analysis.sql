-- PROJECT: Sales & Profitability Analysis with SQL and Python 
-- FILE: 02_exploratory_analysis.sql
-- OBJECT: Initial exploration of the SuperStore database. Understanding the shape, range, scale of the data 
--         while demonstrating basic SQL queries skills (SELECT, COUNT, ROUND, SUM, DISTINCT) alongside GROUP BY, JOIN etc.

-- Format: Question + SQL query + Business Insights
-- AUTHOR: Faris Beg 

---------------------------------------------------------------------------------------------------------------------------
-- QUESTION: What is the DATE RANGE of the sales data?
-- SKILLS:   SELECT, MIN, MAX, aggregate functions

SELECT 
    MIN(order_date) AS FIRST_ORDER, 
    MAX (order_date) AS LAST_ORDER, 
    COUNT(DISTINCT (year)) AS YEARS_PASSED 

from fact_orders;
-- Insight: Our time-based analysis goes between January 2011 and December 2014.


-- QUESTION: What is the OVERALL SCALE of the business? (Metrics on orders, customers, products, profit etc.)
-- SKILLS:   COUNT DISTINCT, SUM, ROUND, aggregate functions

SELECT 
    COUNT (order_id) AS total_orders_placed, 
    COUNT (DISTINCT(customer_name)) AS total_customers,
    COUNT (DISTINCT(product_id)) AS total_products_sold,

    ROUND (SUM (sales), 2) AS generated_revenue,
    ROUND (SUM(profit), 2) AS "total_profit",
    ROUND((SUM(profit)/SUM (sales))*100, 2) AS "%_profit_margin"

FROM fact_orders;


-- QUESTION: Which REGIONS generate the most revenue and profit?
-- SKILLS:   GROUP BY, ORDER BY, SUM, ROUND, JOIN

SELECT 
    l.region AS Region, 
    ROUND(SUM(f.sales), 2) AS generated_revenue,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND((SUM(f.profit)/SUM(f.sales) *100), 2) AS profit_margin_percentage

FROM fact_orders f

JOIN dim_locations l ON f.location_id = l.location_id
GROUP BY Region
ORDER BY total_profit desc;

-- Insight: 
-- Central region dominates in both revenue AND profit, though not in profit margin (17.24%).
-- Southeast Asia has $532 k revenue but only $17 k profit with the lowest (3.3%) profit margin, reaching an almost "breaking even" stage.


-- QUESTION: Which PRODUCTS categories are most and least profitable?
-- SKILLS:   GROUP BY, JOIN, SUM, ROUND, ORDER BY

SELECT 
    p.category AS product_category,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND(SUM(f.sales), 2) AS total_revenue,
    ROUND((SUM(f.profit)/SUM(f.sales)*100), 2) AS "profit_margin_%"

FROM dim_products p

JOIN fact_orders f ON p.product_id = f.product_id
GROUP BY product_category
ORDER BY total_profit desc;

-- Insight: 
-- Furniture generates the second highest revenue but has the worst profit margin (11.92%) by far.
-- Technology leads in profit with only 25% margin — most efficient category. 



