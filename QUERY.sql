-- Вибірка всіх шпалер
SELECT * FROM Wallpaper;

-- Вибірка всіх клієнтів
SELECT * FROM Customer;

-- Вибірка всіх  Orders
SELECT * FROM Orders;

-- Вибірка всіх клієнтів
SELECT * FROM WallpaperOrders;

-- Вибірка всіх замовлень із датою та кількістю
SELECT Order_ID, OrderDate, Quantity FROM Orders;

-- Пошук шпалер із ціною більше 15
SELECT Name, Price FROM Wallpaper
WHERE Price > 15;

-- Пошук шпалер із ціною більше 15 і яких менше 10 у наявності
SELECT Name, Price FROM Wallpaper
WHERE Price > 15 AND Stock < 10;


-- Пошук шпалер типу Floral
SELECT Name, Price FROM Wallpaper
WHERE Name LIKE '%Floral%';

-- Показати всі замовлення з Email клієнтів
SELECT o.Order_ID, c.Email, o.OrderDate
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

-- Показати всі шпалери, навіть якщо їх ніхто не замовляв
SELECT w.Name, wo.Order_ID
FROM Wallpaper w
LEFT JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID;

-- Пошук шпалер із ціною більше AVG
SELECT Name, Price FROM Wallpaper
WHERE Price > (SELECT AVG(Price) FROM Wallpaper);

SELECT C.Email, COUNT(O.Order_ID) AS TotalOrders
FROM Customer C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
GROUP BY C.Email
HAVING COUNT(O.Order_ID) > 1;

-- Отримання даних про замовлення, клієнтів і шпалери з підрахунком загальної суми кожного замовлення
SELECT O.Order_ID, O.OrderDate, C.Email, SUM(W.Price * WO.Quantity) AS TotalPrice
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
GROUP BY O.Order_ID, O.OrderDate, C.Email
ORDER BY TotalPrice DESC;

--Отримання замовлень клієнтів, зроблених після певної дати
SELECT O.Order_ID, O.OrderDate, C.Email, W.Name AS Wallpaper_Name, WO.Quantity
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
WHERE O.OrderDate > '2023-01-11';


-- Сортування шпалер за ціною за спаданням
SELECT Name, Price FROM Wallpaper
ORDER BY Price DESC;

-- Підрахунок загальної кількості шпалер у магазині
SELECT SUM(Stock) AS Total_Stock FROM Wallpaper;

-- Середня ціна шпалер
SELECT AVG(Price) AS AveragePrice FROM Wallpaper;


-- Вивід клієнтів, у яких замовлень більше за 5 одиниць товару
SELECT C.Email, O.Quantity
FROM Customer C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
WHERE O.Quantity > 5;
