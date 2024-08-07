-- Create ACCOUNTS table
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    balance NUMBER(15, 2)
);

-- Create TRANSACTIONS table
CREATE TABLE Transactions (
    TransactionID NUMBER PRIMARY KEY,
    TransactionType VARCHAR2(10),
    AccountID NUMBER,
    Amount NUMBER(15, 2),
    TransactionDate DATE
);

-- Create the trigger to check transaction rules
CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
    v_balance NUMBER(15, 2);
BEGIN
    -- Check if the transaction is a withdrawal
    IF :NEW.TransactionType = 'WITHDRAWAL' THEN
        -- Get the current balance of the account
        SELECT balance INTO v_balance
        FROM accounts
        WHERE account_id = :NEW.AccountID;

        -- Ensure the withdrawal does not exceed the balance
        IF :NEW.Amount > v_balance THEN
            RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance for withdrawal.');
        END IF;
    ELSIF :NEW.TransactionType = 'DEPOSIT' THEN
        -- Ensure the deposit amount is positive
        IF :NEW.Amount <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Deposit amount must be positive.');
        END IF;
    END IF;
END;
/
-- Insert sample account record
INSERT INTO accounts (account_id, balance)
VALUES (101, 1000.00);

-- Insert a valid deposit transaction
INSERT INTO Transactions (TransactionID, TransactionType, AccountID, Amount, TransactionDate)
VALUES (2, 'DEPOSIT', 101, 300.00, SYSDATE);

-- Try to insert an invalid withdrawal transaction (will raise an error)
BEGIN
    INSERT INTO Transactions (TransactionID, TransactionType, AccountID, Amount, TransactionDate)
    VALUES (3, 'WITHDRAWAL', 101, 1500.00, SYSDATE);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Query to see the valid transaction
SELECT * FROM Transactions WHERE TransactionID = 2;

-- Query to see the updated balance
SELECT * FROM accounts WHERE account_id = 101;
