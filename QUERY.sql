-- Вибірка всіх шпалер
SELECT * FROM Wallpaper;

-- Вибірка всіх клієнтів
SELECT * FROM Customer;

-- Вибірка всіх замовлень із датою та кількістю
SELECT Order_ID, OrderDate, Quantity FROM Orders;

-- Пошук шпалер із ціною більше 15
SELECT Name, Price FROM Wallpaper
WHERE Price > 15;

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
