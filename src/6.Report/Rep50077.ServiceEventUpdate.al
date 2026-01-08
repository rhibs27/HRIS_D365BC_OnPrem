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
                        ValuesAllowed = Appointment, Confirmation, "First Deputation", "On The Job Training", "Contract Renew", "Expired Contract";
                        ToolTip = 'Specifies the value of the Service Event field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("Functional Title"; FunctionalTitle)
                    {
                        TableRelation = "Functional Title";
                        ToolTip = 'Specifies the value of the FunctionalTitle field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
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
                        Editable = DeputationOnTo = DeputationOnTo::Branch;
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ProvinceCode := GetDeputation(DeputationOnTo::Province);
                        end;
                    }
                    field("Deputation Code"; DeputationCodeTo)
                    {
                        ToolTip = 'Specifies the value of the DeputationCodeTo field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DeputationCodeTo := GetDeputation(DeputationOnTo);
                        end;
                    }
                    field(RemarksVar; Remarks)
                    {
                        Caption = 'Remarks';
                        ToolTip = 'Specifies the value of the Remarks field.';
                        ApplicationArea = All;
                        // ShowMandatory = true;
                    }
                    field("Employment Type"; EmploymentType)
                    {
                        ToolTip = 'Specifies the value of the EmploymentType field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("Effective Date"; EffectiveDate)
                    {
                        ToolTip = 'Specifies the value of the EffectiveDate field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("ContractExpiry Month"; ContractExpiryMonth)
                    {
                        ToolTip = 'Specifies the value of the ContractExpiryMonth field.';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if ContractExpiryMonth <> ContractExpiryMonth::" " then begin
                                if EmploymentType <> EmploymentType::Contract then
                                    Error('Employment type must be contract');
                                if EffectiveDate = 0D then
                                    Error('Date must have value');
                            end;
                        end;
                    }
                    field("Contract Expiry Date"; ContractExpiryDate)
                    {
                        ToolTip = 'Specifies the value of the Contract Expiry Date field.';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if EmploymentType <> EmploymentType::Contract then
                                Error('Employment type must be contract');
                            if EffectiveDate = 0D then
                                Error('Date must have value');
                        end;
                    }
                    field(ProbationPeriod; ProbationPeriod)
                    {
                        Caption = 'Probation Period';
                        ToolTip = 'Specifies the value of the Probation Period field.';
                        ApplicationArea = All;
                    }
                    field(ContractCode; ContractCode)
                    {
                        Caption = 'Contract Code';
                        TableRelation = "Employment Contract";
                        ToolTip = 'Specifies the value of the Contract Code field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions { }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction in [Action::OK, Action::LookupOK] then
                ValidateRequiredFields();
            exit(true);
        end;
    }

    labels { }

    trigger OnPostReport()
    begin
        Message('Success');
    end;

    trigger OnPreReport()
    begin
        Employee.Get(EmpNo);
        if ServiceEvent = ServiceEvent::" " then
            Error('Please fill Service Event field');
        if EffectiveDate = 0D then
            Error('Please fill Effective Date field');
        if (EmploymentType = EmploymentType::" ") then
            Error('Please fill Employment Type values');
        if ServiceEvent = ServiceEvent::"Re Appointment" then
            if ContractCode = '' then
                Error('Please fill Contract Code field')
            else
                Employee.Validate("Emplymt. Contract Code", ContractCode);
        if EmploymentType = EmploymentType::Contract then
            if ContractExpiryDate = 0D then
                if ContractExpiryMonth = ContractExpiryMonth::" " then
                    Error('Contract Expiry Month must have value.');
        if EmploymentType = EmploymentType::Probation then
            if ProbationPeriod = ProbationPeriod::" " then
                Error('Probation Period must have value.')
            else
                Employee.Validate("Probation Period", ProbationPeriod);
        PayrollEngine.InsertPayrollAttributesUsage(Employee."No.");
        ServiceHistory.Init;
        ServiceHistory.Validate("Employee No.", Employee."No.");
        ServiceHistory.Validate("Effective Date", EffectiveDate);
        ServiceHistory.Validate("Service Event", ServiceEvent);
        ServiceHistory.Validate(Remarks, Remarks);
        ServiceHistory.Validate("Functional Title (To)", FunctionalTitle);
        ServiceHistory.Validate("Contract Code (To)", ContractCode);
        ServiceHistory.Validate("Employment Type (To)", EmploymentType);
        ServiceHistory.Validate("Salary Level (To)", SalaryLevel);
        ServiceHistory.Validate("Salary Grade (To)", SalaryGrade);
        ServiceHistory.Validate("Deputation On (To)", DeputationOnTo);
        ServiceHistory.Validate("Deputation Code (To)", DeputationCodeTo);
        ServiceHistory.Validate("Deputation Value (To)", ServiceHistoryMgt.ExitTransferDeputationWiseValue(DeputationOnTo, ServiceHistory."Employee No."));
        ServiceHistory.Insert(true);
        if FunctionalTitle <> '' then
            Employee.Validate("Functional Title", FunctionalTitle);
        Employee.Validate("Salary Level", SalaryLevel);
        Employee.Validate("Salary Grade", SalaryGrade);
        if EmploymentType = EmploymentType::Permanent then
            Employee.Validate("Confirmation Date", EffectiveDate);
        Employee.Validate("Employment Type", EmploymentType);
        if ServiceEvent = ServiceEvent::Appointment then
            Employee.Validate("Employment Date", EffectiveDate)
        else if ServiceEvent = ServiceEvent::"Contract Renew" then
            Employee.Validate("Contract Renew Date", EffectiveDate);
        if EmploymentType = EmploymentType::Contract then begin
            Employee.Validate("Contract Expiry Month", ContractExpiryMonth);
            Employee.Validate("Contract Expiry Date", ContractExpiryDate);
        end;
        if ServiceEvent = ServiceEvent::Confirmation then begin
            if (DeputationOnTo <> DeputationOnTo::" ") and (DeputationCodeTo <> '') then
                ValidateDeputationOnCode();
        end else
            ValidateDeputationOnCode();
        Employee.Modify;
    end;

    var
        DeputationOnTo : Enum "Deputation Type";
        ServiceEvent: Enum "Service Event";
        DeputationCodeTo: Code[20];
        ProvinceCode: Code[20];
        Employee: Record Employee;
        EffectiveDate: Date;
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        Remarks: Text;
        EmpNo: Code[20];
        FunctionalTitle: Code[20];
        SalaryLevel: Code[20];
        EmploymentType: enum "Employee Type";
        ContractExpiryMonth: Enum "Contract Expiry Date";
        ContractExpiryDate: Date;
        SalaryGrade: Code[20];
        ServiceHistory: Record "Employee Service History";
        PayrollEngine: Codeunit "Payroll Engine";
        ProbationPeriod: Enum "Probation Period";
        ContractCode: Code[10];

    local procedure GetDeputation(Deputation: Enum "Deputation Type"): Code[20]
    var
        OrgStructureList: Record "Organization Structure List";
        OrgStructureListPage: Page "Organization Structure list";
    begin
        case Deputation of
            Deputation::Province:
                begin
                    OrgStructureList.SetRange(Type, OrgStructureList.Type::Province);
                    OrgStructureList.SetRange(Blocked, false);
                    Clear(OrgStructureListPage);
                    OrgStructureListPage.LookupMode(true);
                    OrgStructureListPage.SetTableView(OrgStructureList);
                    OrgStructureListPage.SetRecord(OrgStructureList);
                    if OrgStructureListPage.RunModal() = Action::LookupOK then begin
                        OrgStructureListPage.GetRecord(OrgStructureList);
                        exit(OrgStructureList.Code)
                    end;
                end;

            Deputation::Branch:
                begin
                    OrgStructureList.SetRange(Type, OrgStructureList.Type::Branch);
                    OrgStructureList.SetRange(Blocked, false);
                    Clear(OrgStructureListPage);
                    OrgStructureListPage.LookupMode(true);
                    OrgStructureListPage.SetTableView(OrgStructureList);
                    OrgStructureListPage.SetRecord(OrgStructureList);
                    if OrgStructureListPage.RunModal() = Action::LookupOK then begin
                        OrgStructureListPage.GetRecord(OrgStructureList);
                        exit(OrgStructureList.Code)
                    end;
                end;

            Deputation::Department:
                begin
                    OrgStructureList.SetRange(Type, OrgStructureList.Type::Department);
                    OrgStructureList.SetRange(Blocked, false);
                    Clear(OrgStructureListPage);
                    OrgStructureListPage.LookupMode(true);
                    OrgStructureListPage.SetTableView(OrgStructureList);
                    OrgStructureListPage.SetRecord(OrgStructureList);
                    if OrgStructureListPage.RunModal() = Action::LookupOK then begin
                        OrgStructureListPage.GetRecord(OrgStructureList);
                        exit(OrgStructureList.Code)
                    end;
                end;

            Deputation::"Extension Counter":
                begin
                    OrgStructureList.SetRange(Type, OrgStructureList.Type::"Extension Counter");
                    OrgStructureList.SetRange(Blocked, false);
                    Clear(OrgStructureListPage);
                    OrgStructureListPage.LookupMode(true);
                    OrgStructureListPage.SetTableView(OrgStructureList);
                    OrgStructureListPage.SetRecord(OrgStructureList);
                    if OrgStructureListPage.RunModal() = Action::LookupOK then begin
                        OrgStructureListPage.GetRecord(OrgStructureList);
                        exit(OrgStructureList.Code)
                    end;
                end;

            Deputation::Unit:
                begin
                    OrgStructureList.SetRange(Type, OrgStructureList.Type::Unit);
                    OrgStructureList.SetRange(Blocked, false);
                    Clear(OrgStructureListPage);
                    OrgStructureListPage.LookupMode(true);
                    OrgStructureListPage.SetTableView(OrgStructureList);
                    OrgStructureListPage.SetRecord(OrgStructureList);
                    if OrgStructureListPage.RunModal() = Action::LookupOK then begin
                        OrgStructureListPage.GetRecord(OrgStructureList);
                        exit(OrgStructureList.Code)
                    end;
                end;
        end;
    end;

    local procedure ValidateDeputationOnCode()
    begin
        Employee.Validate("Deputation on", DeputationOnTo);
        case DeputationOnTo of
            DeputationOnTo::Province:
                Employee.Validate("Province Code", DeputationCodeTo);

            DeputationOnTo::Branch:
                begin
                    Employee.Validate("Province Code", ProvinceCode);
                    Employee.Validate("Branch Code", DeputationCodeTo);
                end;

            DeputationOnTo::Department:
                Employee.Validate("Department Code", DeputationCodeTo);

            DeputationOnTo::"Extension Counter":
                Employee.Validate("Extension Counter Code", DeputationCodeTo);

            DeputationOnTo::Unit:
                Employee.Validate("Unit Code", DeputationCodeTo);
        end;
    end;

    procedure SetAppointment(EmpCode: Code[20])
    begin
        // IsAppointment := true;
        EmpNo := EmpCode;
    end;

    local procedure ValidateRequiredFields(): Boolean
    var
        MissingFieldErr: Label '%1 cannot be blank.';
    begin
        if ServiceEvent = ServiceEvent::" " then
            Error(MissingFieldErr, 'Service Event');
        if FunctionalTitle = '' then
            Error(MissingFieldErr, 'Functional Title');

        if SalaryLevel = '' then
            Error(MissingFieldErr, 'Salary Level');

        if EmploymentType = EmploymentType::" " then
            Error(MissingFieldErr, 'Employment Type');

        if EffectiveDate = 0D then
            Error(MissingFieldErr, 'Effective Date');

        if EmploymentType = EmploymentType::Contract then
            if ContractExpiryDate = 0D then
                if ContractExpiryMonth = ContractExpiryMonth::" " then
                    Error('Contract Expiry Month must have value.');
        if EmploymentType = EmploymentType::Probation then
            if ProbationPeriod = ProbationPeriod::" " then
                Error('Probation Period must have value.');
    end;
}
