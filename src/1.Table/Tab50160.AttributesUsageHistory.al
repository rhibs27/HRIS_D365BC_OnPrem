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
        field(7; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(8; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
        }
        field(9; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(10; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(11; "Source Document Type"; Enum "Employee Activity Type")
        {
            Caption = 'Source Document Type';
        }
        field(12; "Source Document No."; Code[20])
        {
            Caption = 'Source Document No.';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(EmpAttrDate; "Employee No.", "Attribute Code", "Start Date")
        {
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
