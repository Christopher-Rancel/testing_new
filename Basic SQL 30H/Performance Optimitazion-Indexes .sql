-- iNDEX --

-- Indexes types --

-- STRUCTURE --

-- Clustered and Non-Clustered --

SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers 

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName)

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName) 

-- Composite Index --

SElECT
*
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500
/* The columns of index order must match the order in your query */
CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country,Score)

-- Leftmost prefix rule --
/* Index works only if your query filters start from the first column in the index and follow its order */
A,B,C,D

-- Index will be used --
A
A,B
A,B,C

-- Index won't be used --
B
A,C
A,B,D

-- STORAGE --

-- Rowscore and columnstore --

-- Columnstore --

CREATE CLUSTERED COLUMNSTORE INDEX idx__DBCustomers_CS
ON Sales.DBCustomers 

DROP INDEX idx__DBCustomers_CS ON Sales.DBCustomers 

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName)

-- Unique --

SELECT * FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products (Product)

INSERT INTO Sales.Products (ProductID,Product) VALUES (106,'Caps')

-- Filtered --

SELECT * FROM Sales.Customers
WHERE Country = 'USA'

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA'

-- Index Management --

-- List all indexes on a specific table 

sp_helpindex 'Sales.DBCustomers'

-- Monitoring index usage 

SELECT
	tbl.name AS TableName,
	idx.name AS IndexName,
	idx.type_desc As IndexType,
	idx.is_primary_key AS IsPrimaryKey,
	idx.is_unique AS IsUnique,
	idx.is_disabled AS IsDisabled,
	s.user_seeks AS UserSeeks,
	s.user_scans AS UserScans,
	s.user_lookups AS UserLookups,
	s.user_updates AS UserUpdates,
COALESCE(s.last_user_seek,s.last_user_scan) LastUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id = idx.object_id
AND s.index_id = idx.index_id 
ORDER BY tbl.name, idx.name 

-- Monitor missing index --

SELECT
	fs.SalesOrderNumber,
	dp.EnglishProductName,
	dp.Color
FROM	FactInternetSales fs
INNER JOIN DimProduct dp
ON		fs.ProductKey = dp.ProductKey
WHERE dp.Color = 'Black'
AND fs.OrderDateKey BETWEEN 20101229 AND 20101231

SELECT * FROM sys.dm_db_missing_index_details 

-- Monitor duplicate indexes --

SELECT 
	tbl.name AS TableName,
	col.name AS IndexColumn,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	COUNT(*) OVER (PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC

-- Update Statistics 

SELECT
	SCHEMA_NAME (t.schema_id) AS SchemaName,
	t.name AS TableName,
	s.name AS StatisticName,
	sp.last_updated AS Lastudate,
	DATEDIFF (day, sp.last_updated, GETDATE()) AS LastUpdateDay,
	sp.rows AS 'Rows',
	sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY 
sp.modification_counter DESC; 

UPDATE STATISTICS Sales.DBCustomers_WA_Sys_00000001_6EF57B66

UPDATE STATISTICS Sales.DBCustomers

EXEC sp_updatestats

-- Monitor Fragmentations --

SELECT
	SCHEMA_NAME (t.schema_id) AS SchemaName,
	t.name AS TableName,
	s.name AS StatisticName,
	sp.last_updated AS Lastudate,
	DATEDIFF (day, sp.last_updated, GETDATE()) AS LastUpdateDay,
	sp.rows AS 'Rows',
	sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY 
sp.modification_counter DESC; 

ALTER INDEX idx_Customers_CS_Country ON Sales.Customers REORGANIZE 

ALTER INDEX idx_Customers_Country ON Sales.Customers REBUILD 