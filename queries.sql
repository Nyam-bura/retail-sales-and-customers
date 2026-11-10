-- ================================================================
-- SQL FUNDAMENTALS SECTION A
-- QUESTIONS 1-10
-- =================================================================
--QUESTION 1. Retrieve all customer records
SELECT * FROM customers;

--QUESTION 2. Display customer names, cities, and segments.
SELECT customer_name,
		city,
		customer_segment
FROM customers;

--QUESTION 3. Find customers living in Nairobi.
SELECT customer_name,
	   city 
FROM customers
WHERE city = 'Nairobi';

--QUESTION 4. Find customers registered after January 1, 2025.
SELECT * FROM customers
WHERE registration_date > DATE '2025-01-01';

--QUESTION 5. Display all unique customer cities
SELECT DISTINCT city 
FROM customers ORDER BY city;

--QUESTION 6. Retrieve the 10 most recent orders.
SELECT * FROM orders 
ORDER BY order_date DESC, order_id DESC
LIMIT 10;

--QUESTION 7. Find orders with unit prices above KSh 10,000
SELECT order_id,
	   unit_price
FROM orders
WHERE unit_price > 10000;

--QUESTION 8. Find customers whose names start with A.
SELECT customer_name 
FROM customers
WHERE customer_name LIKE 'A%';

--QUESTION 9. Retrieve orders with quantities between 2 and 5
SELECT * FROM orders
WHERE quantity BETWEEN 2 AND 5;

--QUESTION 10. Find orders paid through M-Pesa.
SELECT * FROM orders
WHERE payment_method = 'M-Pesa';

-- ===================================================================
-- SECTION B(GROUPING AND AGGREGATION)
-- QUESTIONS 11-2-
-- ===================================================================
--QUESTION 11. Count all customers
SELECT COUNT(*) AS total_customers FROM customers;

--QUESTION 12. Count all orders
SELECT COUNT(*) AS total_orders FROM orders;

--QUESTION 13. Calculate completed-order revenue
SELECT
    ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS total_order_revenue
FROM orders
WHERE order_status = 'Completed';

--QUESTION 14. Calculate the average completed-order value
SELECT
    ROUND(AVG(quantity * unit_price * (1 - discount / 100.0)), 2) AS average_order_value
FROM orders
WHERE order_status = 'Completed';

--QUESTION 15. Find the highest and lowest product prices.
SELECT 
	MAX(unit_price) AS highest_product_price,
	MIN(unit_price) AS lowest_product_price
FROM orders;

--QUESTION 16. Calculate revenue by product category
SELECT product_category,
	  ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS total_revenue
FROM orders	
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY total_revenue DESC;

--QUESTION 17. Count customers by city
SELECT city,
		COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

--QUESTION 18. Calculate quantity sold by product.
SELECT product_name,
	   SUM(quantity) AS total_quantity_sold
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_name
ORDER BY total_quantity_sold DESC;


--QUESTION 19. Find categories generating more than KSh 100,000 in revenue.
SELECT
    product_category,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        2
    ) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
HAVING SUM(quantity * unit_price * (1 - discount / 100.0)) > 100000
ORDER BY total_revenue DESC;


--QUESTION 20. Calculate the percentage of cancelled orders.
SELECT
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancelled_order_percentage
FROM orders;

	
-- =================================================================
-- SECTION C (JOINS AND CUSTOMER ANALYTICS)
-- QUESTIONS 21-28
-- =================================================================

--QUESTION 21. Display orders with customer names and cities.
SELECT o.order_id,
       o.customer_id,
       o.order_date,
       o.product_name,
       c.customer_name,
       c.city
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;

-- QUESTION 22. Calculate total spending by customer.
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(
            o.quantity * o.unit_price * (1 - o.discount / 100.0)
        ),
        2
    ) AS total_spending
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_spending DESC;

-- QUESTION 23. Identify customers who have never ordered.
SELECT c.customer_id,
	   c.customer_name,
	   o.order_id
FROM customers AS c
LEFT JOIN orders AS O
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- QUESTION 24. Find the 10 highest-spending customers.
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)),
        2
    ) AS total_spending
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_spending DESC
LIMIT 10;


--QUESTION 25. Calculate revenue by customer city.
SELECT
    c.city,
    ROUND(
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)),
        2
    ) AS total_revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.city
ORDER BY total_revenue DESC;

-- 	QUESTION 26. Identify customers with more than five orders.
SELECT c.customer_id,
	   c.customer_name,
	   COUNT(o.order_id) AS total_orders
FROM customers AS c
INNER JOIN orders AS O
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,
		 c.customer_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;

-- QUESTION 27. Calculate average customer spending by segment.
SELECT
    customer_segment,
    ROUND(AVG(total_spending), 2) AS average_customer_spending
FROM (
SELECT  c.customer_id,
        c.customer_segment,
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)
        ) AS total_spending
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id,
         c.customer_segment
) AS customer_spending
GROUP BY customer_segment
ORDER BY average_customer_spending DESC;

-- QUESTION 28. Identify the most popular category among VIP customers.
SELECT
    o.product_category,
    COUNT(*) AS total_orders
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.customer_segment = 'VIP'
  AND o.order_status = 'Completed'
GROUP BY o.product_category
ORDER BY total_orders DESC;

-- ===============================================
--              SECTION D: SUBQUERIES AND CTEs
-- ===============================================
-- QUESTION 29. Find customers spending above the average
-- total spending per purchasing customer.
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)),
        2
    ) AS total_spending
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name
HAVING SUM(
    o.quantity * o.unit_price * (1 - o.discount / 100.0)
) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            SUM(
                quantity * unit_price * (1 - discount / 100.0)
            ) AS customer_total
        FROM orders
        WHERE order_status = 'Completed'
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_spending DESC;

-- 	QUESTION 30. Find products priced above the overall average unit price
SELECT DISTINCT
    product_name,
    unit_price
FROM orders
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM orders
)
ORDER BY unit_price DESC;


-- QUESTION 31. Use a CTE to identify the three highest-revenue months.
WITH monthly_revenue AS (
SELECT 
	DATE_TRUNC('month', order_date) AS revenue_month,
	ROUND(
		SUM(
			quantity * unit_price * (1 - discount /100.0)
		),
		2
	) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_TRUNC('month', order_date)
)
SELECT revenue_month,
	   total_revenue
FROM monthly_revenue
ORDER BY total_revenue DESC
LIMIT 3;

-- QUESTION 32. Find customers purchasing from at least three categories.
SELECT c.customer_id,
	   c.customer_name,
	   COUNT ( DISTINCT o.product_category) AS category_count
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY
c.customer_id,
c.customer_name
HAVING COUNT(DISTINCT o.product_category) >= 3
ORDER BY category_count DESC, c.customer_name;

--QUESTION 33. Use a CTE to calculate category revenue, cost, 
--profit, and profit margin
WITH category_financials AS(
SELECT product_category,
SUM(
quantity * unit_price * (1 - discount / 100.0)
)AS total_revenue,
SUM(
quantity * cost_price
)AS total_cost
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
)
SELECT product_category,
ROUND(total_revenue,2) AS total_revenue,
ROUND(total_cost, 2) AS total_cost,
ROUND(total_revenue - total_cost, 2) AS total_profit,
ROUND((total_revenue - total_cost) / NULLIF (total_revenue, 0) * 100,
2
)AS profit_margin_percentage
FROM category_financials
ORDER BY total_profit DESC;

--QUESTION 34. Find customers whose latest completed order is more than 90 days
--before the latest order date in the dataset.
WITH latest_dataset_date AS (
    SELECT MAX(order_date) AS latest_order_date
    FROM orders
),

customer_last_order AS (
    SELECT
        c.customer_id,
        c.customer_name,
        MAX(o.order_date) AS last_completed_order_date
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    clo.customer_id,
    clo.customer_name,
    clo.last_completed_order_date,
    ldd.latest_order_date,
    ldd.latest_order_date - clo.last_completed_order_date
        AS days_since_last_order
FROM customer_last_order clo
CROSS JOIN latest_dataset_date ldd
WHERE ldd.latest_order_date - clo.last_completed_order_date > 90
ORDER BY days_since_last_order DESC;