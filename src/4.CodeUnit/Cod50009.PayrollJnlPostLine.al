codeunit 50009 "Payroll Jnl.-Post Line"
{
    Permissions = tabledata "Employee Ledger Entry" = RIM,
                tabledata "Detailed Employee Ledger Entry" = RIM,
                tabledata "Payable Employee Ledger Entry" = RIM;

    // version PRM19.01.01

    TableNo = "Payroll Journal Line";

    trigger OnRun()
    begin
        if not Confirm(Text001, true, Rec."Document No.") then
            exit;

        TemplateCode := Rec."Journal Template Name";
        BatchCode := Rec."Journal Batch Name";
        PayrollJournalLine.Copy(Rec);
        RunWithCheck(PayrollJournalLine);
        Rec := PayrollJournalLine;
    end;

    var
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";
        PGSetup: Record "Payroll General Setup";
        GenJnlLine: Record "Gen. Journal Line";
        PayrollJournalLine: Record "Payroll Journal Line";
        PayrollJnlBatch: Record "Payroll Journal Batch";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        NoSeriesCodeunit: Codeunit "No. Series";
        NoSeries2: Codeunit "No. Series";
        NoSeries: Record "No. Series";
        EmpLedgCreated: Boolean;
        GLEntryNo: Integer;
        Text001: Label 'Do you want to post the Journal %1?';
        TemplateCode: Code[20];
        BatchCode: Code[20];
        Text002: Label 'Payroll Journal Posted Successfully.';
        Window: Dialog;
        TotalCount: Integer;
        LineCount: Integer;
        CreatingEmployeeLedgersTxt: Label 'Creating Employee Ledgers';
        CreatingGLEntriesTxt: Label 'Creating G/L Entries';
        PostingStateMsg: Label 'Payroll Journal    #1##########\\#3#######################\\Progress @2@@@@@@@@@@@@@', Comment = 'This is a message for dialog window. Parameters do not require translation.';
        LastDocNo: Code[20];
        PostingNo: Code[20];
        GlEntry: Record "G/L Entry";
        PostPrint: Boolean;
        HRMgt: Codeunit "HR Mgt.";
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        NoSeriesBatch: Codeunit "No. Series - Batch";

    procedure RunWithCheck(var PayrollJournalLine2: Record "Payroll Journal Line"): Integer
    var
        PayrollJournalLine: Record "Payroll Journal Line";
    begin
        Code(PayrollJournalLine, true);
    end;

    procedure RunWithoutCheck(var PayrollJournalLine2: Record "Payroll Journal Line"): Integer
    var
        PayrollJournalLine: Record "Payroll Journal Line";
    begin
        Code(PayrollJournalLine, false);
    end;

    local procedure "Code"(var PayrollJournalLine: Record "Payroll Journal Line"; CheckLine: Boolean)
    var
        PreviousEmployee: Code[20];
        RecentEmployee: Code[20];
        DocNo: Code[20];
    begin
        Window.Open(
          PostingStateMsg);
        GetSetup;
        PayrollJournalLine.Reset;
        PayrollJournalLine.SetCurrentKey("Employee No.");
        PayrollJournalLine.SetRange("Journal Template Name", TemplateCode);
        PayrollJournalLine.SetRange("Journal Batch Name", BatchCode);
        Window.Update(1, PayrollJournalLine."Document No.");
        TotalCount := PayrollJournalLine.Count;
        LineCount := 0;
        Window.Update(3, CreatingEmployeeLedgersTxt);
        if PayrollJournalLine.FindSet then
            repeat
                LineCount += 1;
                Window.Update(2, Round(LineCount / TotalCount * 10000, 1));
                RecentEmployee := PayrollJournalLine."Employee No.";
                if PreviousEmployee <> RecentEmployee then
                    EmpLedgCreated := false;
                if CheckLine then
                    CheckPayrollJnlLine(PayrollJournalLine);
                CheckDocumentNo(PayrollJournalLine);
                if (PayrollJournalLine."Attribute Code" <> '') then //OR
                                                                    //(("Account Type" = "Account Type"::"Bank Account") AND ("Document Type" = "Document Type"::Payment)) THEN {Commented in Toyota not applicable as of now}
                    PostEmployee(PayrollJournalLine);
                PreviousEmployee := RecentEmployee;
            until PayrollJournalLine.Next = 0;
        Window.Update(3, CreatingGLEntriesTxt);
        PostJournal(PayrollJournalLine);
        if GLEntryNo <> 0 then begin
            UpdateAndDeleteLines;
            if PayrollJnlBatch."No. Series" <> '' then
                NoSeriesBatch.SaveState();
            Message(Text002);
            Commit;
        end;

        if PostPrint then begin
            GlEntry.Reset;
            GlEntry.SetRange("Entry No.", GLEntryNo);
            if GlEntry.FindFirst then begin
                DocNo := GlEntry."Document No.";
            end;

            GlEntry.Reset;
            GlEntry.SetRange("Document No.", DocNo);
            if GlEntry.FindFirst then
                Report.RunModal(50011, true, false, GlEntry);
        end;
    end;

    local procedure InitEmpLedgEntry(var PayrollJnlLine: Record "Payroll Journal Line"; var EmployeeLedgerEntry: Record "Employee Ledger Entry")
    var
        NextEntryNo: Integer;
    begin
        EmployeeLedgerEntry.LockTable;
        if EmployeeLedgerEntry.FindLast then begin
            NextEntryNo := EmployeeLedgerEntry."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;

        EmployeeLedgerEntry.Init;
        EmployeeLedgerEntry.CopyFromPayrollJnlLine(PayrollJnlLine);
        EmployeeLedgerEntry."Entry No." := NextEntryNo;
        EmployeeLedgerEntry.Open := true;
        EmployeeLedgerEntry."Creation Date" := Today;
        EmployeeLedgerEntry."User ID" := UserId;
    end;

    local procedure InitDetailedEmpLedgEntry(var PayrollJnlLine: Record "Payroll Journal Line"; var DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry")
    var
        NextEntryNo: Integer;
    begin
        if DetailedEmployeeLedgEntry.FindLast then begin
            NextEntryNo := DetailedEmployeeLedgEntry."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;

        DetailedEmployeeLedgEntry.Init;
        DetailedEmployeeLedgEntry."Entry No." := NextEntryNo;
        DetailedEmployeeLedgEntry.CopyFromPayrollJnlLine(PayrollJnlLine);
        DetailedEmployeeLedgEntry."Entry No." := NextEntryNo;
        DetailedEmployeeLedgEntry."Creation Date" := Today;
        DetailedEmployeeLedgEntry."User ID" := UserId;
    end;

    procedure PostEmployee(var PayrollJnlLine: Record "Payroll Journal Line")
    begin
        if not EmpLedgCreated then begin
            InitEmpLedgEntry(PayrollJnlLine, EmployeeLedgerEntry);
            EmployeeLedgerEntry.Insert(true);
            EmpLedgCreated := true;
        end;
        InitDetailedEmpLedgEntry(PayrollJnlLine, DetailedEmployeeLedgEntry);
        DetailedEmployeeLedgEntry."Employee Ledger Entry No." := EmployeeLedgerEntry."Entry No.";
        DetailedEmployeeLedgEntry.Insert(true);
    end;

    local procedure PostPayrollJnlLine(var PayrollJnlLine: Record "Payroll Journal Line"; Integrate: Boolean)
    var
        IntPayrollJnlLine: Record "Payroll Journal Line" temporary;
        EmployeeWisePosting: Boolean;
        FindPositive: Boolean;
    begin
        if Integrate then begin
            PayrollJnlLine.Reset;
            PayrollJnlLine.SetRange("Journal Template Name", TemplateCode);
            PayrollJnlLine.SetRange("Journal Batch Name", BatchCode);
            PayrollJnlLine.SetFilter("Account No.", '<>%1', '');
            PayrollJnlLine.SetFilter("Attribute Code", '<>%1', '');
            if PayrollJnlLine.FindSet then
                repeat
                    EmployeeWisePosting := PayrollJnlLine.SetEmployeeWisePosting(PayrollJnlLine."Attribute Code");
                    IntPayrollJnlLine.Reset;
                    IntPayrollJnlLine.SetRange("Account Type", PayrollJnlLine."Account Type");
                    IntPayrollJnlLine.SetRange("Account No.", PayrollJnlLine."Account No.");
                    IntPayrollJnlLine.SetRange("Shortcut Dimension 1 Code", PayrollJnlLine."Shortcut Dimension 1 Code");
                    IntPayrollJnlLine.SetRange("Shortcut Dimension 2 Code", PayrollJnlLine."Shortcut Dimension 2 Code");
                    if EmployeeWisePosting then
                        IntPayrollJnlLine.SetRange("Employee No.", PayrollJnlLine."Employee No.");
                    if IntPayrollJnlLine.FindFirst then begin
                        IntPayrollJnlLine.Amount += PayrollJnlLine.Amount;
                        IntPayrollJnlLine.Modify;
                    end
                    else begin
                        IntPayrollJnlLine.Init;
                        IntPayrollJnlLine.TransferFields(PayrollJnlLine);
                        if not EmployeeWisePosting then begin
                            IntPayrollJnlLine."Dimension Set ID" := 0;
                            IntPayrollJnlLine.ValidateShortcutDimCode(1, PayrollJnlLine."Shortcut Dimension 1 Code");
                            IntPayrollJnlLine.ValidateShortcutDimCode(2, PayrollJnlLine."Shortcut Dimension 2 Code");
                            IntPayrollJnlLine.UpdateShortcutDimFromDimSetID;
                            IntPayrollJnlLine."Employee No." := '';
                        end;
                        IntPayrollJnlLine.Insert;
                    end;
                until PayrollJnlLine.Next = 0;

            PayrollJnlLine.Reset;
            PayrollJnlLine.SetRange("Journal Template Name", TemplateCode);
            PayrollJnlLine.SetRange("Journal Batch Name", BatchCode);
            PayrollJnlLine.SetFilter("Account No.", '<>%1', '');
            PayrollJnlLine.SetFilter("Attribute Code", '%1', '');
            if PayrollJnlLine.FindSet then
                repeat
                    EmployeeWisePosting := PGSetup."Posting Method" = PGSetup."Posting Method"::"Employee Wise";
                    FindPositive := (PayrollJnlLine.Amount >= 0);
                    IntPayrollJnlLine.Reset;
                    IntPayrollJnlLine.SetRange("Account Type", PayrollJnlLine."Account Type");
                    IntPayrollJnlLine.SetRange("Account No.", PayrollJnlLine."Account No.");
                    IntPayrollJnlLine.SetRange("Shortcut Dimension 1 Code", PayrollJnlLine."Shortcut Dimension 1 Code");
                    IntPayrollJnlLine.SetRange("Shortcut Dimension 2 Code", PayrollJnlLine."Shortcut Dimension 2 Code");
                    if EmployeeWisePosting then
                        IntPayrollJnlLine.SetRange("Employee No.", PayrollJnlLine."Employee No.");
                    if FindPositive then
                        IntPayrollJnlLine.SetFilter(Amount, '>=%1', 0)
                    else
                        IntPayrollJnlLine.SetFilter(Amount, '<%1', 0);
                    if IntPayrollJnlLine.FindFirst then begin
                        IntPayrollJnlLine.Amount += PayrollJnlLine.Amount;
                        IntPayrollJnlLine.Modify;
                    end else begin
                        IntPayrollJnlLine.Init;
                        IntPayrollJnlLine.TransferFields(PayrollJnlLine);
                        if not EmployeeWisePosting then begin
                            IntPayrollJnlLine."Dimension Set ID" := 0;
                            IntPayrollJnlLine.ValidateShortcutDimCode(1, PayrollJnlLine."Shortcut Dimension 1 Code");
                            IntPayrollJnlLine.ValidateShortcutDimCode(2, PayrollJnlLine."Shortcut Dimension 2 Code");
                            IntPayrollJnlLine.UpdateShortcutDimFromDimSetID;
                            IntPayrollJnlLine."Employee No." := '';
                        end;
                        IntPayrollJnlLine.Insert;
                    end;
                until PayrollJnlLine.Next = 0;

            IntPayrollJnlLine.Reset;
            if IntPayrollJnlLine.FindSet then
                repeat
                    PostGenJnlLine(IntPayrollJnlLine);
                until IntPayrollJnlLine.Next = 0;
        end else begin
            PayrollJnlLine.Reset;
            PayrollJnlLine.SetRange("Journal Template Name", TemplateCode);
            PayrollJnlLine.SetRange("Journal Batch Name", BatchCode);
            PayrollJnlLine.SetFilter("Account No.", '<>%1', '');
            PayrollJnlLine.SetCurrentKey("Employee No.");
            if PayrollJnlLine.FindSet then
                repeat
                    PostGenJnlLine(PayrollJnlLine);
                until PayrollJnlLine.Next = 0;
        end;
    end;

    procedure PostJournal(var PayrollJnlLine: Record "Payroll Journal Line")
    begin
        if PGSetup."Posting Method" = PGSetup."Posting Method"::"Global Dimension Wise" then
            PostPayrollJnlLine(PayrollJnlLine, true)
        else if PGSetup."Posting Method" = PGSetup."Posting Method"::"Employee Wise" then
            PostPayrollJnlLine(PayrollJnlLine, false);
    end;

    procedure GetSetup()
    begin
        PGSetup.Get;
        if BatchCode <> '' then
            PayrollJnlBatch.Get(BatchCode);
    end;

    local procedure PostGenJnlLine(var PayrollJnlLine: Record "Payroll Journal Line")
    var
        ShortcutDimCode: array[8] of Code[20];
        EmpSalAdv: Record "Employee Loan/Advance";
        PayrollAttributes: Record "Payroll Attributes";
        GenJnlLine2: Record "Gen. Journal Line";
    begin

        Clear(GenJnlLine);
        Clear(ShortcutDimCode);
        PayrollJnlLine.TestField("Account No.");
        GenJnlLine.Init;
        GenJnlLine."Posting Date" := PayrollJnlLine."Posting Date";
        GenJnlLine."Document Date" := PayrollJnlLine."Document Date";
        GenJnlLine.Description := PayrollJnlLine.Description;
        GenJnlLine."Document Type" := PayrollJnlLine."Document Type";
        if PayrollJnlLine."Posting No." <> '' then
            GenJnlLine."Document No." := PayrollJnlLine."Posting No."
        else
            GenJnlLine."Document No." := PayrollJnlLine."Document No.";
        GenJnlLine."Account Type" := PayrollJnlLine."Account Type";
        GenJnlLine."Account No." := PayrollJnlLine."Account No.";
        //SRT >>
        GenJnlLine."Bal. Account Type" := PayrollJnlLine."Bal. Account Type";
        GenJnlLine."Bal. Account No." := PayrollJnlLine."Bal. Account No.";
        GenJnlLine."Posted Payroll Plan No." := PayrollJnlLine."Posted Payroll Plan No.";
        GenJnlLine."Posted Payroll Plan Line No." := PayrollJnlLine."Posted Payroll Plan Line No.";

        //SRT <<
        GenJnlLine.Validate(Amount, Round(PayrollJnlLine.Amount, 0.01, '='));
        DebitAmount += PayrollJnlLine."Debit Amount";
        CreditAmount += PayrollJnlLine."Credit Amount";
        GenJnlLine.Correction := PayrollJnlLine.Correction;
        GenJnlLine."Shortcut Dimension 1 Code" := PayrollJnlLine."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := PayrollJnlLine."Shortcut Dimension 2 Code";

        GenJnlLine."Dimension Set ID" := PayrollJnlLine."Dimension Set ID";
        GenJnlLine.ShowShortcutDimCode(ShortcutDimCode);
        GenJnlLine."Shortcut Dimension 3 Code" := ShortcutDimCode[3];
        GenJnlLine."Shortcut Dimension 4 Code" := ShortcutDimCode[4];
        GenJnlLine."Shortcut Dimension 5 Code" := ShortcutDimCode[5];
        GenJnlLine."Shortcut Dimension 6 Code" := ShortcutDimCode[6];
        GenJnlLine."Shortcut Dimension 7 Code" := ShortcutDimCode[7];
        GenJnlLine."Shortcut Dimension 8 Code" := ShortcutDimCode[8];
        GenJnlLine."Fiscal Year" := HRMgt.ReturnFiscalYear(PayrollJnlLine."Posting Date");
        GenJnlLine."Source Code" := PayrollJnlLine."Source Code";
        GenJnlLine."Posting No. Series" := PayrollJnlLine."Posting No. Series";
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine.Narration := PayrollJnlLine.Narration;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Employee;
        GenJnlLine."Source No." := PayrollJnlLine."Employee No.";
        GenJnlLine."External Document No." := PayrollJnlLine."External Document No.";

        if PGSetup."Salary Advance" = PayrollJnlLine."Attribute Code" then begin
            if EmpSalAdv.Get(PayrollJnlLine."External Document No.") then begin
                EmpSalAdv.CalcFields("Salary Advance Paid");
                EmpSalAdv.Validate("Remaining Amount", EmpSalAdv."Applied Loan/Advance" - EmpSalAdv."Salary Advance Paid");
                if (EmpSalAdv."Applied Loan/Advance" - EmpSalAdv."Salary Advance Paid") = 0 then begin
                    EmpSalAdv.Validate(Settled, true);
                    EmpSalAdv.Validate("Settlement Date", Today);  //always today?
                    EmpSalAdv.Validate("Settler User ID", UserId);
                    EmpSalAdv.Modify(false);
                end;
            end;
        end;

        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Code, PayrollJnlLine."Attribute Code");
        if PayrollAttributes.FindFirst then
            if PayrollAttributes.Subtype in [PayrollAttributes.Subtype::"Lump Sum Contribution", PayrollAttributes.Subtype::"Tax on Interest"] then begin
                GenJnlLine2.Init;
                GenJnlLine2.Copy(GenJnlLine);
                GenJnlLine2.Validate(Amount, -GenJnlLine.Amount);
                CreditAmount += GenJnlLine2."Credit Amount";
                DebitAmount += GenJnlLine2."Debit Amount";
                GenJnlPostLine.RunWithCheck(GenJnlLine2);
            end;
        GLEntryNo := GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;

    local procedure UpdateAndDeleteLines()
    var
        PayrollJournalLine2: Record "Payroll Journal Line";
    begin
        PayrollJournalLine2.Reset;
        PayrollJournalLine2.SetRange("Journal Template Name", PayrollJournalLine."Journal Template Name");
        PayrollJournalLine2.SetRange("Journal Batch Name", PayrollJournalLine."Journal Batch Name");
        PayrollJournalLine2.DeleteAll;
    end;

    local procedure CheckPayrollJnlLine(var PayrollJournalLine: Record "Payroll Journal Line")
    begin
        PayrollJournalLine.TestField("Account No.");
        PayrollJournalLine.TestField("Posting Date");
        if PayrollJournalLine."Attribute Code" <> '' then begin
            //TestField("Document Type","Document Type"::" "); UTS Commented
            PayrollJournalLine.TestField("Account Type", PayrollJournalLine."Account Type"::"G/L Account");
        end
        else begin
            if not (PayrollJournalLine."Account Type" in [PayrollJournalLine."Account Type"::"Bank Account", PayrollJournalLine."Account Type"::"G/L Account", PayrollJournalLine."Account Type"::Customer, PayrollJournalLine."Account Type"::Vendor]) then
                PayrollJournalLine.FieldError("Account Type");
            if PayrollJournalLine."Account Type" = PayrollJournalLine."Account Type"::"Bank Account" then
                PayrollJournalLine.TestField("Document Type", PayrollJournalLine."Document Type"::Payment);
        end;
        PayrollJournalLine.TestField("Document No.");
        PayrollJournalLine.TestField(Description);
        PayrollJournalLine.TestField(Amount);
        PayrollJournalLine.TestField("Shortcut Dimension 1 Code");
        //TestField("Shortcut Dimension 2 Code");
        PayrollJournalLine.TestField("Source Code");
        PayrollJournalLine.TestField("Document Date");
        PayrollJournalLine.TestField("Posting No. Series");
        PayrollJournalLine.TestField("From Date");
        PayrollJournalLine.TestField("To Date");
        PayrollJournalLine.TestField(Month);
        PayrollJournalLine.TestField("From Date (B.S)");
        PayrollJournalLine.TestField("To Date (B.S)");
        PayrollJournalLine.TestField("Nepali Month");
        PayrollJournalLine.TestField("Nepali Year");
        PayrollJournalLine.TestField("Pay Cycle Code");
        PayrollJournalLine.TestField("Pay Cycle Term");
        PayrollJournalLine.TestField("Pay Cycle Period");
        if PayrollJournalLine."Attribute Code" <> '' then begin
            PayrollJournalLine.TestField("Attribute Type");
        end;
        PayrollJournalLine.TestField("Dimension Set ID");
        PayrollJournalLine.TestField("Pay Period Start Date");
        PayrollJournalLine.TestField("Pay Period End Date");
        PayrollJournalLine.TestField("Employee No.");
        PayrollJournalLine.TestField("Assigned User ID");

        PayrollJournalLine.CheckDocNoBasedOnNoSeries(LastDocNo, PayrollJnlBatch."No. Series", NoSeriesCodeunit);
        if PayrollJournalLine."Posting No. Series" <> '' then
            PayrollJournalLine.TestField("Posting No. Series", PayrollJnlBatch."Posting No. Series");
    end;

    local procedure CheckDocumentNo(var PayrollJournalLine: Record "Payroll Journal Line")
    begin
        NoSeries.Get(PayrollJournalLine."Posting No. Series");
        LastDocNo := PayrollJournalLine."Document No.";
        if PostingNo = '' then begin
            PostingNo :=
              NoSeries2.GetNextNo(PayrollJournalLine."Posting No. Series", PayrollJournalLine."Posting Date", true);
        end;
        PayrollJournalLine."Posting No." := PostingNo;
        PayrollJournalLine.Modify;
    end;

    procedure SetPost_Print()
    begin
        PostPrint := true;
    end;
}
