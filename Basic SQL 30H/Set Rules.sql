-- UNION --

/* Combine the data from employees and customers into one table */

SELECT 
FirstName,
LastName
FROM Sales.Employees
UNION 
SELECT 
FirstName,
LastName
FROM Sales.Customers

/* The order of queries in a UNION operation does not affect the result */

-- UNIION ALL -- 

/* Combine the data from employees and customers into one table, inlcuding duplicates */

SELECT 
FirstName,
LastName
FROM Sales.Employees
UNION ALL 
SELECT 
FirstName,
LastName
FROM Sales.Customers;

/* UNION ALL is generally faster yhan UNION */
/* If you're confident there are no duplicates, use UNION ALL */
/* Use UNION ALL to find duplicates and queality issues*/
/* The order of queries in a UNION ALL operation does not affect the result */

-- EXCEPT --

/* Find employees who are not customers at the same time */

SELECT 
FirstName,
LastName
FROM Sales.Employees
EXCEPT 
SELECT 
FirstName,
LastName
FROM Sales.Customers;

/* It shows the ones who are not duplicated and the ones who are duplicated doesn't appear */
/* The order of queries in a EXCEPT operation affects the result */

-- INTERSECT --

/* Find the employees who are also customers*/

SELECT 
FirstName,
LastName
FROM Sales.Employees
INTERSECT
SELECT 
FirstName,
LastName
FROM Sales.Customers;

/* Returns only rows that are common in both queries*/
/* The order of queries in a INTERSECT operation does not affect the result */


-- EXAMPLE COMBINE INFORMATION --

/* Orders data are stored in separate tables (Orders and OrdersArchive)
Combine all orders data into one report without duplicates */

SELECT 
'Orders' AS SourceTable
,[OrderID]
,[ProductID],
[CustomerID],
[SalesPersonID],
[OrderDate],
[ShipDate],
[OrderStatus],
[ShipAddress],
[BillAddress],
[Quantity],
[Sales],
[CreationTime]
FROM Sales.Orders
UNION  
SELECT 
'OrdersArchive' AS SourceTable
,[OrderID]
,[ProductID]
,[CustomerID]
,[SalesPersonID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID

/* Include additional column to indicate the source of each row*/
/* Never use an asterisk(*) to combine tables; list needed columns instead */

