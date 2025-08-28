report 50009 "Interview Evaluation Form"
{
    // version HRM1.00

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019809.InterviewEvaluationForm.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Candidate; Candidate)
        {
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(ReportName; ReportName) { }
            column(No_Candidates; Candidate."No.") { }
            column(CandidateName; FullName) { }
            column(Age_Candidates; Candidate.Age) { }
            column(Experience_Candidates; Candidate."Commercial Banking Experience") { }
            column(Position; VacancyRec."Salary Level Code") { }
            column(Location; VacancyRec.Location) { }
            column(Budget_Salary; VacancyRec."Budget Salary / CTC") { }
            dataitem(Interviewer; Interviewer)
            {
                DataItemLink = "Vacancy Code" = field("Vacancy Code"), "Candidate No." = field("No.");
                RequestFilterFields = "Vacancy Code", "Candidate No.";
                column(VacancyCode_Interviewer; "Vacancy Code") { }
                column(Interviewer_Interviewer; Interviewer) { }
                column(Sequence_Interviewer; Sequence) { }
                column(InterviewDate_Interviewer; "Interview Date") { }
                column(InterviewTime_Interviewer; "Interview Time") { }
                column(Interviewer1Name; Interviewer1Name) { }
                column(Interviewer2Name; Interviewer2Name) { }
                column(Interviewer3Name; Interviewer3Name) { }
                dataitem("Evaluation Entry"; "Evaluation Entry")
                {
                    DataItemLink = "No." = field("Candidate No."), "Vacancy Code" = field("Vacancy Code");
                    column(VacancyCode_CandidateEvaluationEntry; "Evaluation Entry"."Vacancy Code") { }
                    column(CandidateNo_CandidateEvaluationEntry; "Evaluation Entry"."No.") { }
                    column(AttributeCode_CandidateEvaluationEntry; "Evaluation Entry"."Attribute Code") { }
                    column(AttributeDescription_CandidateEvaluationEntry; "Evaluation Entry"."Attribute Description") { }
                    column(Interviewer1_CandidateEvaluationEntry; "Evaluation Entry"."Interviewer Code") { }
                    column(Interviewer2_CandidateEvaluationEntry; "Evaluation Entry"."Interviewer Name") { }
                    column(Interviewer3_CandidateEvaluationEntry; "Evaluation Entry".Marks) { }
                    column(UserID_CandidateEvaluationEntry; "Evaluation Entry"."User ID") { }
                    column(ModifiedDate_CandidateEvaluationEntry; "Evaluation Entry"."Modified Date") { }
                }

                trigger OnAfterGetRecord()
                begin
                    /*
                    CASE Sequence OF
                      1:
                        IF Employee.GET("Employee Code") THEN
                          Interviewer1Name := Employee.FullName;
                      2:
                        IF Employee.GET("Employee Code") THEN
                          Interviewer2Name := Employee.FullName;
                      3:
                        IF Employee.GET("Employee Code") THEN
                          Interviewer3Name := Employee.FullName;
                    end;
                    */
                end;
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
        ReportName: Label 'Interview Evaluation Form';
        VacancyRec: Record "Vacancy Header";
        Interviewer1Name: Text;
        Interviewer2Name: Text;
        Interviewer3Name: Text;
}
