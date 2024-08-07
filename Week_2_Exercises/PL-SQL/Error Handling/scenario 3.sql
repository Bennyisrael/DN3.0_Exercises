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

--scenario 3
CREATE OR REPLACE PROCEDURE AddNewCustomer (
    p_customer_id IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_loan_interest_rate IN NUMBER,
    p_balance IN NUMBER,
    p_is_vip IN CHAR
) IS
    duplicate_customer EXCEPTION;
BEGIN
    BEGIN
        INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, AGE, LOAN_INTEREST_RATE, BALANCE, IS_VIP)
        VALUES (p_customer_id, p_name, p_age, p_loan_interest_rate, p_balance, p_is_vip);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_customer_id || ' already exists.');
            ROLLBACK;
    END;
    
    COMMIT;
END;
/

BEGIN
    AddNewCustomer(2, 'Jane Smith', 45, 4.5, 20000, 'T');  -- Add a new customer
    AddNewCustomer(1, 'Alice Johnson', 50, 4.0, 10000, 'F');  -- Attempt to add a customer with an existing ID
END;
/
