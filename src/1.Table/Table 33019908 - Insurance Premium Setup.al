table 33019908 "Insurance Premium Setup"
{
    Caption = 'Insurance Premium Setup';
    DrillDownPageId = "Insurance Premium";
    LookupPageId = "Insurance Premium";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Insurance Company"; Option)
        {
            OptionCaption = ' ,NEPAL Life Insurance,LIC Nepal,National Life Insurance,Surya Life Insurance';
            OptionMembers = " ","NEPAL Life Insurance","LIC Nepal","National Life Insurance","Surya Life Insurance";
        }
        field(2; Age; Decimal) { }
        field(3; Period; Decimal) { }
        field(4; Value; Decimal)
        {
            DecimalPlaces = 5 : 5;
        }
    }

    keys
    {
        key(Key1; "Insurance Company", Age, Period) { }
    }

    fieldgroups { }
}
