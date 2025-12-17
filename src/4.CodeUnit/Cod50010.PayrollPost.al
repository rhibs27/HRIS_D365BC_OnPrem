codeunit 50010 "Payroll-Post"
{
    TableNo = "Payroll Header";
    trigger OnRun()
    begin
        PostedPayrollHeaderRec.Reset;
        PostedPayrollLineRec.Reset;
        PayrollLine.Reset;

        if not Confirm(Text004, true, Rec."No.") then
            exit;
        if PreviewMode then begin
            ClearAll;
            PreviewMode := true;
        end else
            ClearAll;

        GetSetup;
        LockTables;
        PayrollHeader := Rec;
        PayrollHeader.TestField("Pay Cycle Code");
        PayrollHeader.TestField("Pay Cycle Period");
        PayrollHeader.TestField("Pay Cycle Term");
        PayrollHeader.TestField(Status, PayrollHeader.Status::Released);
        PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period");
        if DateNotAllowed(PayrollHeader."Posting Date") then
            PayrollHeader.FieldError("Posting Date", Text003);
        CheckSetup;
        if PayrollHeader.Type <> PayrollHeader.Type::Adjustment then
            PayrollHeader.CheckLines(true);
        if PostNothing then
            Error(Text001);
        Window.Open(
          PostingStateMsg);
        Window.Update(1, PayrollHeader."No.");
        PayrollHeader.SetHideModificationDialog(true);
        PostPayrollDocument;
        DeleteDocument;
        Rec := PayrollHeader;
        Window.Close;
        Commit;
    end;

    var
        PayrollHeader: Record "Payroll Header";
        Text001: Label 'There is nothing to post.';
        PayrollLine: Record "Payroll Line";
        PostedPayrollHeader: Record "Posted Payroll Header";
        PostedPayrollLine: Record "Posted Payroll Line";
        PGSetup: Record "Payroll General Setup";
        SourceCodeSetup: Record "Source Code Setup";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";
        PayrollJnlPostLine: Codeunit "Payroll Jnl.-Post Line";
        Window: Dialog;
        Text002: Label 'Net Salary Payable';
        Text003: Label 'is not within your range of allowed posting dates';
        Text004: Label 'Do you want to post the Document %1?';
        Text005: Label 'Net Salary Payment';
        CreatingEmployeeLedgersTxt: Label 'Creating Employee Ledgers';
        CreatingGLEntriesTxt: Label 'Creating G/L Entries';
        PostingStateMsg: Label 'Salary Document    #1##########\\#3#######################\\Progress @2@@@@@@@@@@@@@', Comment = 'This is a message for dialog window. Parameters do not require translation.';
        TotalCount: Integer;
        LineCount: Integer;
        NetBalanceInConsistency: Label 'The Net Pay of Employee %1 is %2 but the Line Balance calculation is %3. Resolve the calculation before proceeding ahead.';
        PreviewMode: Boolean;
        GenJnlDocumentNo: Code[20];
        PostedPayrollHeaderRec: Record "Posted Payroll Header";
        PostedPayrollLineRec: Record "Posted Payroll Line";
        HRMgt: Codeunit "HR Mgt.";
        LeaveType: Record "Leave Type Setup";
        Employee: Record Employee;
        PayCyclePeriod: Record "Pay Cycle Period";
        PayrollEngine: Codeunit "Payroll Engine";

    local procedure CheckSetup()
    begin
        PGSetup.TestField("Net Payable Account Code");
        SourceCodeSetup.TestField("Payroll Journal");
    end;

    local procedure CreateEmployeePayment(var PayrollJournalLine: Record "Payroll Journal Line" temporary; var LastLineNo: Integer; Merge: Boolean)
    var
        TempPayrollJournalLine: Record "Payroll Journal Line" temporary;
        PaymentMethod: Record "Payment Method";
    begin
        PaymentMethod.Get(PGSetup."Payment Method Code");
        PaymentMethod.TestField("Bal. Account Type", PaymentMethod."Bal. Account Type"::"Bank Account");
        PaymentMethod.TestField("Bal. Account No.");

        if Merge then begin
            PayrollJournalLine.Reset;
            if PGSetup."Net Payable Account Type" = PGSetup."Net Payable Account Type"::"G/L Account" then
                PayrollJournalLine.SetRange("Account Type", PayrollJournalLine."Account Type"::"G/L Account")
            else if PGSetup."Net Payable Account Type" = PGSetup."Net Payable Account Type"::"Bank Account" then
                PayrollJournalLine.SetRange("Account Type", PayrollJournalLine."Account Type"::"Bank Account");
            PayrollJournalLine.SetRange("Account No.", PGSetup."Net Payable Account Code");
            if not PayrollJournalLine.FindFirst then
                exit;
        end;

        TempPayrollJournalLine := PayrollJournalLine;

        PayrollJournalLine.Init;
        PayrollJournalLine.TransferFields(TempPayrollJournalLine);
        PayrollJournalLine."Line No." := LastLineNo + 10000;
        PayrollJournalLine.Amount := TempPayrollJournalLine.Amount * -1;
        PayrollJournalLine.Insert;
        LastLineNo += 10000;

        InitPayrollJnlLine(PayrollJournalLine, LastLineNo);
        PayrollJournalLine."Account Type" := PayrollJournalLine."Account Type"::"Bank Account";
        PayrollJournalLine."Document Type" := PayrollJournalLine."Document Type"::Payment;
        PayrollJournalLine.Description := Text005;
        PayrollJournalLine."Account No." := PaymentMethod."Bal. Account No.";
        PayrollJournalLine.Amount := TempPayrollJournalLine.Amount;

        UpdatePayrollJnl(PayrollJournalLine);
        PostEmployee(PayrollJournalLine);
    end;

    local procedure GetSetup()
    begin
        PGSetup.Get;
        SourceCodeSetup.Get;
    end;

    local procedure InitPayrollJnlLine(var PayrollJournalLine: Record "Payroll Journal Line" temporary; var LastLineNo: Integer)
    begin
        PayrollJournalLine.Init;
        PayrollJournalLine."Document Type" := PayrollJournalLine."Document Type"::Invoice;
        PayrollJournalLine."Document No." := GenJnlDocumentNo;
        PayrollJournalLine."Posting No." := GenJnlDocumentNo;
        PayrollJournalLine."Line No." := LastLineNo + 10000;
        PayrollJournalLine."Source Code" := SourceCodeSetup."Payroll Journal";
        PayrollJournalLine.Insert;
        LastLineNo += 10000;
        PayrollJournalLine.CopyFromPayrollLine(PayrollLine);
        PayrollJournalLine.CopyFromPayrollHeader(PayrollHeader);
    end;

    local procedure InsertDocumentHeader(PayrollHeader: Record "Payroll Header"; var PostedPayrollHeader: Record "Posted Payroll Header")
    begin
        PostedPayrollHeader.Init;
        PostedPayrollHeader.TransferFields(PayrollHeader);
        if PreviewMode then
            PostedPayrollHeader."No." := '***'
        else
            PostedPayrollHeader."No." := PayrollHeader."Posting No.";
        PostedPayrollHeader."Pre-Assigned No." := PayrollHeader."No.";
        PostedPayrollHeader."Posting User ID" := UserId;
        PostedPayrollHeader.Irregular := PayrollHeader.Irregular;
        PostedPayrollHeader."Posted Date" := CurrentDateTime;
        PostedPayrollHeader.Insert;
        if PayrollHeader.Type = PayrollHeader.Type::Adjustment then begin
            PayrollEngine.UpdateOTDisbursedEncashCode(PayrollHeader."No.", PostedPayrollHeader."No.");
        end;
        // if PayrollHeader.Type = PayrollHeader.Type::Payroll then
        //     PayrollEngine.UpdateOTDisbursedAllowances(PayrollHeader, PostedPayrollHeader."No.");
    end;

    local procedure LockTables()
    begin
        EmployeeLedgerEntry.LockTable;
        DetailedEmployeeLedgEntry.LockTable;
    end;

    local procedure PostEmployee(var PayrollJnlLine: Record "Payroll Journal Line" temporary)
    begin
        PayrollJnlPostLine.PostEmployee(PayrollJnlLine);
    end;

    local procedure PostJournal(var PayrollJnlLine: Record "Payroll Journal Line" temporary)
    begin
        Clear(PayrollJnlPostLine);
        PayrollJnlPostLine.GetSetup;
        PayrollJnlPostLine.PostJournal(PayrollJnlLine);
    end;

    procedure PostNothing(): Boolean
    begin
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", PayrollHeader."No.");
        if PayrollLine.IsEmpty then
            exit(true);
    end;

    local procedure PostPayrollDocument()
    var
        PayrollJournalLine: Record "Payroll Journal Line" temporary;
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        NoSeriesMgt: Codeunit "No. Series";
        PayrollEngine: Codeunit "Payroll Engine";
        FieldID: Integer;
        LastLineNo: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;
        LineBalance: Decimal;
        PriorTrfAttributeAmount: Decimal;
        UsePayrollAttributeUsageAllocation: Boolean;
        LeaveEarn: Record "Leave Earn";
        DeputationType: Enum "Deputation Type";
    begin
        RecRef.Open(Database::"Payroll Line");
        FieldRef := RecRef.Field(1);
        FieldRef.SetRange(PayrollHeader."No.");
        GenJnlDocumentNo := PayrollHeader."Posting No.";
        if GenJnlDocumentNo = '' then begin
            PayrollHeader."Posting No." := NoSeriesMgt.GetNextNo(PayrollHeader."Posting No. Series", PayrollHeader."Posting Date", true);
            PayrollHeader.Modify(false);
            Commit;
            GenJnlDocumentNo := PayrollHeader."Posting No.";
        end;
        InsertDocumentHeader(PayrollHeader, PostedPayrollHeader);
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", PayrollHeader."No.");
        TotalCount := PayrollLine.Count;
        LineCount := 0;
        if PayrollLine.FindSet then begin
            Window.Update(3, CreatingEmployeeLedgersTxt);
            repeat
                LineCount += 1;
                LineBalance := 0;
                Window.Update(2, Round(LineCount / TotalCount * 10000, 1));
                FieldRef := RecRef.Field(2);
                FieldRef.SetRange(PayrollLine."Line No.");
                RecRef.FindFirst;
                Clear(PayrollJnlPostLine);
                PostedPayrollLine.InitFromPayrollLine(PostedPayrollHeader, PayrollLine);
                PostedPayrollLine.Insert;
                for FieldID := 61 to 220 do begin
                    FieldRef := RecRef.Field(FieldID);
                    Evaluate(FieldValue, Format(FieldRef.Value));
                    if FieldValue <> 0 then begin
                        PayrollColumnConfiguration.Get(Database::"Payroll Line", FieldID);
                        PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code");

                        UpdateSourceDocumentOnPayrollPost(PayrollAttributes, PayrollLine);

                        if PayrollAttributes.Type in [PayrollAttributes.Type::Benefits, PayrollAttributes.Type::Deduction] then begin
                            if PayrollAttributes.Type = PayrollAttributes.Type::Deduction then
                                FieldValue *= -1;
                            UsePayrollAttributeUsageAllocation := false;
                            if PayrollAttributesUsage.Get(PayrollColumnConfiguration."Variable Field Code", PayrollLine."Employee No.") then begin
                                if PayrollAttributesUsage."Global Dimension 2 Code" <> '' then
                                    UsePayrollAttributeUsageAllocation := true;
                            end;
                            if UsePayrollAttributeUsageAllocation then begin
                                InitPayrollJnlLine(PayrollJournalLine, LastLineNo);
                                PayrollJournalLine.Description := PayrollAttributes.Description;
                                PayrollJournalLine."Account Type" := PayrollJournalLine."Account Type"::"G/L Account";
                                PayrollJournalLine."Account No." := GetEmpDesignationAccount(FieldID);
                                if PayrollJournalLine."Account No." = '' then
                                    PayrollJournalLine."Account No." := PayrollAttributes."G/L Account No.";

                                PayrollJournalLine.Amount := Round(FieldValue, 0.01, '=');
                                LineBalance += PayrollJournalLine.Amount;
                                PayrollJournalLine.UpdateAttribute(PayrollJournalLine, PayrollAttributes);
                                UpdatePayrollJnl(PayrollJournalLine);
                                PayrollJournalLine."Shortcut Dimension 2 Code" := PayrollAttributesUsage."Global Dimension 2 Code";

                                PayrollJournalLine.ValidateShortcutDimCode(2, PayrollAttributesUsage."Global Dimension 2 Code");
                                if PGSetup."Salary Advance" = PayrollAttributes.Code then
                                    PayrollJournalLine."External Document No." := PayrollLine."Salary Advance No.";
                                PayrollJournalLine.Modify;
                                PostEmployee(PayrollJournalLine);
                            end
                            else begin
                                InitPayrollJnlLine(PayrollJournalLine, LastLineNo);
                                PayrollJournalLine.Description := PayrollAttributes.Description;
                                PayrollJournalLine."Account Type" := PayrollJournalLine."Account Type"::"G/L Account";
                                PayrollJournalLine."Account No." := GetEmpDesignationAccount(FieldID);
                                if PayrollJournalLine."Account No." = '' then
                                    PayrollJournalLine."Account No." := PayrollAttributes."G/L Account No.";
                                if PGSetup."Salary Advance" = PayrollAttributes.Code then
                                    PayrollJournalLine."External Document No." := PayrollLine."Salary Advance No.";
                                if CheckTransferInServiceHistory(PayrollLine."Employee No.", PayrollHeader."From Date", PayrollHeader."To Date") then begin
                                    if PGSetup."Total Days From" = PGSetup."Total Days From"::Year then begin
                                        PriorTrfAttributeAmount := Round(Round(FieldValue, 0.01, '=') / PGSetup."Total Days" * 12 * GetServiceDaysBeforeTransfer(PayrollLine."Employee No.", PayrollHeader."From Date"), 0.01, '=');
                                        PayrollJournalLine.Amount := PriorTrfAttributeAmount;
                                        LineBalance += PriorTrfAttributeAmount;
                                        PayrollJournalLine."Shortcut Dimension 1 Code" := GetDimensionBeforeTransfer(PayrollLine."Employee No.", PayrollHeader."From Date", PayrollHeader."To Date", DeputationType);
                                        PayrollJournalLine."Deputation On" := GetDeputationOnBeforeTransfer(PayrollLine."Employee No.", PayrollHeader."From Date", PayrollHeader."To Date");
                                        PayrollJournalLine."Deputation Value" := GetDeputationValueBeforeTransfer(PayrollLine."Employee No.", PayrollHeader."From Date", PayrollHeader."To Date");
                                        PayrollJournalLine.UpdateAttribute(PayrollJournalLine, PayrollAttributes);
                                        UpdatePayrollJnl(PayrollJournalLine);
                                        PostEmployee(PayrollJournalLine);
                                    end;
                                    InitPayrollJnlLine(PayrollJournalLine, LastLineNo);
                                    PayrollJournalLine.Description := PayrollAttributes.Description;
                                    PayrollJournalLine."Account Type" := PayrollJournalLine."Account Type"::"G/L Account";
                                    PayrollJournalLine."Account No." := GetEmpDesignationAccount(FieldID);
                                    if PayrollJournalLine."Account No." = '' then
                                        PayrollJournalLine."Account No." := PayrollAttributes."G/L Account No.";
                                    PayrollJournalLine.Amount := Round(FieldValue, 0.01, '=') - PriorTrfAttributeAmount;
                                    LineBalance += PayrollJournalLine.Amount;
                                    PayrollJournalLine.UpdateAttribute(PayrollJournalLine, PayrollAttributes);
                                    UpdatePayrollJnl(PayrollJournalLine);
                                    PostEmployee(PayrollJournalLine);
                                end
                                else begin
                                    PayrollJournalLine.Amount := Round(FieldValue, 0.01, '=');
                                    LineBalance += PayrollJournalLine.Amount;
                                    PayrollJournalLine.UpdateAttribute(PayrollJournalLine, PayrollAttributes);
                                    UpdatePayrollJnl(PayrollJournalLine);
                                    PostEmployee(PayrollJournalLine);
                                end;
                            end;
                        end;
                        if PayrollAttributes.Type = PayrollAttributes.Type::"Non-Payment" then begin
                            //just create det emp ledger do not post to gl
                            InitPayrollJnlLine(PayrollJournalLine, LastLineNo);
                            PayrollJournalLine.Description := PayrollAttributes.Description;
                            PayrollJournalLine.Amount := FieldValue;
                            PayrollJournalLine.UpdateAttribute(PayrollJournalLine, PayrollAttributes);
                            UpdatePayrollJnl(PayrollJournalLine);
                            PostEmployee(PayrollJournalLine);
                        end;
                    end;
                end;
                if Round(PayrollLine."Net Pay", 0.01, '=') <> Round((LineBalance - PayrollEngine.AddTaxOnInterestAllowance(PayrollLine."Employee No.", PayrollHeader."No.")
+ PayrollEngine.GetLumpsumpCIT(PayrollLine."Employee No.", PayrollHeader."No.")), 0.01, '=') then
                    Error(NetBalanceInConsistency, PayrollLine."Employee No.", PayrollLine."Net Pay", LineBalance - PayrollEngine.AddTaxOnInterestAllowance(PayrollLine."Employee No.", PayrollHeader."No.") +
                    PayrollEngine.GetLumpsumpCIT(PayrollLine."Employee No.", PayrollHeader."No."));
                InitPayrollJnlLine(PayrollJournalLine, LastLineNo);
                if PGSetup."Net Payable Account Type" = PGSetup."Net Payable Account Type"::"Bank Account" then begin
                    PayrollJournalLine."Account Type" := PayrollJournalLine."Account Type"::"Bank Account";
                    PayrollJournalLine."Document Type" := PayrollJournalLine."Document Type"::Payment;
                    PayrollJournalLine.Description := Text005;
                end
                else if PGSetup."Net Payable Account Type" = PGSetup."Net Payable Account Type"::"G/L Account" then begin
                    PayrollJournalLine."Account Type" := PayrollJournalLine."Account Type"::"G/L Account";
                    PayrollJournalLine.Description := Text002;
                end;
                PayrollJournalLine."Account No." := PGSetup."Net Payable Account Code";
                PayrollJournalLine.Amount := PayrollLine."Net Pay" * -1;
                UpdatePayrollJnl(PayrollJournalLine);
                if PayrollJournalLine."Document Type" = PayrollJournalLine."Document Type"::Payment then
                    PostEmployee(PayrollJournalLine);
                if (PGSetup."Payment Method Code" <> '') then
                    CreateEmployeePayment(PayrollJournalLine, LastLineNo, false);
            until PayrollLine.Next = 0;
            //IF PayrollHeader.Type = PayrollHeader.Type::Resignation THEN
            //PayrollEngine.GetLeaveDaysForSettlement(PayrollLine."Total Adjusted Leave Days",SickLeave,"Annual Leave",PayrollLine."Employee No.",TRUE);
        end;
        Window.Update(3, CreatingGLEntriesTxt);
        LineCount := 0;
        PostJournal(PayrollJournalLine);
    end;

    local procedure UpdatePayrollJnl(var PayrollJournalLine: Record "Payroll Journal Line" temporary)
    begin
        PayrollJournalLine."Fiscal Year" := HRMgt.ReturnFiscalYear(PayrollHeader."Posting Date");
        PayrollJournalLine.UpdateLineBalance;
        PayrollJournalLine.GetShortcutDimensions;
        PayrollJournalLine.Modify;
    end;

    local procedure DateNotAllowed(PostingDate: Date): Boolean
    begin
        if not ((PostingDate >= PayCyclePeriod."Start Date") and (PostingDate <= PayCyclePeriod."End Date")) then
            exit(true);
    end;

    local procedure DeleteDocument()
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollAttrUsageHistory: Record "Attributes Usage History";
    begin
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", PayrollHeader."No.");
        if PayrollLine.FindSet then
            repeat
                if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
                    PayrollAttributes.Reset;
                    PayrollAttributes.SetRange("Delete Amount After Posting", true);
                    if PayrollAttributes.FindSet then
                        repeat
                            PayrollAttributesUsage.Reset;
                            PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
                            PayrollAttributesUsage.SetRange("Employee Code", PayrollLine."Employee No.");
                            if PayrollAttributesUsage.FindFirst then begin
                                PayrollAttributesUsage.Amount := 0;
                                PayrollAttributesUsage.Modify;
                            end;
                        until PayrollAttributes.Next = 0;

                    //To Automate stop payment of payroll attribute with end date in history.
                    PayrollAttrUsageHistory.Reset();
                    PayrollAttrUsageHistory.SetRange("End Date", PayrollHeader."From Date", PayrollHeader."To Date");
                    if PayrollAttrUsageHistory.FindSet() then
                        repeat
                            PayrollAttributesUsage.Reset();
                            PayrollAttributesUsage.SetRange(Code, PayrollAttrUsageHistory."Attribute Code");
                            PayrollAttributesUsage.SetRange("Employee Code", PayrollAttrUsageHistory."Employee No.");
                            if PayrollAttrUsageHistory.FindFirst() then begin
                                PayrollAttributesUsage.Amount := 0;
                                PayrollAttributesUsage.Modify;
                            end
                        until PayrollAttrUsageHistory.Next() = 0;
                end;
                if PayrollHeader.Type = PayrollHeader.Type::Settlement then begin
                    Employee.Get(PayrollLine."Employee No.");
                    Employee.Settled := true;
                    Employee.Modify;
                end;
                PayrollLine.Delete;
            until PayrollLine.Next = 0;
        PayrollHeader.Delete;
    end;

    local procedure GetEmpDesignationAccount(FieldID: Integer): Code[20]
    var
        Employee: Record Employee;
        FieldValue: Code[20];
    begin
        Employee.Get(PayrollLine."Employee No.");
        exit(FieldValue);
    end;

    procedure CheckTransferInServiceHistory(EmpNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        EmployeeServiceHistory: Record "Employee Service History";
    begin
        EmployeeServiceHistory.Reset;
        EmployeeServiceHistory.SetRange("Employee No.", EmpNo);
        EmployeeServiceHistory.SetRange("Service Event", EmployeeServiceHistory."Service Event"::Transfer);
        EmployeeServiceHistory.SetRange("Effective Date", FromDate, ToDate);
        if EmployeeServiceHistory.FindFirst() then
            exit(true)
    end;

    local procedure GetServiceDaysBeforeTransfer(EmpNo: Code[20]; FromDate: Date): Decimal
    var
        EmployeeServiceHistory: Record "Employee Service History";
    begin
        EmployeeServiceHistory.Reset;
        EmployeeServiceHistory.SetRange("Service Event", EmployeeServiceHistory."Service Event"::Transfer);
        EmployeeServiceHistory.SetRange("Employee No.", EmpNo);
        if EmployeeServiceHistory.FindFirst() then
            exit(EmployeeServiceHistory."Effective Date" - FromDate + 1)
    end;

    procedure GetDimensionBeforeTransfer(EmpNo: Code[20]; FromDate: Date; ToDate: Date; var DeputationType: Enum "Deputation Type"): Code[20]
    var
        EmployeeServiceHistory: Record "Employee Service History";
        OrganizationStructureList: Record "Organization Structure List";
    begin
        EmployeeServiceHistory.Reset;
        EmployeeServiceHistory.SetRange("Service Event", EmployeeServiceHistory."Service Event"::Transfer);
        EmployeeServiceHistory.SetRange("Effective Date", FromDate, ToDate);
        EmployeeServiceHistory.SetRange("Employee No.", EmpNo);
        if EmployeeServiceHistory.FindFirst() then begin
            DeputationType := EmployeeServiceHistory."Deputation On(From)";
            If OrganizationStructureList.get(DeputationType, EmployeeServiceHistory."Deputation Code (From)") then
                exit(OrganizationStructureList."Dimension Value Code")
        end;
    end;

    procedure GetDeputationOnBeforeTransfer(EmpNo: Code[20]; FromDate: Date; ToDate: Date): Enum "Deputation Type"
    var
        EmployeeServiceHistory: Record "Employee Service History";
        OrganizationStructureList: Record "Organization Structure List";
    begin
        EmployeeServiceHistory.Reset;
        EmployeeServiceHistory.SetRange("Service Event", EmployeeServiceHistory."Service Event"::Transfer);
        EmployeeServiceHistory.SetRange("Effective Date", FromDate, ToDate);
        EmployeeServiceHistory.SetRange("Employee No.", EmpNo);
        if EmployeeServiceHistory.FindFirst() then
            exit(EmployeeServiceHistory."Deputation On(From)");
    end;

    procedure GetDeputationValueBeforeTransfer(EmpNo: Code[20]; FromDate: Date; ToDate: Date): Code[20]
    var
        EmployeeServiceHistory: Record "Employee Service History";
        OrganizationStructureList: Record "Organization Structure List";
    begin
        EmployeeServiceHistory.Reset;
        EmployeeServiceHistory.SetRange("Service Event", EmployeeServiceHistory."Service Event"::Transfer);
        EmployeeServiceHistory.SetRange("Effective Date", FromDate, ToDate);
        EmployeeServiceHistory.SetRange("Employee No.", EmpNo);
        if EmployeeServiceHistory.FindFirst() then
            exit(EmployeeServiceHistory."Deputation Code (From)");
    end;

    procedure UpdateSourceDocumentOnPayrollPost(PayrollAttributes: Record "Payroll Attributes"; PayrollLineRec: Record "Payroll Line")
    var
        LeaveEarn: Record "Leave Earn";
        AllowanceAssignLine: Record "Allowance Assignment Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if PayrollAttributes.Code = PGSetup."Leave Fare Allowance" then begin
            LeaveType.Reset;
            LeaveType.SetRange("AML Eligible", true);
            LeaveType.SetRange("Leave For Employee Type", PayrollLineRec."Employee Type");
            LeaveType.FindFirst;

            LeaveEarn.Reset;
            LeaveEarn.SetRange("Employee No.", PayrollLineRec."Employee No.");
            LeaveEarn.SetRange("Leave Code", LeaveType.Code);
            LeaveEarn.SetRange("Posted Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
            if LeaveEarn.FindSet() then begin
                LeaveEarn.ModifyAll("Payroll Posted", true);
                LeaveEarn.ModifyAll("Payroll Document No", PayrollLineRec."Document No.");
            end;
        end;

        if PayrollAttributes."Specific Attributes" = PayrollAttributes."Specific Attributes"::"Leave Encash" then begin
            LeaveEarn.SetRange("Payroll Document No", PayrollHeader."No.");
            LeaveEarn.SetRange("Payroll Attribute", PayrollAttributes.Code);
            LeaveEarn.SetRange("Posted Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
            if LeaveEarn.FindSet() then
                repeat
                    LeaveEarn."Payroll Posted" := true;
                    LeaveEarn."Payroll Document No" := PostedPayrollHeader."No.";
                    LeaveEarn.Modify();
                until LeaveEarn.Next() = 0;
        end;

        AllowanceAssignLine.SetRange("Allowance Type", PayrollAttributes.Code);
        AllowanceAssignLine.SetRange("Payroll Doc No.", PayrollHeader."No.");
        if AllowanceAssignLine.FindSet() then
            AllowanceAssignLine.ModifyAll("Payroll Doc No.", PostedPayrollHeader."No.");

        //check and update Assignment memo lines if any
        AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Request Allowance");
        AssignmentMemoLedgerEntry.SetRange("Payroll Document No.", PayrollHeader."No.");
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                AssignmentMemoLedgerEntry."Payroll Document No." := PostedPayrollHeader."No.";
                AssignmentMemoLedgerEntry.Open := false;
                AssignmentMemoLedgerEntry.Modify();
            until AssignmentMemoLedgerEntry.Next() = 0;
    end;

    procedure UpdatePayrollAttributesInAttributeAdjustmentLine(AttributeAdjustmentHeader: Record "Attribute Adjustment Header")
    var
        PayrollAttributes: Record "Payroll Attributes";
        AttributeAdjustmentLine, NewAttributeAdjustmentLine : Record "Attribute Adjustment Line";
        TempEmployee: Record Employee temporary;
        PayCyclePeriod: Record "Pay Cycle Period";
        PayrollAttribUsage: Record "Payroll Attributes Usage";
        Formula: Code[100];
    begin
        AttributeAdjustmentLine.SetRange("Document No.", AttributeAdjustmentHeader."Document No.");
        if AttributeAdjustmentLine.FindSet() then
            repeat
                TempEmployee.SetRange("No.", AttributeAdjustmentLine."Employee No.");
                if not TempEmployee.FindFirst() then begin
                    TempEmployee.Init();
                    TempEmployee."No." := AttributeAdjustmentLine."Employee No.";
                    TempEmployee.Insert();
                end;
            until AttributeAdjustmentLine.Next() = 0;

        if TempEmployee.IsEmpty() then
            exit;

        PayCyclePeriod.Get(AttributeAdjustmentHeader."Pay Cycle Code", AttributeAdjustmentHeader."Pay Cycle Term", AttributeAdjustmentHeader."Pay Cycle Period");

        //Delete Existing System Generated Adjustment Lines to avoid duplication
        AttributeAdjustmentLine.Reset();
        AttributeAdjustmentLine.SetRange("System Calculated", true);
        AttributeAdjustmentLine.SetRange("Document No.", AttributeAdjustmentHeader."Document No.");
        if AttributeAdjustmentLine.FindSet() then
            AttributeAdjustmentLine.DeleteAll();

        TempEmployee.Reset();
        TempEmployee.FindSet();
        repeat
            PayrollAttribUsage.SetRange("Formula Exists", true);
            PayrollAttribUsage.SetRange("Employee Code", TempEmployee."No.");
            if PayrollAttribUsage.FindSet() then
                repeat
                    Clear(NewAttributeAdjustmentLine);
                    Clear(Formula);
                    NewAttributeAdjustmentLine.Init();
                    NewAttributeAdjustmentLine."Document No." := AttributeAdjustmentHeader."Document No.";
                    NewAttributeAdjustmentLine."Line No." := GetLineNo(AttributeAdjustmentHeader."Document No.");
                    NewAttributeAdjustmentLine.Validate("Employee No.", TempEmployee."No.");
                    NewAttributeAdjustmentLine."Adjustment Type" := AttributeAdjustmentHeader."Adjustment Type";
                    NewAttributeAdjustmentLine."Attribute Code" := PayrollAttribUsage.Code;
                    Formula := GetPayrollAttributeFormula(PayrollAttribUsage.Code);
                    NewAttributeAdjustmentLine."New Amount" := EvaluateAmountOnAttributeAdjustment(Formula, AttributeAdjustmentHeader, TempEmployee."No.", true); // all new amount
                    NewAttributeAdjustmentLine."Old Amount" := EvaluateAmountOnAttributeAdjustment(Formula, AttributeAdjustmentHeader, TempEmployee."No.", false); // all old amount
                    NewAttributeAdjustmentLine."System Calculated" := true;
                    GetEffectiveStartDateEndDate(NewAttributeAdjustmentLine);
                    NewAttributeAdjustmentLine.Insert();
                until PayrollAttribUsage.Next() = 0;
        until TempEmployee.Next() = 0;

        TempEmployee.DeleteAll();
    end;

    procedure GetPayrollAttributeFormula(AttributeCode: Code[20]): Code[100]
    var
        PayrollAttributes: Record "Payroll Attributes";
    begin
        PayrollAttributes.Get(AttributeCode);
        exit(PayrollAttributes.Formula);
    end;

    local procedure GetLineNo(DocumentNo: Code[20]): Integer
    var
        AttributeAdjustmentLine: Record "Attribute Adjustment Line";
    begin
        AttributeAdjustmentLine.SetRange("Document No.", DocumentNo);
        if AttributeAdjustmentLine.FindLast() then
            exit(AttributeAdjustmentLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetEffectiveStartDateEndDate(var AdjLine: Record "Attribute Adjustment Line")
    var
        AttributeAdjustmentLine: Record "Attribute Adjustment Line";
    begin
        AttributeAdjustmentLine.SetRange("Document No.", AdjLine."Document No.");
        AttributeAdjustmentLine.SetRange("Employee No.", AdjLine."Employee No.");
        if not AttributeAdjustmentLine.FindLast() then
            exit;
        AdjLine."Effective Start Date" := AttributeAdjustmentLine."Effective Start Date";
        AdjLine."Effective End Date" := AttributeAdjustmentLine."Effective End Date";
    end;

    local procedure EvaluateAmountOnAttributeAdjustment(Expression: Code[100]; AttributeAdjustmentHeader: Record "Attribute Adjustment Header"; EmpCode: Code[20]; IsNewAmount: Boolean): Decimal
    var
        OperatorStack: array[100] of Code[20];
        NumberStack: array[100] of Decimal;
        DecNumber: Decimal;
        ContiguousNumber: Boolean;
        CurrExpr: Code[100];
        Counter: Integer;
        Num1: Decimal;
        Num2: Decimal;
        operat: Code[20];
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;
        BasicSalaryAfterDeduction: Decimal;
    begin
        ResolveColumnOnAttributeAdjustment(Expression, AttributeAdjustmentHeader, EmpCode, IsNewAmount);
        Expression := DelChr(Expression, '=', ',');
        Counter := 0;
        ExNo := StrLen(Expression);
        OsNo := 0;
        NsNo := 0;
        repeat
            Counter += 1;
            if Expression[Counter] = '(' then begin
                OsNo += 1;
                OperatorStack[OsNo] := Format(Expression[Counter]);
            end else if Expression[Counter] = ')' then begin
                if OsNo <> 0 then
                    while (OperatorStack[OsNo] <> '(') and (OsNo <> 0) do begin
                        Num2 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        Num1 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        operat := OperatorStack[OsNo];
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                        NsNo += 1;
                        NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
                        if OsNo = 0 then
                            break;
                    end;
                if (OsNo <> 0) then begin
                    OperatorStack[OsNo] := '';
                    OsNo -= 1;
                end;
            end
            else if Expression[Counter] in ['+', '-', '*', '/'] then begin
                if OsNo <> 0 then
                    while (OsNo <> 0) and (CheckPrecedence(OperatorStack[OsNo]) >= CheckPrecedence(Format(Expression[Counter]))) do begin
                        Num2 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        Num1 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        operat := OperatorStack[OsNo];
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                        NsNo += 1;
                        NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
                        if OsNo = 0 then
                            break;
                    end;
                OsNo += 1;
                OperatorStack[OsNo] := Format(Expression[Counter]);
            end else begin
                CurrExpr := '';
                repeat
                    ContiguousNumber := false;
                    if Expression[Counter] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'] then
                        CurrExpr := CurrExpr + Format(Expression[Counter]);
                    if Counter < ExNo then begin
                        if Evaluate(DecNumber, Format(Expression[Counter + 1])) or (Expression[Counter + 1] = '.') then begin
                            ContiguousNumber := true;
                            Counter += 1;
                        end;
                    end;
                until not ContiguousNumber;
                Evaluate(DecNumber, CurrExpr);
                NsNo += 1;
                NumberStack[NsNo] := DecNumber;
            end;
        until Counter = ExNo;

        while (OsNo <> 0) do begin
            Num2 := NumberStack[NsNo];
            NumberStack[NsNo] := 0;
            NsNo -= 1;
            Num1 := NumberStack[NsNo];
            NumberStack[NsNo] := 0;
            NsNo -= 1;
            operat := OperatorStack[OsNo];
            OperatorStack[OsNo] := '';
            OsNo -= 1;
            NsNo += 1;
            NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
        end;
        exit(NumberStack[NsNo]);
    end;

    procedure ResolveColumnOnAttributeAdjustment(var Expression: Code[100]; AttributeAdjustmentHeader: Record "Attribute Adjustment Header"; EmpCode: Code[20]; IsNewAmount: Boolean)
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributes: Record "Payroll Attributes";
        AttributeAdjustmentLine: Record "Attribute Adjustment Line";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BasicAmount: Decimal;
        Substring1: Text;
        SubString2: Text;
        SubString3: Text;
        Length: Integer;
        CalculatedAmount: Decimal;
    begin
        Expression := DelChr(Expression, '=');

        StrPosition := StrPos(Expression, PayrollAttributes."Column Name");
        if StrPosition > 0 then begin
            Expression := DelStr(Expression, StrPosition, StrLen(PayrollAttributes."Column Name"));
            Expression := InsStr(Expression, Format(BasicAmount), StrPosition)
        end;
        StrLength := StrLen(Expression);
        repeat
            if Expression[StrLength] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'] then begin
                PayrollAttributes.Reset;
                PayrollAttributes.SetRange("Column Name", Format(Expression[StrLength]));
                if PayrollAttributes.FindFirst then begin
                    StrPosition := StrPos(Expression, Format(Expression[StrLength]));
                    Expression := DelStr(Expression, StrPosition, StrLen(Format(Expression[StrLength])));

                    AttributeAdjustmentLine.SetRange("Document No.", AttributeAdjustmentHeader."Document No.");
                    AttributeAdjustmentLine.SetRange("Employee No.", EmpCode);
                    AttributeAdjustmentLine.SetRange("Attribute Code", PayrollAttributes.Code);
                    if AttributeAdjustmentLine.FindFirst() then begin
                        if IsNewAmount then
                            CalculatedAmount := AttributeAdjustmentLine."New Amount"
                        else
                            CalculatedAmount := AttributeAdjustmentLine."Old Amount";

                        if CalculatedAmount < 0 then begin
                            Length := StrLen(Expression);
                            Substring1 := CopyStr(Expression, 1, StrPosition - 2);
                            SubString2 := CopyStr(Expression, StrPosition);
                            SubString3 := CopyStr(Expression, StrPosition - 1, 1);
                            if SubString3 = '-' then
                                Expression := InsStr(Substring1 + SubString2, '+' + Format(Abs(CalculatedAmount)), StrPosition - 1)
                            else if SubString3 = '+' then
                                Expression := InsStr(Substring1 + SubString2, '-' + Format(Abs(CalculatedAmount)), StrPosition - 1)
                        end else
                            Expression := InsStr(Expression, Format(CalculatedAmount), StrPosition)
                    end else
                        Expression := InsStr(Expression, Format(0), StrPosition);
                end;
            end;
            StrLength -= 1;
        until StrLength = 0;
    end;

    local procedure CalculateValueOnBasisOfOperator(Number1: Decimal; Number2: Decimal; Opt: Code[20]): Decimal
    begin
        case Opt of
            '*':
                exit(Number1 * Number2);
            '/':
                exit(Number1 / Number2);
            '+':
                exit(Number1 + Number2);
            '-':
                exit(Number1 - Number2);
        end;
    end;

    local procedure CheckPrecedence(Opt: Code[20]): Integer
    begin
        if (Opt = '*') or (Opt = '/') then
            exit(2);
        if (Opt = '+') or (Opt = '-') then
            exit(1);
        exit(0);
    end;
}
