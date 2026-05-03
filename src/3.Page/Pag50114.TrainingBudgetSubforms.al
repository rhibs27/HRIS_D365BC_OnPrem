page 50114 "Monthwise Training Budget"
{
    AutoSplitKey = true;
    InsertAllowed = false;
    Caption = 'Monthwise Budget Summary';
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
                field("Actual No. of Training"; Rec."Actual No. of Trainings")
                {
                    ToolTip = 'Specifies the value of the Actual No. of Training field.';
                    ApplicationArea = All;
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                    ApplicationArea = All;
                }
                field("YTD Budgeted Amount"; Rec."YTD Budgeted Amount")
                {
                    ToolTip = 'Specifies the value of the YTD Budgeted Amount field.';
                    ApplicationArea = All;
                }
                field("Actual Amount"; Rec."Actual Amount")
                {
                    ToolTip = 'Specifies the value of the Actual Amount field.';
                    ApplicationArea = All;
                }
                field("YTD Actual Amount"; Rec."YTD Actual Amount")
                {
                    ToolTip = 'Specifies the value of the YTD Actual Amount field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
