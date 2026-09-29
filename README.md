# E-Commerce Management System

**Course:** BTY39105 - Database Management System Lab
**Group Number:** [FILL IN YOUR GROUP NUMBER]
**Team Members:**
- [FILL IN NAME 1]
- [FILL IN NAME 2]
- [FILL IN NAME 3]
- [FILL IN NAME 4]
- [FILL IN NAME 5]

## Problem Statement

Develop a database-driven E-Commerce Management System for managing customers, sellers, products, categories, shopping carts, orders, payments, delivery, inventory, and product reviews. The system supports the complete online purchasing process while maintaining accurate transaction and stock information.

## Objectives

- Design a normalized relational schema for an e-commerce platform
- Implement CRUD operations through a web interface
- Enforce data integrity using triggers and transactions
- Provide reporting and analytics through views, stored procedures, and functions
- Deploy a fully functional, database-driven web application

## Technology Stack

- **Database:** MySQL
- **Backend:** Python (Flask)
- **Frontend:** HTML, CSS, Jinja2 templates
- **Version Control:** Git + GitHub

## Major Features

- Customer login/logout
- Product catalogue with search, category filter, and price/name sorting
- Shopping cart (add/remove items)
- Checkout with atomic order placement (transaction-safe)
- Automatic stock validation and reduction via triggers
- Order history ("My Orders")
- Admin dashboard with live reports: top-selling products, low-stock alerts, revenue by category, recent orders, top customers by spend

## Database Design

- 12 related tables: CUSTOMER, SELLER, CATEGORY, PRODUCT, INVENTORY, CART, CART_ITEM, CUSTOMER_ORDER, ORDER_ITEM, PAYMENT, DELIVERY, REVIEW
- 2 triggers enforcing stock validation and automatic stock reduction
- 2 views: `vw_product_sales`, `vw_low_stock`
- 1 stored procedure: `sp_top_selling_products`
- 1 function: `fn_customer_total_spent`

ER Diagram: see `docs/ER_Diagram`
Data Dictionary: see `docs/Data_Dictionary`
Normalization notes: see `docs/Normalization`

## Installation / Database Setup

1. Install MySQL and Python 3.
2. Create the database:
```
CREATE DATABASE ecommerce_db;
```
3. Load the schema and data, in this order:
```
mysql -u root -p ecommerce_db < database/schema.sql
mysql -u root -p ecommerce_db < database/insert_data.sql
mysql -u root -p ecommerce_db < database/triggers.sql
mysql -u root -p ecommerce_db < database/views.sql
```
4. Install Python dependencies:
```
pip install flask mysql-connector-python
```
5. Update the database password in `src/backend/db.py` to match your MySQL setup.

## How to Run

```
cd src/backend
python app.py
```
Open `http://127.0.0.1:5000` in your browser.

## Demo Credentials

**Customer login:**
Email: `aditi.sen@example.com`
Password: `hash1`

**Admin dashboard:** log in as the customer above, then visit `/admin`

## Live Deployed Website URL

[FILL IN AFTER DEPLOYMENT]

## Screenshots

See `screenshots/` folder.

## Individual Contribution Summary

[FILL IN - one line per team member describing their primary contribution]
