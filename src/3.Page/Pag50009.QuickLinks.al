page 50009 "Quick Links"
{
    Caption = 'Quick Links';
    PageType = List;
    SourceTable = "Quick Links";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Link Code"; Rec."Link Code")
                {
                    ToolTip = 'Specifies the value of the Link Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Link URL"; Rec."Link URL")
                {
                    ToolTip = 'Specifies the value of the Link URL field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
