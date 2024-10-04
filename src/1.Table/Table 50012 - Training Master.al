table 50012 "Training Master"
{
    // version NIC Asia1.00,Training

    DrillDownPageId = "Training Master";
    LookupPageId = "Training Master";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; Description; Text[250]) { }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }
}
