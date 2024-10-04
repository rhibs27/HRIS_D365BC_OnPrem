page 33020052 "Employee Details Entity"
{
    DelayedInsert = true;
    Editable = false;
    EntityName = 'employeeDetailsEntity';
    EntitySetName = 'employeeDetailsEntities';
    PageType = API;
    APIVersion = 'v2.0';
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = Employee;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(No; Rec."No.") { }
                field(FirstName; Rec."First Name") { }
                field(MiddleName; Rec."Middle Name") { }
                field(LastName; Rec."Last Name") { }
                field(Initials; Rec.Initials) { }
                field(Deputationon; Rec."Deputation on") { }
                field(PermanentAddress; Address) { }
                field(TemporaryAddress; "Address 2") { }
                field(SubProvinceName; Rec."Sub Province Name") { }
                field(SubProvinceCode; Rec."Sub Province Code") { }
                field(MobilePhoneNo; Rec."Mobile Phone No.") { }
                field(EMailPersonal; Rec."E-Mail") { }
                field(Picture; Rec.Image) { }
                field(BirthDate; Rec."Birth Date") { }
                field(DepartmentCode; Rec."Department Code") { }
                field(Gender; Rec.Gender) { }
                field(EmploymentDate; Rec."Employment Date") { }
                field(Status; Rec.Status) { }
                field(InactiveDate; Rec."Inactive Date") { }
                field(TerminationDate; Rec."Termination Date") { }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code") { }
                field(Extension; Rec.Extension) { }
                field(CompanyEMail; Rec."Company E-Mail") { }
                field(TitleNA; Title) { }
                field(BankAccountNo; Rec."Bank Account No.") { }
                field(EmployeeWorkShift; Rec."Employee Work Shift") { }
                field(SalaryLevel; Rec."Salary Level") { }
                field(SalaryGrade; Rec."Salary Grade") { }
                field(FullNameNepali; Rec."Full Name (Nepali)") { }
                field(FathersNameNepali; Rec."Father's Name (Nepali)") { }
                field(MothersNameNepali; Rec."Mother's Name (Nepali)") { }
                field(GrandFathersNameNepali; Rec."GrandFather's Name (Nepali)") { }
                field(PANNo; Rec."PAN No.") { }
                field(Age; Rec.Age) { }
                field(MaritalStatus; Rec."Marital Status") { }
                field(CitizenNumber; Rec."Citizen Number") { }
                field(BloodGroup; Rec."Blood Group") { }
                field(EmploymentType; Rec."Employment Type") { }
                field(ProvinceName; Rec."Province Name") { }
                field(Cluster; Rec.Cluster) { }
                field(FullName; Rec."Full Name") { }
                field(OldEmployeeNo; Rec."Old Employee No.") { }
                field(DepartmentName; Rec."Department Name") { }
                field(BranchName; Rec."Branch Name") { }
                field(ExtensionCounterName; Rec."Extension Counter Name") { }
                field(UnitName; Rec."Unit Name") { }
                field(DateofBirthBS; Rec."Date of Birth (B.S.)") { }
                field(CitizenshipIssuePlace; Rec."Citizenship Issue Place") { }
                field(CitizenshipIssueDate; Rec."Citizenship Issue Date") { }
                field(Religion; Rec.Religion) { }
                field(UnitCode; Rec."Unit Code") { }
                field(BranchCategory; Rec."Branch Category") { }
                field(ExperienceYears; Rec."Experience Years") { }
                field(SolId; Rec."Sol Id") { }
                field(ReportingPerson; Rec."Reporting Person") { }
                field(PostingRegion; Rec."Posting Region") { }
                field(FunctionalTitle; Rec."Functional Title") { }
                field(InsideOutisdeValley; Rec."Inside/Outisde Valley") { }
                field(JobTitleCode; Rec."Job Title Code") { }
                field(ServicePeriod; Rec."Service Period") { }
                field(ConvertedToEmpDate; Rec."Converted To Emp. Date") { }
                field(NAVLoginID; Rec."NAV Login ID") { }
                field(PermanentProvince; Rec."Permanent Province") { }
                field(TemporaryProvince; Rec."Temporary Province") { }
                field(KPIDeputation; Rec."KPI Deputation") { }
                field(TemporaryWardNo; Rec."Temporary Ward No") { }
                field(PermanentDistrict; Rec."Permanent District") { }
                field(TemporaryDistrict; Rec."Temporary District") { }
                field(PermanentVDC; Rec."Permanent VDC") { }
                field(TemporaryVDC; Rec."Temporary VDC") { }
                field(PermanentHouse; Rec."Permanent House") { }
                field(TemporaryHouse; Rec."Temporary House") { }
                field(CitizenshipIssuePlaceCode; Rec."Citizenship Issue Place Code") { }
                field(ProvinceCode; Rec."Province Code") { }
                field(WardNo; Rec."Ward No") { }
                field(Office; Rec.Office) { }
                field(EcoSystem; Rec."Eco-System") { }
                field(ContractExpiryDate; Rec."Contract Expiry Date") { }
                field(ResignationDate; Rec."Resignation Date") { }
                field(FunctionalTitleDesc; Rec."Functional Title Desc") { }
                field(SalaryLevelDescription; Rec."Salary Level Description") { }
                field(ContractRenewDate; Rec."Contract Renew Date") { }
                field(ContractExpiryRemainingDays; Rec."Contract Expiry Remaining Days") { }
            }
        }
    }

    actions { }
}
