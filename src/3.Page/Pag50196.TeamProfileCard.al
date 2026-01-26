page 50196 "Team Profile Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Team Profile Header";
    Caption = 'Team Profile';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Can run Employee Master Report"; Rec."Can run Employee Master Report")
                {
                    ToolTip = 'If set employee can run the Employee Master Report from self serve portal.', Comment = '%';
                }
                field("Block"; Rec."Block")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the team is blocked.';
                }
            }
            part(Lines; "Team Profile Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Team Code" = field("Code");
                UpdatePropagation = Both;
            }
        }
    }
}
