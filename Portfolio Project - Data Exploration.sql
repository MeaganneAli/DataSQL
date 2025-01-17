/*
Sales Data Exploration

Skills used: Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

-- Basic exploration of sales data
SELECT *
FROM sales_data
ORDER BY Date, Customer_Age;

-- Total Sales by Product Category
SELECT Product_Category, SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Product_Category
ORDER BY Total_Revenue DESC;

-- Total Sales vs Total Profit
SELECT Product, SUM(Revenue) AS Total_Revenue, SUM(Profit) AS Total_Profit, (SUM(Profit) / SUM(Revenue)) * 100 AS Profit_Margin
FROM sales_data
GROUP BY Product
ORDER BY Total_Revenue DESC;

-- Customer Age Group Analysis
SELECT Age_Group, COUNT(*) AS Total_Customers, SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Age_Group
ORDER BY Total_Revenue DESC;

-- Country-wise Revenue Contribution
SELECT Country, SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Country
ORDER BY Total_Revenue DESC;

-- States with Highest Sales
SELECT State, SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY State
ORDER BY Total_Revenue DESC;

-- Using CTE to calculate the total profit margin by product category
WITH CategoryProfit AS (
    SELECT Product_Category, SUM(Revenue) AS Total_Revenue, SUM(Profit) AS Total_Profit
    FROM sales_data
    GROUP BY Product_Category
)
SELECT Product_Category, Total_Revenue, Total_Profit, (Total_Profit / Total_Revenue) * 100 AS Profit_Margin
FROM CategoryProfit
ORDER BY Profit_Margin DESC;

-- Temporary Table to Calculate Product Performance
DROP TABLE IF EXISTS ProductPerformance;
CREATE TEMP TABLE ProductPerformance AS
SELECT Product, Product_Category, SUM(Revenue) AS Total_Revenue, SUM(Profit) AS Total_Profit, SUM(Order_Quantity) AS Total_Orders
FROM sales_data
GROUP BY Product, Product_Category;

SELECT *, (Total_Profit / Total_Revenue) * 100 AS Profit_Margin
FROM ProductPerformance
ORDER BY Profit_Margin DESC;

-- View Creation for Future Use
CREATE OR REPLACE VIEW StateWiseRevenue AS
SELECT State, Product_Category, SUM(Revenue) AS Total_Revenue, SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY State, Product_Category
ORDER BY Total_Revenue DESC;

-- Using the view to query revenue by state
SELECT *
FROM StateWiseRevenue
WHERE Total_Revenue > 10000;

-- Aggregating Global Sales Data
SELECT
    SUM(Order_Quantity) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit,
    (SUM(Profit) / SUM(Revenue)) * 100 AS Global_Profit_Margin
FROM sales_data;

-- Product Sales Performance with Window Functions
SELECT
    Product,
    SUM(Revenue) AS Total_Revenue,
    RANK() OVER (ORDER BY SUM(Revenue) DESC) AS Revenue_Rank
FROM sales_data
GROUP BY Product
ORDER BY Revenue_Rank;
