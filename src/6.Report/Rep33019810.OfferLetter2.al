report 33019810 "Offer Letter2"
{
    // version not used

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019810.OfferLetter2.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Candidate; Candidate)
        {
            RequestFilterFields = "No.";
            column(Name_CompanyInfo; CompanyInfo.Name) { }
            column(No_Candidates; Candidate."No.") { }
            column(CandidateName; Candidate.FullName) { }
            column(PersonalTitle_Candidates; Candidate."Personal Title") { }
            column(Initials_Candidates; Candidate.Initials) { }
            column(JobTitle_Candidates; JobTitle."Functional Title") { }
            column(Address_Candidates; Candidate."Permanent Address") { }
            column(Address2_Candidates; Candidate."Address 2") { }
            column(PhoneNo_Candidates; Candidate."Phone No.") { }
            column(MobilePhoneNo_Candidates; Candidate."Mobile No.") { }
            column(EMail_Candidates; Candidate."E-Mail") { }
            column(BirthDate_Candidates; Candidate."Birth Date") { }
            column(Gender_Candidates; Candidate.Gender) { }
            column(Status_Candidates; Candidate.Status) { }
            column(ApplicationInfo; ApplicationInfo) { }

            trigger OnAfterGetRecord()
            begin
                //IF JobTitle.GET() THEN;
                ApplicationInfo := 'On the basis of your application and subsequent interviews,' +
                 'we are pleased to offer you the post of <b>' + JobTitle."Functional Title" + 'in our organization.';
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
        ApplicationInfo: Text;
        JobTitle: Record "Job Title";
        CompanyInfo: Record "Company Information";
}
