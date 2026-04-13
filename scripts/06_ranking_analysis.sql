/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - Rank items (products, customers) based on performance metrics
    - Identify top performers and low performers

SQL Functions Used:
    - Window Functions: RANK(), ROW_NUMBER()
    - Aggregation: SUM(), COUNT()
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- ============================================================
-- 1. Top 5 Products Generating Highest Revenue (Simple Ranking)
-- ============================================================

SELECT 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_fact_sales AS f
LEFT JOIN gold_dim_products AS p
    ON f.product_key = p.product_key
GROUP BY 
    p.product_name
ORDER BY 
    total_revenue DESC
LIMIT 5;


-- ============================================================
-- 2. Top 5 Products Using Window Function (Flexible Ranking)
-- ============================================================

SELECT *
FROM (
    SELECT 
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold_fact_sales AS f
    LEFT JOIN gold_dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY 
        p.product_name
) t
WHERE rank_products <= 5;


-- ============================================================
-- 3. Bottom 5 Products (Worst Performing by Revenue)
-- ============================================================

SELECT *
FROM (
    SELECT 
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) ASC) AS rank_products
    FROM gold_fact_sales AS f
    LEFT JOIN gold_dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY 
        p.product_name
) t
WHERE rank_products <= 5;


-- ============================================================
-- 4. Top 10 Customers by Revenue
-- ============================================================

SELECT *
FROM (
    SELECT 
        c.first_name,
        c.last_name,
        c.customer_key,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS customer_rank
    FROM gold_fact_sales AS f
    LEFT JOIN gold_dim_customers AS c
        ON f.customer_key = c.customer_key
    GROUP BY 
        c.first_name,
        c.last_name,
        c.customer_key
) t
WHERE customer_rank <= 10;


-- ============================================================
-- 5. Bottom 3 Customers (Fewest Orders)
-- ============================================================

SELECT *
FROM (
    SELECT 
        c.first_name,
        c.last_name,
        c.customer_key,
        COUNT(DISTINCT f.order_number) AS total_orders,
        ROW_NUMBER() OVER (
            ORDER BY COUNT(DISTINCT f.order_number) ASC, 
                     c.customer_key
        ) AS rn
    FROM gold_fact_sales AS f
    LEFT JOIN gold_dim_customers AS c
        ON f.customer_key = c.customer_key
    GROUP BY 
        c.first_name,
        c.last_name,
        c.customer_key
) t
WHERE rn <= 3;
