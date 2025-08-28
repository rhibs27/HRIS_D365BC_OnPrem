report 50124 "Employee Profile Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019925.EmployeeProfileDetails.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyOneLineAddress; CompanyOneLineAddress) { }
            column(CompanyCommunicationAddress; CompanyCommunicationAddress) { }
            column(CompanyInfoVATRegNo; CompanyInfo.FieldCaption("VAT Registration No.") + ' : ' + CompanyInfo."VAT Registration No.") { }
            column(PrintedOn; CurrentDateTime) { }
            column(PrintedBy; UserId) { }
            column(No_Employee; Employee."No.") { }
            column(FullName_Employee; Employee."Full Name") { }
            column(FathersNameNepali_Employee; Employee."Father's Name (Nepali)") { }
            column(GrandFathersNameNepali_Employee; Employee."GrandFather's Name (Nepali)") { }
            column(DateofBirthBS_Employee; Employee."Date of Birth (B.S.)") { }
            column(ConfirmationDate_Employee; Format(Employee."Confirmation Date")) { }
            column(Age_Employee; Employee.Age) { }
            column(Gender_Employee; Employee.Gender) { }
            column(PermanentAddress_Employee; Employee.Address) { }
            column(PermanentDistrict_Employee; Employee."Permanent District") { }
            column(TemporaryDistrict_Employee; Employee."Temporary District") { }
            column(PermanentProvince_Employee; Employee."Permanent Province") { }
            column(TemporaryProvince_Employee; Employee."Temporary Province") { }
            column(PermanentSubProvince_Employee; Employee."KPI Deputation") { }
            column(TemporaryWardNo_Employee; Employee."Temporary Ward No") { }
            column(PermanentVDC_Employee; Employee."Permanent VDC") { }
            column(TemporaryVDC_Employee; Employee."Temporary VDC") { }
            column(PermanentHouse_Employee; Employee."Permanent House") { }
            column(TemporaryHouse_Employee; Employee."Temporary House") { }
            column(EmploymentDate_Employee; Format(Employee."Employment Date")) { }
            column(MaritalStatus_Employee; Employee."Marital Status") { }
            column(WardNo_Employee; Employee."Permanent Ward No") { }
            column(TemporaryAddress_Employee; Employee."Address 2") { }
            column(DepartmentName_Employee; Employee."Department Name") { }
            column(SalaryLevel_Employee; Employee."Salary Level") { }
            column(FunctionalTitleDesc_Employee; Employee."Functional Title Desc") { }
            column(PANNo_Employee; Employee."PAN No.") { }
            column(Position; Position) { }
            column(DeputationValueToAppointment; DeputationValueToAppointment) { }
            column(FunctionalTitleDescToAppointment; FunctionalTitleDescToAppointment) { }
            column(SalaryLevelDescToAppointment; SalaryLevelDescToAppointment) { }
            column(EffectiveDateAppointment; Format(EffectiveDateAppointment)) { }
            column(AppointmentPeriod; AppointmentPeriod) { }
            column(FatherName_; GetRelativeName(1)) { }
            column(DeputationCode; DeputationCode) { }
            column(DeputationValue; DeputationValue) { }
            column(ConfirmationPeriod; ConfirmationPeriod) { }
            column(LastTransferDate; Format(LastTransferDate)) { }
            dataitem(Promotion; "Employee Service History")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = where("Service Event" = filter(Promotion | Confirmation | "Internal Appointment" | "Promotion Through Job Evaluation"));
                column(ServiceEvent_Promotion; Promotion."Service Event") { }
                column(SalaryLevelTo_Promotion; Promotion."Salary Level (To)") { }
                column(FunctionalTitleTo_Promotion; Promotion."Functional Title (To)") { }
                column(EffectiveDate_Promotion; Format(Promotion."Effective Date")) { }
                column(SalaryLevelFrom_Promotion; Promotion."Salary Level (From)") { }
                column(FunctionalTitleFrom_Promotion; Promotion."Functional Title (From)") { }
                column(SalarylevelDescFrom_Promotion; Promotion."Salary level Desc. (From)") { }
                column(SalaryLevelDescTo_Promotion; Promotion."Salary Level Desc. (To)") { }
                column(DeputationValueTo_Promotion; Promotion."Deputation Value (To)") { }
                column(DeputationOnTo_Promotion; Promotion."Deputation On (To)") { }
                column(FunctionalTitleDescTo_Promotion; Promotion."Functional Title Desc. (To)") { }
                column(PromotionPeriod; PromotionPeriod) { }

                trigger OnAfterGetRecord()
                begin
                    //SetRange("Service Event","Service Event"::Promotion);
                    if Promotion."Effective Date" <> 0D then
                        PromotionPeriod := Round((Today - Promotion."Effective Date") / 365, 0.1, '=');
                end;

                trigger OnPreDataItem()
                begin
                    //SetRange("Service Event","Service Event"::Promotion);
                    Clear(PromotionPeriod);
                end;
            }
            dataitem(Appointed; "Employee Service History")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = where("Service Event" = filter(Appointment));
                column(DeputationValueTo_Appointed; Appointed."Deputation Value (To)") { }
                column(SalaryLevelDescTo_Appointed; Appointed."Salary Level Desc. (To)") { }
                column(EffectiveDate_Appointed; Format(Appointed."Effective Date")) { }
                column(FunctionalTitleDescTo_Appointed; Appointed."Functional Title Desc. (To)") { }
                column(SalaryLevelTo_Appointed; Appointed."Salary Level (To)") { }

                trigger OnAfterGetRecord()
                begin
                    //Appointed.SETCURRENTKEY("Effective Date");
                    //AppointmentPeriod := ROUND((TODAY - Appointed."Effective Date")/365,0.1,'=');
                end;

                trigger OnPreDataItem()
                begin
                    //CLEAR(AppointmentPeriod);
                end;
            }
            dataitem(Transfer; "Employee Service History")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = where("Service Event" = filter(Transfer | "Temporary Deputation" | "Back From Deputation" | "Officiating Arrangement"));
                column(EffectiveDate_Transfer; Transfer."Effective Date") { }
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
                DataItemTableView = where("Emp Qualification Type" = filter(Education));
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
                DataItemTableView = where("Emp Qualification Type" = filter(Work));
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

            trigger OnAfterGetRecord()
            begin
                if SalaryLevel.Get("Salary Level") then
                    Position := SalaryLevel.Description;
                EmpServHistory.Reset;
                EmpServHistory.SetRange("Employee No.", Employee."No.");
                EmpServHistory.SetRange("Service Event", EmpServHistory."Service Event"::Appointment);
                if EmpServHistory.FindFirst then begin
                    DeputationValueToAppointment := EmpServHistory."Deputation Value (To)";
                    FunctionalTitleDescToAppointment := EmpServHistory."Functional Title Desc. (To)";
                    SalaryLevelDescToAppointment := EmpServHistory."Salary Level Desc. (To)";
                    EffectiveDateAppointment := EmpServHistory."Effective Date";
                    if EmpServHistory."Effective Date" <> 0D then
                        AppointmentPeriod := Round((Today - EmpServHistory."Effective Date") / 365, 0.1, '=');
                end;
                ExitTransferDeputationWise("Deputation on");

                EmployeeSerHistory.Reset;
                EmployeeSerHistory.SetRange("Employee No.", Employee."No.");
                EmployeeSerHistory.SetRange("Service Event", EmployeeSerHistory."Service Event"::Transfer);
                //EmployeeSerHistory.SETCURRENTKEY("Effective Date","Service History Code");
                if EmployeeSerHistory.FindLast then
                    LastTransferDate := EmployeeSerHistory."Effective Date";
                if LastTransferDate <> 0D then
                    ConfirmationPeriod := Round((Today - LastTransferDate) / 365, 0.1, '=');
            end;

            trigger OnPreDataItem()
            begin
                Clear(AppointmentPeriod);
                Clear(ConfirmationPeriod);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;

        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        GetCompanyOneLineAddress;
    end;

    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        CompanyOneLineAddress: Text;
        CompanyCommunicationAddress: Text;
        SNTransfer: Integer;
        SNEducation: Integer;
        SNExperience: Integer;
        SalaryLevel: Record "Salary Level";
        Position: Text;
        AppointmentPeriod: Decimal;
        PromotionPeriod: Decimal;
        EmpServHistory: Record "Employee Service History";
        DeputationValueToAppointment: Text;
        FunctionalTitleDescToAppointment: Text;
        SalaryLevelDescToAppointment: Text;
        EffectiveDateAppointment: Date;
        // DimValue: Record "Dimension Value";
        // Depart: Record Department;
        OrganizationalStructureList: Record "Organization Structure List";
        // EmpHie: Record "Employee Hierarchy Master";
        // Province: Record Province;
        // SubProvince: Record "Sub Province";
        DeputationCode: Text;
        DeputationValue: Text;
        GLSetup: Record "General Ledger Setup";
        EmployeeRelative: Record "Employee Relative";
        ConfirmationPeriod: Decimal;
        EmployeeSerHistory: Record "Employee Service History";
        LastTransferDate: Date;

    local procedure GetCompanyOneLineAddress()
    begin
        CompanyAddr[1] := CompanyInfo.Name;
        if CompanyInfo."Phone No." <> '' then
            CompanyOneLineAddress := OneLineAddress(CompanyAddr) + ', ' + CompanyInfo.FieldCaption("Phone No.") + ' : ' + CompanyInfo."Phone No."
        else
            CompanyOneLineAddress := OneLineAddress(CompanyAddr);

        if CompanyInfo."Fax No." <> '' then
            CompanyCommunicationAddress := CompanyInfo.FieldCaption("Fax No.") + ' : ' + CompanyInfo."Fax No.";

        if CompanyInfo."E-Mail" <> '' then begin
            if (CompanyCommunicationAddress <> '') then
                CompanyCommunicationAddress += ', ' + CompanyInfo.FieldCaption("E-Mail") + ' : ' + CompanyInfo."E-Mail"
            else
                CompanyCommunicationAddress += CompanyInfo.FieldCaption("E-Mail") + ' : ' + CompanyInfo."E-Mail";
        end;
    end;

    procedure OneLineAddress(var AddrArray: array[8] of Text[50]) OneLineAddress: Text
    var
        i: Integer;
    begin
        CompressArray(AddrArray);
        for i := 2 to ArrayLen(AddrArray) do begin
            if AddrArray[i] <> '' then
                if OneLineAddress = '' then
                    OneLineAddress += AddrArray[i]
                else
                    OneLineAddress += ', ' + AddrArray[i];
        end;
        exit(OneLineAddress);
    end;

    local procedure ExitTransferDeputationWise(DeputationOn: Enum "Deputation Type")
    begin
        // Clear(DimValue);
        // Clear(EmpHie);
        // Clear(Province);
        Clear(DeputationCode);
        Clear(DeputationValue);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if OrganizationalStructureList.Get(OrganizationalStructureList.Type::Branch, Employee."Global Dimension 1 Code") then begin
                        DeputationValue := OrganizationalStructureList.Name;
                        DeputationCode := OrganizationalStructureList.Code;
                    end;
                end;

            DeputationOn::Department:
                begin
                    if OrganizationalStructureList.Get(OrganizationalStructureList.Type::Department, Employee."Department Code") then begin
                        DeputationValue := OrganizationalStructureList.Name;
                        DeputationCode := OrganizationalStructureList.Code;
                    end;
                end;

            DeputationOn::"Extension Counter":
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    // EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    // if EmpHie.FindFirst then begin
                    //     DeputationValue := EmpHie.Description;
                    //     DeputationCode := EmpHie.Code;
                    // end;
                    if OrganizationalStructureList.Get(OrganizationalStructureList.Type::"Extension Counter", Employee."Extension Counter Code") then begin
                        DeputationValue := OrganizationalStructureList.Name;
                        DeputationCode := OrganizationalStructureList.Code;
                    end;
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
                    //     DeputationValue := EmpHie.Description;
                    //     DeputationCode := EmpHie.Code
                    // end;
                    if OrganizationalStructureList.Get(OrganizationalStructureList.Type::Unit, Employee."Unit Code") then begin
                        DeputationValue := OrganizationalStructureList.Name;
                        DeputationCode := OrganizationalStructureList.Code;
                    end;
                end;

            DeputationOn::Province:
                begin
                    // if Province.Get(Employee."Province Code") then begin
                    //     DeputationValue := Province.Description;
                    //     DeputationCode := Province.Code;
                    // end;
                    if OrganizationalStructureList.Get(OrganizationalStructureList.Type::Province, Employee."Province Code") then begin
                        DeputationValue := OrganizationalStructureList.Name;
                        DeputationCode := OrganizationalStructureList.Code;
                    end;
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
