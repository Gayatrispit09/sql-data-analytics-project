/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost
    2. Segments products by revenue (High-Performer, Mid-Range, Low-Performer)
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

-- ============================================================
-- Create View: report_products
-- ============================================================

DROP VIEW IF EXISTS report_products;

CREATE VIEW report_products AS

WITH base_query AS (
    /*---------------------------------------------------------------------------
    1) Base Query: Core data from fact and dimension tables
    ---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.product_cost
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregations AS (
    /*---------------------------------------------------------------------------
    2) Product-Level Aggregations
    ---------------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        product_cost,
        TIMESTAMPDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,

        -- Average Selling Price
        ROUND(
            AVG(sales_amount / NULLIF(quantity, 0)),
            1
        ) AS avg_selling_price

    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        product_cost
)

-- ============================================================
-- 3) Final Output
-- ============================================================

SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    product_cost,
    last_sale_date,

    -- Recency (months since last sale)
    TIMESTAMPDIFF(
        MONTH,
        last_sale_date,
        CURDATE()
    ) AS recency_in_months,

    -- Product Segmentation
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations;
