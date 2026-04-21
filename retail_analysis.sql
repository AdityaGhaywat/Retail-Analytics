-- =========================================
-- RETAIL ANALYTICS PROJECT (SQL)  
-- =========================================

-- ================================
-- 1. DATA CLEANING
-- ================================

-- Q1 Remove duplicate transactions
SELECT transactionid, COUNT(*) 
FROM sales_transaction
GROUP BY transactionid
HAVING COUNT(*) > 1;

CREATE TABLE sales_transaction_new AS
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY transactionid) AS rnk
    FROM sales_transaction
) t
WHERE rnk = 1;

DROP TABLE sales_transaction;
ALTER TABLE sales_transaction_new RENAME TO sales_transaction;
ALTER TABLE sales_transaction DROP COLUMN rnk;


-- Q2 Fix price inconsistencies
UPDATE sales_transaction s
JOIN product_inventory p
ON s.productid = p.productid
SET s.price = p.price
WHERE s.price <> p.price;


-- Q3 Handle missing values in customer location
UPDATE customer_profiles 
SET location = 'Unknown'
WHERE location IS NULL OR location = '';


-- Q4 Standardize transaction date format
CREATE TABLE sales_transaction_new AS
SELECT * , CAST(transactiondate AS DATE) AS TransactionDate_updated
FROM sales_transaction;

DROP TABLE sales_transaction;
ALTER TABLE sales_transaction_new RENAME TO sales_transaction;


-- ================================
-- 2. SALES ANALYSIS
-- ================================

-- Q5 Total sales and units per product
SELECT ProductID,
SUM(quantitypurchased) AS TotalUnitsSold,
ROUND(SUM(quantitypurchased * price),2) AS TotalSales
FROM sales_transaction 
GROUP BY ProductID
ORDER BY TotalSales DESC;


-- Q7 Category performance by revenue
SELECT Category,
SUM(s.quantitypurchased) AS TotalUnitsSold,
ROUND(SUM(s.quantitypurchased * s.price),2) AS TotalSales
FROM product_inventory p
JOIN sales_transaction s
ON p.productid = s.productid
GROUP BY Category
ORDER BY TotalSales DESC;


-- Q8 Top 10 revenue generating products
SELECT ProductID,
SUM(quantitypurchased * price) AS TotalRevenue
FROM sales_transaction 
GROUP BY ProductID
ORDER BY TotalRevenue DESC
LIMIT 10;


-- Q9 Low selling products
SELECT ProductID,
SUM(quantitypurchased) AS TotalUnitsSold
FROM sales_transaction
GROUP BY ProductID
ORDER BY TotalUnitsSold
LIMIT 10;


-- Q10 Daily sales trend
SELECT transactiondate,
SUM(quantitypurchased * price) AS TotalSales
FROM sales_transaction
GROUP BY transactiondate;


-- Q11 Month-over-month sales growth
WITH sales AS (
    SELECT MONTH(transactiondate) AS month,
    SUM(quantitypurchased * price) AS total_sales
    FROM sales_transaction
    GROUP BY month
),
prev AS (
    SELECT *,
    LAG(total_sales) OVER(ORDER BY month) AS prev_sales
    FROM sales
)
SELECT *,
ROUND(((total_sales - prev_sales)/prev_sales)*100,2) AS mom_growth
FROM prev;


-- ================================
-- 3. CUSTOMER ANALYSIS
-- ================================

-- Q6 Customer purchase frequency
SELECT CustomerID,
COUNT(transactionid) AS NumberOfTransactions
FROM sales_transaction
GROUP BY CustomerID;


-- Q12 High value customers
SELECT CustomerID,
COUNT(transactionid) AS transactions,
SUM(quantitypurchased * price) AS total_spent
FROM sales_transaction
GROUP BY CustomerID
HAVING transactions > 10 AND total_spent > 1000;


-- Q13 Occasional customers
SELECT CustomerID,
COUNT(transactionid) AS transactions
FROM sales_transaction
GROUP BY CustomerID
HAVING transactions <= 2;


-- Q14 Repeat purchases
SELECT CustomerID, ProductID,
COUNT(*) AS times_purchased
FROM sales_transaction
GROUP BY CustomerID, ProductID
HAVING times_purchased > 1;


-- Q15 Customer loyalty duration
SELECT CustomerID,
MIN(TransactionDate_updated) AS first_purchase,
MAX(TransactionDate_updated) AS last_purchase,
DATEDIFF(MAX(TransactionDate_updated), MIN(TransactionDate_updated)) AS days_between
FROM sales_transaction
GROUP BY CustomerID;


-- ================================
-- 4. ADVANCED INSIGHTS
-- ================================

-- Q16 Customer segmentation by purchase volume
WITH cust_segment AS (
    SELECT customerid,
    SUM(quantitypurchased) AS total_quantity
    FROM sales_transaction
    GROUP BY customerid
)
SELECT 
CASE
    WHEN total_quantity BETWEEN 1 AND 10 THEN 'Low'
    WHEN total_quantity BETWEEN 11 AND 30 THEN 'Medium'
    ELSE 'High'
END AS customer_segment,
COUNT(*) AS customer_count
FROM cust_segment
GROUP BY customer_segment;
