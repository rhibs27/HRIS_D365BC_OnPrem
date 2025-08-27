codeunit 50026 "Attendance Mgt"
{
    procedure InsertAttendanceLine(EmpNo: Code[20]; InitialDate: date; DocumentNo: Code[20])
    var
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
        GetDeviceIPsfromLog(EmpNo, InitialDate, AttendanceLine."Check-In Device IP", AttendanceLine."Check-Out Device IP");
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
        PrepareEmployeeDailyActivity(AttendanceLine."Employee No.", InitialDate, InitialDate, true);
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
        AttendanceLog.SetCurrentKey("Date Time Log");
        AttendanceLog.SetRange("Employee ID", EmployeeNo);
        if EmployeeWorkShift.OverNight then begin  // Determine search date based on overnight shift
            AttendanceLog.SetRange(Date, InitialDate);
            if EmployeeWorkShift."Check In From" <> 0 then
                AttendanceLog.SetRange("Date Time Log",
                CreateDateTime(InitialDate, EmployeeWorkShift."Start Time") - EmployeeWorkShift."Check In From",
                CreateDateTime(InitialDate, EmployeeWorkShift."Start Time") + EmployeeWorkShift."Check In From");
            //AttendanceLog.SetRange("Log Time", (EmployeeWorkShift."Start Time" - EmployeeWorkShift."Check In From"), (EmployeeWorkShift."Start Time" + EmployeeWorkShift."Check In From"));
            AttendanceLog.SetAscending("Date Time Log", false);
            if AttendanceLog.Findfirst() then begin
                exit(AttendanceLog."Log Time");
            end else
                exit(0T);
        end else begin
            // Regular shift
            AttendanceLog.SetRange(Date, InitialDate);
            if EmployeeWorkShift."Check In From" <> 0 then
                AttendanceLog.SetRange("Date Time Log",
                CreateDateTime(InitialDate, EmployeeWorkShift."Start Time") - EmployeeWorkShift."Check In From",
                CreateDateTime(InitialDate, EmployeeWorkShift."Start Time") + EmployeeWorkShift."Check In From");
            //AttendanceLog.SetRange("Log Time", (EmployeeWorkShift."Start Time" - EmployeeWorkShift."Check In From"), (EmployeeWorkShift."Start Time" + EmployeeWorkShift."Check In From"));
            AttendanceLog.SetAscending("Date Time Log", true);
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
        AttendanceLog.SetCurrentKey("Date Time Log");
        AttendanceLog.SetRange("Employee ID", EmployeeNo);
        if EmployeeWorkShift.OverNight then begin  // Determine search date based on overnight shift
            AttendanceLog.SetRange(Date, InitialDate + 1);
            if EmployeeWorkShift."Check Out From" <> 0 then
                AttendanceLog.SetRange("Date Time Log",
                CreateDateTime(InitialDate + 1, EmployeeWorkShift."End Time") - EmployeeWorkShift."Check Out From",
                CreateDateTime(InitialDate + 1, EmployeeWorkShift."End Time") + EmployeeWorkShift."Check Out From");
            //AttendanceLog.SetRange("Log Time", (EmployeeWorkShift."End Time" - EmployeeWorkShift."Check Out From"), (EmployeeWorkShift."End Time" + EmployeeWorkShift."Check Out From"));
            AttendanceLog.SetAscending("Date Time Log", true);
            if AttendanceLog.Findfirst() then
                exit(AttendanceLog."Log Time");
            // If not found on next day, search same day after check-in
            AttendanceLog.Reset;
            AttendanceLog.SetLoadFields(Date, "Log Time", "Employee ID");
            AttendanceLog.SetCurrentKey("Date Time Log");
            AttendanceLog.SetRange("Employee ID", EmployeeNo);
            AttendanceLog.SetRange(Date, InitialDate);
            AttendanceLog.SetFilter("Date Time Log", '>%1', CreateDateTime(InitialDate, CheckInTime));
            AttendanceLog.SetAscending("Date Time Log", false);
            if AttendanceLog.FindFirst() then
                exit(AttendanceLog."Log Time")

        end else begin
            // Regular shift - search same day
            AttendanceLog.SetRange(Date, InitialDate);
            AttendanceLog.SetFilter("Date Time Log", '>%1', CreateDateTime(InitialDate, CheckInTime));
            if EmployeeWorkShift."Check Out From" <> 0 then
                AttendanceLog.SetFilter("Date Time Log", '>=%1',
                CreateDateTime(InitialDate, EmployeeWorkShift."End Time") + EmployeeWorkShift."Check Out From");
            AttendanceLog.SetAscending("Date Time Log", false);
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
        if AttendanceLog.FindSet() then
            repeat
                AttendanceLog."Employee ID" := GetEmployeeIDFromBiometric(AttendanceLog."Machine Emp. Code");
                AttendanceLog.Modify();
            until AttendanceLog.Next() = 0;
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
        actualPresentDays: Decimal;
        AttendanceDate: Date;
    begin
        actualPresentDays := 0;
        Clear(AttendanceDate);
        EmpAtt.Reset();
        EmpAtt.SetRange("Employee No.", EmpCode);
        EmpAtt.SetRange("Attendance Date", PStartDate, PEndDate);
        EmpAtt.CalcSums("Present Day", "Week Off Day", "Tour Day", "Training Day", "Leave Day");
        actualPresentDays := EmpAtt."Present Day" + EmpAtt."Week Off Day" + EmpAtt."Tour Day" + EmpAtt."Training Day" + EmpAtt."Leave Day";
        exit(actualPresentDays);
    end;

    procedure GetDeviceIPsfromLog(EmpNo: Code[20]; InitialDate: date; var InIP: text[20]; var OutIP: Text[20])
    var
        AttenLog: Record "Attendance Log";
    begin
        AttenLog.SetLoadFields("Employee ID", "Machine Emp. Code", Date);
        AttenLog.SetRange("Employee ID", EmpNo);
        AttenLog.SetRange(Date, InitialDate);
        if AttenLog.FindFirst() then
            InIP := AttenLog."Device IP";
        if AttenLog.FindLast() then
            OutIP := AttenLog."Device IP";
    end;

    procedure CheckOverNightShift(WorkShiftCode: Code[20]): Boolean
    var
        EmployeeWorkShift: Record "Employee Work Shift";
    begin
        if EmployeeWorkShift.Get(WorkShiftCode) then begin
            if EmployeeWorkShift.OverNight then
                exit(true)
        end;
    end;


    procedure PrepareEmployeeDailyActivity(EmployeeCode: Code[20]; StartDate: Date; EndDate: Date; PreparationBeforePosting: Boolean)
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        Leave: Record Leave;
        Travel: Record "Travel Request";
        OverTime: Record OverTime;
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        AttendanceLine: Record "Attendance Line";
        TrainingAttend: Record "Training Attendance";
        AllowanceAssignMgt: Codeunit "Allowance Assignment Mgt";
    begin
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
        EmployeeAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
        EmployeeAttendanceActivity.DeleteAll;

        AttendanceLine.Reset;
        AttendanceLine.SetCurrentKey("Employee No.", "Attendance Date");
        AttendanceLine.SetRange("Employee No.", EmployeeCode);
        AttendanceLine.SetRange("Attendance Date", StartDate, EndDate);
        if AttendanceLine.FindSet then
            repeat
                Clear(EmployeeAttendanceActivity);
                EmployeeAttendanceActivity.TransferFields(AttendanceLine);
                EmployeeAttendanceActivity."Created Datetime" := CurrentDateTime;
                EmployeeAttendanceActivity.Insert;
            until AttendanceLine.Next = 0;

        Leave.Reset;
        Leave.SetLoadFields("No.", "Employee No.", "Start Date", "End Date", Type, "Approval Status", Cancelled, "Cancelled No.");

        Leave.SetCurrentKey("Employee No.", "Start Date", "End Date");
        Leave.SetRange(Type, Leave.Type::"Leave Request");
        Leave.SetRange("Employee No.", EmployeeCode);
        Leave.SetFilter("Start Date", '<=%1', StartDate);
        Leave.SetFilter("End Date", '>=%1', StartDate);
        Leave.SetRange("Approval Status", Leave."Approval Status"::Approved);
        Leave.SetFilter("Cancelled No.", '%1', '');
        Leave.SetRange(Cancelled, false);
        if Leave.FindSet then
            repeat
                CorrectAttendanceActivity(Leave.Type, Leave."No.", StartDate, EmployeeCode);
            until Leave.Next = 0;

        // for Approved Travel Request
        Travel.Reset;
        Travel.SetLoadFields("No.", "Employee No.", Type, "Start Date", "End Date", "Approval Status", Cancelled, "Cancelled No.");
        Travel.SetCurrentKey("Employee No.", "Start Date", "End Date");
        Travel.SetRange(Type, Leave.Type::"Travel Request");
        Travel.SetRange("Employee No.", EmployeeCode);
        Travel.SetFilter("Start Date", '<=%1', StartDate);
        Travel.SetFilter("End Date", '>=%1', StartDate);
        Travel.SetRange("Approval Status", Leave."Approval Status"::Approved);
        Travel.SetFilter("Cancelled No.", '%1', '');
        Travel.SetRange(Cancelled, false);
        if Travel.FindSet then
            repeat
                CorrectAttendanceActivity(Travel.Type, Travel."No.", StartDate, EmployeeCode);
            until Travel.Next = 0;

        // for Approved OverTime Request
        OverTime.Reset;
        OverTime.SetCurrentKey("Employee No.", "Start Date", "End Date");
        OverTime.SetRange(Type, OverTime.Type::Overtime);
        OverTime.SetRange("Employee No.", EmployeeCode);
        OverTime.SetFilter("Start Date", '<=%1', StartDate);
        OverTime.SetFilter("End Date", '>=%1', StartDate);
        OverTime.SetRange("Approval Status", OverTime."Approval Status"::Approved);
        OverTime.SetRange(Cancelled, false);
        if OverTime.FindSet then
            repeat
                CorrectAttendanceActivity(OverTime.Type, OverTime."No.", StartDate, EmployeeCode);
            until OverTime.Next = 0;
        // for Approved AllowanceAssignmentLine Request
        AllowanceAssignmentLine.Reset;
        AllowanceAssignmentLine.SetRange("Emp Act Type", AllowanceAssignmentLine."Emp Act Type"::"Allowance Assignment"); //Min 8.21.2022
        AllowanceAssignmentLine.SetRange("Employee Code", EmployeeCode);
        AllowanceAssignmentLine.SetFilter("From Date", '<=%1', StartDate);
        AllowanceAssignmentLine.SetFilter("To Date", '>=%1', StartDate);
        AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
        if AllowanceAssignmentLine.Findset then
            repeat
                AllowanceAssignMgt.InsertHighestPriorityAllowanceInAttendance(AllowanceAssignmentLine."Employee Code", AllowanceAssignmentLine."From Date");
            until AllowanceAssignmentLine.Next = 0;

        TrainingAttend.Reset;
        TrainingAttend.SetRange("Employee No.", EmployeeCode);
        TrainingAttend.SetRange("Attended Date", StartDate);
        if TrainingAttend.FindFirst then begin
            if EmployeeAttendanceActivity.Get(EmployeeCode, StartDate) then begin
                EmployeeAttendanceActivity."Training Day" := 1;
                EmployeeAttendanceActivity.Validate("Present Day", 1);
                EmployeeAttendanceActivity."Employee Activity Found" := true;
                EmployeeAttendanceActivity."Source No." := TrainingAttend."Training No";
                EmployeeAttendanceActivity."Created Datetime" := CurrentDateTime;
            end;
        end;
        CalculateLateDays(EmployeeCode, StartDate, EndDate);
        if EmployeeAttendanceActivity.Get(EmployeeCode, StartDate) then begin
            if (EmployeeAttendanceActivity."Present Day" = 0) and (EmployeeAttendanceActivity."Leave Day" = 0) and (EmployeeAttendanceActivity."Week Off Day" = 0) then begin
                EmployeeAttendanceActivity.Validate("Absent Day", 1);
                EmployeeAttendanceActivity.Modify;
            end;
        end;
    end;

    local procedure CorrectAttendanceActivity(EmployeeActType: Enum "Employee Activity Type"; EmpActNo: Code[20]; AttendanceDate: Date; EmpNo: Code[20])
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        Leave: Record Leave;
        LeaveTypeSetup: Record "Leave Type Setup";
    begin

        if EmployeeAttendanceActivity.Get(EmpNo, AttendanceDate) then begin
            case EmployeeActType of
                EmployeeActType::"Leave Request":
                    begin
                        Leave.Get(EmpActNo);
                        LeaveTypeSetup.Get(Leave."Leave Code");
                        if EmployeeAttendanceActivity."Day Type" = EmployeeAttendanceActivity."Day Type"::Holiday then
                            if not LeaveTypeSetup."Exclude Non Working Days" then begin
                                EmployeeAttendanceActivity."Day Type" := EmployeeAttendanceActivity."Day Type"::"Working Day";
                                EmployeeAttendanceActivity."Week Off Day" := 0;
                            end;
                        if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                            EmployeeAttendanceActivity."Pay Type" := EmployeeAttendanceActivity."Pay Type"::Paid;
                        end else begin
                            EmployeeAttendanceActivity."Pay Type" := EmployeeAttendanceActivity."Pay Type"::Unpaid;
                        end;
                        if leave."Leave Type" = Leave."Leave Type"::"Full Day" then begin
                            EmployeeAttendanceActivity."Leave Day" := 1;
                            EmployeeAttendanceActivity."Present Day" := 0;
                        end else begin
                            EmployeeAttendanceActivity."Leave Day" := 0.5;
                            EmployeeAttendanceActivity."Present Day" := 0.5;
                        end;
                        EmployeeAttendanceActivity."Leave Code" := LeaveTypeSetup.Code;
                        EmployeeAttendanceActivity."Tour Day" := 0;
                        EmployeeAttendanceActivity."Half Day" := 0;
                        EmployeeAttendanceActivity."OT Hrs" := 0;
                        EmployeeAttendanceActivity."OT Day" := 0;
                        EmployeeAttendanceActivity."Late Day" := 0;
                        EmployeeAttendanceActivity."Outdoor Duty Day" := 0;
                        EmployeeAttendanceActivity."Training Day" := 0;
                        EmployeeAttendanceActivity.Validate("Leave Description", Leave."Leave Description");
                    end;

                EmployeeActType::"Travel Request":
                    begin
                        EmployeeAttendanceActivity."Leave Day" := 0;
                        EmployeeAttendanceActivity.Validate("Present Day", 1);
                        EmployeeAttendanceActivity."Absent Day" := 0;
                        EmployeeAttendanceActivity."Tour Day" := 1;
                        EmployeeAttendanceActivity."Half Day" := 0;
                        EmployeeAttendanceActivity."OT Hrs" := 0;
                        EmployeeAttendanceActivity."OT Day" := 0;
                        EmployeeAttendanceActivity."Late Day" := 0;
                        EmployeeAttendanceActivity."Outdoor Duty Day" := 0;
                        EmployeeAttendanceActivity."Training Day" := 0;
                    end;
            end;

        end;
        EmployeeAttendanceActivity."Employee Activity Found" := true;
        EmployeeAttendanceActivity."Source No." := EmpActNo;
        EmployeeAttendanceActivity."Created Datetime" := CurrentDateTime;
        CalcAttendance(EmployeeAttendanceActivity);
        EmployeeAttendanceActivity.Modify;
    end;

    local procedure CalcAttendance(var EmployeeAttendanceActivity: Record "Employee Attendance & Activity")
    var
        AttendanceSetup: Record "Attendance Setup";
        CheckInLateMinutes: Duration;
        CheckOutEarlyMinutes: Duration;
        CheckInEarlyMinutes: Duration;
        CheckOutLateMinutes: Duration;
        TempRemarks: Text[100];
        EmpVar: Record Employee;
    begin
        AttendanceSetup.Get;
        EmpVar.Get(EmployeeAttendanceActivity."Employee No.");
        if IsHoliday(AttendanceSetup."Base Calender",
                        EmployeeAttendanceActivity."Attendance Date",
                        TempRemarks, EmpVar."Province Code",
                        EmpVar.Gender,
                        EmpVar."Inside/Outside Valley",
                        EmpVar."Posting Region",
                        EmpVar."Branch Code",
                        HRMgt.GetEmployeeDeputationDistrictName(EmpVar."Deputation on", EmpVar."Deputation On Code"),
                        HRMgt.GetEmployeeDeputationMunicipalityCode(EmpVar."Deputation on", EmpVar."Deputation On Code"),
                        EmpVar.Community,
                        EmpVar.Disabled) then begin

            if AttendanceSetup."Min. minutes to be OT Eligible" <> 0 then begin
                EmployeeAttendanceActivity."OT Hrs" := Round((EmployeeAttendanceActivity."Actual Work Time" / (60 * 1000)) / AttendanceSetup."Min. minutes to be OT Eligible", 1, '<');
                if EmployeeAttendanceActivity."OT Hrs" > 0 then
                    EmployeeAttendanceActivity."OT Day" := 1;
            end;
        end else begin
            if not EmpVar."Automatic Attendance" then begin
                if (EmployeeAttendanceActivity."Shift Start Time" <> 0T) and (EmployeeAttendanceActivity."Check In Time" <> 0T) then
                    EmployeeAttendanceActivity."Check In Difference" := EmployeeAttendanceActivity."Shift Start Time" - EmployeeAttendanceActivity."Check In Time";
                if (EmployeeAttendanceActivity."Check Out Time" <> 0T) and (EmployeeAttendanceActivity."Shift End Time" <> 0T) then
                    EmployeeAttendanceActivity."Check Out Difference" := EmployeeAttendanceActivity."Check Out Time" - EmployeeAttendanceActivity."Shift End Time";
                if EmployeeAttendanceActivity."Check In Difference" < 0 then
                    EmployeeAttendanceActivity."Late Check In Day" := 1;
                if EmployeeAttendanceActivity."Check Out Difference" < 0 then
                    EmployeeAttendanceActivity."Early Check Out Day" := 1;

                if AttendanceSetup."Per Day Late Tolerance" <> 0 then begin
                    if EmployeeAttendanceActivity."Check In Difference" < 0 then
                        CheckInLateMinutes := EmployeeAttendanceActivity."Check In Difference" / (60 * 1000);
                    if EmployeeAttendanceActivity."Check Out Difference" < 0 then
                        CheckOutEarlyMinutes := EmployeeAttendanceActivity."Check Out Difference" / (60 * 1000);
                    if (Abs(CheckInLateMinutes) > AttendanceSetup."Per Day Late Tolerance") or
                        ((Abs(CheckOutEarlyMinutes) > AttendanceSetup."Per Day Late Tolerance")) then begin
                        if EmployeeAttendanceActivity."Leave Day" = 0 then begin
                            EmployeeAttendanceActivity."Present Day" := 0.5;
                            EmployeeAttendanceActivity."Absent Day" := 0.5;
                            EmployeeAttendanceActivity."Half Day" := 0.5;
                        end;
                    end;
                end;

                if AttendanceSetup."Min. minutes to be OT Eligible" <> 0 then begin
                    if EmployeeAttendanceActivity."Check In Difference" > 0 then
                        CheckInEarlyMinutes := EmployeeAttendanceActivity."Check In Difference" / (60 * 1000);
                    if EmployeeAttendanceActivity."Check Out Difference" > 0 then
                        CheckOutLateMinutes := EmployeeAttendanceActivity."Check Out Difference" / (60 * 1000);

                    if CheckInEarlyMinutes > AttendanceSetup."Min. minutes to be OT Eligible" then
                        EmployeeAttendanceActivity."OT Hrs" := Round(CheckInEarlyMinutes / AttendanceSetup."Min. minutes to be OT Eligible", 1, '<');
                    if CheckOutLateMinutes > AttendanceSetup."Min. minutes to be OT Eligible" then
                        EmployeeAttendanceActivity."OT Hrs" += Round(CheckOutLateMinutes / AttendanceSetup."Min. minutes to be OT Eligible", 1, '<');
                    if EmployeeAttendanceActivity."OT Hrs" > 0 then
                        EmployeeAttendanceActivity."OT Day" := 1;
                end;
                if (EmployeeAttendanceActivity."Check In Time" <> 0T) and (EmployeeAttendanceActivity."Check Out Time" <> 0T) then
                    EmployeeAttendanceActivity."Actual Work Time" := EmployeeAttendanceActivity."Check Out Time" - EmployeeAttendanceActivity."Check In Time";
                EmployeeAttendanceActivity."Work Time Difference" := EmployeeAttendanceActivity."Actual Work Time" - EmployeeAttendanceActivity."Standard Work Time";
            end;
        end;
    end;

    local procedure CalculateLateDays(EmployeeCode: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        AttendanceSetup: Record "Attendance Setup";
        LateCheckInMinutes: Decimal;
        EarlyCheckOutMinutes: Decimal;
    begin
        AttendanceSetup.Get;
        if AttendanceSetup."Per Month Late Tolerance" <> 0 then begin
            EmployeeAttendanceActivity.Reset;
            EmployeeAttendanceActivity.SetCurrentKey("Employee No.", "Check In Difference");
            EmployeeAttendanceActivity.Ascending(false);
            EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
            EmployeeAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
            EmployeeAttendanceActivity.SetRange("Late Check In Day", 1);
            if EmployeeAttendanceActivity.FindSet then
                repeat
                    LateCheckInMinutes += EmployeeAttendanceActivity."Check In Difference" / (60 * 1000);
                    if Abs(LateCheckInMinutes) > AttendanceSetup."Per Month Late Tolerance" then begin
                        EmployeeAttendanceActivity."Late Day" := 1;
                        EmployeeAttendanceActivity.Modify;
                    end;
                until EmployeeAttendanceActivity.Next = 0;

            EmployeeAttendanceActivity.Reset;
            EmployeeAttendanceActivity.SetCurrentKey("Employee No.", "Check Out Difference");
            EmployeeAttendanceActivity.Ascending(false);
            EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
            EmployeeAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
            EmployeeAttendanceActivity.SetRange("Early Check Out Day", 1);
            if EmployeeAttendanceActivity.FindSet then
                repeat
                    EarlyCheckOutMinutes += EmployeeAttendanceActivity."Check Out Difference" / (60 * 1000);
                    if Abs(EarlyCheckOutMinutes) > AttendanceSetup."Per Month Late Tolerance" then begin
                        EmployeeAttendanceActivity."Late Day" := 1;
                        EmployeeAttendanceActivity.Modify;
                    end;
                until EmployeeAttendanceActivity.Next = 0;
        end;
    end;

    local procedure IsHoliday(BaseCalendar: Code[20]; Date: Date; Remarks: Text[100]; Provience: Text; Gender: Enum "Employee Gender"; InOutValley: Enum "Outside/Inside Valley";
                                 PostingRegion: enum Region; Branch: Text; District: Text; Municipality: Text; Community: Enum "Community Type"; Disabled: Boolean): Boolean
    var
        HrMgmt: Codeunit "HR Mgt.";
    begin
        exit(HrMgmt.CheckDateStatus(BaseCalendar, Date, Remarks, Provience, Gender, InOutValley, PostingRegion, Branch, District, Municipality, Community, Disabled));
    end;

    // procedure NormalizeAttendanceLogTimeFields(var AttenLog: Record "Attendance Log")
    // var
    //     RecRef: RecordRef;
    //     FldRef: FieldRef;
    //     FieldCount: Integer;
    //     i: Integer;
    //     ConstDate: Date;
    //     TimeVal: Time;
    // begin
    //     ConstDate := DMY2Date(1, 1, 1753); // Standard dummy date

    //     AttenLog."Log Time" := CreateDateTime(ConstDate, AttenLog."Log Time");
    // end;
    procedure ApproveLateAttendance(docNo: Code[20])
    var
        EmpAttenActivity: Record "Employee Attendance & Activity";
        AttenMissed: Record "Attendance Missed";
    begin
        AttenMissed.Get(docNo);
        if AttenMissed.Type <> AttenMissed.Type::"Late Attendance" then
            exit;

        if EmpAttenActivity.Get(AttenMissed."Employee No.", AttenMissed."Start Date") then begin
            EmpAttenActivity."Late Remarks" := AttenMissed.Remarks;
            EmpAttenActivity.Modify();
        end
        else begin
            DailyAttendanceUpdate(AttenMissed."Start Date", AttenMissed."Start Date", AttenMissed."Employee No.");
            Commit();
            ApproveLateAttendance(AttenMissed."No.");
        end;
    end;

    var
        AttendanceLine: Record "Attendance Line";
        AttendanceLog: Record "Attendance Log";
        EngNep: Record "English-Nepali Date";
        CalendarDescription: Text;
        ShiftLine: Record "Shift Line";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";

}
