# 데이터 적재하기
USE sql_project;

## DROP TABLE olist_orders_dataset;
## DROP TABLE olist_customers_dataset;
## DROP TABLE olist_order_items_dataset;

CREATE TABLE orders(
	order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
	order_delivered_customer_date TEXT, 
	order_estimated_delivery_date TEXT
);

CREATE TABLE customer(
    customer_id TEXT,
    customer_unique_id  TEXT,
    customer_zip_code_prefix  TEXT,
	customer_city  TEXT, 
	customer_state  TEXT
);

CREATE TABLE order_item(
	order_id TEXT,
    order_item_id  TEXT,
    product_id  TEXT,
    seller_id  TEXT,
	shipping_limit_date  TEXT, 
	price  INT,
    freight_value INT
);

-- 데이터 적재시 csv 파일 경로 : C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads 폴더 안에 있어야함
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_orders_dataset.csv"
INTO TABLE orders
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY  '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_order_items_dataset.csv"
INTO TABLE order_item
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY  '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_customers_dataset.csv"
INTO TABLE customer
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY  '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;