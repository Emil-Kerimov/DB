-- �������� 3. ������ ������������� (��� IndividualCustomer)
CREATE VIEW vIndividualCustomerNames AS
SELECT 
    ic.Customer_ID,
    ic.Name AS FirstName,
    ic.Surname AS LastName
FROM 
    IndividualCustomer ic;
GO

SELECT * FROM vIndividualCustomerNames;
-- �������� 4. ������������ �������������
SELECT FirstName, LastName FROM vIndividualCustomerNames;
GO

-- �������� 5. ������������� � �������� (Legal Customer)
CREATE VIEW vLegalCustomers AS
SELECT 
    c.Customer_ID,
    lc.Business_Address
FROM 
    Customer c
JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
WHERE 
    c.Type = 'Legal';
GO
SELECT * FROM vLegalCustomers;
-- �������� 6. ��������� ����� �������������
UPDATE vLegalCustomers
SET Business_Address = 'Updated Address, Kyiv'
WHERE Customer_ID = 51; -- ������� ID ���������� �볺���
GO

-- �������� 7. ������������� � JOIN (Customer + Orders)
CREATE VIEW vCustomerOrders AS
SELECT 
    c.Customer_ID,
    CASE 
        WHEN ic.Customer_ID IS NOT NULL THEN ic.Name + ' ' + ic.Surname
        ELSE lc.Business_Address
    END AS CustomerInfo,
    o.Order_ID,
    o.OrderDate,
    o.Quantity
FROM 
    Customer c
LEFT JOIN 
    IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
LEFT JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
JOIN 
    Orders o ON c.Customer_ID = o.Customer_ID;
GO
SELECT * FROM vCustomerOrders;
-- �������� 8. ������������� � ����������
CREATE VIEW vCustomerOrderStats AS
SELECT 
    c.Customer_ID,
    CASE 
        WHEN ic.Customer_ID IS NOT NULL THEN ic.Name + ' ' + ic.Surname
        ELSE lc.Business_Address
    END AS CustomerInfo,
    COUNT(o.Order_ID) AS OrderCount,
    SUM(o.Quantity) AS TotalItems
FROM 
    Customer c
LEFT JOIN 
    IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
LEFT JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
LEFT JOIN 
    Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY 
    c.Customer_ID,ic.Customer_ID, ic.Name, ic.Surname, lc.Business_Address;
GO

-- �������� 10. VIP Customers (� 5+ ������������)
CREATE VIEW vVIPCustomers AS
SELECT *
FROM vCustomerOrderStats
WHERE OrderCount >= 5;
GO

-- �������� 11. ALTER VIEW (������ Email)
ALTER VIEW vCustomerOrders AS
SELECT 
    c.Customer_ID,
    c.Email,
    CASE 
        WHEN ic.Customer_ID IS NOT NULL THEN ic.Name + ' ' + ic.Surname
        ELSE lc.Business_Address
    END AS CustomerInfo,
    o.Order_ID,
    o.OrderDate,
    o.Quantity
FROM 
    Customer c
LEFT JOIN 
    IndividualCustomer ic ON c.Customer_ID = ic.Customer_ID
LEFT JOIN 
    LegalCustomer lc ON c.Customer_ID = lc.Customer_ID
JOIN 
    Orders o ON c.Customer_ID = o.Customer_ID;
GO
SELECT * FROM vCustomerOrders;
-- �������� 12. ��������� �������������
DROP VIEW IF EXISTS vVIPCustomers;
GO

-- �������� 13. ������������� � �����������
CREATE VIEW vOrderSummary AS
SELECT 
    Order_ID AS OrderID,
    OrderDate AS OrderDateTime,
    Quantity AS ItemCount
FROM 
    Orders;
GO
SELECT * FROM vOrderSummary;
-- �������� 14. ������������� � ������������ ��������
CREATE VIEW vWallpaperWithTax AS
SELECT 
    Wallpaper_ID,
    ProductName,
    Price,
    Price * 1.2 AS PriceWithVAT
FROM 
    Wallpaper;
GO
SELECT * FROM vWallpaperWithTax;
-- �������� 15. WITH CHECK OPTION (����� �������)
CREATE VIEW vPremiumWallpapers AS
SELECT *
FROM Wallpaper
WHERE Price > 50
WITH CHECK OPTION;
GO

-- ������ �������� ����� ������� ����� ������������� (������� �������)
 INSERT INTO vPremiumWallpapers (ProductName, Price, Stock) VALUES ('Cheap Wallpaper', 30, 100);
GO

-- �������� 16. ��������� �������������
CREATE VIEW vEncryptedCustomerInfo
WITH ENCRYPTION
AS
SELECT 
    c.Customer_ID,
    c.Email,
    c.Type
FROM 
    Customer c;
GO
-- �������� 17. ������������� ��� ��������� ��������
CREATE VIEW vRestrictedOrders AS
SELECT 
    Order_ID,
    OrderDate
FROM 
    Orders;
GO

-- ������� ���� (����������, �� ���������� ReadOnlyUser ����)
 GRANT SELECT ON vRestrictedOrders TO ReadOnlyUser;
GO