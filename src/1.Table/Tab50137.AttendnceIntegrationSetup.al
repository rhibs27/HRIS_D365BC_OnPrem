table 50137 "Attendnce Integration Setup"
{
    Caption = 'Attendnce Integration Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "User Name"; Code[50])
        {
            Caption = 'User Name';
            DataClassification = ToBeClassified;
        }
        field(3; Password; Text[100])
        {
            Caption = 'Password';
            DataClassification = ToBeClassified;
        }
        field(4; "Base URL"; Text[250])
        {
            Caption = 'URL';
            DataClassification = ToBeClassified;
        }
        field(5; "Company Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }

        //Company setup
        field(10; "Branch Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Department Code"; code[20])
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
