SELECT cohort_year,
    SUM(total_net_revenue) AS cohort_total_revenue,
    COUNT(DISTINCT customerkey) AS total_customer,
    SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis
WHERE orderdate = min_order_date
GROUP BY cohort_year