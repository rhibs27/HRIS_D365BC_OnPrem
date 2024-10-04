page 50130 "Rolewise Job Descriptions"
{
    // version HRM1.00

    DelayedInsert = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Rolewise Job Description";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Role Code"; Rec."Role Code")
                {
                    ToolTip = 'Specifies the value of the Role Code field.';
                    ApplicationArea = All;
                }
                field("Job Description Code"; Rec."Job Description Code")
                {
                    ToolTip = 'Specifies the value of the Job Description Code field.';
                    ApplicationArea = All;
                }
                field("Job Description"; Rec."Job Description")
                {
                    ToolTip = 'Specifies the value of the Job Description field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
