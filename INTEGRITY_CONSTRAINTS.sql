-- 1. ��������� ����
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);

-- 2. ������� ����
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID)
);

-- 3. ��������� CHECK
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Price DECIMAL(10,2) CHECK (Price > 0),
    Stock INT CHECK (Stock >= 0)
);

-- 4. �������� ���������
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE
);

-- 5. ��������� DEFAULT
CREATE TABLE Logs (
    LogID INT PRIMARY KEY,
    LogDate DATETIME DEFAULT GETDATE(),
    Message NVARCHAR(MAX)
);

-- 1. ������� �������� (�� �������������)
ALTER TABLE Orders WITH CHECK
ADD CONSTRAINT FK_Customer
FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID);

--t7
-- 1. ��������� ������ (��� �����)
CREATE DOMAIN PriceDomain AS DECIMAL(10,2) CHECK (VALUE > 0);

-- 2. ��������� ��������
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,  -- NOT NULL - ��������� ��������
    Price DECIMAL(10,2) CHECK (Price > 0)  -- CHECK ��� ��������
);

-- 3. ��������� ������� (�������� ������ ��������)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    ShipDate DATE NULL,
    CONSTRAINT CHK_Dates CHECK (ShipDate IS NULL OR ShipDate >= OrderDate)
);

-- 4. ��������� ��������� (PRIMARY KEY, UNIQUE)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE
);

-- 5. ��������� ���� ����� (��������� ��'����)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID)
);