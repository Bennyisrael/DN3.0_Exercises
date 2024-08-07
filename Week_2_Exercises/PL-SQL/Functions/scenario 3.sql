-- Ensure the accounts table exists
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    balance NUMBER(15, 2)
);

-- Insert sample data into accounts table
INSERT INTO accounts (account_id, balance) VALUES (1, 1000);
INSERT INTO accounts (account_id, balance) VALUES (2, 500);
INSERT INTO accounts (account_id, balance) VALUES (3, 750);
INSERT INTO accounts (account_id, balance) VALUES (4, 1200);

CREATE OR REPLACE FUNCTION HasSufficientBalance (
    p_account_id IN NUMBER,
    p_amount IN NUMBER
) RETURN BOOLEAN IS
    v_balance NUMBER;
BEGIN
    SELECT balance INTO v_balance FROM accounts WHERE account_id = p_account_id;
    
    RETURN v_balance >= p_amount;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;
/

DECLARE
    v_has_balance BOOLEAN;
BEGIN
    v_has_balance := HasSufficientBalance(1, 500); 
    DBMS_OUTPUT.PUT_LINE('Account 1 has sufficient balance for 500: ' || CASE WHEN v_has_balance THEN 'Yes' ELSE 'No' END);
    
    v_has_balance := HasSufficientBalance(2, 600); 
    DBMS_OUTPUT.PUT_LINE('Account 2 has sufficient balance for 600: ' || CASE WHEN v_has_balance THEN 'Yes' ELSE 'No' END);
    
    v_has_balance := HasSufficientBalance(3, 700); 
    DBMS_OUTPUT.PUT_LINE('Account 3 has sufficient balance for 700: ' || CASE WHEN v_has_balance THEN 'Yes' ELSE 'No' END);
    
    v_has_balance := HasSufficientBalance(4, 1000); 
    DBMS_OUTPUT.PUT_LINE('Account 4 has sufficient balance for 1000: ' || CASE WHEN v_has_balance THEN 'Yes' ELSE 'No' END);
END;
/
