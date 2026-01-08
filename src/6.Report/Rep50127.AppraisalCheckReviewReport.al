report 50127 "Appraisal Check Review Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019928.AppraisalCheckReviewReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Appraisal; Appraisal)
        {
            DataItemTableView = sorting("Appraisal Code") order(ascending);
            RequestFilterFields = "Appraisal Type", Status, "Fiscal Year";
            column(EmployeeCode_Appraisal; Appraisal."Employee Code") { }
            column(EmployeeName_Appraisal; Appraisal."Employee Name") { }
            column(RequestedDate_Appraisal; Appraisal."Requested Date") { }
            column(TotalCheckReviewScore_Appraisal; Appraisal."Total Immediate Supv Score") { }
            column(AppraisalType_Appraisal; Appraisal."Appraisal Type") { }
            column(CheckReviewersComments_Appraisal; Appraisal."Check Reviewers Comments") { }
            column(TotalReviewersFinalScore_Appraisal; Appraisal."Total Reviewer Score") { }
            column(FiscalYear_Appraisal; Appraisal."Fiscal Year") { }
            column(Status_Appraisal; Appraisal.Status) { }

            trigger OnAfterGetRecord()
            begin
                Appraisal.CalcFields("Total Immediate Supv Score");
                Appraisal.CalcFields("Total Reviewer Score");
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }
}
