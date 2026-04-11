/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold_fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold_fact_sales;

-- Find the average selling price
SELECT AVG(price)  AS avg_price from gold_fact_sales;

-- Find the Total number of Orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold_fact_sales;

-- Find the total number of products
SELECT COUNT(product_key) AS total_products FROM gold_dim_products;

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold_dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold_fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total_Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'Total_quantity' AS measure_name,SUM(quantity) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'avg_price' AS measure_name, AVG(price) AS measure_value from gold_fact_sales
UNION ALL
SELECT 'total_orders' AS measure_name,COUNT(DISTINCT order_number) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'total_products' AS measure_name ,COUNT(product_key) AS measure_value FROM gold_dim_products
UNION ALL
SELECT 'total_customers' AS measure_name,COUNT(customer_key) AS measure_value FROM gold_dim_customers
