-- Use Cases --

-- Central Query Logic --

/* Find the running total of sales for each month */

WITH CTE_Monthly_Summary AS (
	SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities
	FROm Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)
SELECT
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary

-- CREATE VIEW --

CREATE VIEW V_Monthly_Summary AS 
(
SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)

SELECT
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM V_Monthly_Summary

CREATE VIEW Sales.V_Monthly_Summary AS 
(
SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)

-- DROP VIEW --

DROP VIEW V_Monthly_Summary

DROP VIEW Sales.V_Monthly_Summary

CREATE VIEW Sales.V_Monthly_Summary AS 
(
SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)
-- Or T-SQL--

IF OBJECT_ID ('Sales.V_Monthly_Summary', 'V') IS NOT NULL
	DROP VIEW Sales.V_Monthly_Summary;
GO
CREATE VIEW Sales.V_Monthly_Summary AS 
(
SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)

-- Views Use Case --

/* Provide a view that combines details from orders, products, customers and employees */

CREATE VIEW Sales.V_Order_Details AS (
	SELECT
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') CustomerName,
	c.Country CustomerCountry,
	COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') SalesName,
	e.Department,
	o.Sales,
	o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON p.ProductID = o.ProductID 
	LEFT JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID 
	LEFT JOIN Sales.Employees e
	ON e.EmployeeID = o.SalesPersonID 
)

SELECT 
*
FROM Sales.V_Order_Details

-- Data Security --
 
/* Provide a view for the EU Sales Team that combines details from all tables and excludes data related to the USA */

CREATE VIEW Sales.V_Order_Details_EU AS (
	SELECT
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') CustomerName,
	c.Country CustomerCountry,
	COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') SalesName,
	e.Department,
	o.Sales,
	o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON p.ProductID = o.ProductID 
	LEFT JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID 
	LEFT JOIN Sales.Employees e
	ON e.EmployeeID = o.SalesPersonID 
	WHERE c.Country != 'USA'
)

SELECT
*
FROM Sales.V_Order_Details_EU

-- Flexibility and Dynamic --

-- Multiple Languages -- 

-- Virtual Data Marts in DWH --

