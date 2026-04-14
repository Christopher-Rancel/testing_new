-- Retrieve only 3 customers

SELECT TOP 3*
FROM customers

-- Retrieve the Top 3 Customers with the highest scores 

SELECT TOP 3*
FROM customers
ORDER BY score DESC   

-- Retrieve the Lowest 2 Customers based on the score 

SELECT TOP 2*
FROM customers
ORDER BY score ASC 

-- Get the two most recent orders 

SELECT TOP 2*
FROM orders 
ORDER BY order_date DESC 