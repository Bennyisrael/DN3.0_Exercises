CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(50),
    DATE_OF_BIRTH DATE,
    LOAN_INTEREST_RATE NUMBER(5, 2),
    BALANCE NUMBER(15, 2),
    IS_VIP CHAR(1)
);

INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, DATE_OF_BIRTH, LOAN_INTEREST_RATE, BALANCE, IS_VIP)
VALUES (1, 'John Doe', TO_DATE('1958-08-15', 'YYYY-MM-DD'), 5.5, 15000, 'F');

INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, DATE_OF_BIRTH, LOAN_INTEREST_RATE, BALANCE, IS_VIP)
VALUES (2, 'Jane Smith', TO_DATE('1980-05-20', 'YYYY-MM-DD'), 4.0, 20000, 'T');

INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, DATE_OF_BIRTH, LOAN_INTEREST_RATE, BALANCE, IS_VIP)
VALUES (3, 'Alice Johnson', TO_DATE('1990-11-30', 'YYYY-MM-DD'), 6.5, 25000, 'F');

INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, DATE_OF_BIRTH, LOAN_INTEREST_RATE, BALANCE, IS_VIP)
VALUES (4, 'Bob Brown', TO_DATE('1975-01-25', 'YYYY-MM-DD'), 3.5, 18000, 'T');

--CalculateAge function
CREATE OR REPLACE FUNCTION CalculateAge (
    p_date_of_birth IN DATE
) RETURN NUMBER IS
    v_age NUMBER;
BEGIN
    -- Calculate age in years
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, p_date_of_birth) / 12) INTO v_age FROM dual;
    RETURN v_age;
END;
/

DECLARE
    v_age NUMBER;
BEGIN
    v_age := CalculateAge(TO_DATE('1958-08-15', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Age of John Doe: ' || v_age);
    
    v_age := CalculateAge(TO_DATE('1980-05-20', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Age of Jane Smith: ' || v_age);
    
    v_age := CalculateAge(TO_DATE('1990-11-30', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Age of Alice Johnson: ' || v_age);
    
    v_age := CalculateAge(TO_DATE('1975-01-25', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Age of Bob Brown: ' || v_age);
END;
/
