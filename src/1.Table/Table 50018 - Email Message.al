table 50018 "Agile Email Message"
{
    DataClassification = CustomerContent;
    // version NP16.04

    fields
    {
        field(1; "Template Code"; Code[20])
        {
            TableRelation = "Email Template";
        }
        field(2; "Line No."; Integer) { }
        field(3; "Body Message"; Text[250])
        {
            trigger OnValidate()
            begin
                "New Line" := false;
            end;
        }
        field(4; "Parameter Table ID"; Integer)
        {
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(5; "Parameter Field ID"; Integer)
        {
            TableRelation = Field."No." where(TableNo = field("Parameter Table ID"));
        }
        field(6; "New Line"; Boolean)
        {
            trigger OnValidate()
            begin
                if "New Line" then
                    "Body Message" := '';
            end;
        }
        field(7; Type; Enum "Email Message Type")
        {
        }
    }

    keys
    {
        key(Key1; "Template Code", "Line No.") { }
    }

    fieldgroups { }
}
