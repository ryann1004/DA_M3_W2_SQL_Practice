USE coffeeshop_db;

-- =========================================================
-- JOINS & RELATIONSHIPS PRACTICE
-- =========================================================

-- Q1) Join products to categories: list product_name, category_name, price.
select p.product_id, c.category_id, p.price
from products p
join categories c on p.category_id = c.category_id;

-- Q2) For each order item, show: order_id, order_datetime, store_name,
--     product_name, quantity, line_total (= quantity * products.price).
--     Sort by order_datetime, then order_id.
SELECT 
    o.order_id,
    o.order_datetime,
    o.store_id,
    p.product_id,
    oi.quantity,
    (oi.quantity * p.price) AS line_total
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN stores s ON o.store_id = s.store_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_datetime, o.order_id;

-- Q3) Customer order history (PAID only):
--     For each order, show customer_id, store_name, order_datetime,
--     order_total (= SUM(quantity * products.price) per order).
select
	o.customer_id,
    s.store_id,
    o.order_datetime,
    sum(oi.quantity * p.price) as order_total
from orders o
JOIN stores s ON o.store_id = s.store_id
join order_items oi on oi.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by o.customer_id, s.store_id, o.order_datetime;
    
-- Q4) Left join to find customers who have never placed an order.
--     Return first_name, last_name, city, state.
select
	c.first_name,
    c.last_name,
    c.city,
    c.state
from customers c
left join orders o 
	on c.customer_id = o.customer_id
where o.order_id is null;

-- Q5) For each store, list the top-selling product by units (PAID only).
--     Return store_name, product_name, total_units.
--     Hint: Use a window function (ROW_NUMBER PARTITION BY store) or a correlated subquery.
WITH rankedproducts AS (
    SELECT
        s.store_id,
        oi.product_id,
        SUM(oi.quantity) AS total_units
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN stores s ON o.store_id = s.store_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status = 'paid'
    GROUP BY s.store_id, oi.product_id
    HAVING SUM(oi.quantity) = (
        SELECT MAX(sub.total_units)
        FROM (
            SELECT SUM(oi_inner.quantity) AS total_units
            FROM orders o_inner
            JOIN order_items oi_inner ON o_inner.order_id = oi_inner.order_id
            WHERE o_inner.status = 'paid'
            AND o_inner.store_id = s.store_id
            GROUP BY oi_inner.product_id            
        ) AS sub
    )
)

SELECT store_id, product_id, total_units
FROM rankedproducts;

-- Q6) Inventory check: show rows where on_hand < 12 in any store.
--     Return store_name, product_name, on_hand.
select 
	store_id,
	product_id,
    on_hand
from inventory
where on_hand < '12';

-- Q7) Manager roster: list each store's manager_name and hire_date.
--     (Assume title = 'Manager').
select
	store_id,
    title,
    first_name,
    last_name,
    hire_date
from employees
where title = 'manager';

-- Q8) Using a subquery/CTE: list products whose total PAID revenue is above
--     the average PAID product revenue. Return product_name, total_revenue.
SELECT 
    p.product_id,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'paid'
GROUP BY p.product_id
HAVING SUM(oi.quantity * p.price) > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT SUM(oi_inner.quantity * p_inner.price) AS total_revenue
        FROM orders o_inner
        JOIN order_items oi_inner ON o_inner.order_id = oi_inner.order_id
        JOIN products p_inner ON oi_inner.product_id = p_inner.product_id
        WHERE o_inner.status = 'paid'
        GROUP BY p_inner.product_id
    ) AS subquery
);

-- Q9) Churn-ish check: list customers with their last PAID order date.
--     If they have no PAID orders, show NULL.
--     Hint: Put the status filter in the LEFT JOIN's ON clause to preserve non-buyer rows.
select	
	c.customer_id,
    c.first_name,
    c.last_name,
    max(o.order_datetime) as last_paid_order_date
from customers c
left join orders o on c.customer_id = o.customer_id and o.status = 'paid'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;
    
-- Q10) Product mix report (PAID only):
--     For each store and category, show total units and total revenue (= SUM(quantity * products.price)).
select
	s.store_id,
	c.category_id,
    sum(oi.quantity) as total_units,
    sum(oi.quantity * p.price) as total_revenue
from orders o
join order_items oi on o.order_id = oi.order_id
join stores s on o.store_id = s.store_id
join products p on oi.product_id = p.product_id
join categories c on p.category_id = c.category_id
where o.status = 'paid'
group by s.store_id, c.category_id
order by s.store_id, c.category_id;

    
    
    
    
    