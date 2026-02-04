table 50173 "Appraisal Setup"
{
    DrillDownPageId = "Appraisal Setup";
    LookupPageId = "Appraisal Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[50]) { }
        field(2; Description; Text[250]) { }
        field(3; Type; Enum "Key Value Master Type")
        {

        }
    }
    keys
    {
        key(Key1; "Code", Type) { }
    }
}