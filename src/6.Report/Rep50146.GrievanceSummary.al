report 50146 "Grievance Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50146.GrievanceSummary.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Grievance Summary Report';

    dataset
    {
        dataitem("Grievance Header"; "Grievance Header")
        {
            RequestFilterFields = "Grievance Date", Category, Priority, Severity, "Approval Status", "Fiscal Year";

            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyAddress) { }
            column(PrintedBy; UserId) { }
            column(PrintedOn; CurrentDateTime) { }
            column(FilterCaption; FilterCaption) { }

            column(GrievanceNo; "No.") { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; "Employee Name") { }
            column(GrievanceDate; "Grievance Date") { }
            column(Category; Format(Category)) { }
            column(Priority; Format(Priority)) { }
            column(Severity; Format(Severity)) { }
            column(Subject; Subject) { }
            column(ApprovalStatus; Format("Approval Status")) { }
            column(SLAResolutionDue; "SLA Resolution Due") { }
            column(ResolutionDate; "Resolution Date") { }
            column(FiscalYear; "Fiscal Year") { }
            column(Anonymous; Anonymous) { }

            trigger OnPreDataItem()
            begin
                FilterCaption := "Grievance Header".GetFilters();
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
        CompanyInfo.Get();
        CompanyAddress := CompanyInfo.Name;
        if CompanyInfo.Address <> '' then
            CompanyAddress += ', ' + CompanyInfo.Address;
        if CompanyInfo.City <> '' then
            CompanyAddress += ', ' + CompanyInfo.City;
        if CompanyInfo."Phone No." <> '' then
            CompanyAddress += '  |  Tel: ' + CompanyInfo."Phone No.";
    end;

    var
        CompanyInfo: Record "Company Information";
        FilterCaption: Text;
        CompanyAddress: Text;
}
