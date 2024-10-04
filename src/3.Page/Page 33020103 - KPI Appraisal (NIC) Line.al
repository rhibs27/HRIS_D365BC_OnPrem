page 33020103 "KPI Appraisal (NIC) Line"
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target field.';
                    // DrillDownPageID = 60286;
                }
                field(Actual; Rec.Actual)
                {
                    ToolTip = 'Specifies the value of the Actual field.';
                    // DrillDownPageID = 60286;
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.';
                    // DrillDownPageID = 60286;
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
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        //FilterMonthlyKPI;
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
