-- ==================================
-- FILTERS & AGGREGATION
-- ==================================

USE coffeeshop_db;


-- Q1) Compute total items per order.
--     Return (order_id, total_items) from order_items.
SELECT order_id, SUM(quantity) AS total_items
FROM order_items
GROUP BY order_id;

-- Q2) Compute total items per order for PAID orders only.
--     Return (order_id, total_items). Hint: order_id IN (SELECT ... FROM orders WHERE status='paid').
select order_id, sum(quantity) as total_items
from order_items
where order_id in (
	select order_id
    from orders
    where status = 'paid'
)
group by order_id;

-- Q3) How many orders were placed per day (all statuses)?
--     Return (order_date, orders_count) from orders.
select order_datetime, count(order_id) as order_count
from orders
group by order_datetime
order by order_datetime;

-- Q4) What is the average number of items per PAID order?
--     Use a subquery or CTE over order_items filtered by order_id IN (...).
SELECT AVG(item_count) AS average_items_per_paid_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM order_items
    WHERE order_id IN (
        SELECT order_id
        FROM orders
        WHERE status = 'paid'
    )
    GROUP BY order_id
) AS order_item_counts;


-- Q5) Which products (by product_id) have sold the most units overall across all stores?
--     Return (product_id, total_units), sorted desc.
select product_id, sum(quantity) as total_units
from order_items
group by product_id
order by total_units desc;

-- Q6) Among PAID orders only, which product_ids have the most units sold?
--     Return (product_id, total_units_paid), sorted desc.
--     Hint: order_id IN (SELECT order_id FROM orders WHERE status='paid').
SELECT oi.product_id, SUM(oi.quantity) AS total_units_paid
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'paid'
GROUP BY oi.product_id
ORDER BY total_units_paid DESC;

-- Q7) For each store, how many UNIQUE customers have placed a PAID order?
--     Return (store_id, unique_customers) using only the orders table.
SELECT store_id, COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
WHERE status = 'paid'
GROUP BY store_id;

-- Q8) Which day of week has the highest number of PAID orders?
--     Return (day_name, orders_count). Hint: DAYNAME(order_datetime). Return ties if any.
WITH DailyOrderCounts AS (
    SELECT DAYNAME(order_datetime) AS day_name, COUNT(*) AS orders_count
    FROM orders
    WHERE status = 'paid'
    GROUP BY day_name
)
SELECT day_name, orders_count
FROM DailyOrderCounts
WHERE orders_count = (
    SELECT MAX(orders_count) FROM DailyOrderCounts
);

-- Q9) Show the calendar days whose total orders (any status) exceed 3.
--     Use HAVING. Return (order_date, orders_count).
select date(order_datetime) as order_date, count(*) as orders_count
from orders
group by order_date
having count(*) > 3;

-- Q10) Per store, list payment_method and the number of PAID orders.
--      Return (store_id, payment_method, paid_orders_count).
select store_id, payment_method, count(*) as paid_orders_count
from orders
where status = 'paid'
group by store_id, payment_method;

-- Q11) Among PAID orders, what percent used 'app' as the payment_method?
--      Return a single row with pct_app_paid_orders (0–100).
SELECT 
    (COUNT(CASE WHEN payment_method = 'app' THEN 1 END) * 100.0 / COUNT(*)) AS pct_app_paid_orders
FROM orders
WHERE status = 'paid';


-- Q12) Busiest hour: for PAID orders, show (hour_of_day, orders_count) sorted desc.
SELECT HOUR(order_datetime) AS hour_of_day, COUNT(*) AS orders_count
FROM orders
WHERE status = 'paid'
GROUP BY hour_of_day
ORDER BY orders_count DESC;


-- ================
