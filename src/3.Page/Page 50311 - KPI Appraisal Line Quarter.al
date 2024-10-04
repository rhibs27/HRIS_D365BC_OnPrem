page 50311 "KPI Appraisal Line Quarter"
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
                    ToolTip = 'Specifies the value of the Target field.';
                    ApplicationArea = All;
                }
                field(Actual; Rec.Actual)
                {
                    //DrillDownPageID = 60286;
                    ToolTip = 'Specifies the value of the Actual field.';
                    ApplicationArea = All;
                }
                field(Score; Rec.Score)
                {
                    //DrillDownPageID = 60286;
                    ToolTip = 'Specifies the value of the Score field.';
                    ApplicationArea = All;
                }
                field("KPI Type"; Rec."KPI Type")
                {
                    ToolTip = 'Specifies the value of the KPI Type field.';
                    ApplicationArea = All;
                }
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
