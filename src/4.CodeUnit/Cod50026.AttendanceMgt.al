codeunit 50026 "Attendance Mgt"
{
    procedure InsertAttendanceLine(EmpNo: Code[20]; InitialDate: date; DocumentNo: Code[20])
    var
        PayrollEngine: Codeunit "Payroll Engine";
        EmployeeWorkShift: Record "Employee Work Shift";
        CheckInTime, CheckOutTime : Time;
    begin
        Clear(AttendanceLine);
        Clear(Employee);
        Employee.get(EmpNo);
        UpdateEmployeeIDInAttendanceLog(); // you can skip it if employee id is updated during sync.
        AttendanceLine.Reset;
        AttendanceLine.SetRange("Employee No.", EmpNo);
        AttendanceLine.SetRange("Attendance Date", InitialDate);
        if not AttendanceLine.FindFirst then begin
            AttendanceLine.Init;
            AttendanceLine."Document No." := DocumentNo;
            AttendanceLine."Employee No." := EmpNo;
            AttendanceLine."Employee Name" := Employee."Full Name";
            AttendanceLine."Attendance Date" := InitialDate;
            AttendanceLine."Province Code" := Employee."Province Code";
            AttendanceLine."Province Name" := Employee."Province Name";
            AttendanceLine."Branch Code" := Employee."Branch Code";
            AttendanceLine."Branch Name" := Employee."Branch Name";
            AttendanceLine."Department Code" := Employee."Department Code";
            AttendanceLine."Department Name" := Employee."Department Name";
            AttendanceLine."Unit Code" := Employee."Unit Code";
            //AttendanceLine.CopyFromAttendanceHeader(AttendanceHeader);
            AttendanceLine.Insert();
        end;
        ShiftLine.Reset(); //Check for Approved WorkShift
        ShiftLine.SetRange("Roster Date", InitialDate);
        ShiftLine.SetRange("Employee No", EmpNo);
        ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
        ShiftLine.Setfilter("Substitute Type", '%1|%2', ShiftLine."Substitute Type"::" ", ShiftLine."Substitute Type"::"Added as Substitute");
        if ShiftLine.FindFirst() then
            AttendanceLine.Validate("Employee Working Shift", ShiftLine."Employee Work Shift")
        else
            AttendanceLine.Validate("Employee Working Shift", Employee."Employee Work Shift");

        if IsHoliday(InitialDate, EmpNo) then begin
            AttendanceLine."Day Type" := AttendanceLine."Day Type"::Holiday;
            AttendanceLine."Week Off Day" := 1;
            AttendanceLine."Holiday Remarks" := CalendarDescription;
        end else begin
            AttendanceLine."Day Type" := AttendanceLine."Day Type"::"Working Day";
            AttendanceLine."Holiday Remarks" := '';
            AttendanceLine."Week Off Day" := 0;
        end;
        EmployeeWorkShift.Get(AttendanceLine."Employee Working Shift");
        CheckInTime := GetCheckInTime(InitialDate, EmployeeWorkShift, EmpNo);
        if CheckInTime <> 0T then begin
            AttendanceLine.Validate("Check In Time", CheckInTime);
            AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
            AttendanceLine.Validate("Present Day", 1);
        end else
            Clear(AttendanceLine."Check In Time");
        //For check Out Get 
        CheckOutTime := GetCheckOutTime(InitialDate, EmployeeWorkShift, EmpNo, CheckInTime);
        if (CheckOutTime <> 0T) and (CheckInTime <> CheckOutTime) then begin
            AttendanceLine.Validate("Check Out Time", CheckOutTime);
            if AttendanceLine."Entry Type" <> AttendanceLine."Entry Type"::Present then begin
                AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
                AttendanceLine.Validate("Present Day", 1);
            end;
        end else
            Clear(AttendanceLine."Check Out Time");

        if Employee."Automatic Attendance" and (AttendanceLine."Day Type" = AttendanceLine."Day Type"::"Working Day") then begin
            AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
            AttendanceLine.Validate("Present Day", 1);
        end;

        EngNep.Reset;
        EngNep.SetLoadFields("English Date", Week);
        EngNep.SetRange("English Date", InitialDate);
        if EngNep.FindFirst then
            AttendanceLine.Week := EngNep.Week;
        AttendanceLine.Modify();

        PayrollEngine.PrepareEmployeeDailyActivity(AttendanceLine."Employee No.", InitialDate, InitialDate, true);
    end;

    procedure IsHoliday(Date: Date; EmpNo: Code[20]): Boolean
    var
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        ReturnBool: Boolean;
    begin
        ReturnBool := false;
        Clear(CalendarDescription);
        ReturnBool := LeaveMgt.GetNonWorkingDays(Date, Date, EmpNo) <> 0;
        CalendarDescription := HRMgt.ReturnCalendarDescription;
        exit(ReturnBool);
    end;

    procedure TextToDuration(InputText: Text): Duration
    var
        Millisec: BigInteger;
    begin
        if not Evaluate(Millisec, InputText) then
            exit;

        exit(Millisec * 3600000); // Convert milliseconds to duration
    end;

    local procedure GetCheckInTime(InitialDate: Date; EmployeeWorkShift: Record "Employee Work Shift"; EmployeeNo: Code[20]): Time
    begin
        // Initialize attendance log query
        AttendanceLog.Reset;
        AttendanceLog.SetLoadFields(Date, "Log Time", "Employee ID");
        AttendanceLog.SetCurrentKey("Log Time");
        AttendanceLog.SetRange("Employee ID", EmployeeNo);
        if EmployeeWorkShift.OverNight then begin  // Determine search date based on overnight shift
            AttendanceLog.SetRange(Date, InitialDate);
            if EmployeeWorkShift."Check In From" <> 0 then
                AttendanceLog.SetRange("Log Time", (EmployeeWorkShift."Start Time" - EmployeeWorkShift."Check In From"), (EmployeeWorkShift."Start Time" + EmployeeWorkShift."Check In From"));
            AttendanceLog.SetAscending("Log Time", false);
            if AttendanceLog.Findfirst() then begin
                exit(AttendanceLog."Log Time");
            end else
                exit(0T);
        end else begin
            // Regular shift - search same day
            AttendanceLog.SetRange(Date, InitialDate);
            if EmployeeWorkShift."Check In From" <> 0 then
                AttendanceLog.SetRange("Log Time", (EmployeeWorkShift."Start Time" - EmployeeWorkShift."Check In From"), (EmployeeWorkShift."Start Time" + EmployeeWorkShift."Check In From"));
            AttendanceLog.SetAscending("Log Time", true);
            if AttendanceLog.FindFirst then begin
                exit(AttendanceLog."Log Time")
            end else
                exit(0T);
        end;
    end;

    local procedure GetCheckOutTime(InitialDate: Date; EmployeeWorkShift: Record "Employee Work Shift"; EmployeeNo: Code[20]; CheckInTime: Time): Time
    begin
        // Initialize attendance log query
        AttendanceLog.Reset;
        AttendanceLog.SetLoadFields(Date, "Log Time", "Employee ID");
        AttendanceLog.SetCurrentKey("Log Time");
        AttendanceLog.SetRange("Employee ID", EmployeeNo);
        if EmployeeWorkShift.OverNight then begin  // Determine search date based on overnight shift
            AttendanceLog.SetRange(Date, InitialDate + 1);
            if EmployeeWorkShift."Check Out From" <> 0 then
                AttendanceLog.SetRange("Log Time", (EmployeeWorkShift."End Time" - EmployeeWorkShift."Check Out From"), (EmployeeWorkShift."End Time" + EmployeeWorkShift."Check Out From"));
            AttendanceLog.SetAscending("Log Time", true);
            if AttendanceLog.Findfirst() then
                exit(AttendanceLog."Log Time");
            // If not found on next day, search same day after check-in
            AttendanceLog.Reset;
            AttendanceLog.SetLoadFields(Date, "Log Time", "Employee ID");
            AttendanceLog.SetCurrentKey("Log Time");
            AttendanceLog.SetRange("Employee ID", EmployeeNo);
            AttendanceLog.SetRange(Date, InitialDate);
            AttendanceLog.SetFilter("Log Time", '>%1', CheckInTime);
            AttendanceLog.SetAscending("Log Time", false);
            if AttendanceLog.FindFirst() then
                exit(AttendanceLog."Log Time")

        end else begin
            // Regular shift - search same day
            AttendanceLog.SetRange(Date, InitialDate);
            AttendanceLog.SetFilter("Log Time", '>%1', CheckInTime);
            if EmployeeWorkShift."Check Out From" <> 0 then
                AttendanceLog.Setfilter("Log Time", '>=%1', EmployeeWorkShift."Start Time" + EmployeeWorkShift."Check Out From");
            AttendanceLog.SetAscending("Log Time", false);
            if AttendanceLog.FindFirst then begin
                exit(AttendanceLog."Log Time");
            end;
            // No checkout time found
            exit(0T)
        end;
    end;

    procedure UpdateEmployeeIDInAttendanceLog()
    begin
        AttendanceLog.Reset();
        AttendanceLog.SetRange("Employee ID", '');
        if AttendanceLog.FindSet() then begin
            AttendanceLog."Employee ID" := GetEmployeeIDFromBiometric(AttendanceLog."Machine Emp. Code");
            AttendanceLog.Modify();
        end;
    end;

    procedure GetEmployeeIDFromBiometric(BiometricID: Text): code[20]
    var
        Employee: Record Employee;
    begin
        Employee.SetLoadFields("No.", "Employee Attendance ID");
        Employee.SetRange("Employee Attendance ID", BiometricID);
        if Employee.FindFirst() then
            exit(Employee."No.")
    end;

    procedure DailyAttendanceUpdate(StartDate: Date; EndDate: Date; EmployeeNo: Code[20]): Boolean
    var
        DailyAttendanceUpdate: Report "Daily Attendance Update";
    begin
        // Update Daily Attendance
        DailyAttendanceUpdate.SetRequestFilterValue(StartDate, EndDate, EmployeeNo);
        DailyAttendanceUpdate.UseRequestPage(false);
        DailyAttendanceUpdate.Run();
        exit(true);
    end;

    procedure GetPresentDays(EmpCode: Code[20]; PStartDate: Date; PEndDate: Date): Decimal
    var
        EmpAtt: Record "Employee Attendance & Activity";
        actualPresentDays, PresentDay : Decimal;
        AttendanceDate: Date;
    begin
        actualPresentDays := 0;
        Clear(AttendanceDate);
        EmpAtt.Reset();
        EmpAtt.SetRange("Employee No.", EmpCode);
        EmpAtt.SetRange("Attendance Date", PStartDate, PEndDate);
        EmpAtt.CalcSums("Present Day", "Week Off Day", "Tour Day", "Training Day", "Leave Day");
        // if EmpAtt.FindSet() then
        //     repeat
        //         Clear(PresentDay);
        //         if AttendanceDate <> EmpAtt."Attendance Date" then begin
        //             if EmpAtt."Present Day" + EmpAtt."Week Off Day" + EmpAtt."Tour Day" + EmpAtt."Training Day" + EmpAtt."Leave Day" > 0 then begin
        //                 actualPresentDays += 1;
        //                 PresentDay := 1;
        //             end;
        //             if PresentDay > 0 then
        //                 AttendanceDate := EmpAtt."Attendance Date";
        //         end;
        //     until EmpAtt.Next() = 0;
        actualPresentDays := EmpAtt."Present Day" + EmpAtt."Week Off Day" + EmpAtt."Tour Day" + EmpAtt."Training Day" + EmpAtt."Leave Day";
        exit(actualPresentDays);
    end;

    procedure GetLeaveDays(EmpCode: Code[20]; LeaveCodeFilter: Code[150]; PStartDate: Date; PEndDate: Date): Decimal
    var
        EmpAtt, EmpAtt1 : Record "Employee Attendance & Activity";
        LeaveDays: Decimal;
        AttendanceDate: Date;
    begin
        Clear(LeaveDays);
        Clear(AttendanceDate);
        //unlock this code if leave can't earn in some specific leave
        // EmpAtt.Reset();   
        // EmpAtt.SetRange("Employee No.", EmpCode);
        // EmpAtt.SetRange("Attendance Date", PStartDate, PEndDate);
        // EmpAtt.SetFilter("Leave Code", LeaveCodeFilter);
        // EmpAtt.SetRange("Attendance Status 2", EmpAtt."Attendance Status 2"::LEAVE);
        // EmpAtt.SetRange("Present Day", 0);
        // if EmpAtt.FindSet() then
        //     repeat
        //         if AttendanceDate <> EmpAtt."Attendance Date" then
        //             LeaveDays += 1;
        //         AttendanceDate := EmpAtt."Attendance Date";

        //         EmpAtt1.Reset();
        //         EmpAtt1.SetRange("Employee No.", EmpAtt."Employee No.");
        //         EmpAtt1.SetRange("Attendance Date", EmpAtt."Attendance Date");
        //         EmpAtt1.SetRange("Leave Code", EmpAtt."Leave Code");
        //         EmpAtt1.SetRange("Present Day", 1);
        //         if EmpAtt1.FindFirst() then
        //             LeaveDays -= 1;
        //     until EmpAtt.Next() = 0;
        // exit(LeaveDays);
    end;

    var
        AttendanceLine: Record "Attendance Line";
        AttendanceLog: Record "Attendance Log";
        EngNep: Record "English-Nepali Date";
        CalendarDescription: Text;
        ShiftLine: Record "Shift Line";
        Employee: Record Employee;
        AttendanceSetUp: Record "Attendance Setup";

}
