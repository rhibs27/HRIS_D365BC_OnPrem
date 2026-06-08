codeunit 50001 "HR Mgt."
{
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd;
    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'The previous column set could not be found.';
        Text002: Label 'The period could not be found.';
        Text003: label 'There are no Calendar entries within the filter.';
        SetOption: Option "Initial","Previous","Same","Next","PreviousColumn","NextColumn";
        i: Integer;
        Window: Dialog;
        EmailBodyText: Text;
        Employee: Record Employee;
        EmailRecipients: Text;
        HRSetup: Record "Human Resources Setup";
        EmployeeActivityJournal: Record "Employee Activity Journal";
        leave: Record Leave;
        TravelRequest: Record "Travel Request";
        AttendanceMissed: Record "Attendance Missed";
        EmployeeTransfer: Record "Employee Transfer";
        Overtime: Record OverTime;
        MedicalInsuranceClaim: Record "Medical Insurance Claim";
        Resignation: Record Resignation;
        EmpLoan: Record "Employee Loan/Advance";
        AllowanceHeader: Record "Allowance Assignment Header";
        OrgStructureList: Record "Organization Structure List";
        CompanyInfo: Record "Company Information";
        EngNep: Record "English-Nepali Date";
        PayrollSetup: Record "Payroll General Setup";
        VacancyDocCategoryTxt: Label 'Vacancy', Locked = true;
        CustVacancyCategoryTxt: Label 'Vacancy', Locked = true;
        CustVacancyCategoryDescTxt: Label 'Vacancy Documents';
        VacancyApprWorkflowCodeTxt: Label 'VACANCY', Locked = true;
        VacancyApprWorkflowDescTxt: Label 'Vacancy Approval Workflow';
        VacancyTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Vacancy Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        BlankDateFormula: DateFormula;
        CustomTemplateTok: Label 'AGILE-', Locked = true;
        VacancySendForApproval: Label 'Approval of a Vacancy is requested.';
        VacancyCancelForApproval: Label 'Approval of a Vacancy is cancelled.';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        SetVacancyToPendingApprovalTxt: Label 'Custom - Set Vacancy to Pending Approval.';
        ReleaseVacancyTxt: Label 'Custom - Release the Vacancy document.';
        CreateVacancyApproveApprovalRequestAutomaticallyTxt: Label 'Custom - Create and approve an approval request automatically on Vacancy.';
        OpenDocumentVacancyTxt: Label 'Custom - Reopen the Vacancy.';
        UnsupportedRecordTypeErr: Label 'Custom - Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        TrainingDocCategoryTxt: Label 'Training';
        CustTrainingCategoryTxt: Label 'Training';
        CustTrainingCategoryDescTxt: Label 'Traning Document';
        TrainingApprWorkflowCodeTxt: Label 'TRAINING', Locked = true;
        TrainingApprWorkflowDescTxt: Label 'Training Approval Workflow';
        TrainingTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Training Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        TrainingSendForApproval: Label 'Approval of a Training is requested.';
        TrainingCancelForApproval: Label 'Approval of a Training is cancelled.';
        SetTrainingToPendingApprovalTxt: Label 'Custom - Set Training to Pending Approval.';
        ReleaseTrainingTxt: Label 'Custom - Release the Training document.';
        CreateTrainingApproveApprovalRequestAutomaticallyTxt: Label 'Custom - Create and approve an approval request automatically on Training.';
        OpenDocumentTrainingTxt: Label 'Custom - Reopen the Training.';
        ExportAttendanceTxt: Label 'Export Attendance';
        FacilitatorDocCategoryTxt: Label 'Facilitator';
        CustFacilitatorCategoryTxt: Label 'Facilitator';
        CustFacilitatorCategoryDescTxt: Label 'Facilitator Document';
        FacilitatorApprWorkflowCodeTxt: Label 'FACILITATOR', Locked = true;
        FacilitatorApprWorkflowDescTxt: Label 'Facilitator Approval Workflow';
        FacilitatorTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Facilitator Pool">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        FacilitatorSendForApproval: Label 'Approval of a Facilitator is requested.';
        FacilitatorCancelForApproval: Label 'Approval of a Facilitator is cancelled.';
        SetFacilitatorToPendingApprovalTxt: Label 'Custom - Set Facilitator to Pending Approval.';
        ReleaseFacilitatorTxt: Label 'Custom - Release the Facilitator document.';
        CreateFacilitatorApproveApprovalRequestAutomaticallyTxt: Label 'Custom - Create and approve an approval request automatically on Facilitator.';
        OpenDocumentFacilitatorTxt: Label 'Custom - Reopen the Facilitator.';
        CR: Integer;
        LF: Integer;
        Colon: Label ' : ';
        MutuallyExclPayrollGroup: Record "Mutually Excl. Payroll Group";
        DimensionValue: Record "Dimension Value";
        TempInt: Integer;
        Employee1: Record Employee;
        SQLConnectionMgt: Codeunit "SQL Connection Mgt";
        SQLCommandType: Option StoredProcedure,TableDirect,Text;
        CommandText: Text;
        reader: Text;
        InputStream: InStream;
        SQLstr: Text;
        ReadCommandTxt: Label 'Select * from ';
        WhereTxt: Label 'Where ';
        SetTxt: Label 'Set ';
        UpdateTxt: Label 'Update ';
        InsertTxt: Label 'Insert Into ';
        SpaceTxt: Label ' ';
        ValuesTxt: Label 'Values ';
        NullTxt: Label '12/31/9999';
        ExcelBuffer: Record "Excel Buffer";
        ImportSuccess: Label 'Order Plan Lines imported successfully.';
        UploadFileTxt: Label 'Select the Excel File to Import';
        ExlExt: Label '.xlsx';
        CalendarDescription: Text;
        AndText: Label 'AND';
        IsPunchQuestion: Text;
        PRSetup: Record "Payroll General Setup";
        AttendanceSetup: Record "Attendance Setup";
        PayrollEngine: Codeunit "Payroll Engine";
        DeleteCommandTxt: Label 'Delete from ';
        EmployeeRec: Record Employee;
        LeaveError: Label 'You cannot apply leave in Present day %1.';
        InterviewerCount: Integer;
        j: Integer;
        TransferError: Label 'You cannot Approve HR Transfer of Effective Date %1 in %2.';
        PageMunicipality: Page Municipalities;
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        LeaveMgt: Codeunit "Leave Mgt.";
        loanMgt: Codeunit "Loan Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        TravelMgt: CodeUnit "Travel Mgt.";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        ApprovalMgt: Codeunit "Approver Mgt";

    procedure ReturnNepaliYear(EnglishDate: Date): Integer
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", EnglishDate);
        if EngNep.FindFirst then
            exit(EngNep."Nepali Year");
    end;

    local procedure GetOneLessSalaryCode(SalaryCode: Code[20]): Text[20]
    var
        SalaryLevel: Record "Salary Level";
        SalaryLevel2: Record "Salary Level";
    begin
        SalaryLevel.Get(SalaryCode);
        SalaryLevel2.SetCurrentKey(Rank);
        SalaryLevel2.SetRange(Rank, 0, SalaryLevel.Rank - 1);
        if SalaryLevel2.FindLast then
            exit(SalaryLevel2.Code);
    end;

    procedure LookupSalaryLevel(SalLevelText: Text): Text
    var
        PageSalaryLevel: Page "Salary Levels";
        SalaryLevel: Record "Salary Level";
    begin
        SalaryLevel.Reset;
        Clear(PageSalaryLevel);
        PageSalaryLevel.AssignShowSelected;
        PageSalaryLevel.InsertSalLevel(SalLevelText);
        PageSalaryLevel.SetRecord(SalaryLevel);
        PageSalaryLevel.SetTableView(SalaryLevel);
        if PageSalaryLevel.RunModal = ACTION::OK then
            exit(PageSalaryLevel.ReturnSalLevelText);
    end;

    local procedure "-------HR Mgt--------"()
    begin
    end;

    procedure getDateinFormat(DateVar: Date): Text
    var
        Day: Text;
        Month: Text;
        Year: Text;
    begin
        //day
        if Date2DMY(DateVar, 1) < 10 then
            Day := '0' + Format(Date2DMY(DateVar, 1))
        else
            Day := Format(Date2DMY(DateVar, 1));
        //month
        if Date2DMY(DateVar, 2) < 10 then
            Month := '0' + Format(Date2DMY(DateVar, 2))
        else
            Month := Format(Date2DMY(DateVar, 2));
        //year
        Year := Format(Date2DMY(DateVar, 3));
        exit(Day + '-' + Month + '-' + Year);
    end;

    procedure getTimeInFormat(varTime: Time): Text
    var
        Milliseconds: Integer;
        Hours: Integer;
        Minutes: Integer;
        Seconds: Integer;
        HoursText: Text;
        MinutesText: Text;
        SecondsText: Text;
        TimeText: Text;
    begin
        if varTime = 0T then
            exit('');
        Milliseconds := varTime - 000000T;
        Hours := Round(Milliseconds div 1000 div 60 div 60, 1, '=');
        if Hours < 10 then
            HoursText := '0' + Format(Hours)
        else
            HoursText := Format(Hours);
        Milliseconds -= Hours * 1000 * 60 * 60;
        TimeText := 'AM';
        Minutes := Round(Milliseconds div 1000 div 60, 1, '=');
        if Minutes < 10 then
            MinutesText := '0' + Format(Minutes)
        else
            MinutesText := Format(Minutes);
        if Hours = 12 then
            TimeText := 'PM';
        Milliseconds -= Minutes * 1000 * 60;
        Seconds := Round(Milliseconds div 1000, 1, '=');
        if Seconds < 10 then
            SecondsText := '0' + Format(Seconds)
        else
            SecondsText := Format(Seconds);
        Milliseconds -= Seconds * 1000;
        if Hours > 12 then begin
            Hours := Hours mod 12;
            TimeText := 'PM';
            if Hours < 10 then
                HoursText := '0' + Format(Hours)
            else
                HoursText := Format(Hours);
        end;
        exit(HoursText + ':' + MinutesText + ' ' + TimeText);
    end;

    procedure CheckForCitizen(CitizenNo: Code[30]; CitizenPlace: Code[20])
    var
        ErrorCitizenError: Label 'Citizenship No %1 of issed place %2 already exist.';
    begin
        Employee.Reset;
        Employee.SetRange("Citizen Number", CitizenNo);
        Employee.SetRange("Citizenship Issue Place Code", CitizenPlace);
        if Employee.FindFirst then
            Error(ErrorCitizenError, CitizenNo, CitizenPlace);
    end;

    procedure GetChoraChori(Gender: Enum "Employee Gender"): Text
    var
        Relative: Record Relative;
    begin
        Clear(Relative);
        Relative.SetRange(Relation, Relative.Relation::Father);
        if Relative.FindFirst then begin
            case Gender of
                Employee.Gender::Male:
                    exit(Relative."Male Corres. Relation (Nepali)");
                Employee.Gender::Female:
                    exit(Relative."FemaleCorres. Relation(Nepali)");
            end;
        end;
    end;

    procedure GetNatiNatini(Gender: Enum "Employee Gender"): Text
    var
        Relative: Record Relative;
    begin
        Clear(Relative);
        Relative.SetRange(Relation, Relative.Relation::GrandFather);
        if Relative.FindFirst then begin
            case Gender of
                Employee.Gender::Male:
                    exit(Relative."Male Corres. Relation (Nepali)");
                Employee.Gender::Female:
                    exit(Relative."FemaleCorres. Relation(Nepali)");
            end;
        end;
    end;

    procedure CheckDistrictName(DistrictName: Text)
    var
        DistrictVar: Record District;
        ErrorDistrict: Label 'District Name %1 Not found';
    begin
        DistrictVar.Reset;
        DistrictVar.SetRange("District Name", DistrictName);
        if not DistrictVar.FindFirst then
            Error(ErrorDistrict, DistrictName);
    end;

    procedure CheckCountryName(CountryName: Text)
    var
        Country: Record "Country/Region";
        ErrorDistrict: Label 'Country Name %1 Not found';
    begin
        Country.Reset;
        Country.SetRange("Name", CountryName);
        if not Country.FindFirst then
            Error(ErrorDistrict, CountryName);
    end;

    procedure LookupCountry(): Text
    var
        PageCountry: Page "Countries/Regions";
        Country: Record "Country/Region";
    begin
        Clear(PageCountry);
        Country.Reset;
        PageCountry.LookupMode(true);
        if PageCountry.RunModal = ACTION::LookupOK then begin
            PageCountry.GetRecord(Country);
            exit(Country.Name);
        end;
    end;

    procedure LookupCountryOtherThenNepalAndSAARC(): Text
    var
        PageCountry: Page "Countries/Regions";
        Country: Record "Country/Region";
    begin
        Clear(PageCountry);
        Country.Reset;
        Country.SetRange("Is SAARC", false);
        Country.SetRange("Is Nepal", false);
        PageCountry.SetRecord(Country);
        PageCountry.SetTableView(Country);
        PageCountry.LookupMode(true);
        if PageCountry.RunModal = ACTION::LookupOK then begin
            PageCountry.GetRecord(Country);
            exit(Country.Name);
        end;
    end;

    procedure LookupCountrySAARC(IsSAARC: Boolean): Text
    var
        PageCountry: Page "Countries/Regions";
        Country: Record "Country/Region";
    begin
        Clear(PageCountry);
        Country.Reset;
        Country.SetRange("Is SAARC", IsSAARC);
        PageCountry.SetRecord(Country);
        PageCountry.SetTableView(Country);
        PageCountry.LookupMode(true);
        if PageCountry.RunModal = ACTION::LookupOK then begin
            PageCountry.GetRecord(Country);
            exit(Country.Name);
        end;
    end;

    procedure LookupDistrict(ProvienceName: Text; xDisTxt: Text): Text
    var
        PageDistrict: Page "District";
        DistrictVar: Record District;
    begin
        Clear(PageDistrict);
        DistrictVar.Reset;
        DistrictVar.SetRange("Province Name", ProvienceName);
        PageDistrict.SetRecord(DistrictVar);
        PageDistrict.SetTableView(DistrictVar);
        PageDistrict.LookupMode(true);
        if PageDistrict.RunModal = ACTION::LookupOK then begin
            PageDistrict.GetRecord(DistrictVar);
            exit(DistrictVar."District Name");
        end;
        exit(xDisTxt);
    end;

    procedure LookupAllDistrict(): Text
    var
        PageDistrict: Page "District";
        DistrictVar: Record District;
    begin
        Clear(PageDistrict);
        DistrictVar.Reset;
        PageDistrict.LookupMode(true);
        if PageDistrict.RunModal = ACTION::LookupOK then begin
            PageDistrict.GetRecord(DistrictVar);
            exit(DistrictVar."District Name");
        end;
    end;

    procedure CheckMunicipalityName(MunicipalityName: Text[50])
    var
        Municipality: Record Municipality;
        ErrorDistrict: Label 'Municipality Name %1 Not found';
    begin
        Municipality.Reset;
        Municipality.SetRange("Municipality Name", MunicipalityName);
        if not Municipality.FindFirst then
            Error(ErrorDistrict, MunicipalityName);
    end;

    procedure LookupMunicipalityName(DistrictName: Text[50]; MunicipalityName: Text): Text
    var
        PageMunicipality: Page "Municipalities";
        Municipality: Record Municipality;
    begin
        Clear(PageMunicipality);
        Municipality.Reset;
        Municipality.SetRange("District Name", DistrictName);
        PageMunicipality.SetRecord(Municipality);
        PageMunicipality.SetTableView(Municipality);
        PageMunicipality.LookupMode(true);
        if PageMunicipality.RunModal = ACTION::LookupOK then begin
            PageMunicipality.GetRecord(Municipality);
            exit(Municipality."Municipality Name");
        end;
        exit(MunicipalityName);
    end;

    procedure CheckProvience(ProvienceName: Text)
    var
        ProvienceVar: Record Province;
        ErrorProvience: Label 'Provience Name %1 not found.';
    begin
        Clear(ProvienceVar);
        ProvienceVar.SetRange(Description, ProvienceName);
        if not ProvienceVar.FindFirst then
            Error(ErrorProvience, ProvienceName);
    end;

    procedure LookupProvience(xProvTxt: Text): Text
    var
        PageProvience: Page "Provinces List";
        ProvienceZone: Record Province;
    begin
        Clear(ProvienceZone);
        Clear(PageProvience);
        PageProvience.SetRecord(ProvienceZone);
        PageProvience.SetTableView(ProvienceZone);
        PageProvience.LookupMode(true);
        if PageProvience.RunModal = ACTION::LookupOK then begin
            PageProvience.GetRecord(ProvienceZone);
            exit(ProvienceZone.Description);
        end;
        exit(xProvTxt);
    end;

    procedure LookupProvinceOrganization(): Text[500]
    var
        ProvienceOrganizationList: Record "Organization Structure List";
        ProvienceOrganizationPage: Page "Organization Structure list";
        ConcatenatedValues: Text;
    begin
        Clear(ProvienceOrganizationList);
        Clear(ProvienceOrganizationPage);
        ProvienceOrganizationList.SetRange(Type, ProvienceOrganizationList.Type::Province);
        ProvienceOrganizationPage.SetRecord(ProvienceOrganizationList);
        ProvienceOrganizationPage.SetTableView(ProvienceOrganizationList);
        ProvienceOrganizationPage.LookupMode(true);
        if ProvienceOrganizationPage.RunModal = ACTION::LookupOK then begin
            ProvienceOrganizationPage.SetSelectionFilter(ProvienceOrganizationList);
            if ProvienceOrganizationList.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += ProvienceOrganizationList.code;
                until ProvienceOrganizationList.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupBranch(Province: Text): Text[500]
    var
        OrganizationStructureList: Record "Organization Structure List";
        OrganizationStructureListPage: Page "Organization Structure list";
        ConcatenatedValues: Text;
    begin
        Clear(OrganizationStructureList);
        Clear(OrganizationStructureListPage);
        if Province <> '' then
            OrganizationStructureList.SetRange("Province Code", Province);
        OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Branch);
        OrganizationStructureListPage.SetRecord(OrganizationStructureList);
        OrganizationStructureListPage.SetTableView(OrganizationStructureList);
        OrganizationStructureListPage.LookupMode(true);
        if OrganizationStructureListPage.RunModal = ACTION::LookupOK then begin
            OrganizationStructureListPage.SetSelectionFilter(OrganizationStructureList);
            if OrganizationStructureList.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += OrganizationStructureList.code;
                until OrganizationStructureList.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupMultipleDistrict(): Text[500]
    var
        District: Record District;
        DistrictPage: Page District;
        ConcatenatedValues: Text;
    begin
        Clear(District);
        Clear(DistrictPage);
        DistrictPage.SetRecord(District);
        DistrictPage.SetTableView(District);
        DistrictPage.LookupMode(true);
        if DistrictPage.RunModal = ACTION::LookupOK then begin
            DistrictPage.SetSelectionFilter(District);
            if District.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += District."District Name";
                until District.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupMultipleMunicipality(): Text[500]
    var
        Municipality: Record Municipality;
        MunicipalityPage: Page Municipalities;
        ConcatenatedValues: Text;
    begin
        Clear(Municipality);
        Clear(MunicipalityPage);
        MunicipalityPage.SetRecord(Municipality);
        MunicipalityPage.SetTableView(Municipality);
        MunicipalityPage.LookupMode(true);
        if MunicipalityPage.RunModal = ACTION::LookupOK then begin
            MunicipalityPage.SetSelectionFilter(Municipality);
            if Municipality.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += Municipality.Code;
                until Municipality.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupEmployee(): Text[500]
    var
        Employee: Record Employee;
        EmployeePage: Page "Employee List";
        ConcatenatedValues: Text;
    begin
        Clear(Employee);
        Clear(EmployeePage);
        EmployeePage.SetRecord(Employee);
        EmployeePage.SetTableView(Employee);
        EmployeePage.LookupMode(true);
        if EmployeePage.RunModal = ACTION::LookupOK then begin
            EmployeePage.SetSelectionFilter(Employee);
            if Employee.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += Employee."No.";
                until Employee.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupDepartment(Province: Text): Text[500]
    var
        OrganizationStructureList: Record "Organization Structure List";
        OrganizationStructureListPage: Page "Organization Structure list";
        ConcatenatedValues: Text;
    begin
        Clear(OrganizationStructureList);
        Clear(OrganizationStructureListPage);
        if Province <> '' then
            OrganizationStructureList.SetRange("Province Code", Province);
        OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Department);
        OrganizationStructureListPage.SetRecord(OrganizationStructureList);
        OrganizationStructureListPage.SetTableView(OrganizationStructureList);
        OrganizationStructureListPage.LookupMode(true);
        if OrganizationStructureListPage.RunModal = ACTION::LookupOK then begin
            OrganizationStructureListPage.SetSelectionFilter(OrganizationStructureList);
            if OrganizationStructureList.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += OrganizationStructureList.code;
                until OrganizationStructureList.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupFunctionalTitile(FunctTitleText: Text): Text
    var
        PageFunctTitle: Page "Functional Title List";
        FunctTitle: Record "Functional Title";
    begin
        FunctTitle.Reset;
        Clear(PageFunctTitle);
        PageFunctTitle.AssignShowSelected;
        PageFunctTitle.InsertFunctTitle(FunctTitleText);
        PageFunctTitle.SetRecord(FunctTitle);
        PageFunctTitle.SetTableView(FunctTitle);
        if PageFunctTitle.RunModal = ACTION::OK then
            exit(PageFunctTitle.ReturnFunctTitleText);
    end;

    procedure LookupFiscalYear(): Text
    var
        PagePayCylceTerm: Page "Pay Cycle Term";
        PayCylceTerm: Record "Pay Cycle Term";
    begin
        Clear(PagePayCylceTerm);
        PayCylceTerm.Reset;
        PagePayCylceTerm.LookupMode(true);
        if PagePayCylceTerm.RunModal = ACTION::LookupOK then begin
            PagePayCylceTerm.GetRecord(PayCylceTerm);
            exit(PayCylceTerm.Term);
        end;
    end;

    procedure ValidateTaxCode(Gender: Enum "Employee Gender"; MaritalStatus: Enum "Marital Status"): Code[20]
    var
        TaxCodeVar: Record "Tax Setup Header";
    begin
        TaxCodeVar.Reset;
        TaxCodeVar.SetRange(Gender, Gender);
        TaxCodeVar.SetRange("Marital Status", MaritalStatus);
        if TaxCodeVar.FindFirst then
            exit(TaxCodeVar.Code);
    end;

    procedure ReturnCurrencyCode(CurrCode: Code[20]): Text
    begin
        if CurrCode <> '' then
            exit(' (' + CurrCode + ')');
    end;

    procedure ReturnSelectedEmployeeCode(xEmployeeCode: Text): Text
    var
        PageEmployeeList: Page "Select Employee List";
    begin
        Clear(PageEmployeeList);
        Clear(Employee);
        PageEmployeeList.ForTransferNotify;
        PageEmployeeList.InitEmployeeText(xEmployeeCode);
        PageEmployeeList.SetRecord(Employee);
        PageEmployeeList.SetTableView(Employee);
        if PageEmployeeList.RunModal = ACTION::OK then begin
            exit(PageEmployeeList.ReturnEmployeeText);
        end;
    end;

    procedure ReturnFiscalYear(EngDate: Date): Text
    var
        EngNep: Record "English-Nepali Date";
    begin
        EngNep.SetLoadFields("English Date", "Fiscal Year");
        EngNep.SetRange("English Date", EngDate);
        if EngNep.FindFirst then
            exit(EngNep."Fiscal Year");
    end;

    procedure ReturnEmpName(EmpCode: Code[20]): Text
    begin
        if Employee.Get(EmpCode) then
            exit(Employee."Full Name");
    end;

    procedure GetNoDaysInMonth(): Decimal
    begin
        PRSetup.Get;
        exit(Round((PRSetup."Payroll Fiscal Year End Date" - PRSetup."Payroll Fiscal Year Start Date" + 1) / 12, 0.01, '='));
    end;


    procedure CaluateDuration(StartTime: Time; EndTime: Time; NoOfDays: Decimal): Duration
    var
        ErrorTime: Label 'Start time cannot be greater than end time';
    begin
        if NoOfDays = 1 then
            if StartTime > EndTime then
                Error(ErrorTime);
        exit((EndTime - StartTime) * NoOfDays);
    end;

    procedure CheckAgeAndBirthday(BirthdayDate: Date; CheckAgeDate: Date; var AgeYears: Integer; var AgeDays: Integer; var IsBirthDayDate: Boolean)
    var
        TestDate: Date;
    begin
        AgeYears := 0;
        repeat
            AgeYears += 1;
            TestDate := CalcDate(StrSubstNo('<+%1Y>', AgeYears), BirthdayDate);
        until TestDate >= CheckAgeDate;
        AgeYears -= 1;
        AgeDays := CheckAgeDate - BirthdayDate;
        IsBirthDayDate := TestDate = CheckAgeDate;
    end;



    procedure GetEmployeeName(EmpCode: Code[20]; var EmpName: Text)
    var
        Temp: Text;
    begin
        Clear(Temp);
        Employee.Reset;
        if EmpCode <> '' then begin
            Employee.SetFilter("No.", EmpCode);
            if Employee.FindFirst then
                repeat
                    if Temp <> '' then
                        Temp += '|' + Employee."Full Name"
                    else
                        Temp := Employee."Full Name";
                until Employee.Next = 0;
        end;
        EmpName := CopyStr(Temp, 1, 50);
    end;

    procedure GetEmployeeNo(): Code[20]
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        exit(Employee."No.");
    end;

    procedure GetBranchCode(): Code[20]
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        exit(Employee."Branch Code");
    end;

    procedure GetEmployeeDeputationDistrictName(DeputationType: Enum "Deputation Type"; DeputaionOnCode: code[20]): text[50]
    begin
        if OrgStructureList.Get(DeputationType, DeputaionOnCode) then
            exit(OrgStructureList."District Name")
    end;

    procedure GetEmployeeDeputationMunicipalityCode(DeputationType: Enum "Deputation Type"; DeputaionOnCode: code[20]): text[50]
    begin
        if OrgStructureList.Get(DeputationType, DeputaionOnCode) then
            exit(OrgStructureList."Municipality Code")
    end;

    procedure GetEmployeeName(EmployeeCode: Code[20]): Text[50]
    begin
        Employee.Reset;
        if Employee.Get(EmployeeCode) then
            exit(Employee."Full Name");
    end;

    procedure GetFunctionalTitleCode(EmployeeCode: Code[20]): Text[20]
    begin
        Employee.Reset;
        if Employee.Get(EmployeeCode) then
            exit(Employee."Functional Title");
    end;

    procedure GetHrHead(): Code[20]
    begin
        HRSetup.Get;
        HRSetup.TestField("HR Head Functional Title");
        HRSetup.TestField("HR Department Code");
        Employee.Reset;
        Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        Employee.SetRange("Department Code", HRSetup."HR Department Code");
        Employee.SetRange(Status, Employee.Status::Active);
        if Employee.FindFirst then
            exit(Employee."No.");
    end;

    local procedure "--------------FOR REPORTS---------------"()
    begin
    end;

    procedure WorkStationFunction(EmployeeRec: Record Employee): Text
    var
        HRSetUp: Record "Human Resources Setup";
        SalaryLevel: Record "Salary Level";
        WorkStation: text;
    begin
        case EmployeeRec."Deputation on" of
            EmployeeRec."Deputation on"::Province:
                begin
                    WorkStation := EmployeeRec."Province Name";
                end;
            EmployeeRec."Deputation on"::Department:
                begin
                    if EmployeeRec."Unit Code" <> '' then
                        WorkStation := EmployeeRec."Unit Name"
                    else if EmployeeRec."Department Code" <> '' then begin
                        WorkStation := EmployeeRec."Department Name";
                    end;
                end;
            EmployeeRec."Deputation on"::Branch:
                begin
                    if EmployeeRec."Extension Counter Code" <> '' then
                        WorkStation := EmployeeRec."Extension Counter Name"
                    else if EmployeeRec."Branch Code" <> '' then begin
                        WorkStation := EmployeeRec."Branch Name";
                    end;
                end;
        end;
        OnAfterWorkStation(EmployeeRec, WorkStation);
        exit(WorkStation);
    end;

    procedure getDeputation(empCode: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(empCode) then
            exit(employee."Deputation On Code");
    end;

    procedure ReturnCalendarDescription(): Text
    begin
        exit(CalendarDescription);
    end;

    procedure IsWinter(CheckDate: Date; EmployeeWorkShift: Record "Employee Work Shift"): Boolean
    begin
        if (CheckDate >= EmployeeWorkShift."Winter Start Date") and (CheckDate <= EmployeeWorkShift."Winter End Date") then
            exit(true)
        else
            exit(false)
    end;

    procedure IsAlternateShift(CheckDate: Date; EmployeeWorkShift: Record "Employee Work Shift"): Boolean
    begin
        if (CheckDate >= EmployeeWorkShift."Alternate Start Date") and (CheckDate <= EmployeeWorkShift."Alternate End Date") then
            exit(true)
        else
            exit(false)
    end;


    procedure IsFriday(CheckDate: Date): Boolean
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", CheckDate);
        EngNep.FindFirst;
        exit(EngNep.Week = EngNep.Week::Friday);
    end;

    procedure GetNepaliDate(EnglishDate: Date): Text
    begin
        Clear(EngNep);
        EngNep.SetRange("English Date", EnglishDate);
        if EngNep.FindFirst then
            exit(EngNep."Nepali Date");
    end;

    procedure IsDashinTihar(CheckDate: date): Boolean
    var
        BaseCalenderchanges: Record "Base Calendar Change";
    begin
        BaseCalenderchanges.Reset();
        BaseCalenderchanges.SetRange(Date, CheckDate);
        BaseCalenderchanges.SetRange("Holiday Type", BaseCalenderchanges."Holiday Type"::"Dashain Tihar");
        exit(BaseCalenderchanges.FindFirst());
    end;

    procedure CheckEligibilityBeforeEmploymentDate(ActivityDate: Date; EmployeeNo: Code[20])
    begin
        Employee.get(EmployeeNo);
        if ActivityDate <> 0D then begin
            if ActivityDate < Employee."Employment Date" then
                Error('Cannot apply before your employment date');
        end;
    end;

    procedure UpdateInsuranceFromHomeLoan(EmployeeLoanAdvance: Record "Employee Loan/Advance")
    var
        EmployeeInsuranceInformation: Record "Employee Insurance Information";
        EmployeeInsuranceInfoPage: Page "Employee Insurance Card";
    begin
        if not Confirm('Do you want to update insurance detail ?', false) then
            exit;
        EmployeeInsuranceInformation.Reset;
        EmployeeInsuranceInformation.SetRange("Linked Home Loan Account No.", EmployeeLoanAdvance."No.");
        if not EmployeeInsuranceInformation.FindFirst then begin
            EmployeeInsuranceInformation.Init;
            EmployeeInsuranceInformation."Employee No." := EmployeeLoanAdvance."Employee No.";
            EmployeeInsuranceInformation."Employee Name" := EmployeeLoanAdvance."Employee Name";
            EmployeeInsuranceInformation."Linked Home Loan Account No." := EmployeeLoanAdvance."No.";
            EmployeeInsuranceInformation."Is Home Loan TieUp" := true;
            EmployeeInsuranceInformation.Validate(Type, EmployeeInsuranceInformation.Type::Insurance);
            EmployeeInsuranceInformation.Validate("Approval Status", EmployeeInsuranceInformation."Approval Status"::Open);
            EmployeeInsuranceInformation.Insert(true);
            EmployeeInsuranceInfoPage.SetTableView(EmployeeInsuranceInformation);
            EmployeeInsuranceInfoPage.Run;
        end else begin
            EmployeeInsuranceInfoPage.SetTableView(EmployeeInsuranceInformation);
            EmployeeInsuranceInfoPage.Run;
        end;
    end;

    procedure UpdateEmploymentDate(EmpCode: Code[20])
    var
        EmpPageBuilder: FilterPageBuilder;
        UpdateEmploymentDate: Label 'Update Employment Date';
        EmploymentDate: Date;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
        Counter: Integer;
        ServiceHistory: Record "Employee Service History";
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("Is Admin");
        EmpPageBuilder.AddTable(UpdateEmploymentDate, DATABASE::Employee);
        EmpPageBuilder.ADdField(UpdateEmploymentDate, Employee1."Employment Date");
        if EmpPageBuilder.RunModal then begin
            Employee1.SetView(EmpPageBuilder.GetView(UpdateEmploymentDate));
            Evaluate(EmploymentDate, Employee1.GetFilter("Employment Date"));
            if EmploymentDate = 0D then
                Error('Employment date must have value.');
            Employee.Get(EmpCode);
            if EmploymentDate > Employee."Employment Date" then begin
                EmpAttendanceActivity.Reset;
                EmpAttendanceActivity.SetRange("Employee No.", EmpCode);
                EmpAttendanceActivity.SetFilter("Attendance Date", '<%1', EmploymentDate);
                EmpAttendanceActivity.DeleteAll;
            end else if EmploymentDate < Employee."Employment Date" then begin
                for Counter := 1 to (Employee."Employment Date" - EmploymentDate) do begin
                    EmpAttendanceActivity.Init;
                    EmpAttendanceActivity.Validate("Employee No.", EmpCode);
                    EmpAttendanceActivity.Validate("Attendance Date", EmploymentDate + Counter - 1);
                    EmpAttendanceActivity.Validate("Absent Day", 1);
                    EmpAttendanceActivity.Insert;
                end;
            end;
            ServiceHistory.Reset;
            ServiceHistory.SetRange("Employee No.", EmpCode);
            ServiceHistory.SetRange("Service Event", ServiceHistory."Service Event"::Appointment);
            if ServiceHistory.FindFirst then begin
                ServiceHistory.Validate("Effective Date", EmploymentDate);
                ServiceHistory.Modify;
            end;
            Employee.Validate("Employment Date", EmploymentDate);
            Employee.Modify;
            Message('Update.');
        end;
    end;

    procedure GetEmpName(): Text
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        exit(Employee."Full Name");
    end;

    procedure GetEmpNameSaas(EmployeeNo: code[20]): Text
    begin
        Employee.Reset;
        Employee.SetRange("No.", EmployeeNo);
        Employee.FindFirst;
        exit(Employee."Full Name");
    end;

    procedure LookUpMunicipalityKPI(xMunicipalityTxt: Text[50]): Text[50]
    var
        PageMunicipality: Page Municipalities;
        Municipality: Record Municipality;
    begin
        Clear(Municipality);
        Clear(PageMunicipality);
        PageMunicipality.SetRecord(Municipality);
        PageMunicipality.SetTableView(Municipality);
        PageMunicipality.LookupMode(true);
        if PageMunicipality.RunModal = ACTION::LookupOK then begin
            PageMunicipality.GetRecord(Municipality);
            exit(Municipality."Municipality Name");
        end;
        exit(xMunicipalityTxt);
    end;

    procedure CheckDateStatus(CalendarCode: Code[20];
                                TargetDate: Date;
                                VAR Description: Text[50];
                                VAR Proviences: Text[150];
                                VAR Gender: Enum "Employee Gender";
                                VAR InOutValley: Enum "Outside/Inside Valley";
                                VAR PostingRegion: enum Region;
                                VAR Branch: Text;
                                VAR Distict: Text;
                                var Municipality: text;
                                var Community: Enum "Community Type";
                                var EmployeeFilter: Text;
                                var Disabled: Boolean): Boolean
    var
        BaseCalChange: Record "Base Calendar Change";
    begin
        BaseCalChange.Reset;
        BaseCalChange.SetRange("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FindSet() THEN
            repeat
                CASE BaseCalChange."Recurring System" OF
                    BaseCalChange."Recurring System"::" ":
                        IF TargetDate = BaseCalChange.Date THEN begin
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";
                            Gender := BaseCalChange."Gender Filter";
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";
                            Branch := BaseCalChange."Branch Code";
                            Distict := BaseCalChange.District;
                            Municipality := BaseCalChange.Municipality;
                            Community := BaseCalChange.Community;
                            EmployeeFilter := BaseCalChange.Employee;
                            Disabled := BaseCalChange.Disabled;
                            exit(BaseCalChange.Nonworking);
                        end;
                    BaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = BaseCalChange.Day THEN begin
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";
                            Gender := BaseCalChange."Gender Filter";
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";
                            Branch := BaseCalChange."Branch Code";
                            Distict := BaseCalChange.District;
                            Municipality := BaseCalChange.Municipality;
                            Community := BaseCalChange.Community;
                            EmployeeFilter := BaseCalChange.Employee;
                            Disabled := BaseCalChange.Disabled;
                            exit(BaseCalChange.Nonworking);
                        end;
                    BaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(BaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(BaseCalChange.Date, 1))
                        THEN begin
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";
                            Gender := BaseCalChange."Gender Filter";
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";
                            Branch := BaseCalChange."Branch Code";
                            Distict := BaseCalChange.District;
                            Municipality := BaseCalChange.Municipality;
                            Community := BaseCalChange.Community;
                            EmployeeFilter := BaseCalChange.Employee;
                            Disabled := BaseCalChange.Disabled;
                            exit(BaseCalChange.Nonworking);
                        end;
                end;
            until BaseCalChange.NEXT = 0;
        Description := '';
        Proviences := '';
        clear(Gender);
        clear(InOutValley);
        clear(PostingRegion);
        clear(Branch);
        Clear(Distict);
        Clear(Community);
        Clear(Disabled);
    end;

    procedure CheckSaturday(CheckDate: Date; CalCode: Code[10]): Boolean
    var
        BaseCalendarChange: Record "Base Calendar Change";
    begin
        BaseCalendarChange.Reset();
        BaseCalendarChange.SetRange("Base Calendar Code", CalCode);
        BaseCalendarChange.SetRange("Recurring System", BaseCalendarChange."Recurring System"::"Weekly Recurring");
        if BaseCalendarChange.FindFirst() then begin
            if Date2DWY(CheckDate, 1) = BaseCalendarChange.Day then
                exit(BaseCalendarChange.Nonworking);
        end;
    end;

    procedure GenerateActualMatrixData(VAR RecRef: RecordRef; SetWanted: Option; MaximumSetLength: Integer; CaptionFieldNo: Integer; VAR RecordPosition: Text; VAR CaptionSet: ARRAY[32] OF Text[80]; VAR CaptionRange: Text; VAR CurrSetLength: Integer; VAR DescCaptionSet: ARRAY[32] OF Text; DescCaptionFieldNo: Integer; ShowCaption: Boolean);
    VAR
        Steps: Integer;
        Caption: Text;
        MaxCaptionLength: Integer;
    begin
        clear(CaptionSet);
        clear(DescCaptionSet);
        CaptionRange := '';
        CurrSetLength := 0;
        IF RecRef.ISEMPTY THEN begin
            RecordPosition := '';
            exit;
        end;
        CASE SetWanted OF
            SetOption::Initial:
                RecRef.FindFirst();
            SetOption::Previous:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    Steps := RecRef.NEXT(-MaximumSetLength);
                    IF NOT (Steps IN [-MaximumSetLength, 0]) THEN
                        ERROR(Text001);
                end;
            SetOption::Same:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                end;
            SetOption::Next:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    IF NOT (RecRef.NEXT(MaximumSetLength) = MaximumSetLength) THEN begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    end;
                end;
            SetOption::PreviousColumn:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    Steps := RecRef.NEXT(-1);
                    IF NOT (Steps IN [-1, 0]) THEN
                        ERROR(Text001);
                end;
            SetOption::NextColumn:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    IF NOT (RecRef.NEXT(1) = 1) THEN begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    end;
                end;
        end;
        RecordPosition := RecRef.GETPOSITION;
        repeat
            CurrSetLength := CurrSetLength + 1;
            Caption := FORMAT(RecRef.FIELD(CaptionFieldNo).VALUE);
            MaxCaptionLength := MAXSTRLEN(CaptionSet[CurrSetLength]);
            IF STRLEN(Caption) <= MaxCaptionLength THEN
                CaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength)
            ELSE
                CaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength - 3) + '...';
        until (CurrSetLength = MaximumSetLength) OR (RecRef.NEXT <> 1);
        IF CurrSetLength = 1 THEN
            CaptionRange := CaptionSet[1]
        ELSE
            CaptionRange := CaptionSet[1] + '..' + CaptionSet[CurrSetLength];
        IF ShowCaption THEN begin
            IF RecRef.ISEMPTY THEN begin
                RecordPosition := '';
                exit;
            end;
            CASE SetWanted OF
                SetOption::Initial:
                    RecRef.FindFirst();
                SetOption::Previous:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        Steps := RecRef.NEXT(-MaximumSetLength);
                        IF NOT (Steps IN [-MaximumSetLength, 0]) THEN
                            ERROR(Text001);
                    end;
                SetOption::Same:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    end;
                SetOption::Next:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        IF NOT (RecRef.NEXT(MaximumSetLength) = MaximumSetLength) THEN begin
                            RecRef.SETPOSITION(RecordPosition);
                            RecRef.GET(RecRef.RECORDID);
                        end;
                    end;
                SetOption::PreviousColumn:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        Steps := RecRef.NEXT(-1);
                        IF NOT (Steps IN [-1, 0]) THEN
                            ERROR(Text001);
                    end;
                SetOption::NextColumn:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        IF NOT (RecRef.NEXT(1) = 1) THEN begin
                            RecRef.SETPOSITION(RecordPosition);
                            RecRef.GET(RecRef.RECORDID);
                        end;
                    end;
            end;
            RecordPosition := RecRef.GETPOSITION;
            CurrSetLength := 0;
            repeat
                CurrSetLength := CurrSetLength + 1;
                Caption := FORMAT(RecRef.FIELD(DescCaptionFieldNo).VALUE);
                MaxCaptionLength := MAXSTRLEN(CaptionSet[CurrSetLength]);
                IF STRLEN(Caption) <= MaxCaptionLength THEN
                    DescCaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength)
                ELSE
                    DescCaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength - 3) + '...';
            until (CurrSetLength = MaximumSetLength) OR (RecRef.NEXT <> 1);
            IF CurrSetLength = 1 THEN
                CaptionRange := DescCaptionSet[1]
            ELSE
                CaptionRange := DescCaptionSet[1] + '..' + DescCaptionSet[CurrSetLength];
        end;
    end;

    procedure InitNoSeriesNew(SetupNoSeries: Code[20]; xRecNoSeries: Code[20]; DocDate: Date; var DocNo: Code[20]; var RecNoSeries: Code[20])
    var
        NoSeries: Codeunit "No. Series";
    begin
        If NoSeries.AreRelated(SetupNoSeries, xRecNoSeries) then
            RecNoSeries := xRecNoSeries
        else
            RecNoSeries := SetupNoSeries;
        DocNo := NoSeries.PeekNextNo(RecNoSeries, DocDate)
    end;

    procedure SetDefaultSeries(var NewNoSeriesCode: Code[20]; NoSeriesCode: Code[20])
    var
        GlobalNoSeries: record "No. Series";
    begin
        if NoSeriesCode <> '' then begin
            GlobalNoSeries.Get(NoSeriesCode);
            if GlobalNoSeries."Default Nos." then
                NewNoSeriesCode := GlobalNoSeries.Code;
        end;
    end;

    procedure getServicePeriodText(var Employee: Record Employee)
    var
        NewEmploymentDate: Date;
        LastDate: Date;
    begin
        if Employee."Employment Date" <> 0D then begin
            NewEmploymentDate := GetAdjustedEmploymentDate(Employee, Employee."Employment Date", Today);
            HRSetup.Get();
            LastDate := Employee."Termination Date";
            if Employee."Resignation Date" <> 0D then
                LastDate := Employee."Resignation Date";
            if HRSetup."Service Day without Last Date" then begin
                if LastDate <> 0D then
                    LastDate := LastDate - 1
                else
                    LastDate := Today - 1;
            end ELSE begin
                LastDate := Today;
            end;
            if HRSetup."Calculate Age using Nepali C." then begin
                Employee."Service Period text" := GetAgeBs(EngNep.getNepaliDate(NewEmploymentDate), EngNep.getNepaliDate(LastDate))
            end
            else begin
                if LastDate <> 0D then
                    Employee."Service Period text" := GetAge(NewEmploymentDate, LastDate);
            end;
        end;
    end;

    procedure GetAdjustedEmploymentDate(Employee: Record Employee; EmplymentDate: Date; EndDate: Date): Date
    var
        AdjustingDays: Integer;
        EmployeeInactiveLine: Record "Service Inactivity Ledger";
        NewEmploymentDate: Date;
        PreviousPeriod: DateFormula;
    begin
        AdjustingDays := 0;
        if EmplymentDate <> 0D then begin
            NewEmploymentDate := EmplymentDate;
            EmployeeInactiveLine.Reset();
            EmployeeInactiveLine.SetRange("Employee No.", Employee."No.");
            EmployeeInactiveLine.SetRange("Start Date", EmplymentDate, EndDate);
            if EmployeeInactiveLine.FindSet() then
                repeat
                    if not EmployeeInactiveLine."Counted In Service Period" then
                        if EmployeeInactiveLine."End Date" <> 0D then
                            AdjustingDays += EmployeeInactiveLine."End Date" - EmployeeInactiveLine."Start Date" + 1
                        else
                            AdjustingDays += WorkDate() - EmployeeInactiveLine."Start Date" + 1;
                until EmployeeInactiveLine.Next() = 0;
            NewEmploymentDate := NewEmploymentDate + AdjustingDays;
            //if there is previous service period add code hhere accordingly
            exit(NewEmploymentDate);
        end;
    end;

    procedure GetAge(BirthDate: Date; ToDate: Date) Age: Text
    var
        Year, Month, Days : Integer;
        YearText, MonthText, DayText, ReturnValue : Text;
    begin
        if ToDate < BirthDate then
            exit('-');
        GetAgeInteger(BirthDate, ToDate, Year, Month, Days);
        if Year = 1 then
            YearText := ' year'
        else
            YearText := ' years';
        if Month = 1 then
            MonthText := ' month'
        else
            MonthText := ' months';
        if Days = 1 then
            DayText := ' day'
        else
            DayText := ' days';
        Clear(ReturnValue);
        if Year > 0 then
            ReturnValue := Format(Year) + YearText + ' ';
        if Month > 0 then
            ReturnValue += Format(Month) + MonthText + ' ';
        if Days > 0 then
            ReturnValue += Format(Days) + DayText;
        exit(ReturnValue);
    end;

    procedure GetAgeInteger(BirthDate: Date; ToDate: Date; var year: Integer; var Month: Integer; var Days: Integer)
    begin
        if (ToDate <> 0D) And (BirthDate <> 0D) then begin
            year := Date2DMY(ToDate, 3) - Date2DMY(BirthDate, 3);
            Month := Date2DMY(ToDate, 2) - Date2DMY(BirthDate, 2);        //Total Service = Employment date - Today's date
            Days := Date2DMY(ToDate, 1) - Date2DMY(BirthDate, 1) + 1;  // include today
            if Days < 0 then begin
                Month := Month - 1;
                Days := Date2DMY(CalcDate('<CM>', BirthDate), 1) - Abs(Days);
            end;
            if Month < 0 then begin
                year := year - 1;
                Month := 12 - Abs(Month);
            end;
        end;
    end;

    procedure GetNextEntryNo(TableID: Integer): Integer
    var
        RecRef: RecordRef;
        FieldRefs: FieldRef;
        KeyRefs: KeyRef;
        NextEntryNo: Integer;
        PkIndex: Integer;
    begin
        NextEntryNo := 0;
        RecRef.Open(TableID);
        //check primary key is integer or not
        KeyRefs := RecRef.KeyIndex(1);
        FieldRefs := KeyRefs.FieldIndex(1);
        PkIndex := FieldRefs.Number; //Field number pf PK field
        if FieldRefs.Type <> FieldRefs.Type::Integer then
            Error('Invalid pk type');
        if RecRef.FindLast() then begin
            FieldRefs := RecRef.Field(PkIndex);
            NextEntryNo := FieldRefs.Value;
        end;
        exit(NextEntryNo + 1);
    end;

    procedure GetAgeBS(BirthDate: Code[20]; ToDate: Code[20]) Age: Text
    var
        Year, Month, Days : Integer;
        YearText, MonthText, DayText, ReturnValue : Text;
    begin
        if EngNep.getEngDate(ToDate) < EngNep.getEngDate(BirthDate) then
            exit('-');
        GetAgeIntegerBS(BirthDate, ToDate, Year, Month, Days);
        if Year = 1 then
            YearText := ' year'
        else
            YearText := ' years';
        if Month = 1 then
            MonthText := ' month'
        else
            MonthText := ' months';
        if Days = 1 then
            DayText := ' day'
        else
            DayText := ' days';
        Clear(ReturnValue);
        if Year > 0 then
            ReturnValue := Format(Year) + YearText + ' ';
        if Month > 0 then
            ReturnValue += Format(Month) + MonthText + ' ';
        if Days > 0 then
            ReturnValue += Format(Days) + DayText;
        exit(ReturnValue);
    end;

    procedure GetAgeIntegerBS(BirthDate: Code[20]; ToDate: Code[20]; var year: Integer; var Month: Integer; var Days: Integer)
    var
        EngNep: Record "English-Nepali Date";
        EngNep2: Record "English-Nepali Date";
    begin
        EngNep.SetRange("Nepali Date", BirthDate);
        if EngNep.FindFirst() then begin
            EngNep2.SetRange("Nepali Date", ToDate);
            if EngNep2.FindFirst() then begin
                year := EngNep2."Nepali year" - EngNep."Nepali Year";
                Month := EngNep2."Nepali Month".AsInteger() - EngNep."Nepali Month".AsInteger();
                Days := EngNep2."Nepali Day" - EngNep."Nepali Day" + 1;
            end;
        end;
        if Days < 0 then begin
            Month := Month - 1;
            Days := GetMonthEndDayNepali(EngNep2."Nepali Year", EngNep2."Nepali Month".AsInteger() - 1) - Abs(Days);
        end;
        if Month < 0 then begin
            year := year - 1;
            Month := 12 - Abs(Month);
        end;
    end;

    procedure GetMonthEndDayNepali(NepaliYear: Integer; NepaliMonth: Integer): Integer
    var
        EngNep2: Record "English-Nepali Date";
    begin
        EngNep2.SetRange("Nepali Year", NepaliYear);
        EngNep2.SetRange("Nepali Month", NepaliMonth);
        if EngNep2.findlast() then
            exit(EngNep2."Nepali Day");
    end;

    procedure GetLastPayDate(): Date
    var
        PayCyclePeriod: Record "Pay Cycle Period";
        PGSetUp: Record "Payroll General Setup";
    begin
        PGSetUp.Get();
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetFilter("Pay Cycle Code", PGSetUp."Pay Cycle Code");
        PayCyclePeriod.SetFilter("Pay Cycle Term", PGSetUp."Pay Cycle Term");
        PayCyclePeriod.SetRange(Posted, true);
        PayCyclePeriod.Findlast();
        exit(PayCyclePeriod."Pay Date");
    end;

    procedure GetPayCyclePeriod(StartDate: Date; Var PayCyclePeriod: Record "Pay Cycle Period"): Integer
    var
        PGSetUp: Record "Payroll General Setup";
    begin
        PGSetUp.Get();
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Term", PGSetUp."Pay Cycle Term");
        PayCyclePeriod.SetRange("Pay Cycle Code", PGSetUp."Pay Cycle Code");
        PayCyclePeriod.SetFilter("Start Date", '<=%1', StartDate);
        PayCyclePeriod.SetFilter("End Date", '>=%1', StartDate);
        PayCyclePeriod.FindFirst;
        exit(PayCyclePeriod.Period);
    end;


    procedure IsSaaS(): Boolean
    var
        EnvInfo: Codeunit "Environment Information";
    Begin
        exit(EnvInfo.IsSaaS());
    End;

    procedure CreateEmpActLedger(EmpActType: Enum "Employee Activity Type";
                                                 DocNo: Code[20];
                                                 EmpNo: Code[20];
                                                 ActDate: Date;
                                                 Cancelled: Boolean;
                                                 Days: Decimal)
    var
        EmpActLedgerEntry: Record "Emp. Act. Ledger Entry";
        Leave: Record Leave;
    begin
        if EmpActLedgerEntry.Get(EmpActType, DocNo, EmpNo, ActDate, Cancelled) then
            exit;
        EmpActLedgerEntry.init();
        EmpActLedgerEntry."Document Type" := EmpActType;
        EmpActLedgerEntry."Document No." := DocNo;
        EmpActLedgerEntry.Validate("Employee No.", EmpNo);
        EmpActLedgerEntry."Event Date" := ActDate;
        EmpActLedgerEntry."Cancellation Entry" := Cancelled;
        if Cancelled then
            EmpActLedgerEntry.Day := -Days
        else
            EmpActLedgerEntry.Day := Days;
        if EmpActType = EmpActType::"Leave Request" then
            if Leave.Get(DocNo) then begin
                EmpActLedgerEntry."Leave Type" := Leave."Leave Type";
                EmpActLedgerEntry."Leave Code" := Leave."Leave Code";
            end;
        OnBeforeInsertEmpActLedger(EmpActType, DocNo, EmpNo, ActDate, EmpActLedgerEntry);
        EmpActLedgerEntry.insert();
    end;

    procedure DeleteExistingActivityLedgerEntries(DocumentType: Enum "Employee Activity Type"; DocumentNo: Code[20])
    var
        EmpActLedgerEntry: Record "Emp. Act. Ledger Entry";
    begin
        EmpActLedgerEntry.Reset();
        EmpActLedgerEntry.SetRange("Document Type", DocumentType);
        EmpActLedgerEntry.SetRange("Document No.", DocumentNo);
        EmpActLedgerEntry.DeleteAll();
    end;

    procedure CancelEmpActLedgerForDateRange(EmpActType: Enum "Employee Activity Type";
                                                             DocNo: Code[20];
                                                             EmpNo: Code[20];
                                                             StartDate: Date;
                                                             EndDate: Date)
    var
        EmpActLedgerEntry: Record "Emp. Act. Ledger Entry";
        DateVar: Record Date;
    begin
        DateVar.SetRange("Period Type", DateVar."Period Type"::Date);
        DateVar.SetRange("Period Start", StartDate, EndDate);
        if DateVar.FindSet() then
            repeat
                Clear(EmpActLedgerEntry);
                if EmpActLedgerEntry.Get(EmpActType, DocNo, EmpNo, DateVar."Period Start", false) then
                    EmpActLedgerEntry.Rename(EmpActType, DocNo, EmpNo, DateVar."Period Start", true);
            until DateVar.Next() = 0;
    end;

    procedure CreateEmpActLedgerForDateRange(
                                    EmpActType: Enum "Employee Activity Type";
                                                    DocNo: Code[20];
                                                    EmpNo: Code[20];
                                                    StartDate: Date;
                                                    EndDate: Date)
    var
        DateRec: Record Date;
    begin
        DateRec.SetRange("Period Type", DateRec."Period Type"::Date);
        DateRec.SetRange("Period Start", StartDate, EndDate);
        if DateRec.FindSet() then
            repeat
                CreateEmpActLedger(
                    EmpActType,
                    DocNo,
                    EmpNo,
                    DateRec."Period Start",
                    false,
                    1
                );
            until DateRec.Next() = 0;
    end;

    procedure GetCompanyOneLineAddress(var CompanyName: Text[100]; var CompanyOneLineAddress: Text[250]; var CompanyCommunicationAddress: Text[250])
    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
    begin
        CompanyInfo.Get();
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        CompanyAddr[1] := CompanyInfo.Name;
        CompanyName := CompanyAddr[1];
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

    local procedure OneLineAddress(var AddrArray: array[8] of Text[50]) OneLineAddress: Text
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

    procedure LookupEmployeeByOrgStructure(ProvinceCode: Code[20]; BranchCode: Code[20]; DepartmentCode: Code[20]; UnitCode: Code[20]; EmpCode: Code[20]): Code[20]
    var
        EmployeeRec: Record Employee;
        EmployeeListPage: Page "Employee List";
    begin
        if EmpCode <> '' then
            EmployeeRec.SetRange("No.", EmpCode);
        if ProvinceCode <> '' then
            EmployeeRec.SetRange("Province Code", ProvinceCode);
        if BranchCode <> '' then
            EmployeeRec.SetRange("Branch Code", BranchCode);
        if DepartmentCode <> '' then
            EmployeeRec.SetRange("Department Code", DepartmentCode);
        if UnitCode <> '' then
            EmployeeRec.SetRange("Unit Code", UnitCode);
        EmployeeRec.SetRange(Status, EmployeeRec.Status::Active);

        EmployeeListPage.LookupMode(true);
        EmployeeListPage.SetTableView(EmployeeRec);
        if EmployeeListPage.RunModal() = ACTION::LookupOK then begin
            EmployeeListPage.GetRecord(EmployeeRec);
            exit(EmployeeRec."No.");
        end;
    end;

    procedure AssignEmployeeSeniority()
    var
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;
        EmployeeCount: Integer;
    begin
        SalaryLevel.Reset();
        SalaryLevel.SetFilter(Rank, '>%1', 0);
        if SalaryLevel.FindSet() then
            repeat

                EmployeeCount := 0;
                SalaryLevel.TestField(Rank);

                Employee.Reset();
                Employee.SetCurrentKey("Employment Date");
                Employee.SetRange("Salary Level", SalaryLevel.Code);
                Employee.SetRange(Status, Employee.Status::Active);
                Employee.SetAscending("Employment Date", false);
                if Employee.FindSet() then
                    repeat
                        EmployeeCount += 1;
                        Employee.Seniority := SalaryLevel.Rank * 1000 + EmployeeCount;
                        Employee.Modify();
                    until Employee.Next() = 0;

            until SalaryLevel.Next() = 0;
    end;

    procedure IsHRApprover(EmployeeNo: Code[20]): Boolean
    var
        HRSetup: Record "Human Resources Setup";
        Employee: Record Employee;
    begin
        if not HRSetup.Get() then
            exit(false);
        if not Employee.Get(EmployeeNo) then
            exit(false);
        if HRSetup."HR Department Code" <> '' then begin
            if HRSetup."HR Head Functional Title" = '' then begin
                if Employee."Department Code" = HRSetup."HR Department Code" then
                    exit(true);
            end else begin
                if (Employee."Functional Title" = HRSetup."HR Head Functional Title") and
                   (Employee."Department Code" = HRSetup."HR Department Code") then
                    exit(true);
            end;
        end;
        exit(false);
    end;

    procedure CheckforFiscalYearcontrol(IncomingDate: Date)
    var
        IsHandled: Boolean;
    begin
        OnBeforeCheckFiscalYearControl(IncomingDate, IsHandled);
        if IsHandled then
            exit;
        PayrollSetup.Get();
        if IncomingDate < PayrollSetup."Payroll Fiscal Year Start Date" then
            Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
    end;

    procedure LookupRelatives(EmpNo: Code[60]): Text
    var
        EmpRelativesRec: Record "Employee Relative";
        EmpRelativesPage: Page "Employee Relatives";
    begin
        Clear(EmpRelativesPage);
        EmpRelativesRec.Reset;
        EmpRelativesRec.SetRange("Employee No.", EmpNo);
        EmpRelativesRec.SetRange("Is Medical Insurance Eligible", true);
        EmpRelativesPage.SetRecord(EmpRelativesRec);
        EmpRelativesPage.SetTableView(EmpRelativesRec);
        EmpRelativesPage.LookupMode(true);
        if EmpRelativesPage.RunModal = ACTION::LookupOK then begin
            EmpRelativesPage.GetRecord(EmpRelativesRec);
            exit(EmpRelativesRec."Full Name");
        end;
    end;

    procedure UpdateCompulsoryRetirement()
    begin
        UpdateCompulsoryRetirementIntegrationEvent();
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertEmpActLedger(EmpActType: Enum "Employee Activity Type"; DocNo: Code[20];
                                                               EmpNo: Code[20];
                                                               ActDate: Date; var EmpActLedgerEntry: Record "Emp. Act. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCreateEmailFromTemplate(var TableNo: Integer; var DocumentType: enum "Employee Activity Type";
                              var ApprovalStatus: Enum "approval status";
                              var EmployeeNo: Text;
                              var DocumentNo: Code[20];
                              var Cancelled: Boolean;
                              var IsHandled: Boolean);
    begin
        //Can be used to changes or modify any paramater before Create Email From Template
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckFiscalYearControl(IncomingDate: Date; var IsHandled: Boolean);
    begin
        //Can be Used to skp Fiscal year control on request
    end;


    [IntegrationEvent(false, false)]
    procedure OnAfterWorkStation(Employee: Record Employee; WorkSation: Text);
    begin
        //Can be used to get Work Sation of Employee;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCalculationOfAcutalOrProjectedContribution(var RetirementFund: Record "Retirement Fund");
    begin
        //To add additional contribution if any
    end;

    [IntegrationEvent(false, false)]
    local procedure UpdateCompulsoryRetirementIntegrationEvent()
    begin

    end;
}
