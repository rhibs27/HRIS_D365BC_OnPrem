page 50173 "Grade Entries"
{
    Caption = 'Grade Entries';
    PageType = List;
    SourceTable = "Grade Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the New Salary Level field.';
                    ApplicationArea = All;
                }
                field(Grade; Rec.Grade)
                {
                    ToolTip = 'Specifies the value of the New Grade Level field.';
                    ApplicationArea = All;
                }
                field("Default Grade Percentage"; Rec."Default Grade Percentage")
                {
                    ToolTip = 'Specifies the value of the Default Grade Percentage field.', Comment = '%';
                }
                field("Appraisal Grade Percentage"; Rec."Appraisal Grade Percentage")
                {
                    ToolTip = 'Specifies the value of the Appraisal Grade Percentage field.', Comment = '%';
                }
                field("Total Grade Percentage"; Rec."Total Grade Percentage")
                {
                    ToolTip = 'Specifies the value of the Total Grade Percentage field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {

                    ToolTip = 'Specifies the value of the Last Grade Posting Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
