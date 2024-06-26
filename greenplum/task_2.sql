-- Calculate  the 3-month moving average of sales amount for each month. The moving 
-- average should be calculated based on the sales data from the previous 3 months 
-- (including  the current month).

-- Variant A with custom column total amount

WITH monthly_sales as (
    SELECT 
        EXTRACT(MONTH FROM purchase_date) AS month,
        SUM(total_amount) as total_sales_amount
    FROM 
        sales_transactions
    GROUP BY 
        EXTRACT(MONTH FROM purchase_date)
)
SELECT 
    month,
    total_sales_amount,
    AVG(total_sales_amount) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_average_sales_amount -- AVG() window function. 
    -- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW shows the window for the moving average sales amount,
    -- including the current month and two preceding months
FROM monthly_sales
ORDER BY month;


-- Variant B with join products table

WITH monthly_sales as (
    SELECT 
        EXTRACT(MONTH FROM purchase_date) AS month,
        SUM(st.quantity_purchased * p.price) AS total_sales_amount
    FROM 
        sales_transactions st
    JOIN 
        products p ON st.product_ID = p.ID
    GROUP BY 
        EXTRACT(MONTH FROM purchase_date)
)
SELECT 
    month,
    total_sales_amount,
    AVG(total_sales_amount) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_average_sales_amount -- AVG() window function. 
    -- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW shows the window for the moving average sales amount,
    -- including the current month and two preceding months
FROM monthly_sales
ORDER BY month;
