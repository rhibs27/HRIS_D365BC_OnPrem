page 50139 "Email Template Messages"
{
    // version NP16.04

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Agile Email Message";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Body Message"; Rec."Body Message")
                {
                    ToolTip = 'Specifies the value of the Body Message field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
