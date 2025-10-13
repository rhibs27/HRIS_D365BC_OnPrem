codeunit 50029 "Process Daily Attendance"
{
    TableNo = "Employee Attendance & Activity";

    trigger OnRun()
    begin
        EmpAttendance := Rec;
        GetSetup();
        UpdateEmpAttendance();
    end;

    var
        EmpAttendance: Record "Employee Attendance & Activity";
        EmpWorkShiftDetail: Record "Employee Work Shift";
        HRMgt: Codeunit "HR Mgt.";
        AttSetup: Record "Attendance Setup";
        Employee: Record Employee;
        CheckInThresholdDuration, CheckOutThresholdDuration : Duration;
        Date: Record Date;
        FromSyncProcess: Boolean;
        ShiftLine: Record "Shift Line";
        AttendanceMgt: Codeunit "Attendance Mgt";
        CalendarDescription: Text;

    procedure UpdateEmpAttendance()
    begin
        ResetDays();
        GetShiftCodeformShiftAssignment();
        ProcessHolidayAndShiftNormal();
        GetCheckInandOutFromAttendanceLog();
        UpdateCheckInDifference();
        UpdateLateDay();

        if (EmpAttendance."Check In Time" <> 0T) and (EmpAttendance."Check Out Time" <> 0T) then begin
            EmpAttendance."Present Day" := 1;
            EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::Present;
        end;

        if (EmpAttendance."Present Day" > 0) and (EmpAttendance."Shift Start Time" <> 0T) then
            EmpAttendance."OT Hrs" := Round((EmpAttendance."Check Out Time" - EmpAttendance."Shift End Time") / (60 * 60000), 0.01, '=') + Round((EmpAttendance."Shift Start Time" - EmpAttendance."Check In Time") / (60 * 60000), 0.01, '=');

        if EmpAttendance."Day Type" = EmpAttendance."Day Type"::"Working Day" then
            if (EmpAttendance."Check In Time" = 0T) or (EmpAttendance."Check Out Time" = 0T) then begin
                EmpAttendance."Absent Day" := 1;
                EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::Absent;
            end;

        ProcessDayFromEmpActLedgerEntry();

        if Employee."Automatic Attendance" and (EmpAttendance."Day Type" = EmpAttendance."Day Type"::"Working Day") then begin
            EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::Present;
            EmpAttendance.Validate("Present Day", 1);
        end;

        UpdateAttendanceRemarks();

        if (EmpAttendance."Present Day" = 1) and (EmpAttendance."Week Off Day" = 1) then
            EmpAttendance."Present in Holiday" := 1;

        // if (EmpAttendance."Present Day" = 1) and (EmpAttendance."Absent Day" = 0) and (EmpAttendance."Week Off Day" = 0) and (EmpAttendance."Tour Day" = 0) and (EmpAttendance."Leave Day" = 0) and (EmpAttendance."Transfer Day" = 0) and (EmpAttendance."Training Day" = 0) then
        // CheckAndInsertTimeDifference();

        EmpAttendance.Modify(true);
    end;

    local procedure ResetDays()
    begin
        EmpAttendance."Half Day" := 0;
        EmpAttendance."Late Day" := 0;
        EmpAttendance."Tour Day" := 0;
        EmpAttendance."Leave Day" := 0;
        EmpAttendance."Absent Day" := 0;
        EmpAttendance."Present Day" := 0;
        EmpAttendance."Transfer Day" := 0;
        EmpAttendance."Week Off Day" := 0;
        EmpAttendance."Late Check In Day" := 0;
        EmpAttendance."Early Check Out Day" := 0;
        EmpAttendance."Training Day" := 0;
        EmpAttendance."Leave Code" := '';
        EmpAttendance."Leave Description" := '';
        EmpAttendance."Leave Day" := 0;
        EmpAttendance."Source No." := '';
    end;

    local procedure GetShiftCodeformShiftAssignment(): Code[20]
    begin
        ShiftLine.Reset();
        ShiftLine.SetRange("Roster Date", EmpAttendance."Attendance Date");
        ShiftLine.SetRange("Employee No", EmpAttendance."Employee No.");
        ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
        ShiftLine.Setfilter("Substitute Type", '%1|%2', ShiftLine."Substitute Type"::" ", ShiftLine."Substitute Type"::"Added as Substitute");
        exit(ShiftLine."Employee Work Shift");
    end;

    procedure ProcessHolidayAndShiftNormal()
    var
        WorkShiftCode: Code[20];
    begin
        if AttendanceMgt.IsHoliday(EmpAttendance."Attendance Date", EmpAttendance."Employee No.") then begin
            EmpAttendance."Day Type" := EmpAttendance."Day Type"::Holiday;
            EmpAttendance."Week Off Day" := 1;
            EmpAttendance."Holiday Remarks" := CalendarDescription;
        end else begin
            EmpAttendance."Day Type" := EmpAttendance."Day Type"::"Working Day";
            EmpAttendance."Week Off Day" := 0;
            EmpAttendance."Holiday Remarks" := '';
        end;

        WorkShiftCode := GetShiftCodeformShiftAssignment();
        if WorkShiftCode = '' then
            WorkShiftCode := EmpAttendance."Employee Working Shift";

        if EmpWorkShiftDetail.Get(WorkShiftCode) then begin
            EmpAttendance."Shift Start Time" := EmpWorkShiftDetail."Start Time";
            EmpAttendance."Shift End Time" := EmpWorkShiftDetail."End Time";
            EmpAttendance."Standard Work Time" := EmpWorkShiftDetail."Work Time";

            if EmpWorkShiftDetail."Winter Start Date" <> 0D then
                if (EmpAttendance."Attendance Date" >= EmpWorkShiftDetail."Winter Start Date") and
                    (EmpAttendance."Attendance Date" <= EmpWorkShiftDetail."Winter End Date") and (EmpWorkShiftDetail."Winter End Time" <> 0T) then
                    EmpAttendance."Shift End Time" := EmpWorkShiftDetail."Winter End Time";

            if EmpAttendance.Week = EmpAttendance.Week::Friday then
                if EmpWorkShiftDetail."Friday End Time" <> 0T then
                    EmpAttendance."Shift End Time" := EmpWorkShiftDetail."Friday End Time";

        end;
    end;

    local procedure UpdateCheckInDifference()
    begin

        if (EmpAttendance."Shift Start Time" <> 0T) and (EmpAttendance."Check In Time" <> 0T) then
            EmpAttendance."Check In Difference" := EmpAttendance."Shift Start Time" - EmpAttendance."Check In Time";
        if (EmpAttendance."Shift End Time" <> 0T) and (EmpAttendance."Check Out Time" <> 0T) then
            EmpAttendance."Check Out Difference" := EmpAttendance."Shift End Time" - EmpAttendance."Check Out Time";
        if (EmpAttendance."Check Out Time" <> 0T) and (EmpAttendance."Check In Time" <> 0T) then
            EmpAttendance."Actual Work Time" := EmpAttendance."Check Out Time" - EmpAttendance."Check In Time";
        EmpAttendance."Work Time Difference" := EmpAttendance."Check In Difference" - EmpAttendance."Check Out Difference";
    end;

    local procedure UpdateLateDay()
    begin
        if EmpAttendance."Shift Start Time" = 0T then
            exit;
        if (EmpAttendance."Check In Time" <> 0T) then
            if EmpAttendance."Shift Start Time" + (AttSetup."Per Day Late Tolerance" * 60000) < EmpAttendance."Check In Time" then begin
                EmpAttendance."Late Check In Day" := 1;
                EmpAttendance."Late Day" := 1;
            end;
        if (EmpAttendance."Check Out Time" <> 0T) then
            if EmpAttendance."Shift End Time" - (60000 * AttSetup."Per Day Late Tolerance") > EmpAttendance."Check Out Time" then begin
                EmpAttendance."Early Check Out Day" := 1;
                EmpAttendance."Late Day" := 1;
            end;
    end;

    local procedure ProcessDayFromEmpActLedgerEntry()
    var
        EmpActLedgerEntry: Record "Emp. Act. Ledger Entry";
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveRequest: Record Leave;
        SourceNoText: Text;
    begin
        Clear(SourceNoText);
        EmpActLedgerEntry.SetRange("Employee No.", EmpAttendance."Employee No.");
        EmpActLedgerEntry.SetRange("Event Date", EmpAttendance."Attendance Date");
        EmpActLedgerEntry.SetRange("Cancellation Entry", false);
        if EmpActLedgerEntry.FindSet() then
            repeat
                if EmpAttendance."Source No." = '' then
                    EmpAttendance."Source No." := EmpActLedgerEntry."Document No."
                else begin
                    SourceNoText := EmpAttendance."Source No.";
                    if not SourceNoText.Contains(EmpActLedgerEntry."Document No.") then
                        EmpAttendance."Source No." := EmpAttendance."Source No." + ', ' + EmpActLedgerEntry."Document No.";
                end;
                EmpAttendance."Employee Activity Found" := true;
                case
                    EmpActLedgerEntry."Document Type" of
                    EmpActLedgerEntry."Document Type"::"Leave Request":
                        begin
                            EmpAttendance."Leave Day" += EmpActLedgerEntry.Day;
                            EmpAttendance."Absent Day" := 0;
                            EmpAttendance."Day Type" := EmpActLedgerEntry."Leave Type";
                            if LeaveRequest.Get(EmpActLedgerEntry."Document No.") then begin
                                EmpAttendance."Leave Code" := LeaveRequest."Leave Code";
                                if LeaveTypeSetup.Get(LeaveRequest."Leave Code") then
                                    EmpAttendance."Leave Description" := LeaveTypeSetup.Description;
                            end;
                            EmpAttendance.Remarks := UpperCase(Format(EmpAttendance."Leave Description")) + ' LEAVE';
                        end;
                    EmpActLedgerEntry."Document Type"::"Travel Request":
                        begin
                            EmpAttendance."Absent Day" := 0;
                            EmpAttendance."Tour Day" := EmpActLedgerEntry.Day;
                            EmpAttendance.Remarks := 'TRAVEL';
                        end;
                    EmpActLedgerEntry."Document Type"::"Employee Transfer", EmpActLedgerEntry."Document Type"::"HR Transfer":
                        begin
                            EmpAttendance."Transfer Day" := EmpActLedgerEntry.Day;
                            EmpAttendance."Absent Day" := 0;
                            EmpAttendance."Transfer Day" := 1;
                            EmpAttendance.Remarks := Format(EmpActLedgerEntry."Document Type");
                        end;
                    EmpActLedgerEntry."Document Type"::Training:
                        begin
                            EmpAttendance."Training Day" := 1;
                            EmpAttendance."Absent Day" := 0;
                            EmpAttendance.Remarks := 'TRAINING';
                        end;
                    else begin
                        EmpAttendance."Source No." := '';
                        EmpAttendance."Employee Activity Found" := false;
                    end;
                end;
            until EmpActLedgerEntry.Next() = 0;
    end;

    procedure UpdateAttendanceRemarks()
    begin

        if IsHoliday(Date."Period Start", EmpAttendance."Employee No.") then
            EmpAttendance.Remarks := CalendarDescription
        else begin
            if EmpAttendance."Absent Day" = 0.5 then
                EmpAttendance.Remarks := 'HALF DAY ABSENT';

            if EmpAttendance."Present Day" = 0 then
                if (EmpAttendance."Check In Time" = 0T) and (EmpAttendance."Check Out Time" <> 0T) then
                    EmpAttendance.Remarks := 'MISSED PUNCH'
                else
                    if (EmpAttendance."Check In Time" <> 0T) and (EmpAttendance."Check Out Time" = 0T) then
                        EmpAttendance.Remarks := 'MISSED PUNCH';


            if EmpAttendance."Present Day" = 0.5 then
                EmpAttendance.Remarks := 'HALF DAY PRESENT';

            if (EmpAttendance."Late Check In Day" <> 0) and (EmpAttendance."Early Check Out Day" <> 0) then
                EmpAttendance.Remarks := 'LATE IN/EARLY OUT'
            else
                if EmpAttendance."Late Check In Day" <> 0 then
                    EmpAttendance.Remarks := 'LATE IN'
                else
                    if EmpAttendance."Early Check Out Day" <> 0 then
                        EmpAttendance.Remarks := 'EARLY OUT';

            if EmpAttendance."Transfer Day" > 0 then
                EmpAttendance.Remarks := 'TRANSFER';

            if EmpAttendance."Leave Day" > 0 then
                EmpAttendance.Remarks := UpperCase(Format(EmpAttendance."Leave Description")) + ' LEAVE';

            if EmpAttendance."Tour Day" > 0 then
                EmpAttendance.Remarks := 'TRAVEL';

            if EmpAttendance."Training Day" > 0 then
                EmpAttendance.Remarks := 'TRAINING';

        end;
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

    procedure GetSetup()
    begin
        AttSetup.Get;
        AttSetup.TestField("Base Calender");
        Employee.Get(EmpAttendance."Employee No.");
        Date.Get(Date."Period Type"::Date, EmpAttendance."Attendance Date");
    end;


    procedure GetCheckInandOutFromAttendanceLog()
    var
        AttendanceLog: Record "Attendance Log";
    begin
        if (EmpWorkShiftDetail."Check In From" <> 0) or (EmpWorkShiftDetail."Check Out From" <> 0) then begin
            GetCheckInandOutFromAttendanceLogInRange(
                CreateDateTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail."Start Time") - EmpWorkShiftDetail."Check In From",
                CreateDateTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail."Start Time") + EmpWorkShiftDetail."Check In From",
                EmpAttendance."Check In Time",
                true);

            GetCheckInandOutFromAttendanceLogInRange(
                CreateDateTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail."End Time") - EmpWorkShiftDetail."Check Out From",
                CreateDateTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail."End Time") + EmpWorkShiftDetail."Check Out From",
                EmpAttendance."Check Out Time",
                False);
        end
        else
            GetCheckInandOutFromAttendanceLogRegular();
    end;

    procedure GetCheckInandOutFromAttendanceLogRegular()
    var
        AttendanceLog: Record "Attendance Log";
    begin
        AttendanceLog.SetCurrentKey("Date Time Log");
        AttendanceLog.SetLoadFields("Machine Emp. Code", Date, "Date Time Log", "Log Time");
        AttendanceLog.SetRange("Machine Emp. Code", Employee."Employee Attendance ID");
        AttendanceLog.SetRange(Date, EmpAttendance."Attendance Date");
        if AttendanceLog.FindFirst() then begin
            EmpAttendance."Check In Time" := AttendanceLog."Log Time";
            EmpAttendance."Check-In Device IP" := AttendanceLog."Device IP";
        end;

        AttendanceLog.SetRange(Date, EmpAttendance."Attendance Date");
        if AttendanceLog.FindLast() then begin
            EmpAttendance."Check Out Time" := AttendanceLog."Log Time";
            EmpAttendance."Check-Out Device IP" := AttendanceLog."Device IP";
        end;

    end;

    local procedure GetCheckInandOutFromAttendanceLogInRange(StartTime: DateTime; EndTime: DateTime; var TimeVar: Time; FirstRecord: Boolean): Time
    var
        AttendanceLog: Record "Attendance Log";
    begin
        AttendanceLog.SetCurrentKey("Date Time Log");
        AttendanceLog.SetLoadFields("Machine Emp. Code", Date, "Date Time Log", "Log Time");
        AttendanceLog.SetRange("Machine Emp. Code", Employee."Employee Attendance ID");
        AttendanceLog.SetRange("Date Time Log", StartTime, EndTime);
        if FirstRecord then
            if AttendanceLog.FindFirst() then;
        if not FirstRecord then
            if AttendanceLog.FindLast() then;

        TimeVar := AttendanceLog."Log Time";
        if FirstRecord then
            EmpAttendance."Check-In Device IP" := AttendanceLog."Device IP"
        else
            EmpAttendance."Check-Out Device IP" := AttendanceLog."Device IP"
    end;

    procedure GetSyncProcessBoolean(VarFromSyncProcess: Boolean)
    begin
        FromSyncProcess := VarFromSyncProcess;
    end;
}
