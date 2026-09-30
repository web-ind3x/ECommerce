# ER Diagram — E-Commerce Management System

This diagram is written in Mermaid syntax. It renders automatically when viewed on GitHub.

```mermaid
erDiagram
    CUSTOMER ||--o| CART : owns
    CUSTOMER ||--o{ CUSTOMER_ORDER : places
    CUSTOMER ||--o{ REVIEW : writes
    SELLER ||--o{ PRODUCT : lists
    CATEGORY ||--o{ PRODUCT : classifies
    PRODUCT ||--|| INVENTORY : "tracked by"
    PRODUCT ||--o{ CART_ITEM : "appears in"
    PRODUCT ||--o{ ORDER_ITEM : "appears in"
    PRODUCT ||--o{ REVIEW : receives
    CART ||--o{ CART_ITEM : contains
    CUSTOMER_ORDER ||--o{ ORDER_ITEM : contains
    CUSTOMER_ORDER ||--|| PAYMENT : "settled by"
    CUSTOMER_ORDER ||--|| DELIVERY : "shipped via"

    CUSTOMER {
        int customer_id PK
        string name
        string email UK
        string password
        string phone
        string address
    }

    SELLER {
        int seller_id PK
        string name
        string email UK
        string password
        string shop_name
        string phone
    }

    CATEGORY {
        int category_id PK
        string category_name UK
        string description
    }

    PRODUCT {
        int product_id PK
        int seller_id FK
        int category_id FK
        string product_name
        string description
        decimal price
        string image_url
    }

    INVENTORY {
        int inventory_id PK
        int product_id FK "UK"
        int quantity
    }

    CART {
        int cart_id PK
        int customer_id FK "UK"
    }

    CART_ITEM {
        int cart_item_id PK
        int cart_id FK
        int product_id FK
        int quantity
    }

    CUSTOMER_ORDER {
        int order_id PK
        int customer_id FK
        datetime order_date
        decimal total_amount
        string order_status
    }

    ORDER_ITEM {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal price_at_purchase
    }

    PAYMENT {
        int payment_id PK
        int order_id FK "UK"
        string payment_method
        string payment_status
        decimal amount
    }

    DELIVERY {
        int delivery_id PK
        int order_id FK "UK"
        string delivery_address
        string delivery_status
        date delivery_date
    }

    REVIEW {
        int review_id PK
        int customer_id FK
        int product_id FK
        int rating
        string comment
    }
```

## Cardinality Notes

- **CUSTOMER to CART**: one-to-one — each customer has exactly one active cart.
- **CUSTOMER to CUSTOMER_ORDER**: one-to-many — a customer can place many orders.
- **SELLER to PRODUCT**: one-to-many — a seller can list many products.
- **CATEGORY to PRODUCT**: one-to-many — a category groups many products.
- **PRODUCT to INVENTORY**: one-to-one — each product has exactly one stock record.
- **CART to CART_ITEM**: one-to-many — a cart holds many line items.
- **CUSTOMER_ORDER to ORDER_ITEM**: one-to-many — an order holds many line items.
- **CUSTOMER_ORDER to PAYMENT**: one-to-one — each order has exactly one payment record.
- **CUSTOMER_ORDER to DELIVERY**: one-to-one — each order has exactly one delivery record.
- **CUSTOMER/PRODUCT to REVIEW**: many-to-many, resolved through REVIEW as an associative entity (one review per customer per product, enforced by a UNIQUE constraint).
