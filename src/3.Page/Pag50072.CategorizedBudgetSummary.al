page 50074 "Categorized Budget Summary"
{
    ApplicationArea = All;
    Caption = 'Categorized Budget Summary';
    PageType = ListPart;
    SourceTable = "Training Budget Line";
    SourceTableView = where("Budget By" = filter("Training Category"));
    AutoSplitKey = true;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Training Category"; Rec."Training Category")
                {
                    ToolTip = 'Specifies the value of the Training Category field.', Comment = '%';
                }
                field("Budgeted No. of Trainings"; Rec."Budgeted No. of Trainings")
                {
                    ToolTip = 'Specifies the value of the No. of Training field.';
                }
                field("Actual No. of Trainings"; Rec."Actual No. of Trainings")
                {
                    ToolTip = 'Specifies the value of the Actual No. of Training field.';
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                }
                field("Actual Amount"; Rec."Actual Amount")
                {
                    ToolTip = 'Specifies the value of the Actual Amount field.';
                }
            }
        }
    }
}
