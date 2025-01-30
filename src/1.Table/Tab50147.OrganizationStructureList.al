table 50147 "Organization Structure List"
{
    Caption = 'Organization Structure List';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum "Organization Structure list")
        {
            Caption = 'Type';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
    }
    keys
    {
        key(PK; "Type", Code)
        {
            Clustered = true;
        }
    }
}
