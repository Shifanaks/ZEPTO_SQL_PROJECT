DROP TABLE if exists Zepto;

CREATE TABLE Zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent numeric(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


--data exploaration

--count of rows
SELECT COUNT(*) FROM Zepto;

--sample data
SELECT(*) FROM Zepto
LIMIT 10;

--NULL VALUES
SELECT * FROM Zepto 
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightIngms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product category
SELECT DISTINCT category
FROM Zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock COUNT(sku_id)
FROM Zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "Number Of SKUs"
FROM Zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--DATA CLEANING

--PRODUCT WITH PRICE=0
SELECT * FROM Zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM Zepto
WHERE mrp = 0;

--convert paisa into rupees
UPDATE Zepto
SET mrp = mrp/100.0
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM Zepto;

==find the top 10 best value products based on the discount percentage
SELECT DISTINCT name, mrp, discountPercent
FROM Zepto
ORDER BY discountPercent DESC
LIMIT 10;

--what are the products with high mrp but out of stock
SELECT DISTINCT name, mrp
FROM Zepto
WHARE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Calculate estimated revenue for each category
SELECT category,
SUM(diacountedSellingPrice * availableQuantity) AS total_revenue
FROM Zepto
GROUP BY category
ORDER BY total_revenue;

--find all products where MRP is greater than 500 and discount is less than 10%
SELECT DISTINCT name, mrp, discountPercent
FROM Zepto
WHERE mrp > 500 AND discountPercent <10
ORDER BY mrp desc, discountPercent DESC;

-- identify the top 5 categories offering the highest average discount percentage
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM Zepto
GROUP BY category
ORDER BY vag_discount DESC
LIMIT 5;

--find the  price per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discounteSellingPrice/weightInGms,2) AS price_per_gram
FROM Zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--group the products into categories like low, medium, bulk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
     ELSE 'Bulk'
     END AS weight_category
FROM Zepto;

--what is the total  inventory weight per category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM Zepto
GROUP BY category
ORDER BY total_weight:

--for joins

-- Table 2: Category Info
CREATE TABLE category_info (
    Category VARCHAR(50) PRIMARY KEY,
    description VARCHAR(255)
);

-- category_info data
INSERT INTO category_info (Category, description) VALUES
('Fruits & Vegetables', 'Fresh farm produce'),
('Snacks', 'Packaged snacks and munchies'),
('Beverages', 'Drinks and refreshers');


--inner join
SELECT z.Category, z.name, z.mrp, c.description
FROM Zepto AS z
INNER JOIN category_info AS c
ON z.Category = c.Category;


--create view
CREATE VIEW zepto_analysis AS
SELECT z.*, c.description
FROM Zepto AS z
LEFT JOIN category_info AS c
ON z.Category = c.Category;


SELECT * FROM zepto_analysis;


--check the snack
SELECT z.*, c.description
FROM Zepto AS z
LEFT JOIN category_info AS c
ON z.Category = c.Category
WHERE z.Category = 'Snacks';


--create index
CREATE INDEX idx_category_zepto
ON Zepto(Category);

CREATE INDEX idx_category_categoryinfo
ON category_info(Category);


--show the index
SELECT * 
FROM pg_indexes 
WHERE tablename = 'zepto';






