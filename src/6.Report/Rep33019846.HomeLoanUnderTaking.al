report 33019846 "Home Loan UnderTaking"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019846.HomeLoanUnderTaking.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = const("Home Loan"));
            column(todaydate; "Offer Letter Issued Date") { }
            column(EmployeeCode; "Employee Code") { }
            column(EmployeeName; "Employee Name") { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
            column(ExistingOwnerName; "Name of Owner") { }
            column(ExistingOwnerAddress; "Address of Owner") { }
            column(LocationOfProperty; "Complete Address of Property") { }
            column(PlotNoofProperty; "Plot No. of Property") { }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }
}
