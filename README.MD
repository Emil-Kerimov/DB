# Create new v
docker volume create mssql-storage

Перевірити підключений том можна командою:
docker inspect -f '{{ .Mounts }}' mssql-study
# Run container
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Dbnpswwd2" -v
mssql-storage:/var/opt/mssql -p 1433:1433 --name mssql-study -d
mcr.microsoft.com/mssql/server:2022-latest

# Wallpaper Store Database - Тригери

Цей проект містить реалізацію різних типів тригерів для бази даних магазину шпалер.

## Виконані завдання

1. **DML тригери**
   - `tr_AfterInsertOrder` - логування нових замовлень
   - `tr_InsteadOfDeleteOrder` - захист історії замовлень
   - `tr_AfterUpdateWallpaper` - відстеження змін цін

2. **DDL тригер**
   - `tr_DDL_DatabaseChanges` - відстеження змін структури БД

3. **LOGON тригер**
   - `tr_Logon_RestrictAccess` - обмеження доступу за розкладом

4. **Бізнес-тригери**
   - Автоматичне оновлення запасів
   - Обмеження максимальної знижки
   - Валідація даних замовлення

## Як використовувати

1. Відкрийте файл `TRIGGERS.SQL` у SQL Server Management Studio
2. Виконайте скрипт для створення тригерів
3. Для тестування виконайте операції:
   ```sql
   -- Тест AFTER INSERT
   INSERT INTO Orders (Customer_ID, OrderDate, Quantity)
   VALUES (1, GETDATE(), 2);
   
   -- Тест INSTEAD OF DELETE
   DELETE FROM Orders WHERE Order_ID = 1;
   
   -- Тест AFTER UPDATE
   UPDATE Wallpaper SET Price = Price * 1.1 WHERE Wallpaper_ID = 1;

# Виконання скриптів VIEW.SQL:

Відкрийте файл VIEW.SQL у SQL Server Management Studio

Виконайте весь скрипт або окремі частини

## Приклади використання:
-- Вибрати всіх індивідуальних клієнтів
SELECT * FROM vIndividualCustomerNames;

-- Переглянути статистику замовлень
SELECT * FROM vCustomerOrderStats WHERE OrderCount > 3;
Представлення	Опис
vIndividualCustomerNames	Імена фізичних осіб
vLegalCustomers	Юридичні клієнти
vCustomerOrders	Замовлення клієнтів
vCustomerOrderStats	Статистика замовлень
vPremiumWallpapers	Дорогі шпалери (з обмеженням)
vEncryptedCustomerInfo	Шифрована інформація про клієнтів