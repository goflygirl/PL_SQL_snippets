-- anonymous PL/SQL block
-- Displays all of the classes a student has been enrolled in within the most recent 10 years.
DECLARE
    v_stu_id enrollments.stu_id%TYPE := :student_id;
    v_enrollment_date enrollments.enrollment_date%TYPE;
    v_class_id enrollments.class_id%TYPE;
    v_status enrollments.status%TYPE;

    -- Cursor to fetch multiple records
    CURSOR c_enrollments IS
        SELECT 
            enrollment_date,
            class_id,
            status
        FROM enrollments
        WHERE stu_id = v_stu_id
        AND enrollment_date BETWEEN add_months(trunc(SYSDATE), -12*10) AND SYSDATE
        ORDER BY enrollment_date;

BEGIN
    -- Open cursor and loop through each row
    OPEN c_enrollments;
    LOOP
        FETCH c_enrollments INTO v_enrollment_date, v_class_id, v_status;
        EXIT WHEN c_enrollments%NOTFOUND;
        -- Output the result for each row
        dbms_output.put_line('Enrollment Date: ' || v_enrollment_date || ', Class ID: ' || v_class_id || ', Status: ' || v_status);
    END LOOP;
    CLOSE c_enrollments;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Error: Data not found!');
    WHEN OTHERS THEN
        dbms_output.put_line('An unexpected error occurred: ' || SQLERRM);
END;
