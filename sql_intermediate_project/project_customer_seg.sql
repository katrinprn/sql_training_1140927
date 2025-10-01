WITH customer_ltv AS (
SELECT 
    customerkey,
    cleaned_name,
    SUM(total_net_revenue) AS customer_ltv
FROM cohort_analysis
GROUP BY 
    customerkey,
    cleaned_name
),
customer_segment AS(
SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY customer_ltv) AS ltv_25th_percentile,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY customer_ltv) AS ltv_75th_percentile
FROM customer_ltv
)

SELECT
    c.*,
    CASE
        WHEN customer_ltv<ltv_25th_percentile THEN '1 - Low Value'
        WHEN customer_ltv>ltv_75th_percentile THEN '3 - High Value'
        ELSE '2 - Mid Value'
        END AS customer_segment 
FROM customer_ltv c, customer_segment