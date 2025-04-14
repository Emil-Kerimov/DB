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

-- Пошук шпалер яких менше 10 у наявності
SELECT Name, Price FROM Wallpaper
WHERE Stock < 10;

SELECT Order_ID, Quantity FROM ORDERS
Where Quantity > 2;

--  Вибір замовлень за останній місяць
SELECT Order_ID, OrderDate, Quantity
FROM Orders
WHERE OrderDate >= '2023-01-11';

--  Вибір юридичних клієнтів з певного міста
SELECT c.Email, lc.Business_Address
FROM Customer c
JOIN LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
WHERE lc.Business_Address LIKE '%New York%';


-- Пошук шпалер із ціною більше 15 і яких менше 10 у наявності
SELECT Name, Price FROM Wallpaper
WHERE Price > 15 AND Stock < 10;

-- 1. Шпалери середньої ціни (між 20 і 40), які є в наявності
SELECT Name, Price, Stock
FROM Wallpaper
WHERE Price BETWEEN 20 AND 40
  AND Stock > 0;

-- 2. Замовлення від юридичних клієнтів або великі замовлення (кількість >10)
SELECT o.Order_ID, c.Type, o.Quantity
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
WHERE c.Type = 'Legal' OR o.Quantity > 10;

-- 3. Шпалери, які не є "Vintage" і не "Floral"
SELECT Name, Price
FROM Wallpaper
WHERE NOT (Name LIKE '%Vintage%' OR Name LIKE '%Floral%');

-- 4. Клієнти, які не робили замовлень або робили маленькі замовлення
SELECT c.Email, COUNT(o.Order_ID) AS OrderCount
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Email
HAVING COUNT(o.Order_ID) = 0 OR MAX(o.Quantity) < 3;

-- 5. Шпалери з високим рейтингом або великим запасом
SELECT Name, Price, Stock
FROM Wallpaper
WHERE (Price > 40 AND Stock > 100)
   OR (Price BETWEEN 20 AND 40 AND Stock > 200);

   -- 1. Шпалери, назва яких починається на "Modern"
SELECT Name, Price
FROM Wallpaper
WHERE Name LIKE 'Modern%';

-- 2. Шпалери, назва яких містить "Floral"
SELECT Name, Price
FROM Wallpaper
WHERE Name LIKE '%Floral%';

-- 3. Клієнти з email на Gmail
SELECT Email, Type
FROM Customer
WHERE Email LIKE '%@gmail.com';

-- 4. Шпалери з назвою, що містить рівно 5 символів перед пробілом
SELECT Name
FROM Wallpaper
WHERE Name LIKE '_____ %';

-- 5. Юридичні клієнти з адресою, що містить "St" або "Ave"
SELECT c.Email, lc.Business_Address
FROM Customer c
JOIN LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
WHERE lc.Business_Address LIKE '%St%' 
   OR lc.Business_Address LIKE '%Ave%';

-- Пошук шпалер типу Floral
SELECT Name, Price FROM Wallpaper
WHERE Name LIKE '%Floral%';

-- 1. Список замовлень з інформацією про клієнтів
SELECT o.Order_ID, o.OrderDate, c.Email, c.Type 
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

-- 2. Шпалери та їх кількість у замовленнях
SELECT w.Name, SUM(wo.Quantity) AS TotalOrdered
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name;

-- 3. Повна інформація про замовлення (клієнт + шпалери)
SELECT o.Order_ID, c.Email, w.Name, wo.Quantity, w.Price
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID;

-- 4. Юридичні клієнти та їх замовлення
SELECT lc.Business_Address, o.OrderDate, o.Quantity
FROM LegalCustomer lc
JOIN Customer c ON lc.Customer_ID = c.Customer_ID
JOIN Orders o ON c.Customer_ID = o.Customer_ID;

-- 5. Шпалери, які ніколи не замовлялися
SELECT w.* FROM Wallpaper w
LEFT JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
WHERE wo.Wallpaper_ID IS NULL;

-- Показати всі замовлення з Email клієнтів
SELECT o.Order_ID, c.Email, o.OrderDate
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

-- Показати всі шпалери, навіть якщо їх ніхто не замовляв
SELECT w.Name, wo.Order_ID
FROM Wallpaper w
LEFT JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID;

-- 1. Усі клієнти (навіть без замовлень)
SELECT c.Customer_ID, c.Email, COUNT(o.Order_ID) AS OrderCount
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Email;

-- 2. Шпалери з кількістю замовлень (включаючи ті, що не замовлялися)
SELECT w.Name, COUNT(wo.Order_ID) AS OrderCount
FROM Wallpaper w
LEFT JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name;

-- 3. Порівняння індивідуальних та юридичних клієнтів
SELECT 
    c.Type,
    AVG(o.Quantity) AS AvgOrderSize,
    COUNT(DISTINCT o.Order_ID) AS TotalOrders
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Type;

-- 4. Повний звіт по замовленнях (з усіма можливими комбінаціями)
SELECT 
    c.Customer_ID, 
    o.Order_ID, 
    w.Wallpaper_ID,
    w.Name AS WallpaperName
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
LEFT JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
LEFT JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID;

-- 5. Клієнти без замовлень
SELECT c.* FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_ID IS NULL;

-- Пошук шпалер із ціною більше AVG
SELECT Name, Price FROM Wallpaper
WHERE Price > (SELECT AVG(Price) FROM Wallpaper);

-- 2. Клієнти, які робили замовлення на суму >500
SELECT c.* FROM Customer c
WHERE c.Customer_ID IN (
    SELECT o.Customer_ID FROM Orders o
    JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
    JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
    GROUP BY o.Customer_ID
    HAVING SUM(wo.Quantity * w.Price) > 500
);


-- 4. Замовлення з кількістю товарів більше середньої
SELECT * FROM Orders
WHERE Quantity > (SELECT AVG(Quantity) FROM Orders);

-- 4. Замовлення з кількістю товарів більше середньої
SELECT * FROM WallpaperOrders
WHERE Quantity > (SELECT AVG(Quantity) FROM WallpaperOrders);

-- 1. Середня ціна замовлення по типах клієнтів
SELECT 
    c.Type,
    AVG(w.Price * wo.Quantity) AS AvgOrderValue
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
GROUP BY c.Type;

-- 2. Шпалери, які замовляли більше 1 разів
SELECT 
    w.Name,
    COUNT(wo.Order_ID) AS OrderCount
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
HAVING COUNT(wo.Order_ID) > 1;

-- 3. Клієнти з більш ніж 1 замовленнями
SELECT 
    c.Email,
    c.Type,
    COUNT(o.Order_ID) AS OrderCount
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Email, c.Type
HAVING COUNT(o.Order_ID) > 1;

-- 4. Місячна статистика продажів
SELECT 
    o.OrderDate AS Month,
    SUM(wo.Quantity) AS TotalQuantity,
    SUM(wo.Quantity * w.Price) AS TotalRevenue
FROM Orders o
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
GROUP BY o.OrderDate
ORDER BY Month;

-- 5. Шпалери з загальною сумою продажів >10
SELECT 
    w.Name,
    SUM(wo.Quantity * w.Price) AS TotalSales
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
HAVING SUM(wo.Quantity * w.Price) > 10;

-- Отримання даних про замовлення, клієнтів і шпалери з підрахунком загальної суми кожного замовлення
SELECT O.Order_ID, O.OrderDate, C.Email, SUM(W.Price * WO.Quantity) AS TotalPrice
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
GROUP BY O.Order_ID, O.OrderDate, C.Email
ORDER BY TotalPrice DESC;

-- 1. Аналіз продажів по місяцям і типам клієнтів
SELECT 
    YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
    c.Type AS CustomerType,
    COUNT(DISTINCT o.Order_ID) AS OrderCount,
    SUM(wo.Quantity) AS TotalItems,
    SUM(wo.Quantity * w.Price) AS TotalRevenue
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), c.Type
ORDER BY Year, Month, CustomerType;

-- 2. активні клієнти (топ-5)
SELECT TOP 5
    c.Email,
    c.Type,
    COUNT(o.Order_ID) AS OrderCount,
    SUM(wo.Quantity) AS TotalItems,
    SUM(wo.Quantity * w.Price) AS TotalSpent
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
GROUP BY c.Email, c.Type
ORDER BY TotalSpent DESC;

-- 3. динаміка продажів по категоріям
SELECT 
    CASE
        WHEN w.Name LIKE '%Floral%' THEN 'Floral'
        WHEN w.Name LIKE '%Modern%' THEN 'Modern'
        WHEN w.Name LIKE '%Vintage%' THEN 'Vintage'
        ELSE 'Other'
    END AS Category,
    DATEPART(QUARTER, o.OrderDate) AS Quarter,
    SUM(wo.Quantity) AS TotalSold
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
JOIN Orders o ON wo.Order_ID = o.Order_ID
GROUP BY 
    CASE
        WHEN w.Name LIKE '%Floral%' THEN 'Floral'
        WHEN w.Name LIKE '%Modern%' THEN 'Modern'
        WHEN w.Name LIKE '%Vintage%' THEN 'Vintage'
        ELSE 'Other'
    END,
    DATEPART(QUARTER, o.OrderDate)
ORDER BY Quarter, Category;

-- 4. клієнти, що покупали шпалери вище сер ціни
SELECT DISTINCT
    c.Email,
    c.Type,
    w.Name AS WallpaperName,
    w.Price
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
WHERE w.Price > (SELECT AVG(Price) FROM Wallpaper)
ORDER BY w.Price DESC;

-- 5. повний звіт по замовленням
SELECT 
    o.Order_ID,
    o.OrderDate,
    c.Email,
    c.Type AS CustomerType,
    w.Name AS WallpaperName,
    wo.Quantity,
    w.Price,
    (wo.Quantity * w.Price) AS ItemTotal,
    o.Quantity AS TotalItemsInOrder
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
ORDER BY o.OrderDate DESC;

--Отримання замовлень клієнтів, зроблених після певної дати
SELECT O.Order_ID, O.OrderDate, C.Email, W.Name AS Wallpaper_Name, WO.Quantity
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
WHERE O.OrderDate > '2023-01-11';

-- 1. замовлення на конкретні шпалери
SELECT 
    o.Order_ID,
    o.OrderDate,
    c.Email
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
WHERE wo.Wallpaper_ID = 1;

-- 2. юр особи з певного міста
SELECT 
    c.Email,
    lc.Business_Address
FROM Customer c
JOIN LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
WHERE lc.Business_Address LIKE '%New York%';

-- 3. ціна між 200 і 300 що замовлялись
SELECT DISTINCT
    w.Name,
    w.Price
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
WHERE w.Price BETWEEN 20 AND 300;

-- 4. замовлення за ост місяць
SELECT 
    o.Order_ID,
    o.OrderDate,
    c.Email
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
WHERE o.OrderDate >= DATEADD(MONTH, -1, GETDATE());

-- 5. клієнти що замовлювали більше 2 од товару
SELECT DISTINCT
    c.Email,
    c.Type
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
WHERE wo.Quantity > 2;

-- Отримання списку всіх контактів (email індивідуальних клієнтів та адреси юридичних)
SELECT 
    c.Email AS ContactInfo,
    'Individual' AS ContactType
FROM Customer c
WHERE c.Type = 'Individual'

UNION

SELECT 
    lc.Business_Address AS ContactInfo,
    'Legal' AS ContactType
FROM LegalCustomer lc
JOIN Customer c ON lc.Customer_ID = c.Customer_ID;

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

-- 2. Клієнти, які робили замовлення на суму >500
SELECT c.* FROM Customer c
WHERE c.Customer_ID IN (
    SELECT o.Customer_ID FROM Orders o
    JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
    JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
    GROUP BY o.Customer_ID
    HAVING SUM(wo.Quantity * w.Price) > 500
);
 
-- 2. Шпалери, які замовляли більше 1 разів
SELECT 
    w.Name,
    COUNT(wo.Order_ID) AS OrderCount
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
HAVING COUNT(wo.Order_ID) > 1;

-- 3. Клієнти з більш ніж 1 замовленнями
SELECT 
    c.Email,
    c.Type,
    COUNT(o.Order_ID) AS OrderCount
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Email, c.Type
HAVING COUNT(o.Order_ID) > 1;
 
-- 5. Шпалери з загальною сумою продажів >10
SELECT 
    w.Name,
    SUM(wo.Quantity * w.Price) AS TotalSales
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
HAVING SUM(wo.Quantity * w.Price) > 10;

-- Отримання даних про замовлення, клієнтів і шпалери з підрахунком загальної суми кожного замовлення
SELECT O.Order_ID, O.OrderDate, C.Email, SUM(W.Price * WO.Quantity) AS TotalPrice
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
GROUP BY O.Order_ID, O.OrderDate, C.Email
ORDER BY TotalPrice DESC;
