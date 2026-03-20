-- PROJECT: Sales Performance & Profitability Analysis
-- FILE: 03_time_series_analysis.sql
-- OBJECT: Time-series analysis of revenue and profitability across years and months, demonstrating datetime column extraction (STRFTIME), 
-- aggregates (SUM, COUNT DISTINCT), and GROUP BY query skills. The queries identify peak trading periods, measure year-over-year, 
-- month-over-month, and each month of the year-over-year business growth.

-- Format: Business Question + SQL query + Relevant Insights
-- AUTHOR: Faris Beg 

---------------------------------------------------------------------------------------------------------------------------------
-- NOTE: Since we are using SQLite for this project, we will be using STRFTIME() for datetime functions.
-- eg: SQLite - strftime('%Y', date), strftime('%m', date)

-- QUESTION: How did revenue and profit trend year over year?
-- SKILLS: DATE functions, GROUP BY, ORDER BY, SUM
-- WHERE order_date IS NOT NULL #IMPORTANT

SELECT 
    COUNT(DISTINCT(order_id)) AS number_of_orders,

    ROUND(SUM(sales), 2) AS total_annual_revenue,
    ROUND(SUM(profit), 2) AS total_annual_profit,
    ROUND((SUM(profit)/SUM(sales)*100), 2) AS "profit_margin_%",

    STRFTIME('%Y', order_date) AS order_year

from fact_orders
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year asc;

-- Relevant Insights:
-- 2014 data only covers (Jan-Sep, 2014) yet already outperforms all previous years
-- meaning true 2014 annual figures would be significantly higher.


-- QUESTION: Which months consistently generate the most revenue\
-- SKILLS:   DATE functions, GROUP BY, ORDER BY, SUM

SELECT 

    ROUND(SUM(sales), 2) AS total_monthly_revenue,
    ROUND(SUM(profit), 2) AS total_monthly_profit,

    STRFTIME('%m', order_date) AS order_month

from fact_orders

WHERE order_date IS NOT NULL

GROUP BY order_month
order by total_monthly_revenue desc;

-- Relevant Insight: Nov, Dec dominate the revenue generation as holiday months.\
-- Feb and Jan are weakest — typical post-holiday retail slowdown.


-- QUESTION: How does revenue trend across each month of each year? \
-- SKILLS:   DATE functions, GROUP BY multiple columns, ORDER BY \

SELECT  

    COUNT (DISTINCT(order_id)) AS number_of_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,

strftime('%m', order_date) AS month_of_order,
strftime('%Y', order_date) AS year_of_order

from fact_orders

WHERE month_of_order AND year_of_order IS NOT NULL
GROUP BY month_of_order, year_of_order
ORDER BY year_of_order ASC, month_of_order ASC; 

-- Relevant Insight: 
-- November/December spike repeats every year consistently with the difference between seasons measuring up to twice its size.
-- Year on year growth visible within same months across years.