/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To analyze sales performance at a daily level.
    - To track trends in revenue, customer activity, and product demand.
    - To support time-series analysis and identify patterns over time.

SQL Functions Used:
    - Date Functions: YEAR(), MONTH(), DAY(), DATE()
    - Aggregate Functions: SUM(), COUNT()
    - Clauses: GROUP BY, ORDER BY

Notes:
    - Queries are written in MySQL-compatible syntax.
    - Includes both component-based (YEAR, MONTH, DAY) and full-date aggregation.
===============================================================================
*/

-- ============================================================
-- 1. Sales Performance by Year, Month, and Day
-- ============================================================

SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    DAY(order_date) AS day,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_amount,
    SUM(quantity) AS total_quantity
FROM gold_fact_sales
GROUP BY 
    YEAR(order_date),
    MONTH(order_date),
    DAY(order_date)
ORDER BY 
    year,
    month,
    day;


-- ============================================================
-- 2. Sales Performance by Full Date (Best Practice)
-- ============================================================

SELECT 
    DATE(order_date) AS order_date,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_amount,
    SUM(quantity) AS total_quantity
FROM gold_fact_sales
GROUP BY 
    DATE(order_date)
ORDER BY 
    order_date;
