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
        field(7; "Pay Cycle Term"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Pay Cycle Term';
            TableRelation = "Pay Cycle Term".Term;
        }
    }

    keys
    {
        key(Key1; "Code", "Pay Cycle Term", "Line No.") { }
    }
    fieldgroups { }
}
