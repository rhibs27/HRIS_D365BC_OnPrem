table 50139 Province
{
    Caption = 'Province';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Sol ID"; Code[20]) { DataClassification = ToBeClassified; }
        field(4; "Posting Region"; Enum Region)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Inside/Outside Valley"; Enum "Outside/Inside Valley")
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Reporting Category"; Code[10])
        {
            TableRelation = "Reporting Category";
            DataClassification = ToBeClassified;
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
