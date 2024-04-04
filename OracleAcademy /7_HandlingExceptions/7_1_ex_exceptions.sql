--7.1
--introducing an exception handler into the PL/SQL block
--learning about predefined server errors
-- how PL/SQL handles exceptions in nested blocks


--Example 1
--SELECT highest_elevation 
--FROM wf_countries;

DECLARE

v_country_name wf_countries.country_name%TYPE := 'Korea, South';
v_elevation wf_countries.highest_elevation%TYPE;
BEGIN

SELECT highest_elevation
INTO v_elevation
FROM wf_countries
WHERE country_name = v_country_name;
DBMS_OUTPUT.PUT_LINE(v_elevation); --does not execute because the SELECT statement fails
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Country name ' || v_country_name || ' cannot be found. Re-enter the country name using the correct spelling.');
END;


--Example 2

--SELECT * 
--FROM emp;

DECLARE

v_lastname VARCHAR(15);
BEGIN

SELECT ename INTO v_lastname
FROM emp
WHERE job = 'CLERK';
DBMS_OUTPUT.PUT_LINE('The last name of the CLERK is: ' || v_lastname); --this fails as there are more than one CLERK in the data 
EXCEPTION 
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Your select statement retrieved multiple rows. Consider using a cursor.');
END;

--Practice 4
DECLARE
v_emp_no emp.empno%TYPE;

BEGIN
    SELECT empno INTO v_emp_no
    FROM emp
    WHERE deptno = 30; --this SELECT statement will fail as there are multiple results in this dataset

    EXCEPTION WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Your select statement retrieved multiple rows. Consider using a cursor.');
END;

--Practice 5
--Run the following PL/SQLblock, which tries to insert a new row (with department_id=50)into the departments table. What happens and why?
--SELECT * 
--FROM dept;

BEGIN
    INSERT INTO dept (deptno, dname, loc)
VALUES (50, 'A new department', 1500);
DBMS_OUTPUT.PUT_LINE('The new department was inserted'); 
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE ('An exception has occurred.');
END;


-- Practice 6
CREATE TABLE emp_temp AS SELECT * FROM emp;

DELETE 
FROM emp_temp
WHERE empno = 7934;

DECLARE
v_employee_id emp_temp.empno%TYPE; 
v_last_name emp_temp.ename%TYPE;

BEGIN
    SELECT empno, ename INTO v_employee_id, v_last_name
    FROM emp_temp
    WHERE deptno = 10; -- run with values 10, 20, and 30 
    DBMS_OUTPUT.PUT_LINE('The SELECT was successful');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There is no employee data with this deptno.'); 
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('There are more than one employees in this deptno. Consider using a cursor to fetch data.'); 
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An exception has occurred'); 
END;


--Practice 11

DECLARE
v_number NUMBER(4);
BEGIN
v_number := 1234;
DECLARE
v_number NUMBER(4);
BEGIN
v_number := 5678;
v_number := 'A character string';
--added this exception block later
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception has occurred'); 
        DBMS_OUTPUT.PUT_LINE('The number is: ' || v_number);
END; 
--when the nested exception is not added it outputs the outer v_number, ie 1234
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception has occurred'); 
        DBMS_OUTPUT.PUT_LINE('The number is: ' || v_number);
END;