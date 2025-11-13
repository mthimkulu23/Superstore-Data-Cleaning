DROP TABLE IF EXISTS main  CASCADE
       

    



create table main(
    Row_ID VARCHAR,
    Order_ID VARCHAR,
    Order_Date DATE,
    Order_Month INT,
    Order_Day INT,
    Order_Year INT,	
    Ship_Date DATE,	
    Ship_Day INT,
    Ship_Month INT,
    Ship_Year INT,
    Ship_Mode VARCHAR,	
    Ship_ID	VARCHAR,
    Customer_ID	VARCHAR,
    Customer_Name VARCHAR,	
    Segment	VARCHAR,
    Segment_ID VARCHAR,
    Country	VARCHAR,
    Country_ID	VARCHAR,
    City	VARCHAR,
    City_ID	VARCHAR,
    State	VARCHAR,
    State_ID	VARCHAR,
    Postal_Code	INT,
    Postal_Code_ID	VARCHAR,
    Region	VARCHAR,
    Region_ID	VARCHAR,
    Product_ID	VARCHAR,
    Category	VARCHAR,
    Category_ID	VARCHAR,
    Sub_Category	VARCHAR,
    Sub_Category_ID	VARCHAR,
    Product_Name	VARCHAR,
    Sales	float,
    Quantity	INT,
    Discount	FLOAT,
    Profit  FLOAT

);


COPY main (
    Row_ID ,
    Order_ID ,
    Order_Date ,
    Order_Month ,
    Order_Day ,
    Order_Year ,	
    Ship_Date ,	
    Ship_Day ,
    Ship_Month ,
    Ship_Year ,
    Ship_Mode ,	
    Ship_ID	,
    Customer_ID	,
    Customer_Name ,	
    Segment	,
    Segment_ID ,
    Country	,
    Country_ID	,
    City	,
    City_ID	,
    State	,
    State_ID	,
    Postal_Code	,
    Postal_Code_ID	,
    Region	,
    Region_ID	,
    Product_ID	,
    Category	,
    Category_ID	,
    Sub_Category	,
    Sub_Category_ID	,
    Product_Name	,
    Sales	,
    Quantity	,
    Discount	,
    Profit		

)

FROM '/Users/damacm1152/Desktop/storedata.csv'
DELIMITER ','
CSV HEADER;







-- Step 2: Create dimension tables
CREATE TABLE countries AS
SELECT DISTINCT country
FROM main
WHERE country IS NOT NULL;

ALTER TABLE countries ADD COLUMN country_id SERIAL PRIMARY KEY;

-- Regions
CREATE TABLE regions AS
SELECT DISTINCT region, country
FROM main
WHERE region IS NOT NULL;

ALTER TABLE regions ADD COLUMN region_id SERIAL PRIMARY KEY;
ALTER TABLE regions ADD COLUMN country_id_fk INT;

UPDATE regions r
SET country_id_fk = c.country_id
FROM countries c
WHERE r.country = c.country;

ALTER TABLE regions ADD CONSTRAINT fk_country
FOREIGN KEY (country_id_fk) REFERENCES countries(country_id);

States

CREATE TABLE states AS
SELECT DISTINCT state, region
FROM main
WHERE state IS NOT NULL;

ALTER TABLE states ADD COLUMN state_id SERIAL PRIMARY KEY;
ALTER TABLE states ADD COLUMN region_id_fk INT;

UPDATE states s
SET region_id_fk = r.region_id
FROM regions r
WHERE s.region = r.region;

ALTER TABLE states ADD CONSTRAINT fk_region
FOREIGN KEY (region_id_fk) REFERENCES regions(region_id);

-- Cities
CREATE TABLE cities AS
SELECT DISTINCT city, state
FROM main
WHERE city IS NOT NULL;

ALTER TABLE cities ADD COLUMN city_id SERIAL PRIMARY KEY;
ALTER TABLE cities ADD COLUMN state_id_fk INT;

UPDATE cities c
SET state_id_fk = s.state_id
FROM states s
WHERE c.state = s.state;

ALTER TABLE cities ADD CONSTRAINT fk_states
FOREIGN KEY (state_id_fk) REFERENCES states(state_id);

-- Postal Codes
CREATE TABLE postal_codes AS
SELECT DISTINCT postal_code, city
FROM main
WHERE postal_code IS NOT NULL;

ALTER TABLE postal_codes ADD COLUMN postal_code_id SERIAL PRIMARY KEY;
ALTER TABLE postal_codes ADD COLUMN city_id_fk INT;

UPDATE postal_codes pc
SET city_id_fk = c.city_id
FROM cities c
WHERE pc.city = c.city;

ALTER TABLE postal_codes ADD CONSTRAINT fk_cities
FOREIGN KEY (city_id_fk) REFERENCES cities(city_id);

-- Categories
CREATE TABLE categories AS
SELECT DISTINCT category
FROM main
WHERE category IS NOT NULL;

ALTER TABLE categories ADD COLUMN category_id SERIAL PRIMARY KEY;

-- Sub-categories
CREATE TABLE sub_categories AS
SELECT DISTINCT sub_category, category
FROM main
WHERE sub_category IS NOT NULL;

ALTER TABLE sub_categories ADD COLUMN sub_category_id SERIAL PRIMARY KEY;
ALTER TABLE sub_categories ADD COLUMN category_id_fk INT;

UPDATE sub_categories sc
SET category_id_fk = c.category_id
FROM categories c
WHERE sc.category = c.category;

ALTER TABLE sub_categories ADD CONSTRAINT fk_categories
FOREIGN KEY (category_id_fk) REFERENCES categories(category_id);

-- Ship Modes
CREATE TABLE shipmodes AS
SELECT DISTINCT ship_mode
FROM main
WHERE ship_mode IS NOT NULL;

ALTER TABLE shipmodes ADD COLUMN shipmode_id SERIAL PRIMARY KEY;

-- Products
CREATE TABLE products AS
SELECT DISTINCT product_name, sub_category
FROM main
WHERE product_name IS NOT NULL;

ALTER TABLE products ADD COLUMN product_id SERIAL PRIMARY KEY;
ALTER TABLE products ADD COLUMN sub_category_id_fk INT;

UPDATE products p
SET sub_category_id_fk = sc.sub_category_id
FROM sub_categories sc
WHERE p.sub_category = sc.sub_category;

ALTER TABLE products ADD CONSTRAINT fk_sub_category
FOREIGN KEY (sub_category_id_fk) REFERENCES sub_categories(sub_category_id);

-- Segments


CREATE TABLE segments AS
SELECT DISTINCT segment
FROM main
WHERE segment IS NOT NULL;

ALTER TABLE segments ADD COLUMN segment_id SERIAL PRIMARY KEY;
-- Customers
CREATE TABLE customers AS
SELECT DISTINCT customer_name, segment, postal_code
FROM main
WHERE customer_name IS NOT NULL;

ALTER TABLE customers ADD COLUMN customer_id SERIAL PRIMARY KEY;
ALTER TABLE customers ADD COLUMN segment_id_fk INT;
ALTER TABLE customers ADD COLUMN postal_code_id_fk INT;

UPDATE customers cust
SET segment_id_fk = s.segment_id
FROM segments s
WHERE cust.segment = s.segment;

UPDATE customers cust
SET postal_code_id_fk = pc.postal_code_id
FROM postal_codes pc
WHERE cust.postal_code = pc.postal_code;

ALTER TABLE customers ADD CONSTRAINT fk_segment
FOREIGN KEY (segment_id_fk) REFERENCES segments(segment_id);

ALTER TABLE customers ADD CONSTRAINT fk_postal_codes
FOREIGN KEY (postal_code_id_fk) REFERENCES postal_codes(postal_code_id);

-- Orders (Fact Table)
CREATE TABLE orders AS
SELECT 
    order_id,
    order_date,
    order_month,
    order_year,
    order_day,
    ship_date,
    ship_day,
    ship_month,
    ship_year,
    quantity,
    discount,
    profit,
    sales,
    customer_name,
    ship_mode,
    product_name
FROM main;

ALTER TABLE orders ADD COLUMN order_pk SERIAL PRIMARY KEY;
ALTER TABLE orders ADD COLUMN customer_id_fk INT;
ALTER TABLE orders ADD COLUMN shipmode_id_fk INT;
ALTER TABLE orders ADD COLUMN product_id_fk INT;

UPDATE orders o
SET customer_id_fk = c.customer_id
FROM customers c
WHERE o.customer_name = c.customer_name;

UPDATE orders o
SET shipmode_id_fk = sm.shipmode_id
FROM shipmodes sm
WHERE o.ship_mode = sm.ship_mode;

UPDATE orders o
SET product_id_fk = p.product_id
FROM products p
WHERE o.product_name = p.product_name;

ALTER TABLE orders ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id_fk) REFERENCES customers(customer_id);

ALTER TABLE orders ADD CONSTRAINT fk_ship_mode
FOREIGN KEY (shipmode_id_fk) REFERENCES shipmodes(shipmode_id);

ALTER TABLE orders ADD CONSTRAINT fk_product
FOREIGN KEY (product_id_fk) REFERENCES products(product_id);








1.1 -- Total sales revenue for each year

SELECT order_year,SUM(sales) AS total_sales
FROM orders
GROUP BY order_year
ORDER BY order_year;




1.2  Month total across all years

SELECT order_month,SUM(sales) AS total_sales
FROM orders
GROUP BY order_month
ORDER BY total_sales DESC;



Task 1.3: Top 10 products by revenue

SELECT p.product_name,SUM(o.sales) AS total_revenue
FROM orders o
JOIN products p ON o.product_id_fk = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;




1.4  Sales by Category
SELECT c.category,SUM(o.sales) AS total_sales
FROM orders o
JOIN products p ON o.product_id_fk = p.product_id
JOIN sub_categories sc ON p.sub_category_id_fk = sc.sub_category_id
JOIN categories c ON sc.category_id_fk = c.category_id
GROUP BY c.category
ORDER BY total_sales DESC;


 1.5  Sales by Region
SELECT r.region,SUM(o.sales) AS total_sales
FROM orders o
JOIN customers cust ON o.customer_id_fk = cust.customer_id
JOIN postal_codes pc ON cust.postal_code_id_fk = pc.postal_code_id
JOIN cities ct ON pc.city_id_fk = ct.city_id
JOIN states st ON ct.state_id_fk = st.state_id
JOIN regions r ON st.region_id_fk = r.region_id
GROUP BY r.region
ORDER BY total_sales DESC;






-- 2.1: Profitability by Sub-Category

SELECT 
    sc.sub_category,
    SUM(o.profit) AS total_profit,
    SUM(o.sales) AS total_sales,
    SUM(o.quantity) AS total_qty
FROM orders o
JOIN products p ON o.product_id_fk = p.product_id
JOIN sub_categories sc ON p.sub_category_id_fk = sc.sub_category_id
GROUP BY sc.sub_category
ORDER BY total_profit DESC;



-- 2.2: Profit Margin by Category

SELECT
    c.category,
    SUM(o.profit) AS total_profit,
    SUM(o.sales) AS total_sales,
    ROUND(CAST(SUM(o.profit)/NULLIF(SUM(o.sales),0)*100 AS NUMERIC), 2) AS avg_profit_margin
FROM orders o
JOIN products p ON o.product_id_fk = p.product_id
JOIN sub_categories sc ON p.sub_category_id_fk = sc.sub_category_id
JOIN categories c ON sc.category_id_fk = c.category_id
GROUP BY c.category
ORDER BY avg_profit_margin DESC;



-- 2.3: Loss-Making Products

SELECT
    p.product_name,
    SUM(o.profit) AS total_profit,
    SUM(o.sales) AS total_sales,
    SUM(o.quantity) AS total_qty
FROM orders o
JOIN products p ON o.product_id_fk = p.product_id
GROUP BY p.product_name
HAVING SUM(o.profit) < 0
ORDER BY total_profit ASC;



-- 2.4: Discount Impact Analysis

SELECT
    o.discount,
    COUNT(*) AS num_orders,
    SUM(o.profit) AS total_profit,
    AVG(o.profit) AS avg_profit
FROM orders o
GROUP BY o.discount
ORDER BY o.discount;



-- 2.5: Profitability by Customer Segment

SELECT
    s.segment,
    SUM(o.profit) AS total_profit,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id_fk = c.customer_id
JOIN segments s ON c.segment_id_fk = s.segment_id
GROUP BY s.segment
ORDER BY total_profit DESC;




3.1 Top 20 Customers by Sales

SELECT c.customer_name,c.segment,r.region,SUM(o.sales) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id_fk = c.customer_id
JOIN postal_codes pc ON c.postal_code_id_fk = pc.postal_code_id
JOIN cities ct ON pc.city_id_fk = ct.city_id
JOIN states st ON ct.state_id_fk = st.state_id
JOIN regions r ON st.region_id_fk = r.region_id
GROUP BY c.customer_name, c.segment, r.region
ORDER BY total_spent DESC
LIMIT 20;



3.2 Customers with Multiple Orders

SELECT c.customer_name,s.segment,COUNT(o.order_id) AS order_count,
SUM(o.sales) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id_fk = c.customer_id
JOIN segments s ON c.segment_id_fk = s.segment_id
GROUP BY c.customer_name, s.segment
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC, total_spent DESC;



3.3 Region vs Customers & Sales

SELECT r.region, COUNT(DISTINCT c.customer_id) AS unique_customers, 
SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id_fk = c.customer_id
JOIN postal_codes pc ON c.postal_code_id_fk = pc.postal_code_id
JOIN cities ct ON pc.city_id_fk = ct.city_id
JOIN states st ON ct.state_id_fk = st.state_id
JOIN regions r ON st.region_id_fk = r.region_id
GROUP BY r.region
ORDER BY unique_customers DESC;


3.4 Average Order Value by Segment

SELECT c.customer_name, SUM(o.sales)/COUNT(*) AS average_order_value
FROM orders o JOIN customers c ON o.customer_id_fk = c.customer_id
GROUP BY c.customer_name ORDER BY average_order_value DESC;


3.5 Discount by Segment
SELECT c.segment, AVG(o.discount) AS avg_discount, SUM(o.sales) AS sales
FROM orders o JOIN customers c ON o.customer_id_fk = c.customer_id
GROUP BY c.segment ORDER BY sales DESC;






SHIPPING MODE ANALYSIS


4.1 Most Frequently Used Shipping Mode

SELECT 
    sm.ship_mode,
    COUNT(*) AS order_count,
    ROUND(CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS NUMERIC), 2) AS percentage
FROM orders o
JOIN shipmodes sm ON o.shipmode_id_fk = sm.shipmode_id
GROUP BY sm.ship_mode
ORDER BY order_count DESC;

-- Additional context: Average order value by shipping mode
SELECT 
    sm.ship_mode,
    COUNT(*) AS order_count,
    ROUND(CAST(AVG(o.sales) AS NUMERIC), 2) AS avg_order_value,
    ROUND(CAST(AVG(o.profit) AS NUMERIC), 2) AS avg_profit
FROM orders o
JOIN shipmodes sm ON o.shipmode_id_fk = sm.shipmode_id
GROUP BY sm.ship_mode
ORDER BY order_count DESC;



4.2 Shipping Time by Region


Calculate shipping days and analyze by region
SELECT 
    r.region,
    COUNT(*) AS total_orders,
    ROUND(CAST(AVG(o.ship_date - o.order_date) AS NUMERIC), 2) AS avg_shipping_days,
    MIN(o.ship_date - o.order_date) AS min_shipping_days,
    MAX(o.ship_date - o.order_date) AS max_shipping_days,
    ROUND(CAST(STDDEV(o.ship_date - o.order_date) AS NUMERIC), 2) AS std_dev_days
FROM orders o
JOIN customers c ON o.customer_id_fk = c.customer_id
JOIN postal_codes pc ON c.postal_code_id_fk = pc.postal_code_id
JOIN cities ct ON pc.city_id_fk = ct.city_id
JOIN states s ON ct.state_id_fk = s.state_id
JOIN regions r ON s.region_id_fk = r.region_id
WHERE o.ship_date IS NOT NULL AND o.order_date IS NOT NULL
GROUP BY r.region
ORDER BY avg_shipping_days DESC;

Shipping time by region AND shipping mode

SELECT 
    r.region,
    sm.ship_mode,
    COUNT(*) AS order_count,
    ROUND(CAST(AVG(o.ship_date - o.order_date) AS NUMERIC), 2) AS avg_shipping_days
FROM orders o
JOIN customers c ON o.customer_id_fk = c.customer_id
JOIN postal_codes pc ON c.postal_code_id_fk = pc.postal_code_id
JOIN cities ct ON pc.city_id_fk = ct.city_id
JOIN states s ON ct.state_id_fk = s.state_id
JOIN regions r ON s.region_id_fk = r.region_id
JOIN shipmodes sm ON o.shipmode_id_fk = sm.shipmode_id
WHERE o.ship_date IS NOT NULL AND o.order_date IS NOT NULL
GROUP BY r.region, sm.ship_mode
ORDER BY r.region, avg_shipping_days DESC;



-- 4.3 Shipping Mode with Highest Total Profit


SELECT 
    sm.ship_mode,
    COUNT(*) AS total_orders,
    ROUND(CAST(SUM(o.sales) AS NUMERIC), 2) AS total_sales,
    ROUND(CAST(SUM(o.profit) AS NUMERIC), 2) AS total_profit,
    ROUND(CAST(AVG(o.profit) AS NUMERIC), 2) AS avg_profit_per_order,
    ROUND(CAST(SUM(o.profit) / NULLIF(SUM(o.sales), 0) * 100 AS NUMERIC), 2) AS profit_margin_pct
FROM orders o
JOIN shipmodes sm ON o.shipmode_id_fk = sm.shipmode_id
GROUP BY sm.ship_mode
ORDER BY total_profit DESC;



-- 4.4 Shipping Time Impact on Repeat Purchases


-- First, create a view of customer purchase patterns with shipping times
WITH customer_order_analysis AS (
    SELECT 
        o.customer_id_fk,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(CAST(AVG(o.ship_date - o.order_date) AS NUMERIC), 2) AS avg_shipping_days,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date
    FROM orders o
    JOIN customers c ON o.customer_id_fk = c.customer_id
    WHERE o.ship_date IS NOT NULL AND o.order_date IS NOT NULL
    GROUP BY o.customer_id_fk, c.customer_name

SELECT 
    CASE 
        WHEN avg_shipping_days <= 2 THEN '0-2 days (Same/Next Day)'
        WHEN avg_shipping_days <= 4 THEN '3-4 days (Standard)'
        WHEN avg_shipping_days <= 6 THEN '5-6 days (Slower)'
        ELSE '7+ days (Very Slow)'
    END AS shipping_speed_category,
    COUNT(*) AS customer_count,
    ROUND(CAST(AVG(total_orders) AS NUMERIC), 2) AS avg_orders_per_customer,
    ROUND(CAST(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS NUMERIC), 2) AS repeat_customer_pct
FROM customer_order_analysis
GROUP BY 
    CASE 
        WHEN avg_shipping_days <= 2 THEN '0-2 days (Same/Next Day)'
        WHEN avg_shipping_days <= 4 THEN '3-4 days (Standard)'
        WHEN avg_shipping_days <= 6 THEN '5-6 days (Slower)'
        ELSE '7+ days (Very Slow)'
    END
ORDER BY 
    MIN(avg_shipping_days);

Additional analysis: Correlation between shipping time and repeat rate
WITH customer_metrics AS (
    SELECT 
        o.customer_id_fk,
        COUNT(DISTINCT o.order_id) AS total_orders,
        AVG(o.ship_date - o.order_date) AS avg_shipping_days
    FROM orders o
    WHERE o.ship_date IS NOT NULL AND o.order_date IS NOT NULL
    GROUP BY o.customer_id_fk
)
SELECT 
    ROUND(CAST(avg_shipping_days AS NUMERIC), 1) AS shipping_days,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(CAST(AVG(total_orders) AS NUMERIC), 2) AS avg_orders,
    ROUND(CAST(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS NUMERIC), 2) AS repeat_rate_pct
FROM customer_metrics
GROUP BY ROUND(CAST(avg_shipping_days AS NUMERIC), 1)
HAVING COUNT(*) >= 10  -- Only include shipping times with meaningful sample sizes
ORDER BY shipping_days;


5.1 seasonal patterns in sales for different product categories

SELECT
    c.category,
    EXTRACT(MONTH FROM o.order_date) AS month,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN products p ON o.product_id_fk = p.product_id
JOIN sub_categories sc ON p.sub_category_id_fk = sc.sub_category_id
JOIN categories c ON sc.category_id_fk = c.category_id
GROUP BY c.category, month
ORDER BY c.category, month;

5.2 Calculate the average quantity ordered per product

SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity,
    COUNT(*) AS order_count,
    ROUND(AVG(o.quantity)::numeric, 2) AS avg_quantity_per_order
FROM orders o
JOIN products p ON o.product_id_fk = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC;

5.3 Determine the average sales amount per order.

SELECT
    order_id,order_pk,
    SUM(sales) AS order_total,
    ROUND(AVG(SUM(sales)) OVER ()::numeric, 2) AS avg_sales_per_order
FROM orders
GROUP BY order_pk
ORDER BY order_pk DESC;

5.4 Identify the most frequently purchased products

SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity,
    COUNT(DISTINCT o.order_pk) AS order_count
FROM orders o
JOIN products p ON o.product_id_fk = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;



5.5 Investigate whether certain products are commonly purchased together.

SELECT
    p1.product_name AS product_a,
    p2.product_name AS product_b,
    COUNT(*) AS cooccurrence_count
FROM orders o1
JOIN orders o2 
    ON o1.order_id = o2.order_id
    AND o1.product_id_fk < o2.product_id_fk
JOIN products p1 ON o1.product_id_fk = p1.product_id
JOIN products p2 ON o2.product_id_fk = p2.product_id
GROUP BY product_a, product_b
ORDER BY cooccurrence_count DESC
LIMIT 20;



5.6 Analyze whether regions show preferences for certain product categories.

SELECT
    r.region,
    c.category,
    SUM(o.sales) AS total_sales,
    SUM(o.quantity) AS total_quantity
FROM orders o
JOIN customers cust ON o.customer_id_fk = cust.customer_id
JOIN postal_codes pc ON cust.postal_code_id_fk = pc.postal_code_id
JOIN cities ci ON pc.city_id_fk = ci.city_id
JOIN states s ON ci.state_id_fk = s.state_id
JOIN regions r ON s.region_id_fk = r.region_id
JOIN products p ON o.product_id_fk = p.product_id
JOIN sub_categories sc ON p.sub_category_id_fk = sc.sub_category_id
JOIN categories c ON sc.category_id_fk = c.category_id
GROUP BY r.region, c.category
ORDER BY r.region, total_sales DESC;
