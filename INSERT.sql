-- Додавання записів у таблицю Wallpaper
INSERT INTO Wallpaper (Name, Price, Stock) VALUES
('Floral Pattern', 15.99, 100),
('Modern Stripes', 12.50, 200),
('Vintage Classic', 18.75, 150);
-- Додавання записів у таблицю Customer
INSERT INTO Customer (Email, Type) VALUES
('john.doe@example.com', 'Individual'),
('company@example.com', 'Legal');
-- Додавання записів у таблицю IndividualCustomer
INSERT INTO IndividualCustomer (Customer_ID, Name, Surname, Phone) VALUES
(1, 'John', 'Doe', '123-456-7890');
-- Додавання записів у таблицю LegalCustomer
INSERT INTO LegalCustomer (Customer_ID, Business_Address) VALUES
(2, '123 Business St, Business City');
-- Додавання записів у таблицю Orders
INSERT INTO Orders (Customer_ID, OrderDate, Quantity) VALUES
(1, '2024-11-25', 5),
(2, '2024-11-26', 10);
-- Додавання записів у таблицю WallpaperOrders
INSERT INTO WallpaperOrders (Wallpaper_ID, Order_ID, Quantity) VALUES
(1, 1, 2),
(2, 1, 3),
(3, 2, 10);