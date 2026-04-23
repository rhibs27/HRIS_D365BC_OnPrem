page 50098 "Training Lists"
{
    CardPageId = "Training Card";
    PageType = List;
    SourceTable = "Training Header";
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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Institute Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                    ApplicationArea = All;
                }
                field("Training Type"; Rec."Training Type")
                {
                    ToolTip = 'Specifies the value of the Training Type field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control4; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control3; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

    // var
    //     HrMgt: Codeunit "HR Mgt.";
    //     TrainingMgt: Codeunit "Training Mgt";
}
