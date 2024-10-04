report 33019932 "Loan outstanding check report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019932.LoanOutstandingCheckReport.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.") order(ascending) where(Status = filter(Active));
            RequestFilterFields = Status;
            column(No_Employee; Employee."No.") { }
            dataitem("Loan Outstanding from Finacle"; "Loan Outstanding from Finacle")
            {
                DataItemLink = "Employee No." = field("No.");
                RequestFilterFields = "Scheme Type", "Loan Type", EMI, "Scheme Code";
                column(EMI_LoanOutstandingfromFinacle; "Loan Outstanding from Finacle".EMI) { }
                column(LoanType_LoanOutstandingfromFinacle; "Loan Outstanding from Finacle"."Loan Type") { }
                column(SchemeCode_LoanOutstandingfromFinacle; "Loan Outstanding from Finacle"."Scheme Code") { }
                column(LoanLimit_LoanOutstandingfromFinacle; "Loan Outstanding from Finacle"."Loan Limit") { }
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }
}
