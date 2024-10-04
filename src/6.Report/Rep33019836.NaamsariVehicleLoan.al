report 33019836 "Naamsari Vehicle Loan"
{
    // version NIC Asia,Vehicle Loan

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019836.NaamsariVehicleLoan.rdl';
    PdfFontEmbedding = Default;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = filter("Vehicle Loan"));
            column(TodayDate; "Offer Letter Date(Nepali)") { }
            column(VehicleModel; "Vehicle Model") { }
            column(VehicleEngineNo; "Vehicle Engine No.") { }
            column(VehicleChasisNo; "Vehicle Chasis No.") { }
            column(VehicleRegistrationNo; "Vehicle Registration No.") { }
            column(EmployeeCode; "Employee Code") { }
            column(EmpName; EmpVar."Full Name (Nepali)") { }
            column(VehicleTypeNepali; "Vehicle Type (Nepali)") { }

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
