table 50031 "Employee Ledger Entry PRM"
{

    DrillDownPageId = "Employee Ledger Entries PRM";
    LookupPageId = "Employee Ledger Entries PRM";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Document Type"; Enum "Employee Document Type")
        {
        }
        field(5; "Document No."; Code[20]) { }
        field(6; Description; Text[50]) { }
        field(7; Amount; Decimal)
        {
            CalcFormula = sum("Detailed Employee Ledg. En PRM".Amount where("Employee No." = field("Employee No."),
                                                                             "Employee Ledger Entry No." = field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Source Code"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(9; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(10; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Period"."Pay Cycle Term" where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(11; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(12; "Pay Period Start Date"; Date) { }
        field(13; "Pay Period End Date"; Date) { }
        field(14; Open; Boolean) { }
        field(15; "Creation Date"; Date) { }
        field(16; "User ID"; Code[50]) { }
        field(17; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(18; "Present Days"; Decimal) { }
        field(19; "Week off Days"; Decimal) { }
        field(20; "Leave Days"; Decimal) { }
        field(21; "Absent Days"; Decimal) { }
        field(22; "Total Days"; Decimal) { }
        field(23; "Tour Days"; Decimal) { }
        field(24; "Half Days"; Decimal) { }
        field(25; "Late Days"; Decimal) { }
        field(26; "Overtime Days"; Decimal) { }
        field(27; "Late Rate"; Decimal) { }
        field(28; "OT Hrs (30MIN)"; Decimal)
        {
            Caption = 'OT Hrs (30MIN)';
            Editable = false;
        }
        field(29; "G/L Document No"; Code[20]) { }
        field(30; "Employee Name"; Text[250]) { }
        field(31; Narration; Text[250]) { }
        field(32; "Posted Payroll Plan No."; Code[20])
        {
            TableRelation = "Posted Payroll Header";
        }
        field(33; "Posted Payroll Plan Line No."; Integer) { }
        field(34; "Payroll Attribute Code"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Entry No.") { }
        key(Key2; "Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period") { }
    }

    fieldgroups { }

    procedure CopyFromPayrollJnlLine(var PayrollJournalLine: Record "Payroll Journal Line" temporary)
    begin
        "Employee No." := PayrollJournalLine."Employee No.";
        "Posting Date" := PayrollJournalLine."Posting Date";
        "Document Type" := PayrollJournalLine."Document Type";
        "Document No." := PayrollJournalLine."Document No.";
        "Source Code" := PayrollJournalLine."Source Code";
        "Pay Cycle Code" := PayrollJournalLine."Pay Cycle Code";
        "Pay Cycle Term" := PayrollJournalLine."Pay Cycle Term";
        "Pay Cycle Period" := PayrollJournalLine."Pay Cycle Period";
        "Pay Period Start Date" := PayrollJournalLine."Pay Period Start Date";
        "Pay Period End Date" := PayrollJournalLine."Pay Period End Date";
        "Present Days" := PayrollJournalLine."Present Days";
        "Week off Days" := PayrollJournalLine."Week off Days";
        "Leave Days" := PayrollJournalLine."Leave Days";
        "Absent Days" := PayrollJournalLine."Absent Days";
        "Total Days" := PayrollJournalLine."Total Days";
        "Tour Days" := PayrollJournalLine."Tour Days";
        "Half Days" := PayrollJournalLine."Half Days";
        "Late Days" := PayrollJournalLine."Late Days";
        "Overtime Days" := PayrollJournalLine."OT Days";
        "OT Hrs (30MIN)" := PayrollJournalLine."OT Hrs (30MIN)";
        "Late Rate" := PayrollJournalLine."Late Rate";
        Description := StrSubstNo('Payroll Plan %1, %2, %3', "Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period");
        "G/L Document No" := PayrollJournalLine."Posting No.";
        Narration := PayrollJournalLine.Narration;
        "Employee Name" := PayrollJournalLine."Employee Name";
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "G/L Document No");
        NavigateForm.Run;
    end;
}
