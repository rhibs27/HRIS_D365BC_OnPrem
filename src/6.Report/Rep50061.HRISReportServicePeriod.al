report 50061 "HRIS Report - Service Period"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019862.HRISReportServicePeriod.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(No_; "No.") { }
            column(FullName_; "Full Name") { }
            column(Gender_; Gender) { }
            column(DeputationOn_; "Deputation on") { }
            column(DeputationCode; DeputationCode) { }
            column(DeputationValue; DeputationValue) { }
            column(ProvinceName_; "Province Name") { }
            // column(SubProvinceName_; "Sub Province Name") { }
            // column(EcoSystem_; "Eco-System") { }
            // column(Cluster_; Cluster) { }
            column(BranchName_; "Branch Name") { }
            column(DepartmentName_; "Department Name") { }
            column(FunctionalTitleDesc_; "Functional Title Desc") { }
            column(Status_; Status) { }
            column(EmploymentType_; "Employment Type") { }
            column(SalaryLevel_; "Salary Level") { }
            column(EmploymentDate_; "Employment Date") { }
            column(EmploymentDateNepali_; HRMgt.GetNepaliDate(Employee."Employment Date")) { }
            column(ConfirmationDate_; "Confirmation Date") { }
            column(ConfirmationNepaliDate_; HRMgt.GetNepaliDate(Employee."Confirmation Date")) { }
            column(LastPromotionDate_; "Promotion Date") { }
            column(LastPromotionNepaliDate_; HRMgt.GetNepaliDate(Employee."Promotion Date")) { }
            column(LastPlacementDate_; "Last Placement Date") { }
            column(LastPlacementNepaliDate_; HRMgt.GetNepaliDate(Employee."Last Placement Date")) { }
            column(ContractExpiryPeriod_; "Contract Expiry Month") { }
            column(ContractExpiryDate_; "Contract Expiry Date") { }
            column(MobileNo_; "Mobile Phone No.") { }
            column(PhoneNo_; "Phone No.") { }
            column(BirthDate_; "Birth Date") { }
            column(CompanyEmail_; "Company E-Mail") { }
            column(NavLogInID_; "NAV Login ID") { }
            column(SalaryGrade_; "Salary Grade") { }
            column(BankAccountNo_; "Bank Account No.") { }
            column(PermanentAddress_; Address) { }
            column(CurrentAddress_; "Address 2") { }
            column(MaritalStatus_; "Marital Status") { }
            column(CitizenshipNo_; "Citizen Number") { }
            column(CitizenshipIssuePlace_; "Citizenship Issue Place") { }
            column(CitizenshipIssueDate_; "Citizenship Issue Date") { }
            column(ServiceYear; ServiceYear) { }
            column(Age_; Age) { }
            column(FatherName_; GetRelativeName(1)) { }
            column(GrandFatherName_; GetRelativeName(5)) { }
            column(MotherName_; GetRelativeName(2)) { }
            column(SpouseName_; GetRelativeName(7)) { }

            trigger OnAfterGetRecord()
            begin
                ExitTransferDeputationWise("Deputation on");
                if "Employment Date" <> 0D then
                    ServiceYear := Round((Today - "Employment Date") / 365, 0.01, '=');
                if "Birth Date" <> 0D then
                    Age := Round((Today - "Birth Date") / 365, 1, '<');
                Modify;
                Clear(SalaryLevel);
                if SalaryLevel.Get(Employee."Salary Level") then;
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
        DimValue: Record "Dimension Value";
        // Depart: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        Province: Record Province;
        // SubProvince: Record "Sub Province";
        GLSetup: Record "General Ledger Setup";
        DeputationCode: Text;
        DeputationValue: Text;
        HRMgt: Codeunit "HR Mgt.";
        ServiceYear: Decimal;
        EmployeeRelative: Record "Employee Relative";
        SalaryLevel: Record "Salary Level";

    local procedure ExitTransferDeputationWise(DeputationOn: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department)
    begin
        // Clear(DimValue);
        // Clear(Depart);
        // Clear(EmpHie);
        // Clear(SubProvince);
        // Clear(Province);
        Clear(DeputationCode);
        Clear(DeputationValue);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    // if DimValue.Get(GLSetup."Global Dimension 1 Code", Employee."Global Dimension 1 Code") then begin
                    DeputationValue := Employee."Branch Name";
                    DeputationCode := Employee."Global Dimension 1 Code";
                    // end;
                end;

            DeputationOn::Department:
                begin
                    // if Depart.Get(Employee."Department Code") then begin
                    DeputationValue := Employee."Department Name";
                    DeputationCode := Employee."Department Code";
                    // end;
                end;

            DeputationOn::"Extension Counter":
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    // EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    // if EmpHie.FindFirst then begin
                    DeputationValue := Employee."Extension Counter Name";
                    DeputationCode := Employee."Extension Counter Code";
                    // end;
                end;

            // DeputationOn::"Sub Province":
            //     begin
            //         SubProvince.Reset;
            //         SubProvince.SetRange(Code, Employee."Sub Province Code");
            //         if SubProvince.FindFirst then begin
            //             DeputationValue := SubProvince.City;
            //             DeputationCode := SubProvince.Code;
            //         end;
            //     end;

            DeputationOn::Unit:
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    // EmpHie.SetRange(Code, Employee."Unit Code");
                    // if EmpHie.FindFirst then begin
                    DeputationValue := Employee."Unit Name";
                    DeputationCode := Employee."Unit Code";
                    // end;
                end;

            DeputationOn::Province:
                begin
                    // if Province.Get(Employee."Province Code") then begin
                    DeputationValue := Employee."Province Name";
                    DeputationCode := Employee."Province Code";
                    // end;
                end;
        end;
    end;

    local procedure GetRelativeName(Relationship: Option " ",Father,Mother,"Father In Law","Mother In Law",GrandFather,"Spouse Grandfather",Spouse): Text
    var
        Relative: Record Relative;
    begin
        Clear(EmployeeRelative);
        Clear(Relative);
        Relative.SetRange(Relation, Relationship);
        if Relative.FindFirst then;
        EmployeeRelative.SetRange("Employee No.", Employee."No.");
        EmployeeRelative.SetRange("Relative Code", Relative.Code);
        if EmployeeRelative.FindFirst then
            exit(EmployeeRelative."Full Name");
    end;
}
