USE coffeeshop_db;

-- =========================================================
-- FILTERING & AGGREGATION PRACTICE
-- =========================================================

-- Q1) Compute total revenue per order (order_id, order_total) using v_order_revenue.

-- Q2) Compute total revenue per store (store_id, store_name, total_revenue),
--     excluding orders with status <> 'paid'.

-- Q3) How many orders (count) were placed per day? (date, orders_count) for all days present.

-- Q4) What is the average order_total for paid orders only?

-- Q5) Which products (by name) have sold the most units overall across all stores?
--     Return product_name and total_units, sorted desc.

-- Q6) Revenue by category (category_name, revenue), only for paid orders.

-- Q7) For each store, how many unique customers have placed a paid order?

-- Q8) Which day of week has the highest total revenue for paid orders?
--     Return day_name and total_revenue. (Hint: DAYNAME(order_datetime))

-- Q9) Show categories whose total paid revenue exceeds $30. (HAVING)

-- Q10) Create a summary: per store, list payment_method and total revenue for paid orders.

-- (Optional) Q11) Among paid orders, what percent of revenue is from 'Beans'?
--     Return a single row with pct_beans_revenue (0-100).
