codeunit 50016 "AttendanceMiss Mgt"
{
    var

        PayrollSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        Employee: Record Employee;
        LeaveMgt: Codeunit "Leave Mgt.";
        AttendanceSetup: Record "Attendance Setup";
        AttendanceMgt: Codeunit "Attendance Mgt";


    local procedure "----------Cancel-----------"()
    begin
    end;

    procedure OpenCancelEmpActivity(CancelDocument: Record "Cancel Document")
    var
        //Leave: Record "Leave" temporary;
        CancelDocumentTemp: Record "Employee Activity" temporary;
    begin
        if not Confirm('Do you want to cancel document?', false) then
            exit;
        CancelDocument.TestField("Approval Status", CancelDocument."Approval Status"::Approved);
        CancelDocument.TestField("Cancelled Document No.", '');
        CancelDocumentTemp.Init;
        CancelDocumentTemp.Validate(Cancelled, true);
        CancelDocumentTemp.Validate("Employee No.", CancelDocument."Employee No.");
        CancelDocumentTemp.Validate("Employee Name", CancelDocument."Employee Name");
        CancelDocumentTemp.Validate("Approval Status", CancelDocumentTemp."Approval Status"::Open);
        CancelDocumentTemp.Validate(Type, CancelDocument.Type);
        CancelDocumentTemp.Validate("Leave Code", CancelDocument."Leave Code");
        CancelDocumentTemp.Validate("Requested Date", Today);
        CancelDocumentTemp.Validate("Start Date", CancelDocument."Start Date");
        CancelDocumentTemp.Validate("End Date", CancelDocument."End Date");
        CancelDocumentTemp.Validate("No. of Days", CancelDocument."No. of Days");
        CancelDocumentTemp."Cancelled Document No." := CancelDocument."No.";
        CancelDocumentTemp.Insert;
        if PAGE.RunModal(PAGE::"Cancel Document", CancelDocumentTemp) = ACTION::LookupOK then;
    end;

    procedure OpenAttendanceMissed(EmpCode: Code[20])
    var
        AttendanceMissed: Record "Attendance Missed" temporary;
        ApprovalEntry: Record "Approval HRMS";
    begin
        if not Confirm('Do you want to apply for attendance missed?', false) then
            exit;
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Attendance Missed");
        ApprovalEntry.SetRange("Employee No", EmpCode);
        ApprovalEntry.SetRange("Document No.", '');
        ApprovalEntry.DeleteAll();
        Employee.Get(EmpCode);
        AttendanceMissed.Init;
        AttendanceMissed.Validate("Employee No.", EmpCode);
        AttendanceMissed.Validate("Employee Name", Employee."Full Name");
        AttendanceMissed.Validate("Approval Status", AttendanceMissed."Approval Status"::Open);
        AttendanceMissed.Validate(Type, AttendanceMissed.Type::"Attendance Missed");
        AttendanceMissed.Validate("Requested Date", Today);
        AttendanceMissed.Insert;
        PAGE.Run(PAGE::"Attendance Missed card", AttendanceMissed);
    end;

    procedure OpenLateAttendance(EmpCode: Code[20])
    var
        AttendanceMissed: Record "Attendance Missed" temporary;
        ApprovalEntry: Record "Approval HRMS";
    begin
        if not Confirm('Do you want to apply for Late Attendance?', false) then
            exit;
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Late Attendance");
        ApprovalEntry.SetRange("Employee No", EmpCode);
        ApprovalEntry.SetRange("Document No.", '');
        ApprovalEntry.DeleteAll();
        Employee.Get(EmpCode);
        AttendanceMissed.Init;
        AttendanceMissed.Validate("Employee No.", EmpCode);
        AttendanceMissed.Validate("Employee Name", Employee."Full Name");
        AttendanceMissed.Validate("Approval Status", AttendanceMissed."Approval Status"::Open);
        AttendanceMissed.Validate(Type, AttendanceMissed.Type::"Late Attendance");
        AttendanceMissed.Validate("Requested Date", Today);
        AttendanceMissed.Insert;
        PAGE.Run(PAGE::"Late Attendance Card", AttendanceMissed);
    end;

    procedure ApplyAttendanceMissed(AttendanceMissed: Record "Attendance Missed" temporary): Code[20]
    var
        AttendanceMissed1, AttendanceMissed2 : Record "Attendance Missed";
    begin
        if GuiAllowed then
            if not Confirm('Do you want to apply the document?', false) then
                exit;
        CheckAlreadyExists(AttendanceMissed."Employee No.", AttendanceMissed.Type, AttendanceMissed."Start Date");
        PayrollSetup.Get;
        if AttendanceMissed.Type = AttendanceMissed.Type::"Attendance Missed" then
            CheckForLeaveOnAttendanceMissed(AttendanceMissed."Start Date", AttendanceMissed."End Date", AttendanceMissed."Employee No.");
        if AttendanceMissed."No." = '' then begin
            AttendanceMissed.TestField("Start Date");
            if (AttendanceMissed."Start Date" > Today) or (AttendanceMissed."End Date" > Today) then
                Error('Cannot apply for future date.Please check the date.');
            if AttendanceMissed."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date" then
                Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
            AttendanceMissed.TestField("End Date");
            AttendanceMissed.TestField(Remarks);
            AttendanceMissed1.Init;
            AttendanceMissed1.TransferFields(AttendanceMissed);
            AttendanceMissed1.Validate("Approval Status", AttendanceMissed1."Approval Status"::Pending);
            AttendanceMissed1.Insert(true);
        end;
        exit(AttendanceMissed1."No.");
    end;

    procedure ApplyCancelEmployeeActivity(CancelDocument: Record "Cancel Document" temporary): Text
    var
        CancelDocument1: Record "Cancel Document";
        leave: Record Leave;
        LeaveCancelError: Label 'Your leave request no. %1 of code %2 has been already cancelled.';
    begin
        if GuiAllowed then
            if not Confirm('Do you want to apply the document?', false) then
                exit;
        if CancelDocument.Type = CancelDocument.Type::"Leave Request" then begin
            leave.Reset;
            leave.SetRange("Cancelled Document No.", CancelDocument."Cancelled Document No.");
            leave.SetFilter("Approval Status", '<>%1', leave."Approval Status"::Rejected);
            if leave.FindFirst then
                Error(LeaveCancelError, leave."No.", leave."Leave Code");
        end;
        PayrollSetup.Get;
        if CancelDocument.Type = CancelDocument.Type::"Attendance Missed" then
            CheckForLeaveOnAttendanceMissed(CancelDocument."Start Date", CancelDocument."End Date", CancelDocument."Employee No.");
        if CancelDocument."No." = '' then begin
            CancelDocument.TestField("Start Date");
            if CancelDocument."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date" then
                Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
            CancelDocument.TestField("End Date");
            CancelDocument.TestField(Remarks);
            CancelDocument1.Init;
            CancelDocument1.TransferFields(CancelDocument);
            CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Pending);
            CancelDocument1."Cancelled No." := '';
            CancelDocument1.Insert(true);
            leave.Reset;
            if leave.Get(CancelDocument1."Cancelled Document No.") then begin
                leave.Validate("Cancelled No.", CancelDocument1."No.");
                leave.Validate(Cancelled, true);
                leave.Modify(true);
            end else
                Error('Leave request no. %1 not found.', CancelDocument1."Cancelled Document No.");
            exit(CancelDocument1."No.");
        end;
    end;

    procedure ScreenCancelledLeave(CancelDocument: Record "Cancel Document")
    var
        LeaveEarn: Record "Leave Earn";
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        CancelDocument.TestField("Approval Status", CancelDocument."Approval Status"::Approved);
        CancelDocument.TestField(Type, CancelDocument.Type::"Leave Request");
        Employee.Get(HRMgt.GetEmployeeNo);
        if CancelDocument.Type = CancelDocument.Type::"Leave Request" then begin
            LeaveEarn.Init;
            LeaveEarn.Validate("Entry No.", leaveMgt.GetNextLeaveLedgerEntryNo());
            LeaveEarn.Validate("Leave Code", CancelDocument."Leave Code");
            LeaveEarn.Validate("Leave Description", CancelDocument."Leave Description");
            LeaveEarn.Validate("Leave Request No", CancelDocument."No.");
            LeaveEarn.Validate("Employee No.", CancelDocument."Employee No.");
            LeaveEarn.Validate("Employee Full Name", CancelDocument."Employee Name");
            LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(Today));
            LeaveEarn.Validate("Posted Date", Today);
            LeaveEarn.Validate("Balancing Days", CancelDocument."No. of Days");
            LeaveEarn.Validate(Type, LeaveEarn.Type::Cancelled);
            LeaveEarn.Insert(true);

            EmpAttendActivity.Reset;
            EmpAttendActivity.SetRange("Employee No.", CancelDocument."Employee No.");
            EmpAttendActivity.SetRange("Attendance Date", CancelDocument."Start Date", CancelDocument."End Date");
            if EmpAttendActivity.Find('-') then
                repeat
                    if EmpAttendActivity."Check In Time" <> 0T then begin
                        EmpAttendActivity."Absent Day" := 0;
                        EmpAttendActivity."Present Day" := 1;
                    end else begin
                        EmpAttendActivity."Present Day" := 0;
                        EmpAttendActivity."Absent Day" := 1;
                    end;
                    if LeaveMgt.GetNonWorkingDays(EmpAttendActivity."Attendance Date", EmpAttendActivity."Attendance Date", EmpAttendActivity."Employee No.") <> 0 then begin
                        EmpAttendActivity."Absent Day" := 0;
                    end;
                    EmpAttendActivity."Leave Day" := 0;
                    EmpAttendActivity."Tour Day" := 0;
                    EmpAttendActivity."Source No." := CancelDocument."No.";
                    EmpAttendActivity."Employee Activity Found" := true;
                    EmpAttendActivity."Leave Description" := '';
                    EmpAttendActivity."Created Datetime" := CurrentDateTime;
                    EmpAttendActivity.Modify;
                until EmpAttendActivity.Next = 0;
        end;
    end;

    procedure CheckForLeaveOnAttendanceMissed(StartDate: Date; EndDate: Date; EmpCode: Code[20])
    var
        EmployeeAttendance: Record "Employee Attendance & Activity";
    begin
        if (StartDate > Today) or (EndDate > Today) then
            Error('Start date or end date cannot be greater than today');
        Employee.Get(EmpCode);
        EmployeeAttendance.Reset;
        EmployeeAttendance.SetRange("Employee No.", EmpCode);
        EmployeeAttendance.SetRange("Attendance Date", StartDate, EndDate);
        EmployeeAttendance.FilterGroup(-1);
        EmployeeAttendance.SetRange("Leave Day", 1);
        EmployeeAttendance.FilterGroup(0);
        if EmployeeAttendance.FindFirst then
            Error('You were on a leave on date %1.', EmployeeAttendance."Attendance Date");
    end;

    // >> On Approve Attendance Missed >> Santosh >> 2025-03-04
    procedure AttendanceMissedApproved(AttendanceMissCode: Code[20])
    var
        AttendanceLog: Record "Attendance Log";
        AttendanceMissed: Record "Attendance Missed";
        EmpAttendActivity: Record "Employee Attendance & Activity";
        Employee: Record Employee;
        LogDateTime: DateTime;
        MachineEmpNo: Text;
    begin
        AttendanceMissed.Get(AttendanceMissCode);
        Employee.Get(AttendanceMissed."Employee No.");
        if AttendanceMissed.Type = AttendanceMissed.Type::"Attendance Missed" then begin
            if AttendanceMissed."Check In Time" <> 0T then begin
                AttendanceLog.Init();
                if (Employee."No." = Employee."Employee Attendance ID") or (Employee."Employee Attendance ID" = '') then
                    MachineEmpNo := Employee."No."
                else
                    MachineEmpNo := Employee."Employee Attendance ID";

                Evaluate(LogDateTime, format(AttendanceMissed."Start Date") + ' ' + Format(AttendanceMissed."Check In Time"));
                AttendanceLog.Validate("Emp DateTime", MachineEmpNo + Format(AttendanceMissed."Start Date", 0, '<Year4>-<Month,2>-<Day,2>') + ' ' + Format(AttendanceMissed."Check In Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'));
                AttendanceLog.Validate("Employee ID", AttendanceMissed."Employee No.");
                AttendanceLog.Validate(Date, AttendanceMissed."Start Date");
                AttendanceLog.Validate("Log Time", AttendanceMissed."Check In Time");
                AttendanceLog.Validate("Date Time Log", LogDateTime);
                AttendanceLog.Validate("Biometric Attendance", false);
                AttendanceLog.Insert();
            end;
            if AttendanceMissed."Check Out Time" <> 0T then begin
                AttendanceLog.Init();
                if (Employee."No." = Employee."Employee Attendance ID") or (Employee."Employee Attendance ID" = '') then
                    MachineEmpNo := Employee."No."
                else
                    MachineEmpNo := Employee."Employee Attendance ID";
                Clear(LogDateTime);
                if AttendanceMissed."Checkout OverNight" then begin//For OverNight Checkout
                    AttendanceLog.Validate("Emp DateTime", MachineEmpNo + Format(AttendanceMissed."Start Date" + 1, 0, '<Year4>-<Month,2>-<Day,2>') + ' ' + Format(AttendanceMissed."Check Out Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'));
                    Evaluate(LogDateTime, format(AttendanceMissed."Start Date" + 1) + ' ' + Format(AttendanceMissed."Check Out Time"));
                    AttendanceLog.Validate(Date, AttendanceMissed."Start Date" + 1);
                end else begin
                    AttendanceLog.Validate("Emp DateTime", MachineEmpNo + Format(AttendanceMissed."Start Date", 0, '<Year4>-<Month,2>-<Day,2>') + ' ' + Format(AttendanceMissed."Check Out Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'));
                    Evaluate(LogDateTime, format(AttendanceMissed."Start Date") + ' ' + Format(AttendanceMissed."Check Out Time"));
                    AttendanceLog.Validate(Date, AttendanceMissed."Start Date");
                end;
                AttendanceLog.Validate("Employee ID", AttendanceMissed."Employee No.");
                AttendanceLog.Validate("Log Time", AttendanceMissed."Check Out Time");
                AttendanceLog.Validate("Date Time Log", LogDateTime);
                AttendanceLog.Validate("Biometric Attendance", false);
                AttendanceLog.Insert();
            end;
            // Update Daily Attendance
            if AttendanceMgt.DailyAttendanceUpdate(AttendanceMissed."Start Date", AttendanceMissed."Start Date", AttendanceMissed."Employee No.") then
                if EmpAttendActivity.get(AttendanceMissed."Employee No.", AttendanceMissed."Start Date") then begin
                    EmpAttendActivity."Attendance Update" := true;
                    EmpAttendActivity.Modify();
                end;

        end;
    end;

    procedure CheckAlreadyExists("EmployeeNo": code[20]; Type: Enum "Employee Activity Type"; "startDate": Date)
    var
        AttendanceMissed: Record "Attendance Missed";
    begin
        AttendanceMissed.Reset;
        AttendanceMissed.SetRange("Employee No.", EmployeeNo);
        AttendanceMissed.SetRange(Type, Type);
        AttendanceMissed.SetRange("Start Date", startDate);
        AttendanceMissed.SetFilter("Approval Status", '<>%1&<>%2', AttendanceMissed."Approval Status"::Rejected, AttendanceMissed."Approval Status"::Withdrawn);
        if AttendanceMissed.FindFirst then
            Error('%1 already applied for date %2 for %3', Type, AttendanceMissed."Start Date", EmployeeNo);
    end;

    procedure CheckForLeaveDay(var AttendanceJRN: Record "Employee Activity Journal")
    var
        AttendanceMissed: Record "Attendance Missed";
        leaveDay: Record Leave;
    begin
        leaveDay.Reset;
        leaveDay.SetRange("Employee No.", AttendanceJRN."Employee No.");
        leaveDay.SetRange(Type, AttendanceJRN.Type::"Leave Request");
        leaveDay.SetFilter("Approval Status", '<>%1&<>%2', leaveDay."Approval Status"::Rejected, leaveDay."Approval Status"::Withdrawn);
        if leaveDay.FindSet then
            repeat
                if ((AttendanceJRN."Start Date" > leaveDay."Start Date") and (AttendanceJRN."Start Date" < leaveDay."End Date")) or ((AttendanceJRN."End Date" > leaveDay."Start Date") and (AttendanceJRN."End Date" < leaveDay."End Date")) then
                    Error('%1 was on leave date %2', AttendanceJRN."Employee Name", AttendanceJRN."Start Date");
            until leaveDay.Next = 0;
    end;
}
