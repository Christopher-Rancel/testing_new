-- Retrieve customers with a score not equeal to 0

SELECT *
FROM customers
WHERE score != 0

-- Retriev customers from Germany 

SELECT 
	first_name,
	country
FROM customers
WHERE country = 'Germany'
