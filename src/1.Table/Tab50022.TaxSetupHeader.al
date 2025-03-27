table 50022 "Tax Setup Header"
{
    DrillDownPageId = "Tax Setup List";
    LookupPageId = "Tax Setup List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Effective from"; Date)
        {
        }
        field(4; "Effective to"; Date)
        {
        }
        field(5; "Special Tax Exempt %"; Decimal)
        {
        }
        field(6; "Marital Status"; Enum "Marital Status")
        {

        }
        field(7; Gender; Enum "Employee Gender")
        {

        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
