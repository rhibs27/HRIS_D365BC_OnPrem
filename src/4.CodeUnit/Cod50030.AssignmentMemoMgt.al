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
            AssignmentMemoHdr2.Validate("Activity Type", AssignmentMemoHdr2."Activity Type"::"Allowance Assignment Memo");
            AssignmentMemoHdr2.Validate("Approval Status", AssignmentMemoHdr2."Approval Status"::Open);
            AssignmentMemoHdr2.Validate("Employee No.", EmpCode);
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
                AssignmentMemoHdr."Substitute Approval Status" := AssignmentMemoHdr."Substitute Approval Status"::Rejected;
            if (AssignmentMemoHdr."Approval Status" <> AssignmentMemoHdr."Approval Status"::Approved) and
               (AssignmentMemoHdr."Substitute Approval Status" in [AssignmentMemoHdr."Substitute Approval Status"::Open, AssignmentMemoHdr."Substitute Approval Status"::Created]) then
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
        AllowanceConfiguration, AllConfig2 : Record "Allowance Configuration";
        EmployeeWorkShift: Record "Employee Work Shift";
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveMgt: Codeunit "Leave Mgt.";
        DateVar: Record Date;

    begin
        AssignmentMemoHdr.Get(DocumentNo);
        if AssignmentMemoLine.Get(DocumentNo, lineNo) then begin

            //check and update the source substitute ledger entry to closed
            if AssignmentMemoLine."Substitute Type" = AssignmentMemoLine."Substitute Type"::"Added as Substitute" then
                UpdateSubstituteAssignmentMemoLedgerEntry(AssignmentMemoLine);

            if AssignmentMemoLine."Claimed as Leave" then begin

                //Generate substitute leave balance and exit the procedure
                LeaveTypeSetup.SetRange("Leave Category", LeaveTypeSetup."Leave Category"::Substitute);
                LeaveTypeSetup.FindFirst();

                LeaveMgt.CreateLeaveLedger(AssignmentMemoLine."Employee No.",
                LeaveTypeSetup.Code,
                AssignmentMemoLine."From Date",
                Enum::"Leave Earn Type"::Earned,
                AssignmentMemoLine."To Date" - AssignmentMemoLine."From Date" + 1,
                LeaveMgt.GetNextLeaveLedgerEntryNo(),
                AssignmentMemoLine."Document No.",
                'Leave earned against holiday shift',
                ''
                );
                exit;
            end;

            //check allowance configuration source and create ledger entries accordingly
            AllowanceConfiguration.SetRange("Payroll Attribute", AssignmentMemoLine."Payroll Attribute Code");
            AllowanceConfiguration.SetFilter("ATM Site", '%1|%2', AssignmentMemoLine."ATM Site"::" ", AssignmentMemoLine."ATM Site");
            if AllowanceConfiguration.FindSet() then
                repeat
                    // check if allowance is eligible for employee.
                    if AllowanceConfiguration.IsValidAllowanceConfigurationForEmployee(AllowanceConfiguration, AssignmentMemoLine."Employee No.", AssignmentMemoLine."To Date") then begin
                        AllConfig2 := AllowanceConfiguration;
                        break;
                    end;
                until AllowanceConfiguration.Next() = 0;

            DateVar.Reset();
            DateVar.SetRange("Period Type", DateVar."Period Type"::Date);
            if AllConfig2.Source in [AllConfig2.Source::Assignment, AllConfig2.Source::Shift] then
                DateVar.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date")
            else
                DateVar.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."From Date"); //insert only one ledger
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
                    AssignmentMemoLedgerEntry.Validate(Panel, AssignmentMemoLine."Panel");
                    AssignmentMemoLedgerEntry.Validate("ATM Site", AssignmentMemoLine."ATM Site");
                    AssignmentMemoLedgerEntry.Validate("Employee Work Shift", AssignmentMemoLine."Employee Work Shift");
                    if AssignmentMemoHdr."Activity Type" = AssignmentMemoHdr."Activity Type"::"Shift Assignment Memo" then
                        if EmployeeWorkShift.Get(AssignmentMemoLine."Employee Work Shift") then
                            AssignmentMemoLedgerEntry.Validate("Payroll Attribute Code", EmployeeWorkShift."Payroll Attribute Code");

                    if AllConfig2.Source in [AllConfig2.Source::Direct, AllConfig2.Source::" "] then begin
                        AssignmentMemoLedgerEntry.Validate("Valid From Date", AssignmentMemoHdr."From Date");  //allowance that is request once but valid for whole fiscal year
                        AssignmentMemoLedgerEntry.Validate("Valid To Date", AssignmentMemoHdr."To Date");
                    end;

                    AssignmentMemoLedgerEntry.Insert();

                until DateVar.Next() = 0;
        end;
    end;

    procedure SendApprovalAssignmentMemo(var AssignmentmemoHdr: Record "Assignment Memo Header")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalHrms: Record "Approval HRMS";
        IsHandled: Boolean;
    begin
        if AssignmentmemoHdr."Approval Status" = AssignmentmemoHdr."Approval Status"::Open then
            AssignmentMemoHdr.TestField(Remarks);

        AssignmentMemoOnbeforeSendForApproval(AssignmentmemoHdr, IsHandled);

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
                AssignmentMemoLine.TestField("To Date");

                if AssignmentMemoLine."Emp Act Type" in [AssignmentMemoLine."Emp Act Type"::"Allowance Assignment Memo", AssignmentMemoLine."Emp Act Type"::"Request Allowance"] then begin
                    AssignmentMemoLine.TestField("Payroll Attribute Code");
                end;
                if AssignmentMemoLine."Emp Act Type" = AssignmentMemoLine."Emp Act Type"::"Shift Assignment Memo" then begin
                    AssignmentMemoLine.TestField("Employee Work Shift");
                end;
                AssignmentMemoLine.CalculateAmountForLine();  //calculate the amount before sending for approval
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

        //check if substitute dates are within the original assignment memo line dates
        if not ((FromDate >= AssignmentMemoLine."From Date") and (ToDate <= AssignmentMemoLine."To Date")) then
            Error('Substitute dates must be within the original assignment memo line dates.');

        //check conflicting substitute assignment
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
        if not AssignmentMemoHdr.Get(AllowanceAssignmentCode) then
            exit;
        if AssignmentMemoHdr."Payroll Attribute Code" = '' then
            exit;

        AllowanceConfig.SetRange("Payroll Attribute", AssignmentMemoHdr."Payroll Attribute Code");
        AllowanceConfig.FindFirst();

        case AllowanceConfig.Source of
            AllowanceConfig.Source::" ",
            AllowanceConfig.Source::Direct,
            AllowanceConfig.Source::Leave:
                CreateAllowanceRequestLine(AssignmentMemoHdr);
            AllowanceConfig.Source::Assignment, AllowanceConfig.Source::Shift:
                CreateAllowanceRequestLineFromAssignmentLine(AssignmentMemoHdr, AllowanceConfig.Source);

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
        AssignmentMemoLine.Validate("Employee No.", AllowanceAssignmentHdr."Employee No.");
        AssignmentMemoLine.Validate("From Date", AllowanceAssignmentHdr."From Date");
        AssignmentMemoLine.Validate("To Date", AllowanceAssignmentHdr."To Date");
        AssignmentMemoLine.Insert(true);
        AssignmentMemoLine.Validate("Payroll Attribute Code");
        AssignmentMemoLine.Modify();
    end;

    procedure CreateAllowanceRequestLineFromAssignmentLine(AllowanceAssignmentHdr: Record "Assignment Memo Header"; AllowanceConfigSource: Enum "Allowance Config. Source")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        PayrollAttribute: Record "Payroll Attributes";
        CreateAdjustmentledger: Boolean;
    begin
        //while requesting create a assignment line entry from unclaimed allowance ledger entry
        AssignmentMemoLedgerEntry.SetRange("Employee No.", AllowanceAssignmentHdr."Employee No.");

        if AllowanceConfigSource = AllowanceConfigSource::Assignment then
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Allowance Assignment Memo");
        if AllowanceConfigSource = AllowanceConfigSource::Shift then
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Shift Assignment Memo");

        if AllowanceAssignmentHdr."Payroll Attribute Code" <> '' then
            AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", AllowanceAssignmentHdr."Payroll Attribute Code");
        AssignmentMemoLedgerEntry.SetRange(Open, true);
        AssignmentMemoLedgerEntry.SetRange(Claimed, false);
        AssignmentMemoLedgerEntry.SetRange("Claimed Doc No.", '');
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                AssignmentMemoLedgerEntry.CalcFields("Leave Days");
                if AssignmentMemoLedgerEntry."Leave Days" = 0 then begin  //only calim if employee is present or will be present on that date
                    //create assignment memo line
                    Clear(AssignmentMemoLine);
                    AssignmentMemoLine.Init();
                    AssignmentMemoLine.Validate("Document No.", AllowanceAssignmentHdr."No.");
                    AssignmentMemoLine.Validate("Emp Act Type", AllowanceAssignmentHdr."Activity Type");
                    AssignmentMemoLine.Validate("Employee No.", AssignmentMemoLedgerEntry."Employee No.");
                    AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
                    AssignmentMemoLine.Validate("Payroll Attribute Code", AssignmentMemoLedgerEntry."Payroll Attribute Code");
                    AssignmentMemoLine.Validate("From Date", AssignmentMemoLedgerEntry."Posting Date");
                    AssignmentMemoLine.Validate("To Date", AssignmentMemoLedgerEntry."Posting Date");
                    AssignmentMemoLine.Validate("Allowance Amount", AssignmentMemoLedgerEntry.Amount);
                    AssignmentMemoLine."Assign Memo Ledger Entry No." := AssignmentMemoLedgerEntry."Entry No.";
                    AssignmentMemoLine.Validate(Panel, AssignmentMemoLedgerEntry.Panel);
                    AssignmentMemoLine.Validate("ATM Site", AssignmentMemoLedgerEntry."ATM Site");
                    AssignmentMemoLine.Insert(true);
                    AssignmentMemoLine.Validate("Payroll Attribute Code");
                    AssignmentMemoLine.Modify();

                    // mark allowance
                    AssignmentMemoLedgerEntry."Claimed Doc No." := AllowanceAssignmentHdr."No.";
                    AssignmentMemoLedgerEntry.Claimed := true;
                    AssignmentMemoLedgerEntry.Modify();
                end;

            until AssignmentMemoLedgerEntry.Next() = 0;

        //
        AssignmentMemoLedgerEntry.Reset();
        AssignmentMemoLedgerEntry.SetRange("Employee No.", AllowanceAssignmentHdr."Employee No.");
        AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Request Allowance");
        AssignmentMemoLedgerEntry.SetRange("Attendance Checked", false);
        AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", AllowanceAssignmentHdr."Payroll Attribute Code");
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                //check is employee attendance is marked for the allowance request date
                PayrollAttribute.Get(AssignmentMemoLedgerEntry."Payroll Attribute Code");
                AssignmentMemoLedgerEntry.CalcFields("Present Days", "Leave Days", "Leave Days", "Week Off Days", "Absent Days");
                if (AssignmentMemoLedgerEntry."Present Days" > 0) or (AssignmentMemoLedgerEntry."Absent Days" > 0) then begin
                    AssignmentMemoLedgerEntry."Attendance Checked" := true;
                    AssignmentMemoLedgerEntry.Modify();
                    CreateAdjustmentledger := false;
                end
                else if AssignmentMemoLedgerEntry."Week Off Days" > 0 then begin
                    AssignmentMemoLedgerEntry."Attendance Checked" := true;
                    AssignmentMemoLedgerEntry.Modify();
                    if PayrollAttribute."Specific Attributes" = PayrollAttribute."Specific Attributes"::"Holiday Allowance" then
                        CreateAdjustmentledger := true
                    else
                        CreateAdjustmentledger := false;
                end
                else begin
                    CreateAdjustmentledger := true;
                    AssignmentMemoLedgerEntry."Attendance Checked" := true;
                    AssignmentMemoLedgerEntry.Modify();
                end;

                if CreateAdjustmentledger then begin
                    //create opposite ledger line
                    Clear(AssignmentMemoLine);
                    AssignmentMemoLine.Init();
                    AssignmentMemoLine.Validate("Document No.", AllowanceAssignmentHdr."No.");
                    AssignmentMemoLine.Validate("Emp Act Type", AllowanceAssignmentHdr."Activity Type");
                    AssignmentMemoLine.Validate("Employee No.", AssignmentMemoLedgerEntry."Employee No.");
                    AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
                    AssignmentMemoLine.Validate("Payroll Attribute Code", AssignmentMemoLedgerEntry."Payroll Attribute Code");
                    AssignmentMemoLine.Validate("From Date", AssignmentMemoLedgerEntry."Posting Date");
                    AssignmentMemoLine.Validate("To Date", AssignmentMemoLedgerEntry."Posting Date");
                    AssignmentMemoLine.Validate("Allowance Amount", AssignmentMemoLedgerEntry.Amount);
                    AssignmentMemoLine."Assign Memo Ledger Entry No." := AssignmentMemoLedgerEntry."Entry No.";
                    AssignmentMemoLine.Validate(Panel, AssignmentMemoLedgerEntry.Panel);
                    AssignmentMemoLine.Validate("ATM Site", AssignmentMemoLedgerEntry."ATM Site");
                    AssignmentMemoLine."Allowance Amount" := -AssignmentMemoLedgerEntry.Amount;
                    AssignmentMemoLine.Insert(true);
                    AssignmentMemoLine.Validate("Payroll Attribute Code");
                    AssignmentMemoLine.Modify();

                    // no need to mark allowance
                end;

            until AssignmentMemoLedgerEntry.Next() = 0;
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

    procedure AllowanceRequestOnbeforeSendForApproval(DocNo: Code[20])
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
                        if not CheckIfEmployeeIsPresentForAllowance(AssignmentMemoLine."Employee No.", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date") then
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

    procedure CheckIfEmployeeIsPresentForAllowance(EmpCode: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
    begin
        //do not check for future dates
        if (FromDate > WorkDate()) and (ToDate > WorkDate()) then
            exit(true);
        if (FromDate <= WorkDate()) and (ToDate > WorkDate()) then
            ToDate := WorkDate();
        EmployeeAttendanceActivity.SetLoadFields("Employee No.", "Attendance Date");
        EmployeeAttendanceActivity.SetRange("Employee No.", EmpCode);
        EmployeeAttendanceActivity.SetRange("Attendance Date", FromDate, ToDate);
        if EmployeeAttendanceActivity.FindSet() then begin
            repeat
                if (EmployeeAttendanceActivity."Present Day" = 0) and (EmployeeAttendanceActivity."Week Off Day" = 0) then
                    exit(false);
            until EmployeeAttendanceActivity.Next() = 0;
            exit(true);
        end;
    end;


    //shift assignment section
    procedure OpenShiftRequest(EmpCode: Code[20])
    var
        AssignmentMemoHdr, AssignmentMemoHdr2 : Record "Assignment Memo Header";
        Approval: Record "Approval HRMS";
        Employee: Record Employee;
    begin
        // Clear Approval line 
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Shift Assignment Memo");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();

        Employee.Get(EmpCode);
        AssignmentMemoHdr.Reset();
        AssignmentMemoHdr.SetRange("Employee No.", EmpCode);
        AssignmentMemoHdr.SetRange("Activity Type", AssignmentMemoHdr."Activity Type"::"Shift Assignment Memo");
        AssignmentMemoHdr.SetRange("Approval Status", AssignmentMemoHdr."Approval Status"::open);
        if AssignmentMemoHdr.Findfirst() then begin
            Message('This Employee Already has open Shift Assignment Request.Click Ok to Open');
            PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr)
        end else begin
            AssignmentMemoHdr2.Init;
            AssignmentMemoHdr2.Validate("Activity Type", AssignmentMemoHdr2."Activity Type"::"Shift Assignment Memo");
            AssignmentMemoHdr2.Validate("Approval Status", AssignmentMemoHdr2."Approval Status"::Open);
            AssignmentMemoHdr2.Validate("Employee No.", EmpCode);
            AssignmentMemoHdr2.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr2);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approver Mgt", OnApproverejectDocumentOnBeforeCheckApprover, '', false, false)]
    local procedure OnApproverejectDocumentOnBeforeCheckApprover(var RecRef: RecordRef; var EmployeeActivityType: Enum "Employee Activity Type"; var DocumentNo: Code[20]; var ApprovalStatusField: Text)
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        case RecRef.Number of
            Database::"Assignment Memo Header":
                begin
                    AssignmentMemoHdr.Get(DocumentNo);
                    if ApprovalStatusField = 'Approved' then begin
                        if (AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending) then begin
                            ApprovalStatusField := 'Pending';
                        end;
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Assignment Memo Header", OnAfterInsertEvent, '', false, false)]
    local procedure OnafterInsertAssignmentMemoHeader(var Rec: Record "Assignment Memo Header")
    var
        AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
    begin
        if Rec."Activity Type" = Rec."Activity Type"::"Request Allowance" then
            if not GuiAllowed then
                AssignmentMemoMgt.CreateAllowanceAssignmentLineFromRequest(Rec."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approver Mgt", OnRejectDocumentOnBeforeRecRefModify, '', false, false)]
    local procedure OnRejectDocumentOnBeforeRecRefModify(var RecRef: RecordRef; var Approved: Boolean; var SkipRecRefModifyOnReject: Boolean)
    begin
        if not Approved and (RecRef.Number = Database::"Assignment Memo Header") then
            SkipRecRefModifyOnReject := true;
    end;


    [IntegrationEvent(false, false)]
    local procedure AssignmentMemoOnbeforeSendForApproval(var AssignmentMemoHdr: Record "Assignment Memo Header"; var IsHandled: Boolean)
    begin
    end;
}
