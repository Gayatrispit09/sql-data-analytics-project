/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH category_sales AS(
SELECT 
p.category,
SUM(f.sales_amount) AS total_sales
FROM gold_fact_sales AS f LEFT JOIN 
gold_dim_products as p ON 
f.product_key=p.product_key
GROUP BY p.category
)
SELECT category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
ROUND(total_sales/SUM(total_sales) OVER () * 100,2)AS percentage_of_sales
FROM category_sales
percentage_of_sales;
