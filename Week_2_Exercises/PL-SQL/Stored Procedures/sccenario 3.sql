-- Ensure the accounts table exists
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    balance NUMBER(15, 2)
);

-- Insert initial values if necessary
INSERT INTO accounts (account_id, balance) VALUES (1, 1000);
INSERT INTO accounts (account_id, balance) VALUES (2, 500);

-- Drop the procedure if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE TransferFunds';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if the procedure does not exist
END;
/

-- Create or replace the TransferFunds procedure
CREATE OR REPLACE PROCEDURE TransferFunds (
    p_from_account_id IN NUMBER,
    p_to_account_id IN NUMBER,
    p_amount IN NUMBER
) IS
    insufficient_funds EXCEPTION;
    v_from_balance accounts.balance%TYPE;
    v_to_balance accounts.balance%TYPE;
BEGIN
    -- Lock the rows for update to prevent race conditions
    SELECT balance INTO v_from_balance FROM accounts WHERE account_id = p_from_account_id FOR UPDATE;
    SELECT balance INTO v_to_balance FROM accounts WHERE account_id = p_to_account_id FOR UPDATE;

    -- Check if the source account has sufficient balance
    IF v_from_balance < p_amount THEN
        RAISE insufficient_funds;
    END IF;

    -- Perform the transfer
    UPDATE accounts
    SET balance = v_from_balance - p_amount
    WHERE account_id = p_from_account_id;

    UPDATE accounts
    SET balance = v_to_balance + p_amount
    WHERE account_id = p_to_account_id;

    -- Display the updated balances
    DBMS_OUTPUT.PUT_LINE('Transferred ' || TO_CHAR(p_amount) || ' from Account ID: ' || TO_CHAR(p_from_account_id) || ' to Account ID: ' || TO_CHAR(p_to_account_id));
    DBMS_OUTPUT.PUT_LINE('From Account New Balance: ' || TO_CHAR(v_from_balance - p_amount));
    DBMS_OUTPUT.PUT_LINE('To Account New Balance: ' || TO_CHAR(v_to_balance + p_amount));

    COMMIT;

EXCEPTION
    WHEN insufficient_funds THEN
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds in account ' || TO_CHAR(p_from_account_id));
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Example of executing the procedure
BEGIN
    TransferFunds(1, 2, 200);  -- Transfer 200 from account 1 to account 2
    TransferFunds(1, 2, 1000); -- Attempt to transfer 1000 from account 1 to account 2
END;
/
