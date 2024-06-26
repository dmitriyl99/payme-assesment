CREATE TABLE customers (
    ID SERIAL PRIMARY KEY, 
    name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL, 
    country VARCHAR(100), 
    phone VARCHAR(20), 
    date_of_birth DATE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) DISTRIBUTED BY (ID);