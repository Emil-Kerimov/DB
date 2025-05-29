-- Видалення даних з таблиць
DELETE FROM WallpaperOrders;
DELETE FROM Orders;
DELETE FROM IndividualCustomer;
DELETE FROM LegalCustomer;
DELETE FROM Customer;
DELETE FROM Wallpaper;
-- Видалення таблиць
DROP TABLE WallpaperOrders;
DROP TABLE Orders;
DROP TABLE IndividualCustomer;
DROP TABLE LegalCustomer;
DROP TABLE Customer;
DROP TABLE Wallpaper;

-- Відключаємо індекси перед видаленням
ALTER INDEX ALL ON Wallpaper DISABLE;

-- Виконуємо видалення
DELETE FROM Wallpaper;

-- Включаємо індекси назад
ALTER INDEX ALL ON Wallpaper REBUILD;