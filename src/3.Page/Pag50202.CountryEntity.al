page 50202 "Country Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'country';
    DelayedInsert = true;
    EntityName = 'country';
    EntitySetName = 'countries';
    PageType = API;
    SourceTable = "Country/Region";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(isSAARC; Rec."Is SAARC")
                {
                    Caption = 'Is SAARC';
                }
            }
        }
    }
}
