-- Creating DATABASE ecommerce_db
CREATE database ecommerce_db;
USE ecommerce_db;

SELECT * FROM ecommerce
LIMIT 10;

SHOW INDEX FROM ecommerce;
DESCRIBE ecommerce;

-- Adding and PRIMARY KEY

ALTER TABLE ecommerce
MODIFY orderid VARCHAR(20) PRIMARY KEY;

-- **Sales Insights**
-- Which platform generate highest revenue ?
select sum(total_amount) as Total_revenue from ecommerce;

select platform, ROUND(sum(total_amount), 2) as revenue
from ecommerce
group by platform;

-- Top selling categoies ?

select category, sum(quantity) as quantity_sold, ROUND(sum(total_amount), 2) as revenue
from ecommerce
group by category
order by sum(total_amount) desc;

-- Highest revenue cities?

select city, sum(quantity) as quantity_sold, ROUND(sum(total_amount), 2) as revenue
from ecommerce
group by city
order by sum(total_amount) desc;

-- **Customer/product behavior**

-- Most reviewed products ?

select product, sum(reviews) as reviews, ROUND(sum(rating), 2) as total_rating
from ecommerce
group by product
order by reviews desc;

-- Do higher rating correlate with higher sales ?

select
	CASE 
		WHEN rating >=4 AND rating <= 5 THEN '4 - 5'
		WHEN rating >=3 AND rating < 4 THEN '3 - 4'
		ELSE '0 - 3'
	END AS rating_group,
    sum(quantity) as total_quantity_sold,
    round(sum(total_amount), 2) as total_revenue
from ecommerce
group by rating_group
order by rating_group desc;
    
-- Average order value by category

select category, ROUND(AVG(total_amount),2) as avg_order_value
from ecommerce
group by category
order by avg_order_value desc;

-- **Time Analysis**
-- Which month had highest sales?

select month, ROUND(sum(total_amount), 2) as total_amount
from ecommerce
group by month
order by sum(total_amount)
limit 1;

--   total_revenue generated on each category of product and month?

select category, product, month, sum(total_amount) as total_amount
from ecommerce
group by category, product, month
order by category, product, month;

 -- highest_revenue for each month based, with respect to each category and product
 
WITH highest_month_revenue AS (
SELECT category, product, month, sum(total_amount) as total_amt,
	DENSE_RANK() OVER (
		PARTITION BY category, product
		ORDER BY sum(total_amount) desc
        ) as d_rank
FROM ecommerce
group by category, product, month
)

SELECT * FROM highest_month_revenue
WHERE d_rank = 1;

-- How many order gets on each weekday ?

SELECT day_name, count(*) as no_of_orders
FROM ecommerce
group by day_name
order by FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- Which weekday gets more orders ?

select day_name, count(*) as no_of_orders
from ecommerce
group by day_name
order by no_of_orders desc
limit 1;

-- **Platform Comparision**
-- Estimated Revenue by platform and Percentage of Revenue contributed by platform ?

select 
	platform, 
	ROUND(sum(total_amount),2) as revenue,
    ROUND((sum(total_amount) * 100.0 / sum(sum(total_amount)) over()), 2) as percentage
from ecommerce
group by platform
order by sum(total_amount) desc;

-- Top 5 brands by revenue

select brand, ROUND(sum(total_amount),2) as revenue
from ecommerce
group by brand
order by sum(total_amount) desc
limit 5;

-- END --

