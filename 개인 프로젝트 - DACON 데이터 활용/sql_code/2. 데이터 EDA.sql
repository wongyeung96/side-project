USE dacon_project;

-- 2019년 1월 ~ 2019년 12월 월별 구매고객 수 확인
SELECT 
	DATE_FORMAT(order_date, "%Y-%m") AS order_month,
    COUNT(DISTINCT customer_id) AS total_customer_cnt
FROM onlinesales
GROUP BY order_month;

-- 어떤 카테고리 제품의 구매고객 수가 많을까? 
-- 1) category 종류 몇가지인지 확인
SELECT DISTINCT product_category
FROM onlinesales;
-- 20가지의 카테고리가 존재
-- 2) 월별 카테고리별 구매고객 수 확인
SELECT 
	DATE_FORMAT(order_date, "%Y-%m") AS order_month,
    product_category,
    COUNT(DISTINCT customer_id) AS total_customer_cnt
FROM onlinesales
GROUP BY order_month, product_category
ORDER BY order_month, total_customer_cnt DESC;

-- 3) 월별 할인쿠폰(쿠폰 코드 종류 48개) 개수 구하기
SELECT 
	COUNT(DISTINCT coupon_code)
FROM discount;

-- 4) 마케팅 이루어진 날짜 
SELECT 
	DATE_FORMAT(marketing_date, "%Y-%m") AS marketing_month,
    SUM(offline_price) AS offline_price_month,
    SUM(online_price) AS online_price_month
FROM marketing
GROUP BY marketing_month;