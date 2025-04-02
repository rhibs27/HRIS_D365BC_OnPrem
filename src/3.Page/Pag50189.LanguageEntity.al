page 50189 "Language Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'languageEntity';
    DelayedInsert = true;
    EntityName = 'language';
    EntitySetName = 'languageEntity';
    PageType = API;
    SourceTable = Language;

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
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
            }
        }
    }
}
