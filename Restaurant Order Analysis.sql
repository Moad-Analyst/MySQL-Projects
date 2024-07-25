-- You've been asked to dig into the customer data to see which menu items are doing well / not well and what the top customer seem to like best 

-- 1. View The menu data items
SELECT * FROM menu_items;

-- 2. Find the number of items on the menu
SELECT COUNT(*) FROM menu_items;

-- 3. What are the least and the most expensive items on the menu? 
(SELECT item_name, price
FROM menu_items
ORDER BY price 
LIMIT 1)
UNION
(SELECT item_name, price
FROM menu_items
ORDER BY price DESC 
LIMIT 1);
-- In case There are more than one record with the same result use tgis query
(SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items))
UNION
(SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MAX(price)FROM menu_items));
-- 4. How many Italian dishes are on the menu?
SELECT COUNT(menu_item_id) AS Total_Italian_Dishes
FROM menu_items
WHERE category LIKE 'Italian';

-- 5. What are the least and the most expensive Italian dishes on the menu
(SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items WHERE category = 'Italian'))
UNION
(SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MAX(price)FROM menu_items WHERE category = 'Italian'));

-- 6. How many dishes are in each category?
SELECT
	category,
    COUNT(*) AS Total_Dishes
FROM
	menu_items
GROUP BY
	category
ORDER BY
	Total_Dishes DESC;
    
-- 7. What is the average dish price within each category?
SELECT
	category,
    ROUND(AVG(price), 2) AS Avg_Price 
FROM
	menu_items
GROUP BY
	category;
    
-- 8. View the orders table
SELECT * FROM order_details;

-- 9. What's the date range of the table
((SELECT
	MIN(order_date) AS Date_Range 
FROM 
	order_details) 
UNION
(SELECT
	MAX(order_date) 
FROM 
	order_details)) ;
    
-- 10. How many orders are there
SELECT COUNT(DISTINCT order_id) Total_Order FROM order_details;

-- 11. How many orders were made within that range?
SELECT COUNT(*) AS Total_purchse FROM order_details;

-- 12. Which orders had the most number of items?
SELECT
	order_id,
    COUNT(item_id) AS num_item
FROM
	order_details
GROUP BY
order_id
ORDER BY
num_item DESC;

-- 13. How many orders had more than 12 items?
SELECT COUNT(*) FROM
(SELECT
	order_id,
    COUNT(item_id) AS num_item
FROM
	order_details
GROUP BY
order_id
HAVING
	num_item > 12) AS Num_item;

-- 14. Conmbine the menu_items and order_details tables into a single table
SELECT * FROM menu_items;
SELECT * FROM order_details;

SELECT * 
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id;

-- 15. What were the least and most ordered item? What categories were they in?
SELECT  category, item_name, COUNT(order_details_id) AS num_purchases
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY category, item_name
ORDER BY num_purchases DESC;

-- 16. What were the top 5 orders that spent the most money
SELECT  order_id, SUM(price) Total_spent
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY SUM(price) DESC LIMIT 5; 

-- 17. View the details of the highest spend order. What insights can you gather from?
SELECT category, COUNT(menu_item_id) AS Num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id = 400
GROUP BY category;

-- 18.  View the details of the top 5 highest spend order, What insights can you gather from?
SELECT category, COUNT(menu_item_id) AS Num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category;
