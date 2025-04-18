table 50139 Province
{
    Caption = 'Province';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "Blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
