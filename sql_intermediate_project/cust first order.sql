WITH purchase_days AS(
	SELECT customerkey,
		total_net_revenue,
		orderdate - min(orderdate) OVER (PARTITION BY customerkey) AS days_since_first_purch
	FROM cohort_analysis
)
SELECT days_since_first_purch,
	SUM(total_net_revenue) AS total_cohort_revenue,
	SUM(total_net_revenue) * 100 /(
		SELECT SUM(total_net_revenue)
		FROM cohort_analysis
	) AS percentage_of_total_revenue
FROM purchase_days
GROUP BY days_since_first_purch
ORDER BY days_since_first_purch;
SELECT cohort_year,
	SUM(total_net_revenue) AS cohort_total_revenue,
	COUNT(DISTINCT customerkey) AS total_customer,
	SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis
WHERE orderdate = min_order_date
GROUP BY cohort_year