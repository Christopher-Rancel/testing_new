-- Retrieve all customers from either Germany or USA --

SELECT *
FROM customers
WHERE country IN ('Germany', 'USA')

-- Using IN or NOT IN is faster and better if there are a lot of same values --
SELECT *
FROM customers
WHERE country = 'Germany' OR country = 'USA'