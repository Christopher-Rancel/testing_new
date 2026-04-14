-- FETCHING DATA --

-- =================================================
-- Tip 1: Select Only What You Need 
-- =================================================

-- Bad Practice
SELECT * FROM Sales.Customers

-- Good Practice
SELECT CustomerID, FirstName, LastName FROM Sales.Customers

-- =================================================
-- Tip 2: Avoid unnecessary DISTINCT and ORDER BY 
-- =================================================

-- Bad Practice
SELECT DISTINCT 
	FirstName
FROM Sales.Customers
ORDER BY FirstName

-- Good Practice
SELECT FirstName
FROM Sales.Customers 

-- =================================================
-- Tip 3: For Exploration Purpose, Limit Rows
-- =================================================

-- Bad Practice
SELECT 
	OrderID,
	Sales
FROM Sales.Orders

-- Good Practice
SELECT TOP 10
	OrderID,
	Sales
FROM Sales.Orders

-- FILTERING DATA --

-- =================================================
-- Tip 4: Create nonclustered index on frequently used columns in WHERE clause
-- =================================================

SELECT * FROM Sales.Orders WHERE OrderStatus = 'Delivered'

CREATE NONCLUSTERED INDEX idx_Orders_OrderStatus ON Sales.Orders(OrderStatus)

-- =================================================
-- Tip 5: Avoid applying functions to columns in WHERE clauses 
-- =================================================

-- Bad Practice
SELECT * FROM Sales.Orders 
WHERE LOWER(OrderStatus) = 'delivered'

-- Good Practice
SELECT * FROM Sales.Orders 
WHERE OrderStatus = 'Delivered'

-- Bad Practice 
SELECT *
FROM Sales.Customers
WHERE SUBSTRING(FirstName, 1, 1) = 'A'

-- Good Practice
SELECT *
FROM Sales.Customers
WHEN FirstName LIKE 'A%'

-- Bad Practice
SELECT *
FROM Sales.Orders 
WHERE YEAR(OrderDate) = 2025

-- Good Practice 
SELECT *
FROM Sales.Orders
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31'

-- =================================================
-- Tip 6: Avoid leading wildcards as they prevent index usage 
-- =================================================

-- Bad Practice 
SELECT *
FROM Sales.Customers 
WHERE LastName LIkE '%Gold%'

-- Good Practice
SELECT *
FROM Sales.Customers 
WHERE LastName LIKE 'Gold%'

-- =================================================
-- Tip 7: Use IN instead of multiple OR 
-- =================================================

-- Bad Practice 
SELECT *
FROM Sales.Orders 
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3

-- Good Practice
SELECT *
FROM Sales.Orders 
WHERE CustomerID IN (1, 2, 3)

-- JOINING DATA --

-- =================================================
-- Tip 8: Understand the speed of joins and use INNER JOIN when possible 
-- =================================================

-- Best Performance 
SELECT c.FirstName, o.OrderID FROM Sales.Customers c INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID 

-- Slightly Slower Performance 
SELECT c.FirstName, o.OrderID FROM Sales.Customers c RIGHT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID 
SELECT c.FirstName, o.OrderID FROM Sales.Customers c LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID 

-- Worst Performance 
SELECT c.FirstName, o.OrderID FROM Sales.Customers c OUTER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID 

-- =================================================
-- Tip 9: Use explicit join (ANSI join) Instead of implicit join (non-ANSI join)
-- =================================================

-- Bad Practice 
SELECT o.OrderId, c.FirstName 
FROM Sales.Customers c, Sales.Orders o
WHERE c.CustomerID = o.CustomerID

-- Good Practice
SELECT o.OrderID, c.FirstName 
FROM Sales.Customers c 
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID 

-- =================================================
-- Tip 10: Make sure toIndex the columns used in the ON clause
-- =================================================

SELECT c.FirstName, o.OrderID
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

CREATE NONCLUSTERED INDEX IX_Order_CustomerID ON Sales.Orders(CustomerID) 

-- =================================================
-- Tip 12: Filter Before Joining (Big tables)
-- =================================================

-- Best Practice For Small-Medium Tables
-- Filter After Join (WHERE)
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'

-- Filter during Join (ON)
SELECT c.FirstName, o.OrderID 
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
AND o.OrderStatus = 'Delivered'

-- Best Practice For Big Tables
-- Filter Before Join (SUBQUERY)
SELECT c.FirstName, o.OrderID 
FROM Sales.Customers c
INNER JOIN ( SELECT OrderID, CustomerID FROM Sales.Orders WHERE OrderStatus = 'Delivered') o
ON c.CustomerID = o.CustomerID

-- =================================================
-- Tip 12: Aggregate before joining (Big tables) 
-- =================================================

-- Best Practice For Small-Medium Tables
-- Grouping and Joining
SELECT 
    c.CustomerID, 
    c.FirstName, 
    COUNT(o.OrderID) AS OrderCount
FROM Sales.Customers c
INNER JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName;


-- Best Practice For Big Tables
-- Pre-aggregated Subquery
SELECT 
    c.CustomerID, 
    c.FirstName, 
    o.OrderCount
FROM Sales.Customers c
INNER JOIN (
    SELECT 
        CustomerID, 
        COUNT(OrderID) AS OrderCount
    FROM Sales.Orders
    GROUP BY CustomerID
) o
    ON c.CustomerID = o.CustomerID;


-- Bad Practice
-- Correlated Subquery
SELECT 
    c.CustomerID,
    c.FirstName,
    (SELECT COUNT(o.OrderID)
     FROM Sales.Orders o
     WHERE o.CustomerID = c.CustomerID) AS OrderCount
FROM Sales.Customers c;

-- =================================================
-- Tip 13: Use Union Instead of OR in Joins
-- =================================================

-- Bad Practice
SELECT 
    o.OrderID, 
    c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
    OR c.CustomerID = o.SalesPersonID;


-- Best Practice
SELECT 
    o.OrderID, 
    c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
UNION
SELECT 
    o.OrderID, 
    c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
    ON c.CustomerID = o.SalesPersonID;

-- =================================================
-- Tip 14: Check for nested loops and use SQL HINTS 
-- =================================================

SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- Good practice for having big table and small table 
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OPTION (HASH JOIN)

-- =================================================
-- Tip 15: Use UNION ALL instead of using UNION if duplicates are acceptable
-- =================================================

-- Bad Practice
SELECT CustomerID FROM Sales.Orders
UNION 
SELECT CustomerID FROM Sales.OrdersArchive

-- Best Practice
SELECT CustomerID FROM Sales.Orders
UNION ALL 
SELECT CustomerID FROM Sales.OrdersArchive 

-- =================================================
-- Tip 16: Use UNION ALL + Diatinct instead of using UNION if duplicates are not acceptable
-- =================================================

-- Bad Practice
SELECT CustomerID FROM Sales.Orders
UNION 
SELECT CustomerID FROM Sales.OrdersArchive

-- Best Practice
SELECT DISTINCT CustomerID 
FROM (
    SELECT CustomerID FROM Sales.Orders 
    UNION ALL 
    SELECT CustomerID FROM Sales.OrdersArchive
) AS CombinedData
