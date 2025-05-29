-- Вибірка всіх шпалер
SELECT * FROM Wallpaper;
SELECT * FROM Wallpaper WHERE Price > 25.00;
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

SELECT COUNT(*) AS WallpaperCount
FROM Wallpaper;

SELECT COUNT(*) AS CustomerCount
FROM Customer;

SELECT COUNT(*) AS IndividualCustomerCount
FROM IndividualCustomer;

SELECT COUNT(*) AS LegalCustomerCount
FROM LegalCustomer;

SELECT COUNT(*) AS OrdersCount
FROM Orders;

SELECT COUNT(*) AS WallpaperOrdersCount
FROM WallpaperOrders;

-- avg price of walpappers
SELECT
AVG(Price) AS AvgPrice
From Wallpaper;

-- count of orders for each client
SELECT 
	c.Email,
	COUNT(o.Order_ID) AS OrderCount
From Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
Group BY c.Email

-- топ 3 найпопулярніших шпалер
SELECT TOP 3
    w.Name,
    SUM(wo.Quantity) AS TotalSold
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
ORDER BY TotalSold DESC;

-- рейтинг за продажами
SELECT 
    w.Name,
    w.Price,
    SUM(wo.Quantity) AS TotalSold,
    RANK() OVER (ORDER BY SUM(wo.Quantity) DESC) AS SalesRank
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name, w.Price;

-- поіврняння ціни з середньою
SELECT 
    Name,
    Price,
    AVG(Price) OVER() AS AvgPrice,
    Price - AVG(Price) OVER() AS PriceDifference
FROM Wallpaper;

-- наростаючі продажі по місяцях
SELECT 
    YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
    SUM(wo.Quantity) AS MonthlySales,
    SUM(SUM(wo.Quantity)) OVER (ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)) AS CumulativeSales
FROM Orders o
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate);

-- форматування інформації про клієнтів
SELECT 
    Customer_ID,
    UPPER(LEFT(Type, 1)) + LOWER(SUBSTRING(Type, 2, LEN(Type))) AS FormattedType,
    CONCAT(LEFT(Email, 3), '...', RIGHT(Email, 7)) AS ShortEmail
FROM Customer;

SELECT 
    Name,
    LEN(Name) AS NameLength,
    CHARINDEX(' ', Name) AS FirstSpacePosition,
    REPLACE(Name, ' ', '-') AS NameWithDashes
FROM Wallpaper;

-- розділ адрес юр клієнтів
SELECT 
    Business_Address,
    LEFT(Business_Address, CHARINDEX(',', Business_Address) - 1) AS Street,
    SUBSTRING(Business_Address, 
              CHARINDEX(',', Business_Address) + 2,
              LEN(Business_Address)) AS CityAndState
FROM LegalCustomer;

--аналіз часу виконання замовлень
SELECT 
    Order_ID,
    OrderDate,
    DAY(OrderDate) AS OrderDay,
    DATENAME(weekday, OrderDate) AS WeekdayName,
    DATEDIFF(day, OrderDate, GETDATE()) AS DaysSinceOrder
FROM Orders;

-- продажі по кварталах
SELECT 
    DATEPART(quarter, o.OrderDate) AS Quarter,
    YEAR(o.OrderDate) AS Year,
    COUNT(*) AS OrderCount
FROM Orders o
GROUP BY DATEPART(quarter, o.OrderDate), YEAR(o.OrderDate)
ORDER BY Year, Quarter;

-- останній день місяця для кожного замовлення
SELECT 
    Order_ID,
    OrderDate,
    EOMONTH(OrderDate) AS MonthEndDate
FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31';

-- l5
-- Запит з фільтрацією WHERE
SELECT Name, Price FROM Wallpaper WHERE Stock < 50;

-- Запит з сортуванням ORDER BY
SELECT * FROM Orders ORDER BY OrderDate DESC;

-- Запит з JOIN
SELECT w.Name, wo.Quantity 
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
WHERE wo.Order_ID = 10;
-- t5
-- 1. Видаляємо foreign key constraint з таблиці WallpaperOrders
ALTER TABLE WallpaperOrders DROP CONSTRAINT FK__Wallpaper__Wallp__4E739D3B;

-- 2. Видаляємо первинний ключ з таблиці Wallpaper
ALTER TABLE Wallpaper DROP CONSTRAINT PK__Wallpape__8AF9E60299F35DB4;

-- 3. Створюємо новий кластеризований індекс на стовпці Wallpaper_ID
CREATE CLUSTERED INDEX IX_Wallpaper_Clustered ON Wallpaper(Wallpaper_ID);

-- 4. Відновлюємо первинний ключ як некластеризований індекс
ALTER TABLE Wallpaper ADD CONSTRAINT PK_Wallpaper PRIMARY KEY NONCLUSTERED (Wallpaper_ID);

-- 5. Відновлюємо foreign key constraint
ALTER TABLE WallpaperOrders 
ADD CONSTRAINT FK_WallpaperOrders_Wallpaper 
FOREIGN KEY (Wallpaper_ID) REFERENCES Wallpaper(Wallpaper_ID);
-- t6
CREATE NONCLUSTERED INDEX IX_Wallpaper_Price ON Wallpaper(Price);
--t7
CREATE UNIQUE INDEX IX_Customer_Email_Unique ON Customer(Email);
--t8
-- Створення індексу з включеними стовпцями
CREATE NONCLUSTERED INDEX IX_Wallpaper_Stock_INCLUDE 
ON Wallpaper(Stock) INCLUDE (Name, Price);

-- Порівняння планів виконання
SELECT Name, Price FROM Wallpaper WHERE Stock < 50;
--9
CREATE NONCLUSTERED INDEX IX_Orders_LegalCustomers 
ON Orders(Customer_ID)
WHERE Customer_ID > 50; -- ID юридичних клієнтів
--10
SELECT
 DB_NAME() AS [База_даних],
 OBJECT_NAME(i.[object_id]) AS [Таблиця],
 i.name AS [Індекс],
 i.type_desc AS [Тип_індексу],
 i.is_unique AS [Унікальний],
 ps.avg_fragmentation_in_percent AS [Фрагментація_у_%],
 ps.page_count AS [Кількість_сторінок]
FROM
 sys.indexes AS i
INNER JOIN
 sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
 ON i.[object_id] = ps.[object_id] AND i.index_id = ps.index_id
WHERE
 i.type > 0 AND i.is_hypothetical = 0
ORDER BY
 ps.avg_fragmentation_in_percent DESC;
--11
ALTER INDEX IX_Wallpaper_Price ON Wallpaper REORGANIZE;
--12
ALTER INDEX IX_Wallpaper_Clustered ON Wallpaper REBUILD;
--13
DROP INDEX IX_Wallpaper_Stock_INCLUDE ON Wallpaper;
--14
-- Переглянути наявні індекси для таблиці Wallpaper
SELECT 
    i.name AS index_name,
    i.type_desc AS index_type,
    c.name AS column_name
FROM 
    sys.indexes i
INNER JOIN 
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE 
    i.object_id = OBJECT_ID('Wallpaper');
-- Видалити існуючий індекс, якщо він є
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Wallpaper_Price' AND object_id = OBJECT_ID('Wallpaper'))
BEGIN
    DROP INDEX IX_Wallpaper_Price ON Wallpaper;
END
-- 1. Очистити кеш (для точних результатів тесту)
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

-- 2. Виконати запит БЕЗ індексу (фіксуємо час)
SET STATISTICS TIME ON;
SELECT * FROM Wallpaper WHERE Price BETWEEN 20 AND 30;
SET STATISTICS TIME OFF;
-- Зафіксувати час виконання та план (Clustered Index Scan)

-- 3. Створити індекс
CREATE NONCLUSTERED INDEX IX_Wallpaper_Price ON Wallpaper(Price);

-- 4. Очистити кеш знову
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

-- 5. Виконати запит З індексом (фіксуємо час)
SET STATISTICS TIME ON;
SELECT * FROM Wallpaper WHERE Price BETWEEN 20 AND 30;
SET STATISTICS TIME OFF;
-- Зафіксувати час виконання та план
--t 4 lab 5
SELECT * FROM Wallpaper WHERE Price BETWEEN 20 AND 30;

SELECT c.Customer_ID, COUNT(o.Order_ID) AS OrderCount FROM Customer c JOIN Orders o ON c.Customer_ID = o.Customer_ID GROUP BY c.Customer_ID;

SELECT w.Name, SUM(wo.Quantity) AS TotalSold FROM Wallpaper w JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID GROUP BY w.Name;

-- task6 lab 5
SELECT
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique,
    ips.avg_fragmentation_in_percent AS Fragmentation,
    ips.page_count AS PageCount
FROM 
    sys.indexes i
JOIN 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
    ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE 
    i.object_id = OBJECT_ID('Wallpaper') OR
    i.object_id = OBJECT_ID('Customer') OR
    i.object_id = OBJECT_ID('Orders');

	-- p6 t3
BEGIN TRANSACTION;
    -- Оновлення ціни шпалер
    UPDATE Wallpaper SET Price = Price * 1.1 WHERE Stock > 50;
    
    -- Додавання нового замовлення
    INSERT INTO Orders (Customer_ID, OrderDate, Quantity)
    VALUES (1, GETDATE(), 3);
COMMIT TRANSACTION;
--p6 t 4
BEGIN TRANSACTION;
    -- Зменшення запасів
    UPDATE Wallpaper SET Stock = Stock - 5 WHERE Wallpaper_ID = 1;
    
    -- Додавання запису про продаж
    INSERT INTO WallpaperOrders (Wallpaper_ID, Order_ID, Quantity)
    VALUES (1, 1, 5);
    
    -- Умова для відкату
    IF (SELECT Stock FROM Wallpaper WHERE Wallpaper_ID = 1) < 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Transaction rolled back due to negative stock';
    END
    ELSE
        COMMIT TRANSACTION;

--p6 t5
BEGIN TRANSACTION;
    -- Оновлення даних клієнта
    UPDATE Customer SET Email = 'new.email@example.com' WHERE Customer_ID = 1;
    
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Error occurred during customer update';
    END
    ELSE
        COMMIT TRANSACTION;
--p6 t6
BEGIN TRANSACTION;
    -- Точка збереження
    SAVE TRANSACTION BeforeUpdate;
    
    -- Оновлення цін
    UPDATE Wallpaper SET Price = Price * 99.2;
    
    -- Перевірка умови
    IF (SELECT AVG(Price) FROM Wallpaper) > 100
    BEGIN
        ROLLBACK TRANSACTION BeforeUpdate;
        PRINT 'Prices too high, rolling back to savepoint';
    END
    
    COMMIT TRANSACTION;

--tt7
BEGIN TRANSACTION;
BEGIN TRY
    -- Оновлення замовлення
    UPDATE Orders SET Quantity = 10 WHERE Order_ID = 1;
    
    -- Оновлення запасів
    UPDATE Wallpaper SET Stock = Stock - 10 WHERE Wallpaper_ID = 1;
    
    COMMIT TRANSACTION;
    PRINT 'Transaction completed successfully';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;
--t8
-- Спочатку створимо таблицю для логування
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLog')
CREATE TABLE AuditLog (
    LogID INT IDENTITY PRIMARY KEY,
    Action NVARCHAR(200),
    Timestamp DATETIME,
    UserName NVARCHAR(100) DEFAULT SYSTEM_USER
);

BEGIN TRANSACTION;
    -- Оновлення даних
    UPDATE Wallpaper SET Stock = 100 WHERE Wallpaper_ID = 1;
    
    -- Логування змін
    INSERT INTO AuditLog (Action, Timestamp)
    VALUES ('Updated wallpaper stock for ID 1', GETDATE());
    
COMMIT TRANSACTION;
SELECT * FROM AuditLog;
BEGIN TRANSACTION;
BEGIN TRY
    -- 1. Додаємо нового клієнта
    INSERT INTO Customer (Email, Type)
    VALUES ('new.customer@example.com', 'Individual');
    
    -- 2. Додаємо деталі фізичної особи
    INSERT INTO IndividualCustomer (Customer_ID, Name, Surname, Phone)
    VALUES (SCOPE_IDENTITY(), 'Іван', 'Петренко', '380991234567');
    
    -- 3. Додаємо перше замовлення
    INSERT INTO Orders (Customer_ID, OrderDate, Quantity)
    VALUES (SCOPE_IDENTITY(), GETDATE(), 2);
    
    -- Якщо все успішно - коміт
    COMMIT TRANSACTION;
    PRINT 'Транзакція успішно виконана';
END TRY
BEGIN CATCH
    -- При помилці - відкат
    ROLLBACK TRANSACTION;
    PRINT 'Помилка: ' + ERROR_MESSAGE();
    PRINT 'Транзакція відкочена через помилку';
END CATCH;

--t10
-- Спочатку створимо таблицю для підрахунку клієнтів
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerTypeCount')
CREATE TABLE CustomerTypeCount (
    Type NVARCHAR(50) PRIMARY KEY,
    Count INT DEFAULT 0
);

-- Транзакція для додавання клієнта з оновленням лічильника
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @CustomerType NVARCHAR(50) = 'Individual';
    
    -- 1. Додаємо нового клієнта
    INSERT INTO Customer (Email, Type)
    VALUES ('another.customer@example.com', @CustomerType);
    
    -- 2. Оновлюємо лічильник для типу клієнта
    IF EXISTS (SELECT 1 FROM CustomerTypeCount WHERE Type = @CustomerType)
        UPDATE CustomerTypeCount SET Count = Count + 1 WHERE Type = @CustomerType;
    ELSE
        INSERT INTO CustomerTypeCount (Type, Count) VALUES (@CustomerType, 1);
    
    COMMIT TRANSACTION;
    PRINT 'Клієнта додано та лічильник оновлено';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Помилка: ' + ERROR_MESSAGE();
END CATCH;

--11
BEGIN TRANSACTION;
BEGIN TRY
    -- 1. Додаємо нові шпалери
    INSERT INTO Wallpaper (ProductName, Price, Stock)
    VALUES ('Нова колекція', 49.99, 100);
    
    DECLARE @NewWallpaperID INT = SCOPE_IDENTITY();
    
    -- 2. Додаємо замовлення цих шпалер
    INSERT INTO Orders (Customer_ID, OrderDate, Quantity)
    VALUES (1, GETDATE(), 5);
    
    DECLARE @NewOrderID INT = SCOPE_IDENTITY();
    
    -- 3. Додаємо зв'язок між шпалерами і замовленням
    INSERT INTO WallpaperOrders (Wallpaper_ID, Order_ID, Quantity)
    VALUES (@NewWallpaperID, @NewOrderID, 5);
    
    -- 4. Оновлюємо залишок на складі
    UPDATE Wallpaper SET Stock = Stock - 5 WHERE Wallpaper_ID = @NewWallpaperID;
    
    COMMIT TRANSACTION;
    PRINT 'Усі операції виконані успішно';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Помилка: ' + ERROR_MESSAGE();
END CATCH;