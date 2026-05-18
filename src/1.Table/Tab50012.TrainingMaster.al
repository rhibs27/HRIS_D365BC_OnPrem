table 50012 "Training Master"
{
    DrillDownPageId = "Training Master";
    LookupPageId = "Training Master";
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20]) { }
        field(2; Description; Text[250]) { }
        field(3; "Master Type"; Enum "Training Setup Type") { }
        field(4; "Training Category"; Code[20])
        {
            TableRelation = if ("Master Type" = filter("Training Setup Type"::" "))
                            "Training Master".Code where("Master Type" = filter("Training Setup Type"::"Training Category"));
        }
    }

    keys
    {
        key(Key1; Code) { }
    }

    fieldgroups { }
}
