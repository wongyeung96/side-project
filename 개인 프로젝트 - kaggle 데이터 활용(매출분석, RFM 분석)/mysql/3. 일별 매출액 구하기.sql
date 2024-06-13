### 일별 매출액 구하기
USE sql_project;
SELECT * FROM `orders` LIMIT 10;
SELECT * FROM order_item LIMIT 10;

## 1. 주문 데이터와 주문 아이템 데이터 합치기
# 매출을 확인하기 위해 정확하게 배송이 완료된(order_status = 'delivered') 데이터만 출력
# 총 99,441건 중 배송 완료된(delivered) 건수는 96,478건임
-- SELECT order_status, COUNT(DISTINCT order_id) FROM olist_orders_dataset GROUP BY order_status;

## 2. 각 날짜별 매출(revenue) 확인(일별 매출액 확인)
SELECT 
	DATE(o.order_purchase_timestamp) AS dt,
    SUM(oi.price) AS revenue
FROM orders o 
LEFT JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY dt
ORDER BY revenue DESC
LIMIT 10;

## 3. 일별 구매 고객 수 구하기(paying user)
SELECT 
	DATE(o.order_purchase_timestamp) AS dt,
    COUNT(DISTINCT c.customer_unique_id) AS pu
FROM orders o 
LEFT JOIN customer c ON o.customer_id = c.customer_id 
WHERE o.order_status = 'delivered'
GROUP BY dt
ORDER BY dt  
LIMIT 10; 

## 4. 2,3 합쳐서 진행해 ARPPU 계산
SELECT 
	DATE(o.order_purchase_timestamp) AS dt,
    SUM(oi.price) AS revenue,
    COUNT(DISTINCT c.customer_unique_id) AS pu,
    ROUND(SUM(oi.price)/COUNT(DISTINCT c.customer_unique_id),2) AS ARPPU
FROM orders o 
LEFT JOIN order_item oi ON o.order_id = oi.order_id
LEFT JOIN customer c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY dt
ORDER BY dt;

## 5. state별 일별 paying user 추이 확인(state가 총 27개이므로 그 중 고객 10,000명이상인 state만 비교 = SP, RJ, MG)
SELECT 
	DATE(o.order_purchase_timestamp) AS dt,
    COUNT(DISTINCT CASE WHEN c.customer_state = 'SP' THEN c.customer_unique_id END) AS SP_pu,
    COUNT(DISTINCT CASE WHEN c.customer_state = 'RJ' THEN c.customer_unique_id END) AS RJ_pu,
    COUNT(DISTINCT CASE WHEN c.customer_state = 'MG' THEN c.customer_unique_id END) AS MG_pu
FROM orders o 
LEFT JOIN order_item oi ON o.order_id = oi.order_id
LEFT JOIN customer c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered' AND c.customer_state IN ('SP','RJ','MG')
GROUP BY dt


