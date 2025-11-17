report 50040 "Personal Loan Deed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019841.PersonalLoanDeed.rdl';
    WordLayout = './src/6.Report/Rep33019841.PersonalLoanDeed.docx';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = const("Personal Loan"));
            RequestFilterFields = "No.";
            column(EmployeeCode; "Employee No.") { }
            column(EmployeeName; EmpVar."Full Name (Nepali)") { }
            column(CitizenShipIssueDate; EmpVar."Citizenship Date (B.S.)") { }
            column(Age; EmpVar.Age) { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
            column(CurrentYear; Format(CurrentYear)) { }
            column(CurrentMonth; Format(CurrentMonth)) { }
            column(CurrentDay; Format(CurrentDay)) { }
            column(FatherName; EmpVar."Father's Name (Nepali)") { }
            column(GranfatherName; EmpVar."GrandFather's Name (Nepali)") { }
            column(VDCMunicipalty; EmpVar."VDC/Municipality (Nepali)") { }
            column(ChoroChori; ChoroChori) { }
            column(NatiNatini; NatiNatini) { }
            column(DisbursedAmt; "Disbursed Amount") { }
            column(DistrictName; District."District Name(Nepali)") { }
            column(VDCMunName; EmpVar."VDC/Municipality (Nepali)") { }
            column(CitizenshipNoNepali; EmpVar."Citizenship No. (Nepali)") { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(EmpNoNepali; EmpVar."Employee No. (Nepali)") { }
            column(WardNo; Format(EmpVar."Permanent Ward No")) { }
            column(EmpDistrict; EmpDistrict) { }
            column(OfferDate; "Offer Letter Date(Nepali)") { }

            trigger OnAfterGetRecord()
            begin
                EmpVar.Get("Employee No.");
                Clear(EngNepaliDate);
                Clear(District);
                District.SetRange("District Name", EmpVar."Permanent District");
                if District.FindFirst then
                    EmpDistrict := District."District Name(Nepali)";

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

                Clear(District);
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
        CurrentYear: Integer;
        CurrentMonth: Integer;
        CurrentDay: Integer;
        EngNepaliDate: Record "English-Nepali Date";
        ChoroChori: Text;
        NatiNatini: Text;
        HRMgt: Codeunit "HR Mgt.";
        District: Record District;
        EmpDistrict: Text;
}
