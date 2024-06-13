## 1) Recency : 2019년 12월 31일 기준 44일 이내 구매 고객과 44일 이내 구매하지 않은 고객(last_order_date 변수로 확인)
## 2) Frequency : 2.76건 초과 구매 고객과 2.76건 이하 구매 고객(customer_id, order_id가 같으면 주문 1건)
## 3) Monetary : $4,120.53 초과 구매 고객과 $4,210.53 이하 구매 고객(customer_id 별 총 구매 금액)
## 가정
## > 오늘은 2019년 12월 31일 

USE dacon_project;
WITH tb AS (
SELECT 
	customer_id,
    MAX(order_date) AS last_order_date,
    COUNT(DISTINCT order_id) AS order_cnt,
    SUM(count*average_price) AS total_sales
FROM onlinesales
GROUP BY customer_id
), rfm_tb AS (
SELECT 
	*,
    CASE WHEN DATEDIFF("2019-12-31",last_order_date) <= 44  THEN 'recent' ELSE 'past' END AS Recency,
    CASE WHEN order_cnt > 2.76 THEN 'high' ELSE 'low' END AS Frequency,
    CASE WHEN total_sales > 4120.53 THEN 'high' ELSE 'low' END AS Monetary
FROM tb
)

-- 고객별 등급 테이블 만들기
SELECT 
	*,
    CASE 
		WHEN Recency = 'past' AND Frequency = 'low' AND Monetary = 'low' THEN "1회성 고객"
 		WHEN Recency = 'past' AND Frequency = 'high' AND Monetary = 'high' THEN "VIP 이탈 가능 고객"
		WHEN Recency = 'past' AND Frequency = 'high' AND Monetary = 'low' THEN "구매 이탈 가능 고객"
		WHEN Recency = 'recent' AND Frequency = 'high' AND Monetary = 'low' THEN "충성 고객"
		WHEN Recency = 'recent' AND Frequency = 'high' AND Monetary = 'high' THEN "VIP"
		WHEN Recency = 'recent' AND Frequency = 'low' AND Monetary = 'low' THEN "일반 구매 고객"
	END AS grade
FROM rfm_tb

-- SELECT 
-- 	Recency,
--     Frequency,
--     Monetary,
--     COUNT(customer_id)
-- FROM rfm_tb
-- GROUP BY Recency, Frequency, Monetary; 