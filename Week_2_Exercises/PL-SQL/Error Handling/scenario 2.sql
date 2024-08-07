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

--scenario 2
CREATE OR REPLACE PROCEDURE UpdateSalary (
    p_employee_id IN NUMBER,
    p_percentage IN NUMBER
) IS
    employee_not_found EXCEPTION;
    v_current_salary NUMBER;
BEGIN
    SELECT salary INTO v_current_salary FROM employees WHERE employee_id = p_employee_id FOR UPDATE;
    UPDATE employees
    SET salary = v_current_salary * (1 + p_percentage / 100)
    WHERE employee_id = p_employee_id;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || p_employee_id || ' does not exist.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/
BEGIN
    UpdateSalary(1, 10);  -- Increase salary of employee with ID 1 by 10%
    UpdateSalary(3, 5);   -- Attempt to increase salary of a non-existent employee
END;
/