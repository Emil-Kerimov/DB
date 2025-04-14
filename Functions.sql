-- розрахунок загальної вартості замовлення
CREATE FUNCTION dbo.GetOrderTotal (@OrderID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2)
    SELECT @Total = SUM(w.Price * wo.Quantity)
    FROM WallpaperOrders wo
    JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
    WHERE wo.Order_ID = @OrderID
    RETURN @Total
END;
SELECT dbo.GetOrderTotal(4) AS OrderTotal;

-- перевірка наявності шпалер на складі
CREATE FUNCTION dbo.IsInStock (@WallpaperID INT, @RequiredQty INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Stock INT
    SELECT @Stock = Stock FROM Wallpaper WHERE Wallpaper_ID = @WallpaperID
    RETURN CASE WHEN @Stock >= @RequiredQty THEN 1 ELSE 0 END
END;
SELECT dbo.IsInStock(1, 5) AS IsAvailable;

-- форматування інформації про клієнта
CREATE FUNCTION dbo.FormatCustomerInfo (@CustomerID INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Result NVARCHAR(200)
    SELECT @Result = 
        CASE c.Type
            WHEN 'Individual' THEN CONCAT(ic.Name, ' ', ic.Surname, ' (', c.Email, ')')
            WHEN 'Legal' THEN CONCAT('Company: ', c.Email, ' (', lc.Business_Address, ')')
        END
    FROM Customer c
    LEFT JOIN IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
    LEFT JOIN LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
    WHERE c.Customer_ID = @CustomerID
    RETURN @Result
END;
SELECT dbo.FormatCustomerInfo(1) AS CustomerInfo;

-- inline top10
CREATE FUNCTION dbo.GetTopWallpapers()
RETURNS TABLE
AS
RETURN (
    SELECT TOP 10 w.Wallpaper_ID, w.Name, SUM(wo.Quantity) AS TotalSold
    FROM Wallpaper w
    JOIN WallpaperOrders wo ON w.Wallpaper_ID = wo.Wallpaper_ID
    GROUP BY w.Wallpaper_ID, w.Name
    ORDER BY TotalSold DESC
);
SELECT * FROM dbo.GetTopWallpapers();

-- отримати замовлення клієнта
CREATE FUNCTION dbo.GetCustomerOrders (@CustomerID INT)
RETURNS TABLE
AS
RETURN (
    SELECT o.Order_ID, o.OrderDate, SUM(wo.Quantity) AS TotalItems
    FROM Orders o
    JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
    WHERE o.Customer_ID = @CustomerID
    GROUP BY o.Order_ID, o.OrderDate
);
SELECT * FROM dbo.GetCustomerOrders(1);

-- пошук за ціновим діапазоном
CREATE FUNCTION dbo.GetWallpapersByPriceRange (@MinPrice DECIMAL(10,2), @MaxPrice DECIMAL(10,2))
RETURNS TABLE
AS
RETURN (
    SELECT Wallpaper_ID, Name, Price, Stock
    FROM Wallpaper
    WHERE Price BETWEEN @MinPrice AND @MaxPrice
);
SELECT * FROM dbo.GetWallpapersByPriceRange(10, 300);

-- функція для аналізу продажів по місяцях
CREATE FUNCTION dbo.GetMonthlySalesReport()
RETURNS @Report TABLE (
    MonthYear NVARCHAR(20),
    TotalOrders INT,
    TotalRevenue DECIMAL(12,2),
    MostPopularWallpaper NVARCHAR(100)
)
AS
BEGIN
    INSERT INTO @Report
    SELECT 
        FORMAT(o.OrderDate, 'yyyy-MM') AS MonthYear,
        COUNT(DISTINCT o.Order_ID) AS TotalOrders,
        SUM(w.Price * wo.Quantity) AS TotalRevenue,
        (SELECT TOP 1 w2.Name 
         FROM WallpaperOrders wo2 
         JOIN Wallpaper w2 ON wo2.Wallpaper_ID = w2.Wallpaper_ID
         JOIN Orders o2 ON wo2.Order_ID = o2.Order_ID
         WHERE FORMAT(o2.OrderDate, 'yyyy-MM') = FORMAT(o.OrderDate, 'yyyy-MM')
         GROUP BY w2.Name
         ORDER BY SUM(wo2.Quantity) DESC) AS MostPopularWallpaper
    FROM Orders o
    JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
    JOIN Wallpaper w ON wo.Wallpaper_ID = w.Wallpaper_ID
    GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
    RETURN
END;
SELECT * FROM dbo.GetMonthlySalesReport();

-- функція для аналізу клієнтів
CREATE FUNCTION dbo.GetCustomerAnalysis()
RETURNS @Analysis TABLE (
    CustomerID INT,
    CustomerType NVARCHAR(20),
    TotalOrders INT,
    TotalSpent DECIMAL(12,2)
)
AS
BEGIN
    INSERT INTO @Analysis
    SELECT 
        c.Customer_ID,
        c.Type,
        COUNT(o.Order_ID) AS TotalOrders,
        SUM(dbo.GetOrderTotal(o.Order_ID)) AS TotalSpent
    FROM Customer c
    LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
    GROUP BY c.Customer_ID, c.Type
    RETURN
END;
SELECT * FROM dbo.GetCustomerAnalysis();

-- пошук клієнтів, які купили конкретні шпалери
SELECT c.Customer_ID, dbo.FormatCustomerInfo(c.Customer_ID) AS CustomerInfo
FROM Customer c
WHERE EXISTS (
    SELECT 1 FROM Orders o
    JOIN WallpaperOrders wo ON o.Order_ID = wo.Order_ID
    WHERE o.Customer_ID = c.Customer_ID AND wo.Wallpaper_ID = 6
);
-- отримати всі замовлення, де сума перевищує 100
SELECT 
    o.Order_ID AS OrderID,
    o.OrderDate,
    o.Customer_ID,
    dbo.GetOrderTotal(o.Order_ID) AS TotalAmount
FROM 
    Orders o
WHERE 
    dbo.GetOrderTotal(o.Order_ID) > 100
ORDER BY 
    TotalAmount DESC;