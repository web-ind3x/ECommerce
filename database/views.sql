CREATE VIEW vw_product_sales AS
SELECT p.product_id, p.product_name, c.category_name,
       COALESCE(SUM(oi.quantity), 0) AS total_sold,
       COALESCE(SUM(oi.quantity * oi.price_at_purchase), 0) AS total_revenue
FROM PRODUCT p
JOIN CATEGORY c ON p.category_id = c.category_id
LEFT JOIN ORDER_ITEM oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, c.category_name;

CREATE VIEW vw_low_stock AS
SELECT p.product_id, p.product_name, i.quantity
FROM PRODUCT p
JOIN INVENTORY i ON p.product_id = i.product_id
WHERE i.quantity < 20;

DELIMITER $$

CREATE PROCEDURE sp_top_selling_products(IN limit_count INT)
BEGIN
    SELECT product_id, product_name, category_name, total_sold, total_revenue
    FROM vw_product_sales
    ORDER BY total_sold DESC
    LIMIT limit_count;
END$$

CREATE FUNCTION fn_customer_total_spent(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT COALESCE(SUM(total_amount), 0) INTO total
    FROM CUSTOMER_ORDER
    WHERE customer_id = cust_id AND order_status != 'CANCELLED';
    RETURN total;
END$$

DELIMITER ;
