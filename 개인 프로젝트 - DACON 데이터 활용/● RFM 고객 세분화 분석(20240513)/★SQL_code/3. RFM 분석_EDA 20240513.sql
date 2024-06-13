USE dacon_project;

## 1) 고객 수 확인하기
SELECT COUNT(DISTINCT customer_id) AS '고객 수'
FROM onlinesales;

## 2) 고객별 최근 구매 일자 확인 
SELECT DISTINCT customer_id, MAX(order_date) OVER (PARTITION BY customer_id) AS last_order_date FROM onlinesales;

## 3) 고객별 총 구매 횟수 확인(같은 날 주문한 건은 1건으로 가정)
SELECT customer_id, COUNT(DISTINCT customer_id, order_date) AS order_cnt FROM onlinesales GROUP BY customer_id;

## 4) 고객별 총 구매 금액 확인 
SELECT customer_id, SUM(count*average_price) AS order_price FROM onlinesales GROUP BY customer_id ORDER BY customer_id;

## 5) 데이터 합치기
WITH tb AS (
	SELECT DISTINCT customer_id, MAX(order_date) OVER (PARTITION BY customer_id) AS last_order_date FROM onlinesales
), tb1 AS (
	SELECT customer_id, COUNT(DISTINCT customer_id, order_date) AS order_cnt FROM onlinesales GROUP BY customer_id
), tb2 AS (
	SELECT customer_id, SUM(count*average_price) AS order_price FROM onlinesales GROUP BY customer_id ORDER BY customer_id
)

SELECT 
	tb.customer_id,
    tb.last_order_date,
    tb1.order_cnt,
    tb2.order_price
FROM tb 
LEFT JOIN tb1 ON tb.customer_id = tb1.customer_id 
LEFT JOIN tb2 ON tb.customer_id = tb2.customer_id ;

## 6) 최근에 구매 후 얼마나 지났는지 확인(현재를 2019년 12월 31일이라고 가정)
SELECT customer_id, DATEDIFF('2019-12-31',last_order_date) AS diff_days FROM (SELECT DISTINCT customer_id, MAX(order_date) OVER (PARTITION BY customer_id) AS last_order_date FROM onlinesales) A;

## 7) 다시 데이터 합치기
WITH tb AS (
	SELECT customer_id, DATEDIFF('2019-12-31',last_order_date) AS diff_days FROM (SELECT DISTINCT customer_id, MAX(order_date) OVER (PARTITION BY customer_id) AS last_order_date FROM onlinesales) A
), tb1 AS (
	SELECT customer_id, COUNT(DISTINCT customer_id, order_date) AS order_cnt FROM onlinesales GROUP BY customer_id
), tb2 AS (
	SELECT customer_id, SUM(count*average_price) AS order_price FROM onlinesales GROUP BY customer_id ORDER BY customer_id
)

SELECT 
	tb.customer_id,
    tb.diff_days,
    tb1.order_cnt,
    tb2.order_price
FROM tb 
LEFT JOIN tb1 ON tb.customer_id = tb1.customer_id 
LEFT JOIN tb2 ON tb.customer_id = tb2.customer_id ;

## 8) 재구매한 고객들이 첫 구매와 재구매 사이의 차이는? (당일에 주문을 여러 건 한 경우, 그 다음 주문한 날짜를 불러온다.
WITH tb3 AS (
SELECT DISTINCT customer_id, order_date, order_date_rank FROM (SELECT *, DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_date_rank FROM onlinesales ORDER BY customer_id, order_date) A WHERE order_date_rank <= 2
), tb4 AS (
SELECT customer_id, CASE WHEN order_date_rank = 1 THEN order_date END AS first_order_date, CASE WHEN order_date_rank = 2 THEN order_date END AS second_order_date FROM tb3
), tb5 AS (
## 같은 customer_id 끼리 first_order_date 와 second_order_date를 붙여준다. = 다른 날 재구매한 customer_id만 출력 
SELECT A.customer_id, A.first_order_date, B.second_order_date
FROM (SELECT customer_id,first_order_date FROM tb4 WHERE first_order_date IS NOT NULL) A 
INNER JOIN (SELECT customer_id, second_order_date FROM tb4 WHERE second_order_date IS NOT NULL) B ON A.customer_id = B.customer_id
)
SELECT 
	*,
    DATEDIFF(second_order_date,first_order_date) AS "재구매 기간"
FROm tb5
## 총 다른 날 재구매한 고객들의 재구매까지의 기간을 확인해보았다. (734명)
