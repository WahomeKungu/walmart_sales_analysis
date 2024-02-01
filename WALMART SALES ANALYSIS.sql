 CREATE TABLE IF NOT EXISTS sales(
   invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
   branch VARCHAR(5) NOT NULL,
   city VARCHAR(30) NOT NULL,
   customer_type VARCHAR(30) NOT NULL,
   gender VARCHAR(10) NOT NULL,
   product_line VARCHAR(100) NOT NULL,
   unit_price DECIMAL(10,2) NOT NULL,
   quantity INT NOT NULL,
   VAT FLOAT(6,4) NOT NULL,
   total DECIMAL (12,4) NOT NULL,
   date DATETIME NOT NULL,
   time TIME NOT NULL,
   payment_method VARCHAR(15) NOT NULL,
   cogs DECIMAL(10,2) NOT NULL,
   gross_margin_pct FLOAT(11,9),
   gross_income DECIMAL(12,4) NOT NULL,
   rating FLOAT(2,1)
);

-- Feature Engineering -----------

-- time of day 
SELECT 
   time,
   (CASE 
      WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
      WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
      ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
  CASE 
      WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
      WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
      ELSE "Evening"
    END
);

-- Day name
SELECT 
  date,
  DAYNAME(date)  AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month name
SELECT
  date,
  MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = monthname(date);


------ GENERIC QUESTIONS ------------

-- How many distinct cities does the data have?
SELECT DISTINCT city
FROM sales;

-- In which city is each branch
SELECT DISTINCT city,
   branch
FROM sales;

-- How many unique product lines does the data have?
SELECT
  count(DISTINCT product_line)
FROM sales;

-- most common payment method
SELECT
  payment_method, 
  count(payment_method) AS cnt
FROM sales
group by payment_method
ORDER BY cnt desc;

-- most selling product line
SELECT
  product_line,
  COUNT(product_line) AS cnt_prd
FROM sales
GROUP BY product_line
ORDER by cnt_prd DESC;

-- total revenue by month
SELECT 
  month_name AS month,
  SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue desc;

-- what month had the largest cogs
SELECT 
  month_name AS month,
  SUM(cogs) as cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue
SELECT
  product_line,
  SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- what city has the largest revenue
SELECT
  city,
  branch,
  SUM(total) AS total_revenue
FROM sales
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- which branch sold more products than average product sold
SELECT
  branch,
  SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG (quantity) FROM sales);

-- what is the most common product line by gender
SELECT 
  gender,
  product_line,
  COUNT(gender) AS total_count
FROM sales
GROUP BY gender, product_line
ORDER BY total_count DESC;

-- what is the average rating of each product line
SELECT 
  product_line,
  ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;



-- ----------------SALES ANALYSIS --------------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT 
  time_of_day,
  COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales desc;

-- Which of the customer types brings the most revenue?
SELECT 
  customer_type,
  SUM(total) as total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
  city,
  ROUND(AVG(VAT),2) as VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;


-- Which customer type pays the most in VAT?
SELECT 
  customer_type,
  AVG(VAT) AS total_VAT
FROM sales
GROUP BY customer_type
ORDER BY total_VAT DESC;

-- --------------------------------------------------------------------------------------------------------------------------
































   
   