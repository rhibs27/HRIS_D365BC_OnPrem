page 50187 "Qualification Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'qualification';
    DelayedInsert = true;
    EntityName = 'qualification';
    EntitySetName = 'qualificationEntity';
    PageType = API;
    SourceTable = Qualification;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(code; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
            }
        }
    }
}
