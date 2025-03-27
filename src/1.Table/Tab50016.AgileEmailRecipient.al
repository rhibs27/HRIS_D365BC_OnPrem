table 50016 "Agile Email Recipient"
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
        field(4; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";
        }
        field(5; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(6; "Recipient Type"; Enum "Email Recipient Type")
        {

        }
        field(7; Region; Enum "Region Direction")
        {

        }
        field(8; Method; Enum "Email Recipient Type")
        {
        }
        field(9; "Province Code"; Code[10])
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
