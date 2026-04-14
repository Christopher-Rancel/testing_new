-- Left anti join --

/* Get all customers who haven't placed any order */

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

/* First use normal Left Join and then with WHERE to check the not existence */

-- Right Anti Join --

/* Get all orders without matching customers */

SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL 

/* Get all orders without matching customers ( USING LEFT JOIN )*/

SELECT *
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.id
WHERE c.id IS NULL 

 -- Same results if you switch the tables --
 -- Left join is better, just be carefull of the orders --
 
 -- Full anti join --

  /* Find customers without orders and orders without customers */

 SELECT * 
 FROM customers AS c
 FULL JOIN orders AS o
 ON c.id = o.customer_id
 WHERE
 c.id IS NULL
 OR
 o.customer_id IS NULL 


/* Get all customers along with their orders, but only for customers who have placed and order (Without using INNER JOIN)*/

SELECT *
FROM customers AS c
LEFT JOIN orders As O
ON c.id = O.customer_id
WHERE o.customer_id IS NOT NULL 

-- Cross join -- 

/* Generate all possible combinations of customers and orders*/

SELECT *
FROM customers
CROSS JOIN orders

/* It is used basically for testintg */