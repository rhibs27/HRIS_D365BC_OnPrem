page 50308 "KPI Appriasal Province API"
{
    // version KPI1.00

    EntityName = 'kpiappriasalprovincemtd';
    EntitySetName = 'kpiappriasalprovincesmtd';
    ODataKeyFields = "Appraisal Code";
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "KPI Appraisal Header NIC";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Type; Rec.Type) { }
                field(EmployeeCode; Rec."Employee Code") { }
                field(EmployeeName; Rec."Employee Name") { }
                field(FunctionaTitle; Rec."Functional Title") { }
                field(Department; Rec.Department)
                {
                    Editable = false;
                }
                field(BranchCode; Rec."Branch Code") { }
                field(BranchName; Rec."Branch Name") { }
                field(KPIScore; Rec."KPI Score")
                {
                    //DrillDownPageID = 60286;
                }
                field(KPIScoreWithLocationInc; Rec."KPI Score With Location Inc")
                {
                    // DrillDownPageID = 60285;
                }
                field(KPIScoreWithRoleIncentive; Rec."KPI Score With Role Incentive")
                {
                    // DrillDownPageID = 60285;
                }
                field(NetKPIScore; Rec."Net KPI Score")
                {
                    // DrillDownPageID = 60285;
                }
                field(Rating; Rec.Rating) { }
                field(ClosedKPI; Rec."Closed KPI") { }
                field(DateFilter; Rec."Date Filter") { }
                field(Quarter; Rec.Quarter) { }
                field(FiscalYear; Rec."Fiscal Year") { }
                field(CreatedDate; Rec."Created Date") { }
            }
            part("KPI Appriasal Lines"; "KPI Appraisal Sub. Form API")
            {
                EntityName = 'kpiappriasalprovlinemtd';
                EntitySetName = 'kpiappriasalprovlinesmtd';
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Close Quarter")
            {
                trigger OnAction()
                begin
                    KPIAppriasalLine.Reset;
                    KPIAppriasalLine.SetRange("Appraisal Code", Rec."Appraisal Code");
                    if KPIAppriasalLine.FindSet then
                        repeat
                            if KPIAppriasalLine."Check Reviewer's Score" = 0 then
                                Error('Check Reviewer Score is %1 in Line No. %2', KPIAppriasalLine."Check Reviewer's Score", KPIAppriasalLine."Line No.");
                        until KPIAppriasalLine.Next = 0;
                    KPIAppriasalLine.CalcSums("Check Reviewer's Score");
                    Rec."Approved KPI Score" := KPIAppriasalLine."Check Reviewer's Score";
                    Rec.CalcFields("KPI Score With Location Inc");
                    Rec.CalcFields("KPI Score With Role Incentive");
                    Rec."Net Approved KPI Score" := Rec."KPI Score With Location Inc" + Rec."KPI Score With Role Incentive" + Rec."Approved KPI Score";
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Net KPI Score");
        KPIRatingSetup.Reset;
        KPIRatingSetup.SetFilter("Min Score", '<=%1', Rec."Net KPI Score");
        KPIRatingSetup.SetFilter("Max Score", '>=%1', Rec."Net KPI Score");
        if KPIRatingSetup.FindFirst then begin
            Rec.Rating := KPIRatingSetup.Rating;
        end;
    end;

    trigger OnOpenPage()
    begin
        FilterMonthlyKPI;
        Rec.SetRange("Closed KPI", false);
    end;

    var
        KPIAppriasalLine: Record "KPI Appraisal (NIC) Lines";
        AccountingPeriod: Record "Accounting Period";
        KPIRatingSetup: Record "KPI Rating Setup";

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
    begin
        AccountingPeriod.SetFilter("Starting Date", '<=%1', Today);
        if AccountingPeriod.FindLast then
            Rec.SetFilter("Date Filter", '%1..%2', AccountingPeriod."Starting Date", GetNextAccPeriodStartDate(Today) - 1);
    end;
}
