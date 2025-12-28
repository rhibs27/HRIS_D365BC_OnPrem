table 50166 "Det Salary Deduction Entries"
{
    Caption = 'Detailed Salary Deduction Entries';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Det Salary Deduction Entries";
    LookupPageId = "Det Salary Deduction Entries";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(4; "Deduction Date"; Date)
        {
            Caption = 'Deduction Date';
            DataClassification = CustomerContent;
        }
        field(5; "Deduction Type"; Enum "Attribute Deduction Type")
        {
            Caption = 'Deduction Type';
            DataClassification = CustomerContent;
        }
        field(6; "Pay Cycle Term"; Code[20])
        {
            Caption = 'Pay Cycle Term';
            DataClassification = CustomerContent;
        }
        field(7; "Pay Cycle Period"; Integer)
        {
            Caption = 'Pay Cycle Period';
            DataClassification = CustomerContent;
        }
        field(8; "Attribute Type"; Enum "Payroll Type")
        {
            Caption = 'Attribute Type';
            DataClassification = CustomerContent;
        }
        field(9; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            DataClassification = CustomerContent;
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(11; "Pay Cycle Code"; Code[20])
        {
            Caption = 'Pay Cycle Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key1; "Employee No.") { }
        key(key2; "Employee No.", "Deduction Date") { }
    }
}
