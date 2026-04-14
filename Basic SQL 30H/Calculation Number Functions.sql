-- CALCULATIONS --

 -- DATEADD --

 SELECT
 OrderID,
 OrderDate,
 DATEADD(day, -10, OrderDate) AS TenDayrsLater,
 DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
 DATEADD(year, 2, OrderDate) AS TwoYearsLater
 FROM Sales.Orders

 -- DATEDIFF --


 /* Calculate the age of the employees */


 SELECT 
 EmployeeID,
 BirthDate,
 DATEDIFF(year, BirthDate, GETDATE()) AGE
 FROM Sales.Employees 

 /* Find the averagge shipping duration in days for each month */

 SELECT
 MONTH(OrderDate) AS OrderDate,
 AVG(DATEDIFF(day, OrderDate, ShipDate)) AvgShip
 FROM Sales.Orders
 GROUP BY MONTH(OrderDate)

 /* Find the number of days between each order and previous order */

 SELECT 
 OrderID,
 OrderDate CurrentOrderDate,
 LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
 DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) NrOfDays 
 FROM Sales.Orders 

 /* That excercise it's caalled Time Gap Analysis and is very common in the data analyst sector */

 -- ISDATE --

 SELECT
 ISDATE('123') DateCheck1,
 ISDATE('2025-08-20') DateCheck2,
 ISDATE('20-08-2025') DateCheck3,
 ISDATE('2025') DateCheck4,
 ISDATE('08') DateCheck5

 /* EXAMPLE */

 SELECT
	-- CAST(OrdersDate AS DATE) OrderDate,
	 OrderDate,
	ISDATE(OrderDate),
	CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		ELSE '9999-01-01'
	END NewOrderDate
FROM
(
	SELECT '2025-08-20' AS OrderDate UNION
	SELECT '2025-08-21' UNION
	SELECT '2025-08-23' UNION
	SELECT '2025-08'
)t
-- WHERE ISDATE(OrderDate) = 0 --