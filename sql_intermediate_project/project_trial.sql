WITH cust_ltv AS(
    SELECT
        DISTINCT customerkey,
        SUM(quantity*netprice*exchangerate) AS cust_ltv
    FROM sales
    GROUP BY customerkey
),
     total_ltv AS(
        SELECT
            SUM(cust_ltv) AS total_ltv
        FROM cust_ltv
    )

    SELECT 
        customerkey,
        cust_ltv,
        total_ltv,
        ROUND((100.0*cust_ltv/ total_ltv)::NUMERIC   , 2) AS ltv_percentage
    FROM cust_ltv
    CROSS JOIN total_ltv