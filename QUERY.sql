-- ������ ��� ������
SELECT * FROM Wallpaper;

-- ������ ��� �볺���
SELECT * FROM Customer;

-- ������ ���  Orders
SELECT * FROM Orders;

-- ������ ��� �볺���
SELECT * FROM WallpaperOrders;

-- ������ ��� ��������� �� ����� �� �������
SELECT Order_ID, OrderDate, Quantity FROM Orders;

-- ����� ������ �� ����� ����� 15
SELECT Name, Price FROM Wallpaper
WHERE Price > 15;

-- ����� ������ ���� ����� 10 � ��������
SELECT Name, Price FROM Wallpaper
WHERE Stock < 10;

SELECT Order_ID, Quantity FROM ORDERS
Where Quantity > 2;

--  ���� ��������� �� ������� �����
SELECT Order_ID, OrderDate, Quantity
FROM Orders
WHERE OrderDate >= '2023-01-11';

--  ���� ��������� �볺��� � ������� ����
SELECT c.Email, lc.Business_Address
FROM Customer c
JOIN LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
WHERE lc.Business_Address LIKE '%New York%';


-- ����� ������ �� ����� ����� 15 � ���� ����� 10 � ��������
SELECT Name, Price FROM Wallpaper
WHERE Price > 15 AND Stock < 10;

-- 1. ������� �������� ���� (�� 20 � 40), �� � � ��������
SELECT Name, Price, Stock
FROM Wallpaper
WHERE Price BETWEEN 20 AND 40
  AND Stock > 0;

-- 2. ���������� �� ��������� �볺��� ��� ����� ���������� (������� >10)
SELECT o.Order_ID, c.Type, o.Quantity
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
WHERE c.Type = 'Legal' OR o.Quantity > 10;

-- 3. �������, �� �� � "Vintage" � �� "Floral"
SELECT Name, Price
FROM Wallpaper
WHERE NOT (Name LIKE '%Vintage%' OR Name LIKE '%Floral%');

-- 4. �볺���, �� �� ������ ��������� ��� ������ ������� ����������
SELECT c.Email, COUNT(o.Order_ID) AS OrderCount
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Email
HAVING COUNT(o.Order_ID) = 0 OR MAX(o.Quantity) < 3;

-- 5. ������� � ������� ��������� ��� ������� �������
SELECT Name, Price, Stock
FROM Wallpaper
WHERE (Price > 40 AND Stock > 100)
   OR (Price BETWEEN 20 AND 40 AND Stock > 200);

   -- 1. �������, ����� ���� ���������� �� "Modern"
SELECT Name, Price
FROM Wallpaper
WHERE Name LIKE 'Modern%';

-- 2. �������, ����� ���� ������ "Floral"
SELECT Name, Price
FROM Wallpaper
WHERE Name LIKE '%Floral%';

-- 3. �볺��� � email �� Gmail
SELECT Email, Type
FROM Customer
WHERE Email LIKE '%@gmail.com';

-- 4. ������� � ������, �� ������ ���� 5 ������� ����� �������
SELECT Name
FROM Wallpaper
WHERE Name LIKE '_____ %';

-- 5. ������� �볺��� � �������, �� ������ "St" ��� "Ave"
SELECT c.Email, lc.Business_Address
FROM Customer c
JOIN LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
WHERE lc.Business_Address LIKE '%St%' 
   OR lc.Business_Address LIKE '%Ave%';

-- ����� ������ ���� Floral
SELECT Name, Price FROM Wallpaper
WHERE Name LIKE '%Floral%';

-- 1. ������ ��������� � ����������� ��� �볺���
SELECT o.Order_ID, o.OrderDate, c.Email, c.Type 
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

-- 2. ������� �� �� ������� � �����������
SELECT w.Name, SUM(wo.Quantity) AS TotalOrdered
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name;

-- 3. ����� ���������� ��� ���������� (�볺�� + �������)
SELECT o.Order_ID, c.Email, w.Name, wo.Quantity, w.Price
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID;

-- 4. ������� �볺��� �� �� ����������
SELECT lc.Business_Address, o.OrderDate, o.Quantity
FROM LegalCustomer lc
JOIN Customer c ON lc.Customer_ID = c.Customer_ID
JOIN Orders o ON c.Customer_ID = o.Customer_ID;

-- 5. �������, �� ����� �� �����������
SELECT w.* FROM Wallpaper w
LEFT JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
WHERE wo.Wallpaper_ID IS NULL;

-- �������� �� ���������� � Email �볺���
SELECT o.Order_ID, c.Email, o.OrderDate
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

-- �������� �� �������, ����� ���� �� ���� �� ��������
SELECT w.Name, wo.Order_ID
FROM Wallpaper w
LEFT JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID;

-- 1. �� �볺��� (����� ��� ���������)
SELECT c.Customer_ID, c.Email, COUNT(o.Order_ID) AS OrderCount
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Email;

-- 2. ������� � ������� ��������� (��������� �, �� �� �����������)
SELECT w.Name, COUNT(wo.Order_ID) AS OrderCount
FROM Wallpaper w
LEFT JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name;

-- 3. ��������� ������������� �� ��������� �볺���
SELECT 
    c.Type,
    AVG(o.Quantity) AS AvgOrderSize,
    COUNT(DISTINCT o.Order_ID) AS TotalOrders
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Type;

-- 4. ������ ��� �� ����������� (� ���� ��������� �����������)
SELECT 
    c.Customer_ID, 
    o.Order_ID, 
    w.Wallpaper_ID,
    w.Name AS WallpaperName
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
LEFT JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
LEFT JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID;

-- 5. �볺��� ��� ���������
SELECT c.* FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_ID IS NULL;

-- ����� ������ �� ����� ����� AVG
SELECT Name, Price FROM Wallpaper
WHERE Price > (SELECT AVG(Price) FROM Wallpaper);

-- 2. �볺���, �� ������ ���������� �� ���� >500
SELECT c.* FROM Customer c
WHERE c.Customer_ID IN (
    SELECT o.Customer_ID FROM Orders o
    JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
    JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
    GROUP BY o.Customer_ID
    HAVING SUM(wo.Quantity * w.Price) > 500
);


-- 4. ���������� � ������� ������ ����� ��������
SELECT * FROM Orders
WHERE Quantity > (SELECT AVG(Quantity) FROM Orders);

-- 4. ���������� � ������� ������ ����� ��������
SELECT * FROM WallpaperOrders
WHERE Quantity > (SELECT AVG(Quantity) FROM WallpaperOrders);

-- 1. ������� ���� ���������� �� ����� �볺���
SELECT 
    c.Type,
    AVG(w.Price * wo.Quantity) AS AvgOrderValue
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
GROUP BY c.Type;

-- 2. �������, �� ��������� ����� 1 ����
SELECT 
    w.Name,
    COUNT(wo.Order_ID) AS OrderCount
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
HAVING COUNT(wo.Order_ID) > 1;

-- 3. �볺��� � ���� �� 1 ������������
SELECT 
    c.Email,
    c.Type,
    COUNT(o.Order_ID) AS OrderCount
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Email, c.Type
HAVING COUNT(o.Order_ID) > 1;

-- 4. ̳����� ���������� �������
SELECT 
    o.OrderDate AS Month,
    SUM(wo.Quantity) AS TotalQuantity,
    SUM(wo.Quantity * w.Price) AS TotalRevenue
FROM Orders o
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
GROUP BY o.OrderDate
ORDER BY Month;

-- 5. ������� � ��������� ����� ������� >10
SELECT 
    w.Name,
    SUM(wo.Quantity * w.Price) AS TotalSales
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
HAVING SUM(wo.Quantity * w.Price) > 10;

-- ��������� ����� ��� ����������, �볺��� � ������� � ���������� �������� ���� ������� ����������
SELECT O.Order_ID, O.OrderDate, C.Email, SUM(W.Price * WO.Quantity) AS TotalPrice
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
GROUP BY O.Order_ID, O.OrderDate, C.Email
ORDER BY TotalPrice DESC;

-- 1. ����� ������� �� ������ � ����� �볺���
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

-- 2. ������ �볺��� (���-5)
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

-- 3. ������� ������� �� ���������
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

-- 4. �볺���, �� �������� ������� ���� ��� ����
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

-- 5. ������ ��� �� �����������
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

--��������� ��������� �볺���, ��������� ���� ����� ����
SELECT O.Order_ID, O.OrderDate, C.Email, W.Name AS Wallpaper_Name, WO.Quantity
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
WHERE O.OrderDate > '2023-01-11';

-- 1. ���������� �� �������� �������
SELECT 
    o.Order_ID,
    o.OrderDate,
    c.Email
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
WHERE wo.Wallpaper_ID = 1;

-- 2. �� ����� � ������� ����
SELECT 
    c.Email,
    lc.Business_Address
FROM Customer c
JOIN LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
WHERE lc.Business_Address LIKE '%New York%';

-- 3. ���� �� 200 � 300 �� �����������
SELECT DISTINCT
    w.Name,
    w.Price
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
WHERE w.Price BETWEEN 20 AND 300;

-- 4. ���������� �� ��� �����
SELECT 
    o.Order_ID,
    o.OrderDate,
    c.Email
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
WHERE o.OrderDate >= DATEADD(MONTH, -1, GETDATE());

-- 5. �볺��� �� ����������� ����� 2 �� ������
SELECT DISTINCT
    c.Email,
    c.Type
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
WHERE wo.Quantity > 2;

-- ��������� ������ ��� �������� (email ������������� �볺��� �� ������ ���������)
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

-- ���������� ������ �� ����� �� ���������
SELECT Name, Price FROM Wallpaper
ORDER BY Price DESC;

-- ϳ�������� �������� ������� ������ � �������
SELECT SUM(Stock) AS Total_Stock FROM Wallpaper;

-- ������� ���� ������
SELECT AVG(Price) AS AveragePrice FROM Wallpaper;


-- ���� �볺���, � ���� ��������� ����� �� 5 ������� ������
SELECT C.Email, O.Quantity
FROM Customer C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
WHERE O.Quantity > 5;

-- 2. �볺���, �� ������ ���������� �� ���� >500
SELECT c.* FROM Customer c
WHERE c.Customer_ID IN (
    SELECT o.Customer_ID FROM Orders o
    JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
    JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
    GROUP BY o.Customer_ID
    HAVING SUM(wo.Quantity * w.Price) > 500
);
 
-- 2. �������, �� ��������� ����� 1 ����
SELECT 
    w.Name,
    COUNT(wo.Order_ID) AS OrderCount
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
HAVING COUNT(wo.Order_ID) > 1;

-- 3. �볺��� � ���� �� 1 ������������
SELECT 
    c.Email,
    c.Type,
    COUNT(o.Order_ID) AS OrderCount
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Email, c.Type
HAVING COUNT(o.Order_ID) > 1;
 
-- 5. ������� � ��������� ����� ������� >10
SELECT 
    w.Name,
    SUM(wo.Quantity * w.Price) AS TotalSales
FROM Wallpaper w
JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
GROUP BY w.Name
HAVING SUM(wo.Quantity * w.Price) > 10;

-- ��������� ����� ��� ����������, �볺��� � ������� � ���������� �������� ���� ������� ����������
SELECT O.Order_ID, O.OrderDate, C.Email, SUM(W.Price * WO.Quantity) AS TotalPrice
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
GROUP BY O.Order_ID, O.OrderDate, C.Email
ORDER BY TotalPrice DESC;
