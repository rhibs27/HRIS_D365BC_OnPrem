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
        AttSetup: Record "Attendance Setup";
        Employee: Record Employee;
        Date: Record Date;
        FromSyncProcess: Boolean;
        ShiftLine: Record "Shift Line";
        CalendarDescription: Text;
        AllowanceAssignment: Codeunit "Allowance Assignment Mgt";
        PGSetup: Record "Payroll General Setup";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        ShiftMgt: Codeunit "Shift Assignment Mgt";

    procedure UpdateEmpAttendance()
    begin
        ResetDays();
        ProcessHolidayAndShiftNormal();
        GetCheckInandOutFromAttendanceLog();
        UpdateCheckInDifference();
        UpdateLateDay();

        if (EmpAttendance."Check In Time" <> 0T) or (EmpAttendance."Check Out Time" <> 0T) then begin
            EmpAttendance."Present Day" := 1;
            EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::Present;
        end;
        // Need to discuss
        // if (EmpAttendance."Present Day" > 0) and (EmpAttendance."Shift Start Time" <> 0T) then
        //     EmpAttendance."OT Hrs" := Round((EmpAttendance."Check Out Time" - EmpAttendance."Shift End Time") / (60 * 60000), 0.01, '=') + Round((EmpAttendance."Shift Start Time" - EmpAttendance."Check In Time") / (60 * 60000), 0.01, '=');


        ProcessDayFromEmpActLedgerEntry();

        if IsHoliday(EmpAttendance."Attendance Date", EmpAttendance."Employee No.") then begin
            if EmpAttendance."Present Day" <> 0 then
                EmpAttendance."Week Off Day" := (1 - EmpAttendance."Present Day");
        end;
        if EmpAttendance."Day Type" = EmpAttendance."Day Type"::"Working Day" then begin
            if (EmpAttendance."Check In Time" = 0T) and (EmpAttendance."Check Out Time" = 0T) then begin
                EmpAttendance."Absent Day" := 1;
                EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::Absent;
            end;
            if (EmpAttendance."Check In Time" = 0T) and (EmpAttendance."Check Out Time" = 0T) and (EmpAttendance."Leave Day" <> 0) then begin
                EmpAttendance."Absent Day" := (1 - EmpAttendance."Leave Day");
                EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::Absent;
            end;
        end;

        if Employee."Automatic Attendance" and (EmpAttendance."Day Type" = EmpAttendance."Day Type"::"Working Day") then begin
            EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::Present;
            EmpAttendance.Validate("Present Day", 1);
        end;

        UpdateAttendanceRemarks();
        if (EmpAttendance."Present Day" = 1) and (EmpAttendance."Leave Day" <> 0) then
            EmpAttendance.Validate("Present Day", 1 - EmpAttendance."Leave Day");

        if (EmpAttendance."Present Day" = 1) and (EmpAttendance."Week Off Day" = 1) then
            EmpAttendance."Present in Holiday" := 1;

        OnUpdateEmpAttendanceOnbeforeModify(EmpAttendance);
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
        EmpAttendance."Check In Time" := 0T;
        EmpAttendance."Check Out Time" := 0T;
        EmpAttendance."Check In Difference" := 0;
        EmpAttendance."Check Out Difference" := 0;
        EmpAttendance."Actual Work Time" := 0;
        EmpAttendance."Work Time Difference" := 0;
        EmpAttendance."Late Check In Day" := 0;
        EmpAttendance."Early Check Out Day" := 0;
        EmpAttendance."Training Day" := 0;
        EmpAttendance."Leave Code" := '';
        EmpAttendance."Leave Description" := '';
        EmpAttendance."Leave Day" := 0;
        EmpAttendance."Source No." := '';
        EmpAttendance.Remarks := '';
        EmpAttendance."Employee Activity Found" := false;
        EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::" ";
    end;

    local procedure GetShiftCodeformShiftAssignment(): Code[20]
    begin
        if PGSetup."Use Allowance Configuration" then begin
            AssignmentMemoLedgerEntry.SetLoadFields("Employee Activity Type", Reversed, "Employee No.", "Employee Work Shift", "Posting Date", "Substituted Employee No.");
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Shift Assignment Memo");
            AssignmentMemoLedgerEntry.SetRange(Reversed, false);
            AssignmentMemoLedgerEntry.SetRange("Employee No.", EmpAttendance."Employee No.");
            AssignmentMemoLedgerEntry.SetRange("Posting Date", EmpAttendance."Attendance Date");
            AssignmentMemoLedgerEntry.SetRange("Substituted Employee No.", '');
            exit(AssignmentMemoLedgerEntry."Employee Work Shift");
        end
        else begin
            ShiftLine.Reset();
            ShiftLine.SetRange("Roster Date", EmpAttendance."Attendance Date");
            ShiftLine.SetRange("Employee No", EmpAttendance."Employee No.");
            ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
            ShiftLine.Setfilter("Substitute Type", '%1|%2', ShiftLine."Substitute Type"::" ", ShiftLine."Substitute Type"::"Added as Substitute");
            exit(ShiftLine."Employee Work Shift");
        end;
    end;

    procedure ProcessHolidayAndShiftNormal()
    var
        WorkShiftCode: Code[20];
    begin
        if IsHoliday(EmpAttendance."Attendance Date", EmpAttendance."Employee No.") then begin
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
            EmpAttendance."OverNight Shift" := EmpWorkShiftDetail.OverNight;
            EmpAttendance."Shift Start Time" := EmpWorkShiftDetail."Start Time";
            EmpAttendance."Shift End Time" := ShiftMgt.ReturnShiftEndTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail);
            if not EmpAttendance."OverNight Shift" then
                EmpAttendance."Standard Work Time" := EmpAttendance."Shift End Time" - EmpAttendance."Shift Start Time"
            else
                EmpAttendance."Standard Work Time" := EmpAttendance."Shift End Time" - EmpAttendance."Shift Start Time" + 24 * 60 * 60 * 1000;
        end;
    end;

    local procedure UpdateCheckInDifference()
    begin

        if (EmpAttendance."Shift Start Time" <> 0T) and (EmpAttendance."Check In Time" <> 0T) then
            EmpAttendance."Check In Difference" := EmpAttendance."Shift Start Time" - EmpAttendance."Check In Time";
        if (EmpAttendance."Shift End Time" <> 0T) and (EmpAttendance."Check Out Time" <> 0T) then
            EmpAttendance."Check Out Difference" := EmpAttendance."Check Out Time" - EmpAttendance."Shift End Time";
        if (EmpAttendance."Check Out Time" <> 0T) and (EmpAttendance."Check In Time" <> 0T) then
            if not EmpAttendance."OverNight Shift" then
                EmpAttendance."Actual Work Time" := EmpAttendance."Check Out Time" - EmpAttendance."Check In Time"
            else
                EmpAttendance."Actual Work Time" := EmpAttendance."Check Out Time" - EmpAttendance."Check In Time" + 24 * 60 * 60 * 1000;
        if (EmpAttendance."Check In Difference" <> 0) and (EmpAttendance."Check Out Difference" <> 0) then
            EmpAttendance."Work Time Difference" := EmpAttendance."Check In Difference" + EmpAttendance."Check Out Difference";
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
        Ishandled: Boolean;
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

                            if EmpAttendance."Leave Day" <> 0 then begin
                                if IsHoliday(EmpAttendance."Attendance Date", EmpAttendance."Employee No.") then
                                    EmpAttendance."Week Off Day" := (1 - EmpAttendance."Leave Day")
                            end;
                            EmpAttendance."Leave Type" := EmpActLedgerEntry."Leave Type";
                            if LeaveRequest.Get(EmpActLedgerEntry."Document No.") then begin
                                EmpAttendance."Leave Code" := LeaveRequest."Leave Code";
                                if LeaveTypeSetup.Get(LeaveRequest."Leave Code") then begin
                                    EmpAttendance."Leave Description" := LeaveTypeSetup.Description;
                                    EmpAttendance."Pay Type" := LeaveTypeSetup."Pay Type";
                                end;
                            end;
                            EmpAttendance.Remarks := UpperCase(Format(EmpAttendance."Leave Description")) + ' LEAVE';
                        end;
                    EmpActLedgerEntry."Document Type"::"Travel Request":
                        begin
                            EmpAttendance."Absent Day" := 0;
                            EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::"Outdoor Duty";
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
                            EmpAttendance."Entry Type" := EmpAttendance."Entry Type"::Training;
                            EmpAttendance."Absent Day" := 0;
                            EmpAttendance.Remarks := 'TRAINING';
                        end;
                    EmpActLedgerEntry."Document Type"::"Allowance Assignment Claim":
                        begin
                            AllowanceAssignment.InsertHighestPriorityAllowanceInAttendance(EmpActLedgerEntry."Employee No.", EmpActLedgerEntry."Event Date", EmpAttendance);
                        end;
                    EmpActLedgerEntry."Document Type"::"Late Deduction":
                        begin
                            EmpAttendance."Late Deduction" := true;
                            EmpAttendance.Remarks := 'Late Deduction';
                        end;
                    else begin
                        OnAfterProcessDayFromEmpActLedgerEntry(EmpAttendance, EmpActLedgerEntry, Ishandled);
                        if not Ishandled then begin
                            EmpAttendance."Source No." := '';
                            EmpAttendance."Employee Activity Found" := false;
                        end;
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
                EmpAttendance.Remarks := UpperCase(Format(EmpAttendance."Leave Description"));

            if EmpAttendance."Tour Day" > 0 then
                EmpAttendance.Remarks := 'TRAVEL';

            if EmpAttendance."Training Day" > 0 then
                EmpAttendance.Remarks := 'TRAINING';
        end;
    end;

    procedure IsHoliday(Date: Date; EmpNo: Code[20]): Boolean
    var
        AttendanceMgt: Codeunit "Attendance Mgt";
        ReturnBool: Boolean;
    begin
        ReturnBool := false;
        Clear(CalendarDescription);
        ReturnBool := AttendanceMgt.GetNonWorkingDaysFromAttendance(Date, Date, EmpAttendance."Deputation On", EmpAttendance."Deputation On Code", EmpAttendance."Province Code", EmpNo) <> 0;
        CalendarDescription := AttendanceMgt.ReturnCalendarDescription;
        exit(ReturnBool);
    end;

    procedure GetSetup()
    begin
        AttSetup.Get;
        PGSetup.Get;
        AttSetup.TestField("Base Calender");
        Employee.Get(EmpAttendance."Employee No.");
        Date.Get(Date."Period Type"::Date, EmpAttendance."Attendance Date");
    end;

    procedure GetCheckInandOutFromAttendanceLog()
    begin
        if (EmpWorkShiftDetail."Check In From" <> 0) or (EmpWorkShiftDetail."Check Out From" <> 0) then begin
            GetCheckInAndOutFromAttendanceLogInRange(
                CreateDateTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail."Start Time") - EmpWorkShiftDetail."Check In From",
                CreateDateTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail."Start Time") + EmpWorkShiftDetail."Check In From",
                EmpAttendance."Check In Time",
                true);

            if EmpWorkShiftDetail.OverNight then
                GetCheckInAndOutFromAttendanceLogInRange(
                    CreateDateTime(EmpAttendance."Attendance Date" + 1, EmpWorkShiftDetail."End Time") - EmpWorkShiftDetail."Check Out From",
                    CreateDateTime(EmpAttendance."Attendance Date" + 1, EmpWorkShiftDetail."End Time") + EmpWorkShiftDetail."Check Out From",
                    EmpAttendance."Check Out Time",
                    False)
            else
                GetCheckInAndOutFromAttendanceLogInRange(
                    CreateDateTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail."End Time") - EmpWorkShiftDetail."Check Out From",
                    CreateDateTime(EmpAttendance."Attendance Date", EmpWorkShiftDetail."End Time") + EmpWorkShiftDetail."Check Out From",
                    EmpAttendance."Check Out Time",
                    False);
        end
        else
            GetCheckInAndOutFromAttendanceLogRegular();
    end;

    procedure GetCheckInAndOutFromAttendanceLogRegular()
    var
        AttendanceLog: Record "Attendance Log";
    begin
        AttendanceLog.SetLoadFields("Employee ID", Date, "Date Time Log", "Log Time", "Device IP");
        AttendanceLog.SetCurrentKey("Date Time Log");
        AttendanceLog.SetAscending("Date Time Log", true);
        AttendanceLog.SetRange("Employee ID", EmpAttendance."Employee No.");
        AttendanceLog.SetRange(Date, EmpAttendance."Attendance Date");
        if AttendanceLog.FindFirst() then begin
            EmpAttendance."Check In Time" := AttendanceLog."Log Time";
            EmpAttendance."Check-In Device IP" := AttendanceLog."Device IP";
        end;

        AttendanceLog.SetRange(Date, EmpAttendance."Attendance Date");
        if AttendanceLog.FindLast() then
            if EmpAttendance."Check In Time" <> AttendanceLog."Log Time" then begin
                EmpAttendance."Check Out Time" := AttendanceLog."Log Time";
                EmpAttendance."Check-Out Device IP" := AttendanceLog."Device IP";
            end else begin
                Clear(EmpAttendance."Check Out Time");
                Clear(EmpAttendance."Check-Out Device IP");
            end;
    end;

    local procedure GetCheckInAndOutFromAttendanceLogInRange(StartTime: DateTime; EndTime: DateTime; var TimeVar: Time; FirstRecord: Boolean): Time
    var
        AttendanceLog: Record "Attendance Log";
    begin
        AttendanceLog.SetLoadFields("Employee ID", Date, "Date Time Log", "Log Time");
        AttendanceLog.SetCurrentKey("Date Time Log");
        AttendanceLog.SetAscending("Date Time Log", true);
        AttendanceLog.SetRange("Employee ID", EmpAttendance."Employee No.");
        if GuiAllowed or (not FromSyncProcess) then
            AttendanceLog.SetRange("Date Time Log", StartTime, EndTime)
        else begin
            AttendanceLog.SetRange(Date, DT2Date(StartTime), DT2Date(EndTime));
            AttendanceLog.SetRange("Log Time", DT2Time(StartTime), DT2Time(EndTime));
        end;
        if FirstRecord then begin
            if AttendanceLog.FindFirst() then;
            EmpAttendance."Check-In Device IP" := AttendanceLog."Device IP"
        end else begin
            if AttendanceLog.FindLast() then;
            EmpAttendance."Check-Out Device IP" := AttendanceLog."Device IP"
        end;
        TimeVar := AttendanceLog."Log Time";
    end;

    procedure GetSyncProcessBoolean(VarFromSyncProcess: Boolean)
    begin
        FromSyncProcess := VarFromSyncProcess;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterProcessDayFromEmpActLedgerEntry(var EmpAttendance: Record "Employee Attendance & Activity"; Var EmpActLedgerEntry: Record "Emp. Act. Ledger Entry"; var Ishandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnUpdateEmpAttendanceOnbeforeModify(var EmpAttendance: Record "Employee Attendance & Activity")
    begin
    end;
}
