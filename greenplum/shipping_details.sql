CREATE TYPE shipping_status AS ENUM ('created', 'pickedup', 'delivered', 'canceled');

CREATE TABLE shippind_details (
    transaction_ID INTEGER NOT NULL,
    shipping_date DATE NOT NULL,
    shipping_address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    shippind_price NUMERIC(10, 2) NOT NULL,
    status shipping_status DEFAULT 'created',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_ID)
            REFERENCES sales_transactions(transaction_ID)
) WITH (APPENDOPTIMIZED=true, COMPRESSTYPE=ZLIB, compresslevel=3) DISTRIBUTED BY (transaction_ID);