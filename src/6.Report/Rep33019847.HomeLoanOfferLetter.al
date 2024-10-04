report 33019847 "Home Loan Offer Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019847.HomeLoanOfferLetter.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            column(EmployeeCode; EmpVar."Employee No. (Nepali)") { }
            column(NepaliName; EmpVar."Full Name (Nepali)") { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
            column(DisbursedAmount; "Disbursed Amount") { }
            column(EMI; EMI) { }
            column(TodayDate; "Employee Loan/Advance"."Offer Letter Date(Nepali)") { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(ProposedOwnerNepali; "Proposed Owner (Nepali)") { }
            column(AddressofPropertyNepali; "Address of Property (Nepali)") { }
            column(InterestRate; "Interest Rate") { }
            column(PlotNo; "Plot No. of Property") { }
            column("Area"; "Area of Plot") { }
            column(LoanExpiryDateNepal; "Loan Expiry Date( Nepali)") { }

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
