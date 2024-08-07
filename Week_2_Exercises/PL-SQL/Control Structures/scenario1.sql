-- Create CUSTOMERS table
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(50),
    AGE NUMBER,
    LOAN_INTEREST_RATE NUMBER(5, 2),
    BALANCE NUMBER(15, 2),
    IS_VIP BOOLEAN
);

-- Create LOANS table
CREATE TABLE LOANS (
    LOAN_ID NUMBER PRIMARY KEY,
    CUSTOMER_ID NUMBER,
    LOAN_DUE_DATE DATE,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID)
);

-- Insert data
INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, AGE, LOAN_INTEREST_RATE, BALANCE, IS_VIP) VALUES (1, 'John Doe', 65, 5.5, 15000, FALSE);
INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, AGE, LOAN_INTEREST_RATE, BALANCE, IS_VIP) VALUES (2, 'Jane Smith', 45, 6.0, 8000, FALSE);
INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, AGE, LOAN_INTEREST_RATE, BALANCE, IS_VIP) VALUES (3, 'Jim Brown', 70, 4.5, 20000, FALSE);
INSERT INTO LOANS (LOAN_ID, CUSTOMER_ID, LOAN_DUE_DATE) VALUES (1, 1, SYSDATE + 10);
INSERT INTO LOANS (LOAN_ID, CUSTOMER_ID, LOAN_DUE_DATE) VALUES (2, 2, SYSDATE + 40);
INSERT INTO LOANS (LOAN_ID, CUSTOMER_ID, LOAN_DUE_DATE) VALUES (3, 3, SYSDATE + 20);

--Scenario 1
DECLARE
    CURSOR customer_cursor IS
        SELECT customer_id, loan_interest_rate
        FROM CUSTOMERS
        WHERE age > 60;

    v_customer_id CUSTOMERS.customer_id%TYPE;
    v_loan_interest_rate CUSTOMERS.loan_interest_rate%TYPE;

BEGIN
    OPEN customer_cursor;

    LOOP
        FETCH customer_cursor INTO v_customer_id, v_loan_interest_rate;
        EXIT WHEN customer_cursor%NOTFOUND;
        UPDATE CUSTOMERS
        SET loan_interest_rate = v_loan_interest_rate - 1
        WHERE customer_id = v_customer_id;

        DBMS_OUTPUT.PUT_LINE('Updated customer ' || v_customer_id || ' loan interest rate to ' || (v_loan_interest_rate - 1));

    END LOOP;

    CLOSE customer_cursor;
    COMMIT;
END;
/
