report 50077 "Service Event Update"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Employee Service Event")
                {
                    field("Service Event"; ServiceEvent)
                    {
                        ValuesAllowed = Appointment, Confirmation, "On The Job Training", "Contract Renew", "Expired Contract", "Period Extend", "Change Of Employment status", "Change Details";
                        ToolTip = 'Specifies the value of the Service Event field.';
                        ApplicationArea = All;
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            UpdateFieldVisibility();
                        end;
                    }
                }

                group("Appointment Details")
                {
                    Caption = 'Appointment Details';
                    Visible = ShowAppointmentFields;

                    field("Functional Title"; FunctionalTitle)
                    {
                        TableRelation = "Functional Title";
                        ToolTip = 'Specifies the value of the FunctionalTitle field.';
                        ApplicationArea = All;
                    }
                    field("Salary level"; SalaryLevel)
                    {
                        TableRelation = "Salary Level";
                        ToolTip = 'Specifies the value of the SalaryLevel field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field(SalaryGrade; SalaryGrade)
                    {
                        TableRelation = "Salary Grade";
                        ToolTip = 'Specifies the value of the SalaryGrade field.';
                        ApplicationArea = All;
                    }
                    field("Employment Type"; EmploymentType)
                    {
                        ToolTip = 'Specifies the value of the EmploymentType field.';
                        ApplicationArea = All;
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            UpdateFieldVisibility();
                        end;
                    }
                    field("Effective Date"; EffectiveDate)
                    {
                        ToolTip = 'Specifies the value of the EffectiveDate field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("Deputation On"; DeputationOnTo)
                    {
                        ToolTip = 'Specifies the value of the DeputationOnTo field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if DeputationOnTo <> DeputationOnTo::Branch then
                                Clear(ProvinceCode);
                        end;
                    }
                    field(ProvinceCode; ProvinceCode)
                    {
                        Caption = 'Province Code';
                        ToolTip = 'Specifies the value of the Province Code field.';
                        ApplicationArea = All;
                        // Editable = DeputationOnTo = DeputationOnTo::Branch;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ProvinceCode := GetDeputation(DeputationOnTo::Province);
                        end;
                    }
                    field("Branch Code"; BranchCode)
                    {
                        Caption = 'Branch Code';
                        ToolTip = 'Specifies the value of the Branch Code field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            BranchCode := GetDeputation(DeputationOnTo::Branch);
                        end;
                    }
                    field("Department Code"; DepartmentCode)
                    {
                        Caption = 'Department Code';
                        ToolTip = 'Specifies the value of the Department Code field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DepartmentCode := GetDeputation(DeputationOnTo::Department);
                        end;
                    }
                    field("Sub-Department Code"; SubDepartmentCode)
                    {
                        Caption = 'Sub-Department Code';
                        ToolTip = 'Specifies the value of the Sub-Department Code field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            SubDepartmentCode := GetDeputation(DeputationOnTo::Unit);
                        end;
                    }
                    field(RemarksVar; Remarks)
                    {
                        Caption = 'Remarks';
                        ToolTip = 'Specifies the value of the Remarks field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }

                    group("Probation Details")
                    {
                        ShowCaption = false;
                        Visible = ShowProbationPeriod;

                        field(ProbationPeriod; ProbationPeriod)
                        {
                            Caption = 'Probation Period';
                            ToolTip = 'Specifies the value of the Probation Period field.';
                            ApplicationArea = All;
                        }
                    }

                    group("Trainee Details")
                    {
                        ShowCaption = false;
                        Visible = ShowTraineePeriod;

                        field(TraineePeriod; ProbationPeriod)
                        {
                            Caption = 'Trainee Period';
                            ToolTip = 'Specifies the value of the Trainee Period field.';
                            ApplicationArea = All;
                        }
                    }

                    group("Contract Details")
                    {
                        ShowCaption = false;
                        Visible = ShowContractPeriod;

                        field("ContractExpiry Month"; ContractExpiryMonth)
                        {
                            Caption = 'Contract Period';
                            ToolTip = 'Specifies the value of the ContractExpiryMonth field.';
                            ApplicationArea = All;

                            trigger OnValidate()
                            begin
                                if ContractExpiryMonth <> ContractExpiryMonth::" " then begin
                                    if (EmploymentType <> EmploymentType::Contract) and (EmploymentType <> EmploymentType::Outsource) then
                                        Error('Employment type must be contract or outsource');
                                    if EffectiveDate = 0D then
                                        Error('Date must have value');
                                end;
                            end;
                        }
                    }
                }

                group("Confirmation Details")
                {
                    Caption = 'Confirmation Details';
                    Visible = ShowConfirmationFields;

                    field("Functional Title Conf"; FunctionalTitle)
                    {
                        Caption = 'Functional Title';
                        TableRelation = "Functional Title";
                        ToolTip = 'Specifies the value of the FunctionalTitle field.';
                        ApplicationArea = All;
                    }
                    field("Salary level Conf"; SalaryLevel)
                    {
                        Caption = 'Salary Level';
                        TableRelation = "Salary Level";
                        ToolTip = 'Specifies the value of the SalaryLevel field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("Deputation On Conf"; DeputationOnTo)
                    {
                        Caption = 'Deputation On';
                        ToolTip = 'Specifies the value of the DeputationOnTo field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if DeputationOnTo <> DeputationOnTo::Branch then
                                Clear(ProvinceCode);
                        end;
                    }
                    field("Province Code Conf"; ProvinceCode)
                    {
                        Caption = 'Province Code';
                        ToolTip = 'Specifies the value of the Province Code field.';
                        ApplicationArea = All;
                        //Editable = DeputationOnTo = DeputationOnTo::Branch;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ProvinceCode := GetDeputation(DeputationOnTo::Province);
                        end;
                    }
                    field("Branch Code Conf"; BranchCode)
                    {
                        Caption = 'Branch Code';
                        ToolTip = 'Specifies the value of the Branch Code field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            BranchCode := GetDeputation(DeputationOnTo::Branch);
                        end;
                    }
                    field("Department Code Conf"; DepartmentCode)
                    {
                        Caption = 'Department Code';
                        ToolTip = 'Specifies the value of the Department Code field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DepartmentCode := GetDeputation(DeputationOnTo::Department);
                        end;
                    }
                    field("Sub-Department Code Conf"; SubDepartmentCode)
                    {
                        Caption = 'Sub-Department Code';
                        ToolTip = 'Specifies the value of the Sub-Department Code field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            SubDepartmentCode := GetDeputation(DeputationOnTo::Unit);
                        end;
                    }
                    field("Remarks Conf"; Remarks)
                    {
                        Caption = 'Remarks';
                        ToolTip = 'Specifies the value of the Remarks field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field(EffectiveDate; EffectiveDate)
                    {
                        caption = 'Confirmation Date';
                        ToolTip = 'Specifies the value of Confirmation Date';
                        ApplicationArea = All;
                        ShowMandatory = true;

                    }
                }
                group("Period Extend Fields")
                {
                    visible = ShowPeriodExtendFields;
                    caption = 'Period Extend';
                    field(EmploymentType; EmploymentType)
                    {
                        Caption = 'Employment Type';
                        TableRelation = Employee."Employment Type";
                        ToolTip = '';
                        ApplicationArea = All;
                        ShowMandatory = true;

                    }

                }

                group("Hidden Fields")
                {
                    Visible = false;

                    field("Deputation Code"; DeputationCodeTo)
                    {
                        ToolTip = 'Specifies the value of the DeputationCodeTo field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DeputationCodeTo := GetDeputation(DeputationOnTo);
                        end;
                    }
                }
            }
        }

        actions { }

        trigger OnOpenPage()
        begin
            UpdateFieldVisibility();
        end;
    }

    trigger OnPreReport()
    var
        ProbationEndDate: Date;
        ProbationFormula: Text;
        TraineeFormula: Text;
        TraineeEndDate: Date;
    begin
        Employee.Get(EmpNo);

        if ServiceEvent = ServiceEvent::" " then
            Error('Please fill Service Event field');

        if ServiceEvent = ServiceEvent::Appointment then begin

            if EffectiveDate = 0D then
                Error('Please fill Effective Date field');
            if EmploymentType = EmploymentType::" " then
                Error('Please fill Employment Type values');
            if EmploymentType in [EmploymentType::Contract, EmploymentType::Outsource] then
                if ContractExpiryMonth = ContractExpiryMonth::" " then
                    Error('Contract Expiry Month must have value.');
            if EmploymentType = EmploymentType::Probation then
                if ProbationPeriod = ProbationPeriod::" " then
                    Error('Probation Period must have value.')
                else begin
                    Employee.Validate("Probation Period", ProbationPeriod);
                    if ProbationPeriod = ProbationPeriod::"6 Month" then
                        ProbationFormula := '6M';
                    if ProbationPeriod = ProbationPeriod::"12 Month" then
                        ProbationFormula := '1Y';
                    ProbationEndDate := CalcDate(ProbationFormula, EffectiveDate);
                    Employee.Validate("Trainee/Probation End date", ProbationEndDate);
                end;
            if EmploymentType = EmploymentType::Temporary then
                if format(TraineePeriod) = '' then
                    Error('Trainee Period must have value.')
                else begin
                    Employee.Validate("Trainee Period", TraineePeriod);
                    if TraineePeriod = TraineePeriod::"6 Month" then
                        TraineeFormula := '6M';
                    if TraineePeriod = TraineePeriod::"12 Month" then
                        TraineeFormula := '1Y';
                    TraineeEndDate := CalcDate(TraineeFormula, EffectiveDate);
                    Employee.Validate("Trainee/Probation End date", TraineeEndDate);
                end;
        end;

        if ServiceEvent in [ServiceEvent::Appointment, ServiceEvent::Confirmation] then begin
            if DeputationOnTo <> DeputationOnTo::" " then
                Employee.Validate("Deputation on", DeputationOnTo);

            if FunctionalTitle <> '' then
                Employee.Validate("Functional Title", FunctionalTitle);
            if SalaryLevel <> '' then
                Employee.Validate("Salary Level", SalaryLevel);
            if SalaryGrade <> '' then
                Employee.Validate("Salary Grade", SalaryGrade);
            if FunctionalTitle <> '' then
                Employee.Validate("Functional Title", FunctionalTitle);
            if ProvinceCode <> '' then
                Employee.Validate("Province Code", ProvinceCode);
            if BranchCode <> '' then
                Employee.Validate("Branch Code", BranchCode);
            if DepartmentCode <> '' then
                Employee.Validate("Department Code", DepartmentCode);

            if ProbationPeriod <> ProbationPeriod::" " then
                Employee.Validate("Probation Period", ProbationPeriod);
            if format(TraineePeriod) <> '' then
                Employee.validate("Trainee Period", TraineePeriod);


            if EmploymentType <> EmploymentType::" " then
                Employee.Validate("Employment Type", EmploymentType);
            if EmploymentType = EmploymentType::Permanent then
                Employee."Confirmation Date" := EffectiveDate;
            if EffectiveDate <> 0D then
                Employee.Validate("Employment Date", EffectiveDate);

            if ServiceEvent = ServiceEvent::Confirmation then
                Employee.Validate("Employment Type", Employee."Employment Type"::Permanent);

            if EmploymentType in [EmploymentType::Contract, EmploymentType::Outsource] then
                Employee.Validate("Contract Expiry Month", ContractExpiryMonth);
        end;

        if ServiceEvent = ServiceEvent::"Contract Renew" then
            Employee.Validate("Contract Renew Date", EffectiveDate);

        ValidateDeputationOnCode();

        Employee.Modify;
        PayrollEngine.InsertPayrollAttributesUsage(Employee."No.");

        ServiceHistory.Init;
        ServiceHistory.Validate("Employee No.", Employee."No.");
        ServiceHistory.Validate("Effective Date", EffectiveDate);
        ServiceHistory.Validate("Service Event", ServiceEvent);
        ServiceHistory.Validate(Remarks, Remarks);
        ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
        ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
        ServiceHistory.Validate("Deputation On (To)", DeputationOnTo);
        ServiceHistory.Validate("Deputation Code (To)", DeputationCodeTo);
        ServiceHistory.Validate("Deputation Value (To)", ServiceHistoryMgt.ExitTransferDeputationWiseValue(DeputationOnTo, ServiceHistory."Employee No."));
        ServiceHistory.Insert(true);
    end;

    trigger OnPostReport()
    begin
        Message('Success');
    end;

    var
        DeputationOnFrom, DeputationOnTo : Enum "Deputation Type";
        ServiceEvent: Enum "Service Event";
        DeputationCodeTo: Code[20];
        ProvinceCode: Code[20];
        BranchCode: Code[20];
        DepartmentCode: Code[20];
        SubDepartmentCode: Code[20];
        PageProvince: Page "Provinces List";
        GLSetup: Record "General Ledger Setup";
        Employee: Record Employee;
        EffectiveDate: Date;
        HRMgt: Codeunit "HR Mgt.";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        Remarks: Text;
        EmpNo: Code[20];
        FunctionalTitle: Code[20];
        SalaryLevel: Code[20];
        EmploymentType: enum "Employee Type";
        ContractExpiryMonth: Enum "Contract Expiry Date";
        SalaryGrade: Code[20];
        ServiceHistory: Record "Employee Service History";
        PayrollEngine: Codeunit "Payroll Engine";
        ProbationPeriod: Enum "Probation Period";
        TraineePeriod: Enum "Trainee Period";


        // Visibility Controls
        ShowAppointmentFields: Boolean;
        ShowConfirmationFields: Boolean;
        ShowProbationPeriod: Boolean;
        ShowTraineePeriod: Boolean;
        ShowContractPeriod: Boolean;
        ShowPeriodExtendFields: Boolean;

    local procedure UpdateFieldVisibility()
    begin
        ShowAppointmentFields := false;
        ShowConfirmationFields := false;
        ShowProbationPeriod := false;
        ShowTraineePeriod := false;
        ShowContractPeriod := false;
        ShowPeriodExtendFields := false;

        case ServiceEvent of
            ServiceEvent::Appointment:
                ShowAppointmentFields := true;
            ServiceEvent::Confirmation:
                ShowConfirmationFields := true;
            ServiceEvent::"Period Extend":
                ShowPeriodExtendFields := true;
        end;

        case EmploymentType of
            EmploymentType::Probation:
                ShowProbationPeriod := true;
            EmploymentType::Temporary:
                ShowTraineePeriod := true;
            EmploymentType::Contract, EmploymentType::Outsource:
                ShowContractPeriod := true;
        end;
    end;

    local procedure GetDeputation(Deputation: Enum "Deputation Type"): Code[20]
    var
        OrgStructureList: Record "Organization Structure List";
        OrgStructureListPage: Page "Organization Structure list";
    begin
        OrgStructureList.SetRange(Type, Deputation);
        OrgStructureList.SetRange(Blocked, false);
        Clear(OrgStructureListPage);
        OrgStructureListPage.LookupMode(true);
        OrgStructureListPage.SetTableView(OrgStructureList);
        OrgStructureListPage.SetRecord(OrgStructureList);
        if OrgStructureListPage.RunModal() = Action::LookupOK then begin
            OrgStructureListPage.GetRecord(OrgStructureList);
            exit(OrgStructureList.Code);
        end;
    end;

    local procedure ValidateDeputationOnCode()
    begin
        Employee.Validate("Deputation on", DeputationOnTo);
        case DeputationOnTo of
            DeputationOnTo::Province:
                Employee.Validate("Province Code", ProvinceCode);
            DeputationOnTo::Branch:
                begin
                    Employee.Validate("Province Code", ProvinceCode);
                    Employee.Validate("Branch Code", BranchCode);
                end;
            DeputationOnTo::Department:
                Employee.Validate("Department Code", DepartmentCode);
            DeputationOnTo::"Extension Counter":
                Employee.Validate("Extension Counter Code", DeputationCodeTo);
            DeputationOnTo::Unit:
                Employee.Validate("Unit Code", SubDepartmentCode);
        end;
    end;

    procedure SetAppointment(EmpCode: Code[20])
    begin
        EmpNo := EmpCode;
    end;



}
