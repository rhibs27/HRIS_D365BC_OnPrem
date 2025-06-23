codeunit 50026 "Attendance Mgt"
{
    procedure InsertAttendanceLine(EmpNo: Code[20]; InitialDate: date; DocumentNo: Code[20])
    var
        PayrollEngine: Codeunit "Payroll Engine";

    begin
        Clear(AttendanceLine);
        AttendanceSetUp.Get();
        Employee.get(EmpNo);
        AttendanceLine.Reset;
        AttendanceLine.SetRange("Employee No.", EmpNo);
        AttendanceLine.SetRange("Attendance Date", InitialDate);
        if not AttendanceLine.FindFirst then begin
            AttendanceLine.Init;
            AttendanceLine."Document No." := DocumentNo;
            AttendanceLine."Employee No." := EmpNo;

            ShiftLine.Reset(); //Check for Approved WorkShift
            ShiftLine.SetRange("Roster Date", InitialDate);
            ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
            if ShiftLine.FindFirst() then
                AttendanceLine.Validate("Employee Working Shift", ShiftLine."Employee Work Shift")
            else
                AttendanceLine.Validate("Employee Working Shift", Employee."Employee Work Shift");
            AttendanceLine."Attendance Date" := InitialDate;
            //AttendanceLine.CopyFromAttendanceHeader(AttendanceHeader);
            AttendanceLine.Insert(false);
        end;

        if IsHoliday(InitialDate, EmpNo) then begin
            AttendanceLine."Day Type" := AttendanceLine."Day Type"::Holiday;
            AttendanceLine."Week Off Day" := 1;
            AttendanceLine."Holiday Remarks" := CalendarDescription;
        end else begin
            AttendanceLine."Day Type" := AttendanceLine."Day Type"::"Working Day";
            AttendanceLine."Holiday Remarks" := '';
            AttendanceLine."Week Off Day" := 0;
        end;
        //For Check IN Time Get
        AttendanceLog.Reset;
        AttendanceLog.SetCurrentKey("Check In Time");
        AttendanceLog.SetAscending("Check In Time", true);
        AttendanceLog.SetRange(Date, InitialDate);
        AttendanceLog.SetRange("Employee ID", AttendanceLine."Employee No.");
        if AttendanceLog.FindFirst then begin
            AttendanceLine.Validate("Check In Time", AttendanceLog."Check In Time");
            // AttendanceLine.Validate("Check Out Time", AttendanceLog."Check Out Time");
            // AttendanceLine.Validate("Punch Out Reviewer", AttendanceLog."Punch Out Reviewer"); //Min 8.25.2022
            // AttendanceLine.Validate("Punch Out Check Reviewer", AttendanceLog."Punch Out Check Reviewer"); //Min 8.25.2022
            // AttendanceLine.Validate("Punch out Remarks", AttendanceLog."Punch out Remarks"); //Min 8.29.2022
            // AttendanceLine.Validate("Night Shift Punch Out Time", AttendanceLog."Night Shift Check Out Time"); //Min 12.05.2022
            if (AttendanceLine."Check In Time" <> 0T) then begin
                AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
                AttendanceLine.Validate("Present Day", 1);
            end;
        end;
        //For check Out Get 
        AttendanceLog.Reset;
        AttendanceLog.SetCurrentKey("Check In Time");
        AttendanceLog.SetAscending("Check In Time", true);
        AttendanceLog.SetRange(Date, InitialDate);
        AttendanceLog.SetRange("Employee ID", AttendanceLine."Employee No.");
        if AttendanceLog.Findlast then begin
            if AttendanceLog."Check In Time" >= (AttendanceSetUp."Check Out From") then
                AttendanceLine.Validate("Check Out Time", AttendanceLog."Check In Time");
        end;

        EngNep.Reset; //Min 1.25.2023
        EngNep.SetRange("English Date", InitialDate);
        if EngNep.FindFirst then
            AttendanceLine.Week := EngNep.Week;
        AttendanceLine.Modify(false);

        PayrollEngine.PrepareEmployeeDailyActivity(AttendanceLine."Employee No.", InitialDate, InitialDate, true);

        // ChangeStatusToApproveFromHold;
    end;

    procedure IsHoliday(Date: Date; EmpNo: Code[20]): Boolean
    var
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        RetrunBool: Boolean;
    begin
        RetrunBool := false;
        Clear(CalendarDescription);
        RetrunBool := LeaveMgt.GetNonWokingDays(Date, Date, EmpNo) <> 0;
        CalendarDescription := HRMgt.ReturnCalendarDescription;
        exit(RetrunBool);
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
