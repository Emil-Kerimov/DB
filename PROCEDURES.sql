-- 1. sp_help - отримання інформації про об'єкт
EXEC sp_help 'Wallpaper';

-- 2. sp_spaceused - перевірка використання простору
EXEC sp_spaceused 'Customer';

-- 3. sp_rename - перейменування стовпця
EXEC sp_rename 'Wallpaper.Name', 'ProductName', 'COLUMN';

-- 1. Процедура для аналізу замовлень
CREATE PROCEDURE ##GetOrderSummary
AS
BEGIN
    SELECT 
        c.Email, 
        COUNT(o.Order_ID) AS OrderCount,
        SUM(o.Quantity) AS TotalItems
    FROM 
        Customer c
    JOIN 
        Orders o ON c.Customer_ID = o.Customer_ID
    GROUP BY 
        c.Email;
END;

EXEC ##GetOrderSummary;