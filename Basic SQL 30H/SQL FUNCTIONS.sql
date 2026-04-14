-- STRING FUNCTIONS --

-- CONCAT --

/*Show a list of customers' first names together with their country in one column*/

SELECT
first_name,
country,
CONCAT(first_name,'-', country) AS name_country
FROM customers

-- UPPER AND LOWER --

/* Transform the customer's first name to lowercase*/

SELECT 
First_name,
country,
CONCAT(first_name,'-', country) AS name_country,
LOWER(first_name) AS low_name,
UPPER(first_name) AS up_name
FROM customers 

-- TRIM --

/* Find customers whose first name contains leading or trailing spaces */

SELECT 
first_name
FROM customers
WHERE first_name != TRIM(first_name) 

-- REPLACE --

/* Remove dashes (-) from a phone number */

SELECT 
'123-456-7890' As phone, 
REPLACE('123-456-7890', '-', '/') AS clean_phone

/* Replace file extence from txt to csv */

SELECT 
'report.txt' AS old_filename,
REPLACE('report.txt', '.txt', '.csv') AS new_filename 

-- LEN --

/* Calculate the length of each customer's first name */

SELECT 
first_name,
LEN(first_name) AS len_name
FROM customers 

-- LEFT AND RIGHT --

/* Retrieve the first two characters of each first name */
/* LEFT */

SELECT 
first_name, 
LEFT(TRIM(first_name),2) AS first_2_char
FROM customers 

/* Retrieve the last two characters of each first name */
/* RIGHT */

SELECT
first_name,
RIGHT(first_name,2) AS last_2_char
FROM customers

-- SUBSTRING --

/* Retrieves a list of customers' first names after removing the first character */

SELECT
first_name,
SUBSTRING(TRIM(first_name),2,LEN(first_name)) AS subs_first_name
FROM customers

/* Use LEN to the length be as long as the value or put a very high number. It looks more pro if you put LEN )*/


-- NUMBER FUNCTIONS --


--ROUND --


SELECT
3.516,
ROUND(3.516,2) AS round_2,
ROUND(3.516,1) AS round_1,
ROUND(3.516,0) AS round_0

-- ABS --

SELECT
-10,
ABS(-10) AS abs_num


-- DATE and TIME Functions)

SELECT
OrderID,
OrderDate,
ShipDate,
CreationTime
FROM Sales.Orders

-- VALUES --

/* - Date column from a table
   - Hardcoded constant string value ( Is an static value on the query)
   - GETDATE () function */


-- Part Extraction --

-- DAY , MONTH , YEAR --


SELECT
OrderID,
CreationTime,
YEAR(CreationTime) AS Year,
MONTH(CreationTime) AS Month,
DAY(CreationTime) AS Day
FROM Sales.Orders


-- GETDATE () --

-- DATEPART --

SELECT
OrderID,
CreationTime,
DATEPART(year, CreationTime) Year_dp,
DATEPART(month, CreationTime) Month_dp,
DATEPART(day, CreationTime) Day_dp,
DATEPART(hour, CreationTime) Hour_dp,
DATEPART(minute, CreationTime) Minute_dp,
DATEPART(quarter, CreationTime) Quarter_dp,
DATEPART(week, CreationTime) Week_dp,
YEAR(CreationTime) AS Year,
MONTH(CreationTime) AS Month,
DAY(CreationTime) AS Day
FROM Sales.Orders

/* Similar to YEAR, MONTH, DAY but you can colect more info than that like hours, minutes, weeks, quarter... 
even if that is not on the table */

-- DATENAME --

SELECT
OrderID,
CreationTime,
DATENAME(month, CreationTime) Month_dn,
DATENAME(weekday, CreationTime) Weekday_dn,
DATENAME(day, CreationTime) Day_dn,
DATENAME(year, CreationTime) Year_dn,
DATEPART(year, CreationTime) Year_dp,
DATEPART(month, CreationTime) Month_dp,
DATEPART(day, CreationTime) Day_dp,
DATEPART(hour, CreationTime) Hour_dp,
DATEPART(minute, CreationTime) Minute_dp,
DATEPART(quarter, CreationTime) Quarter_dp,
DATEPART(week, CreationTime) Week_dp,
YEAR(CreationTime) AS Year,
MONTH(CreationTime) AS Month,
DAY(CreationTime) AS Day
FROM Sales.Orders

/* Similar to DATEPART but it's STRING instead of INT */

-- DATETRUNC --

SELECT
OrderID,
CreationTime,
DATETRUNC(year,CreationTime) Year_dt,
DATETRUNC(day,CreationTime) Day_dt,
DATETRUNC(minute,CreationTime) Minute_dt,
DATENAME(month, CreationTime) Month_dn,
DATENAME(weekday, CreationTime) Weekday_dn,
DATENAME(day, CreationTime) Day_dn,
DATENAME(year, CreationTime) Year_dn,
DATEPART(year, CreationTime) Year_dp,
DATEPART(month, CreationTime) Month_dp,
DATEPART(day, CreationTime) Day_dp,
DATEPART(hour, CreationTime) Hour_dp,
DATEPART(minute, CreationTime) Minute_dp,
DATEPART(quarter, CreationTime) Quarter_dp,
DATEPART(week, CreationTime) Week_dp,
YEAR(CreationTime) AS Year,
MONTH(CreationTime) AS Month,
DAY(CreationTime) AS Day
FROM Sales.Orders

/* Resets all the values that goes after the date. Ex. If you put DATETRUNC (hour) ALL the values that are after hour will be reset to 00.
- Remember that date values reset at 01 aand time values reset to 00 */

SELECT 
DATETRUNC(month,CreationTime) creation,
COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(month,CreationTime) 

/* It's really helpfull for telling how much orders for example are made by day,month...*/

-- EOMONTH 'EndOfMONTH'--

SELECT
OrderID,
CreationTime,
EOMONTH(CreationTime) EndOfMonth,
CAST(DATETRUNC(month, CreationTime) AS DATE) StartOfMonth 
FROM Sales.Orders 

/* Changes the day for the last day of the month
- DATETRUNC to put the first day of the month */

/* EXCERCISES */

-- DATA AGGREGATION --

/* How many orders were placed each year */

SELECT 
YEAR(OrderDate) ,
COUNT(*) NrOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate)

/* How many orders were placed each month */

SELECT 
DATENAME(month,OrderDate),
COUNT(*) NrOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)

-- DATA FILTERING --

/* Show all orders that were placed during the month of february */

SELECT 
*
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2 

/* Filterin data using an integer is faster faster than using a String */
/* Avoid using DATENAME for filtering data, instead use DATEPART */