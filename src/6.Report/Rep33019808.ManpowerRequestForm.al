report 33019808 "Manpower Request Form"
{
    // version HRM1.00

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019808.ManpowerRequestForm.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Vacancy Header"; "Vacancy Header")
        {
            RequestFilterFields = "No.";
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(ReportName; ReportName) { }
            column(No_VacancyHeader; "Vacancy Header"."No.") { }
            column(Description_VacancyHeader; "Vacancy Header".Description) { }
            column(ReferenceNo_VacancyHeader; "Vacancy Header"."Reference No.") { }
            column(DateofRequest_VacancyHeader; "Vacancy Header"."Date of Request") { }
            column(RequestorEmployeeCode_VacancyHeader; "Vacancy Header"."Requestor Employee Code") { }
            column(RequestorName_VacancyHeader; "Vacancy Header"."Requestor Name") { }
            column(RequestorDesignation_VacancyHeader; "Vacancy Header"."Requestor Designation") { }
            column(Positiontobefilled_VacancyHeader; "Vacancy Header"."Functional Title") { }
            column(Location_VacancyHeader; "Vacancy Header".Location) { }
            column(NewPosition_VacancyHeader; "Vacancy Header"."New Position") { }
            column(PositionVacancy_VacancyHeader; "Vacancy Header"."Salary Level Code") { }
            column(BudgetSalaryCTC_VacancyHeader; "Vacancy Header"."Budget Salary / CTC") { }
            column(ExistingSalary_VacancyHeader; "Vacancy Header"."Existing Salary") { }
            column(NewPositionSalary_VacancyHeader; "Vacancy Header"."New Position Salary") { }
            column(InternalCandidateIdentified_VacancyHeader; "Vacancy Header"."Internal Candidate Identified") { }
            column(InternalCandidateCode_VacancyHeader; "Vacancy Header"."Internal Candidate Code") { }
            column(InternalCandidateName_VacancyHeader; "Vacancy Header"."Internal Candidate Name") { }
            column(RequesterUserID_VacancyHeader; "Vacancy Header"."Requester User ID") { }
            column(NoSeries_VacancyHeader; "Vacancy Header"."No. Series") { }
            column(LastModifiedDate_VacancyHeader; "Vacancy Header"."Last Modified Date") { }
            column(ReportingtoEmployeeID_VacancyHeader; "Vacancy Header"."Reporting to Employee ID") { }
            column(Status_VacancyHeader; "Vacancy Header"."Approval Status") { }
            column(Posted_VacancyHeader; "Vacancy Header".Posted) { }
            column(ExperienceMinimumTotal_VacancyHeader; "Vacancy Header"."Banking Experience") { }
            column(ExperienceMaximumTotal_VacancyHeader; "Vacancy Header"."Non-Banking Experience") { }
            column(ExperienceMinimumRelevant_VacancyHeader; "Vacancy Header"."Total Experience") { }
            column(ExperienceMaximumRelevant_VacancyHeader; "Vacancy Header"."Experience Maximum Relevant") { }
            column(Age_VacancyHeader; "Vacancy Header"."Minimum Age") { }
            column(Requirementfortwofourwheel_VacancyHeader; "Vacancy Header"."Requirement for two/four wheel") { }
            column(Recruitmenttobefilled_VacancyHeader; "Vacancy Header"."Recruitment to be filled") { }
            column(ReportingToEmployeeName_VacancyHeader; "Vacancy Header"."Reporting to Employee ID") { }
            dataitem("Job Desc./Spec. Entry"; "Job Desc./Spec. Entry")
            {
                DataItemLink = "Vacancy Code" = field("No.");
                column(Description_VacancyJobDescription; "Job Desc./Spec. Entry"."Job Description") { }
                column(Type_VacancyJobDescription; "Job Desc./Spec. Entry".Type) { }
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportName: Label 'Manpower Request Form';
}
