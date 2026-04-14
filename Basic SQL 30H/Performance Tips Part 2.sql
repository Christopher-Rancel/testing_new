-- AGGREGATING DATA --

-- =================================================
-- Tip 17: Use Columnstore index for Aggregations on large table
-- =================================================

SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM Sales.Orders 
GROUP BY CustomerID 

CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore ON Sales.Orders 

-- =================================================
-- tip 18: Pre-Agreggate data and store it in new table for reporting 
-- =================================================

SELECT MONTH(OrderDate) OrderYear, SUM(Sales) AS TotalSales
INTO Sales.SalesSummary
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

SELECT OrderYear, TotalSales FROM Sales.SalesSummary 

-- SUBQUERIES --

-- =================================================
-- Tip 19: JOIN vs EXISTS vs IN 
-- =================================================

-- Best Practice: If the performance equals to EXISTS 
-- JOIN 
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'

-- Best Practice: Use it for large tables 
-- EXISTS 
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE EXISTS (
	SELECT 1
	FROM Sales.Customers c
	WHERE c.CustomerID =o.CustomerID
	AND c.Country = 'USA'
)

-- Bad Practice
-- IN 
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE o.CustomerID IN (
	SELECT CustomerID
	FROM Sales.Customers
	WHERE Country = 'USA'
)

-- =================================================
-- Tip 20: Avoid redundant logic in your query
-- =================================================

-- Bad Practice 
SELECT EmployeeID, FirstName, 'Above Average' Status
FROM Sales.Employees 
WHERE Salary > (SELECT AVG(Salary) FROM Sales.Employees)
UNION ALL 
SELECT EmployeeID, FirstName, 'Below Average' Status
FROM Sales.Employees 
WHERE Salary < (SELECT AVG(Salary) FROM Sales.Employees)

-- Good Practice 
SELECT 
	EmployeeID,
	FirstName,
	CASE
		WHEN Salary > AVG(Salary) OVER () THEN 'Above Average'
		WHEN Salary < AVG(Salary) OVER () THEN 'Below Average'
		ELSE 'Average'
		ELSE 'Average'
	END AS Status
FROM Sales.Employees 

-- CREATING TABLES (DDL) --

-- =================================================
-- Tip 21: Avoid Data types VARCHAR and TEXT
-- =================================================

-- Bad Practice
CREATE TABLE CustomersInfo (
	CustomerID INT,
	FirstName VARCHAR (MAX),
	LastName TEXT,
	Country VARCHAR (255),
	TotalPurchases FLOAT,
	Score VARCHAR (255),
	BirthDate VARCHAR(255),
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employee(EmployeeID)
)

-- Good Practice 
CREATE TABLE CustomersInfo (
	CustomerID INT,
	FirstName VARCHAR (MAX),
	LastName VARCHAR(50),
	Country VARCHAR (255),
	TotalPurchases FLOAT,
	Score INT,
	BirthDate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employee(EmployeeID)
)

-- =================================================
-- Tip 22: Avoid (MAX) unnecessarily large lenghts in data types 
-- =================================================

CREATE TABLE CustomersInfo (
	CustomerID INT,
	FirstName  VARCHAR(50),
	LastName VARCHAR(50),
	Country VARCHAR (50),
	TotalPurchases FLOAT,
	Score INT,
	BirthDate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employee(EmployeeID)
)

-- =================================================
-- Tip 23: Use the NOT NULL constraint where applicable
-- =================================================

CREATE TABLE CustomersInfo (
	CustomerID INT,
	FirstName  VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Country VARCHAR (50) NOT NULL,
	TotalPurchases FLOAT,
	Score INT,
	BirthDate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employee(EmployeeID)
)

-- =================================================
-- Ensure all your tables have a clustered primary key 
-- =================================================

CREATE TABLE CustomersInfo (
	CustomerID INT PRIMARY KEY CLUSTERED,
	FirstName  VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Country VARCHAR (50) NOT NULL,
	TotalPurchases FLOAT,
	Score INT,
	BirthDate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employee(EmployeeID)
)

-- =================================================
-- Tip 25: Create non-clustered index for foreign keys that are used frequently
-- =================================================

CREATE TABLE CustomersInfo (
	CustomerID INT PRIMARY KEY CLUSTERED,
	FirstName  VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Country VARCHAR (50) NOT NULL,
	TotalPurchases FLOAT,
	Score INT,
	BirthDate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employee(EmployeeID)
)

CREATE NONCLUSTERED INDEX IX_CustomersInfo_EmployeeID
ON CustomersInfo(EmployeeID)

-- INDEXING --

-- =================================================
-- Tip 26: Avoid over Indexing 
-- =================================================


-- =================================================
-- Tip 27: Drop unused indexes 
-- =================================================


-- =================================================
-- Tip 28: Update Statistics
-- =================================================


-- =================================================
-- Tip 29: Reorganize and rebuild indexes (Weekly)
-- =================================================


-- =================================================
-- Tip 30: Partition large tables (Facts) to improve performance. Next, apply a columnstore index for the best results
-- =================================================
 