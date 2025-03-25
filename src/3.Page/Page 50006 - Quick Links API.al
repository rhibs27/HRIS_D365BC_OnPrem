page 50006 "Quick Links API"
{
    EntityName = 'quickLinkEntity';
    EntitySetName = 'quickLinkEntities';
    PageType = API;
    APIPublisher = 'Agile';
    APIGroup = 'HRMS';
    DelayedInsert = true;
    APIVersion = 'v2.0';
    SourceTable = "Quick Links";

    layout
    {
        area(Content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(linkCode; Rec."Link Code")
                {
                    Caption = 'Link Code';
                }
                field(Description; Rec.Description) { }
                field(linkURL; Rec."Link URL")
                {
                    Caption = 'Link URL';
                }
            }
        }
    }

    actions { }
}
