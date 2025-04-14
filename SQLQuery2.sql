-- Вставка даних у таблицю Lvls
INSERT INTO Lvl (LvlID, LvlName) VALUES
(1, 'Low'),
(2, 'Mid'),
(3, 'High');

-- Вставка даних у таблицю Products
INSERT INTO Products (ProductID, ProductName, LvlID) VALUES
(101, 'Nasme1', 1),
(102, 'Nasme2', 2),
(103, 'Nasme3', 3),
(104, 'Nasme4', 1);

-- Перевірка даних
SELECT * FROM Lvl;
SELECT * FROM Products;

-- Оновлення LvlID в таблиці Categories
UPDATE Lvl SET LvlID = 4 WHERE LvlID = 1;

-- Перевірка оновлення
SELECT * FROM Lvl;
SELECT * FROM Products;

-- Видалення рядка з таблиці lvl
DELETE FROM Lvl WHERE LvlID = 2;

-- Перевірка видалення
SELECT * FROM Lvl;
SELECT * FROM Products;