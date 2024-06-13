USE dacon_project;

-- 1. 고객이 구매와 재구매 사이 기간 EDA
SELECT *
FROM onlinesales
ORDER BY customer_id ASC, order_id ASC, order_date ASC;

SELECT 
	customer_id,
    order_id,
    MIN(order_date) AS order_date,
    SUM(average_price*count) AS 'revenue($)'
FROM onlinesales
GROUP BY customer_id, order_id