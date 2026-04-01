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
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Setup Type"; Rec."Setup Type")
                {
                    ToolTip = 'Specifies the type of setup entry (Training Institute Name, Training Category, etc.).';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
