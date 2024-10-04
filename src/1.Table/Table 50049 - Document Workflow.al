table 50049 "Document Workflow"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Employee Name" := '';
                if "Employee No." <> '' then begin
                    Employee.Get("Employee No.");
                    "Employee Name" := Employee."Full Name";
                end;
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Heading Type"; Enum "Document Heading Type")
        {

        }
    }

    keys
    {
        key(Key1; "Primary Key", "Line No.") { }
    }

    fieldgroups { }

    var
        Employee: Record Employee;
}
