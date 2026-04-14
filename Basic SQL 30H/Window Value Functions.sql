-- LEAD and LAG --

-- Time Series Analysis --

/* The process of analyzing the data to understand patterns, trends, and behaviors over time.*/

-- Year-Over-Year Analysis --

/* Analyze the overall growth or decline of the business's performance over time.*/

-- Month-Over-Month Analysis --

/* Analyze short-term trends and discover patterns in seasonality.*/

/* Find the month-over-month performance 
by finding the percentage change in sales
between the current and previous month */

SELECT
*,
CurrentMonthSales - PreviousMonthSales AS MoM_Change,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/PreviousMonthSales * 100, 1) AS MoM_Perc
FROM (
	SELECT
		MONTH(OrderDate) OrderMonth,
		SUM(Sales) CurrentMonthSales,
		LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales
	FROM Sales.Orders
	GROUP BY 
		MONTH(OrderDate)
)t

-- Customer Retention Analysis -- 

/* Analyze customer loyalty by ranking customers based on the average number of days between orders*/

SELECT
CustomerID,
AVG(DaysUntilNextOrder) AvgDays,
RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 99999)) RankAvg
FROM (
	SELECT 
		OrderID,
		CustomerID,
		OrderDate CurrentOrder,
		LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
		DATEDIFF(day,OrderDate, LEAD (OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM Sales.Orders
)t
GROUP BY 
	CustomerID

/* Measure customers's behavior and loyalty to help businesses build strong relationships with customers */

-- FIRST_VALUE and LAST_VALUE --

-- Compare to Extrems --

/* Find the lowest and highest sales for each product */

SELECT 
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales 
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) HighestSales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2,
	MIN(Sales) OVER (PARTITION BY ProductID) LowestSales2,
	MAX(Sales) OVER (PARTITION BY ProductID) HighestSales3
FROM Sales.Orders 

/* How well a value is performing relative to the extremes */


/* Find the lowest and highest sales for each product
and the difference in sales between the current and the lowest sales*/

SELECT 
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales 
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) HighestSales,
	Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) LowestSales
FROM Sales.Orders 