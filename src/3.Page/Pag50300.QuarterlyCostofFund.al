page 50398 "Quarterly Cost of Fund"
{
    Caption = 'Quarterly Cost of Fund';
    PageType = List;
    SourceTable = "Quarterly Cost of Fund";
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the first date of the quarter.';
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the last date of the quarter.';
                    ApplicationArea = All;
                }
                field("Cost of Fund Rate"; Rec."Cost of Fund Rate")
                {
                    ToolTip = 'Specifies the quarterly published Cost of Fund rate (%).';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a label for this entry, e.g. ''Q1 FY2081-82''.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
