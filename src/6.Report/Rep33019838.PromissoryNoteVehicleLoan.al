report 33019838 "Promissory Note Vehicle Loan"
{
    // version NIC Asia,Vehicle Loan

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019838.PromissoryNoteVehicleLoan.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = filter("Vehicle Loan"));
            column(TodayDate; "Offer Letter Date(Nepali)") { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
            column(EmployeeCode; EmpVar."Employee No. (Nepali)") { }
            column(DisbursedAmt; "Disbursed Amount") { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(OfferLetterIssuedDate; "Offer Letter Date(Nepali)") { }
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
