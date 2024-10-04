report 50038 "Delivery Order Vehicle  Loan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019839.DeliveryOrderVehicleLoan.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = const("Vehicle Loan"));
            column(todaydate; "Offer Letter Issued Date") { }
            column(NameofSupplier; "Name of Supplier") { }
            column(AddressofSupplier; "Address of Supplier") { }
            column(EmployeeCode; "Employee Code") { }
            column(EmployeeName; "Employee Name") { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }
}
