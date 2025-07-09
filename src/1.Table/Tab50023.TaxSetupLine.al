table 50023 "Tax Setup Line"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = "Tax Setup Header";
        }
        field(2; "Line No."; Integer) { }
        field(3; "Start Amount"; Decimal) { }
        field(4; "End Amount"; Decimal) { }
        field(5; "Tax Rate"; Decimal) { }
    }

    keys
    {
        key(Key1; "Code", "Line No.") { }
    }

    fieldgroups { }
}
