CREATE TABLE sales_transactions (
    transaction_ID SERIAL PRIMARY KEY,
    customer_ID INT NOT NULL,
    product_ID INT NOT NULL,
    purchase_date TIMESTAMP NOT NULL,
    quantity_purchased INT NOT NULL CHECK (quantity_purchased > 0),
    total_amount NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_ID)
            REFERENCES customers(ID),
    FOREIGN KEY (product_ID)
            REFERENCES products(ID) -- Greenplum doesn't support foreign keys so it will not be enforced
            
) WITH (APPENDOPTIMIZED=true, COMPRESSTYPE=ZLIB, compresslevel=3) DISTRIBUTED BY (transaction_ID);

-- It would be better to create 
-- distribution such as DISTRIBUTED BY (customer_ID, product_ID) 
-- to maximize query parallelism in join operations with related tables "customers" and "products", 
-- but in that case we can't create foreign key from shipping_details to sales_transactions,
-- which contradicts the original task