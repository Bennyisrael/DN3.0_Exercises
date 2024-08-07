CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    balance NUMBER(15, 2)
);

INSERT INTO accounts (account_id, balance) VALUES (1, 1000);
INSERT INTO accounts (account_id, balance) VALUES (2, 500);
INSERT INTO accounts (account_id, balance) VALUES (3, 10000);
INSERT INTO accounts (account_id, balance) VALUES (4, 61000);

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
    v_account_id accounts.account_id%TYPE;
    v_balance accounts.balance%TYPE;
    v_interest_rate CONSTANT NUMBER := 0.01;
BEGIN
    FOR account_rec IN (SELECT account_id, balance FROM accounts) LOOP
        v_account_id := account_rec.account_id;
        v_balance := account_rec.balance;
        v_balance := v_balance * (1 + v_interest_rate);

        UPDATE accounts
        SET balance = v_balance
        WHERE account_id = v_account_id;

        DBMS_OUTPUT.PUT_LINE('Account ID: ' || v_account_id || ' - New Balance: ' || v_balance);
    END LOOP;

    COMMIT;
END;
/

BEGIN
    ProcessMonthlyInterest;
END;
/
