--  Aggregate Window Function --

-- COUNT --

/* Find the total number of orders */

-- OVERALL ANALYSIS --

SELECT
COUNT(*) TotalOrders 
FROM Sales.Orders

/* This is used to take a quick summary or snapshot of the entire dataset */

/* Find the total number of orders, additionally provide details such order ID, order date */

SELECT
OrderID,
OrderDate,
COUNT(*) OVER() TotalOrders 
FROM Sales.Orders

/* Find the total number of orders, the total orders for each customer,
additionally provide details such order ID, order date */

-- TOTAL PER GROUPS --

SELECT
OrderID,
OrderDate,
CustomerID,
COUNT(*) OVER() TotalOrders,
COUNT(*) OVER(PARTITION BY CustomerID) OrdersByCustomers
FROM Sales.Orders

/* Gruo-wise analysis, to understand patterns within different categories */


/* Find the total number of customer,
additionally provide all customer's details */

SELECT
*,
COUNT(*) OVER () TotalCustomers
FROM Sales.Customers

/* Find the total number of customer,
Find the total number of scores for the customers,
additionally provide all customer's details */

-- DATA QUALITY CHECK --

-- IDENTIFY NULLs --

SELECT
*,
COUNT(*) OVER () TotalCustomersStar,
COUNT(1) OVER () TotalCustomersOne,
COUNT(Score) OVER() TotalScores,
COUNT(Country) OVER() TotalCountry
FROM Sales.Customers

/* Detecting number of NULLS by comparing to total number of rows */

-- IDENTIFY DUPLICATES --

/* Check whether the table 'Orders' contains any duplicate rows */

SELECT
	OrderID,
	COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.Orders
/*Maximum number of rows for each window (ID) = 1 */

SELECT
*
FROM (
	SELECT
		OrderID,
		COUNT(*) OVER (PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
)t WHERE CheckPK > 1

/* Identify duplicate rows to improve data quality */



-- SUM --

-- OVERALL ANALYSIS --

/* Find the total sales across all orders 
Additionally, provide details such as order ID and order date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	SUM(Sales) OVER() TotalSales
FROM Sales.Orders
/* Quick summary or snsapshot of the entire dataset */

-- TOTAL PER GROUPS --

/* Find the total sales across all orders 
and the total sales for each product.
Additionally, provide details such as order ID and order date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) SalesByProducts
FROM Sales.Orders
/* Group-wise analysis, to understand patterns within different categories */

-- COMPARISION ANALYSIS --

-- Part-To-Whole --

/*Find the percentage contribution of each product's sales to the total sales */

SELECT
OrderID,
ProductID,
Sales,
SUM(Sales) OVER() TotalSales,
ROUND (CAST (Sales AS FlOAT) / SUM (Sales) OVER () * 100,2) PercentageOfTotal
FROM Sales.Orders
/* Shows the contribution of each data point to the overall dataset */



-- AVG --

-- Overall Analysis --

/* Find the average sales across all orders 
Additionally, provide details such as order ID and order date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	AVG(Sales) OVER () AvgSales
FROM Sales.Orders
/* Quick summary or snapshot of the entire dataset */


-- Total Per Groups --

/* Find the average sales across all orders 
and the average sales for each product.
Additionally, provide details such as order ID and order date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	AVG(Sales) OVER () AvgSales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProducts
FROM Sales.Orders
/* Group-wise analysis, to understand patterns within defferent categories */


-- Removing NULLs --

/* Find the average scores of customers.
Additionally, provide details such as Customer ID and Last Name */

SELECT 
	CustomerID,
	LastName,
	Score,
	COALESCE(Score,0) CustomerScore,
	AVG(Score) OVER () AvgScore,
	AVG(COALESCE(Score,0)) OVER () AvgScoreWithoutNull
FROm Sales.Customers


-- Compare To Average --

/* Find all orders where sales are higher than the average sales across all orders */

SELECT 
*
FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER () AvgSales
	FROM Sales.Orders
)t WHERE Sales > AvgSales 
/* Helps to evaluate whether a value is above or below the average */


-- MIN and MAX --

-- Overall Analysis --

/* Find the highest and lowest sales across all orders 
Additionally, provide details such as order ID and order date */

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER() LowestSales
FROM Sales.Orders
/* Quick summary or snapshot of the entire dataset */


-- Total Per Groups --

/* Find the highest and lowest sales across all orders 
and the highest and lowest sales for each product.
Additionally, provide details such as order ID and order date */

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER() LowestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) HighestSalesByProduct,
	MIN(Sales) OVER(PARTITION BY ProductID) LowestSalesByProduct
FROM Sales.Orders
/* Group-wise analysis, to understand patterns within different categories */

-- Use Case -- 

/* Show the employees with the highest salaries */

SELECT
*
FROM (
	SELECT
	*,
	MAX(Salary) OVER() HighestSalary
	FROM Sales.Employees
)t WHERE Salary = HighestSalary


-- Comparison Analysis --

-- Compare To Extremes --

/* Calculate the deviation of each sale from both the minimum and maximum sales amounts */

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER() LowestSales,
	Sales - MIN(Sales) OVER () DeviationFromMin,
	MAX(Sales) OVER () - Sales DeviationFromMax
FROM Sales.Orders 
/* Help to evaluate how well a value is performing relative to the extremes */



-- RUNNING and ROLLING TOTAL --

-- Moving Average --

/* Calculate the moving average of sales for each product over time */

SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg
FROM Sales.Orders

 
-- Rolling Average --

/* Calculate the moving average of sales for each product over time,
including only the next order */

SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders
