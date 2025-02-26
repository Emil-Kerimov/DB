-- ������ ��� ������
SELECT * FROM Wallpaper;

-- ������ ��� �볺���
SELECT * FROM Customer;

-- ������ ��� ��������� �� ����� �� �������
SELECT Order_ID, OrderDate, Quantity FROM Orders;

-- ����� ������ �� ����� ����� 15
SELECT Name, Price FROM Wallpaper
WHERE Price > 15;

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
