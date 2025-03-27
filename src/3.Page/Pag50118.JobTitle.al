page 50118 "Job Title"
{
    // version HRP6.1.0

    CardPageId = "Job Title Card";
    PageType = List;
    SourceTable = "Job Title";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Banking Experince"; Rec."Banking Experince")
                {
                    ToolTip = 'Specifies the value of the Banking Experince field.';
                    ApplicationArea = All;
                }
                field("Non-Banking Experince"; Rec."Non-Banking Experince")
                {
                    ToolTip = 'Specifies the value of the Non-Banking Experince field.';
                    ApplicationArea = All;
                }
                field("Minimum Age"; Rec."Minimum Age")
                {
                    ToolTip = 'Specifies the value of the Minimum Age field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1102159012; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
