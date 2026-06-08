table 50016 "Email Template Recipient"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Email Template Code"; Code[20])
        {
            TableRelation = "Email Template";
        }
        field(2; "Email Recipients"; Text[100]) { }
        field(3; "Line No."; Integer) { }
        field(6; "Recipient Type"; Enum "Email Recipient Type") { }
        field(8; Method; Enum "Email Recipient Type") { }
        field(9; "Province Code"; Code[20])
        {
            TableRelation = Province;

            trigger OnValidate()
            begin
            end;
        }
    }

    keys
    {
        key(Key1; "Email Template Code", "Line No.") { }
    }

    fieldgroups { }
}
