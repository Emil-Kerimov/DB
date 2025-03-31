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

-- ����� ������ �� ����� ����� 15 � ���� ����� 10 � ��������
SELECT Name, Price FROM Wallpaper
WHERE Price > 15 AND Stock < 10;


-- ����� ������ ���� Floral
SELECT Name, Price FROM Wallpaper
WHERE Name LIKE '%Floral%';

-- �������� �� ���������� � Email �볺���
SELECT o.Order_ID, c.Email, o.OrderDate
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

-- �������� �� �������, ����� ���� �� ���� �� ��������
SELECT w.Name, wo.Order_ID
FROM Wallpaper w
LEFT JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID;

-- ����� ������ �� ����� ����� AVG
SELECT Name, Price FROM Wallpaper
WHERE Price > (SELECT AVG(Price) FROM Wallpaper);

SELECT C.Email, COUNT(O.Order_ID) AS TotalOrders
FROM Customer C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
GROUP BY C.Email
HAVING COUNT(O.Order_ID) > 1;

-- ��������� ����� ��� ����������, �볺��� � ������� � ���������� �������� ���� ������� ����������
SELECT O.Order_ID, O.OrderDate, C.Email, SUM(W.Price * WO.Quantity) AS TotalPrice
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
GROUP BY O.Order_ID, O.OrderDate, C.Email
ORDER BY TotalPrice DESC;

--��������� ��������� �볺���, ��������� ���� ����� ����
SELECT O.Order_ID, O.OrderDate, C.Email, W.Name AS Wallpaper_Name, WO.Quantity
FROM Orders O
JOIN Customer C ON O.Customer_ID = C.Customer_ID
JOIN WallpaperOrders WO ON O.Order_ID = WO.Order_ID
JOIN Wallpaper W ON WO.Wallpaper_ID = W.Wallpaper_ID
WHERE O.OrderDate > '2023-01-11';


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
