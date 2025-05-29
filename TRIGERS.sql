-- ��������� ������� ��� ��������� ��������� (���� �� ����)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderLogs')
CREATE TABLE OrderLogs (
    LogID INT IDENTITY PRIMARY KEY,
    OrderID INT,
    Action VARCHAR(20),
    LogDate DATETIME DEFAULT GETDATE(),
    UserName VARCHAR(100) DEFAULT SYSTEM_USER
);
-- 1. AFTER INSERT ������ ��� ��������� ����� ���������
CREATE TRIGGER tr_AfterInsertOrder
ON Orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO OrderLogs (OrderID, Action, LogDate)
    SELECT i.Order_ID, 'INSERT', GETDATE()
    FROM inserted i;
    
    PRINT 'New order logged successfully';
END;
GO

-- 2. INSTEAD OF DELETE ������ ��� ������� ����� ���������
-- ������������� ����� ��� ������ (������ ����� ���������)
CREATE TRIGGER tr_InsteadOfDeleteOrder
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    -- ������ ������� ��������� � ������������
    DECLARE @OrderCount INT = (SELECT COUNT(*) FROM deleted);
    RAISERROR('Deletion of orders is not allowed. %d order(s) were not deleted.', 16, 1, @OrderCount);
END;
GO

-- ��������� ������� ��������� ��� ���
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PriceChangeLog')
CREATE TABLE PriceChangeLog (
    ChangeID INT IDENTITY PRIMARY KEY,
    WallpaperID INT,
    OldPrice DECIMAL(12,2),
    NewPrice DECIMAL(12,2),
    ChangeDate DATETIME DEFAULT GETDATE(),
    UserName VARCHAR(100) DEFAULT SYSTEM_USER,
    FOREIGN KEY (WallpaperID) REFERENCES Wallpaper(Wallpaper_ID)
);
-- 3. AFTER UPDATE ������ ��� ���������� ��� ���
CREATE TRIGGER tr_AfterUpdateWallpaper
ON Wallpaper
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Price)
    BEGIN
        INSERT INTO PriceChangeLog (WallpaperID, OldPrice, NewPrice, ChangeDate)
        SELECT d.Wallpaper_ID, d.Price, i.Price, GETDATE()
        FROM deleted d
        JOIN inserted i ON d.Wallpaper_ID = i.Wallpaper_ID
        WHERE d.Price <> i.Price;
    END
END;
GO

-- 5. DDL ������ ��� ���������� ��� ���������
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_DDL_DatabaseChanges' AND parent_id = 0)
    DROP TRIGGER tr_DDL_DatabaseChanges ON DATABASE;
GO

CREATE TRIGGER tr_DDL_DatabaseChanges
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @EventData XML = EVENTDATA();
    DECLARE @Message NVARCHAR(1000) = 
        'Database change: ' + 
        @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)') + 
        ' on ' + 
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)');
    
    PRINT @Message;
END;
GO

-- 6. LOGON ������

CREATE TRIGGER tr_Logon_RestrictAccess
ON ALL SERVER
FOR LOGON
AS
BEGIN
    IF ORIGINAL_LOGIN() = 'RestrictedUser'
    AND DATEPART(HOUR, GETDATE()) BETWEEN 0 AND 6
    BEGIN
        ROLLBACK;
        PRINT 'Access denied: This user cannot log in between 12AM and 6AM';
    END
END;
GO

-- 4. ������ ��� ������������� ��������� ������ ��� ���������
CREATE TRIGGER tr_AfterInsertWallpaperOrder
ON WallpaperOrders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE w
    SET w.Stock = w.Stock - i.Quantity
    FROM Wallpaper w
    JOIN inserted i ON w.Wallpaper_ID = i.Wallpaper_ID;
    
    PRINT 'Wallpaper stock updated after new order';
END;
GO

-- 1. ��������� ������� ��� �������� ���������  ��������� ��� �������� ���������
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CheckOrderDiscount')
    DROP TRIGGER tr_CheckOrderDiscount;
GO

CREATE TRIGGER tr_CheckOrderDiscount
ON Orders
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- ����������, �� � ���������� � ���������� ���������
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Customer c ON i.Customer_ID = c.Customer_ID
        WHERE i.Quantity > 10 AND c.Type = 'Individual'
    )
    BEGIN
        RAISERROR('Individual customers cannot order more than 10 items at once', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- ��������� �������� ��� ��������� ���
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Customer c ON i.Customer_ID = c.Customer_ID
        WHERE i.Quantity > 50 AND c.Type = 'Legal'
    )
    BEGIN
        RAISERROR('Legal customers cannot order more than 50 items at once', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
-- ����������
DELETE FROM Orders WHERE Order_ID = 10;

-- ��������
SELECT * FROM Orders WHERE Order_ID = 10; -- ����� �� ����������

-- ����������
UPDATE Wallpaper SET Price = 150.00 WHERE Wallpaper_ID = 101;

-- ��������
SELECT * FROM PriceChangeLog WHERE WallpaperID = 101;