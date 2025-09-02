page 50030 "Tax Setup Subform"
{
    // version PRM19.01.01

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Tax Setup Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                }
                field("Start Amount"; Rec."Start Amount")
                {
                    ToolTip = 'Specifies the value of the Start Amount field.';
                    ApplicationArea = All;
                }
                field("End Amount"; Rec."End Amount")
                {
                    ToolTip = 'Specifies the value of the End Amount field.';
                    ApplicationArea = All;
                }
                field("Tax Rate"; Rec."Tax Rate")
                {
                    ToolTip = 'Specifies the value of the Tax Rate field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
