report 50011 "Appointment Letter"
{
    // version HRM1.00

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019811.AppointmentLetter.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Candidate; Candidate)
        {
            column(Name_CompanyInfo; CompanyInfo.Name) { }
            column(No_Candidates; Candidate."No.") { }
            column(LastName_Candidates; Candidate."Last Name") { }
            column(CandidateName; Candidate.FullName) { }
            column(JobTitle_Candidates; Candidate."Job Title") { }
            column(Address_Candidates; Candidate."Permanent Address") { }
            column(Address2_Candidates; Candidate."Address 2") { }
            column(PhoneNo_Candidates; Candidate."Phone No.") { }
            column(MobilePhoneNo_Candidates; Candidate."Mobile No.") { }
            column(EMail_Candidates; Candidate."E-Mail") { }
            column(Gender_Candidates; Candidate.Gender) { }
            column(PersonalTitle_Candidates; Candidate."Personal Title") { }
            column(JobPositionType_Candidates; Candidate."Job Position Type") { }
            column(Age_Candidates; Candidate.Age) { }
            column(VacancyCode_Candidates; Candidate."Vacancy Code") { }
            column(Experience_Candidates; Candidate."Commercial Banking Experience") { }
            column(OfferLetterPrinted_Candidates; Candidate."Offer Letter Printed") { }
            column(ApplicationLetterPrinted_Candidates; Candidate."Application Letter Printed") { }
            column(ApplicationInfo; ApplicationInfo) { }
            column(JobtitleName; JobTitle."Functional Title") { }
            column(ReportingToEmployeePosition; Employee."Job Title") { }
            column(ReportingToEmployeeName; VacancyHdr."Reporting To Employee Name") { }

            trigger OnAfterGetRecord()
            begin
                if JobTitle.Get(Candidate."Applied Salary Level") then;
                ApplicationInfo := 'With reference to your application and subsequent interviews you had with us,' +
                 'we are pleased to offer you an appointment as <b>' + JobTitle."Functional Title" + 'effective from <b>';

                SN := 0;
                if VacancyHdr.Get(Candidate."Vacancy Code") then
                    if Employee.Get(VacancyHdr."Requestor Employee Code") then;
            end;
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
        JobTitle: Record "Job Title";
        CompanyInfo: Record "Company Information";
        ApplicationInfo: Text;
        SN: Integer;
        Employee: Record Employee;
        VacancyHdr: Record "Vacancy Header";
}
