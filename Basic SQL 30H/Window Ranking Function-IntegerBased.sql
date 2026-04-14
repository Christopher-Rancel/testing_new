-- Window Ranking Functions --
--Integer-Based Ranking --

-- ROW_NUMBER --

/* Rank the orders based on their sales from highestto lowest */

SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row 
FROM Sales.Orders

-- RANK --

/* Rank the orders based on their sales from highestto lowest */

SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row,
RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank
FROM Sales.Orders
 
-- DENSE_RANK --

/* Rank the orders based on their sales from highestto lowest */

SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row,
RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank,
DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_Dense
FROM Sales.Orders


-- ROW_NUMBER Use Cases --

-- Top-N Analysis --

/* Find the top highest sales for each product */

SELECT 
* 
FROM (
	SELECT 
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
	FROM Sales.Orders 
) t WHERE RankByProduct = 1

/* Analysis yhe top performers to do targeted marketing */


-- Bottom-N Analysis --

/* Find the lowest 2 customers based on their total sales */

 SELECT *
 FROM (
	SELECT 
		CustomerID,
		SUM(Sales) TotalSales,
		ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers 
	FROM Sales.Orders
	GROUP BY
	CustomerID
)t WHERE RankCustomers < 3 

/* Help analysis the underperformance to manage risks and to do optimizations */


-- Generate Unique IDs --

/* Assign unique IDs to the rows of the 'Orders Archive' table */

SELECT 
ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
*
FROM Sales.OrdersArchive

/* Help to assing unique identifier for each row to help paginating */
-- Paginating --
/* The process of breacking down a large data into smaller, more manageble chunks */


-- Identify Duplicates --

/* Identify duplicate rows in the table 'Orders Archive' 
and return a clean result without any duplicates */

SELECT * 
FROM (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
		*
	FROM Sales.Orders
)t WHERE rn = 1

/* Identify and remove duplicate rows to improve data quality */


-- NTILE --

SELECT
OrderID,
Sales,
NTILE(4) OVER (ORDER BY Sales DESC) FourBucket,
NTILE(3) OVER (ORDER BY Sales DESC) ThreeBucket,
NTILE(2) OVER (ORDER BY Sales DESC)TwoBucket,
NTILE(1) OVER (ORDER BY Sales DESC) OneBucket
FROM Sales.Orders

-- NTILE Use Case --

-- Data Segmentation --

/* Segment all orders into 3 categories:
High, Medium and Low sales */

SELECT 
*,
CASE WHEN Buckets = 1 THEN 'High'
	 WHEN Buckets = 2 THEN 'Medium'
	 WHEN Buckets = 3 THEN 'Low'
END SalesSegmentations 
FROM (
	SELECT
		OrderID,
		Sales,
		NTILE(3) OVER (ORDER BY Sales DESC) Buckets 
	FROM Sales.Orders 
)t

/* Divides a dataset into distinct subsets based on certain criteria */

