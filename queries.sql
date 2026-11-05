--SQL FUNDAMENTALS SECTION A
--QUESTION 1. Retrieve all customer records
SELECT * FROM customers;

--QUESTION 2. Display customer names, cities, and segments.
SELECT customer_name,
		city,
		customer_segment
FROM customers ORDER BY customer_id DESC;

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

--SECTION B(GROUPING AND AGGREGATION)
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
-- Q19: Find categories generating more than KSh 100,000
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

	