-- Common Table Expression --

-- None_Recursive --

-- Standalone CTE --

/* Step 1: Find the total sales per customer */

WITH CTE_Total_Sales AS
(
SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders 
GROUP BY CustomerID
)
/* Step 2: Find the last order date for each customer */
, CTE_Last_Order AS
(
SELECT
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders 
GROUP BY CustomerID
)
/* Step 3: Rank customers based on total sales for customers */
, CTE_Customer_Rank AS
(
SELECT
CustomerID,
TotalSales,
RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank 
FROM CTE_Total_Sales
)
/* Step 4: segment customners based on their total sales (Nested CTE) */
, CTE_Customer_Segments AS 
(
SELECT
CustomerID,
CASE WHEN TotalSales > 100 THEN 'High'
	 WHEN TotalSales > 80 THEN 'Medium'
	 ELSE 'Low'
END CustomerSegnments
FROM CTE_Total_Sales 
)
--Main Query --
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order,
ccr.CustomerRank,
ccs.CustomerSegnments
FROM Sales.Customers c 
LEFT JOIN CTE_Total_Sales cts 
ON cts.CustomerID = c.CustomerID 
LEFT JOIN CTE_Last_Order clo 
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments ccs
ON ccs.CustomerID = c.CustomerID

-- Recursive CTE --

/* Generate a sequence of numbers from 1 to 20 */

WITH Series AS (
	-- Anchor query 
	SELECT 
	1 AS MyNumber 
	UNION ALL 
	-- Recursive Query 
	SELECT 
	MyNumber + 1
	FROM Series 
	WHERE MyNumber < 20
)
-- Main Query 
SELECT *
FROM Series 
OPTION (MAXRECURSION 500) -- With that you can amplified the amount of rows that it shows 


/* Show the employee hierarchy by displaying each employee's level within the organization */

WITH CTE_Emp_Hierarchy AS 
(
	-- Anchor Query
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level
	FROM Sales.Employees
	WHERE ManagerID IS NULL 
	UNION ALL 
	-- Recursive Query 
	SELECT
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Level + 1
	FROM Sales.Employees AS e
	INNER JOIN CTE_Emp_Hierarchy ceh
	ON e.ManagerID = ceh.EmployeeID
) 
--Main Query 
SELECT
*
FROM CTE_Emp_Hierarchy