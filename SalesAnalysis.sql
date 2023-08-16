-- Create database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'walmartSales')
BEGIN
    CREATE DATABASE walmartSales;
END;
USE walmartSales; -- Assuming you're using the 'walmartSales' database


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sales') AND type in (N'U'))
BEGIN
    CREATE TABLE sales(
        invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
        branch VARCHAR(5) NOT NULL,
        city VARCHAR(30) NOT NULL,
        customer_type VARCHAR(30) NOT NULL,
        gender VARCHAR(30) NOT NULL,
        product_line VARCHAR(100) NOT NULL,
        unit_price DECIMAL(10, 2) NOT NULL,
        quantity INT NOT NULL,
        tax_pct FLOAT NOT NULL,
        total DECIMAL(12, 4) NOT NULL,
        date DATETIME NOT NULL,
        time TIME NOT NULL,
        payment VARCHAR(15) NOT NULL,
        cogs DECIMAL(10, 2) NOT NULL,
        gross_margin_pct FLOAT,
        gross_income DECIMAL(12, 4),
        rating FLOAT
    );
END;

-- Data cleaning
SELECT *
FROM sales;

-- Query to Categorize Time of Day from Sales Data
SELECT
    time,
    CASE
        WHEN time >= '00:00:00' AND time <= '12:00:00' THEN 'Morning'
        WHEN time >= '12:01:00' AND time <= '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sales;

-- Add the time_of_day column
ALTER TABLE sales ADD time_of_day VARCHAR(20);

-- To perform the following update, make sure you have backed up your data or tested it on a sample dataset,
-- as updating all records in the table can have significant impact.

-- Update the time_of_day column based on the time column values
UPDATE sales
SET time_of_day = (
    CASE
        WHEN [time] >= '00:00:00' AND [time] <= '12:00:00' THEN 'Morning'
        WHEN [time] >= '12:01:00' AND [time] <= '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

-- Add day_name column
-- Select the date and its corresponding day name
SELECT
    [date],
    DATENAME(dw, [date]) AS day_name
FROM sales;

-- Add the day_name column to the table
ALTER TABLE sales ADD day_name VARCHAR(10);

-- Update the day_name column based on the date column values
UPDATE sales
SET day_name = DATENAME(dw, [date]);

-- Add month_name column
-- Select the date and its corresponding month name
SELECT
    [date],
    DATENAME(month, [date]) AS month_name
FROM sales;

-- Add the month_name column to the table
ALTER TABLE sales ADD month_name VARCHAR(10);

-- Update the month_name column based on the date column values
UPDATE sales
SET month_name = DATENAME(month, [date]);









-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT DISTINCT city, branch
FROM sales;




-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM sales;

-- What is the most selling product line?
SELECT
    SUM(quantity) AS qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- What is the total revenue by month?
SELECT
    month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue;

-- What month had the largest COGS?
SELECT
    month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs;

-- What product line had the largest revenue?
SELECT
    product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
    branch,
    city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue;

-- What product line had the largest VAT?
SELECT
    product_line,
    AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product
-- lines showing "Good" if it's greater than average sales, otherwise "Bad"
SELECT
    AVG(quantity) AS avg_qnty
FROM sales;

SELECT
    product_line,
    CASE
        WHEN AVG(quantity) > 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than the average product sold?
SELECT
    branch,
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT
    gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT
    ROUND(AVG(rating), 2) AS avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;



-- --------------------------------------------------------------------
-- --------------------------------------------------------------------







-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM sales;

-- What is the most common customer type?
SELECT
    customer_type,
    COUNT(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
    customer_type,
    COUNT(*) as total_purchases
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT
    gender,
    COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
    gender,
    COUNT(*) as gender_cnt
FROM sales
WHERE branch = 'C'
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT
    time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
    time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings?
SELECT
    day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT
    day_name,
    COUNT(day_name) AS total_sales
FROM sales
WHERE branch = 'C'
GROUP BY day_name
ORDER BY total_sales DESC;



-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT
    time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Sunday'
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evening experiences the most sales on Sundays, 
-- suggesting higher customer activity during evening hours.

-- Which of the customer types brings the most revenue?
SELECT
    customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;
-- Type "Member" brings in the highest revenue, followed by "Normal" and "Guest".

-- Which city has the largest tax/VAT percent?
SELECT
    city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;
-- The city with the largest average tax/VAT percent is shown.

-- Which customer type pays the most in VAT?
SELECT
    customer_type,
    AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
-- The customer type with the highest average VAT payment is shown.

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------


