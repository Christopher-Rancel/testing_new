SELECT 
FirstName AS F_Name ,
LastName AS L_Name 
FROM Sales.Customers

UNION

SELECT
FirstName,
LastName
FROM Sales.Employees

-- ORDER BY always at the end --
-- The queries must have the same amount of columns --
-- VARCHAR with VARCHAR and INT with INT. Same data type --
-- Becarefull with the order --
-- You only have to put the AS in the first query --
-- Be carefull with the results of the UNION because that doesn't mean the result it's ok. DOBLE CHECK --
