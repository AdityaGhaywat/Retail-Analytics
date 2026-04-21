# Retail Analytics using SQL

## Overview:

Analyzed a retail transactions dataset to uncover sales trends, customer behavior, and product performance using SQL. The project covers data cleaning, transformation, and analytical queries to derive business insights.

---

## Dataset:

* **sales_transaction.csv** – Transaction-level sales data
* **customer_profiles.csv** – Customer demographics
* **product_inventory.csv** – Product details and pricing

---

## Key Tasks Performed:

### Data Cleaning

* Removed duplicate transactions using window functions
* Fixed pricing inconsistencies across tables
* Handled missing values in customer data
* Standardized date formats for analysis

### Sales Analysis

* Calculated total sales and product-level performance
* Identified top and low-performing products
* Analyzed category-wise revenue contribution
* Evaluated sales trends and growth patterns

### Customer Analysis

* Analyzed purchase frequency and spending behavior
* Identified high-value and low-engagement customers
* Detected repeat purchase patterns
* Measured customer loyalty using purchase timelines

### Advanced Insights

* Segmented customers into Low, Medium, and High groups based on purchase volume

---

## SQL Concepts Used:

* Joins
* Aggregations
* Window Functions (ROW_NUMBER, LAG)
* Common Table Expressions (CTEs)
* Case Statements

---

## Key Insights:

* A small segment of customers contributes a large portion of total revenue
* Certain product categories consistently outperform others
* Sales exhibit identifiable trends across months
* Repeat customers show higher engagement and value

---

## Business Recommendations:

* Focus retention strategies on high-value customers
* Promote underperforming categories through targeted campaigns
* Optimize inventory based on top-selling products
* Encourage repeat purchases through loyalty programs

---

## Project Structure:

```
Retail-Analytics/
│── retail_analytics.sql
│── sales_transaction.csv
│── customer_profiles.csv
│── product_inventory.csv
```
