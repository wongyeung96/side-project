USE dacon_project; 

SELECT o.customer_id, o.order_id, o.order_date, o.count, o.average_price, o.delivery_fee, o.discount_coupon, c.sex, c.area, c.sign_month
FROM onlinesales o
LEFT JOIN customer c ON o.customer_id = c.customer_id
LIMIT 53000;

# 테이블 안에 데이터셋 만들기
DROP TABLE customer_sales;

CREATE TABLE customer_sales(
	customer_id TEXT,
    order_id TEXT,
    order_date TEXT,
    count TEXT,
    average_price INT,
    delivery_fee INT,
    discount_coupon TEXT,
    sex TEXT,
    area TEXT,
    sign_month INT
);

-- 데이터 적재시 csv 파일 경로 : C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads 폴더 안에 있어야함
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\DACON ecommerce data\\customer_sales.csv"
INTO TABLE customer_sales
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY  '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;