--anonimni blok, ki klice proceduro

DECLARE 
    l_ime_case varchar2(100);
BEGIN
    l_ime_case := 'Ines Repnik';

    izpisi_tekst(
        p_kolikokrat_izpis => 3,
        p_male_crke_dn => 'N',
        p_ime_case => l_ime_case
    );
    
    dbms_output.put_line('moja lokalna spremenljvika l_ime_case: ' || l_ime_case);
END;



--komentarji v SQL
SELECT
    empno, 
    ename, 
    job, 
    mgr, 
    hiredate,   --DODANO KER JE ALES TAKO HOTEL 12.3.2024
    /*
    sal, 
    comm,
    */
    /*SAMO ENA VRSTICA*/ 
    deptno
FROM EBA_DEMO_IR_EMP
;



--primer procedure
CREATE OR REPLACE PROCEDURE izpisi_tekst (
    p_kolikokrat_izpis number,
    p_male_crke_dn varchar2 default 'D',
    p_ime_case IN OUT varchar2
) AS 

    l_ime char(50);
    l_priimek varchar2(50 char);
    l_leto_rojstva number(4, 0);
    --l_datum_prve_zaposlitve date;
    l_mesto_bivanja varchar2(100) := 'Ljubljana';
    l_zaposlen boolean := true;
    
BEGIN

    l_ime := 'Zoran';
    l_priimek := 'Zlatica';
    
    p_ime_case := lower(p_ime_case);
    
    dbms_output.put_line('p_male_crke_dn: ' || p_male_crke_dn);
    --p_male_crke_dn := 'D';
    
    dbms_output.put_line(l_ime);
    dbms_output.put_line(l_priimek);
    dbms_output.put_line(l_mesto_bivanja);

    dbms_output.put_line( rtrim(l_ime) || ' ' || l_priimek);
    
    dbms_output.put_line(sysdate + 2);
    dbms_output.put_line('nek tekst ' || to_char(sysdate, 'mm/dd/yyyy hh:mi:ss') );
    dbms_output.put_line('nek tekst ' || to_char(1276546.56, 'fm999G999G999G999G999D0000') );
    
                                --01276546.5600

END izpisi_tekst;
    


--primer funkcije
CREATE OR REPLACE FUNCTION male_crke (
    p_ime varchar2
) RETURN varchar2 AS
    l_male_crke varchar2(100);
BEGIN
    l_male_crke := lower(p_ime);
    
    RETURN l_male_crke;
END male_crke;



--primer SQL v PLSQL
CREATE OR REPLACE FUNCTION iniciali (
    p_empno number
) RETURN varchar2 AS

    l_iniciali varchar2(2);

BEGIN
    SELECT substr(ename, 1, 1) || substr(job, 1, 1) as inciali_stolpec
    INTO l_iniciali
    FROM eba_demo_ir_emp  
    WHERE empno = p_empno
    ;
    
    RETURN l_iniciali;

END iniciali;



--SQL v PLSQL - 2 podatka/stolpca iz SELECT-a v 2 spremenljivki
CREATE OR REPLACE FUNCTION iniciali2 (
    p_empno number
) RETURN varchar2 AS

    l_ime eba_demo_ir_emp.ename%TYPE;
    l_pozicija varchar2(100);

BEGIN
    SELECT 
        ename,
        job
    INTO 
        l_ime,
        l_pozicija
    FROM eba_demo_ir_emp  
    WHERE empno = p_empno
    ;

    SELECT 
        ename,
        job
    INTO 
        l_ime,
        l_pozicija
    FROM eba_demo_ir_emp  
    WHERE empno = p_empno
    ;

    SELECT 
        ename,
        job
    INTO 
        l_ime,
        l_pozicija
    FROM eba_demo_ir_emp  
    WHERE empno = p_empno
    ;

    
    RETURN substr(l_ime, 1, 1) || substr(l_pozicija, 1, 1);

END iniciali2;



--uporaba funkcije v SQL-u (SELECT)
SELECT
    empno,
    iniciali(empno) as iniciali_stolpec,
    ename
FROM eba_demo_ir_emp  




--"bind" variabla
SELECT substr(ename, 1, 1) || substr(job, 1, 1) as inciali_stolpec
FROM eba_demo_ir_emp  
WHERE empno = :l_empno
;


--klic funkcije iz PLSQL
DECLARE 
    l_ime_case varchar2(100);
BEGIN
    l_ime_case := male_crke (
        p_ime => 'Ines Repnik'
    );
    
    dbms_output.put_line('moja lokalna spremenljvika l_ime_case: ' || l_ime_case);
END;



--cursor + lokalna sub-procedura
CREATE OR REPLACE FUNCTION iniciali3 (
    p_empno1 eba_demo_ir_emp.empno%TYPE, 
    p_empno2 eba_demo_ir_emp.empno%TYPE,
    p_empno3 eba_demo_ir_emp.empno%TYPE 
) RETURN varchar2 AS

    l_ime eba_demo_ir_emp.ename%TYPE;
    l_pozicija varchar2(100);
    l_menadzer eba_demo_ir_emp.mgr%TYPE;

    CURSOR c_emp_data (
        p_empno eba_demo_ir_emp.empno%TYPE 
    ) IS
        SELECT 
            ename,
            job,
            mgr
        FROM eba_demo_ir_emp  
        WHERE empno = p_empno
    ;

    PROCEDURE p_fetch_employee_data_because_of_reusability (
        p_empno eba_demo_ir_emp.empno%TYPE 
    ) IS
    BEGIN
        OPEN c_emp_data(p_empno => p_empno);
        
        FETCH c_emp_data 
        INTO 
            l_ime, 
            l_pozicija,
            l_menadzer
        ;
        
        CLOSE c_emp_data;
    
    END p_fetch_employee_data_because_of_reusability;

BEGIN
    p_fetch_employee_data_because_of_reusability(p_empno => p_empno1);
    p_fetch_employee_data_because_of_reusability(p_empno => p_empno2);
    p_fetch_employee_data_because_of_reusability(p_empno => p_empno3);

    RETURN substr(l_ime, 1, 1) || substr(l_pozicija, 1, 1);

END iniciali3;



--primer cursor + rowtype spremenljivka
CREATE OR REPLACE FUNCTION iniciali4 (
    p_empno1 eba_demo_ir_emp.empno%TYPE, 
    p_empno2 eba_demo_ir_emp.empno%TYPE,
    p_empno3 eba_demo_ir_emp.empno%TYPE 
) RETURN varchar2 AS

    CURSOR c_emp_data (
        p_empno eba_demo_ir_emp.empno%TYPE 
    ) IS
        SELECT 
            ename as ime,
            job,
            mgr,
            iniciali(empno) as inic
        FROM eba_demo_ir_emp  
        WHERE empno = p_empno
    ;
    
    l_emp_data c_emp_data%ROWTYPE;
    l_emp_data2 c_emp_data%ROWTYPE;
    l_emp_data3 c_emp_data%ROWTYPE;

    PROCEDURE p_fetch_employee_data_because_of_reusability (
        p_empno eba_demo_ir_emp.empno%TYPE 
    ) IS
    BEGIN
        OPEN c_emp_data(p_empno => p_empno);
        
        FETCH c_emp_data 
        INTO l_emp_data
        ;
        
        CLOSE c_emp_data;
    
    END p_fetch_employee_data_because_of_reusability;

BEGIN
    p_fetch_employee_data_because_of_reusability(p_empno => p_empno1);
    p_fetch_employee_data_because_of_reusability(p_empno => p_empno2);
    p_fetch_employee_data_because_of_reusability(p_empno => p_empno3);
    
    RETURN l_emp_data.inic;

END iniciali4;




--tabela + rowtype spremenljivka + SELECT * INTO rowtype spremenljivka
--IF stavek
--CASE stavek
--INSERT DML operacija v SQL + returning into (da dobis PK vrednost novega zapisa)
CREATE OR REPLACE FUNCTION iniciali5 (
    p_empno1 eba_demo_ir_emp.empno%TYPE, 
    p_empno2 eba_demo_ir_emp.empno%TYPE,
    p_empno3 eba_demo_ir_emp.empno%TYPE,
    p_sallary number
) RETURN varchar2 AS

    l_zaposleni eba_demo_ir_emp%ROWTYPE;
    
    l_zaposlen_pk eba_demo_ir_emp.empno%TYPE; 
    l_sallary number;

BEGIN
    if p_sallary > 3000 then
        dbms_output.put_line('Previse');
        dbms_output.put_line('Ne moze');
        RAISE_APPLICATION_ERROR(-20001, 'Ne more toliko placilo');
    
    elsif p_sallary between 3000 and 5000 then
        null;
        
    else
        dbms_output.put_line('ma daaaaaaaaaaaaaaaaaj');
        

    end if;
    
    if p_sallary < 3000 then
        l_sallary := p_sallary;
    elsif p_sallary between 3000 and 5000 then
        l_sallary := 3000 + p_sallary * 10 / 100;
    else
        l_sallary := 5000;
    end if;
    
    l_sallary := 
        CASE
            WHEN p_sallary < 3000 THEN p_sallary
            WHEN p_sallary between 3000 and 5000 THEN 3000 + p_sallary * 10 / 100
            ELSE 5000
        END
    ;
        
        

    SELECT 
        *
    INTO l_zaposleni
    FROM eba_demo_ir_emp  
    WHERE empno = p_empno1;
    
    INSERT INTO eba_demo_ir_emp (ename, job)
    VALUES ('ZORAN', 'MGR')
    RETURNING empno INTO l_zaposlen_pk
    ;
    
    
    RETURN l_zaposlen_pk;

END iniciali5;



--CASE v SQL - primer za izracun podatka in primer za sortiranje
SELECT
    empno, ename, sal, job,
    CASE 
        WHEN sal > 3000 or job = 'MANAGER' THEN 'ohoho'
        WHEN sal between 1500 and 3000 THEN 'ajde'
        ELSE 'bogi'
    END as sal_komentar
FROM eba_demo_ir_emp 
;

SELECT
    empno, ename, sal, job,
    CASE 
        WHEN sal > 3000 or job = 'MANAGER' THEN 'ohoho'
        WHEN sal between 1500 and 3000 THEN 'ajde'
        ELSE 'bogi'
    END as sal_komentar
FROM eba_demo_ir_emp 
ORDER BY 
    CASE 
        WHEN job = 'PRESIDENT' THEN 1
        WHEN job = 'MANAGER' THEN 2
        WHEN job = 'ANALYST' THEN 3
        ELSE 99
    END,
    ename
;



--primer paketa - specifikacija + body - klic procedure iz paketa
CREATE OR REPLACE PACKAGE ucenje_pkg AS

g_tekst_global varchar2(100);


/*
PROCEDURE izpis (
    p_text varchar2
);
*/

FUNCTION kvadrat (
    p_stevilka number
) RETURN number;

END ucenje_pkg;



CREATE OR REPLACE PACKAGE BODY ucenje_pkg AS

g_tekst varchar2(100) := 'http://google.com';


PROCEDURE izpis (
    p_text varchar2
) AS
BEGIN
    g_tekst := 'aloha';

    dbms_output.put_line(p_text);
END izpis;


FUNCTION kvadrat (
    p_stevilka number
) RETURN number AS
BEGIN
    g_tekst := 'aloha 2';

    izpis('moj tekst');

    RETURN p_stevilka * p_stevilka;
END kvadrat;

END ucenje_pkg;



BEGIN
    ucenje_pkg.izpis(p_text => 'moj tekst');
END;