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
        AssignmentMemoHdr.SetRange("Employee No.", EmpCode);
        AssignmentMemoHdr.SetRange("Activity Type", AssignmentMemoHdr."Activity Type"::"Allowance Assignment Memo");
        AssignmentMemoHdr.SetRange("Approval Status", AssignmentMemoHdr."Approval Status"::open);
        if AssignmentMemoHdr.Findfirst() then begin
            Message('This Employee Already has open Allowance Request.Click Ok to Open');
            PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr)
        end else begin
            AssignmentMemoHdr2.Init;
            AssignmentMemoHdr2.Validate("Employee No.", EmpCode);
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

    procedure ApproveRejectAssignmentmemo(docNo: Code[20]; IsApproved: Boolean)
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if not AssignmentMemoHdr.Get(docNo) then
            Error('Assignment Memo %1 not found.', docNo);

        if not IsApproved then begin
            if AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending then  //substitute approval pending
                AssignmentMemoHdr."Substitute Approval Status" := AssignmentMemoHdr."Substitute Approval Status"::Rejected
            else if AssignmentMemoHdr."Approval Status" <> AssignmentMemoHdr."Approval Status"::Approved then
                AssignmentMemoHdr."Approval Status" := AssignmentMemoHdr."Approval Status"::Rejected;
            AssignmentMemoHdr.Modify();

            //reject the pending line as well
            AssignmentMemoLine.SetRange("Document No.", docNo);
            AssignmentMemoLine.SetRange("Approval Status", AssignmentMemoLine."Approval Status"::"Pending");
            if AssignmentMemoLine.FindSet() then
                repeat
                    AssignmentMemoLine."Approval Status" := AssignmentMemoLine."Approval Status"::Rejected;
                    AssignmentMemoLine.Modify();
                until AssignmentMemoLine.Next() = 0;
        end;

        //approved
        if IsApproved then begin
            AssignmentMemoHdr."Approval Status" := AssignmentMemoHdr."Approval Status"::Approved;
            if AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending then
                AssignmentMemoHdr."Substitute Approval Status" := AssignmentMemoHdr."Substitute Approval Status"::Approved;
            AssignmentMemoHdr.Modify();

            //approve line as well
            AssignmentMemoLine.SetRange("Document No.", docNo);
            AssignmentMemoLine.SetRange("Approval Status", AssignmentMemoLine."Approval Status"::"Pending");
            if AssignmentMemoLine.FindSet() then
                repeat
                    AssignmentMemoLine."Approval Status" := AssignmentMemoLine."Approval Status"::Approved;
                    AssignmentMemoLine.Modify();

                    //create assignment memo ledger entry
                    CreateAssignmentMemoLedgerEntry(AssignmentMemoLine."Document No.", AssignmentMemoLine."Line No.");

                until AssignmentMemoLine.Next() = 0;
        end;
    end;

    procedure CreateAssignmentMemoLedgerEntry(DocumentNo: Code[20]; lineNo: Integer)
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        DateVar: Record Date;
    begin
        AssignmentMemoHdr.Get(DocumentNo);
        if AssignmentMemoLine.Get(DocumentNo, lineNo) then begin

            DateVar.Reset();
            DateVar.SetRange("Period Type", DateVar."Period Type"::Date);
            DateVar.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date");
            if DateVar.FindSet() then
                repeat

                    //insert ledger entry for each date in range
                    Clear(AssignmentMemoLedgerEntry);
                    AssignmentMemoLedgerEntry.Init();
                    AssignmentMemoLedgerEntry."Entry No." := AssignmentMemoLedgerEntry.GetNextEntryNo();
                    AssignmentMemoLedgerEntry.Validate("Document No.", AssignmentMemoHdr."No.");
                    AssignmentMemoLedgerEntry.Validate("Employee Activity Type", AssignmentMemoHdr."Activity Type");
                    AssignmentMemoLedgerEntry.Validate("Employee No.", AssignmentMemoLine."Employee No.");
                    AssignmentMemoLedgerEntry.Validate("Payroll Attribute Code", AssignmentMemoLine."Payroll Attribute Code");
                    AssignmentMemoLedgerEntry.Validate("Posting Date", DateVar."Period Start");
                    AssignmentMemoLedgerEntry.Validate("Open", true);
                    AssignmentMemoLedgerEntry.Validate(Amount, AssignmentMemoLine."Allowance Amount");
                    AssignmentMemoLedgerEntry.Insert();

                until DateVar.Next() = 0;

            //check and update the source substitute ledger entry to closed
            if AssignmentMemoLine."Substitute Type" = AssignmentMemoLine."Substitute Type"::"Added as Substitute" then
                UpdateSubstituteAssignmentMemoLedgerEntry(AssignmentMemoLine);
        end;
    end;

    procedure SendApprovalAssignmentMemo(var AssignmentmemoHdr: Record "Assignment Memo Header")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalHrms: Record "Approval HRMS";
    begin
        ApproverMgt.UpdateFirstApproverStatus(AssignmentmemoHdr."No.");

        if AssignmentmemoHdr."Approval Status" in [AssignmentmemoHdr."Approval Status"::Open, AssignmentmemoHdr."Approval Status"::Created] then
            AssignmentmemoHdr.Validate("Approval Status", AssignmentmemoHdr."Approval Status"::"Pending");
        if AssignmentmemoHdr."Substitute Approval Status" = AssignmentmemoHdr."Substitute Approval Status"::Open then
            AssignmentmemoHdr.Validate("Substitute Approval Status", AssignmentmemoHdr."Substitute Approval Status"::"Pending");
        AssignmentmemoHdr.Modify(true);

        AssignmentMemoLine.SetRange("Document No.", AssignmentmemoHdr."No.");
        AssignmentMemoLine.SetRange("Approval Status", AssignmentMemoLine."Approval Status"::Open);
        if AssignmentMemoLine.FindSet() then
            repeat
                AssignmentMemoLine.TestField("Employee No.");
                AssignmentMemoLine.TestField("From Date");
                AssignmentMemoLine.TestField("Payroll Attribute Code");
                AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::"Pending");
                AssignmentMemoLine.Modify();
            until AssignmentMemoLine.Next() = 0;

        //In case of substitute, open the approval for substitute
        if AssignmentmemoHdr."Substitute Approval Status" = AssignmentmemoHdr."Substitute Approval Status"::Pending then begin
            ApprovalHrms.SetFilter("Approval Sequence", '>%1', 1);
            ApprovalHrms.SetRange("Document No.", AssignmentmemoHdr."No.");
            ApprovalHrms.SetFilter("Approval Sequence", '>%1', 1);
            if ApprovalHrms.FindSet() then
                ApprovalHrms.ModifyAll("Approval Status", ApprovalHrms."Approval Status"::Created);
        end;

    end;

    procedure InsertSubstituteAssignmentMemo(docNo: Code[20]; lineNo: Integer; fromDate: Date; toDate: Date; empCode: Code[20])
    var
        SubAssigmemoLine: Record "Assignment Memo Line";
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        ApprovalHrms: Record "Approval HRMS";
    begin
        // Implementation for inserting substitute assignment memo
        AssignmentMemoHdr.Get(docNo);
        AssignmentMemoLine.Get(docNo, lineNo);

        CheckConflictingSubstituteAssignment(docNo, lineNo, fromDate, toDate);

        SubAssigmemoLine.Init();
        SubAssigmemoLine.TransferFields(AssignmentMemoLine);
        SubAssigmemoLine."Line No." := 0;
        SubAssigmemoLine.Validate("Employee No.", EmpCode);
        SubAssigmemoLine.Validate("From Date", FromDate);
        SubAssigmemoLine.Validate("To Date", ToDate);
        SubAssigmemoLine.Validate("Substitute Type", SubAssigmemoLine."Substitute Type"::"Added as Substitute");
        SubAssigmemoLine."Substitute of Line No." := AssignmentMemoLine."Line No.";
        SubAssigmemoLine."Approval Status" := SubAssigmemoLine."Approval Status"::Open;
        SubAssigmemoLine.Insert(true);

        AssignmentMemoHdr."Substitute Approval Status" := AssignmentMemoHdr."Substitute Approval Status"::Open;
        AssignmentMemoHdr.Modify();

    end;

    procedure UpdateSubstituteAssignmentMemoLedgerEntry(var SubAssigmemoLine: Record "Assignment Memo Line")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        AssignmentMemoLine.Get(SubAssigmemoLine."Document No.", SubAssigmemoLine."Substitute of Line No.");
        AssignmentMemoLedgerEntry.SetRange("Document No.", AssignmentMemoLine."Document No.");
        AssignmentMemoLedgerEntry.SetRange("Employee No.", AssignmentMemoLine."Employee No.");
        AssignmentMemoLedgerEntry.SetRange("Posting Date", SubAssigmemoLine."From Date", SubAssigmemoLine."To Date");
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                AssignmentMemoLedgerEntry.Validate("Open", false);
                AssignmentMemoLedgerEntry.Validate("Substituted Employee No.", SubAssigmemoLine."Employee No.");
                AssignmentMemoLedgerEntry.Modify();
            until AssignmentMemoLedgerEntry.Next() = 0;
    end;

    procedure CheckConflictingSubstituteAssignment(docNo: Code[20]; LineNo: Integer; fromDate: Date; toDate: Date): Boolean
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        Daterec: Record Date;
        DateList: List of [Date];
    begin
        AssignmentMemoLine.SetRange("Document No.", docNo);
        AssignmentMemoLine.SetRange("Substitute Type", AssignmentMemoLine."Substitute Type"::"Added as Substitute");
        AssignmentMemoLine.SetRange("Substitute of Line No.", LineNo);
        if AssignmentMemoLine.Count() <= 1 then
            exit;

        if AssignmentMemoLine.FindSet() then
            repeat
                Daterec.Reset();
                Daterec.SetRange("Period Type", Daterec."Period Type"::Date);
                Daterec.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date");
                if Daterec.FindSet() then
                    repeat
                        //check if date exist in date list. If exist then return true else add the new date in list
                        if not DateList.Contains(Daterec."Period Start") then
                            DateList.Add(Daterec."Period Start")
                        else
                            Error('Conflicting Substitute Assignment Memo exists for the selected date range %1 to %2.', fromDate, toDate);
                    until Daterec.Next() = 0;

            until AssignmentMemoLine.Next() = 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approver Mgt", OnApproverejectDocumentOnBeforeCheckApprover, '', false, false)]
    local procedure OnApproverejectDocumentOnBeforeCheckApprover(var RecRef: RecordRef; var EmployeeActivityType: Enum "Employee Activity Type"; var DocumentNo: Code[20]; var ApprovalStatusField: Text)
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        case RecRef.Number of
            Database::"Assignment Memo Header":
                begin
                    if ApprovalStatusField = 'Approved' then begin
                        AssignmentMemoHdr.Get(DocumentNo);
                        if (AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending) then begin
                            ApprovalStatusField := 'Pending';
                        end;
                    end;
                end;
        end;
    end;

    //request allowance section
    procedure OpenAllowance(EmpCode: Code[20]; AllowanceType: code[20])
    var
        AssignmentmemoHdr, AssignmentMemoHdr2 : Record "Assignment Memo Header";
        Approval: Record "Approval HRMS";
        PGSetup: Record "Payroll General Setup";
        Employee: Record Employee;
    begin
        PGSetup.Get();

        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Request Allowance");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();

        Employee.Get(EmpCode);
        AssignmentmemoHdr.Reset();
        AssignmentmemoHdr.SetRange("Employee No.", EmpCode);
        AssignmentmemoHdr.SetRange("Activity Type", AssignmentmemoHdr."Activity Type"::"Request Allowance");
        AssignmentmemoHdr.SetRange("Approval Status", AssignmentmemoHdr."Approval Status"::open);
        AssignmentmemoHdr.SetRange("Payroll Attribute Code", AllowanceType);
        if AssignmentmemoHdr.Findfirst() then begin
            If GuiAllowed then begin
                Message('This Employee Already has open Allowance Request .Click Ok to Open');
                PAGE.Run(PAGE::"Request Allowance Card", AssignmentmemoHdr)
            end;
        end
        else
            CreateNewAllowanceRequest(EmpCode, AllowanceType);
    end;

    procedure CreateNewAllowanceRequest(EmpCode: Code[20]; AllowanceType: Code[20])
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        FilterPageBuilder: FilterPageBuilder;
        Allowanceconfig: Record "Allowance Configuration";
        PGSetup: Record "Payroll General Setup";
    begin
        PGSetup.Get();

        AssignmentMemoHdr.Init;
        AssignmentMemoHdr.Validate("Employee No.", EmpCode);
        AssignmentMemoHdr.Validate("Activity Type", AssignmentMemoHdr."Activity Type"::"Request Allowance");
        AssignmentMemoHdr."Payroll Attribute Code" := AllowanceType;
        AssignmentMemoHdr.Validate("From Date", WorkDate());
        AssignmentMemoHdr.Validate("To date", PGSetup."Payroll Fiscal Year end Date");
        AssignmentMemoHdr.Validate("Approval Status", AssignmentMemoHdr."Approval Status"::Open);
        AssignmentMemoHdr.Insert(true);

        CreateAllowanceAssignmentLineFromRequest(AssignmentMemoHdr."No.");
        if GuiAllowed then
            PAGE.Run(PAGE::"request allowance Card", AssignmentMemoHdr);
    end;

    procedure CreateAllowanceAssignmentLineFromRequest(AllowanceAssignmentCode: Code[20])
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        AllowanceConfig: Record "Allowance Configuration";
    begin
        AssignmentMemoHdr.Get(AllowanceAssignmentCode);
        if AssignmentMemoHdr."Payroll Attribute Code" = '' then
            exit;

        AllowanceConfig.SetRange("Payroll Attribute", AssignmentMemoHdr."Payroll Attribute Code");
        AllowanceConfig.FindFirst();

        case AllowanceConfig.Source of
            AllowanceConfig.Source::" ",
            AllowanceConfig.Source::Direct,
            AllowanceConfig.Source::Leave:
                CreateAllowanceRequestLine(AssignmentMemoHdr);
            AllowanceConfig.Source::Assignment:
                CreateAllowanceRequestLineFromAssignmentLine(AssignmentMemoHdr);
            AllowanceConfig.Source::Shift:
                CreateAllowanceRequestLineFromShiftLine(AssignmentMemoHdr);
        end;
    end;

    procedure CreateAllowanceRequestLine(AllowanceAssignmentHdr: Record "Assignment Memo Header")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
    begin
        AssignmentMemoLine.Init();
        AssignmentMemoLine.Validate("Document No.", AllowanceAssignmentHdr."No.");
        AssignmentMemoLine.Validate("Emp Act Type", AllowanceAssignmentHdr."Activity Type");
        AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
        AssignmentMemoLine.Validate("Payroll Attribute Code", AllowanceAssignmentHdr."Payroll Attribute Code");
        AssignmentMemoLine.Insert(true);
        AssignmentMemoLine.Validate("Payroll Attribute Code");
        AssignmentMemoLine.Modify();
    end;

    procedure CreateAllowanceRequestLineFromAssignmentLine(AllowanceAssignmentHdr: Record "Assignment Memo Header")
    var
        AssignmentMemoLine2: Record "Assignment Memo Line";
        AssignmentMemoLine: Record "Assignment Memo Line";
    begin
        AssignmentMemoLine2.SetRange("Employee No.", AllowanceAssignmentHdr."Employee No.");
        AssignmentMemoLine2.SetRange("Emp Act Type", AssignmentMemoLine2."Emp Act Type"::"Allowance Assignment");
        AssignmentMemoLine2.SetRange("Allowance Claimed", false);
        AssignmentMemoLine2.SetRange("Approval Status", AssignmentMemoLine2."Approval Status"::Approved);
        AssignmentMemoLine2.SetRange("Payroll Doc No.", '');
        AssignmentMemoLine2.SetRange("Allowance Claim From", '');
        if AllowanceAssignmentHdr."Payroll Attribute Code" <> '' then
            AssignmentMemoLine2.SetRange("Payroll Attribute Code", AllowanceAssignmentHdr."Payroll Attribute Code");
        if AssignmentMemoLine2.FindSet() then
            repeat
                Clear(AssignmentMemoLine);
                AssignmentMemoLine.Init();
                AssignmentMemoLine := AssignmentMemoLine2;
                AssignmentMemoLine."Document No." := AllowanceAssignmentHdr."No.";
                AssignmentMemoLine."Line No." := 0;
                AssignmentMemoLine."Emp Act Type" := AllowanceAssignmentHdr."Activity Type";
                AssignmentMemoLine."Approval Status" := AssignmentMemoLine."Approval Status"::Open;
                AssignmentMemoLine.Insert(true);
                AssignmentMemoLine.Validate("Payroll Attribute Code");
                AssignmentMemoLine.Modify();

                // mark allowance 
                AssignmentMemoLine2."Allowance Claim From" := AllowanceAssignmentHdr."No.";
                AssignmentMemoLine2.Modify();

            until AssignmentMemoLine2.Next() = 0;
    end;

    procedure CreateAllowanceRequestLineFromShiftLine(AllowanceAssignmentHdr: Record "Assignment Memo Header")
    var
        ShiftLine: Record "Shift Line";
        AssignmentMemoLine: Record "Assignment Memo Line";
    begin
        ShiftLine.SetRange("Employee No", AllowanceAssignmentHdr."Employee No.");
        ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
        // ShiftLine.SetRange("Shift Claimed From", '');
        if ShiftLine.FindSet() then
            repeat
                Clear(AssignmentMemoLine);
                AssignmentMemoLine.Init();
                AssignmentMemoLine.Validate("Employee No.", ShiftLine."Employee No");
                AssignmentMemoLine."Emp Act Type" := AllowanceAssignmentHdr."Activity Type";
                AssignmentMemoLine."Approval Status" := AssignmentMemoLine."Approval Status"::Open;
                AssignmentMemoLine.Insert(true);
                AssignmentMemoLine.Validate("Payroll Attribute Code");
                AssignmentMemoLine.Modify();

                // mark allowance
                // ShiftLine."Shift Claimed From" := AllowanceAssignmentHdr."No.";
                ShiftLine.Modify();

            until ShiftLine.Next() = 0;
    end;

    procedure GenerateIncDocuments(EmpActType: Enum "Employee Activity Type"; No: Code[20]; EmployeeNo: Code[20]; AttachmentCode: Code[20])
    var
        IncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        AttachmentSetup.setfilter(Type, Format(EmpActType));
        if not AttachmentSetup.FindFirst then
            exit;

        IncomingDoc.Init;
        IncomingDoc.Validate(Type, IncomingDoc.Type::" ");
        IncomingDoc.Validate("No.", No);
        IncomingDoc.Validate("Employee Activity Type", EmpActType);
        IncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
        IncomingDoc.Validate(Description, Format(EmpActType) + ': ' + Format(AttachmentSetup."Attachment Code") + '-' + Format(No));
        IncomingDoc.Validate("Employee Code", EmployeeNo);
        if IncomingDoc.Insert(true) then;
    end;

    procedure AllowancerequestOnbeforeSendForApproval(DocNo: Code[20])
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        PayrollAttribute: Record "Payroll Attributes";
        AllowanceConfig: Record "Allowance Configuration";
    begin
        AssignmentMemoHdr.Get(DocNo);

        if AssignmentMemoHdr."Activity Type" <> AssignmentMemoHdr."Activity Type"::"Request Allowance" then
            exit;

        AssignmentMemoLine.SetRange("Document No.", DocNo);
        if AssignmentMemoLine.FindSet() then
            repeat
                AssignmentMemoLine.TestField("Approval Status", AssignmentMemoLine."Approval Status"::Open);
                PayrollAttribute.Get(AssignmentMemoLine."Payroll Attribute Code");
                case PayrollAttribute."Specific Attributes" of
                    PayrollAttribute."Specific Attributes"::"OutStation Allowance":
                        AssignmentMemoLine.TestField("Distance (KM)");
                    PayrollAttribute."Specific Attributes"::"Education Allowance":
                        begin
                            AssignmentMemoLine.TestField("Name of Children");
                            AssignmentMemoLine.TestField("School Name");
                            AssignmentMemoLine.TestField("Grade/Class");
                        end;
                end;
                AllowanceConfig.SetRange("Payroll Attribute", AssignmentMemoLine."Payroll Attribute Code");
                if AllowanceConfig.FindFirst then begin
                    if AllowanceConfig.Source in [AllowanceConfig.Source::Shift, AllowanceConfig.Source::Assignment] then
                        if not CheckIfAttendanceExistForAllowance(AssignmentMemoLine."Employee No.", AssignmentMemoLine."From Date", AssignmentMemoLine."From Date") then
                            Error('Attendance not found for %1 on %2', AssignmentMemoLine."Employee No.", AssignmentMemoLine."From Date");

                    if AllowanceConfig.Source = AllowanceConfig.Source::Leave then
                        if not CheckIfLeaveExistForAllowance(AssignmentMemoLine."Employee No.", AssignmentMemoLine."Document No.", AssignmentMemoLine."Payroll Attribute Code") then
                            Error('Unclaimed Leave not found for %1', AssignmentMemoLine."Employee No.");
                end;

            until AssignmentMemoLine.Next() = 0;
    end;

    procedure CheckIfLeaveExistForAllowance(EmpCode: Code[20]; DocNo: Code[20]; AllowanceType: Code[20]): Boolean
    var
        LeaveRec: Record Leave;
        LeaveTypeSetUp: Record "Leave Type Setup";
    begin
        LeaveTypeSetUp.SetRange("Payroll Attribute", AllowanceType);
        if not LeaveTypeSetUp.FindFirst() then
            exit(false);

        LeaveRec.SetRange("Employee No.", EmpCode);
        LeaveRec.SetRange("Leave code", LeaveTypeSetUp.Code);
        LeaveRec.SetRange("Approval Status", LeaveRec."Approval Status"::Approved);
        LeaveRec.SetRange(Claimed, false);
        if LeaveRec.FindLast() then begin
            LeaveRec."Claimed Doc No." := '';
            LeaveRec.Claimed := true;
            LeaveRec.Modify();
            exit(true);
        end;
    end;

    procedure CheckIfAttendanceExistForAllowance(EmpCode: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
    begin
        EmployeeAttendanceActivity.SetLoadFields("Employee No.", "Attendance Date");
        EmployeeAttendanceActivity.SetRange("Employee No.", EmpCode);
        EmployeeAttendanceActivity.SetRange("Attendance Date", FromDate, ToDate);
        if not EmployeeAttendanceActivity.IsEmpty() then
            exit(true);
    end;

    procedure ClearMarkedAllowanceData(DocNo: Code[20])
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        ShiftLine: Record "Shift Line";
    begin
        AssignmentMemoLine.SetRange("Allowance Claim From", DocNo);
        AssignmentMemoLine.ModifyAll("Allowance Claim From", '');

        // ShiftLine.SetRange("Shift Claimed From", DocNo);
        // ShiftLine.ModifyAll("Shift Claimed From", '');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendApprovalAllowanceAssignment(var AllowanceAssignment: Record "Assignment Memo Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertAllowanceAssignmentLine(var AllowanceAssignmntLine: Record "Assignment Memo Line"; var IsHandled: Boolean)
    begin
    end;
}
