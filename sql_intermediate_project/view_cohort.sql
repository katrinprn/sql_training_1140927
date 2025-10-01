DROP VIEW cohort_analysis;

CREATE OR REPLACE VIEW cohort_analysis AS

WITH customer_revenue AS (
    SELECT
        s.customerkey,
        s.orderdate,
        SUM(quantity::double precision *netprice*exchangerate) AS total_net_revenue,
        COUNT (orderkey) AS count_order,
        countryfull,
        age,
        givenname,
        surname
    FROM sales s
    LEFT JOIN customer c ON s.customerkey = c.customerkey
    GROUP BY s.customerkey, orderdate, countryfull, age, givenname, surname
)
SELECT
    customerkey,
    orderdate,
    total_net_revenue,
    count_order,
    countryfull, 
    age, 
    CONCAT (TRIM(givenname),'',TRIM(surname)) AS cleaned_name,
    MIN(orderdate) OVER (PARTITION BY customerkey) AS first_purchase_date,
    EXTRACT (YEAR FROM MIN(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
FROM customer_revenue