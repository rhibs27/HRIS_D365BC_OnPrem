table 50126 Municipality
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Municipality Name"; Text[50]) { }
        field(3; "District Name"; Text[50])
        {
            Caption = 'District Name';
            TableRelation = District."District Name";
        }
        field(4; "District Name (In Nepali)"; Text[50])
        {
            Caption = 'District Name (In Nepali) ';
            TableRelation = District."District Name";
        }

        field(5; "No of ward"; Integer)
        {
            Caption = 'No of ward';
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
