-- 1. Первинний ключ
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);

-- 2. Зовнішній ключ
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID)
);

-- 3. Обмеження CHECK
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Price DECIMAL(10,2) CHECK (Price > 0),
    Stock INT CHECK (Stock >= 0)
);

-- 4. Унікальне обмеження
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE
);

-- 5. Обмеження DEFAULT
CREATE TABLE Logs (
    LogID INT PRIMARY KEY,
    LogDate DATETIME DEFAULT GETDATE(),
    Message NVARCHAR(MAX)
);

-- 1. Негайна перевірка (за замовчуванням)
ALTER TABLE Orders WITH CHECK
ADD CONSTRAINT FK_Customer
FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID);

--t7
-- 1. Обмеження домена (тип даних)
CREATE DOMAIN PriceDomain AS DECIMAL(10,2) CHECK (VALUE > 0);

-- 2. Обмеження атрибута
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,  -- NOT NULL - обмеження атрибута
    Price DECIMAL(10,2) CHECK (Price > 0)  -- CHECK для атрибута
);

-- 3. Обмеження кортежу (перевірка кількох атрибутів)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    ShipDate DATE NULL,
    CONSTRAINT CHK_Dates CHECK (ShipDate IS NULL OR ShipDate >= OrderDate)
);

-- 4. Обмеження відношення (PRIMARY KEY, UNIQUE)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE
);

-- 5. Обмеження бази даних (міжтабличні зв'язки)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID)
);