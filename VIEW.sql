-- Завдання 3. Просте представлення (для IndividualCustomer)
CREATE VIEW vIndividualCustomerNames AS
SELECT 
    ic.Customer_ID,
    ic.Name AS FirstName,
    ic.Surname AS LastName
FROM 
    IndividualCustomer ic;
GO

SELECT * FROM vIndividualCustomerNames;
-- Завдання 4. Використання представлення
SELECT FirstName, LastName FROM vIndividualCustomerNames;
GO

-- Завдання 5. Представлення з фільтром (Legal Customer)
CREATE VIEW vLegalCustomers AS
SELECT 
    c.Customer_ID,
    lc.Business_Address
FROM 
    Customer c
JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
WHERE 
    c.Type = 'Legal';
GO
SELECT * FROM vLegalCustomers;
-- Завдання 6. Оновлення через представлення
UPDATE vLegalCustomers
SET Business_Address = 'Updated Address, Kyiv'
WHERE Customer_ID = 51; -- Приклад ID юридичного клієнта
GO

-- Завдання 7. Представлення з JOIN (Customer + Orders)
CREATE VIEW vCustomerOrders AS
SELECT 
    c.Customer_ID,
    CASE 
        WHEN ic.Customer_ID IS NOT NULL THEN ic.Name + ' ' + ic.Surname
        ELSE lc.Business_Address
    END AS CustomerInfo,
    o.Order_ID,
    o.OrderDate,
    o.Quantity
FROM 
    Customer c
LEFT JOIN 
    IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
LEFT JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
JOIN 
    Orders o ON c.Customer_ID = o.Customer_ID;
GO
SELECT * FROM vCustomerOrders;
-- Завдання 8. Представлення з агрегацією
CREATE VIEW vCustomerOrderStats AS
SELECT 
    c.Customer_ID,
    CASE 
        WHEN ic.Customer_ID IS NOT NULL THEN ic.Name + ' ' + ic.Surname
        ELSE lc.Business_Address
    END AS CustomerInfo,
    COUNT(o.Order_ID) AS OrderCount,
    SUM(o.Quantity) AS TotalItems
FROM 
    Customer c
LEFT JOIN 
    IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
LEFT JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
LEFT JOIN 
    Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY 
    c.Customer_ID,ic.Customer_ID, ic.Name, ic.Surname, lc.Business_Address;
GO

-- Завдання 10. VIP Customers (з 5+ замовленнями)
CREATE VIEW vVIPCustomers AS
SELECT *
FROM vCustomerOrderStats
WHERE OrderCount >= 5;
GO

-- Завдання 11. ALTER VIEW (додаємо Email)
ALTER VIEW vCustomerOrders AS
SELECT 
    c.Customer_ID,
    c.Email,
    CASE 
        WHEN ic.Customer_ID IS NOT NULL THEN ic.Name + ' ' + ic.Surname
        ELSE lc.Business_Address
    END AS CustomerInfo,
    o.Order_ID,
    o.OrderDate,
    o.Quantity
FROM 
    Customer c
LEFT JOIN 
    IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
LEFT JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
JOIN 
    Orders o ON c.Customer_ID = o.Customer_ID;
GO
SELECT * FROM vCustomerOrders;
-- Завдання 12. Видалення представлення
DROP VIEW IF EXISTS vVIPCustomers;
GO

-- Завдання 13. Представлення з псевдонімами
CREATE VIEW vOrderSummary AS
SELECT 
    Order_ID AS OrderID,
    OrderDate AS OrderDateTime,
    Quantity AS ItemCount
FROM 
    Orders;
GO
SELECT * FROM vOrderSummary;
-- Завдання 14. Представлення з обчислюваним стовпцем
CREATE VIEW vWallpaperWithTax AS
SELECT 
    Wallpaper_ID,
    ProductName,
    Price,
    Price * 1.2 AS PriceWithVAT
FROM 
    Wallpaper;
GO
SELECT * FROM vWallpaperWithTax;
-- Завдання 15. WITH CHECK OPTION (дорогі шпалери)
CREATE VIEW vPremiumWallpapers AS
SELECT *
FROM Wallpaper
WHERE Price > 50
WITH CHECK OPTION;
GO

-- Спроба вставити дешеві шпалери через представлення (викличе помилку)
 INSERT INTO vPremiumWallpapers (ProductName, Price, Stock) VALUES ('Cheap Wallpaper', 30, 100);
GO

-- Завдання 16. Шифроване представлення
CREATE VIEW vEncryptedCustomerInfo
WITH ENCRYPTION
AS
SELECT 
    c.Customer_ID,
    c.Email,
    c.Type
FROM 
    Customer c;
GO
-- Завдання 17. Представлення для управління доступом
CREATE VIEW vRestrictedOrders AS
SELECT 
    Order_ID,
    OrderDate
FROM 
    Orders;
GO

-- Надання прав (припускаємо, що користувач ReadOnlyUser існує)
 GRANT SELECT ON vRestrictedOrders TO ReadOnlyUser;
GO