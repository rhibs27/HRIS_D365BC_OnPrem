codeunit 50016 "AttendanceMiss Mgt"
{
    var

        PayrollSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        Employee: Record Employee;
        LeaveMgt: Codeunit "Leave Mgt.";
        AttendanceSetup: Record "Attendance Setup";


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
        //TempEmpActivity: Record "Employee Activity" temporary;
        //CancelDocument: Record "Cancel Document" temporary;
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



    procedure ApplyAttendanceMissed(AttendanceMissed: Record "Attendance Missed" temporary)
    var
        AttendanceMissed1: Record "Attendance Missed";
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
        if AttendanceMissed.Type = AttendanceMissed.Type::"Leave Request" then begin //Min 10.13.2022
            leave.Reset;
            leave.SetRange("Cancelled Document No.", AttendanceMissed."Cancelled Document No.");
            leave.SetFilter("Approval Status", '<>%1', leave."Approval Status"::Rejected);
            if leave.FindFirst then
                Error(LeaveCancelError, leave."No.", leave."Leave Code");
        end;
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
            // if CancelDocument."Recommender Code" <> '' then
            //     CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::"Pending Approval")
            // else
            //     CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Recommended);

            AttendanceMissed1.Validate("Approval Status", AttendanceMissed1."Approval Status"::Pending);
            AttendanceMissed1.Insert(true);
        end else begin
            // CancelDocument1.Get(CancelDocument."No.");
            // if CancelDocument1."Recommender Code" <> '' then
            //     CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::"Pending Approval")
            // else
            //     CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Recommended);
            // CancelDocument1.Modify(true);
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

    procedure ApplyCancelEmployeeActivity(CancelDocument: Record "Cancel Document" temporary)
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
            if (CancelDocument."Start Date" >= Today) or (CancelDocument."End Date" >= Today) then
                Error('Cannot apply for future date.Please check the date.');
            if CancelDocument."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date" then
                Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
            CancelDocument.TestField("End Date");
            CancelDocument.TestField(Remarks);
            CancelDocument1.Init;
            CancelDocument1.TransferFields(CancelDocument);
            // if CancelDocument."Recommender Code" <> '' then
            //     CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::"Pending Approval")
            // else
            //     CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::Recommended);

            CancelDocument1."Cancelled No." := '';
            CancelDocument1.Insert(true);
            // end else begin
            //     CancelDocument1.Get(CancelDocument."No.");
            //     if CancelDocument1."Recommender Code" <> '' then
            //         CancelDocument1.Validate("Approval Status", CancelDocument1."Approval Status"::"Pending Approval")
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
                    if LeaveMgt.GetNonWokingDays(EmpAttendActivity."Attendance Date", EmpAttendActivity."Attendance Date", EmpAttendActivity."Employee No.") <> 0 then begin
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
        EmployeeAttendance.SetRange("Present Day", 1);
        EmployeeAttendance.SetRange("Leave Day", 1);
        EmployeeAttendance.FilterGroup(0);
        if EmployeeAttendance.FindFirst then
            Error('You were present or on a leave on date %1.', EmployeeAttendance."Attendance Date");
    end;

    // procedure ApproveRejectCancelAttendanceMissed(CancelDocument: Record "Cancel Document"; IsApproved: Boolean)
    // var
    //     LeaveEarn: Record "Leave Earn";
    //     EmpAttendActivity: Record "Employee Attendance & Activity";
    // begin
    //     if CancelDocument."Approval Status" = CancelDocument."Approval Status"::"Pending" then begin
    //         if StrPos(CancelDocument."Recommender Code", HRMgt.GetEmployeeNo) = 0 then
    //             Error('You are not eligible')
    //         else begin
    //             if IsApproved then begin
    //                 CancelDocument."Approval Status" := CancelDocument."Approval Status"::Recommended;
    //                 Message('Document has been recommended');
    //             end else begin
    //                 CancelDocument."Approval Status" := CancelDocument."Approval Status"::Rejected;
    //                 Message('Document has been rejected.');
    //             end;
    //         end;
    //     end else if CancelDocument."Approval Status" = CancelDocument."Approval Status"::Recommended then begin
    //         if StrPos(CancelDocument."Approver Code", HRMgt.GetEmployeeNo) = 0 then
    //             Error('You are not eligible')
    //         else begin
    //             if IsApproved then begin
    //                 CancelDocument."Approval Status" := CancelDocument."Approval Status"::Approved;

    //                 if CancelDocument.Type = CancelDocument.Type::"Attendance Missed" then begin
    //                     EmpAttendActivity.Reset;
    //                     EmpAttendActivity.SetRange("Employee No.", CancelDocument."Employee No.");
    //                     EmpAttendActivity.SetRange("Attendance Date", CancelDocument."Start Date", CancelDocument."End Date");
    //                     if EmpAttendActivity.Find('-') then
    //                         repeat
    //                             EmpAttendActivity."Absent Day" := 0;
    //                             EmpAttendActivity."Present Day" := 1;
    //                             EmpAttendActivity."Leave Day" := 0;
    //                             if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then
    //                                 EmpAttendActivity."Week Off Day" := 1
    //                             else
    //                                 EmpAttendActivity."Week Off Day" := 0;
    //                             EmpAttendActivity."Tour Day" := 0;
    //                             EmpAttendActivity."Source No." := CancelDocument."No.";
    //                             EmpAttendActivity."Employee Activity Found" := true;
    //                             EmpAttendActivity."Created Datetime" := CurrentDateTime;
    //                             EmpAttendActivity.Modify;
    //                         until EmpAttendActivity.Next = 0;
    //                     AttendanceSetup.Get;
    //                     Employee.Get(CancelDocument."Employee No.");
    //                     Employee.Validate("Attendance Missed On", HRMgt.CheckLeaveCount(Employee."No."));
    //                     if AttendanceSetup."Activate Punch in Date" <> 0D then begin
    //                         if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
    //                             Employee.Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
    //                         else
    //                             Employee.Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
    //                     end else
    //                         Employee.Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
    //                     Employee.Modify;
    //                 end;
    //                 Message('Document has been approved.');
    //             end else begin
    //                 CancelDocument."Approval Status" := CancelDocument."Approval Status"::Rejected;
    //                 Message('Document has been rejected.');
    //             end;
    //         end;
    //     end;
    //     CancelDocument.Modify;
    // end;

    // >> On Approve Attendance Missed >> Santosh >> 2025-03-04
    procedure AttendanceMissedApproved(AttendanceMissCode: Code[20])
    var
        EmpAttendActivity: Record "Employee Attendance & Activity";
        AttendanceMissed: Record "Attendance Missed";
    begin
        AttendanceMissed.Get(AttendanceMissCode);
        if AttendanceMissed.Type = AttendanceMissed.Type::"Attendance Missed" then begin
            EmpAttendActivity.Reset;
            EmpAttendActivity.SetRange("Employee No.", AttendanceMissed."Employee No.");
            EmpAttendActivity.SetRange("Attendance Date", AttendanceMissed."Start Date", AttendanceMissed."End Date");
            if EmpAttendActivity.Find('-') then
                repeat
                    EmpAttendActivity."Absent Day" := 0;
                    EmpAttendActivity."Present Day" := 1;
                    EmpAttendActivity."Leave Day" := 0;
                    if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then
                        EmpAttendActivity."Week Off Day" := 1
                    else
                        EmpAttendActivity."Week Off Day" := 0;
                    EmpAttendActivity."Tour Day" := 0;
                    EmpAttendActivity."Source No." := AttendanceMissed."No.";
                    EmpAttendActivity."Employee Activity Found" := true;
                    EmpAttendActivity."Created Datetime" := CurrentDateTime;
                    EmpAttendActivity.Modify;
                until EmpAttendActivity.Next = 0;
            AttendanceSetup.Get;
            Employee.Get(AttendanceMissed."Employee No.");
            Employee.Validate("Attendance Missed On", HRMgt.CheckLeaveCount(Employee."No."));
            if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                    Employee.Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                else
                    Employee.Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
            end else
                Employee.Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
            Employee.Modify;
        end;
        AttendanceMissed.Modify;
    end;
}
