-- ==========================================================
-- 1. DATA CLEANING
-- ==========================================================

-- ----------------------------------------------------------
-- Updating Unit_Cost_USD and Unit_Price_USD Columns
-- ----------------------------------------------------------

-- Remove '$' and ',' from Unit_Cost_USD
UPDATE Products
SET Unit_Cost_USD = REPLACE(Unit_Cost_USD, '$', '');

UPDATE Products
SET Unit_Cost_USD = REPLACE(Unit_Cost_USD, ',', '');

-- Remove '$' and ',' from Unit_Price_USD
UPDATE Products
SET Unit_Price_USD = REPLACE(Unit_Price_USD, '$', '');

UPDATE Products
SET Unit_Price_USD = REPLACE(Unit_Price_USD, ',', '');

-- ----------------------------------------------------------
-- Altering Columns to Numeric Data Type
-- ----------------------------------------------------------

-- Convert Unit_Cost_USD to DECIMAL(10, 2)
ALTER TABLE Products
ALTER COLUMN Unit_Cost_USD DECIMAL(10, 2);

-- Convert Unit_Price_USD to DECIMAL(10, 2)
ALTER TABLE Products
ALTER COLUMN Unit_Price_USD DECIMAL(10, 2);

-- ==========================================================
-- 2. DATA VALIDATION
-- ==========================================================

-- ----------------------------------------------------------
-- Check for Missing Zip_Code in Customers Table
-- ----------------------------------------------------------

SELECT CustomerKey, Name, Country, Zip_Code
FROM Customers
WHERE Zip_Code IS NULL;
-- Result: NONE

-- ----------------------------------------------------------
-- Identify Products Where Unit_Cost_USD >= Unit_Price_USD
-- ----------------------------------------------------------

SELECT ProductKey, Product_Name, Unit_Cost_USD, Unit_Price_USD
FROM Products
WHERE Unit_Cost_USD >= Unit_Price_USD;
-- Result: NONE

-- ----------------------------------------------------------
-- Check for Transactions with Negative Quantities
-- ----------------------------------------------------------

SELECT Order_Number, ProductKey, CustomerKey, Quantity, Order_Date
FROM Sales
WHERE Quantity < 0;
-- Result: NONE

-- ----------------------------------------------------------
-- Check for Transactions with Invalid Dates
-- ----------------------------------------------------------

SELECT Order_Number, ProductKey, CustomerKey, Quantity, Order_Date
FROM Sales
WHERE Order_Date IS NULL
   OR Order_Date > GETDATE();
-- Result: NONE

-- ----------------------------------------------------------
-- Identify Duplicate Records in Sales Table
-- ----------------------------------------------------------

SELECT Order_Number, ProductKey, CustomerKey, COUNT(*) AS Duplicate_Count
FROM Sales
GROUP BY Order_Number, ProductKey, CustomerKey
HAVING COUNT(*) > 1;

-- Result: REMOVED

-- ----------------------------------------------------------
-- Check for Customers with Missing Name or Country
-- ----------------------------------------------------------

SELECT CustomerKey, Name, Country, Zip_Code
FROM Customers
WHERE Name IS NULL OR Country IS NULL;
-- Result: NONE



-- =======================================================================================================
-- 2. Customer Analysis : Objective: Understand customer demographics and purchasing behavior.
-- =======================================================================================================


-- a. Retrieve the Number of Customers in Each Continent and Country
SELECT 
    Country, 
    COUNT(*) AS Customer_Count
FROM Customers
GROUP BY Country
ORDER BY Customer_Count DESC;



--- b. Find the Percentage of Male and Female Customers for Each Country

SELECT 
    Country,
    Gender,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Country) AS Percentage
FROM Customers
GROUP BY Country, Gender
ORDER BY Country, Percentage DESC;


--- c. Identify the Top 5 Cities with the Most Customers

SELECT TOP 5
    City,
    COUNT(*) AS Customer_Count
FROM Customers
GROUP BY City
ORDER BY Customer_Count DESC;


--- d. List Customers Born in the 1990s Along with Their Respective Countries

SELECT 
    CustomerKey,
    Name,
    Country,
    Birthday
FROM Customers
WHERE YEAR(Birthday) BETWEEN '1990' AND '1999'
ORDER BY Birthday;

--- e. Determine the Average Age of Customers per Continent

SELECT 
    Continent,
    AVG(DATEDIFF(YEAR, Birthday, GETDATE())) AS Average_Age
FROM Customers
GROUP BY Continent
ORDER BY Average_Age;


