-- SUBQUERIES --

-- FROM Subquery --

/* Find the products that have a price higher than the average price of all products */

SELECT
*
FROM (
	SELECT
		ProductID,
		Price,
		AVG(Price) OVER() AvgPrice
		FROM Sales.Products)t
WHERE price > AvgPrice  

/* Rank customers based on their total amount of sales */

SELECT
*,
RANK() OVER (ORDER BY TotalSales DESC) CustomerRank
FROM (
	SELECT
		CustomerID,
		SUM(Sales) TotalSales
		FROM Sales.Orders
		GROUP BY CustomerID)t


-- SELECT Subquery --

/* Show the product IDs, names, prices and total number of orders */

SELECt
	ProductID,
	Product,
	Price,
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products

-- JOIN Subquery --

/* Show all customer details and find the total orders for each customer */

SELECT
c.*,
o.TotalOrders
FROM Sales.Customers c
LEFT JOIN (
	SELECT
	CustomerID,
	COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID

-- WHERE Subquery --

-- Comparison Operators --
/* Find the products that have a price higher than the average price of all products */

SELECT
ProductID,
Price,
(SELECT AVG(Price) FROM Sales.Products) AvgPrice 
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

-- Logical Operators --

-- IN and NOT IN Subquery --

/* Show the details of orders made by customers in Germany */

SELECT
*
FROM Sales.Orders
WHERE CustomerID IN
					(SELECT
					CustomerID
					FROM Sales.Customers
					WHERE Country = 'Germany')

/* Show the details of orders made by customers that are not from Germany */

SELECT
*
FROM Sales.Orders
WHERE CustomerID NOT IN
						(SELECT
						CustomerID
						FROM Sales.Customers
						WHERE Country = 'Germany')

-- ANY and ALL Subqueries --

-- ANY Subquery --

/* Find female employees whose salaries are greater than the salaries of any male employees */

SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

-- ALL Subquery --

/* Find female employees whose salaries are greater than the salaries of all male employees */

SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

-- Non-Correlated and Correlated Subqueries --

-- Correlated Subqueries --

/* Show all custom,er details and find the total orders of each customer */

SELECT
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales 
FROM Sales.Customers c


-- EXIST and NOT EXISTS Subqueries --

/* Show the datails of orders made by customers in Germany */

SELECT
*
FROM Sales.Orders o
WHERE EXISTS ( SELECT 1
			   FROM Sales.Customers c
			   WHERE Country = 'Germany'
			   AND o.CustomerID = c.CustomerID)

