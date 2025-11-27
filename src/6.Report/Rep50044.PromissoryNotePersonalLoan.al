report 50044 "Promissory Note Personal Loan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019845.PromissoryNotePersonalLoan.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = const("Personal Loan"));
            column(RequestedLoanDate; "Offer Letter Date(Nepali)") { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
            column(EmployeeCode; "Employee No.") { }
            column(DisbursedAmt; "Disbursed Amount") { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(OfferLetterIssuedDate; "Offer Letter Date(Nepali)") { }
            column(EmpNameNepali; EmpVar."Full Name (Nepali)") { }
            column(EmpCodeNepali; EmpVar."Employee No. (Nepali)") { }

            trigger OnAfterGetRecord()
            begin
                EmpVar.Get("Employee No.");
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
