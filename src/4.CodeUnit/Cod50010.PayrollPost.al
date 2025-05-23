codeunit 50010 "Payroll-Post"
{
    // version PRM19.01.01

    // //Min 12.28.2022 -- for update OT Disbursed,Payroll No. in Overtime Lines.

    TableNo = "Payroll Header";

    trigger OnRun()
    begin
        PostedPayrollHeaderRec.Reset; //Pranisha Begin
        PostedPayrollLineRec.Reset;
        PayrollLine.Reset;
        PostedPayrollHeaderRec.Reset;
        PostedPayrollHeaderRec.SetRange("Pay Cycle Period", Rec."Pay Cycle Period");
        PostedPayrollHeaderRec.SetRange(Reversed, false);
        if PostedPayrollHeaderRec.FindFirst then begin
            PostedPayrollLineRec.SetRange("Document No.", PostedPayrollHeaderRec."No.");
            /*PayrollLine.RESET;
            PayrollLine.SETRANGE("Document No.",Rec."No.");
            IF PayrollLine.FINDFIRST THEN REPEAT
              IF PostedPayrollLineRec.FINDFIRST THEN REPEAT
                IF PostedPayrollLineRec."Employee No." = PayrollLine."Employee No." THEN
                  ERROR(Text50000,Rec."Pay Cycle Period",PayrollLine."Employee No.");
              UNTIL PostedPayrollLineRec.NEXT = 0;
            UNTIL PayrollLine.NEXT = 0;*/
        end; //Pranisha End
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
        // if PayrollHeader.Type <> PayrollHeader.Type::Adjustment then
        //     PayrollHeader.TestField("Employee Type"); //ratan 1.21.2021
        PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period");
        if DateNotAllowed(PayrollHeader."Posting Date") then
            PayrollHeader.FieldError("Posting Date", Text003);
        CheckSetup;
        //CheckHeader;
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
        if PayrollHeader.Type = PayrollHeader.Type::Adjustment then begin  //Min 12.28.2022
            if PayrollHeader."Encashment Code" <> '' then
                PayrollEngine.UpdateOTDisbursedEncashCode(PayrollHeader, PostedPayrollHeader."No.");
            if PayrollHeader."Encashment Period" <> PayrollHeader."Encashment Period"::" " then
                PayrollEngine.UpdateOTDisbursedEncashPeriod(PayrollHeader, PostedPayrollHeader."No.");
        end;
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then //Min 12.28.2022
            PayrollEngine.UpdateOTDisbursedAllowances(PayrollHeader, PostedPayrollHeader."No.");
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
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PayrollEngine: Codeunit "Payroll Engine";
        FieldID: Integer;
        LastLineNo: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;
        LineBalance: Decimal;
        UsePayrollAttributeUsageAllocation: Boolean;
        EmployeeActivity: Record "Employee Activity";
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
                for FieldID := 47 to 100 do begin //Min 9.16.2022
                    FieldRef := RecRef.Field(FieldID);
                    Evaluate(FieldValue, Format(FieldRef.Value));
                    if FieldValue <> 0 then begin
                        PayrollColumnConfiguration.Get(Database::"Payroll Line", FieldID);
                        PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code");
                        if PayrollAttributes.Code = PGSetup."LFA Alowance" then begin
                            LeaveType.Reset;
                            LeaveType.SetRange("AML Eligible", true);
                            LeaveType.FindFirst;

                            EmployeeActivity.Reset;
                            EmployeeActivity.SetRange("Employee No.", PayrollLine."Employee No.");
                            EmployeeActivity.SetRange("Leave Code", LeaveType.Code);
                            EmployeeActivity.SetRange("Start Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
                            EmployeeActivity.SetRange("Approval Status", EmployeeActivity."Approval Status"::Approved);
                            EmployeeActivity.SetRange(Cancelled, false);
                            if EmployeeActivity.FindFirst then begin
                                EmployeeActivity."LFA Paid" := true;
                                EmployeeActivity.Modify;
                            end;
                        end;
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
                                if PayrollAttributes."Enable Dimension 2 Code Alloc." then begin
                                    /* commented at UTS1.00
                                    JournalAllocation.RESET;
                                    JournalAllocation.SETRANGE("Document No.",PayrollLine."Document No.");
                                    JournalAllocation.SETRANGE("Journal Line No.",PayrollLine."Line No.");
                                    IF JournalAllocation.FINDFIRST THEN BEGIN
                                      TotalNoOfAllocation := JournalAllocation.COUNT;
                                      LineAllocationSum := 0;
                                      REPEAT
                                        TotalNoOfAllocation -= 1;
                                        WITH PayrollJournalLine DO BEGIN
                                          JournalAllocation.TESTFIELD("Allocation %");
                                          JournalAllocation.TESTFIELD("Shortcut Dimension 2 Code");
                                          InitPayrollJnlLine(PayrollJournalLine,LastLineNo);
                                          Description := PayrollAttributes.Description;
                                          "Account Type" := "Account Type"::"G/L Account";
                                          "Account No." := GetEmpDesignationAccount(FieldID);
                                          IF "Account No." = '' THEN
                                            "Account No." := PayrollAttributes."G/L Account No.";

                                          Amount := ROUND(FieldValue * JournalAllocation."Allocation %" / 100,0.01,'=');
                                          LineAllocationSum += Amount;
                                          IF (TotalNoOfAllocation = 0) THEN BEGIN
                                            IF LineAllocationSum <> FieldValue THEN
                                              Amount := Amount - (LineAllocationSum - FieldValue);
                                          END;

                                          LineBalance += Amount;
                                          UpdateAttribute(PayrollJournalLine,PayrollAttributes);
                                          UpdatePayrollJnl(PayrollJournalLine);
                                          "Shortcut Dimension 2 Code" := JournalAllocation."Shortcut Dimension 2 Code";
                                          ValidateShortcutDimCode(2,JournalAllocation."Shortcut Dimension 2 Code");
                                          MODIFY;
                                          PostEmployee(PayrollJournalLine);
                                       END;
                                      UNTIL JournalAllocation.NEXT = 0;
                                    END

                                    ELSE BEGIN
                                      ERROR(ErrDimensionAllocationReq,PayrollAttributes.Code,PayrollLine."Employee No.");
                                    END;
                                    */
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
                //"Shortcut Dimension 1 Code" := PayrollLine."Global Dimension 1 Code";
                //ValidateShortcutDimCode(1,PayrollLine."Global Dimension 1 Code");
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
                end;
                if PayrollHeader.Type = PayrollHeader.Type::Resignation then begin
                    Employee.Get(PayrollLine."Employee No.");
                    Employee.Settled := true;
                    Employee.Modify;
                end;
                PayrollLine.Delete;
            until PayrollLine.Next = 0;
        PayrollHeader.Delete;
        /*JournalAllocation.RESET; //commented at UTS1.00
        JournalAllocation.SETRANGE("Document No.",PayrollHeader."No.");
        JournalAllocation.DELETEALL;
        PayrollBalancingAccount.RESET;
        PayrollBalancingAccount.SETRANGE("Document No.",PayrollHeader."No.");
        PayrollBalancingAccount.DELETEALL;*/
    end;

    local procedure GetEmpDesignationAccount(FieldID: Integer): Code[20]
    var
        Employee: Record Employee;
        FieldValue: Code[20];
    begin
        Employee.Get(PayrollLine."Employee No.");
        /*RecRef.OPEN(DATABASE::"Employee Designation"); //commented at UTS1.00
        FieldRef := RecRef.FIELD(1);
        FieldRef.SETRANGE(Employee."Employee Designation");
        RecRef.FINDFIRST;
        FieldRef := RecRef.FIELD(FieldID);
        EVALUATE(FieldValue,FORMAT(FieldRef.VALUE));*/
        exit(FieldValue);
    end;
}
