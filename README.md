# Case Study: Global Electronics Retailer - Data Analytics for Business Optimization

## 🛠️ **Business Objective**
To optimize business operations and enhance customer satisfaction by analyzing global sales data. The goal is to uncover actionable insights across:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**
- **Store Efficiency**
- **Currency Impacts**

These insights will inform strategic decisions such as:
- Inventory management
- Pricing adjustments
- Customer retention strategies
- Regional growth opportunities

---

## 📝 **Problem Statement**
As a data analyst for a fictitious global electronics retailer, your task is to:

1. **Analyze** customer demographics and purchasing behaviors.
2. **Evaluate** product performance and profitability.
3. **Examine** store efficiency and geographical performance.
4. **Assess** sales trends and delivery times.
5. **Normalize** revenue and trends across currencies.
6. **Provide** actionable insights to improve overall performance and customer satisfaction.

The analysis involves using **SQL** to answer specific questions related to sales trends, customer segmentation, product revenue, and operational efficiency.

---

## 🔍 **Manager’s Requests and Corresponding SQL Questions**

### 1. **Customer Analysis**
**Objective:** Understand customer demographics and purchasing behavior.
- Retrieve the number of customers in each continent and country.
- Find the percentage of male and female customers for each country.
- Identify the top 5 cities with the most customers.
- List customers born in the 1990s along with their respective countries.
- Determine the average age of customers per continent (calculated based on their birthdays).

---

### 2. **Product Analysis**
**Objective:** Evaluate product performance and profitability.
- Identify the top 10 products by total revenue.
- Calculate the profit margin (`Unit Price USD - Unit Cost USD`) for all products and rank products by profitability.
- Find the most popular product category (based on quantity sold).
- Determine the top 3 brands contributing to overall revenue.

---

### 3. **Sales Trends**
**Objective:** Analyze sales performance over time.
- Calculate the total sales revenue for each month from January to April 2024.
- Find the day with the highest sales revenue in each month.
- Identify the top 5 product subcategories sold in the first quarter of 2024.
- Determine the average delivery time (in days) across all orders.

---

### 4. **Store Performance**
**Objective:** Assess store efficiency and geographical performance.
- Calculate total sales by store and rank stores by revenue within each country.
- Find the store with the largest floor area and its total sales.
- Calculate the average revenue per square meter for all stores.
- Identify the oldest store (based on `Open Date`) and its total sales.

---

### 5. **Currency Impact**
**Objective:** Normalize sales data across currencies.
- Convert total revenue for each transaction into USD using the `Exchange_Rates` table.
- Identify the currency with the highest revenue (converted to USD) and the total revenue generated in that currency.
- Calculate the average exchange rate for each currency during the dataset period.
- Determine the impact of fluctuating exchange rates on total revenue (compare revenues before and after normalization to USD).

---

### 6. **Operational Efficiency**
**Objective:** Improve delivery and operational performance.
- Identify orders with the longest delivery times and the products included in those orders.
- Calculate the average delivery time for each country.
- Find the percentage of orders delivered within 3 days of the order date.

---

### 7. **Advanced Analytics**
**Objective:** Provide deeper insights using advanced SQL techniques.
- Use a **window function** to rank products by total revenue for each category.
- Write a **CTE** to identify customers who have purchased from more than 3 different categories.
- Use a **subquery** to find products sold only in stores with a floor area greater than 500 square meters.
- Identify repeat customers who have placed more than 5 orders.

---

### 8. **Data Quality and Validation**
**Objective:** Ensure the dataset is clean and reliable.
- Identify and list customers with missing or invalid `Zip Code` values.
- Find products where `Unit Cost USD` is greater than or equal to `Unit Price USD`.
- Check for any transactions with negative quantities or invalid dates.

---

## 📂 **Repository Structure**
├── datasets/ │ ├── customers.csv │ ├── products.csv │ ├── sales.csv │ ├── stores.csv │ ├── exchange_rates.csv ├── queries/ │ ├── customer_analysis.sql │ ├── product_analysis.sql │ ├── sales_trends.sql │ ├── store_performance.sql │ ├── currency_impact.sql │ ├── operational_efficiency.sql │ ├── advanced_analytics.sql │ ├── data_quality_validation.sql ├── 

## 📊 Technologies Used
- SQL (MySQL)
- Excel/Google Sheets (for data validation)
