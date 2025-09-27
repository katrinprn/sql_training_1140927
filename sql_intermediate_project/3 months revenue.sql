WITH month_revenue AS (
SELECT
	DATE_TRUNC('month', orderdate)::DATE AS month_period,
	SUM(total_net_revenue) AS monthly_revenue,
	COUNT(DISTINCT customerkey) AS monthly_total_customer,
	SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS monthly_customer_revenue
FROM cohort_analysis 
GROUP BY month_period
ORDER BY month_period
)

SELECT
	month_period,
	monthly_revenue,
	AVG(monthly_revenue) OVER (
	ORDER BY month_period
	ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
	) AS rolling_3mo_total_revenue,
	AVG(monthly_total_customer) OVER (
	ORDER BY month_period 
	ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
	) AS rolling_3mo_total_customer,
	AVG(monthly_customer_revenue) OVER (
	ORDER BY month_period
	ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
	) AS rolling_3mo_customer_revenue
FROM month_revenue