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
-- 3. CUSTOMER ANALYSIS
-- Objective: Understand customer demographics and purchasing behavior.
-- =======================================================================================================

-- ------------------------------------------------------------------------------------------------------
-- a. Retrieve the Number of Customers in Each Country
-- ------------------------------------------------------------------------------------------------------

SELECT 
    Country, 
    COUNT(*) AS Customer_Count
FROM 
    Customers
GROUP BY 
    Country
ORDER BY 
    Customer_Count DESC;

-- ------------------------------------------------------------------------------------------------------
-- b. Find the Percentage of Male and Female Customers for Each Country
-- ------------------------------------------------------------------------------------------------------

SELECT 
    Country,
    Gender,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Country) AS Percentage
FROM 
    Customers
GROUP BY 
    Country, Gender
ORDER BY 
    Country, Percentage DESC;

-- ------------------------------------------------------------------------------------------------------
-- c. Identify the Top 5 Cities with the Most Customers
-- ------------------------------------------------------------------------------------------------------

SELECT 
    TOP 5 City,
    COUNT(*) AS Customer_Count
FROM 
    Customers
GROUP BY 
    City
ORDER BY 
    Customer_Count DESC;

-- ------------------------------------------------------------------------------------------------------
-- d. List Customers Born in the 1990s Along with Their Respective Countries
-- ------------------------------------------------------------------------------------------------------

SELECT 
    CustomerKey,
    Name,
    Country,
    Birthday
FROM 
    Customers
WHERE 
    YEAR(Birthday) BETWEEN 1990 AND 1999
ORDER BY 
    Birthday;

-- ------------------------------------------------------------------------------------------------------
-- e. Determine the Average Age of Customers per Continent
-- ------------------------------------------------------------------------------------------------------

SELECT 
    Continent,
    AVG(DATEDIFF(YEAR, Birthday, GETDATE())) AS Average_Age
FROM 
    Customers
GROUP BY 
    Continent
ORDER BY 
    Average_Age;



-- =======================================================================================================
-- 4. PRODUCT ANALYSIS
-- Objective: Evaluate product performance and profitability.
-- =======================================================================================================

-- ------------------------------------------------------------------------------------------------------
-- a. Identify the Top 10 Product Categories by Total Revenue
-- ------------------------------------------------------------------------------------------------------

SELECT 
    TOP 10 p.Category,
    SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
FROM 
    Sales s
JOIN 
    Products p ON s.ProductKey = p.ProductKey
GROUP BY 
    p.Category
ORDER BY 
    Total_Revenue DESC;

-- ------------------------------------------------------------------------------------------------------
-- a. Identify the Top 10 Products by Total Revenue
-- ------------------------------------------------------------------------------------------------------

SELECT 
    TOP 10 p.Product_Name, p.Category,
    SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
FROM 
    Sales s
JOIN 
    Products p ON s.ProductKey = p.ProductKey
GROUP BY 
    p.Product_Name, p.Category
ORDER BY 
    Total_Revenue DESC;

-- ------------------------------------------------------------------------------------------------------
-- b. Calculate Total Profit, Profit Margin, and Rank Products by Profitability
-- ------------------------------------------------------------------------------------------------------

-- Calculate Profit Margin for Each Product
SELECT 
    Product_Name, Category,
    (Unit_Price_USD - Unit_Cost_USD) AS Profit_Margin
FROM 
    Products
ORDER BY 
    Profit_Margin DESC;

-- Calculate and Rank the Top 10 Products by Profit
SELECT 
    TOP 10 p.Product_Name, 
    (SUM(p.Unit_Price_USD * s.Quantity) - SUM(p.Unit_Cost_USD * s.Quantity)) AS Profit
FROM 
    Sales s
JOIN 
    Products p ON s.ProductKey = p.ProductKey
GROUP BY 
    p.Product_Name
ORDER BY 
    Profit DESC;

-- ------------------------------------------------------------------------------------------------------
-- c. Find the Most Popular Product Categories (Based on Quantity Sold)
-- ------------------------------------------------------------------------------------------------------

SELECT 
    TOP 5 p.Category, 
    SUM(s.Quantity) AS Total_Qty_Sold
FROM 
    Sales s
JOIN 
    Products p ON s.ProductKey = p.ProductKey
GROUP BY 
    p.Category
ORDER BY 
    Total_Qty_Sold DESC;

-- ------------------------------------------------------------------------------------------------------
-- d. Determine the Top 3 Brands Contributing to Overall Revenue
-- ------------------------------------------------------------------------------------------------------

SELECT 
    TOP 3 p.Brand,
    SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
FROM 
    Sales s
JOIN 
    Products p ON s.ProductKey = p.ProductKey
GROUP BY 
    p.Brand
ORDER BY 
    Total_Revenue DESC;


-- =======================================================================================================
-- 5. SALES TREND 
-- Objective: Analyze sales performance over time.
-- =======================================================================================================


-- ------------------------------------------------------------------------------------------------------
-- a. Calculate the total sales revenue for each month from January to June 2020.
-- ------------------------------------------------------------------------------------------------------

SELECT 
    FORMAT(S.Order_Date, 'yyyy-MM') AS YearMonth,
    SUM(S.Quantity * P.Unit_Price_USD) AS Total_Revenue
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
WHERE s.Order_Date BETWEEN '2020-01-01' AND '2020-06-01'
GROUP BY FORMAT(S.Order_Date, 'yyyy-MM')
ORDER BY YearMonth;

-- ------------------------------------------------------------------------------------------------------
-- b. Find the Day with the Highest Sales Revenue in Each Month
-- ------------------------------------------------------------------------------------------------------
SELECT 
    FORMAT(S.Order_Date, 'yyyy-MM') AS YearMonth,
    S.Order_Date,
    SUM(S.Quantity * P.Unit_Price_USD) AS Daily_Revenue
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
WHERE s.Order_Date BETWEEN '2020-01-01' AND '2020-06-01'
GROUP BY FORMAT(S.Order_Date, 'yyyy-MM'), S.Order_Date
ORDER BY YearMonth, Daily_Revenue DESC;


WITH MonthlySales AS (
    SELECT 
        FORMAT(S.Order_Date, 'yyyy-MM') AS YearMonth,
        S.Order_Date,
        SUM(S.Quantity * P.Unit_Price_USD) AS Daily_Revenue,
        ROW_NUMBER() OVER (PARTITION BY FORMAT(S.Order_Date, 'yyyy-MM') ORDER BY SUM(S.Quantity * P.Unit_Price_USD) DESC) AS RowNum
    FROM Sales S
    JOIN Products P ON S.ProductKey = P.ProductKey
    WHERE s.Order_Date BETWEEN '2020-01-01' AND '2020-06-01'
    GROUP BY FORMAT(S.Order_Date, 'yyyy-MM'), S.Order_Date
)
SELECT YearMonth, Order_Date, Daily_Revenue
FROM MonthlySales
WHERE RowNum = 1;


-- ------------------------------------------------------------------------------------------------------
-- c. Identify the Top 5 Product Subcategories Sold in the First Quarter of 2024
-- ------------------------------------------------------------------------------------------------------

SELECT TOP 5
    P.SubCategory,
    SUM(S.Quantity) AS Total_Quantity_Sold
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
WHERE Order_Date BETWEEN '2020-01-01' AND '2020-03-31'
GROUP BY P.SubCategory
ORDER BY Total_Quantity_Sold DESC;


-- ------------------------------------------------------------------------------------------------------
-- d. Determine the Average Delivery Time (in Days) Across All Orders
-- ------------------------------------------------------------------------------------------------------

SELECT 
    AVG(DATEDIFF(DAY, Order_Date, Delivery_Date)) AS Avg_Delivery_Time_Days
FROM Sales
WHERE Delivery_Date IS NOT NULL;



-- =======================================================================================================
-- 5. Store Performance
--- Objective: Assess store efficiency and geographical performance.
-- =======================================================================================================


-- ------------------------------------------------------------------------------------------------------
-- a. Calculate Total Sales by Store and Rank Stores by Revenue Within Each Country
-- ------------------------------------------------------------------------------------------------------

SELECT 
    ST.Country,
    ST.StoreKey,
    SUM(S.Quantity * P.Unit_Price_USD) AS Total_Sales,
    RANK() OVER (PARTITION BY ST.Country ORDER BY SUM(S.Quantity * P.Unit_Price_USD) DESC) AS Revenue_Rank
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
JOIN Stores ST ON S.StoreKey = ST.StoreKey
GROUP BY ST.Country, ST.StoreKey
ORDER BY ST.Country, Revenue_Rank;
