report 50036 "Offer Letter Vehicle Loan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019837.OfferLetterVehicleLoan.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = filter("Vehicle Loan"));
            column(TodayDate; "Offer Letter Issued Date") { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
            column(InterestRate; "Interest Rate") { }
            column(RepaymentPeriod; "Repayment Period") { }
            column(PaybackMonths; "Payback Months") { }
            column(EMI; EMI) { }
            column(VehicleModel; "Vehicle Model") { }
            column(VehicleEngineNo; "Vehicle Engine No.") { }
            column(VehicleChasisNo; "Vehicle Chasis No.") { }
            column(VehicleRegistrationNo; "Vehicle Registration No.") { }
            column(EmployeeCode; EmpVar."Employee No. (Nepali)") { }
            column(EmployeeName; EmpVar."Full Name (Nepali)") { }
            column(EmployeeCodeNeplai; EmpVar."Employee No. (Nepali)") { }
            column(DisbursedAmt; "Disbursed Amount") { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(VehicleTypeNepali; "Vehicle Type (Nepali)") { }

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
