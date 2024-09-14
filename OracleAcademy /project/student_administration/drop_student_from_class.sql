DECLARE

v_stu_id enrollments.stu_id%TYPE := :student_id;
v_class_id enrollments.class_id%TYPE := :class_id;
v_enrollment_date enrollments.enrollment_date%TYPE := SYSDATE;
v_status enrollments.status%TYPE := 'Enrolled';
v_stu_exists NUMBER := 0;
v_class_exists NUMBER := 0;

BEGIN
    -- Check if the class exists
    -- COUNT(1) will return 0 if no record exist or 1 if a record exist
    SELECT COUNT(1)
    INTO v_class_exists
    FROM classes
        WHERE class_id = v_class_id;


    -- Check if the student exists
    SELECT COUNT(1)
    INTO v_stu_exists
    FROM students
        WHERE stu_id = v_stu_id;
     
    IF v_class_exists > 0 AND v_stu_exists > 0 THEN
                    
            DELETE FROM enrollments
            WHERE stu_id = v_stu_id
            AND class_id = v_class_id;
        DBMS_OUTPUT.PUT_LINE('The student with an ID ' || v_stu_id || 'has been dropped from the class ' || v_class_id || ' successfully.');
    ELSE
        RAISE_APPLICATION_ERROR(-20111, 'The student or the class does not exist! No enrollments are dropped.');
    END IF;

    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Error: Data not found!');
    WHEN OTHERS THEN
        dbms_output.put_line('An unexpected error occurred: ' || SQLERRM);
END;