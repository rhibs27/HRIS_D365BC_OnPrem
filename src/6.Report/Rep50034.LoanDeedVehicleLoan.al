report 50034 "Loan Deed Vehicle Loan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019835.LoanDeedVehicleLoan.rdl';
    WordLayout = './src/6.Report/Rep33019835.LoanDeedVehicleLoan.docx';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = filter("Vehicle Loan"));
            column(LoanNo; "No.") { }
            column(EmployeeName; "Employee Name") { }
            column(JobTitle; "Job Title") { }
            column(BranchName; "Branch Name") { }
            column(DepartmentName; "Department Name") { }
            column(RequestedLoanDate; "Offer Letter Date(Nepali)") { }
            column(EmployeeCode; "Employee No.") { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
            column(Age; EmpVar.Age) { }
            column(CurrentYear; CurrentYear) { }
            column(CurrentMonth; CurrentMonth) { }
            column(CurrentDay; CurrentDay) { }
            column(CitizenshipDate; EmpVar."Citizenship Date (B.S.)") { }
            column(EmpName; EmpVar."Full Name (Nepali)") { }
            column(FatherName; EmpVar."Father's Name (Nepali)") { }
            column(GrandfatherName; EmpVar."GrandFather's Name (Nepali)") { }
            column(CitizenshipNo; EmpVar."Citizenship No. (Nepali)") { }
            column(VDCMunicipality; EmpVar."VDC/Municipality (Nepali)") { }
            column(EmpNoNepali; EmpVar."Employee No. (Nepali)") { }
            column(DistrictName; District."District Name") { }
            column(ChoroChori; ChoroChori) { }
            column(NatiNatini; NatiNatini) { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(EmpWardNo; EmpVar."Permanent Ward No") { }
            column(DisbursedAmt; "Disbursed Amount") { }
            column(VehicleModel; "Vehicle Model") { }
            column(VehicleEngineNo; "Vehicle Engine No.") { }
            column(VehicleChasisNo; "Vehicle Chasis No.") { }
            column(VehicleRegistrationNo; "Vehicle Registration No.") { }
            column(VehicleTypeNepali; "Vehicle Type (Nepali)") { }
            column(NameOfSupplier; "Name of Supplier") { }
            column(CostOfVehicle; "Cost of Vehicle") { }
            column(InterestRate; "Interest Rate") { }
            column(RepaymentPeriod; "Repayment Period") { }
            column(EMIAmount; EMI) { }
            column(LicenseNo; "License No.") { }

            trigger OnAfterGetRecord()
            begin
                if EmpVar.Get("Employee No.") then;
                Clear(EngNepaliDate);
                EngNepaliDate.Reset;
                EngNepaliDate.SetRange("English Date", Today);
                if EngNepaliDate.FindFirst then begin
                    CurrentYear := EngNepaliDate."Nepali Year";
                    CurrentMonth := EngNepaliDate."Nepali Month";
                    CurrentDay := EngNepaliDate."Nepali Day";
                end;
                EngNepaliDate.Reset;
                EngNepaliDate.SetRange("English Date", EmpVar."Citizenship Issue Date");
                if EngNepaliDate.FindFirst then;
                ChoroChori := HRMgt.GetChoraChori(EmpVar.Gender);
                NatiNatini := HRMgt.GetNatiNatini(EmpVar.Gender);

                District.Reset;
                District.SetRange("District Code", EmpVar."Citizenship Issue Place Code");
                if District.FindFirst then;
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
        EngNepaliDate: Record "English-Nepali Date";
        CurrentYear: Integer;
        CurrentMonth: Integer;
        CurrentDay: Integer;
        District: Record District;
        ChoroChori: Text;
        NatiNatini: Text;
        HRMgt: Codeunit "HR Mgt.";
}
