report 50041 "Offer Letter Personal Loan"
{
    RDLCLayout = './src/6.Report/Rep33019842.OfferLetterPersonalLoan.rdl';
    WordLayout = './src/6.Report/Rep33019842.OfferLetterPersonalLoan.docx';
    DefaultLayout = Word;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = const("Personal Loan"));
            RequestFilterFields = "No.";
            column(TodayDate; "Offer Letter Date(Nepali)") { }
            column(EmployeeCode; EmpVar."Employee No. (Nepali)") { }
            column(InterestRate_EmployeeLoanAdvance; "Interest Rate") { }
            column(EligibleLoanAdvance_EmployeeLoanAdvance; "Eligible Loan/Advance") { }
            column(DisbursedAmount; "Applied Loan/Advance") { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(EmployeeName; EmpVar."Full Name (Nepali)") { }

            trigger OnAfterGetRecord()
            begin
                EmpVar.Get("Employee Code");
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
        EmpVar: Record Employee;
}
