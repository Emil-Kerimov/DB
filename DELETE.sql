-- ��������� ����� � �������
DELETE FROM WallpaperOrders;
DELETE FROM Orders;
DELETE FROM IndividualCustomer;
DELETE FROM LegalCustomer;
DELETE FROM Customer;
DELETE FROM Wallpaper;
-- ��������� �������
DROP TABLE WallpaperOrders;
DROP TABLE Orders;
DROP TABLE IndividualCustomer;
DROP TABLE LegalCustomer;
DROP TABLE Customer;
DROP TABLE Wallpaper;

-- ³�������� ������� ����� ����������
ALTER INDEX ALL ON Wallpaper DISABLE;

-- �������� ���������
DELETE FROM Wallpaper;

-- �������� ������� �����
ALTER INDEX ALL ON Wallpaper REBUILD;