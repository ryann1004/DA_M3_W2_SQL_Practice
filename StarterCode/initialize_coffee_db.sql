-- Drop & create fresh schema
DROP DATABASE IF EXISTS coffeeshop_db;
CREATE DATABASE coffeeshop_db;
USE coffeeshop_db;

-- --------------------------------------------
-- Tables
-- --------------------------------------------
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name  VARCHAR(50),
  email      VARCHAR(100) UNIQUE,
  city       VARCHAR(100),
  state      VARCHAR(50)
);

CREATE TABLE stores (
  store_id INT PRIMARY KEY AUTO_INCREMENT,
  name     VARCHAR(100),
  city     VARCHAR(100),
  state    VARCHAR(50)
);

CREATE TABLE employees (
  employee_id INT PRIMARY KEY AUTO_INCREMENT,
  store_id INT,
  first_name VARCHAR(50),
  last_name  VARCHAR(50),
  title      VARCHAR(50),
  hire_date  DATE,
  FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(100)
);

CREATE TABLE products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  category_id INT,
  name        VARCHAR(100),
  price       DECIMAL(6,2),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  store_id INT,
  order_datetime DATETIME,
  status  ENUM('paid','refunded','void') DEFAULT 'paid',
  payment_method ENUM('cash','card','app') DEFAULT 'card',
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (store_id)    REFERENCES stores(store_id)
);

CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(6,2), -- price at time of sale
  FOREIGN KEY (order_id)  REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE inventory (
  store_id INT,
  product_id INT,
  on_hand INT,
  PRIMARY KEY (store_id, product_id),
  FOREIGN KEY (store_id)  REFERENCES stores(store_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- --------------------------------------------
-- Seed data
-- --------------------------------------------

INSERT INTO stores (name, city, state) VALUES
 ('Līhuʻe Café','Līhuʻe','HI'),
 ('Kapaʻa Café','Kapaʻa','HI'),
 ('Hanalei Café','Hanalei','HI');

INSERT INTO employees (store_id, first_name, last_name, title, hire_date) VALUES
 (1,'Malia','Kea','Manager','2023-11-02'),
 (1,'Noa','Ikaika','Barista','2024-06-10'),
 (2,'Kai','Tan','Manager','2024-02-14'),
 (2,'Leilani','Wong','Barista','2025-01-05'),
 (3,'Keanu','Lee','Manager','2024-08-20'),
 (3,'Ana','Rivera','Barista','2025-03-01');

INSERT INTO customers (first_name,last_name,email,city,state) VALUES
 ('Ava','Kona','ava.kona@example.com','Līhuʻe','HI'),
 ('Mason','Imai','m.ima@example.com','Kapaʻa','HI'),
 ('Olivia','Park','olivia.park@example.com','Hanalei','HI'),
 ('Liam','Akana','liam.ak@example.com','Kīlauea','HI'),
 ('Emma','Lau','emma.lau@example.com','Wailua','HI'),
 ('Noah','Kim','noah.kim@example.com','Princeville','HI'),
 ('Sophia','Ng','sophia.ng@example.com','Līhuʻe','HI'),
 ('Ethan','Nakamura','ethan.n@example.com','Kapaʻa','HI');

INSERT INTO categories (name) VALUES
 ('Espresso'),
 ('Tea'),
 ('Bakery'),
 ('Beans'),
 ('Merch');

INSERT INTO products (category_id, name, price) VALUES
 (1,'Espresso',3.00),
 (1,'Latte',4.75),
 (1,'Cappuccino',4.50),
 (1,'Cold Brew',4.25),
 (2,'Green Tea',3.25),
 (2,'Chai Latte',4.50),
 (3,'Croissant',3.50),
 (3,'Banana Bread',3.75),
 (4,'House Beans 12oz',12.00),
 (4,'Kona Blend 12oz',16.00),
 (5,'Mug',10.00),
 (5,'T-Shirt',18.00);

-- Orders (2025, mixed times/methods)
INSERT INTO orders (customer_id, store_id, order_datetime, status, payment_method) VALUES
 (1,1,'2025-08-29 07:42:00','paid','card'),
 (2,2,'2025-08-29 08:15:00','paid','cash'),
 (3,3,'2025-08-30 09:05:00','paid','card'),
 (4,1,'2025-08-30 14:20:00','paid','app'),
 (5,2,'2025-09-01 07:50:00','paid','card'),
 (6,2,'2025-09-02 12:10:00','paid','card'),
 (7,1,'2025-09-02 16:45:00','refunded','card'),
 (8,3,'2025-09-03 10:30:00','paid','cash'),
 (1,1,'2025-09-04 06:58:00','paid','app'),
 (2,2,'2025-09-04 13:22:00','paid','card'),
 (3,3,'2025-09-05 08:40:00','paid','card'),
 (4,1,'2025-09-06 09:10:00','paid','cash'),
 (5,2,'2025-09-07 15:05:00','void','card'),
 (6,2,'2025-09-08 07:33:00','paid','app'),
 (7,1,'2025-09-08 11:12:00','paid','card');

-- Order items (quantity & unit_price captured at sale)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
 (1, 2, 1, 4.75),  (1, 7, 1, 3.50),
 (2, 1, 2, 3.00),
 (3, 4, 1, 4.25),  (3, 8, 1, 3.75),
 (4, 6, 1, 4.50),  (4,11, 1,10.00),
 (5, 2, 2, 4.75),
 (6,10, 1,16.00),  (6, 7, 2, 3.50),
 (7, 9, 1,12.00),  -- refunded order
 (8, 5, 2, 3.25),  (8,12, 1,18.00),
 (9, 3, 1, 4.50),  (9, 7, 1, 3.50),
 (10,4, 2, 4.25),
 (11,2, 1, 4.75),  (11,8, 1, 3.75),
 (12,1, 1, 3.00),  (12,7, 1, 3.50),
 (13,2, 1, 4.75),  -- void order
 (14,6, 1, 4.50),  (14,10,1,16.00),
 (15,2, 1, 4.75),  (15,7, 1, 3.50);

INSERT INTO inventory (store_id, product_id, on_hand) VALUES
 (1,1,50),(1,2,40),(1,3,35),(1,4,25),(1,5,30),(1,6,20),(1,7,40),(1,8,25),(1,9,15),(1,10,10),(1,11,20),(1,12,15),
 (2,1,45),(2,2,42),(2,3,33),(2,4,28),(2,5,26),(2,6,24),(2,7,38),(2,8,22),(2,9,18),(2,10,12),(2,11,18),(2,12,16),
 (3,1,30),(3,2,28),(3,3,22),(3,4,20),(3,5,18),(3,6,14),(3,7,26),(3,8,16),(3,9,12),(3,10,8),(3,11,10),(3,12,9);

-- Helpful view for revenue (excludes refunded/void in later practice via WHERE)
CREATE OR REPLACE VIEW v_order_revenue AS
SELECT
  o.order_id,
  o.order_datetime,
  o.status,
  o.payment_method,
  o.store_id,
  o.customer_id,
  SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id;
