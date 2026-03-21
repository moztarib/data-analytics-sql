-- PROJECT: Sales & Profitability Analysis with SQL and Python 
-- FILE: 04_cumulative_analysis.sql
-- OBJECT: 

-- Format: Business Question + SQL query + Relevant Insights
-- AUTHOR: Faris Beg 

------------------------------------------------------------------------------------------------------------------------------------
-- NOTE: aliases cannot be used inside OVER() — SQL evaluates window functions
--       before aliases are assigned, so the full expression must be repeated


-- QUESTION: How does cumulative revenue build up month by month across all years to show overall business growth trajectory?
-- SKILLS:   Window functions, SUM() OVER(), ORDER BY, DATE functions

SELECT 

ROUND(SUM (sales), 2) AS total_monthly_revenue, 

STRFTIME('%m', order_date) AS month_of_order,
STRFTIME('%Y', order_date) AS year_of_order,

ROUND(SUM(SUM(sales)) OVER  --inner SUM is the aggregate function for monthly total. Outer SUM is the total_running function adding each value subsequently.
                        (ORDER BY STRFTIME('%Y', order_date), STRFTIME('%m', order_date) --WE ARE SAYING THAT WE NEED TO ADD VALUES ON TOP OF EACH OTHER STARTING FROM LOWEST OF THE YEAR AND LOWEST OF THE MONTH AND BUILDING UP WITH INCREAsING.
                                         -- The window is like a moving avergae window.
                                         -- order by year always before order by month

from fact_orders
WHERE order_date IS NOT NULL --IMPORTANT
GROUP BY year_of_order, month_of_order --Year must be grouped and ordered before month otherwise all the january for each year will appear first
ORDER BY year_of_order, month_of_order;    

-- INSIGHT: Cumulative revenue grows consistently with no flat periods.
--          Final running total of $7,835,128 confirms accuracy against total revenue from exploratory analysis.
--          Steepest growth visible in 2013-2014 period.



-- QUESTION: How does revenue accumulate within each individual year?
-- SKILLS:   Window functions, SUM() OVER(), PARTITION BY

SELECT 
    STRFTIME('%Y', order_date) AS order_year,
    STRFTIME('%m', order_date) AS order_month,

    ROUND(SUM(sales), 2) AS total_monthly_revenue,

    ROUND(SUM(SUM(sales)) OVER 
                            (PARTITION BY STRFTIME('%Y', order_date)
                            ORDER BY STRFTIME('%m', order_date) ) , 2) AS running_total_per_year
    
from fact_orders
WHERE order_date IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month;    

-- NOTE: Partition by Year, order by Month
--       Here, we are saying instead of adding each value on top of another beginning from lowest year/month,
--       we begin at the beginning of each year and keep adding more values as the months increase.

-- INSIGHT: Annual revenue grows significantly each year.
--          2011 closed at $1.37M, 2014 reached $2.67M by September only.
--          Each year the running total accelerates faster. Business is scaling.
 