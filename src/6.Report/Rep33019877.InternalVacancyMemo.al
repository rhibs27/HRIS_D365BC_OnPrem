report 33019877 "Internal Vacancy Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019877.InternalVacancyMemo.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Recruitement Memo"; "Recruitement Memo")
        {
            DataItemTableView = where(Type = const(Internal));
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(CurrentDate; Today) { }
            column(ReferenceNo_; "Reference No.") { }
            column(Subject_; Subject) { }
            column(DateofRequest_; "Date of Request") { }
            column(HRSCMeetingNo_; "HRSC Meeting No.") { }
            column(Posted_; Posted) { }
            column(MemoNo_; "Memo No.") { }
            column(PostingDate_; "Posting Date") { }
            dataitem("Recruitement Memo Line"; "Recruitement Memo Line")
            {
                DataItemLink = "Memo No." = field("Memo No.");
                column(SalaryLevelCode_; "Salary Level Code") { }
                column(SalaryLevelDescription_; "Salary Level Description") { }
                column(RequiredNo_; Format("Required No.")) { }
                column(ProvinceCode_; "Province Code") { }
                column(ProvinceName_; "Province Name") { }
                column(FunctionalTitleDescription_; "Functional Title Description") { }
            }
            dataitem("Document Workflow"; "Document Workflow")
            {
                DataItemLink = "Primary Key" = field("Memo No.");
                column(HeadingType_; "Heading Type") { }
                column(EmployeeNo_; "Employee No.") { }
                column(EmployeeName_; "Employee Name") { }
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
}
