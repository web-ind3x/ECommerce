# Normalization — E-Commerce Management System

Every table in this schema uses a single-column surrogate primary key (an `AUTO_INCREMENT` integer). This means 2NF is automatically satisfied everywhere, since partial dependency can only occur against a composite key. The analysis below focuses on functional dependencies and 3NF.

## CUSTOMER
FD: `customer_id → name, email, password, phone, address, created_at`
All attributes depend only on the key. No transitive dependency. **1NF, 2NF, 3NF satisfied.**

## SELLER
FD: `seller_id → name, email, password, shop_name, phone, created_at`
**1NF, 2NF, 3NF satisfied.**

## CATEGORY
FD: `category_id → category_name, description`
**1NF, 2NF, 3NF satisfied.**

## PRODUCT
FD: `product_id → seller_id, category_id, product_name, description, price, image_url, created_at`
`category_name` is deliberately **not** stored here — it lives only in CATEGORY and is reached through `category_id`. Storing it here would create a transitive dependency (`product_id → category_id → category_name`) and a 3NF violation. **1NF, 2NF, 3NF satisfied.**

## INVENTORY
FD: `inventory_id → product_id, quantity, last_updated`
`product_id` is UNIQUE, enforcing the one-to-one relationship with PRODUCT. **1NF, 2NF, 3NF satisfied.**

## CART
FD: `cart_id → customer_id, created_at`
**1NF, 2NF, 3NF satisfied.**

## CART_ITEM
FD: `cart_item_id → cart_id, product_id, quantity, added_at`
The UNIQUE constraint on `(cart_id, product_id)` prevents duplicate line items for the same product in the same cart; it is a candidate key constraint, not the primary key. **1NF, 2NF, 3NF satisfied.**

## CUSTOMER_ORDER
FD: `order_id → customer_id, order_date, total_amount, order_status`
`total_amount` is a **derived/summary value** (the sum of related ORDER_ITEM rows), stored here intentionally for fast reads on order-history and dashboard pages rather than recalculating it on every request. This is a deliberate, documented denormalization for performance, not an oversight. **1NF, 2NF, 3NF satisfied with respect to non-derived attributes.**

## ORDER_ITEM
FD: `order_item_id → order_id, product_id, quantity, price_at_purchase`
`price_at_purchase` intentionally duplicates the product's price at the time of the order. This is **not** a normalization violation — it represents a different fact (historical price at purchase) from `PRODUCT.price` (current price), and both must be able to differ over time. **1NF, 2NF, 3NF satisfied.**

## PAYMENT
FD: `payment_id → order_id, payment_method, payment_status, payment_date, amount`
`order_id` is UNIQUE, enforcing one payment per order. **1NF, 2NF, 3NF satisfied.**

## DELIVERY
FD: `delivery_id → order_id, delivery_address, delivery_status, delivery_date, courier_name`
`order_id` is UNIQUE, enforcing one delivery record per order. **1NF, 2NF, 3NF satisfied.**

## REVIEW
FD: `review_id → customer_id, product_id, rating, comment, review_date`
The UNIQUE constraint on `(customer_id, product_id)` enforces one review per customer per product. **1NF, 2NF, 3NF satisfied.**

## Summary

All 12 tables are in Third Normal Form (3NF). Every non-key attribute depends on the whole primary key and nothing but the primary key. The two places that look like redundancy (`CUSTOMER_ORDER.total_amount` and `ORDER_ITEM.price_at_purchase`) are intentional, commonly accepted denormalizations that preserve historical accuracy and read performance — not violations of normalization rules.
