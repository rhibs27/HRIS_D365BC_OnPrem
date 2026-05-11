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
        ServiceDaysBeforeTransfer: Decimal;
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
                                if CheckTransferInServiceHistory(PayrollLine."Employee No.", PayrollHeader."From Date",
                                                                PayrollHeader."To Date", ServiceDaysBeforeTransfer,
                                                                PayrollJournalLine."Deputation On", PayrollJournalLine."Deputation Value",
                                                                PayrollJournalLine."Shortcut Dimension 1 Code", PayrollJournalLine."Sol ID") then begin
                                    if PGSetup."Total Days From" = PGSetup."Total Days From"::Year then
                                        PriorTrfAttributeAmount := Round(Round(FieldValue, 0.01, '=') / PGSetup."Total Days" * 12 * ServiceDaysBeforeTransfer, 0.01, '=')
                                    else if PGSetup."Total Days From" = PGSetup."Total Days From"::Month then
                                        //Payline: Adjustment plan  doesnot contain Total days 
                                        PriorTrfAttributeAmount := Round(FieldValue / PayrollHeader."Total Days" * ServiceDaysBeforeTransfer, 0.01, '=');

                                    PayrollPostOnafterTransferCheckOnBeforeUpdateAmount(PayrollJournalLine, PayrollAttributes, PayrollLine."Document No.", PriorTrfAttributeAmount);

                                    PayrollJournalLine.Amount := PriorTrfAttributeAmount;
                                    LineBalance += PriorTrfAttributeAmount;
                                    PayrollJournalLine.UpdateAttribute(PayrollJournalLine, PayrollAttributes);
                                    UpdatePayrollJnl(PayrollJournalLine);
                                    PostEmployee(PayrollJournalLine);

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
                        if PayrollAttributes."Specific Attributes" = PayrollAttributes."Specific Attributes"::"OverTime Salary" then begin
                            PayrollEngine.PostEmployeeOvertimeLedger(PayrollHeader."No.", PostedPayrollHeader."No.");
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
            OnBeforeUpdateEmployeeBaseForALPayment(PayrollHeader);
        end;
        UpdatePayrollNoInAllowanceAssignment;
        Window.Update(3, CreatingGLEntriesTxt);
        LineCount := 0;
        PostJournal(PayrollJournalLine);
    end;

    local procedure UpdatePayrollJnl(var PayrollJournalLine: Record "Payroll Journal Line" temporary)
    begin
        PayrollJournalLine."Fiscal Year" := HRMgt.ReturnFiscalYear(PayrollHeader."Posting Date");
        PayrollJournalLine.UpdateLineBalance;
        //PayrollJournalLine.GetShortcutDimensions;   //Redundant assigning of dimensions
        PayrollJournalLine.Modify;
    end;

    local procedure DateNotAllowed(PostingDate: Date): Boolean
    begin
        if not ((PostingDate >= PayCyclePeriod."Start Date") and (PostingDate <= PayCyclePeriod."End Date")) then
            exit(true);
    end;

    local procedure UpdatePayrollNoInAllowanceAssignment()
    var
        AllowanceAssignLine: Record "Allowance Assignment Line";
    begin
        AllowanceAssignLine.Reset();
        AllowanceAssignLine.SetRange("Payroll Doc No.", PayrollHeader."No.");
        if AllowanceAssignLine.FindSet() then
            repeat
                AllowanceAssignLine.Validate("Payroll Doc No.", PostedPayrollHeader."No.");
                AllowanceAssignLine.Validate("Payroll Posted", true);
                AllowanceAssignLine.Modify();
            until AllowanceAssignLine.Next() = 0;
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
                            if PayrollAttributesUsage.get(PayrollAttributes.Code, PayrollLine."Employee No.") then begin
                                PayrollAttributesUsage.Amount := 0;
                                PayrollAttributesUsage.Modify;
                            end;
                        until PayrollAttributes.Next = 0;
                end;
                if PayrollHeader.Type = PayrollHeader.Type::Settlement then begin
                    Employee.Get(PayrollLine."Employee No.");
                    Employee.Settled := true;
                    Employee.Modify;
                end;
            until PayrollLine.Next = 0;
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then
            ClearPayrollAttributeUsageFromAttributeHistory(PayrollHeader."From Date", PayrollHeader."To Date");
        PayrollLine.DeleteAll();
        PayrollHeader.Delete;
    end;

    local procedure ClearPayrollAttributeUsageFromAttributeHistory(FromDate: Date; ToDate: Date)
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollAttrUsageHistory: Record "Attributes Usage History";
    begin
        //To Automate stop payment of payroll attribute with end date in history.
        PayrollAttrUsageHistory.Reset();
        PayrollAttrUsageHistory.SetRange("End Date", FromDate, ToDate);
        PayrollAttrUsageHistory.SetRange(Reversed, false);
        if PayrollAttrUsageHistory.FindSet() then
            repeat
                if PayrollAttributesUsage.get(PayrollAttrUsageHistory."Attribute Code", PayrollAttrUsageHistory."Employee No.") then begin
                    PayrollAttributesUsage.Amount := 0;
                    PayrollAttributesUsage.Modify;
                end;
            until PayrollAttrUsageHistory.Next() = 0;
    end;

    local procedure GetEmpDesignationAccount(FieldID: Integer): Code[20]
    var
        Employee: Record Employee;
        FieldValue: Code[20];
    begin
        Employee.Get(PayrollLine."Employee No.");
        exit(FieldValue);
    end;

    procedure CheckTransferInServiceHistory(EmpNo: Code[20];
                                            FromDate: Date;
                                            ToDate: Date;
                                            var ServiceDays: Decimal;
                                            var DeputationType: Enum "Deputation Type";
                                            var DeputationCode: Code[20];
                                            var DimensionValue: Code[20];
                                            var SolID: Code[20]): Boolean
    var
        EmployeeServiceHistory: Record "Employee Service History";
        OrgStructList: Record "Organization Structure List";
    begin
        EmployeeServiceHistory.Reset;
        EmployeeServiceHistory.SetRange("Employee No.", EmpNo);
        EmployeeServiceHistory.SetRange("Service Event", EmployeeServiceHistory."Service Event"::Transfer);
        EmployeeServiceHistory.SetRange("Effective Date", FromDate, ToDate);
        if EmployeeServiceHistory.FindFirst() then begin
            ServiceDays := EmployeeServiceHistory."Effective Date" - FromDate;
            DeputationType := EmployeeServiceHistory."Deputation On(From)";
            DeputationCode := EmployeeServiceHistory."Deputation Code (From)";
            OrgStructList.Get(DeputationType, DeputationCode);
            DimensionValue := OrgStructList."Dimension Value Code";
            SolID := OrgStructList."Sol ID";
            exit(true)
        end;
    end;

    procedure UpdateSourceDocumentOnPayrollPost(PayrollAttributes: Record "Payroll Attributes"; PayrollLineRec: Record "Payroll Line")
    var
        LeaveEarn: Record "Leave Earn";
        EncashmentRequest: Record "Encashment Request";
        AllowanceAssignLine: Record "Allowance Assignment Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        SalaryDeductionEntry: Record "Salary Deduction Entry";
    begin
        if PayrollAttributes.Code = PGSetup."Leave Fare Allowance" then begin
            LeaveType.Reset;
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
                    //To modify taken leave is encashed 
                    EncashmentRequest.SetRange("No.", LeaveEarn."Leave Request No");
                    if EncashmentRequest.FindFirst() then begin
                        EncashmentRequest.Validate(Paid, true);
                        EncashmentRequest.Validate("Paid Date", PostedPayrollHeader."Posting Date");
                        EncashmentRequest.Modify();
                    end;
                until LeaveEarn.Next() = 0;
        end;

        //check and update Assignment memo lines if any
        AssignmentMemoLedgerEntry.SetRange("Payroll Posted", false);
        PGSetup.Get();
        if PGSetup."Get Amount From Assignment" then
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Allowance Assignment Memo")
        else
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Request Allowance");
        AssignmentMemoLedgerEntry.SetRange("Payroll Document No.", PayrollHeader."No.");
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                AssignmentMemoLedgerEntry."Payroll Document No." := PostedPayrollHeader."No.";
                AssignmentMemoLedgerEntry.Open := false;
                AssignmentMemoLedgerEntry."Payroll Posted" := true;
                AssignmentMemoLedgerEntry."Payroll Posted Date" := PostedPayrollHeader."Posting Date";
                AssignmentMemoLedgerEntry."Payroll Posted Month" := PostedPayrollHeader."Nepali Month";
                AssignmentMemoLedgerEntry.Modify();
            until AssignmentMemoLedgerEntry.Next() = 0;

        if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
            SalaryDeductionEntry.Reset();
            SalaryDeductionEntry.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
            SalaryDeductionEntry.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
            SalaryDeductionEntry.SetRange("Pay Cycle Period", PayrollHeader."Pay Cycle Period");
            SalaryDeductionEntry.SetRange("Attendance Posted", true);
            SalaryDeductionEntry.ModifyAll("Payroll Posted", true);
            SalaryDeductionEntry.ModifyAll("Payroll Document No.", PostedPayrollHeader."No.");
        end;
        OnAfterUpdateSourceDocumentOnPayrollPost(PayrollAttributes, PayrollLineRec, PGSetup, PostedPayrollHeader);
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeUpdateEmployeeBaseForALPayment(PayrollHeader: Record "Payroll Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterUpdateSourceDocumentOnPayrollPost(PayrollAttributes: Record "Payroll Attributes"; PayrollLine: Record "Payroll Line"; PGSetup: Record "Payroll General Setup"; PostedPayrollHeader: Record "Posted Payroll Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure PayrollPostOnafterTransferCheckOnBeforeUpdateAmount(var PayrollJournalLine: Record "Payroll Journal Line" temporary;
                                                PayrollAttributes: Record "Payroll Attributes";
                                                DocumentNo: Code[20];
                                                var PriorTrfAttributeAmount: Decimal)
    begin
    end;
}
