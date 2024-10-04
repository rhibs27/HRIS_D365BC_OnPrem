page 33019824 "Salary Grades"
{
    // version PRM19.01.01

    PageType = List;
    SourceTable = "Salary Grade";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field("Standard Step"; Rec."Standard Step")
                {
                    ToolTip = 'Specifies the value of the Standard Step field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Grade Percentage"; Rec."Grade Percentage")
                {
                    ToolTip = 'Specifies the value of the Grade Percentage field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
