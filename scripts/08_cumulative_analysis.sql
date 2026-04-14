/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 


SELECT 
DATE,
total_sales,
SUM(total_sales) OVER (PARTITION BY YEAR(DATE ) ORDER BY DATE) AS running_total_sales,
AVG(avg_price) OVER (PARTITION BY YEAR(DATE) ORDER BY DATE) AS moving_avg
FROM(
SELECT 
    DATE(order_date) AS DATE,
    SUM(sales_amount) AS total_sales,
    AVG(price) AS avg_price
FROM gold_fact_sales
GROUP BY 
    DATE(order_date)
ORDER BY 
      DATE(order_date))t;
