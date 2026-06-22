table 50108 "Insurance Premium Setup"
{
    Caption = 'Insurance Premium Setup';
    DrillDownPageId = "Insurance Premium";
    LookupPageId = "Insurance Premium";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Insurance Company"; Code[20])
        {
            TableRelation = "Insurance Company";
        }
        field(2; Age; Decimal) { }
        field(3; Period; Decimal) { }
        field(4; Value; Decimal)
        {
            DecimalPlaces = 5 : 5;
        }
    }

    keys
    {
        key(Key1; "Insurance Company", Age, Period) { }
    }

    fieldgroups { }
}
