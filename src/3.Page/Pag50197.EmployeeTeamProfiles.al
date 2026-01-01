page 50197 "Employee Team Profiles"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Team Profile Header";
    Caption = 'Employee Team Profiles';
    CardPageId = "Team Profile Card";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the team code.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the team description.';
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee code.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                }
                field("Approval Role"; Rec."Approval Role")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval role.';
                }
                field("Block"; Rec."Block")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the team is blocked.';
                }
            }
        }
    }
}
