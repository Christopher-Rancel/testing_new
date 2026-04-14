-- No Join --

/* Retrieve all data from customers and orders in two different results */

SELECT *
FROM customers ;

SELECT *
FROM orders ;

-- Inner Join --

/* Get all customers along with their orders, but only for customers who have placed an order */

SELECT 
c.id,
c.first_name,
o.order_id,
o.sales
FROM customers AS c 
INNER JOIN orders AS o
ON c.id = o.customer_id

/* See on the tables the matching columns in order to match with the ON, usually the column would be the 'id' column so be aware of that before do it */
/* Always select the tales that you need in order to only see the essential info */
/* Also before putting the columns put the name of the tables first to not make mistakes and to understand everything */
/* If the names of the tables are to long you can put an AS instead of the name of the table */
/* The order of the tables doesn't matters because is an inner join */ 

-- Left Join --

/* Get all customers along with their orders, including those without orders */

SELECT 
c.id,
c.first_name,
o.order_id,
o.sales
FROM customers AS c
LEFT JOIN orders AS o 
ON c.id = o.customer_id

 /* The order is very important*/

 -- Right join --

 /* Get all customers along with their orders, including orders without matching customers */

 SELECT 
c.id,
c.first_name,
o.order_id,
o.sales
 FROM customers AS c
 RIGHT JOIN orders AS o
 ON c.id = o.customer_id

 /* The order is very important*/

 /* Get all customers along with their orders, including orders without matching customers (Using LEFT JOIN) */

 SELECT
 o.order_id,
 o.sales,
 c.id,
 c.first_name
 FROM orders AS O
 LEFT JOIN customers AS c
 ON o.customer_id = c.id

 /* Same results if you switch the tables +/
 /* Left join is better, just be carefull of the orders */

 -- Full join --

 /* Get all customers and all orders, even if there's no match*/

SELECT 
c.id,
c.first_name,
o.order_id,
o.sales
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id 