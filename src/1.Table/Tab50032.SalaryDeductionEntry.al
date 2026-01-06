table 50032 "Salary Deduction Entry"
{
    Caption = 'Salary Deduction Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(3; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
        }
        field(4; "Deduction Type"; Enum "Attribute Deduction Type")
        {
            Caption = 'Deduction Type';
        }
        field(5; "Deduction Date"; Date)
        {
            Caption = 'Deduction Date';
        }
        field(6; "Pay Cycle Code"; Code[20])
        {
            Caption = 'Pay Cycle Code';
            TableRelation = "Pay Cycle".Code;
        }
        field(7; "Pay Cycle Term"; Code[20])
        {
            Caption = 'Pay Cycle Term';
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(8; "Pay Cycle Period"; Integer)
        {
            Caption = 'Pay Cycle Period';
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"), "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(9; "Amount"; Decimal)
        {
            Caption = 'Amount';
            CalcFormula = sum("Det Salary Deduction Entries".Amount where("Deduction Entry No." = field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Payroll Posted"; Boolean)
        {
            Caption = 'Payroll Posted';
        }
        field(11; "Payroll Document No."; Code[20])
        {
            Caption = 'Payroll Document No.';
        }
        field(12; Reversed; Boolean)
        {
            Caption = 'Reversed';
            Editable = false;
        }
        field(13; "Reversal of Entry No."; Integer)
        {
            Caption = 'Reversal of Entry No.';
        }
        field(14; "Attendance Document No"; Code[20])
        {
            Caption = 'Attendance Document No';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        DetSalaryDeductionEntry: Record "Det Salary Deduction Entries";
    begin

        DetSalaryDeductionEntry.SetRange("Employee No.", "Employee No.");
        DetSalaryDeductionEntry.SetRange("Deduction Date", "Deduction Date");
        DetSalaryDeductionEntry.DeleteAll();
    end;
}
