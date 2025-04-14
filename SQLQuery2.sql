-- ������� ����� � ������� Lvls
INSERT INTO Lvl (LvlID, LvlName) VALUES
(1, 'Low'),
(2, 'Mid'),
(3, 'High');

-- ������� ����� � ������� Products
INSERT INTO Products (ProductID, ProductName, LvlID) VALUES
(101, 'Nasme1', 1),
(102, 'Nasme2', 2),
(103, 'Nasme3', 3),
(104, 'Nasme4', 1);

-- �������� �����
SELECT * FROM Lvl;
SELECT * FROM Products;

-- ��������� LvlID � ������� Categories
UPDATE Lvl SET LvlID = 4 WHERE LvlID = 1;

-- �������� ���������
SELECT * FROM Lvl;
SELECT * FROM Products;

-- ��������� ����� � ������� lvl
DELETE FROM Lvl WHERE LvlID = 2;

-- �������� ���������
SELECT * FROM Lvl;
SELECT * FROM Products;