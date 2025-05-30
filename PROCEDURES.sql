-- 1. sp_help - отримання інформації про об'єкт
EXEC sp_help 'Wallpaper';

-- 2. sp_spaceused - перевірка використання простору
EXEC sp_spaceused 'Customer';

-- 3. sp_rename - перейменування стовпця
EXEC sp_rename 'Wallpaper.Name', 'ProductName', 'COLUMN';

-- 1. Процедура для аналізу замовлень
CREATE PROCEDURE ##GetOrderSummary
AS
BEGIN
    SELECT 
        c.Email, 
        COUNT(o.Order_ID) AS OrderCount,
        SUM(o.Quantity) AS TotalItems
    FROM 
        Customer c
    JOIN 
        Orders o ON c.Customer_ID = o.Customer_ID
    GROUP BY 
        c.Email;
END;

-- 2. Процедура для аналізу запасів шпалер
CREATE PROCEDURE ##GetWallpaperStockAnalysis
AS
BEGIN
    SELECT 
        Type = CASE 
            WHEN Stock > 100 THEN 'High'
            WHEN Stock BETWEEN 50 AND 100 THEN 'Medium'
            ELSE 'Low'
        END,
        COUNT(*) AS Count,
        AVG(Price) AS AvgPrice
    FROM 
        Wallpaper
    GROUP BY 
        CASE 
            WHEN Stock > 100 THEN 'High'
            WHEN Stock BETWEEN 50 AND 100 THEN 'Medium'
            ELSE 'Low'
        END;
END;

-- 3. Процедура для пошуку клієнтів з найбільшою кількістю замовлень
CREATE PROCEDURE ##GetTopCustomers
    @TopCount INT = 10
AS
BEGIN
    SELECT TOP (@TopCount)
        c.Customer_ID,
        ic.Name,
        ic.Surname,
        COUNT(o.Order_ID) AS OrderCount
    FROM 
        Customer c
    LEFT JOIN 
        IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
    LEFT JOIN 
        Orders o ON c.Customer_ID = o.Customer_ID
    GROUP BY 
        c.Customer_ID, ic.Name, ic.Surname
    ORDER BY 
        OrderCount DESC;
END;

-- Виконання процедур
EXEC ##GetOrderSummary;
EXEC ##GetWallpaperStockAnalysis;
EXEC ##GetTopCustomers 5;

--t8 тимчасові збережені 
-- 1. Процедура для пошуку шпалер за ціною
CREATE PROCEDURE #FindWallpapersByPrice
    @MinPrice DECIMAL(12,2),
    @MaxPrice DECIMAL(12,2)
AS
BEGIN
    SELECT 
        ProductName, 
        Price, 
        Stock 
    FROM 
        Wallpaper 
    WHERE 
        Price BETWEEN @MinPrice AND @MaxPrice;
END;

-- 2. Процедура для оновлення запасів
CREATE PROCEDURE #UpdateWallpaperStock
    @WallpaperID INT,
    @QuantityToAdd INT
AS
BEGIN
    UPDATE Wallpaper
    SET Stock = Stock + @QuantityToAdd
    WHERE Wallpaper_ID = @WallpaperID;
    
    SELECT Wallpaper_ID, ProductName, Stock 
    FROM Wallpaper 
    WHERE Wallpaper_ID = @WallpaperID;
END;

-- 3. Процедура для пошуку замовлень за період
CREATE PROCEDURE #GetOrdersByDateRange
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        o.Order_ID,
        c.Email,
        o.OrderDate,
        o.Quantity
    FROM 
        Orders o
    JOIN 
        Customer c ON o.Customer_ID = c.Customer_ID
    WHERE 
        o.OrderDate BETWEEN @StartDate AND @EndDate
    ORDER BY 
        o.OrderDate;
END;

-- Виконання процедур
EXEC #FindWallpapersByPrice 20, 30;
EXEC #UpdateWallpaperStock 1, 10;
EXEC #GetOrdersByDateRange '2023-01-01', '2023-12-31';

--t9 user
-- 1. Процедура для оновлення запасів
CREATE PROCEDURE usp_UpdateStock
    @WallpaperID INT,
    @Quantity INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE Wallpaper 
        SET Stock = Stock - @Quantity 
        WHERE Wallpaper_ID = @WallpaperID;
        
        IF @@ROWCOUNT = 0
            RAISERROR('Wallpaper not found', 16, 1);
            
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

EXEC usp_UpdateStock 1, 5;
-- t10
CREATE PROCEDURE usp_AddTestWallpapers
    @Count INT
AS
BEGIN
    DECLARE @i INT = 1;
    
    WHILE @i <= @Count
    BEGIN
        INSERT INTO Wallpaper (ProductName, Price, Stock)
        VALUES ('Test Wallpaper ' + CAST(@i AS VARCHAR), 
                ROUND(RAND() * 100, 2), 
                FLOOR(RAND() * 100));
        
        SET @i = @i + 1;
    END;
END;

EXEC usp_AddTestWallpapers 100;
--t11
-- Створення послідовності
CREATE SEQUENCE seq_WallpaperID
    START WITH 1000
    INCREMENT BY 1;

-- Процедура для вставки
CREATE PROCEDURE usp_InsertWallpaper
    @Name NVARCHAR(100),
    @Price DECIMAL(12,2),
    @Stock INT,
    @NewID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Wallpaper (ProductName, Price, Stock)
        VALUES (@Name, @Price, @Stock);

        -- Отрим останній згенерований IDENTITY ID
        SET @NewID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        SET @NewID = NULL; -- Якщо сталася помилка, встанов @NewID в NULL
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; -- Перекидає виняток далі
    END CATCH
END;

DECLARE @ID INT;
EXEC usp_InsertWallpaper 'New Design', 29.99, 50, @ID OUTPUT;
SELECT @ID AS NewWallpaperID;