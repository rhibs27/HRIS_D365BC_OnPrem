report 50050 "Employee KYE Report"
{
    ApplicationArea = All;
    Caption = 'Employee KYE Report';
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50050.EmployeeKYEReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Employee; Employee)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";

            column(PrintedOn; CurrentDateTime) { }
            column(PrintedBy; UserId) { }
            column(No_Employee; Employee."No.") { }
            column(FullName_Employee; Employee."Full Name") { }
            column(DateofBirthBS_Employee; Employee."Date of Birth (B.S.)") { }
            column(Gender_Employee; Employee.Gender) { }
            column(PermanentAddress_Employee; Employee.Address) { }
            column(MaritalStatus_Employee; Employee."Marital Status") { }
            column(DepartmentName_Employee; Employee."Department Name") { }
            column(SalaryLevel_Employee; Employee."Salary Level Description") { }
            column(FunctionalTitleDesc_Employee; Employee."Functional Title Desc") { }
            column(PANNo_Employee; Employee."PAN No.") { }
            column(Employment_Type; "Employment Type") { }
            column(Temporary_Address; Employee."Temporary Address") { }
            column(Residential_Address; Employee."Temporary Address") { }  //to avoid error
            column(Citizen_Number; Employee."Citizen Number") { }
            column(NID_No; Employee."NID No") { }
            column(Passport_Number; Employee."Passport Number") { }
            column(Driving_License_No_; Employee."Driving License No.") { }
            column(Bank_Account_No_; Employee."Bank Account No.") { }
            column(Mobile_Phone_No_; Employee."Mobile Phone No.") { }
            column(Company_E_Mail; Employee."Company E-Mail") { }
            column(Employee_Attendance_ID; Employee."Employee Attendance ID") { }
            column(Branch_Name; Employee."Branch Name") { }
            column(Image; Employee.Image) { }
            column(Employment_Type__To_; Appointed."Employment Type (To)") { }
            column(DeputationValueTo_Appointed; Appointed."Deputation Value (To)") { }
            column(SalaryLevelDescTo_Appointed; Appointed."Salary Level Desc. (To)") { }
            column(EffectiveDate_Appointed; Format(Appointed."Effective Date") + '(' + Appointed."Effective Date (B.S.)" + ')') { }
            column(FunctionalTitleDescTo_Appointed; Appointed."Functional Title Desc. (To)") { }
            column(SalaryLevelTo_Appointed; Appointed."Salary Level (To)") { }
            column(Duration_Appointed; Appointed.Duration) { }
            column(BranchDescriptionTo_Appointed; Appointed."Branch Description (To)")
            {
            }
            column(DepartmentDescriptionTo_Appointed; Appointed."Department Description (To)")
            {
            }
            column(Employment_Type__To__Confirmation; Confirmation."Employment Type (To)") { }
            column(DeputationValueTo_Confirmation; Confirmation."Deputation Value (To)") { }
            column(SalaryLevelDescTo_Confirmation; Confirmation."Salary Level Desc. (To)") { }
            column(EffectiveDate_Confirmation; Format(Confirmation."Effective Date") + '(' + Confirmation."Effective Date (B.S.)" + ')') { }
            column(FunctionalTitleDescTo_Confirmation; Confirmation."Functional Title Desc. (To)") { }
            column(SalaryLevelTo_Confirmation; Confirmation."Salary Level (To)") { }
            column(Duration_Confirmation; Confirmation.Duration) { }
            column(BranchDescriptionTo_Confirmation; Confirmation."Branch Description (To)")
            {
            }
            column(DepartmentDescriptionTo_Confirmation; Confirmation."Department Description (To)")
            {
            }

            dataitem(Promotion; "Employee Service History")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Effective Date") order(descending) where("Service Event" = filter(Promotion | "Internal Appointment" | "Promotion Through Job Evaluation"));
                column(ServiceEvent_Promotion; Promotion."Service Event") { }
                column(SalaryLevelTo_Promotion; Promotion."Salary Level (To)") { }
                column(FunctionalTitleTo_Promotion; Promotion."Functional Title (To)") { }
                column(EffectiveDate_Promotion; Format(Promotion."Effective Date") + '(' + Promotion."Effective Date (B.S.)" + ')') { }
                column(SalaryLevelFrom_Promotion; Promotion."Salary Level (From)") { }
                column(FunctionalTitleFrom_Promotion; Promotion."Functional Title (From)") { }
                column(SalarylevelDescFrom_Promotion; Promotion."Salary level Desc. (From)") { }
                column(SalaryLevelDescTo_Promotion; Promotion."Salary Level Desc. (To)") { }
                column(DeputationValueTo_Promotion; Promotion."Deputation Value (To)") { }
                column(DeputationOnTo_Promotion; Promotion."Deputation On (To)") { }
                column(FunctionalTitleDescTo_Promotion; Promotion."Functional Title Desc. (To)") { }
                column(PromotionPeriod; promotion.Duration) { }
                column(SNPromotion; SNPromotion) { }
                trigger OnAfterGetRecord()
                begin
                    if Promotion."Service Event" = Promotion."Service Event"::Promotion then
                        SNPromotion := SNPromotion + 1;
                end;

                trigger OnPreDataItem()
                begin
                    SNPromotion := 0;
                end;
            }

            dataitem(Transfer; "Employee Service History")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Effective Date") order(descending) where("Service Event" = filter(Transfer | "Temporary Deputation" | "Back From Deputation" | "Officiating Arrangement"));
                column(EffectiveDate_Transfer; Format(Transfer."Effective Date") + '(' + Transfer."Effective Date (B.S.)" + ')') { }
                column(ServiceEvent_Transfer; Transfer."Service Event") { }
                column(SalarylevelDescFrom_Transfer; Transfer."Salary level Desc. (From)") { }
                column(SalaryLevelDescTo_Transfer; Transfer."Salary Level Desc. (To)") { }
                column(DeputationValueTo_Transfer; Transfer."Deputation Value (To)") { }
                column(SNTransfer; SNTransfer) { }
                column(DeputationOnTo_Transfer; Transfer."Deputation On (To)") { }
                column(DeputationOnFrom_Transfer; Transfer."Deputation On(From)") { }
                column(DeputationValueFrom_Transfer; Transfer."Deputation Value (From)") { }
                column(FunctionalTitleDescFrom_Transfer; Transfer."Functional Title Desc. (From)") { }
                column(FunctionalTitleDescTo_Transfer; Transfer."Functional Title Desc. (To)") { }
                column(Duration_Transfer; Transfer.Duration) { }
                column(BranchDescriptionFrom_Transfer; "Branch Description (From)")
                {
                }
                column(BranchDescriptionTo_Transfer; "Branch Description (To)")
                {
                }
                column(DepartmentDescriptionFrom_Transfer; "Department Description (From)")
                {
                }
                column(DepartmentDescriptionTo_Transfer; "Department Description (To)")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Transfer."Service Event" = Transfer."Service Event"::Transfer then
                        SNTransfer := SNTransfer + 1;
                end;

                trigger OnPreDataItem()
                begin
                    SNTransfer := 0;
                end;
            }
            dataitem("Employee Qualification"; "Employee Qualification")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Year") order(descending) where("Emp Qualification Type" = filter(Education));
                column(InstitutionCompany_EmployeeQualification; "Employee Qualification"."Institution/Company") { }
                column(Stream_EmployeeQualification; "Employee Qualification".Stream) { }
                column(Year_EmployeeQualification; "Employee Qualification".Year) { }
                column(Percentage_EmployeeQualification; "Employee Qualification".Percentage) { }
                column(FromDate_EmployeeQualification; Format("Employee Qualification"."From Date")) { }
                column(ToDate_EmployeeQualification; Format("Employee Qualification"."To Date")) { }
                column(Rank_EmployeeQualification; "Employee Qualification".Rank) { }
                column(TimePeriod_EmployeeQualification; "Employee Qualification"."Time Period") { }
                column(SNEducation; SNEducation) { }
                column(QualificationCode_EmployeeQualification; "Employee Qualification"."Qualification Code") { }
                column(GPAScale_EmployeeQualification; "Employee Qualification"."GPA Scale") { }
                column(CGPA_EmployeeQualification; "Employee Qualification".CGPA) { }

                trigger OnAfterGetRecord()
                begin
                    if "Employee Qualification"."Institution/Company" <> '' then
                        SNEducation := SNEducation + 1;
                end;

                trigger OnPreDataItem()
                begin
                    SNEducation := 0;
                end;
            }
            dataitem(Experience; "Employee Qualification")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Employee No.", "Line No.") where("Emp Qualification Type" = filter(Work));
                column(InstitutionCompany_Experience; Experience."Institution/Company") { }
                column(Designation_Experience; Experience.Designation) { }
                column(TimePeriod_Experience; Experience."Time Period") { }
                column(FromDate_Experience; Format(Experience."From Date")) { }
                column(ToDate_Experience; Format(Experience."To Date")) { }
                column(Year_Experience; Experience.Year) { }
                column(SNExperience; SNExperience) { }
                column(Stream_Experience; Experience.Stream) { }

                trigger OnAfterGetRecord()
                begin
                    if Experience."Institution/Company" <> '' then
                        SNExperience := SNExperience + 1;
                end;

                trigger OnPreDataItem()
                begin
                    SNExperience := 0;
                end;
            }
            dataitem(Relative; "Employee Relative")
            {
                DataItemLinkReference = Employee;
                DataItemLink = "Employee No." = field("No.");
                column(Relation_Relative; Relative.Relationship) { }
                column(FullName_Relative; Relative."Full Name") { }
                column(Age_Relative; Relative.Age) { }
                column(Occupation_Relative; '') { }
                column(ContactNo_Relative; Relative."Phone No.") { }
                column(Birth_Date_Relative; Format(Relative."Birth Date")) { }
                column(Citizenship_No_Relative; Relative."Citizenship No.") { }
                column(SNRelatives; SNRelatives) { }
                trigger OnAfterGetRecord()
                begin
                    if Relative."Line No." <> 0 then
                        SNRelatives := SNRelatives + 1;
                end;

                trigger OnPreDataItem()
                begin
                    SNRelatives := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Appointed.SetRange("Employee No.", Employee."No.");
                Appointed.SetRange("Service Event", Appointed."Service Event"::Appointment);
                if Appointed.FindFirst() then;
                Confirmation.SetRange("Employee No.", Employee."No.");
                Confirmation.SetRange("Service Event", Confirmation."Service Event"::Confirmation);
                if Confirmation.FindFirst() then;
            end;

        }
    }

    requestpage
    {
        SaveValues = true;

    }

    trigger OnPreReport()
    begin
        if Employee.GetFilter("No.") = '' then
            Error('Please select Employee No. in the filter to run the report.');
    end;

    var
        SNTransfer: Integer;
        SNEducation: Integer;
        SNExperience: Integer;
        SNTraining, SNRelatives : Integer;
        SNPromotion: Integer;
        Appointed, Confirmation : Record "Employee Service History";
}
