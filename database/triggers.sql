DELIMITER $$

CREATE TRIGGER trg_check_stock_before_order
BEFORE INSERT ON ORDER_ITEM
FOR EACH ROW
BEGIN
    DECLARE available INT;
    SELECT quantity INTO available FROM INVENTORY WHERE product_id = NEW.product_id;
    IF available < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock for this product';
    END IF;
END$$

CREATE TRIGGER trg_reduce_stock_after_order
AFTER INSERT ON ORDER_ITEM
FOR EACH ROW
BEGIN
    UPDATE INVENTORY SET quantity = quantity - NEW.quantity WHERE product_id = NEW.product_id;
END$$

DELIMITER ;