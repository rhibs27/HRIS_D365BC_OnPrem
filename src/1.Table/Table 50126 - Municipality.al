table 50126 Municipality
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[50]) { }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
