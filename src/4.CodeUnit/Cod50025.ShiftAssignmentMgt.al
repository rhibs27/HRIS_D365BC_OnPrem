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
        Approval.setRange("Document Type", Approval."Document Type"::"Allowance Assignment");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        Employee.Get(EmpCode);
        ShiftAssignment.Reset();
        ShiftAssignment.SetRange("Employee No.", EmpCode);
        ShiftAssignment.SetRange("Type", ShiftAssignment."Type"::"Allowance Assignment");
        ShiftAssignment.SetRange("Approval Status", ShiftAssignment."Approval Status"::open);
        if ShiftAssignment.Findfirst() then begin
            Message('This Employee Already has open Shift Assignment Request.Click Ok to Open');
            PAGE.Run(PAGE::"Shift Assignment Card", ShiftAssignment)
        end else begin
            ShiftAssignment2.Init;
            ShiftAssignment2.Validate("Employee No.", EmpCode);
            ShiftAssignment2.Validate("Type", ShiftAssignment2."Type"::"Allowance Assignment");
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
            ShiftAssignLine.Validate("Deputation Code", ShiftAssignHeader."Deputation Code");
            ShiftAssignLine.Validate("Deputation Name", ShiftAssignHeader."Deputation Name");
            ShiftAssignLine.Validate("Deputation Type", ShiftAssignHeader."Deputation Type");
            ShiftAssignLine.Validate("Employee No", EmployeeNo);
            ShiftAssignLine.Validate("Employee Work Shift", EmployeeWorkShift);
            ShiftAssignLine.Validate("Roster Date", FromDate);
            ShiftAssignLine.Validate("Approval Status", ShiftAssignLine."Approval Status"::Open);
            GetLineNo(ShiftAssignLine);
            ShiftAssignLine.Insert();
            AssignDate := FromDate + 1;
        end;
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
    begin
        ShiftAssignmentHeader.Get(DocumentNo);
        ShiftLine.Reset;
        ShiftLine.SetRange("No.", DocumentNo);
        ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::"Pending");
        if ShiftLine.Findset() then
            repeat
                if Approved then begin
                    ShiftLine.Validate("Approval Status", ShiftLine."Approval Status"::Approved);
                    ShiftLine.Validate("Approved Date", Today);
                    ShiftLine.Modify();
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

    var
        Employee: Record Employee;

}
