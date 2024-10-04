report 33019814 "Interviewer Email"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019814.InterviewerEmail.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Candidate; Candidate)
        {
            RequestFilterFields = "Vacancy Code";
            column(InterviewDate_Interviewer; Format("Interview Date")) { }
            column(InterviewTime_Interviewer; "Interview Time") { }
            column(Candidate_Fullame; FName) { }
            column(SN; SN) { }
            column(VacancyCode_Interviewer; "Vacancy Code") { }

            trigger OnAfterGetRecord()
            begin

                SN += 1;
                Clear(FName);
                FName := Candidate."First Name" + ' ' + Candidate."Last Name";
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        SN: Integer;
        FName: Text;
}
