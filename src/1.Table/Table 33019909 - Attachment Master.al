table 33019909 "Attachment Master"
{
    DrillDownPageId = "Attachment Master";
    LookupPageId = "Attachment Master";
    DataClassification = CustomerContent;

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
