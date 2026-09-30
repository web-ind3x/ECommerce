# Testing Report — E-Commerce Management System

## Already Verified (during development)

| Test ID | Test Case | Steps | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|
| T01 | Valid login | Log in with aditi.sen@example.com / hash1 | Redirected to shop page, session created | Redirected successfully, "Welcome, Aditi Sen" shown | Pass |
| T02 | Add to cart | Click "Add to cart" on a product | Item appears in CART_ITEM, visible on /cart | Product appeared correctly with subtotal | Pass |
| T03 | Checkout transaction | Add items, click Checkout | Order, order items, payment, delivery all created; cart cleared | Order #9-12 confirmed, all 4 related tables populated correctly | Pass |
| T04 | Trigger: stock reduction | Check INVENTORY before and after checkout | Quantity reduced by ordered amount, only after order confirmed | Product 9: 18 -> 17, Product 10: 22 -> 21, confirmed via SELECT | Pass |
| T05 | Search | Search "book" in product search box | Only matching products shown | Filtered correctly | Pass |
| T06 | Category filter | Select a category from dropdown | Only that category's products shown | Filtered correctly | Pass |
| T07 | Sort by price | Select "Price: low to high" | Products reordered ascending by price | Sorted correctly | Pass |
| T08 | Order history | Visit /my_orders while logged in | All past orders for that customer shown with line items | All orders and items displayed correctly | Pass |
| T09 | Admin dashboard reports | Visit /admin as customer_id 1 | 5 live reports shown (top products, low stock, category revenue, recent orders, top customers) | All 5 sections populated with real data | Pass |

## To Be Executed — run these yourself and fill in "Actual Result"

| Test ID | Test Case | Steps | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|
| T10 | Invalid login | Go to /login, enter a wrong password for a real email | "Invalid email or password" message shown, no session created | | |
| T11 | Non-existent email | Go to /login, enter an email that doesn't exist in CUSTOMER | Same error message, no crash | | |
| T12 | Empty form submission | On /login, click submit with both fields blank | Browser blocks submission (HTML5 "required" validation) | | |
| T13 | Duplicate category name | In MySQL: `INSERT INTO CATEGORY (category_name) VALUES ('Electronics');` | Query fails with a UNIQUE constraint error | | |
| T14 | Duplicate customer email | In MySQL: `INSERT INTO CUSTOMER (name, email, password) VALUES ('Test','aditi.sen@example.com','x');` | Query fails with a UNIQUE constraint error | | |
| T15 | Foreign key violation | In MySQL: `INSERT INTO PRODUCT (seller_id, category_id, product_name, price) VALUES (999, 1, 'Fake', 10);` | Query fails — seller_id 999 doesn't exist | | |
| T16 | Trigger blocks over-order | Add a product to cart with quantity greater than its current stock (edit CART_ITEM directly in MySQL to a huge quantity), then checkout | Checkout fails, error message shown on cart page, no order created, stock unchanged | | |
| T17 | Transaction rollback | Force T16's scenario and confirm in MySQL that no row was added to CUSTOMER_ORDER for that attempt | No partial order exists after a failed checkout | | |
| T18 | Remove from cart | Add 2 items, remove 1, check /cart | Only the remaining item shown, total recalculated | | |
| T19 | Logout clears session | Log in, click Logout, try visiting /cart directly | Redirected to /login (session cleared) | | |
| T20 | CRUD - review uniqueness | In MySQL, insert two reviews for the same (customer_id, product_id) pair | Second insert fails — UNIQUE constraint on (customer_id, product_id) | | |

## How to Run the MySQL-Based Tests (T13-T15, T20)

Open MySQL and run:
```sql
USE ecommerce_db;
```
Then paste each test's query one at a time and record whether it succeeds or throws an error, along with the exact error message MySQL gives you.

## Summary

- Total test cases: 20
- Automatically verified during development: 9
- Manual tests to execute and record: 11

Fill in the Actual Result and Status (Pass/Fail) columns above after running each test, then include this file in your final submission as evidence of Phase XI (Testing).
