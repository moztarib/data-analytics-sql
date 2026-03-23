-- PROJECT: Sales & Profitability Analysis with SQL and Python 
-- FILE: 06_advanced_analytics.sql
-- OBJECT: Advanced analysis using CTEs, window ranking functions and LAG
--           to answer deeper business questions. We will identify top ranked products
--           and regions, measures year over year profit growth, and surfaces
--           which categories are quietly losing money despite high sales volume..

-- Format: Question + SQL query + Relevant Business Insights
-- AUTHOR: Faris Beg 
----------------------------------------------------------------------------------------------------------------------------------
-- QUESTION: How did profit grow year over year — and by how much? 
-- SKILLS: LAG(), window functions, CTE, date functions, ROUND

WITH yearly_profit AS (
    SELECT
        strftime('%Y', order_date)  AS order_year,
        ROUND(SUM(profit), 2)       AS total_profit
    FROM fact_orders
    WHERE order_date IS NOT NULL
    GROUP BY order_year
    ORDER BY order_year
), 

prev_year_profit AS (

SELECT
    order_year,
    total_profit,
    LAG(total_profit) OVER (ORDER BY order_year)  AS previous_year_profit

FROM yearly_profit)

SELECT 
* ,
ROUND((total_profit - previous_year_profit)/ (previous_year_profit) * 100, 2) AS year_on_year_growth_pct

FROM prev_year_profit;

-- INSIGHT: Profit grew to maximum during 2013 as the strongest year at 32.89% YoY growth and then suffered a hit reaching back 
--          to the levels similar to 2012, in 2014.



-- QUESTION: What are the top 10 most profitable products ?
-- SKILLS:   RANK(), window functions, JOIN, GROUP BY, CTE

-- NOTE: RANK() differs from ORDER BY in that it handles ties explicitly
--       by assigning the same rank to equal values and skipping the next number.

WITH product_profits AS (
    SELECT
        p.product_name,
        p.category,
        p.sub_category,
        ROUND(SUM(f.profit), 2) AS total_profit
    FROM fact_orders f
    JOIN dim_products p ON f.product_id = p.product_id
    GROUP BY p.product_name, p.category, p.sub_category
)
SELECT
    product_name,
    category,
    sub_category,
    total_profit,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank

FROM product_profits
LIMIT 10;

-- INSIGHT: Technology products dominate the top 10 most profitable products.
--          Canon imageCLASS copier alone generates $25,199 profit.
--          Copiers and Phones are the star sub-categories driving profitability.


-- QUESTION: Which regions rank highest in total profit?
-- SKILLS:   DENSE_RANK(), window functions, CTE, JOIN, GROUP BY

WITH region_profits AS (
    SELECT
        l.region AS region_name,
    ROUND(SUM(f.profit), 2) AS total_profit
    FROM fact_orders f
    JOIN dim_locations l ON f.location_id = l.location_id
    GROUP BY l.region
)
SELECT
    region_name,
    total_profit,
    DENSE_RANK() OVER (ORDER BY total_profit DESC) AS profit_rank 

FROM region_profits;

-- Note: Dense_RANK does not skip numbers after a tie 
-- INSIGHT: Central, North, North-Asia are the top 3 profit-generating regions. This verifies the earlier stats we saw in 
--          Exploratory analysis as the same three regions had the highest profit margin percentage.



-- QUESTION: Which sub-categories are losing money despite generating sales?
-- SKILLS:   CTE, RANK(), JOIN, GROUP BY, SUM, CASE WHEN

WITH sub_category_performance AS (
    SELECT
        p.sub_category,
        p.category,
        ROUND(SUM(f.sales), 2)  AS total_sales,
        ROUND(SUM(f.profit), 2) AS total_profit
    FROM fact_orders f
    JOIN dim_products p ON f.product_id = p.product_id
    GROUP BY p.sub_category, p.category
)
SELECT
    sub_category,
    category,
    total_sales,
    total_profit,
    RANK() OVER (ORDER BY total_profit ASC) AS loss_rank,
    CASE
        WHEN total_profit < 0 THEN 'Losing Money'
        ELSE 'Profitable'
    END AS status
FROM sub_category_performance
ORDER BY total_profit ASC;