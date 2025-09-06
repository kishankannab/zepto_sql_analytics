USE zepto;

-- NULL values 
SELECT *
FROM zepto 
WHERE Category IS NULL OR name IS NULL OR mrp IS NULL OR discountPercent IS NULL
OR availableQuantity IS NULL OR discountedSellingPrice IS NULL OR weightInGms IS NULL OR outOfStock IS NULL OR quantity IS NULL;

--different product categories
SELECT DISTINCT category 
FROM zepto 
ORDER BY category;

-- products in stocks vs out of stock
SELECT outOfStock, COUNT(*) AS product_count
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, COUNT(*) AS Number_of_SKUs
FROM zepto 
GROUP BY name 
HAVING COUNT(*)>1 
ORDER BY Number_of_SKUs DESC;

-- Data Cleaning

-- products with price = 0
SELECT *
FROM zepto 
WHERE mrp = 0 or discountedSellingPrice = 0;

DELETE FROM zepto 
WHERE mrp = 0;

-- mrps and discountedSellingPrice are in paise
-- Converting paise to rupees
UPDATE zepto 
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice
FROM zepto;

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT TOP 10 *
FROM zepto
ORDER BY discountPercent DESC;

--Q2. What are the products with High MRP but out of stock
SELECT *
FROM zepto 
WHERE outOfStock = 1 AND mrp>300;

--Q3. Calculate Estimated Revenue for each category
SELECT Category, SUM(discountedSellingPrice*quantity) AS estimated_revenue
FROM zepto
GROUP BY Category
ORDER BY estimated_revenue DESC;

--Q4. Find all products where mrp is greater than 500 and discount is less than 10%
SELECT *
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC, discountPercent DESC;

--Q5.Identify the top 5 categories offering the highest average discount percentage
SELECT TOP 5 Category, AVG(discountPercent) AS average_discount_percentage
FROM zepto
GROUP BY Category 
ORDER BY average_discount_percentage DESC;

--Q6. Find the price per gram for products above 100g and sort by best value
SELECT Category, name, ROUND(discountedSellingPrice*1.0/weightInGms,3)*100 AS price_per_gram_in_paise
FROM zepto
WHERE weightInGms>100
ORDER BY price_per_gram_in_paise;

--Q7. Group the products into categories like low, Medium, Bulk
SELECT DISTINCT name, weightInGms,
       CASE WHEN weightInGms < 1000 THEN 'Low'
	        WHEN weightInGms <5000 THEN 'Medium'
			ELSE 'Bulk' END AS weight_category 
FROM zepto;

--Q8. What is the Total Inventory Weight Per Category
SELECT Category, ROUND(SUM(weightIngms*quantity)/1000.0,3) AS total_inventory_weight
FROM zepto
GROUP BY Category;

