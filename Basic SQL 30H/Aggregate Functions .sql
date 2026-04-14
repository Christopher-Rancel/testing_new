-- Aggregate Functions --

-- COUNT, SUM, AVG, MAX, MIN --

/* Find the total number of orders */

SELECT 
COUNT(*) AS total_nr_orders
FROM orders

/* Find the total sales of orders */

SELECT 
COUNT(*) AS total_nr_orders,
SUM(sales) AS totsl_sales
FROM orders

/* Find the avarage sales of all orders */

SELECT 
COUNT(*) AS total_nr_orders,
SUM(sales) AS totsl_sales,
AVG(sales) AS avg_sales
FROM orders


/* Find the highest sales of all orders */

SELECT 
COUNT(*) AS total_nr_orders,
SUM(sales) AS totsl_sales,
AVG(sales) AS avg_sales,
MAX(sales) AS highest_sales
FROM orders

/* Find the lowest sales of all orders */

SELECT 
customer_id,
COUNT(*) AS total_nr_orders,
SUM(sales) AS totsl_sales,
AVG(sales) AS avg_sales,
MAX(sales) AS highest_sales,
MIN(sales) AS lowest_sales
FROM orders
GROUP BY customer_id

/* Analyze the scores in customers table */

SELECT
country,
COUNT(*) AS total_nr_customers,
SUM(score) AS total_score,
AVG(score) AS avg_score,
MAX(score) AS max_score,
MIN(score) AS min_score
FROM customers
GROUP BY country