table 50082 "Rating Scale"
{
    // version HRM1.00
    Caption = 'Rating Scale';
    DrillDownPageId = "Rating Scale";
    LookupPageId = "Rating Scale";
    DataClassification = CustomerContent;

    fields
    {
        field(1; Type; Enum "Rating Scale Type") { }
        field(2; "Code"; Decimal) { }
        field(3; Remarks; Text[30]) { }
        field(4; Description; Text[250]) { }
    }

    keys
    {
        key(Key1; Type, "Code") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Type, "Code", Remarks, Description) { }
    }
}
