table 50130 "KPI Category"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "Category Code"; Code[20]) { }
        field(2; "Category Description"; Text[50]) { }
    }

    keys
    {
        key(Key1; "Category Code") { }
    }

    fieldgroups { }
}
