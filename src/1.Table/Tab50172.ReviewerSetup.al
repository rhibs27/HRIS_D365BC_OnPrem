table 50172 "Reviewer Setup"
{
    Caption = 'Reviewer Setup';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(3; "Is Self Review"; Boolean)
        {
            Caption = 'Is Self Review';

            trigger OnValidate()
            var
                ReviewerSetup: Record "Reviewer Setup";
            begin
                if "Is Self Review" and "Is Group Based" then
                    Error('A record cannot be both Self Review and Group Based.');
                if "Is Self Review" then begin
                    ReviewerSetup.Reset();
                    ReviewerSetup.SetRange("Is Self Review", true);
                    ReviewerSetup.SetFilter(Code, '<>%1', Code);
                    if ReviewerSetup.FindFirst() then
                        Error('Only one Self Review is allowed.');
                end;
            end;
        }

        field(4; "Is Group Based"; Boolean)
        {
            Caption = 'Is Group Based';

            trigger OnValidate()
            var
                ReviewerSetup: Record "Reviewer Setup";
            begin
                if "Is Group Based" and "Is Self Review" then
                    Error('A record cannot be both Group Based and Self Review.');
                if "Is Group Based" then begin
                    ReviewerSetup.Reset();
                    ReviewerSetup.SetRange("Is Group Based", true);
                    ReviewerSetup.SetFilter(Code, '<>%1', Code);
                    if ReviewerSetup.FindFirst() then
                        Error('Only one Group Based review is allowed.');
                end;
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
}
