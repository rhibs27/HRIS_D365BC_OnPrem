page 50296 "KPI Appraisal Department"
{
    // version KPI1.00

    PageType = Card;
    SourceTable = "KPI Appraisal Header NIC";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
                field("Net KPI Score Dept"; Rec."Net KPI Score Dept")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net KPI Score Dept field.';
                    // DrillDownPageID = 60285;
                }
                field("Approved KPI Score"; Rec."Approved KPI Score")
                {
                    ToolTip = 'Specifies the value of the Approved KPI Score field.';
                }
                field("Net Approved KPI Score"; Rec."Net Approved KPI Score")
                {
                    ToolTip = 'Specifies the value of the Net Approved KPI Score field.';
                }
            }
            part("KPI Appraisal (NIC) Line"; "KPI Appraisal Dept Subform")
            {
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Calculate Score")
            {
                ToolTip = 'Executes the Calculate Score action.';

                trigger OnAction()
                begin
                    KPIMgt.DailyKPIScoreCalculationIndv(Rec."Appraisal Code");
                end;
            }
            action("Calculate Location Incentive")
            {
                ToolTip = 'Executes the Calculate Location Incentive action.';

                trigger OnAction()
                begin
                    Rec."KPI Score With Location Inc" := KPIMgt.CalculateLocationIncentive(Rec."Employee Code");
                    Rec.Modify;
                end;
            }
            action("Calculate Role Incentive")
            {
                ToolTip = 'Executes the Calculate Role Incentive action.';

                trigger OnAction()
                begin
                    Rec."KPI Score With Role Incentive" := KPIMgt.CalculateRoleIncentive(Rec."Employee Code");
                    Rec.Modify;
                end;
            }
            action("Calculate Net Score")
            {
                ToolTip = 'Executes the Calculate Net Score action.';

                trigger OnAction()
                begin
                    Rec.CalcFields("KPI Score");
                    Rec."Net KPI Score" := Rec."KPI Score" + Rec."KPI Score With Location Inc" + Rec."KPI Score With Role Incentive";
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Department;
    end;

    var
        KPIMgt: Codeunit "KPI Mgt.";
}
