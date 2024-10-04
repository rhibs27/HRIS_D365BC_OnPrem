page 33020017 "Grade Entries"
{
    PageType = List;
    SourceTable = "Grade Entry";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Old Grade Level"; Rec."Old Grade Level")
                {
                    ToolTip = 'Specifies the value of the Old Grade Level field.';
                    ApplicationArea = All;
                }
                field("New Grade Level"; Rec."New Grade Level")
                {
                    ToolTip = 'Specifies the value of the New Grade Level field.';
                    ApplicationArea = All;
                }
                field("Old Salary Level"; Rec."Old Salary Level")
                {
                    ToolTip = 'Specifies the value of the Old Salary Level field.';
                    ApplicationArea = All;
                }
                field("New Salary Level"; Rec."New Salary Level")
                {
                    ToolTip = 'Specifies the value of the New Salary Level field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
