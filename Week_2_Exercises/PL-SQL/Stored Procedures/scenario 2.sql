CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    salary NUMBER(15, 2),
    department VARCHAR2(50)
);

INSERT INTO employees (employee_id, salary, department) VALUES (1, 50000, 'HR');
INSERT INTO employees (employee_id, salary, department) VALUES (2, 60000, 'IT');
INSERT INTO employees (employee_id, salary, department) VALUES (3, 35000, 'TL');

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_department IN VARCHAR2,
    p_bonus_percentage IN NUMBER
) IS
    v_employee_id employees.employee_id%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    FOR employee_rec IN (SELECT employee_id, salary FROM employees WHERE department = p_department) LOOP
        v_employee_id := employee_rec.employee_id;
        v_salary := employee_rec.salary;
        v_salary := v_salary * (1 + p_bonus_percentage / 100);

        UPDATE employees
        SET salary = v_salary
        WHERE employee_id = v_employee_id;

        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id || ' - New Salary: ' || v_salary);
    END LOOP;

    COMMIT;
END;
/

BEGIN
    UpdateEmployeeBonus('IT', 10); 
END;
/
