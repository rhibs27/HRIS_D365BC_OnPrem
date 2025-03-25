page 50192 "KPI Appraisal Submit Sub Form"
{
    ApplicationArea = All;
    Caption = 'KPI Appraisal Submit Sub Form';
    PageType = ListPart;
    SourceTable = "KPI Appraisal Bank Lines";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("KPI Code"; Rec."KPI Code")
                {
                    ToolTip = 'Specifies the value of the KPI Code field.';
                }
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                }
                field("KPI Description"; Rec."KPI Description")
                {
                    ToolTip = 'Specifies the value of the KPI Description field.';
                }
                field("Weightage %"; Rec."Weightage %")
                {
                    ToolTip = 'Specifies the value of the Weightage % field.';
                }
                field(Target; Rec.Target)
                {
                    ToolTip = 'Specifies the value of the Target field.';
                }
                field(Actual; Rec.Actual)
                {
                    ToolTip = 'Specifies the value of the Actual field.';
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.';
                }
                field("Reviewer's Score"; Rec."Reviewer's Score")
                {
                    ToolTip = 'Specifies the value of the Reviewer''s Score field.';
                }
                field("Check Reviewer's Score"; Rec."Check Reviewer's Score")
                {
                    ToolTip = 'Specifies the value of the Check Reviewer''s Score field.';
                }
                field("Final Reviewer's Score"; Rec."Final Reviewer's Score")
                {
                    ToolTip = 'Specifies the value of the Final Reviewer''s Score field.';
                }
                field("Probation Employee Score"; Rec."Probation Employee Score")
                {
                    ToolTip = 'Specifies the value of the Probation Employee Score field.', Comment = '%';
                }
                field("KPI Type"; Rec."KPI Type")
                {
                    ToolTip = 'Specifies the value of the KPI Type field.';
                }
                field(Quarter; Rec.Quarter)
                {
                    ToolTip = 'Specifies the value of the Quarter field.';
                }
            }
        }
    }
}
