-- 1. 데이터 불러오기
SELECT *
FROM customer_pro;

-- 월별 평균 매출 구하기
SELECT
	DATE_FORMAT(order_date,"%Y-%m") AS order_month,
    SUM(count*average_price) AS revenue
FROM onlinesales 
GROUP BY order_month;

-- 여기서 사용자가 유지된다는 지표는 구매로 첫 구매 이후에 retention이 얼마나 잘 유지되는지 확인(재구매율)

