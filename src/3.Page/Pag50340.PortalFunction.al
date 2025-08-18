page 50340 "Portal Function"
{
    PageType = List;
    Caption = 'portalFunctions';
    SourceTable = "Portal Function";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(PrimaryKey; Rec.PrimaryKey)
                { ApplicationArea = all; }
            }
        }
    }
}
