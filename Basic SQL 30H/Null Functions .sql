-- ISNULL and COALESCE --

/* Find the avarage scores of the customers */

SELECT
CustomerID,
Score,
COALESCE(Score,0) Score2,
AVG(Score) OVER () AvgScores,
AVG(COALESCE(Score,0)) OVER () AvgScores2
FROM Sales.Customers

/* Display the full name of customers in a single field
by merging their first and last names,
and add 10 bonus points to each customer's score */

SELECT
CustomerID,
FirstName,
LastName,
FirstName + ' ' + COALESCE(LastName, '') AS FullName,
Score,
COALESCE(Score,0) + 10 AS ScoreWithBonus
FROM Sales.Customers

/* Sort the customers from lowest to highest scores,
with NULLS appering last */

SELECT
CustomerID,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score 

-- NULLIF --

/* Find the sales price for each order by dividing sales by quantity */

SELECT
OrderID,
Sales,
Quantity,
Sales / NULLIF(Quantity,0) AS Price
FROM Sales.Orders

-- IS NULL and IS NOT NULL --

/* Identify the customers who have no scores */

SELECT 
*
FROM Sales.Customers
WHERE Score IS NULL 

/* List of all customers who have scores */

SELECT 
*
FROM Sales.Customers
WHERE Score IS NOT NULL 

/* List all details for customers who have not placed any orders */

SELECT
c.*,
o.OrderID
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL 

-- Diference between NULL, EMPTY STRINGS and BLANKS --

WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)
SELECT
*,
TRIM(Category) Policy1,
NULLIF(TRIM(Category), '') Policy2,
COALESCE(NULLIF(TRIM(Category), '') , 'unknown') Policy3
FROM Orders 