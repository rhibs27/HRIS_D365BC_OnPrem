table 50167 "Det Salary Deduction Entries"
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
            TableRelation = Employee;
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
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(7; "Pay Cycle Period"; Integer)
        {
            Caption = 'Pay Cycle Period';
            DataClassification = CustomerContent;
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"), "Pay Cycle Term" = field("Pay Cycle Term"));
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
            TableRelation = "Payroll Attributes".Code;
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
            TableRelation = "Pay Cycle".Code;
        }
        field(12; "Attendance No."; Code[20])
        {
            Caption = 'Attendance No.';
            DataClassification = CustomerContent;
        }
        field(13; "Salary Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Reversed By Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Old Deducation Date"; Date)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Specifies the old deduction date in case of reversed.';
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
