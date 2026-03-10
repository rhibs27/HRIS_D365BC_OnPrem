codeunit 50025 "Shift Assignment Mgt"
{
    procedure OpenShiftRequest(EmpCode: Code[20])
    var
        ShiftAssignment, ShiftAssignment2 : Record "Shift Assignment Header";
        Approval: Record "Approval HRMS";
    begin
        Clear(Employee);
        // Clear Approval line
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Shift Assignment");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        Employee.Get(EmpCode);
        ShiftAssignment.Reset();
        ShiftAssignment.SetRange("Employee No.", EmpCode);
        ShiftAssignment.SetRange("Type", ShiftAssignment."Type"::"Shift Assignment");
        ShiftAssignment.SetRange("Approval Status", ShiftAssignment."Approval Status"::open);
        if ShiftAssignment.Findfirst() then begin
            Message('This Employee Already has open Shift Assignment Request.Click Ok to Open');
            PAGE.Run(PAGE::"Shift Assignment Card", ShiftAssignment)
        end else begin
            ShiftAssignment2.Init;
            ShiftAssignment2.Validate("Employee No.", EmpCode);
            ShiftAssignment2.Validate("Type", ShiftAssignment2."Type"::"Shift Assignment");
            ShiftAssignment2.Validate("Approval Status", ShiftAssignment2."Approval Status"::Open);
            ShiftAssignment2.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Shift Assignment Card", ShiftAssignment2);
        end;
    end;

    procedure InsertShiftLine(DocumentNo: Code[20]; EmployeeNo: Code[20]; EmployeeWorkShift: Code[20]; FromDate: date; ToDate: date)
    var
        ShiftAssignLine: Record "Shift Line";
        ShiftAssignHeader: Record "Shift Assignment Header";
        AssignDate: Date;
    begin
        ShiftAssignHeader.Get(DocumentNo);
        AssignDate := FromDate;
        for FromDate := FromDate to ToDate do begin
            ShiftAssignLine.Init();
            ShiftAssignLine.Validate("No.", DocumentNo);
            ShiftAssignLine.Validate("Type", ShiftAssignLine."Type"::"Shift Assignment");
            if ShiftAssignHeader."Deputation Sub Type" = ShiftAssignHeader."Deputation Sub Type"::" " then begin
                ShiftAssignLine.Validate("Deputation Type", ShiftAssignHeader."Deputation Type");
                ShiftAssignLine.Validate("Deputation Code", ShiftAssignHeader."Deputation Code");
            end else begin
                ShiftAssignLine.Validate("Deputation Type", ShiftAssignHeader."Deputation Sub Type");
                ShiftAssignLine.Validate("Deputation Code", ShiftAssignHeader."Deputation Sub Type Code");
            end;
            ShiftAssignLine.Validate("Employee No", EmployeeNo);
            ShiftAssignLine.Validate("Employee Work Shift", EmployeeWorkShift);
            ShiftAssignLine.Validate("Roster Date", FromDate);
            ShiftAssignLine.Validate("Approval Status", ShiftAssignLine."Approval Status"::Open);
            GetLineNo(ShiftAssignLine);
            ShiftAssignLine.Insert();
            AssignDate := FromDate + 1;
        end;
    end;

    procedure SubstituteShiftLine(Var ShiftAssignmentLine: Record "Shift Line"; EmployeeNo: Code[20]; Remarks: Text)
    var
        ShiftAssignLine: Record "Shift Line";
    begin
        ShiftAssignLine.Init();
        ShiftAssignLine.Validate("No.", ShiftAssignmentLine."No.");
        ShiftAssignLine.Validate("Type", ShiftAssignLine."Type"::"Shift Assignment");
        ShiftAssignLine.Validate("Approval Status", ShiftAssignLine."Approval Status"::"Pending");
        ShiftAssignLine.Validate("Deputation Type", ShiftAssignmentLine."Deputation Type");
        ShiftAssignLine.Validate("Deputation Code", ShiftAssignmentLine."Deputation Code");
        ShiftAssignLine.Validate("Employee Work Shift", ShiftAssignmentLine."Employee Work Shift");
        ShiftAssignLine.Validate("Employee No", EmployeeNo);
        ShiftAssignLine.Validate("Roster Date", ShiftAssignmentLine."Roster Date");
        ShiftAssignLine.Validate("Substitute Type", ShiftAssignmentLine."Substitute Type"::"Added as Substitute");
        ShiftAssignLine.Validate("Substitute of Line No.", ShiftAssignmentLine."Line No");
        ShiftAssignLine.Validate(Remarks, Remarks);
        GetLineNo(ShiftAssignLine);
        ShiftAssignLine.Insert();
        ShiftAssignmentLine.Validate("Substitute Type", ShiftAssignmentLine."Substitute Type"::Substituted);
        ShiftAssignmentLine.Modify();
        Message('%1 is Successfully Substituted by %2', ShiftAssignmentLine."Employee Name", ShiftAssignLine."Employee Name");
    end;

    procedure GetLineNo(var ShiftAssignLine: Record "shift Line")
    var
        ShiftLine: Record "Shift Line";
    begin
        ShiftLine.Reset;
        ShiftLine.SetCurrentKey("No.", "Line No");
        ShiftLine.SetRange("No.", ShiftAssignLine."No.");
        if ShiftLine.FindLast then
            ShiftAssignLine."Line No" := ShiftLine."Line No" + 10000
        else
            ShiftAssignLine."Line No" := 10000;
    end;

    procedure SendApprovalShiftAssignment(var ShiftAssignment: Record "Shift Assignment Header"; var ShiftLine: Record "Shift Line")
    var
        ShiftLineCheck: Record "Shift Line";
        ApproverMgt: Codeunit "Approver Mgt";
    begin
        ApproverMgt.UpdateFirstApproverStatus(ShiftAssignment."No.");
        ShiftLineCheck.Copy(ShiftLine);
        if ShiftLineCheck.FindFirst then
            repeat
                ShiftLineCheck.TestField("Employee No");
                ShiftLineCheck.TestField("Roster Date");
                ShiftLineCheck.TestField("Employee Work Shift");
            until ShiftLineCheck.Next = 0;
        ShiftAssignment.Validate("Approval Status", ShiftAssignment."Approval Status"::"Pending");
        ShiftAssignment.Modify(true);
        ShiftLine.ModifyAll("Approval Status", ShiftLine."Approval Status"::"Pending");
    end;

    procedure ApproveRejectShiftLine(Approved: Boolean; DocumentNo: Code[20])
    var
        ShiftAssignmentHeader: Record "Shift Assignment Header";
        ShiftLine: Record "Shift Line";
        ApprovalLine: Record "Approval HRMS";
        ApproverMgt: Codeunit "Approver Mgt";
        EmpAttendance: Record "Employee Attendance & Activity";
        AttendanceMgt: Codeunit "Attendance Mgt";
    begin
        ShiftAssignmentHeader.Get(DocumentNo);
        ShiftLine.Reset;
        ShiftLine.SetRange("No.", DocumentNo);
        ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::"Pending");
        if ShiftLine.Findset() then
            repeat
                if Approved then begin
                    EmpAttendance.Reset();
                    EmpAttendance.SetRange("Attendance Date", ShiftLine."Roster Date");
                    EmpAttendance.SetRange("Employee No.", ShiftLine."Employee No");
                    if EmpAttendance.FindSet() then
                        repeat
                            EmpAttendance.Delete();
                        until EmpAttendance.Next() = 0;
                    ShiftLine.Validate("Approval Status", ShiftLine."Approval Status"::Approved);
                    ShiftLine.Validate("Approved Date", Today);
                    ShiftLine.Modify();
                    if ShiftLine."Roster Date" <= Today then
                        AttendanceMgt.DailyAttendanceUpdate(ShiftLine."Roster Date", ShiftLine."Roster Date", ShiftLine."Employee No");
                end;
            until ShiftLine.Next() = 0;
        if not Approved then begin
            ShiftLine.ModifyAll("Approval Status", ShiftLine."Approval Status"::open);
            ApprovalLine.Reset();
            ApprovalLine.SetRange("Document No.", DocumentNo);
            ApprovalLine.DeleteAll(true);
            ApproverMgt.InsertApproval(ShiftAssignmentHeader."Employee No.", DocumentNo, ShiftAssignmentHeader."Type"::"Shift Assignment", ShiftAssignmentHeader."Approval Status"::open);
        end;
    end;

    procedure ValidateEmployeeOnDate(var LineRec: Record "Shift Line")
    var
        ShiftLine: Record "Shift Line";
    begin
        ShiftLine.SetRange(Type, LineRec.Type::"Shift Assignment");
        ShiftLine.SetRange("No.", LineRec."No.");
        ShiftLine.SetRange("Employee No", LineRec."Employee No");
        ShiftLine.SetRange("Roster Date", LineRec."Roster Date");
        ShiftLine.SetFilter("Line No", '<>%1', LineRec."Line No");
        if ShiftLine.FindFirst() then
            Error('Employee %1 is already scheduled on %1 at Line No. %2', LineRec."Employee Name", LineRec."Roster Date", Shiftline."Line No");
    end;

    procedure ReturnEmployeeWorkShift(EmployeeNo: Code[20]; ShiftDate: Date): Code[20];
    var
        ShiftLine: Record "Shift Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        EmployeeWorkShift: Code[20];
    begin
        PGSetup.Get();
        if PGSetup."Use Allowance Configuration" then begin
            AssignmentMemoLedgerEntry.SetLoadFields("Employee Activity Type", Reversed, "Employee No.", "Employee Work Shift", "Posting Date", "Substituted Employee No.");
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Shift Assignment Memo");
            AssignmentMemoLedgerEntry.SetRange(Reversed, false);
            AssignmentMemoLedgerEntry.SetRange("Employee No.", EmployeeNo);
            AssignmentMemoLedgerEntry.SetRange("Posting Date", ShiftDate);
            AssignmentMemoLedgerEntry.SetRange("Substituted Employee No.", '');
            if AssignmentMemoLedgerEntry.FindFirst() then
                exit(AssignmentMemoLedgerEntry."Employee Work Shift");
        end else begin
            ShiftLine.Reset();
            ShiftLine.SetRange("Employee No", EmployeeNo);
            ShiftLine.SetRange("Roster Date", ShiftDate);
            ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
            ShiftLine.Setfilter("Substitute Type", '%1|%2', ShiftLine."Substitute Type"::" ", ShiftLine."Substitute Type"::"Added as Substitute");
            if ShiftLine.FindFirst() then
                exit(ShiftLine."Employee Work Shift")
        end;
        Employee.Get(EmployeeNo);
        exit(Employee."Employee Work Shift");
    end;

    procedure CheckWorkShiftFields(EmployeeWorkShift: Record "Employee Work Shift");
    begin
        EmployeeWorkShift.TestField("Start Time");
        EmployeeWorkShift.TestField("End Time");
        EmployeeWorkShift.TestField("Friday End Time");
        EmployeeWorkShift.TestField("Winter Start Date");
        EmployeeWorkShift.TestField("Winter End Date");
        EmployeeWorkShift.TestField("Winter End Time");
    end;

    procedure ReturnShiftEndTime(ShiftDate: date; var WorkShift: Record "Employee Work Shift"): Time
    begin
        if HRMgt.IsWinter(ShiftDate, WorkShift) then begin
            if HRMgt.IsFriday(ShiftDate) then
                exit(WorkShift."Friday End Time")
            else
                exit(WorkShift."Winter End Time");
        end else begin
            if HRMgt.IsFriday(ShiftDate) then
                exit(WorkShift."Friday End Time")
            else
                exit(WorkShift."End Time");
        end;
    end;

    procedure ProcessDailyAttendanceForShiftSubstitute(RosterDate: Date; EmployeeNo: Code[20])
    begin
        if RosterDate <= Today then begin
            EmpAttendance.Reset();
            EmpAttendance.SetRange("Attendance Date", RosterDate);
            EmpAttendance.SetRange("Employee No.", EmployeeNo);
            if EmpAttendance.FindSet() then
                repeat
                    EmpAttendance.Delete();
                until EmpAttendance.Next() = 0;
            AttendanceMgt.DailyAttendanceUpdate(RosterDate, RosterDate, EmployeeNo);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterGetEmployeeWorkShift(EmployeeNo: Code[20]; ShiftDate: Date; var EmployeeWorkShift: Code[20])
    begin
    end;

    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        PGSetup: Record "Payroll General Setup";
        EmpAttendance: Record "Employee Attendance & Activity";
        AttendanceMgt: Codeunit "Attendance Mgt";

}
