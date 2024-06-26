-- Calculate  the total sales amount and the total number of transactions for each month.

-- Variant A with custom column total amount

SELECT
    EXTRACT(MONTH FROM purchase_date) AS month,
    SUM(total_amount) AS total_sales_amount,
    COUNT(transaction_ID) AS total_transactions
FROM 
    sales_transactions
GROUP BY
    EXTRACT(MONTH FROM purchase_date)
ORDER BY 
    month;

-- Variant B with join products table

SELECT
    EXTRACT(MONTH FROM st.purchase_date) AS month,
    SUM(st.quantity_purchased * p.price) AS total_sales_amount,
    COUNT(st.transaction_ID) AS total_transactions
FROM 
    sales_transactions st
JOIN 
    products p ON st.product_ID = p.ID
GROUP BY
    EXTRACT(MONTH FROM purchase_date)
ORDER BY 
    month;


-- In this case, we can see the benefit of storing the sale amount separately, 
-- since the price of products in the "products" table may change over time, 
-- which will violate the historicity of the data

-- In addition, it removes the JOIN, which speeds up the query