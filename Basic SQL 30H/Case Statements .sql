-- CASE STATEMENTS --


--USE CASES--


-- Categorizing Data --

/* Generate a report showing the total sales for each category:
High: If the sales higher than 50
Medium: If the salws between 20 and 50 
Low: If the sales equal or lower than 20
Sort the results from highest to lowest */
SELECT
Category,
SUM(Sales) AS TotalSales
FROM(
	SELECT 
	OrderID,
	Sales,
	CASE 
		WHEN Sales > 50 THEN 'High'
		WHEN Sales > 20 THEN 'Medium'
		ELSE 'Low'
	END Category
	FROM Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSales DESC

-- Mapping Values --

/* Retrieve employee details with gender displayed as full text */

SELECT
EmployeeID,
FirstName,
LastName,
Gender,
CASE 
	WHEN Gender = 'F' THEN 'Female'
	WHEN Gender = 'M' THEN 'Male'
	ELSE 'Not Available'
END GenderFullText
FROM Sales.Employees

/* Retriev customers details with abbreviated country code */

SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA'     THEN 'US'
		ELSE 'n/a'
	END CountryAbbr,
/* It's the quick form to do it but it's better to do it the 'long way' */
		CASE Country 
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA'     THEN 'US'
		ELSE 'n/a'
	END CountryAbbr2
FROM Sales.Customers



SELECT DISTINCT Country 
FROM Sales.Customers

-- Handling Nulls --

/* Find the avwrage scores of customers and treat Nulls as 0 
And additiional provide details such CustomerID and LastName */


SELECT
CustomerID,
LastName,
Score,
CASE 
	WHEN Score IS NULL THEN 0
	ELSE Score
END ScoreClean,

AVG(CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
    END) OVER () AvgCustomerClean,

AVG(Score) OVER () AvgCustomer
FROM Sales.Customers

-- Conditional Aggregation --

/* Count how many times each customer has made an order with sales greater than 30 */

SELECT
	CustomerID,
	SUM(CASE
			WHEN Sales > 30 THEN 1
			ELSE 0
		END) TotalOrdersHighSales,
		COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID