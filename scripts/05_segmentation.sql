-- PROJECT: Sales & Profitability Analysis with SQL and Python 
-- FILE: 05_segmentation.sql
-- OBJECT:  Segment customers and products into meaningful business categories
--          using CASE WHEN logic. To Identify high value customers, top performing
--          products and loss-making items draining company profitability.

-- Format: Question + SQL query + Relevant Business Insights
-- AUTHOR: Faris Beg 

----------------------------------------------------------------------------------------------------------------------------------
-- QUESTION: Which products are high, mid or low performers
--           based on total profit generated?
-- SKILLS:   CASE WHEN, GROUP BY, JOIN, SUM, ORDER BY

SELECT
p.product_name,
p.category,
ROUND(SUM(f.profit), 2) AS total_profit,
    CASE
        WHEN SUM(f.profit) > 5000  THEN 'High Performer'
        WHEN SUM(f.profit) > 1000  THEN 'Mid Performer'
        WHEN SUM(f.profit) > 0     THEN 'Low Performer'
        ELSE 'Losing Money'
    END AS performance_segment

FROM fact_orders f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_profit DESC;

-- QUESTION: How many products fall into each performance segment?
-- SKILLS:   CASE WHEN, subquery, GROUP BY, COUNT

SELECT
performance_segment,
COUNT(*) AS number_of_products
FROM 
(
SELECT
    p.product_name,
    ROUND(SUM(f.profit), 2) AS total_profit,
    CASE
        WHEN SUM(f.profit) > 5000 THEN 'High Performer'
        WHEN SUM(f.profit) > 1000 THEN 'Mid Performer'
        WHEN SUM(f.profit) > 0    THEN 'Low Performer'
        ELSE 'Losing Money'
        END AS performance_segment

FROM fact_orders f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.product_name
) AS product_segments
GROUP BY performance_segment
ORDER BY number_of_products DESC;

-- INSIGHT: Only 41 high performing products drive the majority of profit.
--          674 products actively lose money which is ~ 7% of total product catalogue.
--          Business should review pricing or discontinue some products.




-- QUESTION: Which customers are VIP, Loyal, Regular or Occasional
--           based on total revenue generated?
-- SKILLS:   CASE WHEN, GROUP BY, JOIN, SUM, ORDER BY

SELECT
    c.customer_name,
    ROUND(SUM(f.sales), 2) AS total_revenue,
        CASE
            WHEN SUM(f.sales) > 10000 THEN 'VIP'
            WHEN SUM(f.sales) > 5000 THEN 'Loyal'
            WHEN SUM(f.sales) > 1000 THEN 'Regular'
            ELSE 'Occasional'
    END AS performance_segment
FROM fact_orders f
JOIN dim_customers c ON f.customer_name = c.customer_name
GROUP BY c.customer_name
ORDER BY total_revenue DESC;

-- QUESTION: How many customers fall into each value segment?
-- SKILLS:   subquery, CASE WHEN, , GROUP BY, COUNT

SELECT
    performance_segment,
    COUNT(*) AS number_of_customers
FROM (
SELECT
    c.customer_name,
    ROUND(SUM(f.sales), 2) AS total_revenue,
        CASE
            WHEN SUM(f.sales) > 10000 THEN 'VIP'
            WHEN SUM(f.sales) > 5000 THEN 'Loyal'
            WHEN SUM(f.sales) > 1000 THEN 'Regular'
            ELSE 'Occasional'
    END AS performance_segment
FROM fact_orders f
JOIN dim_customers c ON f.customer_name = c.customer_name
GROUP BY c.customer_name
) AS customer_segments
GROUP BY performance_segment
ORDER BY number_of_customers DESC;

-- INSIGHT: 373 VIP and 399 Loyal customers make up virtually the entire base.
--          Zero occasional customers suggests a B2B focused business model.
--          Retaining top customers is critical. Losing one VIP will affect business significantly.