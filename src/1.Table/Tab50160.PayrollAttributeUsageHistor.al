table 50160 "Payroll Attri Usage History"
{
    Caption = 'Payroll Attri Usage History';
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
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
        }
        field(6; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(7; "Entry Date"; DateTime)
        {
            Caption = 'Entry Date';
        }
        field(8; Reversed; Boolean)
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
        PayrollAttrUsageHistor: Record "Payroll Attri Usage History";
    begin
        if PayrollAttrUsageHistor.FindLast() then
            "Entry No." := PayrollAttrUsageHistor."Entry No." + 1
        else
            "Entry No." := 1;
    end;
}
