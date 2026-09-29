-- ============================================================
-- E-Commerce Management System - Database Schema
-- BTY39105 - Database Management System Lab
-- ============================================================
-- Run this after: USE ecommerce_db;

-- ------------------------------------------------------------
-- 1. CUSTOMER
-- ------------------------------------------------------------
CREATE TABLE CUSTOMER (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    phone       VARCHAR(15),
    address     VARCHAR(255),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- 2. SELLER
-- ------------------------------------------------------------
CREATE TABLE SELLER (
    seller_id   INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    shop_name   VARCHAR(100) NOT NULL,
    phone       VARCHAR(15),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- 3. CATEGORY
-- ------------------------------------------------------------
CREATE TABLE CATEGORY (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description   VARCHAR(255)
);

-- ------------------------------------------------------------
-- 4. PRODUCT
-- ------------------------------------------------------------
CREATE TABLE PRODUCT (
    product_id   INT AUTO_INCREMENT PRIMARY KEY,
    seller_id    INT NOT NULL,
    category_id  INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    description  VARCHAR(500),
    price        DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    image_url    VARCHAR(255),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES SELLER(seller_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id) ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- 5. INVENTORY  (1-to-1 with PRODUCT)
-- ------------------------------------------------------------
CREATE TABLE INVENTORY (
    inventory_id  INT AUTO_INCREMENT PRIMARY KEY,
    product_id    INT NOT NULL UNIQUE,
    quantity      INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    last_updated  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 6. CART  (1-to-1 with CUSTOMER)
-- ------------------------------------------------------------
CREATE TABLE CART (
    cart_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 7. CART_ITEM
-- ------------------------------------------------------------
CREATE TABLE CART_ITEM (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id      INT NOT NULL,
    product_id   INT NOT NULL,
    quantity     INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    added_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES CART(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE,
    UNIQUE (cart_id, product_id)  -- one row per product per cart
);

-- ------------------------------------------------------------
-- 8. CUSTOMER_ORDER
-- ------------------------------------------------------------
CREATE TABLE CUSTOMER_ORDER (
    order_id      INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT NOT NULL,
    order_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount  DECIMAL(10,2) NOT NULL DEFAULT 0,
    order_status  ENUM('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 9. ORDER_ITEM
-- ------------------------------------------------------------
CREATE TABLE ORDER_ITEM (
    order_item_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id          INT NOT NULL,
    product_id        INT NOT NULL,
    quantity          INT NOT NULL CHECK (quantity > 0),
    price_at_purchase DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES CUSTOMER_ORDER(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- 10. PAYMENT  (1-to-1 with ORDER)
-- ------------------------------------------------------------
CREATE TABLE PAYMENT (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT NOT NULL UNIQUE,
    payment_method ENUM('CARD','UPI','NETBANKING','COD') NOT NULL,
    payment_status ENUM('PENDING','SUCCESS','FAILED','REFUNDED') DEFAULT 'PENDING',
    payment_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount         DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES CUSTOMER_ORDER(order_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 11. DELIVERY  (1-to-1 with ORDER)
-- ------------------------------------------------------------
CREATE TABLE DELIVERY (
    delivery_id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id          INT NOT NULL UNIQUE,
    delivery_address  VARCHAR(255) NOT NULL,
    delivery_status   ENUM('PROCESSING','DISPATCHED','IN_TRANSIT','DELIVERED') DEFAULT 'PROCESSING',
    delivery_date     DATE,
    courier_name      VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES CUSTOMER_ORDER(order_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 12. REVIEW
-- ------------------------------------------------------------
CREATE TABLE REVIEW (
    review_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id  INT NOT NULL,
    rating      INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment     VARCHAR(500),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE,
    UNIQUE (customer_id, product_id)  -- one review per customer per product
);

-- ------------------------------------------------------------
-- Indexes (in addition to the automatic ones on PK/UNIQUE/FK)
-- ------------------------------------------------------------
CREATE INDEX idx_product_category ON PRODUCT(category_id);
CREATE INDEX idx_order_customer   ON CUSTOMER_ORDER(customer_id);
