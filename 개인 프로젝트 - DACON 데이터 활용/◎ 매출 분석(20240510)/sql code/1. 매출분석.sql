USE dacon_project;

SELECT *
FROM onlinesales;

-- 1. 월별 revenue 확인
SELECT 
	DATE_FORMAT(order_date,"%Y-%m") AS order_month,
    SUM(count*average_price) AS revenue
FROM onlinesales
GROUP BY order_month;

-- 2. 월별 매출 쪼개 매출 원인 분석
-- 2. 월별 active user 수 (동일), 구매고객 수 , 1인당 평균 구매금액(ARPPU) 컬럼 생성
WITH month_revenue AS 
(SELECT 
	*,
	DATE_FORMAT(order_date, "%Y-%m") AS order_month,
    (SELECT COUNT(*) FROM customer) AS active_user
    
FROM onlinesales
)

SELECT 
	order_month,
    active_user,
	COUNT(DISTINCT customer_id) AS mdu, -- 구매고객 수 중복제거
	SUM(count*average_price) AS revenue,
    ROUND(SUM(count*average_price)/COUNT(DISTINCT customer_id),2) AS per_average_price -- 1인당 평균 구매금액
FROM month_revenue
GROUP BY order_month;  

-- 3. ARRPU 증가 원인 분석
-- 월별 1회당 구매 금액($), 월별 고객별 평균 구매횟수, ARPPU($) 컬럼 생성
-- 1) 월별 구매 1건당 구매 금액($) = 월별 총 구매금액($) / 총 구매건수 
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    SUM(count*average_price) AS "월별 총 구매금액($)", 
	COUNT(DISTINCT customer_id, order_id) AS "월별 총 구매건수",
    ROUND(SUM(count*average_price)/COUNT(DISTINCT customer_id, order_id),2) AS "월별 구매 1건당 구매 금액($)"
FROM onlinesales
GROUP BY order_month;

-- 2) 월별 고객별 평균 구매횟수 = DISTINCT customer_id, order_id한 후 customer_id 별 구매 횟수 구한 후 평균값
SELECT 
	DISTINCT order_month, 
	`평균 구매 횟수`
FROM (
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    AVG(COUNT(DISTINCT order_id)) OVER (PARTITION BY DATE_FORMAT(order_date, '%Y-%m')) AS `평균 구매 횟수`
FROM onlinesales
GROUP BY order_month, customer_id
ORDER BY order_month, customer_id) A;

