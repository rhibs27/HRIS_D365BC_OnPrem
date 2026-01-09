table 50168 "Temp Assignment Memo Ledger"
{
    Caption = 'Temp Assignment Memo Ledger';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then
                    "Employee Name" := Employee.FullName()
                else
                    "Employee Name" := '';
            end;
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(7; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(8; "Substituted Employee No."; Code[20])
        {
            Caption = 'Substituted Employee No.';
        }
        field(9; "Payroll Document No."; Code[20])
        {
            Caption = 'Applied Document No.';
        }
        field(10; "Employee Activity Type"; Enum "Employee Activity Type")
        {
            Caption = 'Employee Activity Type';
        }
        field(11; "Payroll Attribute Code"; Code[20])
        {
            Caption = 'Payroll Attribute Code';
        }
        field(12; "Valid From Date"; Date)
        {
            Caption = 'Valid From Date';
        }
        field(13; "Valid To Date"; Date)
        {
            Caption = 'Valid To Date';
        }
        field(14; Claimed; Boolean)
        {
            Caption = 'Claimed';
        }
        field(15; "Claimed Doc No."; Code[20])
        {
            Caption = 'Claimed Doc No.';
        }
        field(16; Panel; Enum Panel) { }
        field(17; "ATM Site"; Enum "ATM Site") { }
        field(18; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift";
        }
        field(19; "Payroll Posted"; Boolean)
        {
            Caption = 'Payroll Posted';
            editable = false;
        }
        field(20; "Vault Name"; Code[100])
        {
            Caption = 'Vault Name';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Employee No.", "Document No.", "Posting Date", "Employee Activity Type")
        {
        }
        key(key3; "Payroll Document No.", "Substituted Employee No.", Open)
        {
        }
    }
}
