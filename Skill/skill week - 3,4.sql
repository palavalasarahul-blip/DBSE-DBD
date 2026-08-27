CREATE DATABASE IF NOT EXISTS Rahul_2520090016;
use Rahul_2520090016;

DROP TABLE IF EXISTS class_info;
DROP TABLE IF EXISTS class;

CREATE TABLE class (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE class_info (
    id INT,
    address VARCHAR(30)
);

INSERT INTO class VALUES
(1, 'abhi'),
(2, 'adam'),
(3, 'alex'),
(4, 'anu');

INSERT INTO class_info VALUES
(1, 'DELHI'),
(2, 'MUMBAI'),
(3, 'CHENNAI');

SELECT *
FROM class
CROSS JOIN class_info;

SELECT *
FROM class
INNER JOIN class_info
ON class.id = class_info.id;

SELECT class.name, class_info.address
FROM class
INNER JOIN class_info
ON class.id = class_info.id;

SELECT *
FROM class
NATURAL JOIN class_info;

INSERT INTO class VALUES
(5, 'ashish');

INSERT INTO class_info VALUES
(7, 'NOIDA'),
(8, 'PANIPAT');

SELECT *
FROM class
LEFT OUTER JOIN class_info
ON class.id = class_info.id;

SELECT *
FROM class
LEFT JOIN class_info
ON class.id = class_info.id
WHERE class_info.id IS NULL;

SELECT *
FROM class
RIGHT OUTER JOIN class_info
ON class.id = class_info.id;

SELECT *
FROM class
RIGHT JOIN class_info
ON class.id = class_info.id
WHERE class.id IS NULL;

SELECT
    class.id AS class_id,
    class.name,
    class_info.id AS info_id,
    class_info.address
FROM class
LEFT JOIN class_info
ON class.id = class_info.id

UNION

SELECT
    class.id AS class_id,
    class.name,
    class_info.id AS info_id,
    class_info.address
FROM class
RIGHT JOIN class_info
ON class.id = class_info.id;

SELECT
    class.id AS class_id,
    class.name,
    class_info.id AS info_id,
    class_info.address
FROM class
LEFT JOIN class_info
ON class.id = class_info.id
WHERE class_info.id IS NULL

UNION

SELECT
    class.id AS class_id,
    class.name,
    class_info.id AS info_id,
    class_info.address
FROM class
RIGHT JOIN class_info
ON class.id = class_info.id
WHERE class.id IS NULL;

DROP TABLE IF EXISTS first_table;
DROP TABLE IF EXISTS second_table;

CREATE TABLE first_table (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE second_table (
    id INT,
    name VARCHAR(30)
);

INSERT INTO first_table VALUES
(1, 'abhi'),
(2, 'adam');

INSERT INTO second_table VALUES
(2, 'adam'),
(3, 'chester');

SELECT *
FROM first_table
UNION
SELECT *
FROM second_table;

SELECT name
FROM first_table
UNION
SELECT name
FROM second_table;

SELECT *
FROM first_table
UNION ALL
SELECT *
FROM second_table;

SELECT COUNT(*) AS total_records
FROM (
    SELECT *
    FROM first_table
    UNION ALL
    SELECT *
    FROM second_table
) AS A;

SELECT f.id, f.name
FROM first_table f
INNER JOIN second_table s
ON f.id = s.id
AND f.name = s.name;

SELECT DISTINCT f.name
FROM first_table f
INNER JOIN second_table s
ON f.name = s.name;

SELECT f.id, f.name
FROM first_table f
WHERE NOT EXISTS (
    SELECT 1
    FROM second_table s
    WHERE s.id = f.id
    AND s.name = f.name
);

SELECT DISTINCT f.name
FROM first_table f
WHERE NOT EXISTS (
    SELECT 1
    FROM second_table s
    WHERE s.name = f.name
);

SELECT c.id, c.name, ci.address
FROM class c
INNER JOIN class_info ci
ON c.id = ci.id;

SELECT
    c.id,
    c.name,
    CASE
        WHEN ci.address IS NULL THEN 'Address Missing'
        ELSE 'Address Available'
    END AS Status
FROM class c
LEFT JOIN class_info ci
ON c.id = ci.id;

SELECT * FROM class;
SELECT * FROM class_info;
SELECT * FROM first_table;
SELECT * FROM second_table;

USE BankDB;

CREATE VIEW Customer_Account_View AS
SELECT
    C.Customer_ID,
    C.Customer_Name,
    C.Phone,
    C.Email,
    C.City,
    A.Account_No,
    A.Account_Type,
    A.Balance,
    A.Branch
FROM Customer C
JOIN Account A
ON C.Customer_ID = A.Customer_ID;

SELECT * FROM Customer_Account_View;

CREATE VIEW Customer_Loan_View AS
SELECT
    C.Customer_ID,
    C.Customer_Name,
    L.Loan_ID,
    L.Loan_Type,
    L.Loan_Amount,
    L.Interest_Rate
FROM Customer C
JOIN Loan L
ON C.Customer_ID = L.Customer_ID;

SELECT * FROM Customer_Loan_View;

CREATE VIEW Transaction_View AS
SELECT
    T.Transaction_ID,
    T.Account_No,
    C.Customer_Name,
    T.Transaction_Type,
    T.Amount,
    T.Transaction_Date
FROM Bank_Transaction T
JOIN Account A
ON T.Account_No = A.Account_No
JOIN Customer C
ON A.Customer_ID = C.Customer_ID;

SELECT * FROM Transaction_View;

DELIMITER //

CREATE TRIGGER CheckBalance
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
    IF NEW.Balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction failed: Insufficient balance';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER CheckTransactionAmount
BEFORE INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    IF NEW.Amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction amount must be greater than zero';
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER TransactionAudit
AFTER INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    INSERT INTO Transaction_Audit
    (
        Transaction_ID,
        Account_No,
        Transaction_Type,
        Amount
    )
    VALUES
    (
        NEW.Transaction_ID,
        NEW.Account_No,
        NEW.Transaction_Type,
        NEW.Amount
    );
END //

DELIMITER ;

USE BankDB;

DROP PROCEDURE IF EXISTS GetAllCustomers;
DROP PROCEDURE IF EXISTS GetAccountDetails;
DROP PROCEDURE IF EXISTS GetCustomerAccounts;
DROP PROCEDURE IF EXISTS DepositMoney;
DROP PROCEDURE IF EXISTS WithdrawMoney;
DROP PROCEDURE IF EXISTS TransferMoney;
DROP PROCEDURE IF EXISTS GetCustomerLoans;
DROP PROCEDURE IF EXISTS HighBalanceAccounts;
DROP PROCEDURE IF EXISTS GetBalance;

DELIMITER //

CREATE PROCEDURE GetAllCustomers()
BEGIN
    SELECT * FROM Customer;
END //

CREATE PROCEDURE GetAccountDetails(
    IN p_Account_No INT
)
BEGIN
    SELECT *
    FROM Account
    WHERE Account_No = p_Account_No;
END //

CREATE PROCEDURE GetCustomerAccounts(
    IN p_Customer_ID INT
)
BEGIN
    SELECT
        C.Customer_ID,
        C.Customer_Name,
        A.Account_No,
        A.Account_Type,
        A.Balance,
        A.Branch
    FROM Customer C
    JOIN Account A
    ON C.Customer_ID = A.Customer_ID
    WHERE C.Customer_ID = p_Customer_ID;
END //

CREATE PROCEDURE DepositMoney(
    IN p_Account_No INT,
    IN p_Amount DECIMAL(12,2)
)
BEGIN
    UPDATE Account
    SET Balance = Balance + p_Amount
    WHERE Account_No = p_Account_No;
END //

CREATE PROCEDURE WithdrawMoney(
    IN p_Account_No INT,
    IN p_Amount DECIMAL(12,2)
)
BEGIN
    UPDATE Account
    SET Balance = Balance - p_Amount
    WHERE Account_No = p_Account_No;
END //

CREATE PROCEDURE TransferMoney(
    IN SenderAccount INT,
    IN ReceiverAccount INT,
    IN TransferAmount DECIMAL(12,2)
)
BEGIN
    DECLARE SenderBalance DECIMAL(12,2);

    SELECT Balance
    INTO SenderBalance
    FROM Account
    WHERE Account_No = SenderAccount;

    IF SenderBalance < TransferAmount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transfer failed: Insufficient balance';
    ELSE
        UPDATE Account
        SET Balance = Balance - TransferAmount
        WHERE Account_No = SenderAccount;

        UPDATE Account
        SET Balance = Balance + TransferAmount
        WHERE Account_No = ReceiverAccount;
    END IF;
END //

CREATE PROCEDURE GetCustomerLoans(
    IN p_Customer_ID INT
)
BEGIN
    SELECT
        C.Customer_Name,
        L.Loan_ID,
        L.Loan_Type,
        L.Loan_Amount,
        L.Interest_Rate
    FROM Customer C
    JOIN Loan L
    ON C.Customer_ID = L.Customer_ID
    WHERE C.Customer_ID = p_Customer_ID;
END //

CREATE PROCEDURE HighBalanceAccounts(
    IN MinimumBalance DECIMAL(12,2)
)
BEGIN
    SELECT *
    FROM Account
    WHERE Balance >= MinimumBalance
    ORDER BY Balance DESC;
END //

CREATE PROCEDURE GetBalance(
    IN p_Account_No INT,
    OUT p_Balance DECIMAL(12,2)
)
BEGIN
    SELECT Balance
    INTO p_Balance
    FROM Account
    WHERE Account_No = p_Account_No;
END //

DELIMITER ;

CALL GetAllCustomers();

CALL GetAccountDetails(10001);

CALL GetCustomerAccounts(101);

CALL DepositMoney(10001, 5000);

CALL WithdrawMoney(10001, 3000);

CALL TransferMoney(10001, 10002, 5000);

CALL GetCustomerLoans(101);

CALL HighBalanceAccounts(50000);

CALL GetBalance(10001, @CurrentBalance);

SELECT @CurrentBalance;