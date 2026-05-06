table 50034 "Posted Payroll Header"
{
    // version PRM19.01.01

    DrillDownPageId = "Posted Payroll Plan List";
    LookupPageId = "Posted Payroll Plan List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; "From Date"; Date) { }
        field(3; "To Date"; Date) { }
        field(4; Month; Enum "English Month")
        {
            Editable = false;
        }
        field(5; Remarks; Text[250]) { }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(8; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(9; "Pre-Assigned No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Document Date"; Date) { }
        field(11; "Posting Date"; Date) { }
        field(12; Status; enum "Approval Status")
        {
            Editable = false;
        }
        field(13; "Posting No."; Code[20]) { }
        field(14; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; "Posting Description"; Text[50]) { }
        field(16; "Assigned User ID"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(17; "From Date (B.S)"; Code[20]) { }
        field(18; "To Date (B.S)"; Code[20]) { }
        field(19; "Nepali Month"; Enum "Nepali Month") { }
        field(20; "Nepali Year"; Integer) { }
        field(21; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(22; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(23; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"), "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(24; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(25; "Total Net Payable"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Posted Payroll Line"."Net Pay" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; Irregular; Boolean) { }
        field(29; Type; Enum "Payroll Header Type") { }
        field(30; "Employee Type"; enum "Employee Type") { }
        field(31; "Gross Payment"; Boolean) { }
        field(32; Narration; Text[250])
        {
            Width = 100;
        }
        field(33; "Previous Year Payroll"; Boolean) { }
        field(34; "OverTime From"; Date) { }
        field(35; "OverTime To"; Date) { }
        field(36; "Encashment Code"; Code[20])
        {
            TableRelation = "OT Encashment Setup";
        }
        field(37; "Encashment Period"; Enum "Encashment Period") { }
        field(39; "Posted Date"; DateTime) { }
        field(40; "Approver Code"; Code[20])
        {
            Description = 'NIC';
        }
        field(41; "Approver Name"; Text[100])
        {
            Description = 'NIC';
        }
        field(42; "Approved Date"; Date)
        {
            Description = 'NIC';
        }
        // field(43; "Approval Status"; Enum "Approve Status")
        // {
        //     Description = 'NIC';

        // }
        field(44; "Posting User ID"; Code[50])
        {
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(45; "Pre-Assigned No."; Code[20]) { }
        field(46; Reversed; Boolean) { }
        field(501; "Optimal Deduction"; Boolean) { }
    }

    keys
    {
        key(Key1; "No.") { }
        key(Key2; "Posted Date") { }
    }

    fieldgroups { }

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;

    procedure SendEmail(DocumentNo: Code[20])
    var
        PostedPayrollHeaderRec: Record "Posted Payroll Header";
        MailForPayrollReport: Report "Mail for Payroll";
    begin
        PostedPayrollHeaderRec.Reset;
        PostedPayrollHeaderRec.SetRange("No.", DocumentNo);
        //Report.Run(Report::"Mail for Payroll", true, true, PostedPayrollHeaderRec);
        if PostedPayrollHeaderRec.FindFirst() then begin
            Clear(MailForPayrollReport);
            MailForPayrollReport.SetYearMonth(PostedPayrollHeaderRec."Nepali Year", PostedPayrollHeaderRec."Nepali Month");
            MailForPayrollReport.SetTableView(PostedPayrollHeaderRec);
            MailForPayrollReport.Run();
        end;
    end;

    procedure ReverseDocument(var PostedPayrollHeader: Record "Posted Payroll Header")
    var
        PostedPayrollLine: Record "Posted Payroll Line";
        ReversalEntry: Record "Reversal Entry";
        GLEntry: Record "G/L Entry";
        PreviousPayrollHdr: Record "Posted Payroll Header";
        PreviousPayrollLine: Record "Posted Payroll Line";
        PgSetup: Record "Payroll General Setup";
    begin
        if PostedPayrollHeader.FindFirst then begin
            PostedPayrollHeader.TestField(Reversed, false);
            PgSetup.get();
            if not PgSetup."Backdated Payroll Reverse" then begin
                PreviousPayrollHdr.Reset;
                PreviousPayrollHdr.SetFilter("Posted Date", '>%1', PostedPayrollHeader."Posted Date");
                PreviousPayrollHdr.SetRange("Nepali Year", "Nepali Year");
                PreviousPayrollHdr.SetRange(Reversed, false);
                if PreviousPayrollHdr.FindLast then
                    repeat
                        PostedPayrollLine.Reset;
                        PostedPayrollLine.SetLoadFields("Document No.", "Employee No.");

                        PostedPayrollLine.SetRange("Document No.", PostedPayrollHeader."No.");
                        if PostedPayrollLine.FindFirst then
                            repeat
                                PreviousPayrollLine.Reset;
                                PreviousPayrollLine.SetLoadFields("Document No.", "Employee No.");
                                PreviousPayrollLine.SetRange("Document No.", PreviousPayrollHdr."No.");
                                PreviousPayrollLine.SetRange("Employee No.", PostedPayrollLine."Employee No.");
                                if PreviousPayrollLine.FindFirst then
                                    Error('Please reverse payroll plan %1 before reversing this payroll.', PreviousPayrollHdr."No.");
                            until PostedPayrollLine.Next = 0;
                    until PreviousPayrollHdr.Next(-1) = 0;
            end;

            if not Confirm('Do you want to reverse Payroll %1?', false, PostedPayrollHeader."No.") then
                exit;
            GLEntry.Reset;
            GLEntry.SetRange("Document No.", PostedPayrollHeader."No.");
            if GLEntry.FindFirst then begin
                Clear(ReversalEntry);
                if GLEntry.Reversed then
                    ReversalEntry.AlreadyReversedEntry(TableCaption, GLEntry."Entry No.");
                GLEntry.TestField("Transaction No.");
                ReversalEntry.SetHideDialog(true);
                ReversalEntry.SetPayrollEntry(true);
                ReversalEntry.ReverseTransaction(GLEntry."Transaction No.")
            end;
            if GLEntry.FindFirst then
                if GLEntry.Reversed then begin
                    PostedPayrollLine.Reset;
                    PostedPayrollLine.SetRange("Document No.", PostedPayrollHeader."No.");
                    PostedPayrollLine.SetRange(Reversed, false);
                    if PostedPayrollLine.FindSet() then
                        repeat
                            PostedPayrollLine.ReverseLine(PostedPayrollLine);
                        until PostedPayrollLine.Next = 0;
                    PostedPayrollHeader.Reversed := true;
                    PostedPayrollHeader.Modify;
                    ReverseSourceDocumentsOnPayrollReverse(PostedPayrollHeader."No.");
                    Message('Payroll %1 has been reversed successfully.', PostedPayrollHeader."No.");
                end;
        end;
    end;

    procedure ReverseSourceDocumentsOnPayrollReverse(PostedDocNo: Code[20])
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        LeaveEarn: Record "Leave Earn";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        OvertimeLedgerEntry: Record "OverTime Ledger Entry";
        SalaryDeductionEntry: Record "Salary Deduction Entry";
        PGSetup: Record "Payroll General Setup";
    begin
        LeaveEarn.SetRange("Payroll Posted", true);
        LeaveEarn.SetRange("Payroll Document No", PostedDocNo);
        if LeaveEarn.FindSet() then
            repeat
                LeaveEarn."Payroll Posted" := false;
                LeaveEarn."Payroll Document No" := '';
                LeaveEarn.Modify();
            until LeaveEarn.Next() = 0;

        AllowanceAssignmentLine.SetRange("Payroll Doc No.", PostedDocNo);
        if AllowanceAssignmentLine.FindSet() then
            repeat
                AllowanceAssignmentLine.Validate("Payroll Doc No.", '');
                AllowanceAssignmentLine.Validate("Payroll Posted", false);
            until AllowanceAssignmentLine.Next() = 0;

        PGSetup.Get();
        if PGSetup."Get Amount From Assignment" then
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Allowance Assignment Memo")
        else
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Request Allowance");
        AssignmentMemoLedgerEntry.SetRange("Payroll Document No.", PostedDocNo);
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                AssignmentMemoLedgerEntry."Payroll Document No." := '';
                AssignmentMemoLedgerEntry.Open := true;
                AssignmentMemoLedgerEntry."Payroll Posted" := false;
                Clear(AssignmentMemoLedgerEntry."Payroll Posted Date");
                AssignmentMemoLedgerEntry."Payroll Posted Month" := AssignmentMemoLedgerEntry."Payroll Posted Month"::" ";
                AssignmentMemoLedgerEntry.Modify();
            until AssignmentMemoLedgerEntry.Next() = 0;

        OvertimeLedgerEntry.Reset();
        OvertimeLedgerEntry.SetRange("Payroll No.", PostedDocNo);
        if OvertimeLedgerEntry.FindSet() then
            repeat
                OvertimeLedgerEntry."Payroll No." := '';
                OvertimeLedgerEntry."OT Disbursed" := false;
                OvertimeLedgerEntry.Posted := false;
                OvertimeLedgerEntry.Modify();
            until OvertimeLedgerEntry.Next() = 0;

        SalaryDeductionEntry.Reset();
        SalaryDeductionEntry.SetRange("Payroll Document No.", "No.");
        SalaryDeductionEntry.ModifyAll("Payroll Posted", false);
        SalaryDeductionEntry.ModifyAll("Payroll Document No.", '');

        OnAfterUnmarkPostedPayrollDocNo(PostedDocNo);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUnmarkPostedPayrollDocNo(PostedDocNo: Code[20]);
    begin
        //Additional steps after unmarking payroll document number from related tables
    end;
}
