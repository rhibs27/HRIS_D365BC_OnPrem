page 33019914 "Training Budget Subforms"
{
    AutoSplitKey = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Training Budget Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field("No. of Training"; Rec."No. of Training")
                {
                    ToolTip = 'Specifies the value of the No. of Training field.';
                    ApplicationArea = All;
                }
                field("Budget Amount"; Rec."Budget Amount")
                {
                    ToolTip = 'Specifies the value of the Budget Amount field.';
                    ApplicationArea = All;
                }
                field("YTD Budget"; Rec."YTD Budget")
                {
                    ToolTip = 'Specifies the value of the YTD Budget field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
