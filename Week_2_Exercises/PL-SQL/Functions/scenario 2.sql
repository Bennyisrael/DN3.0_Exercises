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


CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment (
    p_loan_amount IN NUMBER,
    p_interest_rate IN NUMBER,
    p_loan_duration_years IN NUMBER
) RETURN NUMBER IS
    v_monthly_installment NUMBER;
    v_monthly_interest_rate NUMBER;
    v_total_months NUMBER;
BEGIN
    v_monthly_interest_rate := p_interest_rate / 12 / 100;
    v_total_months := p_loan_duration_years * 12;
    
    v_monthly_installment := p_loan_amount * (v_monthly_interest_rate * POWER(1 + v_monthly_interest_rate, v_total_months)) / (POWER(1 + v_monthly_interest_rate, v_total_months) - 1);
    
    RETURN v_monthly_installment;
END;
/

SET SERVEROUTPUT ON;
DECLARE
    v_installment NUMBER;
BEGIN
    v_installment := CalculateMonthlyInstallment(10000, 5, 15); -- Loan amount: 10000, Interest rate: 5%, Duration: 15 years
    DBMS_OUTPUT.PUT_LINE('Monthly Installment for $10,000 loan: ' || TO_CHAR(v_installment, 'FM9999.99'));
    
    v_installment := CalculateMonthlyInstallment(20000, 4, 10); -- Loan amount: 20000, Interest rate: 4%, Duration: 10 years
    DBMS_OUTPUT.PUT_LINE('Monthly Installment for $20,000 loan: ' || TO_CHAR(v_installment, 'FM9999.99'));
    
    v_installment := CalculateMonthlyInstallment(5000, 6.5, 5); -- Loan amount: 5000, Interest rate: 6.5%, Duration: 5 years
    DBMS_OUTPUT.PUT_LINE('Monthly Installment for $5,000 loan: ' || TO_CHAR(v_installment, 'FM9999.99'));
    
    v_installment := CalculateMonthlyInstallment(15000, 3.5, 20); -- Loan amount: 15000, Interest rate: 3.5%, Duration: 20 years
    DBMS_OUTPUT.PUT_LINE('Monthly Installment for $15,000 loan: ' || TO_CHAR(v_installment, 'FM9999.99'));
END;
/
