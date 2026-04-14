-- Format and Casting --

-- FORMAT --

SELECT
OrderId,
CreationTime,
FORMAT(CreationTime,'MM-dd-yyyy') USA_Format,
FORMAT(CreationTime,'dd-MM-yyyy') EU_Format,
FORMAT(CreationTime,'dd') dd,
FORMAT(CreationTime,'ddd') ddd,
FORMAT(CreationTime,'dddd') dd,
FORMAT(CreationTime,'MM') MM,
FORMAT(CreationTime,'MMM') MMM,
FORMAT(CreationTime,'MMMM') MMMM
FROM Sales.Orders

/* Show CreationTime using the following format:
Day Wed Jan Q1 2025 12:34:56 PM */


SELECT 
OrderID,
CreationTime,
'Day' + FORMAT(CreationTime, ' ddd MM') +
' Q' + DATENAME(quarter, CreationTime) +
' ' + FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomeFormat
FROM Sales.Orders 

-- EXCERCISE --

/* To customize the format of the results */

SELECT 
FORMAT(OrderDate, 'MMM yy') OrderDate,
COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')


-- CONVERT --

--CASTING--

SELECT
CONVERT(INT, '123') AS [String to Int CONVERT],
CONVERT(DATE, '2025-08-20') AS [String to Date CONVERT],
CreationTime,
CONVERT(DATE,CreationTime) AS [DAteTime to Date CONVERT]
FROM Sales.Orders

--FORMATTING and CASTING--

SELECT
CreationTime,
CONVERT(DATE,CreationTime) AS [DAteTime to Date CONVERT],
CONVERT(VARCHAR, CreationTime, 32) AS [USA std. Style:32],
CONVERT(VARCHAR, CreationTime, 34) AS [EU std. Style:34]
FROM Sales.Orders

-- CASTING --

SELECT
CAST('123' AS INT) AS [STRING to INT],
CAST(123 AS VARCHAR) AS [INT to STRING],
CAST('2025-08-20' AS DATE) [STRING to DATE],
CAST('2025-08-20' AS DATETIME2) [STRING to DATETIME],
CreationTime,
CAST(CreationTime AS DATE) [DATETIME to DATE]
FROM Sales.Orders

