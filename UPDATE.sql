-- Оновлення ціни на шпалери
UPDATE Wallpaper
SET Price = 16.99
WHERE Name = 'Floral Pattern';
-- Оновлення адреси юридичного клієнта
UPDATE LegalCustomer
SET Business_Address = '456 Corporate Rd, Corporate City'
WHERE Customer_ID = 2;
DELETE FROM WallpaperOrders
WHERE Order_ID = 1;

DELETE FROM Orders
WHERE Order_ID = 1;

-- Зменшення залишку товарів у таблиці Wallpaper
UPDATE Wallpaper
SET Stock = Stock - 10
WHERE Wallpaper_ID = 3;