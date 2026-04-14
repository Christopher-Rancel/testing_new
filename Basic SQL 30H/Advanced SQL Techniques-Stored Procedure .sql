-- BASICS --

-- Step 1: Write a Query 
/* For us Customers Find the total Number Of Customers and the average score */

SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers 
WHERE Country = 'USA'

-- Step 2: Turning the query into a stored procedure --

CREATE PROCEDURE GetCustomerSummary AS 
BEGIN
SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers 
WHERE Country = 'USA'
END 

-- Step 3: Executre the sored Procedure --

EXEC GetCustomerSummary 

-- PARAMETERS --

 /* For German Customers Find the total Number Of Customers and the average score */

 CREATE PROCEDURE GetCustomerSummaryGermany AS 
BEGIN
SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers 
WHERE Country = 'Germany'
END 

EXEC GetCustomerSummaryGermany 
-- If in programming you have two times de same thing, something you can improve so find a solution */

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50)
AS
BEGIN
SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers 
WHERE Country = @Country
END 

EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary @Country = 'USA'

-- So we don't need this --
DROP PROCEDURE GetCustomerSummaryGermany

-- You can put default --
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) = 'USA'
AS
BEGIN
SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers 
WHERE Country = @Country
END 

EXEC GetCustomerSummary

-- MULTIPLE STATEMENTS --

/* Find the total nr. of orders and total sales */

SELECT
COUNT(OrderID) TotalOrders,
SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'
/* Add a semicolon at the end of each SQL statement */

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) = 'USA'
AS
BEGIN
SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers 
WHERE Country = @Country;

SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;

END 

EXEC GetCustomerSummary

-- VARIABLE --

/* Total Customers from Germany : 2
Average Score from Germany: 425 */

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) = 'USA'
AS
BEGIN

DECLARE @TotalCustomers INT, @AvgScore FLOAT;

SELECT
	@TotalCustomers = COUNT(*),
	@AvgScore = AVG(Score)
FROM Sales.Customers 
WHERE Country = @Country;

PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;

END 

EXEC GetCustomerSummary

-- CONTROL FLOW --

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) = 'USA'
AS
BEGIN

DECLARE @TotalCustomers INT, @AvgScore FLOAT;

-- Prepare and Cleanup Data --
IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
BEGIN
	PRINT ('Updating NULL Scores to 0');
	UPDATE Sales.Customers
	SET Score = 0
	WHERE Score IS NULL AND Country = @Country;
END

ELSE 
BEGIN 
	PRINT('No NULL Scores found')
END;

-- Generating Reports 
SELECT
	@TotalCustomers = COUNT(*),
	@AvgScore = AVG(Score)
FROM Sales.Customers 
WHERE Country = @Country;

PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;

END 

EXEC GetCustomerSummary

-- ERROR HANDLING --

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) = 'USA'
AS
BEGIN
BEGIN TRY
DECLARE @TotalCustomers INT, @AvgScore FLOAT;

-- Prepare and Cleanup Data --
IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
BEGIN
	PRINT ('Updating NULL Scores to 0');
	UPDATE Sales.Customers
	SET Score = 0
	WHERE Score IS NULL AND Country = @Country;
END

ELSE 
BEGIN 
	PRINT('No NULL Scores found')
END;

-- Generating Reports 
SELECT
	@TotalCustomers = COUNT(*),
	@AvgScore = AVG(Score)
FROM Sales.Customers 
WHERE Country = @Country;

PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales,
	1/0
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;

END TRY 
BEGIN CATCH
	PRINT('An error ocurred.');
	PRINT('Error Message: ' + ERROR_MESSAGE());
	PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
	PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
	PRINT('Error Procedure: ' + ERROR_PROCEDURE());
END CATCH 
END 
GO

EXEC GetCustomerSummary 

-- STYLING --

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) = 'USA'
AS
BEGIN
	BEGIN TRY
		DECLARE @TotalCustomers INT, @AvgScore FLOAT;
		-- =====================================
		-- Step 1: Prepare and Cleanup Data 
		-- =====================================
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN
			PRINT ('Updating NULL Scores to 0');
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country;
		END

		ELSE 
		BEGIN 
			PRINT('No NULL Scores found')
		END;

		-- =====================================
		-- Step 2: Generating Summary Reports 
		-- =====================================
		-- Calculate Total Customers and Average Score for Specific Country 
		SELECT
			@TotalCustomers = COUNT(*),
			@AvgScore = AVG(Score)
		FROM Sales.Customers 
		WHERE Country = @Country;

		PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
		PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);


		-- Calculate Total Number of Number of orders and Total Sales for specific Country
		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country;
	END TRY 
	BEGIN CATCH
		-- =====================================
		-- Error Handling 
		-- =====================================
		PRINT('An error ocurred.');
		PRINT('Error Message: ' + ERROR_MESSAGE());
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE());
	END CATCH 
END 
GO

EXEC GetCustomerSummary 