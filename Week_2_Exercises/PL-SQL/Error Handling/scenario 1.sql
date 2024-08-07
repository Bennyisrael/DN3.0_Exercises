-- Create the tables
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    balance NUMBER(15, 2)
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    salary NUMBER(15, 2)
);

CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(50),
    AGE NUMBER,
    LOAN_INTEREST_RATE NUMBER(5, 2),
    BALANCE NUMBER(15, 2),
    IS_VIP CHAR(1)
);

-- Insert values into tables
INSERT INTO accounts (account_id, balance) VALUES (1, 1000);
INSERT INTO accounts (account_id, balance) VALUES (2, 500);

INSERT INTO employees (employee_id, salary) VALUES (1, 50000);
INSERT INTO employees (employee_id, salary) VALUES (2, 60000);

INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, AGE, LOAN_INTEREST_RATE, BALANCE, IS_VIP) VALUES (1, 'John Doe', 65, 5.5, 15000, 'F');

-- Create the procedure
CREATE OR REPLACE PROCEDURE SafeTransferFunds (
    p_from_account_id IN NUMBER,
    p_to_account_id IN NUMBER,
    p_amount IN NUMBER
) IS
    insufficient_funds EXCEPTION;
    v_from_balance NUMBER;
    v_to_balance NUMBER;
BEGIN
    -- Lock the rows for update to prevent race conditions
    SELECT balance INTO v_from_balance FROM accounts WHERE account_id = p_from_account_id FOR UPDATE;
    
    -- Check for sufficient funds
    IF v_from_balance < p_amount THEN
        RAISE insufficient_funds;
    END IF;

    -- Lock the destination row
    SELECT balance INTO v_to_balance FROM accounts WHERE account_id = p_to_account_id FOR UPDATE;

    -- Update the balances
    UPDATE accounts SET balance = v_from_balance - p_amount WHERE account_id = p_from_account_id;
    UPDATE accounts SET balance = v_to_balance + p_amount WHERE account_id = p_to_account_id;

    COMMIT;

EXCEPTION
    WHEN insufficient_funds THEN
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds in account ' || p_from_account_id);
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Execute the procedure
BEGIN
    SafeTransferFunds(1, 2, 200);
    SafeTransferFunds(1, 2, 1000);
END;
/
