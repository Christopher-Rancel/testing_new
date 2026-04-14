-- Window Functions or Analytical Functions --

-- GROUP BY vs WINDOW --

-- Why we need WINDOW FUNCTIONS? and Why GROUP BY is not enough? --

/* Find the total sales acroos all orders */

 SELECT 
 SUM(Sales) TotalSales
 FROM Sales.Orders

 /* Find the total sales for each products */

  SELECT 
	 ProductID,
	 SUM(Sales) TotalSales
 FROM Sales.Orders
 GROUP BY ProductID

  /* Find the total sales for each products,
  additionally provide details such order id and order date */

SELECT 
	OrderID
	OrderDate,
	ProductID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY 
	OrderID,
	OrderDate,
	ProductID
/* That doesn't work beecause the first part of the excercise it can't be done with GROUP BY because it can't do
aggregations and provide details at the same time */

/* Find the total sales for each products,
  additionally provide details such order id and order date */
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER (PARTITION BY ProductID) TotalSalesByProducts
FROM Sales.Orders
/* This is the good way to do it */

-- OVER clause --

-- PRTITION BY --

/* Find the total sales across all orders,
additionally provide details such order Id, order date */

SELECt
OrderID,
OrderDate,
SUM(Sales) OVER () TotalSales
FROM Sales.Orders

/* Find the total sales for each product,
additionally provide details such order Id, order date */

SELECT
OrderID,
OrderDate,
ProductID,
SUM(Sales) OVER (PARTITION BY ProductID) TotalSales
FROM Sales.Orders

/* Find the total sales for each product,
the total sales across all orders,
additionally provide details such order Id, order date */

SELECT
OrderID,
OrderDate,
ProductID,
Sales,
SUM(Sales) OVER () TotalSales,
SUM(Sales) OVER (PARTITION BY ProductID) TotalSalesByProducts
FROM Sales.Orders

/* Find the total sales for each product,
the total sales across all orders.
Find the total sales for each combination of product and order status,
additionally provide details such order Id, order date */

SELECT
OrderID,
OrderDate,
ProductID,
OrderStatus,
Sales,
SUM(Sales) OVER () TotalSales,
SUM(Sales) OVER (PARTITION BY ProductID) TotalSalesByProducts,
SUM(Sales) OVER (PARTITION BY ProductID,OrderStatus) SalesByProductsAndStatus
FROM Sales.Orders

-- ORDER BY --

/* Rank each order based on their sales from highest to lowest,
additionally provide details such order id and order date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) RankSales
FROM Sales.Orders 

--WINDOW FRAME--

SELECT 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales 
FROM Sales.Orders 

-- RULES --

/* Find total sales for eaCH ORDER STATUS,
	ONLY FOR TWO PRODUCTS 101 AND 102*/

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders 
WHERE ProductID IN (101,102) 

/* Rank customers based on their total sales */

/* 1- STEP: Add GROUP BY to the query */
/* 2- STEP: Add WINDOW function to the query */

SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
































