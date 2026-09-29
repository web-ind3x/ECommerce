-- ============================================================
-- E-Commerce Management System - Sample Data
-- Run this after schema.sql
-- ============================================================
USE ecommerce_db;

-- ------------------------------------------------------------
-- CUSTOMER
-- ------------------------------------------------------------
INSERT INTO CUSTOMER (name, email, password, phone, address) VALUES
('Aditi Sen', 'aditi.sen@example.com', 'hash1', '9800000001', 'Kolkata, WB'),
('Rohan Das', 'rohan.das@example.com', 'hash2', '9800000002', 'Howrah, WB'),
('Priya Sharma', 'priya.sharma@example.com', 'hash3', '9800000003', 'Barasat, WB'),
('Arjun Roy', 'arjun.roy@example.com', 'hash4', '9800000004', 'Durgapur, WB'),
('Megha Paul', 'megha.paul@example.com', 'hash5', '9800000005', 'Siliguri, WB'),
('Karan Mehta', 'karan.mehta@example.com', 'hash6', '9800000006', 'Asansol, WB'),
('Sneha Ghosh', 'sneha.ghosh@example.com', 'hash7', '9800000007', 'Kolkata, WB'),
('Ritwik Das', 'ritwik.das@example.com', 'hash8', '9800000008', 'Kolkata, WB');

-- ------------------------------------------------------------
-- SELLER
-- ------------------------------------------------------------
INSERT INTO SELLER (name, email, password, shop_name, phone) VALUES
('Anil Kumar', 'anil.seller@example.com', 'hashA', 'TechWorld Store', '9700000001'),
('Sunita Rao', 'sunita.seller@example.com', 'hashB', 'HomeEssentials Hub', '9700000002'),
('Deepak Verma', 'deepak.seller@example.com', 'hashC', 'FashionPoint', '9700000003');

-- ------------------------------------------------------------
-- CATEGORY
-- ------------------------------------------------------------
INSERT INTO CATEGORY (category_name, description) VALUES
('Electronics', 'Gadgets, devices, and accessories'),
('Home & Kitchen', 'Household and kitchen items'),
('Clothing', 'Apparel for men and women'),
('Books', 'Fiction, non-fiction, and academic books'),
('Sports', 'Sports gear and fitness equipment');

-- ------------------------------------------------------------
-- PRODUCT
-- ------------------------------------------------------------
INSERT INTO PRODUCT (seller_id, category_id, product_name, description, price, image_url) VALUES
(1, 1, 'Wireless Mouse', 'Ergonomic 2.4GHz wireless mouse', 599.00, NULL),
(1, 1, 'Bluetooth Headphones', 'Over-ear headphones with 20hr battery', 1999.00, NULL),
(1, 1, 'USB-C Charger 65W', 'Fast charging adapter', 899.00, NULL),
(2, 2, 'Non-stick Frying Pan', '28cm non-stick frying pan', 750.00, NULL),
(2, 2, 'Electric Kettle', '1.5L stainless steel kettle', 1100.00, NULL),
(2, 2, 'Dinner Set (24pc)', 'Ceramic dinner set for 6 people', 2400.00, NULL),
(3, 3, 'Cotton T-Shirt', 'Unisex round-neck cotton t-shirt', 449.00, NULL),
(3, 3, 'Denim Jacket', 'Men\'s slim-fit denim jacket', 1899.00, NULL),
(3, 4, 'Introduction to Algorithms', 'CLRS textbook', 1250.00, NULL),
(3, 4, 'Clean Code', 'Robert C. Martin', 899.00, NULL),
(1, 5, 'Yoga Mat', 'Anti-slip 6mm yoga mat', 699.00, NULL),
(1, 5, 'Football', 'Size 5 match football', 999.00, NULL);

-- ------------------------------------------------------------
-- INVENTORY  (one row per product)
-- ------------------------------------------------------------
INSERT INTO INVENTORY (product_id, quantity) VALUES
(1, 50), (2, 30), (3, 40), (4, 25), (5, 20),
(6, 15), (7, 60), (8, 35), (9, 18), (10, 22),
(11, 45), (12, 28);

-- ------------------------------------------------------------
-- CART  (one per customer, first 5 customers have carts)
-- ------------------------------------------------------------
INSERT INTO CART (customer_id) VALUES
(1), (2), (3), (4), (5);

-- ------------------------------------------------------------
-- CART_ITEM
-- ------------------------------------------------------------
INSERT INTO CART_ITEM (cart_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 7, 1),
(2, 4, 1),
(3, 9, 1),
(4, 2, 1),
(5, 11, 1),
(5, 12, 2);

-- ------------------------------------------------------------
-- CUSTOMER_ORDER
-- ------------------------------------------------------------
INSERT INTO CUSTOMER_ORDER (customer_id, total_amount, order_status) VALUES
(1, 2598.00, 'DELIVERED'),
(2, 750.00, 'SHIPPED'),
(3, 1250.00, 'CONFIRMED'),
(4, 1999.00, 'PENDING'),
(6, 899.00, 'DELIVERED'),
(7, 449.00, 'DELIVERED'),
(8, 2400.00, 'CANCELLED'),
(1, 999.00, 'CONFIRMED');

-- ------------------------------------------------------------
-- ORDER_ITEM
-- ------------------------------------------------------------
INSERT INTO ORDER_ITEM (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 2, 599.00),
(1, 7, 1, 449.00),
(2, 4, 1, 750.00),
(3, 9, 1, 1250.00),
(4, 2, 1, 1999.00),
(5, 10, 1, 899.00),
(6, 7, 1, 449.00),
(7, 6, 1, 2400.00),
(8, 12, 1, 999.00);

-- ------------------------------------------------------------
-- PAYMENT
-- ------------------------------------------------------------
INSERT INTO PAYMENT (order_id, payment_method, payment_status, amount) VALUES
(1, 'CARD', 'SUCCESS', 2598.00),
(2, 'UPI', 'SUCCESS', 750.00),
(3, 'UPI', 'SUCCESS', 1250.00),
(4, 'COD', 'PENDING', 1999.00),
(5, 'CARD', 'SUCCESS', 899.00),
(6, 'UPI', 'SUCCESS', 449.00),
(7, 'CARD', 'REFUNDED', 2400.00),
(8, 'NETBANKING', 'SUCCESS', 999.00);

-- ------------------------------------------------------------
-- DELIVERY
-- ------------------------------------------------------------
INSERT INTO DELIVERY (order_id, delivery_address, delivery_status, delivery_date, courier_name) VALUES
(1, 'Kolkata, WB', 'DELIVERED', '2026-09-10', 'BlueDart'),
(2, 'Howrah, WB', 'IN_TRANSIT', NULL, 'Delhivery'),
(3, 'Barasat, WB', 'DISPATCHED', NULL, 'DTDC'),
(4, 'Durgapur, WB', 'PROCESSING', NULL, NULL),
(5, 'Asansol, WB', 'DELIVERED', '2026-09-12', 'BlueDart'),
(6, 'Kolkata, WB', 'DELIVERED', '2026-09-14', 'Delhivery'),
(7, 'Kolkata, WB', 'PROCESSING', NULL, NULL),
(8, 'Kolkata, WB', 'DISPATCHED', NULL, 'DTDC');

-- ------------------------------------------------------------
-- REVIEW
-- ------------------------------------------------------------
INSERT INTO REVIEW (customer_id, product_id, rating, comment) VALUES
(1, 1, 5, 'Great mouse, very responsive.'),
(1, 7, 4, 'Good quality fabric.'),
(2, 4, 4, 'Works well, easy to clean.'),
(3, 9, 5, 'Classic textbook, well printed.'),
(6, 7, 3, 'Decent, sizing runs small.'),
(7, 6, 5, 'Beautiful dinner set.'),
(1, 12, 4, 'Good bounce and grip.');