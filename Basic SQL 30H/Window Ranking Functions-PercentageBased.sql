-- CUME_DIST and PERCENT_RANK --

/* Find the products that fall within the highest 40% of prices */

SELECT
*,
CONCAT(DistRank * 100, '%') DistRankPerc
FROM (
	SELECT
		Product,
		Price,
		CUME_DIST() OVER(ORDER BY Price DESC) DistRank
	FROM Sales.Products
)t
WHERE DistRank <= 0.4