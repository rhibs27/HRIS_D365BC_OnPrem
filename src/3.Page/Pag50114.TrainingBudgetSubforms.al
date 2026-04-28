page 50114 "Monthwise Training Budget"
{
    AutoSplitKey = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Training Budget Line";
    SourceTableView = where("Budget By" = filter(Month));
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
                field("No. of Training"; Rec."Budgeted No. of Trainings")
                {
                    ToolTip = 'Specifies the value of the No. of Training field.';
                    ApplicationArea = All;
                }
                field("Budget Amount"; Rec."Budgeted Amount")
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
