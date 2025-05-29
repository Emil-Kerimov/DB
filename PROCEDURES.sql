-- 1. sp_help - ��������� ���������� ��� ��'���
EXEC sp_help 'Wallpaper';

-- 2. sp_spaceused - �������� ������������ ��������
EXEC sp_spaceused 'Customer';

-- 3. sp_rename - �������������� �������
EXEC sp_rename 'Wallpaper.Name', 'ProductName', 'COLUMN';

-- 1. ��������� ��� ������ ���������
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

EXEC ##GetOrderSummary;