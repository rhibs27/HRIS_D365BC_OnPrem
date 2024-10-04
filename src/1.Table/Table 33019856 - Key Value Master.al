table 33019856 "Key Value Master"
{
    DrillDownPageId = "Key Value Master List";
    LookupPageId = "Key Value Master List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[50]) { }
        field(2; Description; Text[250]) { }
        field(3; Type; Option)
        {
            OptionCaption = ' ,KRA Category,Key Result Area';
            OptionMembers = " ","KRA Category","Key Result Area";
        }
    }

    keys
    {
        key(Key1; "Code", Type) { }
    }

    fieldgroups { }
}
