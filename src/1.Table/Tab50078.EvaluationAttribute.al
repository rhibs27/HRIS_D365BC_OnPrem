table 50078 "Evaluation Attribute"
{
    DataClassification = CustomerContent;
    // version HRM1.00
    fields
    {
        field(1; "Attribute Type"; Enum "Evaluation Attribute Type") { }
        field(2; "Code"; Code[20]) { }
        field(3; Description; Text[250]) { }
        field(4; "Description 2"; Text[250]) { }
        field(5; "Job Title Code"; Code[20])
        {
            TableRelation = "Job Title";
        }
        field(6; "Job Level Code"; Code[20])
        {
            TableRelation = "Salary Level".Code;
        }
        field(7; "Full Marks"; Decimal) { }
        field(8; PassMarks; Decimal) { }
        field(9; Remarks; Text[250]) { }
        field(10; "Is Remarks"; Boolean) { }
        field(11; "Is Remarks Options"; Boolean)
        {
            trigger OnValidate()
            begin
                TestField("Is Remarks");
            end;
        }
    }

    keys
    {
        key(Key1; "Attribute Type", "Code", "Job Title Code", "Job Level Code") { }
    }

    fieldgroups { }
}
