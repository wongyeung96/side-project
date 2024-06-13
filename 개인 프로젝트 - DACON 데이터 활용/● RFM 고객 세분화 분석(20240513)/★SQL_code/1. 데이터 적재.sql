# 데이터 적재하기
USE dacon_project;

## DROP TABLE olist_orders_dataset;
## DROP TABLE olist_customers_dataset;
## DROP TABLE olist_order_items_dataset;

# 테이블 안에 데이터셋 만들기
CREATE TABLE onlinesales(
	customer_id TEXT,
    order_id TEXT,
    order_date TEXT,
    product_id TEXT,
	product_category TEXT, 
	count TEXT,
    average_price INT,
    delivery_fee INT,
    discount_coupon TEXT
);

CREATE TABLE customer(
	customer_id TEXT,
	sex TEXT,
	area TEXT,
	sign_month INT
);

-- 데이터 적재시 csv 파일 경로 : C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads 폴더 안에 있어야함
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\DACON ecommerce data\\Customer_info.csv"
INTO TABLE customer
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY  '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\DACON ecommerce data\\Onlinesales_info.csv"
INTO TABLE onlinesales
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY  '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- 데이터 확인
SELECT *
FROM onlinesales
LIMIT 100000;