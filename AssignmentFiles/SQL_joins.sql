USE coffeeshop_db;

-- =========================================================
-- JOINS & RELATIONSHIPS PRACTICE
-- =========================================================

-- Q1) Join products to categories: list product_name, category_name, price.

-- Q2) For each order item, show: order_id, order_datetime, store_name,
--     product_name, quantity, line_total (quantity * unit_price).
--     Sort by order_datetime, then order_id.

-- Q3) Customer order history: for each order (paid only),
--     show customer name, store, order_datetime, order_total.

-- Q4) Left join to find customers who have never placed an order.
--     Return their names and city/state.

-- Q5) For each store, list the top-selling product by units (paid only).
--     Return store_name, product_name, total_units. (Hint: GROUP BY + ORDER BY ... LIMIT per-store can be done with window functions or a subquery.)

-- Q6) Inventory check: show products where on_hand < 12 in any store.
--     Return store_name, product_name, on_hand.

-- Q7) Manager roster: list each store's manager name and hire_date.
--     (Assume title='Manager'.)

-- Q8) Using a subquery: list products whose total paid revenue is above the average product revenue.
--     Return product_name, total_revenue.

-- Q9) Churn-ish check: list customers with their last order date (paid only).
--     If they have no orders, show NULL.

-- (Stretch) Q10) Build a small product mix report:
--     For each store and category, show total paid units and revenue.
