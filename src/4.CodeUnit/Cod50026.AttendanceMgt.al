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
        AttendanceLine.Reset;
        AttendanceLine.SetRange("Employee No.", EmpNo);
        AttendanceLine.SetRange("Attendance Date", InitialDate);
        if not AttendanceLine.FindFirst then begin
            AttendanceLine.Init;
            AttendanceLine."Document No." := DocumentNo;
            AttendanceLine."Employee No." := EmpNo;
            AttendanceLine."Attendance Date" := InitialDate;
            AttendanceLine."Province Code" := Employee."Province Code";
            AttendanceLine."Province Name" := Employee."Province Name";
            AttendanceLine."Branch Code" := Employee."Branch Code";
            AttendanceLine."Branch Name" := Employee."Branch Name";
            AttendanceLine."Department Code" := Employee."Department Code";
            AttendanceLine."Department Name" := Employee."Department Name";
            //AttendanceLine.CopyFromAttendanceHeader(AttendanceHeader);
            AttendanceLine.Insert(false);
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

        EngNep.Reset; //Min 1.25.2023
        EngNep.SetRange("English Date", InitialDate);
        if EngNep.FindFirst then
            AttendanceLine.Week := EngNep.Week;
        AttendanceLine.Modify(false);

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
        AttendanceLog.Reset;
        AttendanceLog.SetCurrentKey("Log Time");
        AttendanceLog.SetAscending("Log Time", true);
        AttendanceLog.SetRange("Employee ID", EmployeeNo);
        AttendanceLog.SetRange(Date, InitialDate);
        if EmployeeWorkShift."Check In From" <> 0 then
            AttendanceLog.SetRange("Log Time", EmployeeWorkShift."Start Time" - TextToDuration(format(EmployeeWorkShift."Check In From")), EmployeeWorkShift."Start Time" + TextToDuration(format(EmployeeWorkShift."Check In From")));
        if AttendanceLog.FindFirst then begin
            exit(AttendanceLog."Log Time")
        end else
            exit(0T)
    end;

    local procedure GetCheckOutTime(InitialDate: Date; EmployeeWorkShift: Record "Employee Work Shift"; EmployeeNo: Code[20]; CheckInTime: Time): Time
    begin

        // Initialize attendance log query
        AttendanceLog.Reset;
        AttendanceLog.SetCurrentKey("Log Time");
        AttendanceLog.SetRange("Employee ID", EmployeeNo);
        if EmployeeWorkShift.OverNight then begin  // Determine search date based on overnight shift
            AttendanceLog.SetRange(Date, InitialDate + 1);
            if EmployeeWorkShift."Check Out From" <> 0 then
                AttendanceLog.SetRange("Log Time", EmployeeWorkShift."End Time" - TextToDuration(format(EmployeeWorkShift."Check Out From")), EmployeeWorkShift."End Time" + TextToDuration(format(EmployeeWorkShift."Check Out From")));
            AttendanceLog.SetAscending("Log Time", true);
            if AttendanceLog.Findfirst() then
                exit(AttendanceLog."Log Time");
            // If not found on next day, search same day after check-in
            AttendanceLog.Reset;
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
                AttendanceLog.Setfilter("Log Time", '>=%1', EmployeeWorkShift."Start Time" + TextToDuration(format(EmployeeWorkShift."Check Out From")));
            AttendanceLog.SetAscending("Log Time", false);
            if AttendanceLog.FindFirst then begin
                exit(AttendanceLog."Log Time");
            end;
            // No checkout time found
            exit(0T)
        end;
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
