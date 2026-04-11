/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), TIMESTAMPDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months

SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(year, MIN(order_date), MAX(order_date)) AS orders_range_years
FROM gold_fact_sales;

-- Find the youngest and oldest customer based on birthdate

SELECT 
	MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate,
    TIMESTAMPDIFF (year, MIN(birthdate), CURDATE()) as oldest_age,
    TIMESTAMPDIFF (year, MAX(birthdate), CURDATE()) as youngest_age
    FROM gold_dim_customers;
