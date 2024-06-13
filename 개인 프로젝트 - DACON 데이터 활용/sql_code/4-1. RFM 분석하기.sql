USE dacon_project;
-- 고객별 RFM 값 구하기

WITH customer_df AS (
	SELECT 
		customer_id,
		order_id,
		order_date,
		MIN(order_date) OVER (partition by customer_id) AS first_order_date,
		MAX(order_date) OVER (PARTITION BY customer_id) AS last_order_date
	FROM customer_sales
	ORDER BY customer_id, order_date
)
SELECT *
FROM customer_df