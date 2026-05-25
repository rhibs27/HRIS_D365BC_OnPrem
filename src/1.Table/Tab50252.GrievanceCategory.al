table 50252 "Grievance Category"
{
    Caption = 'Grievance Category';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Anonymous Filing"; Boolean)
        {
            Caption = 'Anonymous Filing';
        }
        field(4; "Email IDs"; Text[500])
        {
            Caption = 'Email IDs';
            trigger OnLookup()
            begin
                Validate("Email IDs", GrievanceMgt.LookupEmployee())
            end;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    var
        GrievanceMgt: Codeunit "Grievance Mgt";
}
