-- CTA --

-- PERMANENT TABLES --

-- Use Cases --

-- Optimize Performance --

SELECT 
	DATENAME(month, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders 
GROUP BY DATENAME (month, OrderDate) 

SELECT *
FROM Sales.MonthlyOrders

DROP TABLE Sales.MonthlyOrders

-- How to refresh CTAS ? --
-- DROP and RECREATE or  --

IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
DROP TABLE Sales.MonthlyOrders;
GO
SELECT 
	DATENAME(month, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders 
GROUP BY DATENAME (month, OrderDate) 

-- Creating a Snapshot --

-- Physical Data Marts in DWH --

-- TEMPORARY TABLES --

SELECT 
*
INTO #Orders
FROM Sales.Orders 

SELECT 
*
FROM #Orders 

DELETE FROM #Orders 
WHERE OrderStatus = 'Delivered'

SELECT 
*
FROM #Orders 

SELECT 
*
INTO Sales.OrdersTest
FROM #Orders 

-- Use Case --

-- Intermediate Results --

