page 33020093 "KPI Appriasal Yearly"
{
    // version KPI1.00

    EntityName = 'YearlyKPIScore';
    EntitySetName = 'Yearlykpiscores';
    ODataKeyFields = "Employee Code";
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
            repeater(General)
            {
                field(AppraisalCode; Rec."Appraisal Code") { }
                field(Type; Rec.Type) { }
                field(EmployeeCode; Rec."Employee Code")
                {
                    Editable = false;
                }
                field(EmployeeName; Rec."Employee Name") { }
                field(FunctionalTitle; Rec."Functional Title") { }
                field(Department; Rec.Department)
                {
                    Editable = false;
                }
                field(BranchCode; Rec."Branch Code") { }
                field(BranchName; Rec."Branch Name") { }
                field(Rating; Rec.Rating) { }
                field(NetKPIScore; Rec."Net KPI Score") { }
                field(YearlyKPIScore; YearlyKPIScore) { }
                field(KPIScoreWithLocationInc; Rec."KPI Score With Location Inc") { }
                field(KPIScoreWithRoleIncentive; Rec."KPI Score With Role Incentive") { }
                field(KPIScore; Rec."KPI Score") { }
            }
            part(Control15; "KPI Appraisal Yearly Subform")
            {
                EntityName = 'yearlykpiscoreline';
                EntitySetName = 'yearlykpiscoreslines';
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
        //<<KPI1.00
        KPIAppriasalRecord.Reset;
        KPIAppriasalRecord.SetRange("Employee Code", Rec."Employee Code");
        KPIAppriasalRecord.SetRange("Fiscal Year", Rec."Fiscal Year");
        if KPIAppriasalRecord.FindSet then
            repeat
                if not KPIAppriasalRecord."Closed KPI" then begin
                    KPIAppriasalRecord.CalcFields("Net KPI Score");
                    NetKPIScore += KPIAppriasalRecord."Net KPI Score";
                end
                else if KPIAppriasalRecord."Closed KPI" then
                    NetKPIScore += KPIAppriasalRecord."Approved KPI Score"
          until KPIAppriasalRecord.Next = 0;
        KPIAppriasalRecord1.Reset;
        KPIAppriasalRecord1.SetRange("Employee Code", Rec."Employee Code");
        KPIAppriasalRecord1.SetRange("Fiscal Year", Rec."Fiscal Year");
        NoOfAppriasalPeriod := KPIAppriasalRecord1.Count;
        YearlyKPIScore := NetKPIScore / NoOfAppriasalPeriod;
        KPIRatingSetup.Reset;
        KPIRatingSetup.SetFilter("Min Score", '<=%1', YearlyKPIScore);
        KPIRatingSetup.SetFilter("Max Score", '>=%1', YearlyKPIScore);
        if KPIRatingSetup.FindFirst then begin
            Rec.Rating := KPIRatingSetup.Rating;
        end;
        //>>KPI1.00
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("Closed KPI",TRUE);
        Rec.SetRange("Closed KPI", false);
    end;

    var
        KPIAppriasalLine: Record "KPI Appraisal (NIC) Lines";
        KPIRatingSetup: Record "KPI Rating Setup";
        YearlyKPIScore: Decimal;
        KPIAppriasalRecord: Record "KPI Appraisal Header NIC";
        NetKPIScore: Decimal;
        KPIAppriasalRecord1: Record "KPI Appraisal Header NIC";
        NoOfAppriasalPeriod: Integer;
}
