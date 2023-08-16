# Walmart Sales Data Analysis

## About

This project aims to explore the Walmart Sales data to understand top-performing branches and products, sales trends of different products, and customer behavior. The goal is to study how sales strategies can be improved and optimized. The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting).

## Purpose

The main purpose of this project is to gain insights into the sales data of Walmart to understand the different factors that affect the sales of different branches.

## Dataset Overview

The dataset was sourced from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting). It contains sales transactions from three different branches of Walmart located in Mandalay, Yangon, and Naypyitaw. The dataset includes 17 columns and 1000 rows.

| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| ...                     | ...                                     | ...            |
| rating                  | Rating                                  | FLOAT(2, 1)    |

## Analysis Topics

This project covers the following analysis areas:

1. **Product Analysis**
   - Identification of top-performing product lines.
   - Analysis of product lines requiring improvement.

2. **Sales Analysis**
   - Analysis of sales trends for different products.
   - Measurement of the effectiveness of sales strategies.

3. **Customer Analysis**
   - Identification of customer segments.
   - Analysis of customer purchase trends.

## Approach Used

1. **Data Wrangling:** Handling NULL and missing values in the dataset.
2. **Feature Engineering:** Creating new columns for time of day, day of the week, and month.
3. **Exploratory Data Analysis (EDA):** Analyzing data to answer specific questions.
4. **Conclusion:** Summarizing key findings from the analysis.

## Business Questions Explored

- Generic questions about cities, branches, and customer types.
- Product-related questions like best-selling product lines and VAT impact.
- Sales questions about the time of day, customer types, and VAT.
- Customer questions such as customer types, gender distribution, and ratings.

## Revenue and Profit Calculations

The project includes calculations for Cost of Goods Sold (COGS), VAT, Total Gross Sales, Gross Profit, and Gross Margin Percentage.

## Code Sample

Here's an example code snippet for creating the database and table in SQL:

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    ... -- Other columns
    rating FLOAT(2, 1)
);
