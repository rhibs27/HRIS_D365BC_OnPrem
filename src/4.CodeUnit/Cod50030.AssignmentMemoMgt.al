codeunit 50030 "Assignment Memo Mgt"
{

    procedure OpenAllowanceRequestMemo(EmpCode: Code[20])
    var
        AssignmentMemoHdr, AssignmentMemoHdr2 : Record "Assignment Memo Header";
        Approval: Record "Approval HRMS";
        Employee: Record Employee;
    begin

        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Allowance Assignment Memo");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();

        Employee.Get(EmpCode);
        AssignmentMemoHdr.SetRange("Requester Employee No.", EmpCode);
        AssignmentMemoHdr.SetRange("Activity Type", AssignmentMemoHdr."Activity Type"::"Allowance Assignment Memo");
        AssignmentMemoHdr.SetRange("Approval Status", AssignmentMemoHdr."Approval Status"::open);
        if AssignmentMemoHdr.Findfirst() then begin
            Message('This Employee Already has open Allowance Request.Click Ok to Open');
            PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr)
        end else begin
            AssignmentMemoHdr2.Init;
            AssignmentMemoHdr2.Validate("Requester Employee No.", EmpCode);
            AssignmentMemoHdr2.Validate("Activity Type", AssignmentMemoHdr2."Activity Type"::"Allowance Assignment Memo");
            AssignmentMemoHdr2.Validate("Approval Status", AssignmentMemoHdr2."Approval Status"::Open);
            AssignmentMemoHdr2.Validate("Province Code", Employee."Province Code");
            AssignmentMemoHdr2.Validate("Branch Code", Employee."Branch Code");
            AssignmentMemoHdr2.Validate("Department Code", Employee."Department Code");
            AssignmentMemoHdr2.Validate("Unit Code", Employee."Unit Code");
            AssignmentMemoHdr2.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr2);
        end;
    end;

    procedure ApproveRejectAssignmentmemo(docNo: Code[20]; IsApproved: Boolean; RejectionRemarks: Text[250])
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if not AssignmentMemoHdr.Get(docNo) then
            Error('Assignment Memo %1 not found.', docNo);

        if not IsApproved then begin
            ;
            AssignmentMemoHdr."Approval Status" := AssignmentMemoHdr."Approval Status"::Rejected;
            AssignmentMemoHdr."Rejection Remarks" := RejectionRemarks;
            AssignmentMemoHdr.Modify();

            //reject line as well
            AssignmentMemoLine.SetRange("Document No.", docNo);
            if AssignmentMemoLine.FindSet() then
                repeat
                    AssignmentMemoLine."Approval Status" := AssignmentMemoLine."Approval Status"::Rejected;
                    AssignmentMemoLine.Modify();
                until AssignmentMemoLine.Next() = 0;
        end;

        //approved
        if IsApproved then begin
            AssignmentMemoHdr."Approval Status" := AssignmentMemoHdr."Approval Status"::Approved;
            AssignmentMemoHdr.Modify();

            //approve line as well
            AssignmentMemoLine.SetRange("Document No.", docNo);
            if AssignmentMemoLine.FindSet() then
                repeat
                    AssignmentMemoLine."Approval Status" := AssignmentMemoLine."Approval Status"::Approved;
                    AssignmentMemoLine.Modify();
                until AssignmentMemoLine.Next() = 0;

            //create assignment memo ledger entry
            CreateAssignmentMemoLedgerEntry(docNo);
        end;
    end;

    procedure CreateAssignmentMemoLedgerEntry(DocumentNo: Code[20])
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        DateVar: Record Date;
    begin
        AssignmentMemoLine.SetRange("Document No.", DocumentNo);
        if AssignmentMemoLine.FindSet() then
            repeat
                DateVar.Reset();
                DateVar.SetRange("Period Type", DateVar."Period Type"::Date);
                DateVar.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date");
                if DateVar.FindSet() then
                    repeat
                        //insert ledger entry for each date in range
                        Clear(AssignmentMemoLedgerEntry);
                        AssignmentMemoLedgerEntry.Init();
                        AssignmentMemoLedgerEntry."Enrty No." := AssignmentMemoLedgerEntry.GetNextEntryNo();
                        AssignmentMemoLedgerEntry.Validate("Document No.", AssignmentMemoHdr."No.");
                        AssignmentMemoLedgerEntry.Validate("Employee Activity Type", AssignmentMemoHdr."Activity Type");
                        AssignmentMemoLedgerEntry.Validate("Employee No.", AssignmentMemoLine."Employee Code");
                        AssignmentMemoLedgerEntry.Validate("Payroll Attribute Code", AssignmentMemoLine."Allowance Type");
                        AssignmentMemoLedgerEntry.Validate("Posting Date", AssignmentMemoLine."From Date");
                        AssignmentMemoLedgerEntry.Validate("Open", true);
                        AssignmentMemoLedgerEntry.Insert();
                    until DateVar.Next() = 0;

            until AssignmentMemoLine.Next() = 0;
    end;

    procedure SendApprovalAssignmentMemo(var AllowanceAssignment: Record "Assignment Memo Header")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        ApproverMgt: Codeunit "Approver Mgt";
    begin
        ApproverMgt.UpdateFirstApproverStatus(AllowanceAssignment."No.");

        AllowanceAssignment.Validate("Approval Status", AllowanceAssignment."Approval Status"::"Pending");
        AllowanceAssignment.Modify(true);

        AssignmentMemoLine.SetRange("Document No.", AllowanceAssignment."No.");
        if AssignmentMemoLine.FindSet() then
            repeat
                AssignmentMemoLine.TestField("Employee Code");
                AssignmentMemoLine.TestField("From Date");
                AssignmentMemoLine.TestField("Allowance Type");
                AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::"Pending");
                AssignmentMemoLine.Modify();
            until AssignmentMemoLine.Next() = 0;
    end;

    procedure InsertSubstituteAssignmentMemo(docNo: code[20]; SourceEmpNo: Code[20]; AllowanceType: Code[20]; panel: Enum Panel; EmpCode: Code[20]; FromDate: Date; ToDate: Date)
    var
        SubAssigmemoLine: Record "Assignment Memo Line";
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        // Implementation for inserting substitute assignment memo
        AssignmentMemoHdr.Get(docNo);

        SubAssigmemoLine.Init();
        SubAssigmemoLine."Document No." := docNo;
        SubAssigmemoLine."Emp Act Type" := AssignmentMemoHdr."Activity Type";
        SubAssigmemoLine.Validate("Employee Code", EmpCode);
        SubAssigmemoLine.Validate("From Date", FromDate);
        SubAssigmemoLine.Validate("To Date", ToDate);
        SubAssigmemoLine.Validate("Allowance Type", AllowanceType);
        SubAssigmemoLine.Validate("Substitute Type", SubAssigmemoLine."Substitute Type"::"Added as Substitute");
        SubAssigmemoLine.Insert(true);

        //reverse the ledger entry

    end;
}
