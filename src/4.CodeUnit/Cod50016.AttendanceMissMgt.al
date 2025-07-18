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
        // CancelDocumentTemp.Validate("Recommender Code", CancelDocument."Recommender Code");
        // CancelDocumentTemp.Validate("Approver Code", CancelDocument."Approver Code");
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
        // CancelDocument.Validate("Recommender Code", Employee."KPI Deputation Value");
        // CancelDocument.Validate("Approver Code", Employee."Approver Code");
        AttendanceMissed.Insert;
        PAGE.Run(PAGE::"Attendance Missed card", AttendanceMissed);
    end;

    procedure OpenLateAttendance(EmpCode: Code[20])
    var
        //TempEmpActivity: Record "Employee Activity" temporary;
        //CancelDocument: Record "Cancel Document" temporary;
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
        // CancelDocument.Validate("Recommender Code", Employee."KPI Deputation Value");
        // CancelDocument.Validate("Approver Code", Employee."Approver Code");
        AttendanceMissed.Insert;
        PAGE.Run(PAGE::"Late Attendance Card", AttendanceMissed);
    end;

    // procedure ApplyLateAttendance(AttendanceMissed: Record "Attendance Missed" temporary)
    // var
    //     AttendanceMissed1: Record "Attendance Missed";
    // begin
    //     if GuiAllowed then
    //         if not Confirm('Do you want to apply the document?', false) then
    //             exit;
    //     PayrollSetup.Get;
    //     if AttendanceMissed."No." = '' then begin
    //         AttendanceMissed.TestField("Start Date");
    //         if (AttendanceMissed."Start Date" >= Today) or (AttendanceMissed."End Date" >= Today) then
    //             Error('Cannot apply for future date.Please check the date.');
    //         if AttendanceMissed."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date" then
    //             Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
    //         AttendanceMissed.TestField("End Date");
    //         AttendanceMissed.TestField(Remarks);
    //         AttendanceMissed1.Init;
    //         AttendanceMissed1.TransferFields(AttendanceMissed);
    //         AttendanceMissed1.Validate("Approval Status", AttendanceMissed1."Approval Status"::Pending);
    //         AttendanceMissed1.Insert(true);
    //     end;
    // end;

    procedure ApplyAttendanceMissed(AttendanceMissed: Record "Attendance Missed" temporary): Code[20]
    var
        AttendanceMissed1, AttendanceMissed2 : Record "Attendance Missed";
    begin
        if GuiAllowed then
            if not Confirm('Do you want to apply the document?', false) then
                exit;
        AttendanceMissed2.Reset();
        AttendanceMissed2.SetRange("Employee No.", AttendanceMissed."Employee No.");
        AttendanceMissed2.SetRange("Start Date", AttendanceMissed."Start Date");
        AttendanceMissed2.Setfilter("Approval Status", '<>%1', AttendanceMissed2."Approval Status"::Rejected);
        if AttendanceMissed2.FindFirst then
            Error('%1 already applied on %2', AttendanceMissed.Type, AttendanceMissed."Start Date");
        PayrollSetup.Get;
        if AttendanceMissed.Type = AttendanceMissed.Type::"Attendance Missed" then
            CheckForLeaveOnAttendanceMissed(AttendanceMissed."Start Date", AttendanceMissed."End Date", AttendanceMissed."Employee No.");
        if AttendanceMissed."No." = '' then begin
            AttendanceMissed.TestField("Start Date");
            if (AttendanceMissed."Start Date" >= Today) or (AttendanceMissed."End Date" >= Today) then
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
        //EmployeeActivity: Record "Employee Activity";
        //CancelDocument2: Record "Cancel Document";
        //EmployeeActivity2: Record "Employee Activity";
        leave: Record Leave;
        //EmpAct: Record "Employee Activity";
        LeaveCancelError: Label 'Your leave request no. %1 of code %2 has been already cancelled.';
    begin
        if GuiAllowed then
            if not Confirm('Do you want to apply the document?', false) then
                exit;
        if CancelDocument.Type = CancelDocument.Type::"Leave Request" then begin //Min 10.13.2022
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
            // if (CancelDocument."Start Date" > Today) or (CancelDocument."End Date" > Today) then
            //     Error('Cannot apply for future date.Please check the date.');
            if CancelDocument."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date" then
                Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
            CancelDocument.TestField("End Date");
            CancelDocument.TestField(Remarks);
            CancelDocument1.Init;
            CancelDocument1.TransferFields(CancelDocument);
            CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Pending);
            // if CancelDocument."Recommender Code" <> '' then
            //     CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Pending)
            // else
            //     CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Recommended);

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
            // end else begin
            //     CancelDocument1.Get(CancelDocument."No.");
            //     if CancelDocument1."Recommender Code" <> '' then
            //         CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Pending)
            //     else
            //         CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Recommended);
            //     CancelDocument1.Modify(true);
        end;


        // if CancelDocument1.Type = CancelDocument1.Type::"Leave Request" then begin
        //     Clear(CancelDocument2);
        //     CancelDocument2.Get(CancelDocument."Cancelled Document No.");
        //     CancelDocument2."Cancelled No." := CancelDocument1."No.";
        //     CancelDocument2.Modify;

        //     if (CancelDocument1."Start Date" < CancelDocument2."Start Date") or (CancelDocument1."End Date" < CancelDocument2."Start Date") then
        //         Error('Date must be between %1 and %2', CancelDocument2."Start Date", CancelDocument2."End Date");

        //     if (CancelDocument1."Start Date" > CancelDocument2."End Date") or (CancelDocument1."End Date" > CancelDocument2."End Date") then
        //         Error('Date must be between %1 and %2', CancelDocument2."Start Date", CancelDocument2."End Date");

        // end;
    end;

    procedure ScreenCancelledLeave(CancelDocument: Record "Cancel Document")
    var
        LeaveEarn: Record "Leave Earn";
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        CancelDocument.TestField("Approval Status", CancelDocument."Approval Status"::Approved);
        CancelDocument.TestField(Type, CancelDocument.Type::"Leave Request");
        Employee.Get(HRMgt.GetEmployeeNo);
        // if not Employee.Screener then
        //     Error('You are not eligible to screen this document.');
        if CancelDocument.Type = CancelDocument.Type::"Leave Request" then begin
            //LeaveEarn.RESET;
            LeaveEarn.Init;
            LeaveEarn.Validate("Leave Code", CancelDocument."Leave Code");
            LeaveEarn.Validate("Leave Description", CancelDocument."Leave Description");
            LeaveEarn.Validate("Leave Request No", CancelDocument."No.");
            LeaveEarn.Validate(EmpNo, CancelDocument."Employee No.");
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
                    //EmpAttendActivity."Week Off Day" := 0;
                    EmpAttendActivity."Tour Day" := 0;
                    EmpAttendActivity."Source No." := CancelDocument."No.";
                    EmpAttendActivity."Employee Activity Found" := true;
                    EmpAttendActivity."Leave Description" := '';
                    EmpAttendActivity."Created Datetime" := CurrentDateTime;
                    EmpAttendActivity.Modify;
                until EmpAttendActivity.Next = 0;
        end;
        // CancelDocument."Approval Status" := CancelDocument."Approval Status"::Screened;
        // CancelDocument.Modify;
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
    begin
        AttendanceMissed.Get(AttendanceMissCode);
        if AttendanceMissed.Type = AttendanceMissed.Type::"Attendance Missed" then begin
            if AttendanceMissed."Check In Time" <> 0T then begin
                AttendanceLog.Init();
                AttendanceLog.Validate("Emp DateTime", AttendanceMissed."Employee No." + Format(AttendanceMissed."Start Date") + Format(AttendanceMissed."Check In Time"));
                AttendanceLog.Validate("Employee ID", AttendanceMissed."Employee No.");
                AttendanceLog.Validate(Date, AttendanceMissed."Start Date");
                AttendanceLog.Validate("Log Time", AttendanceMissed."Check In Time");
                AttendanceLog.Validate("Biometric Attendance", false);
                AttendanceLog.Insert();
            end;
            if AttendanceMissed."Check Out Time" <> 0T then begin
                AttendanceLog.Init();
                AttendanceLog.Validate("Emp DateTime", AttendanceMissed."Employee No." + Format(AttendanceMissed."Start Date") + Format(AttendanceMissed."Check Out Time"));
                AttendanceLog.Validate("Employee ID", AttendanceMissed."Employee No.");
                AttendanceLog.Validate(Date, AttendanceMissed."Start Date");
                AttendanceLog.Validate("Log Time", AttendanceMissed."Check Out Time");
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
}
