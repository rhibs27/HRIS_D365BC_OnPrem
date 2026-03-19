report 50023 "Employee Master"
{
    ApplicationArea = All;
    Caption = 'Employee Master with payroll';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50023.EmployeeMaster.rdl';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Employment Type", "Province Code", "Branch Code", "Department Code", "Salary Level", Status;
            column(FilterApplied; FilterApplied) { }
            column(No; "No.") { }
            column(FullName; "Full Name") { }
            column(Salutation; Salutation) { }
            column(Gender; Gender) { }
            column(MaritalStatus; "Marital Status") { }
            column(TaxCode; "Tax Code") { }
            column(Address; Address) { }
            column(TemporaryAddress; "Temporary Address") { }
            column(DateofBirthBS; "Date of Birth (B.S.)") { }
            column(BirthDate; "Birth Date") { }
            column(AgeText; "Age Text") { }
            column(CitizenNumber; "Citizen Number") { }
            column(LastQualification; LastQualification) { }
            column(LastGPA; LastGPA) { }
            column(EMail; "E-Mail") { }
            column(CompanyEMail; "Company E-Mail") { }
            column(MobilePhoneNo; "Mobile Phone No.") { }
            column(PhoneNo; "Phone No.") { }
            column(BankAccountNo; "Bank Account No.") { }
            column(AdditionalBankAccountNo; AdditionalBankAccountNo) { }
            column(Disabled; Disabled) { }
            column(DonotCalculateSalary; "Do not Calculate Salary") { }
            column(Status; Status) { }
            column(CauseofInactivityCode; "Cause of Inactivity Code") { }
            column(EmployeeWorkShift; "Employee Work Shift") { }
            column(EmploymentType; "Employment Type") { }
            column(EmploymentDate; "Employment Date") { }
            column(EmplymtContractCode; "Emplymt. Contract Code") { }
            column(EmploymentDateBS; "Employment Date (B.S.)") { }
            column(ConfirmationDate; "Confirmation Date") { }
            column(ConfirmationDateBS; "Confirmation Date (B.S.)") { }
            column(ContractExpiryDate; "Contract Expiry Date") { }
            column(TraineeProbationEnddate; "Trainee/Probation End date") { }
            column(SalaryLevel; "Salary Level") { }
            column(FunctionalTitle; "Functional Title") { }
            column(FunctionalTitleDesc; "Functional Title Desc") { }
            column(SalaryLevelDescription; "Salary Level Description") { }
            column(DeputationOnCode; "Deputation On Code") { }
            column(Deputationon; "Deputation on") { }
            column(ProvinceCode; "Province Code") { }
            column(ProvinceName; "Province Name") { }
            column(BranchCode; "Branch Code") { }
            column(BranchName; "Branch Name") { }
            column(DepartmentCode; "Department Code") { }
            column(DepartmentName; "Department Name") { }
            column(UnitCode; "Unit Code") { }
            column(UnitName; "Unit Name") { }
            column(ExtensionCounterCode; "Extension Counter Code") { }
            column(ExtensionCounterName; "Extension Counter Name") { }
            column(ServicePeriodText; "Service Period Text") { }
            column(LastPlacementDate; Format("Last Placement Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(LastPlacementDateBS; "Last Placement Date (B.S.)") { }
            column(PromotionDate_Employee; Format("Promotion Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(PromotionDateBS_Employee; "Promotion Date (B.S.)") { }
            column(ResignationDate; "Resignation Date") { }
            column(ResignationDateBS; "Resignation Date (B.S.)") { }
            column(PANNo; "PAN No.") { }
            column(PFNo; "PF No.") { }
            column(CITNo; "CIT No.") { }
            column(SocialSecurityNo; "Social Security No.") { }
            column(GratuityNumber; "Gratuity Number") { }
            dataitem("Payroll Attributes Usage"; "Payroll Attributes Usage")
            {
                DataItemLink = "Employee code" = field("No.");
                DataItemLinkReference = Employee;
                DataItemTableView = sorting(Code, "Employee Code") where(Type = const(Benefits), Irregular = const(false));
                column(Code_PayrollAttributesUsage; Code) { }
                column(Description_PayrollAttributesUsage; Description) { }
                column(Amount_PayrollAttributesUsage; Amount) { }
                trigger OnAfterGetRecord()
                var
                    PayrollAttributes: Record "Payroll Attributes";
                    PayrollReportMgt: Codeunit "Payroll Report Mgt.";
                    BasicAmt: Decimal;
                begin
                    PayrollAttributes.Get(Code);
                    if PayrollAttributes.Formula <> '' then begin
                        PayrollReportMgt.SetEmployeeCode(Employee."No.");
                        //  BasicAmt := PayrollReportMgt.GetBasicAmount(Employee."No.");
                        Amount := PayrollReportMgt.EvaluateAmount(PayrollAttributes.Formula, BasicAmt);
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                PayrollAttrUses: Record "Payroll Attributes Usage";
                ImportPayrollAttributes: Report "Import Payroll Attributes";
                PayrollReportMgt: Codeunit "Payroll Report Mgt.";
            begin
                // Get Last Qualification and GPA
                LastQualification := '';
                LastGPA := 0;
                AdditionalBankAccountNo := '';

                //check if payroll attribute usage exist for employee
                PayrollAttrUses.SetRange("Employee Code", Employee."No.");
                if PayrollAttrUses.IsEmpty() then begin
                    Clear(ImportPayrollAttributes);
                    ImportPayrollAttributes.SetEmployeeNo(Employee."No.");
                    ImportPayrollAttributes.UseRequestPage(false);
                    ImportPayrollAttributes.Run();
                    Commit();
                end;

                //get payroll attribute uses values.
                PayrollReportMgt.GetPayrollAttributes(Employee);

                EmployeeQualification.SetRange("Employee No.", Employee."No.");
                EmployeeQualification.SetRange("Emp Qualification Type", EmployeeQualification."Emp Qualification Type"::Education);
                EmployeeQualification.SetRange(Running, true);
                if EmployeeQualification.FindLast() then begin
                    LastQualification := EmployeeQualification."Qualification Code";  //get the running one
                    LastGPA := EmployeeQualification.CGPA;
                    if LastGPA = 0 then
                        LastGPA := EmployeeQualification.Percentage
                end;

                if LastQualification = '' then begin
                    EmployeeQualification.SetRange(Running, false);
                    EmployeeQualification.SetCurrentKey(Year);
                    if EmployeeQualification.FindLast() then begin
                        LastQualification := EmployeeQualification."Qualification Code";  //get the latest one
                        LastGPA := EmployeeQualification.CGPA;
                        if LastGPA = 0 then
                            LastGPA := EmployeeQualification.Percentage
                    end;
                end;

                EmployeeBankAccount.SetRange("Employee No.", Employee."No.");
                EmployeeBankAccount.SetRange("Primary Payroll Account", false);
                if EmployeeBankAccount.FindFirst() then begin
                    AdditionalBankAccountNo := EmployeeBankAccount."Bank Account No.";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if EmploymentTypeFilter <> EmploymentTypeFilter::" " then
                    Employee.SetRange("Employment Type", EmploymentTypeFilter);
                if not GuiAllowed then
                    Employee.SetRange("Status", EmployeeStatusFilter); // Default to Active if not passed
                if BranchCodeFilter <> '' then
                    Employee.SetRange("Branch Code", BranchCodeFilter);
                if EmployeeFulter <> '' then
                    Employee.SetRange("No.", EmployeeFulter);
                Employee.SetCurrentKey(Seniority);
                Employee.Ascending(false);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }
        actions
        {
            area(Processing) { }
        }
    }
    trigger OnPreReport()
    begin
        if GuiAllowed then
            FilterApplied := Employee.GetFilters();
    end;

    var
        EmployeeQualification: Record "Employee Qualification";
        EmployeeBankAccount: Record "Employee Bank Account";

        LastQualification: Text[100];
        LastGPA: Decimal;
        AdditionalBankAccountNo: Text[50];
        FilterApplied: Text[100];

        EmploymentTypeFilter: Enum "Employee Type";
        BranchCodeFilter, EmployeeFulter : code[20];
        EmployeeStatusFilter: Enum "Employee Status";


    procedure PassParPortal(EmploymentType: Enum "Employee Type"; EmployeeStatus: Enum "Employee Status"; BranchCode: Code[20]; EmployeeNo: Code[20])
    begin
        EmploymentTypeFilter := EmploymentType;
        EmployeeStatusFilter := EmployeeStatus;
        BranchCodeFilter := BranchCode;
        EmployeeFulter := EmployeeNo;
    end;
}
