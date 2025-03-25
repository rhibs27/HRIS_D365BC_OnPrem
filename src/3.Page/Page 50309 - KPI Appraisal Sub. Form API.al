page 50309 "KPI Appraisal Sub. Form API"
{
    // version KPI1.00

    //The property 'EntityName' can only be set if the property 'PageType' is set to 'API'
    //EntityName = 'kpiappriasalprovline';
    //The property 'EntitySetName' can only be set if the property 'PageType' is set to 'API'
    //EntitySetName = 'kpiappriasalprovlines';
    PageType = ListPart;
    SourceTable = "KPI Appraisal Bank Lines";
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target field.';
                }
                field(Actual; Rec.Actual)
                {
                    ToolTip = 'Specifies the value of the Actual field.';
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.';
                    // DrillDownPageID = 60286;
                }
                field("KPI Type"; Rec."KPI Type")
                {
                    ToolTip = 'Specifies the value of the KPI Type field.';
                }
                field("Date Filter"; Rec."Date Filter")
                {
                    ToolTip = 'Specifies the value of the Date Filter field.';
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        FilterMonthlyKPI;
    end;

    local procedure GetNextAccPeriodStartDate(CurrentDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.Reset;
        AccountingPeriod.SetFilter("Starting Date", '>%1', CurrentDate);
        if AccountingPeriod.FindFirst then
            exit(AccountingPeriod."Starting Date");
    end;

    local procedure FilterMonthlyKPI()
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SetFilter("Starting Date", '<=%1', Today);
        if AccountingPeriod.FindLast then
            Rec.SetFilter("Date Filter", '%1..%2', AccountingPeriod."Starting Date", GetNextAccPeriodStartDate(Today) - 1);
    end;
}
