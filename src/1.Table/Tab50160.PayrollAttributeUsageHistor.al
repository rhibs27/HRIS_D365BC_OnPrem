table 50160 "Attributes Usage History"
{
    Caption = 'Payroll Attributes Usage History';
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
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Employee No.")));
            Editable = false;
        }
        field(4; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            TableRelation = "Payroll Attributes";
        }
        field(5; "Old Amount"; Decimal)
        {
            Caption = 'Old Amount';
            DecimalPlaces = 2 : 2;
        }
        field(6; "New Amount"; Decimal)
        {
            Caption = 'New Amount';
            DecimalPlaces = 2 : 2;
        }
        field(7; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(8; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
        }
        field(9; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        PayrollAttrUsageHistory: Record "Attributes Usage History";
    begin
        if PayrollAttrUsageHistory.FindLast() then
            "Entry No." := PayrollAttrUsageHistory."Entry No." + 1
        else
            "Entry No." := 1;

        "Entry Date" := Today;
    end;
}
