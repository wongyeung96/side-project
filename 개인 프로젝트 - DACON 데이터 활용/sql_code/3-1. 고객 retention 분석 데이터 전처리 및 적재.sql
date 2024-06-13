USE dacon_project;


-- onlinesales order_date 최초 구매일자와 최근 구매일자 확인 
SELECT MIN(order_date), MAX(order_date)
FROM onlinesales;
-- -> 2019-01-01 ~ 2019-12-31의 데이터인 것을 확인할 수 있음

-- customer 가입개월 수 가장 오래된 고객과 최근 고객 확인 
SELECT MIN(sign_month), MAX(sign_month)
FROM customer;
-- -> 가장 오래된 가입 고객 50개월, 가장 최신 가입 고객 2개월

-- 1. customer 테이블과 onlinesales 테이블 JOIN 
SELECT 
	DISTINCT c.customer_id, 
    CASE WHEN c.sign_month > 0 THEN DATE_SUB('2019-12-01',INTERVAL c.sign_month MONTH) END AS sign_date, 
    MIN(o.order_date) OVER (PARTITION BY c.customer_id) AS first_order_date,
    MAX(o.order_date) OVER (PARTITION BY c.customer_id) AS last_order_date,
    SUM(o.count*o.average_price) OVER (PARTITION BY c.customer_id) AS total_price,
    COUNT(o.order_date) OVER (PARTITION BY c.customer_id) AS buy_cnt
FROM customer c
LEFT JOIN onlinesales o ON c.customer_id = o.customer_id
ORDER BY sign_date;

-- customer_processing_data.csv로 저장 후 아래 코드 진행
# 테이블 안에 데이터셋 만들기
CREATE TABLE customer_pro(
	customer_id TEXT,
	sign_date DATE,
	first_order_date DATE,
	last_order_date	DATE,
    total_price INT,
	buy_cnt INT
);

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\DACON ecommerce data\\customer_process_data.csv"
INTO TABLE customer_pro
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY  '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT *
FROM customer_pro;