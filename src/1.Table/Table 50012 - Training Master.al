table 50012 "Training Master"
{
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
