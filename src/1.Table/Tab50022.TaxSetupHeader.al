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
        // field(3; "Effective from"; Date)
        // {
        // }
        // field(4; "Effective to"; Date)
        // {
        // }
        field(5; "Special Tax Exempt %"; Decimal)
        {
        }
        field(6; "Marital Status"; Enum "Marital Status")
        {

        }
        field(7; Gender; Enum "Employee Gender")
        {

        }
        field(8; Pension; Boolean) { }
        field(9; "Special Red. % on 1st Slab"; Decimal)
        {
            Caption = 'Special Reduction % on First Slab';
        }
        field(10; SSF; Boolean) { }
        field(11; "Pension Reduction % 1st Slab"; Decimal) { }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
