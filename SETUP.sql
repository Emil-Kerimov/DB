-- Створення таблиці Wallpaper
CREATE TABLE Wallpaper (
 Wallpaper_ID INT PRIMARY KEY IDENTITY(1,1),
 Name NVARCHAR(100) NOT NULL,
 Price DECIMAL(12,2) NOT NULL CHECK (Price > 0),
 Stock INT NOT NULL CHECK (Stock >= 0)
);
-- Створення таблиці Customer
CREATE TABLE Customer (
 Customer_ID INT PRIMARY KEY IDENTITY(1,1),
 Email NVARCHAR(100) NOT NULL UNIQUE,
 Type NVARCHAR(50) NOT NULL
);
-- Створення таблиці IndividualCustomer
CREATE TABLE IndividualCustomer (
 Customer_ID INT PRIMARY KEY REFERENCES Customer(Customer_ID),
 Name NVARCHAR(100) NOT NULL,
 Surname NVARCHAR(100) NOT NULL,
 Phone NVARCHAR(20) NOT NULL
);
-- Створення таблиці LegalCustomer
CREATE TABLE LegalCustomer (
 Customer_ID INT PRIMARY KEY REFERENCES Customer(Customer_ID),
 Business_Address NVARCHAR(200) NOT NULL
);
-- Створення таблиці Orders
CREATE TABLE Orders (
 Order_ID INT PRIMARY KEY IDENTITY(1,1),
 Customer_ID INT NOT NULL FOREIGN KEY REFERENCES Customer(Customer_ID),
 OrderDate DATE NOT NULL,

 Quantity INT NOT NULL CHECK (Quantity > 0)
);
-- Створення таблиці WallpaperOrders
CREATE TABLE WallpaperOrders (
 Wallpaper_ID INT NOT NULL FOREIGN KEY REFERENCES Wallpaper(Wallpaper_ID),
 Order_ID INT NOT NULL FOREIGN KEY REFERENCES Orders(Order_ID),
 Quantity INT NOT NULL CHECK (Quantity > 0),
 PRIMARY KEY (Wallpaper_ID, Order_ID)
 );

 -- Створення таблиці Categories
CREATE TABLE Lvl (
    LvlID INT PRIMARY KEY,
    LvlName VARCHAR(255)
);

-- Створення таблиці Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    LvlID INT,
    FOREIGN KEY (LvlID) REFERENCES Lvl(LvlID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE DATABASE WallpaperStoreDB;
GO
SELECT
    CASE
        WHEN DB_ID('WallpaperStoreDB') IS NOT NULL THEN 'База даних існує'
        ELSE 'База даних НЕ існує'
    END AS DatabaseStatus;