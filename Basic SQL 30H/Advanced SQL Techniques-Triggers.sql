-- DML Triggers --

-- USE CASE --

-- Logging --


-- Step 1: Create log table 
CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY (1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR (255),
	LogDate DATE 
)

-- Step 2: Create trigger on employees table --
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT 
AS
BEGIN 
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added =' + CAST(EmployeeID AS VARCHAR),
		GETDATE ()
	FROM INSERTED 
END 

-- Step 3: Insert New Data Into Employees
SELECT * FROM Sales.EmployeeLogs

INSERT INTO Sales.Employees 
VALUES 
(7, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3)