page 50299 "KPI Appraisal Dept Subform"
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the KPI Code field.';
                    ApplicationArea = All;
                }
                field("KPI Description"; Rec."KPI Description")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the KPI Description field.';
                    ApplicationArea = All;
                }
                field("Weightage %"; Rec."Weightage %")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Weightage % field.';
                    ApplicationArea = All;
                }
                field("Target Dept"; Rec."Target Dept")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Dept field.';
                    // DrillDownPageID = 60286;
                }
                field("Actual Dept"; Rec."Actual Dept")
                {
                    ToolTip = 'Specifies the value of the Actual Dept field.';
                    // DrillDownPageID = 60286;
                }
                field("Score Dept"; Rec."Score Dept")
                {
                    ToolTip = 'Specifies the value of the Score Dept field.';
                    // DrillDownPageID = 60286;
                }
            }
        }
    }

    actions { }
}
