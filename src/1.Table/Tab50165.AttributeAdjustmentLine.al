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
                AttributeAdj: Record "Attribute Adjustment Header";
            begin
                if EmployeeRec.Get("Employee No.") then begin
                    "Employee Name" := EmployeeRec.FullName();
                    AttributeAdj.Get("Document No.");
                    Validate("Adjustment Type", AttributeAdj."Adjustment Type");
                end else begin
                    Clear("Employee Name");
                    Clear("Adjustment Type");
                end;
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

            trigger OnValidate()
            var
                AttributeAdj: Record "Attribute Adjustment Header";
            begin
                AttributeAdj.Get("Document No.");
                TestField("Adjustment Type", AttributeAdj."Adjustment Type");
            end;
        }
        field(6; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            TableRelation = "Payroll Attributes"."Code";
            trigger OnValidate()
            var
                PayrollAttrUsage: Record "Payroll Attributes Usage";
            begin
                if PayrollAttrUsage.Get("Attribute Code", "Employee No.") then
                    Validate("Old Amount", PayrollAttrUsage.Amount);
            end;
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
        field(11; "System Calculated"; Boolean)
        {
            DataClassification = ToBeClassified;
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
