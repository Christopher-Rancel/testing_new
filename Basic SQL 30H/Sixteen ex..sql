-- Change the score of customer with ID 6 to 0 --

UPDATE customers
SET score = 0
WHERE id = 6

SELECT *
FROM customers

-- Change the score of customer with ID 10 to 0 and update the country to 'UK' --

UPDATE customers
SET score = 0,
	country = 'UK'
WHERE id = 10

-- Udate all customers with a NULL score by setting their score to 0 --

UPDATE customers
SET score = 0
WHERE score IS NULL

SELECT *
FROM customers
WHERE score IS NULL

