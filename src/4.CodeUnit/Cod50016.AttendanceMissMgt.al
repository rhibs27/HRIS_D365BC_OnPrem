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
        if AttendanceMissed.Type = AttendanceMissed.Type::"Attendance Missed" then
            CheckForLeaveOnAttendanceMissed(AttendanceMissed."Start Date", AttendanceMissed."End Date", AttendanceMissed."Employee No.");
        if AttendanceMissed."No." = '' then begin
            AttendanceMissed.TestField("Start Date");
            if (AttendanceMissed."Start Date" > Today) or (AttendanceMissed."End Date" > Today) then
                Error('Cannot apply for future date.Please check the date.');
            HRMgt.CheckForFiscalYearControl(AttendanceMissed."Start Date");
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
        if CancelDocument.Type = CancelDocument.Type::"Attendance Missed" then
            CheckForLeaveOnAttendanceMissed(CancelDocument."Start Date", CancelDocument."End Date", CancelDocument."Employee No.");
        if CancelDocument."No." = '' then begin
            CancelDocument.TestField("Start Date");
            HRMgt.CheckForFiscalYearControl(CancelDocument."Start Date");
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
        SalaryDeductionMgt: Codeunit "Salary Deduction Mgt";
        IsHandled: Boolean;
    begin
        AttendanceMissed.Get(AttendanceMissCode);
        Employee.Get(AttendanceMissed."Employee No.");
        if AttendanceMissed.Type = AttendanceMissed.Type::"Attendance Missed" then begin
            MachineEmpNo := ReturnEmpMachineCode(Employee."No.");
            if AttendanceMissed."Check In Time" <> 0T then
                if not CheckAttendanceLogs(MachineEmpNo, AttendanceMissed."Start Date", AttendanceMissed."Check In Time") then begin//Check Already exits logs
                    AttendanceLog.Init();
                    OnBeforeInsertAttendanceLog(AttendanceLog, IsHandled);
                    if (not GuiAllowed) and (HRMgt.IsSaaS() or IsHandled) then
                        Evaluate(LogDateTime, format(AttendanceMissed."Start Date") + ' ' + Format(AttendanceMissed."Check In Time" - (5 * 3600000 + 45 * 60000)))
                    else
                        Evaluate(LogDateTime, format(AttendanceMissed."Start Date") + ' ' + Format(AttendanceMissed."Check In Time"));
                    AttendanceLog.Validate("Emp DateTime", MachineEmpNo + Format(AttendanceMissed."Start Date", 0, '<Year4>-<Month,2>-<Day,2>') + ' ' + Format(AttendanceMissed."Check In Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'));
                    AttendanceLog.Validate("Employee ID", AttendanceMissed."Employee No.");
                    AttendanceLog.Validate(Date, AttendanceMissed."Start Date");
                    AttendanceLog.Validate("Log Time", AttendanceMissed."Check In Time");
                    AttendanceLog.Validate("Date Time Log", LogDateTime);
                    AttendanceLog.Validate("Biometric Attendance", false);
                    AttendanceLog.Validate("Document No", AttendanceMissed."No.");
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
                    OnBeforeInsertAttendanceLog(AttendanceLog, IsHandled);
                    if (not GuiAllowed) and (HRMgt.IsSaaS() or IsHandled) then  //Check wheather the environment is SaaS or not.
                        Evaluate(LogDateTime, format(CheckOutDate) + ' ' + Format(AttendanceMissed."Check Out Time" - (5 * 3600000 + 45 * 60000)))
                    else
                        Evaluate(LogDateTime, format(CheckOutDate) + ' ' + Format(AttendanceMissed."Check Out Time"));
                    AttendanceLog.Validate(Date, CheckOutDate);
                    AttendanceLog.Validate("Employee ID", AttendanceMissed."Employee No.");
                    AttendanceLog.Validate("Log Time", AttendanceMissed."Check Out Time");
                    AttendanceLog.Validate("Date Time Log", LogDateTime);
                    AttendanceLog.Validate("Biometric Attendance", false);
                    AttendanceLog.Validate("Document No", AttendanceMissed."No.");
                    AttendanceLog."Machine Emp. Code" := Employee."Employee Attendance ID";
                    AttendanceLog.Insert();
                end;
            end;

            //Reverse Deduction if found when approved.
            SalaryDeductionMgt.ReverseSalaryLedgerEntry(AttendanceMissed."Employee No.", AttendanceMissed."Start Date");

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
        AttendanceMissed.SetRange(Cancelled, false);
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

    procedure CancelAttendanceMissedJournal(var AttendanceMissedJournal: Record "Posted Employee Journal")
    begin
        If AttendanceMissedJournal."Employee Act Type" = AttendanceMissedJournal."Employee Act Type"::"Attendance Missed" then
            if not AttendanceMissedJournal.Cancelled then begin
                AttendanceMissedJournal.Validate(Cancelled, true);
                AttendanceMissedJournal.Validate("Cancelled By", HRMgt.GetEmployeeNo());
                AttendanceMissedJournal.Validate("Cancelled Date", Today);
                AttendanceMissedJournal.Modify();
                CancelledAttendanceMissed(AttendanceMissedJournal."Document No");
                CancelledAttendanceLogs(AttendanceMissedJournal."Document No");
            end else
                Error('%1 is Already Cancelled', AttendanceMissedJournal."Document No")
        else
            Error('Entry No %1 Type Must be %2', AttendanceMissedJournal."Entry No", AttendanceMissedJournal."Employee Act Type"::"Attendance Missed");
    end;

    procedure CancelledAttendanceMissed(DocNo: Code[20])
    var
        AttendanceMissed: Record "Attendance Missed";
    begin
        AttendanceMissed.Get(DocNo);
        AttendanceMissed.Validate(Cancelled, true);
        AttendanceMissed.Modify();
    end;

    procedure CancelledAttendanceLogs(DocNo: Code[20])
    var
        AttendanceLogs: Record "Attendance Log";
    begin
        AttendanceLogs.SetRange("Document No", DocNo);
        if AttendanceLogs.FindSet() then
            repeat
                AttendanceLogs.Validate(Cancelled, true);
                AttendanceLogs.Modify();
                AttendanceMgt.DailyAttendanceUpdate(AttendanceLogs.Date, AttendanceLogs.Date, AttendanceLogs."Employee ID");
            until AttendanceLogs.Next() = 0;
    end;

    procedure OpenCancelEmpActivity(AtteanceMissed: Record "Attendance Missed")
    var
        TempCancelDocument: Record "Cancel Document" temporary;
        Approval: record "Approval HRMS";
        HRSetup: Record "Human Resources Setup";
        Ishandel: Boolean;
    begin
        HRSetup.Get();
        if AtteanceMissed.Cancelled then
                Error('Update Attendance request no. %1 is already cancelled.', AtteanceMissed."No.");
        if AtteanceMissed."Approved Date" + HRSetup."Cancel Document Upto (Days)" < Today then
            Error('Leave request no. %1 cannot be cancelled after %2', AtteanceMissed."No.", AtteanceMissed."Approved Date" + HRSetup."Cancel Document Upto (Days)");
        AtteanceMissed.TestField("Approval Status", AtteanceMissed."Approval Status"::Approved);
        AtteanceMissed.TestField("Cancelled Document No.", '');
        // Clear Approval line
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Attendance Missed");
        Approval.SetRange("Employee No", AtteanceMissed."Employee No.");
        Approval.DeleteAll();
        TempCancelDocument.Init;
        TempCancelDocument.Validate(Cancelled, true);
        TempCancelDocument.Validate("Employee No.", AtteanceMissed."Employee No.");
        TempCancelDocument.Validate("Employee Name", AtteanceMissed."Employee Name");
        TempCancelDocument.Validate("Approval Status", TempCancelDocument."Approval Status"::Open);
        TempCancelDocument.Validate(Type, AtteanceMissed.Type);
        TempCancelDocument.Validate("Requested Date", Today);
        TempCancelDocument.Validate("Start Date", AtteanceMissed."Start Date");
        TempCancelDocument.Validate("CheckIn Time", AtteanceMissed."Check In Time");
        TempCancelDocument.Validate("CheckOut Time", AtteanceMissed."Check Out Time");
        TempCancelDocument.Validate("Previous Check In Time", AtteanceMissed."Previous Check In Time");
        TempCancelDocument.Validate("Previous Check Out Time", AtteanceMissed."Previous Check Out Time");
        TempCancelDocument."Cancelled Document No." := AtteanceMissed."No.";
        TempCancelDocument."No." := '';
        TempCancelDocument.Insert;
        PAGE.Run(PAGE::"Cancel Document", TempCancelDocument)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSkipForCallBackApprovedLeave(StartDate: Date; EndDate: Date; EmployeeCode: Code[20]; var Ishandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertAttendanceLog(var AttendanceLog: Record "Attendance Log"; var IsHandled: Boolean)
    begin
    end;
}
