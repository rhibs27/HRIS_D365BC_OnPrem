page 33020120 "KPI Appriasal Province Quarter"
{
    // version KPI1.00

    EntityName = 'kpiappriasalprovincequarter';
    EntitySetName = 'kpiappriasalprovincequarters';
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
                field(FunctionalTitle; Rec."Functional Title") { }
                field(AppraisalCode; Rec."Appraisal Code") { }
                field(Department; Rec.Department)
                {
                    Editable = false;
                }
                field(BranchCode; Rec."Branch Code") { }
                field(BranchName; Rec."Branch Name") { }
                field(KPIScore; Rec."KPI Score")
                {
                    // DrillDownPageID = 60286;
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
                field(Quarter; Rec.Quarter) { }
                field(FiscalYear; Rec."Fiscal Year") { }
                field(CreatedDate; Rec."Created Date") { }
            }
            part("KPI Appraisal Line Quarter"; "KPI Appraisal Line Quarter")
            {
                Caption = '<KPI Appraisal Line Quarter>';
                EntityName = 'kpiappriasallinequarter';
                EntitySetName = 'kpiappriasallinesquarters';
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
        Rec.SetRange("Closed KPI", false);
    end;

    var
        KPIAppriasalLine: Record "KPI Appraisal (NIC) Lines";
        KPIRatingSetup: Record "KPI Rating Setup";
}
