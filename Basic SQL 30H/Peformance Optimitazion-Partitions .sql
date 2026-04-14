-- Partition Function --

-- Step 1: Create a Partition Function 

CREATE PARTITION	FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31','2024-12-31','2025-12-31')
/* Query lists all existing partition functions */
SELECT
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions 

-- Step 2: Create filegroups 

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2023;

/* Query lists all existing filegroups */
SELECT *
FROM sys.filegroups 
WHERE type = 'FG'

-- Step 3: Add .ndf files to each filegroup (Create data files) 

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2023, -- Logical Name 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
)	TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2024, -- Logical Name 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
)	TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2025, -- Logical Name 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
)	TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2026, -- Logical Name 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
)	TO FILEGROUP FG_2026;

/* Query lists all existing data files */

SELECT 
	fg.name AS FilegroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PhysicalFilePath,
	mf.size / 128 AS SizeInMB
FROM
	sys.filegroups fg
JOIN 
	sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE 
	mf.database_id = DB_ID('SalesDB');

-- Step 4: Create Partition scheme 

CREATE PARTITION SCHEME SchemPartitionByYear 
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026)

/* Query lists all partitions scheme */
SELECT 
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFunctionName,
	ds.destination_id AS PartitionNumber,
	fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id 

-- Step 5: Create the Partitioned table 

CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemPartitionByYear (OrderDate)

-- Step 6: Insert Data into the partitioned table 

INSERT INTO Sales.Orders_Partitioned VALUES (1, '2023-05-15', 100);
INSERT INTO Sales.Orders_Partitioned VALUES (2, '2024-07-20', 50);
INSERT INTO Sales.Orders_Partitioned VALUES (1, '2025-12-31', 20);
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2026-01-01', 100);

SELECT * FROM Sales.Orders_partitioned 

/* Query lists all partitioned tables */

SELECT
	p.partition_number AS PartitionNumber,
	f.name AS PartitionFilegroup,
	p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_partitioned';
