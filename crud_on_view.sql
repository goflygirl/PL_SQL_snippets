-- custom PL/SQL because we are doing CRUD ON a view;

declare
    activity_type_missing EXCEPTION;
begin
    case :APEX$ROW_STATUS
    when 'C' then
    IF :activity_type = 'Absence' THEN
       INSERT INTO absences (months_month_id, employees_employee_id, type_id, h_planned, duration_h)
        VALUES (:MONTH_NAME, :EMPLOYEE_ID, :ACTIVITY_ID, :HOURS_PLANNED, :HOURS_CONSUMED);
    ELSIF :activity_type = 'Project' THEN
       INSERT INTO work_entries (months_month_id, projects_project_id, employees_employee_id, hours_planned, hours_consumed) 
        VALUES (:MONTH_NAME, :ACTIVITY_ID, :EMPLOYEE_ID, :HOURS_PLANNED, :HOURS_CONSUMED);
    ELSIF :activity_type = 'Investment' THEN
        INSERT INTO invest_entries (months_month_id, employees_employee_id, investments_investment_id, hours_planned, hours_consumed)
        VALUES(:MONTH_NAME, :EMPLOYEE_ID, :ACTIVITY_ID, :HOURS_PLANNED, :HOURS_CONSUMED);
    ELSIF :activity_type = 'Internal work' THEN null;
    ELSE
        RAISE activity_type_missing;
    END IF;
    when 'U' then
        IF :activity_type = 'Absence' THEN
            UPDATE absences
                SET h_planned = :hours_planned,
                    duration_h = :hours_consumed
                WHERE months_month_id = :month_id 
                AND employees_employee_id = :employee_id
                AND type_id = :activity_id;
        ELSIF :activity_type = 'Project' THEN
            UPDATE work_entries
                SET hours_planned = :hours_planned,
                    hours_consumed = :hours_consumed
                WHERE months_month_id = :month_id
                AND employees_employee_id = :employee_id
                AND projects_project_id = :activity_id;
        ELSIF :activity_type = 'Investment' THEN
            UPDATE invest_entries
                SET hours_planned = :hours_planned,
                    hours_consumed = :hours_consumed
                WHERE months_month_id = :month_id
                AND employees_employee_id = :employee_id
                AND investments_investment_id = :activity_id;
        ELSIF :activity_type = 'Internal work' THEN
            UPDATE intwork_entries
                SET  hours_planned = :hours_planned,
                     hours_consumed = :hours_consumed
                WHERE months_month_id = :month_id
                AND employees_employee_id = :employee_id
                AND internal_work_internal_work_id = :activity_id;
        ELSE
                RAISE activity_type_missing;
        END IF;
    when 'D' then
    --APEX_DEBUG.MESSAGE('Activity type: ' || :activity_type);
    --APEX_DEBUG.MESSAGE('Month id: ' || :month_id);
    --APEX_DEBUG.MESSAGE('Employee id: ' || :employee_id);
    --APEX_DEBUG.MESSAGE('Activity id: ' || :activity_id);
        IF :activity_type = 'Absence' THEN
            DELETE absences
            WHERE months_month_id = :month_id 
            AND employees_employee_id = :employee_id
            AND type_id = :activity_id;
        ELSIF :activity_type = 'Project' THEN
            DELETE work_entries
            WHERE months_month_id = :month_id
            AND employees_employee_id = :employee_id
            AND projects_project_id = :activity_id;
        ELSIF :activity_type = 'Investment' THEN
            DELETE invest_entries
            WHERE months_month_id = :month_id
            AND employees_employee_id = :employee_id
            AND investments_investment_id = :activity_id;
        ELSIF :activity_type = 'Internal work' THEN
            DELETE intwork_entries
            WHERE months_month_id = :month_id
            AND employees_employee_id = :employee_id
            AND internal_work_internal_work_id = :activity_id;
        ELSE
            RAISE activity_type_missing;
        END IF;
    end case;

    EXCEPTION
        when activity_type_missing then
        dbms_output.put_line('Activity type missing!');
end;