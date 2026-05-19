page 50014 "Training Master"
{
    PageType = List;
    SourceTable = "Training Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Setup Type"; Rec."Master Type")
                {
                    ToolTip = 'Specifies the type of setup entry (Training Institute Name, Training Category, etc.).';
                    ApplicationArea = All;
                }
                field("No."; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Training Type"; Rec."Training Category")
                {

                }
            }
        }
    }

    actions { }
}
