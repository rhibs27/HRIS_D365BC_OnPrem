report 50042 "Guarantee Personal Loan"
{
    RDLCLayout = './src/6.Report/Rep33019843.GuaranteePersonalLoan.rdl';
    WordLayout = './src/6.Report/Rep33019843.GuaranteePersonalLoan.docx';
    DefaultLayout = Word;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            DataItemTableView = where("Loan Type" = const("Personal Loan"));
            column(Age; EmpVar.Age) { }
            column(EmpCode; EmpVar."No.") { }
            column(AppliedLoanAdvance; "Applied Loan/Advance") { }
            column(TodayDate; "Offer Letter Date(Nepali)") { }
            column(EmployeeNameinNepali; EmpVar."Full Name (Nepali)") { }
            column(FathersNameInNepali; EmpVar."Father's Name (Nepali)") { }
            column(GrandfathersNameInNepali; EmpVar."GrandFather's Name (Nepali)") { }
            column(GuarantorsVDCMunicipality; EmpRelative."VDC/Municipality") { }
            column(GuarantorWardNo; EmpRelative."Ward No") { }
            column(GuarantorsCitizenshipN; EmpRelative."Citizenship No.") { }
            column(GuarantorAge; EmpRelative.Age) { }
            column(GuarantorCitizenshipDate; EmpRelative."Citizenship Date (Nepali)") { }
            column(GuarantorNameNepali; EmpRelative."Name(Nepali)") { }
            column(GurarantorFathersName; EmpRelative."Fathers Name(Nepali)") { }
            column(GuarantrorGrandFather; EmpRelative."GrandFather Name(Nepali)") { }
            column(GuarantorSpouseName; EmpVar."Full Name (Nepali)") { }
            column(EmployeeCitizenshipNo; EmpVar."Citizenship No. (Nepali)") { }
            column(EmployeeVDCMunicipality; EmpVar."VDC/Municipality (Nepali)") { }
            column(EmployeeNoNepali; EmpVar."Employee No. (Nepali)") { }
            column(EmployeeCitizenshipIssueDate; EmpVar."Citizenship Date(Nepali)") { }
            column(AmountInWordsNepali; "Amount In Words (Nepali)") { }
            column(EmployeeWardNo; Format(EmpVar."Ward No")) { }
            column(CurrentYear; Format(CurrentYear)) { }
            column(CurrentMonth; Format(CurrentMonth)) { }
            column(CurrentDay; Format(CurrentDay)) { }
            column(ChoroChori; ChoroChori) { }
            column(NatiNatini; NatiNatini) { }
            column(GuarantorDistrict; GuarantorDistrict."District Name(Nepali)") { }
            column(EmployeeDistrict; EmpDistrict."District Name(Nepali)") { }
            column(GuarantorIssueDistrict; GuarantorCitizenDistrict."District Name(Nepali)") { }

            trigger OnAfterGetRecord()
            begin
                EmpVar.Get("Employee Code");

                Clear(EmpDistrict);
                EmpDistrict.SetRange("District Code", EmpVar."Citizenship Issue Place Code");
                if EmpDistrict.FindFirst then;

                Clear(GuarantorDistrict);
                EmpRelative.Reset;
                EmpRelative.SetRange("Employee No.", EmpVar."No.");
                EmpRelative.SetRange("Relative Code", HRSetup."Spouse Code");
                if EmpRelative.FindFirst then;

                GuarantorDistrict.Reset;
                GuarantorDistrict.SetRange("District Code", EmpRelative.District);
                if GuarantorDistrict.FindFirst then;

                GuarantorCitizenDistrict.Reset;
                GuarantorCitizenDistrict.SetRange("District Code", EmpRelative."Citizenship Issued District");
                if GuarantorCitizenDistrict.FindFirst then;

                Clear(EngNepaliDate);
                EngNepaliDate.SetRange("English Date", Today);
                if EngNepaliDate.FindFirst then begin
                    CurrentYear := EngNepaliDate."Nepali Year";
                    CurrentMonth := EngNepaliDate."Nepali Month";
                    CurrentDay := EngNepaliDate."Nepali Day";
                end;

                Clear(EngNepaliDate);
                EngNepaliDate.SetRange("English Date", "Offer Letter Issued Date");
                if EngNepaliDate.FindFirst then;

                GuarantorEnglishNepDate.Reset;
                GuarantorEnglishNepDate.SetRange("English Date", EmpRelative."Citizenship Date");
                if GuarantorEnglishNepDate.FindFirst then;

                EmpEnglishNepDate.Reset;
                EmpEnglishNepDate.SetRange("English Date", EmpVar."Citizenship Issue Date");
                if EmpEnglishNepDate.FindFirst then;

                ChoroChori := HRMgt.GetChoraChori(EmpVar.Gender);
                NatiNatini := HRMgt.GetNatiNatini(EmpVar.Gender);
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        HRSetup.Get;
    end;

    var
        EmpVar: Record Employee;
        EmpDistrict: Record District;
        GuarantorDistrict: Record District;
        CurrentYear: Integer;
        CurrentMonth: Integer;
        CurrentDay: Integer;
        EngNepaliDate: Record "English-Nepali Date";
        GuarantorEnglishNepDate: Record "English-Nepali Date";
        EmpEnglishNepDate: Record "English-Nepali Date";
        ChoroChori: Text;
        NatiNatini: Text;
        HRMgt: Codeunit "HR Mgt.";
        HRSetup: Record "Human Resources Setup";
        EmpRelative: Record "Employee Relative";
        GuarantorCitizenDistrict: Record District;
}
