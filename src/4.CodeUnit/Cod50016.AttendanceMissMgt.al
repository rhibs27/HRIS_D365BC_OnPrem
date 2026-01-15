codeunit 50016 "AttendanceMiss Mgt"
{
    var

        PayrollSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        Employee: Record Employee;
        AttendanceMgt: Codeunit "Attendance Mgt";

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
        AttendanceMissed1: Record "Attendance Missed";
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
        HRMgt.SendMailFromTemplate(DATABASE::"Attendance Missed", AttendanceMissed1.Type, "Approval Status"::Pending, AttendanceMissed1."Employee No.", AttendanceMissed1."No.", false);   //For email
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

    procedure CheckForLeaveOnAttendanceMissed(StartDate: Date; EndDate: Date; EmpCode: Code[20])
    var
        EmployeeAttendance: Record "Employee Attendance & Activity";
        IsHandled: Boolean;
    begin
        if (StartDate > Today) or (EndDate > Today) then
            Error('Start date or end date cannot be greater than today');
        OnSkipForCallBackApprovedLeave(StartDate, EndDate, EmpCode, IsHandled);
        if not IsHandled then begin
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
        CheckOutDate: Date;
    begin
        AttendanceMissed.Get(AttendanceMissCode);
        Employee.Get(AttendanceMissed."Employee No.");
        if AttendanceMissed.Type = AttendanceMissed.Type::"Attendance Missed" then begin
            MachineEmpNo := ReturnEmpMachineCode(Employee."No.");
            if AttendanceMissed."Check In Time" <> 0T then
                if not CheckAttendanceLogs(MachineEmpNo, AttendanceMissed."Start Date", AttendanceMissed."Check In Time") then begin//Check Already exits logs
                    AttendanceLog.Init();
                    Evaluate(LogDateTime, format(AttendanceMissed."Start Date") + ' ' + Format(AttendanceMissed."Check In Time"));
                    AttendanceLog.Validate("Emp DateTime", MachineEmpNo + Format(AttendanceMissed."Start Date", 0, '<Year4>-<Month,2>-<Day,2>') + ' ' + Format(AttendanceMissed."Check In Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'));
                    AttendanceLog.Validate("Employee ID", AttendanceMissed."Employee No.");
                    AttendanceLog.Validate(Date, AttendanceMissed."Start Date");
                    AttendanceLog.Validate("Log Time", AttendanceMissed."Check In Time");
                    AttendanceLog.Validate("Date Time Log", LogDateTime);
                    AttendanceLog.Validate("Biometric Attendance", false);
                    AttendanceLog."Machine Emp. Code" := Employee."Employee Attendance ID";
                    AttendanceLog.Insert();
                end;
            if AttendanceMissed."Check Out Time" <> 0T then begin
                if AttendanceMissed."Checkout OverNight" then begin//For OverNight Checkout
                    CheckOutDate := AttendanceMissed."Start Date" + 1;
                end else begin
                    CheckOutDate := AttendanceMissed."Start Date";
                end;
                if not CheckAttendanceLogs(MachineEmpNo, CheckOutDate, AttendanceMissed."Check Out Time") then begin
                    AttendanceLog.Init();
                    AttendanceLog.Validate("Emp DateTime", MachineEmpNo + Format(CheckOutDate, 0, '<Year4>-<Month,2>-<Day,2>') + ' ' + Format(AttendanceMissed."Check Out Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'));
                    Evaluate(LogDateTime, format(CheckOutDate) + ' ' + Format(AttendanceMissed."Check Out Time"));
                    AttendanceLog.Validate(Date, CheckOutDate);
                    AttendanceLog.Validate("Employee ID", AttendanceMissed."Employee No.");
                    AttendanceLog.Validate("Log Time", AttendanceMissed."Check Out Time");
                    AttendanceLog.Validate("Date Time Log", LogDateTime);
                    AttendanceLog.Validate("Biometric Attendance", false);
                    AttendanceLog."Machine Emp. Code" := Employee."Employee Attendance ID";
                    AttendanceLog.Insert();
                end;
            end;
            // Update Daily Attendance
            if AttendanceMgt.DailyAttendanceUpdate(AttendanceMissed."Start Date", AttendanceMissed."Start Date", AttendanceMissed."Employee No.") then begin
                EmpAttendActivity.SetRange("Attendance Date", AttendanceMissed."Start Date");
                EmpAttendActivity.SetRange("Employee No.", AttendanceMissed."Employee No.");
                if EmpAttendActivity.FindSet() then
                    EmpAttendActivity.ModifyAll("Attendance Update", true);
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
        leaveDay: Record Leave;
        Ishandled: Boolean;
    begin
        OnSkipForCallBackApprovedLeave(AttendanceJRN."Start Date", AttendanceJRN."Start Date", AttendanceJRN."Employee No.", Ishandled);
        if not Ishandled then begin
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
    end;

    procedure CheckAttendanceLogs(MachineEmpNo: Code[20]; AttendanceDate: Date; LogTime: Time): Boolean
    var
        AttendanceLogs: Record "Attendance Log";
        FindRecord: Boolean;
        EmpDateTime: Text[100];
    begin
        AttendanceLogs.Reset();
        EmpDateTime := MachineEmpNo + Format(AttendanceDate, 0, '<Year4>-<Month,2>-<Day,2>') + ' ' + Format(LogTime, 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
        FindRecord := AttendanceLogs.Get(EmpDateTime);
        exit(FindRecord);
    end;

    procedure ReturnEmpMachineCode(EmpCode: Code[20]): Code[20]
    begin
        Employee.Get(EmpCode);
        if (Employee."No." = Employee."Employee Attendance ID") or (Employee."Employee Attendance ID" = '') then
            exit(Employee."No.")
        else
            exit(Employee."Employee Attendance ID");
    end;

    procedure GetUserDeviceIp(AttendanceMissed: Record "Attendance Missed"): Text[30]
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnSkipForCallBackApprovedLeave(StartDate: Date; EndDate: Date; EmployeeCode: Code[20]; var Ishandled: Boolean)
    begin
    end;
}
