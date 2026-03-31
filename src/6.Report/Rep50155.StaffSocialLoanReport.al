report 50155 "Staff Social Loan Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50155.StaffSocialLoanReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = const("Staff Social Loan"));
            RequestFilterFields = "No.";

            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(LoanNo; "No.") { }
            column(EmployeeCode; "Employee No.") { }
            column(EmployeeName; "Employee Name") { }
            column(JobTitle; "Job Title") { }
            column(FunctionalTitle; "Functional title") { }
            column(SalaryAccountNo; "Salary Account Number") { }
            column(BranchName; "Branch Name") { }
            column(DepartmentName; "Department Name") { }
            column(UnitName; "Unit Name") { }
            column(DateOfBirth; "Date of Birth") { }
            column(Age; Age) { }
            column(ConfirmationServicePeriod; "Confirmation Service Period") { }
            column(ApprovalStatus; Format("Approval Status")) { }
            column(RequestedLoanDate; "Requested Loan Date") { }
            column(InterestRate; "Interest Rate") { }
            column(PreviousLoanAmount; "Previous Loan Amount") { }
            column(GrossSalary; "Gross Salary") { }
            column(EligibleLoan; "Eligible Loan/Advance") { }
            column(TotalLoanAmount; "Total Loan Amount") { }
            column(MonthlyInterest; EMI) { }
            column(PurposeOfLoan; "Purpose of Loan") { }
            column(AppliedLoan; "Applied Loan/Advance") { }
            column(DBRRatio; "DBR Ratio") { }
            column(LoanEnhancement; Format("Loan Enhancement")) { }
            column(CitizenshipNo; "Citizenship No.") { }
            column(CitizenshipIssueDate; "Citizenship Issue Date") { }
            column(EmployeeNameNepali; "Employee Name in Nepali") { }
            column(FathersNameNepali; "Father's Name In Nepali") { }
            column(GrandfathersNameNepali; "Grandfather's Name In Nepali") { }
            column(OfferLetterIssuedDate; "Offer Letter Issued Date") { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(OfferLetterDateNepali; "Offer Letter Date(Nepali)") { }
            column(DisbursementDate; "Disbursement Date") { }
            column(DisbursedAmount; "Disbursed Amount") { }
            column(Settled; Format(Settled)) { }
            column(SettlementDate; "Settlement Date") { }
            column(SettlerUserID; "Settler User ID") { }
            column(AccountNo; "Account No.") { }
            column(Disbursed; Format(Disbursed)) { }
            column(Remarks; Remarks) { }
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
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}
