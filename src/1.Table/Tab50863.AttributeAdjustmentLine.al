table 50165 "Attribute Adjustment Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Attribute Adjustment Header"."Document No.";
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                EmployeeRec: Record Employee;
            begin
                if EmployeeRec.Get("Employee No.") then
                    "Employee Name" := EmployeeRec.FullName()
                else
                    Clear("Employee Name");
            end;
        }

        field(4; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }

        field(5; "Adjustment Type"; Enum "Employee Activity Type")
        {
            Caption = 'Adjustment Type';
            ValuesAllowed = " ", Promotion, Confirmation, "Employee Transfer";
        }

        field(6; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            TableRelation = "Payroll Attributes"."Code";
        }

        field(7; "Old Amount"; Decimal)
        {
            Caption = 'Old Amount';
        }

        field(8; "New Amount"; Decimal)
        {
            Caption = 'New Amount';
        }

        field(9; "Effective Start Date"; Date)
        {
            Caption = 'Effective Start Date';
        }

        field(10; "Effective End Date"; Date)
        {
            Caption = 'Effective End Date';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }

        key(Document; "Document No.") { }
        key(Line; "Line No.") { }
    }
}
