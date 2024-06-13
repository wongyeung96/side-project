USE sql_project;
### 데이터 확인
SELECT * FROM olist_orders_dataset LIMIT 10;
SELECT * FROM olist_customers_dataset LIMIT 10;
SELECT * FROM olist_order_items_dataset LIMIT 10;

### EDA
## 1. 며칠치의 데이터가 들어있는지 확인(order_purchase_timestamp 기준) : 2016-09-04 ~ 2018-10-17까지의 데이터 확인
SELECT 
	COUNT(DISTINCT DATE(order_purchase_timestamp)) AS cnt,
    MIN(DATE(order_purchase_timestamp)) AS first_order_date,
    MAX(DATE(order_purchase_timestamp)) AS last_order_date
FROM olist_orders_dataset;

## 2017년도의 데이터를 가지고 EDA 진행 
-- WITH orders AS (
-- SELECT *
-- FROM olist_orders_dataset
-- WHERE order_purchase_timestamp BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 00:00:00'
-- ORDER BY order_purchase_timestamp)
-- SELECT *
-- FROM orders;

## 2. olist_customers_dataset 안에 customer_city 컬럼을 보고 각 고객들이 어느 도시에 살고 있는지 확인(TOP 10 확인)
SELECT
	customer_city,
    COUNT(DISTINCT customer_id) AS cnt
FROM olist_customers_dataset
GROUP BY customer_city
ORDER BY cnt DESC
LIMIT 10;

## 3. olist_customers_dataset(고객 테이블)과 olist_orders_dataset(주문 테이블) 관계 파악
SELECT c.customer_id,c.customer_unique_id, c.customer_city, o.order_id, o.order_status, o.order_purchase_timestamp, o.order_delivered_customer_date,o.order_estimated_delivery_date
FROM olist_customers_dataset c 
LEFT JOIN olist_orders_dataset o ON o.customer_id = c.customer_id
LIMIT 10; 

# 고객당 주문을 여러번 할 수 있나요? YES
SELECT c.customer_unique_id, COUNT(order_id) AS cnt
FROM olist_customers_dataset c 
LEFT JOIN olist_orders_dataset o ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY cnt DESC
LIMIT 10;

## 4. olist_order_items_dataset에서 한 주문당 여러개의 item이 등록될 수 있나요? YES 
SELECT 
	order_id,
    COUNT(DISTINCT product_id) AS cnt
FROM olist_order_items_dataset
GROUP BY order_id 
ORDER BY cnt DESC;

## 5. 주문, 고객, 상품 정보를 하나의 테이블로 볼 수 있나?
SELECT c.customer_unique_id, c.customer_city, o.order_id, o.order_status, o.order_purchase_timestamp, o.order_delivered_customer_date, o.order_estimated_delivery_date, oi.price
FROM olist_customers_dataset c 
LEFT JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
LEFT JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
LIMIT 10;

## 6. 가장 매출이 많은 도시가 어디인지 TOP 3를 뽑아보자. 
SELECT c.customer_city, SUM(oi.price) AS revenue
FROM olist_customers_dataset c 
LEFT JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
LEFT JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 10

