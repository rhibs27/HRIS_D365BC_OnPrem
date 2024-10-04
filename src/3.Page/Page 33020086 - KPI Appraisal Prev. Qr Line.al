page 33020086 "KPI Appraisal Prev. Qr Line"
{
    // version KPI1.00

    PageType = ListPart;
    SourceTable = "KPI Appraisal (NIC) Lines";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("KPI Code"; Rec."KPI Code")
                {
                    ToolTip = 'Specifies the value of the KPI Code field.';
                    ApplicationArea = All;
                }
                field("KPI Description"; Rec."KPI Description")
                {
                    ToolTip = 'Specifies the value of the KPI Description field.';
                    ApplicationArea = All;
                }
                field("Weightage %"; Rec."Weightage %")
                {
                    ToolTip = 'Specifies the value of the Weightage % field.';
                    ApplicationArea = All;
                }
                field(Target; Rec.Target)
                {
                    //DrillDownPageID = 60286;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target field.';
                }
                field(Actual; Rec.Actual)
                {
                    //DrillDownPageID = 60286;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual field.';
                }
                field(Score; Rec.Score)
                {
                    //DrillDownPageID = 60286;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Score field.';
                }
                field("Reviewer's Score"; Rec."Reviewer's Score")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Reviewer''s Score field.';
                    ApplicationArea = All;
                }
                field("Check Reviewer's Score"; Rec."Check Reviewer's Score")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Check Reviewer''s Score field.';
                    ApplicationArea = All;
                }
                field("Final Reviewer's Score"; Rec."Final Reviewer's Score")
                {
                    ToolTip = 'Specifies the value of the Final Reviewer''s Score field.';
                    ApplicationArea = All;
                }
                field("KPI Type"; Rec."KPI Type")
                {
                    ToolTip = 'Specifies the value of the KPI Type field.';
                    ApplicationArea = All;
                }
                field(Quarter; Rec.Quarter)
                {
                    ToolTip = 'Specifies the value of the Quarter field.';
                    ApplicationArea = All;
                }
                field("KPI Category"; Rec."KPI Category")
                {
                    ToolTip = 'Specifies the value of the KPI Category field.';
                    ApplicationArea = All;
                }
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
