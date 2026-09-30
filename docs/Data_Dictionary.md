# Data Dictionary — E-Commerce Management System

## CUSTOMER
| Column | Type | Constraints | Description |
|---|---|---|---|
| customer_id | INT | PK, AUTO_INCREMENT | Unique identifier for a customer |
| name | VARCHAR(100) | NOT NULL | Customer's full name |
| email | VARCHAR(100) | NOT NULL, UNIQUE | Login email |
| password | VARCHAR(255) | NOT NULL | Hashed password |
| phone | VARCHAR(15) | | Contact number |
| address | VARCHAR(255) | | Default shipping address |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation time |

## SELLER
| Column | Type | Constraints | Description |
|---|---|---|---|
| seller_id | INT | PK, AUTO_INCREMENT | Unique identifier for a seller |
| name | VARCHAR(100) | NOT NULL | Seller's name |
| email | VARCHAR(100) | NOT NULL, UNIQUE | Login email |
| password | VARCHAR(255) | NOT NULL | Hashed password |
| shop_name | VARCHAR(100) | NOT NULL | Display name of the seller's shop |
| phone | VARCHAR(15) | | Contact number |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation time |

## CATEGORY
| Column | Type | Constraints | Description |
|---|---|---|---|
| category_id | INT | PK, AUTO_INCREMENT | Unique identifier for a category |
| category_name | VARCHAR(100) | NOT NULL, UNIQUE | Name of the category |
| description | VARCHAR(255) | | Short description |

## PRODUCT
| Column | Type | Constraints | Description |
|---|---|---|---|
| product_id | INT | PK, AUTO_INCREMENT | Unique identifier for a product |
| seller_id | INT | FK → SELLER, NOT NULL | Seller who lists this product |
| category_id | INT | FK → CATEGORY, NOT NULL | Category this product belongs to |
| product_name | VARCHAR(150) | NOT NULL | Product title |
| description | VARCHAR(500) | | Product details |
| price | DECIMAL(10,2) | NOT NULL, CHECK ≥ 0 | Current selling price |
| image_url | VARCHAR(255) | | Product image |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Listing creation time |

## INVENTORY
| Column | Type | Constraints | Description |
|---|---|---|---|
| inventory_id | INT | PK, AUTO_INCREMENT | Unique identifier for a stock record |
| product_id | INT | FK → PRODUCT, NOT NULL, UNIQUE | The product being tracked |
| quantity | INT | NOT NULL, CHECK ≥ 0 | Units currently in stock |
| last_updated | TIMESTAMP | AUTO ON UPDATE | Last stock change time |

## CART
| Column | Type | Constraints | Description |
|---|---|---|---|
| cart_id | INT | PK, AUTO_INCREMENT | Unique identifier for a cart |
| customer_id | INT | FK → CUSTOMER, NOT NULL, UNIQUE | Owner of this cart |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Cart creation time |

## CART_ITEM
| Column | Type | Constraints | Description |
|---|---|---|---|
| cart_item_id | INT | PK, AUTO_INCREMENT | Unique identifier for a cart line item |
| cart_id | INT | FK → CART, NOT NULL | Cart this item belongs to |
| product_id | INT | FK → PRODUCT, NOT NULL | Product added to the cart |
| quantity | INT | NOT NULL, CHECK > 0 | Quantity requested |
| added_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When the item was added |

Unique constraint: (cart_id, product_id) — one row per product per cart.

## CUSTOMER_ORDER
| Column | Type | Constraints | Description |
|---|---|---|---|
| order_id | INT | PK, AUTO_INCREMENT | Unique identifier for an order |
| customer_id | INT | FK → CUSTOMER, NOT NULL | Customer who placed the order |
| order_date | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When the order was placed |
| total_amount | DECIMAL(10,2) | NOT NULL | Total order value |
| order_status | ENUM | DEFAULT 'PENDING' | PENDING / CONFIRMED / SHIPPED / DELIVERED / CANCELLED |

## ORDER_ITEM
| Column | Type | Constraints | Description |
|---|---|---|---|
| order_item_id | INT | PK, AUTO_INCREMENT | Unique identifier for an order line item |
| order_id | INT | FK → CUSTOMER_ORDER, NOT NULL | Order this item belongs to |
| product_id | INT | FK → PRODUCT, NOT NULL | Product ordered |
| quantity | INT | NOT NULL, CHECK > 0 | Units ordered |
| price_at_purchase | DECIMAL(10,2) | NOT NULL | Price of the product at the moment of purchase |

## PAYMENT
| Column | Type | Constraints | Description |
|---|---|---|---|
| payment_id | INT | PK, AUTO_INCREMENT | Unique identifier for a payment |
| order_id | INT | FK → CUSTOMER_ORDER, NOT NULL, UNIQUE | Order this payment settles |
| payment_method | ENUM | NOT NULL | CARD / UPI / NETBANKING / COD |
| payment_status | ENUM | DEFAULT 'PENDING' | PENDING / SUCCESS / FAILED / REFUNDED |
| payment_date | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Time of payment |
| amount | DECIMAL(10,2) | NOT NULL | Amount paid |

## DELIVERY
| Column | Type | Constraints | Description |
|---|---|---|---|
| delivery_id | INT | PK, AUTO_INCREMENT | Unique identifier for a delivery |
| order_id | INT | FK → CUSTOMER_ORDER, NOT NULL, UNIQUE | Order being delivered |
| delivery_address | VARCHAR(255) | NOT NULL | Shipping destination |
| delivery_status | ENUM | DEFAULT 'PROCESSING' | PROCESSING / DISPATCHED / IN_TRANSIT / DELIVERED |
| delivery_date | DATE | | Date delivered |
| courier_name | VARCHAR(100) | | Courier handling the delivery |

## REVIEW
| Column | Type | Constraints | Description |
|---|---|---|---|
| review_id | INT | PK, AUTO_INCREMENT | Unique identifier for a review |
| customer_id | INT | FK → CUSTOMER, NOT NULL | Reviewer |
| product_id | INT | FK → PRODUCT, NOT NULL | Product being reviewed |
| rating | INT | NOT NULL, CHECK BETWEEN 1 AND 5 | Star rating |
| comment | VARCHAR(500) | | Review text |
| review_date | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When the review was posted |

Unique constraint: (customer_id, product_id) — one review per customer per product.
