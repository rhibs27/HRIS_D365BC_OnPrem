page 50275 "Active Employee"
{
    ApplicationArea = All;
    Caption = 'Active Employee';
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(Content)
        {
            grid("Active Employees")
            {
                group("Active Employee")
                {
                    field("Contract Staff"; Rec."Contract Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Contract Staff field.';
                        ApplicationArea = All;
                    }
                    field("Probation Staff"; Rec."Probation Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Probation Staff field.';
                        ApplicationArea = All;
                    }
                    field("Permanent Staff"; Rec."Permanent Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Permanent Staff field.';
                        ApplicationArea = All;
                    }
                    field("To Check Reviews KPI"; Rec."To Check Reviews KPI")
                    {
                        DrillDownPageID = "KPI Appraisals bank List";
                        ToolTip = 'Specifies the value of the To Check Reviews KPI field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
}
