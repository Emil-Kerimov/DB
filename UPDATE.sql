-- ��������� ���� �� �������
UPDATE Wallpaper
SET Price = 16.99
WHERE Name = 'Floral Pattern';
-- ��������� ������ ���������� �볺���
UPDATE LegalCustomer
SET Business_Address = '456 Corporate Rd, Corporate City'
WHERE Customer_ID = 2;
DELETE FROM WallpaperOrders
WHERE Order_ID = 1;

DELETE FROM Orders
WHERE Order_ID = 1;

-- ��������� ������� ������ � ������� Wallpaper
UPDATE Wallpaper
SET Stock = Stock - 10
WHERE Wallpaper_ID = 3;