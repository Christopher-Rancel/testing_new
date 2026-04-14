-- Select the total score for each country

SELECT 
country,
SUM(score) AS total_score
FROM customers
GROUP BY country

-- Select the total score and total number of costumers for each country.

SELECT
	country,
	SUM(score) AS total_score,
	COUNT(id) AS total_costumers 
FROM customers
GROUP BY country


