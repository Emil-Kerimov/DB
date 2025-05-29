BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @i INT = 1;
    DECLARE @StartTime DATETIME = GETDATE();
    
    WHILE @i <= 10000
    BEGIN
        INSERT INTO Wallpaper (ProductName, Price, Stock)
        VALUES ('BulkWallpaper_' + CAST(@i AS VARCHAR), 
                ROUND(RAND() * 100, 2), 
                FLOOR(RAND() * 200));
        
        SET @i = @i + 1;
        
        -- Коміт кожні 1000 записів
        IF @i % 1000 = 0
        BEGIN
            COMMIT;
            BEGIN TRANSACTION;
        END
    END
    
    COMMIT;
    PRINT 'Inserted 10000 records in ' + 
          CAST(DATEDIFF(SECOND, @StartTime, GETDATE()) AS VARCHAR) + ' seconds';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error during bulk insert: ' + ERROR_MESSAGE();
END CATCH;

-- t7
-- Додамо час виконання до процедури ##GetOrderSummary
ALTER PROCEDURE ##GetOrderSummary
AS
BEGIN
    DECLARE @StartTime DATETIME = GETDATE();
    PRINT 'Procedure started at: ' + CONVERT(VARCHAR, @StartTime, 120);
    
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
    
    PRINT 'Procedure completed in: ' + 
          CAST(DATEDIFF(MILLISECOND, @StartTime, GETDATE()) AS VARCHAR) + ' ms';
END;

--t8
-- Складний запит з кількома JOIN, сортуванням та фільтраці
SET STATISTICS TIME ON;
SELECT 
    c.Customer_ID,
    c.Email,
    CASE WHEN ic.Customer_ID IS NOT NULL THEN ic.Name + ' ' + ic.Surname
         ELSE lc.Business_Address END AS CustomerInfo,
    COUNT(o.Order_ID) AS TotalOrders,
    SUM(o.Quantity) AS TotalItems,
    AVG(w.Price) AS AvgPrice
FROM 
    Customer c
LEFT JOIN 
    IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
LEFT JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
JOIN 
    Orders o ON c.Customer_ID = o.Customer_ID
JOIN 
    WallpaperOrders wo ON o.Order_ID = wo.Order_ID
JOIN 
    Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
WHERE 
    o.OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
    AND w.Price > 20
GROUP BY 
    c.Customer_ID, c.Email, ic.Name,ic.Customer_ID, ic.Surname, lc.Business_Address
ORDER BY 
    TotalOrders DESC, TotalItems DESC;
SET STATISTICS TIME OFF;

--t9
-- Додаємо індекси для прискорення запиту
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID_OrderDate ON Orders(Customer_ID, OrderDate);
CREATE NONCLUSTERED INDEX IX_WallpaperOrders_OrderID ON WallpaperOrders(Order_ID);
CREATE NONCLUSTERED INDEX IX_Wallpaper_Price ON Wallpaper(Price) INCLUDE (ProductName);

-- Варіант з курсором
DECLARE @Results TABLE (
    Customer_ID INT,
    Email NVARCHAR(100),
    CustomerInfo NVARCHAR(200),
    TotalOrders INT,
    TotalItems INT,
    AvgPrice DECIMAL(12,2)
);

DECLARE @CustomerID INT, @Email NVARCHAR(100), @CustomerInfo NVARCHAR(200);
DECLARE @StartTime DATETIME = GETDATE();

DECLARE customer_cursor CURSOR FOR
SELECT 
    c.Customer_ID,
    c.Email,
    CASE WHEN ic.Customer_ID IS NOT NULL THEN ic.Name + ' ' + ic.Surname
         ELSE lc.Business_Address END
FROM Customer c
LEFT JOIN IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
LEFT JOIN LegalCustomer lc ON c.Customer_ID = lc.Customer_ID;

OPEN customer_cursor;
FETCH NEXT FROM customer_cursor INTO @CustomerID, @Email, @CustomerInfo;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @TotalOrders INT, @TotalItems INT, @AvgPrice DECIMAL(12,2);
    
    SELECT 
        @TotalOrders = COUNT(o.Order_ID),
        @TotalItems = SUM(o.Quantity),
        @AvgPrice = AVG(w.Price)
    FROM Orders o
    JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
    JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
    WHERE o.Customer_ID = @CustomerID
    AND o.OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
    AND w.Price > 20;
    
    IF @TotalOrders > 0
    BEGIN
        INSERT INTO @Results VALUES (
            @CustomerID, @Email, @CustomerInfo, 
            @TotalOrders, @TotalItems, @AvgPrice);
    END
    
    FETCH NEXT FROM customer_cursor INTO @CustomerID, @Email, @CustomerInfo;
END

CLOSE customer_cursor;
DEALLOCATE customer_cursor;

SELECT * FROM @Results ORDER BY TotalOrders DESC, TotalItems DESC;
PRINT 'Час виконання: ' + CAST(DATEDIFF(MS, @StartTime, GETDATE()) AS VARCHAR) + ' мс';