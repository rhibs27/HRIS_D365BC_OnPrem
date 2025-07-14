table 50032 "Detailed Employee Ledg. En PRM"
{
    DrillDownPageId = "Detailed Emp. Ledg. en PRM";
    LookupPageId = "Detailed Emp. Ledg. en PRM";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; "Employee Ledger Entry No."; Integer) { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(4; "Posting Date"; Date)
        {
        }
        field(5; "Document Type"; Enum "Employee Document Type")
        {
        }
        field(6; "Document No."; Code[20])
        {
        }
        field(7; Description; Text[50])
        {
        }
        field(8; Amount; Decimal)
        {
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(11; "Source Code"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(12; "Payroll Attribute Code"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(13; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(14; "Pay Cycle Term"; Code[20])
        {
            Description = '*';
            TableRelation = "Pay Cycle Period"."Pay Cycle Term" where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(15; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(16; "Pay Period Start Date"; Date)
        {
        }
        field(17; "Pay Period End Date"; Date)
        {
        }
        field(18; "Attribute Type"; Enum "Attribute Type")
        {

        }
        field(19; "Attribute Sub Type"; Enum "Payroll SubType")
        {

        }
        field(20; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(21; "Creation Date"; Date) { }
        field(22; "User ID"; Code[50]) { }
        field(23; Reversed; Boolean) { }
        field(24; "G/L Document No"; Code[20]) { }
        field(25; "Non-Taxable"; Boolean) { }
        field(26; "Posted Payroll Plan No."; Code[20])
        {
            TableRelation = "Posted Payroll Header";
        }
        field(27; "Posted Payroll Plan Line No."; Integer) { }
        field(28; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(29; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(30; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(31; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }
        field(32; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
        }
        field(33; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    procedure CopyFromPayrollJnlLine(var PayrollJournalLine: Record "Payroll Journal Line" temporary)
    begin
        "Employee No." := PayrollJournalLine."Employee No.";
        "Posting Date" := PayrollJournalLine."Posting Date";
        "Document Type" := PayrollJournalLine."Document Type";
        "Document No." := PayrollJournalLine."Document No.";
        Description := PayrollJournalLine.Description;
        Amount := PayrollJournalLine.Amount;
        "Source Code" := PayrollJournalLine."Source Code";
        "Payroll Attribute Code" := PayrollJournalLine."Attribute Code";
        "Pay Cycle Code" := PayrollJournalLine."Pay Cycle Code";
        "Pay Cycle Term" := PayrollJournalLine."Pay Cycle Term";
        "Pay Cycle Period" := PayrollJournalLine."Pay Cycle Period";
        "Pay Period Start Date" := PayrollJournalLine."Pay Period Start Date";
        "Pay Period End Date" := PayrollJournalLine."Pay Period End Date";
        "Attribute Type" := PayrollJournalLine."Attribute Type";
        "Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type";
        "G/L Document No" := PayrollJournalLine."Posting No.";
        "Non-Taxable" := PayrollJournalLine."Non-Taxable";

        "Dimension Set ID" := PayrollJournalLine."Dimension Set ID";
        "Shortcut Dimension 1 Code" := PayrollJournalLine."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := PayrollJournalLine."Shortcut Dimension 2 Code";
        "Shortcut Dimension 3 Code" := PayrollJournalLine."Shortcut Dimension 3 Code";
        "Shortcut Dimension 4 Code" := PayrollJournalLine."Shortcut Dimension 4 Code";
        "Shortcut Dimension 5 Code" := PayrollJournalLine."Shortcut Dimension 5 Code";
        "Shortcut Dimension 6 Code" := PayrollJournalLine."Shortcut Dimension 6 Code";
        "Shortcut Dimension 7 Code" := PayrollJournalLine."Shortcut Dimension 7 Code";
        "Shortcut Dimension 8 Code" := PayrollJournalLine."Shortcut Dimension 8 Code";
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "Document No.");
        NavigateForm.Run;
    end;
}
