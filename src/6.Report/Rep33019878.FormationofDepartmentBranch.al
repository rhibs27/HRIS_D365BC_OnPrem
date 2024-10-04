report 33019878 "Formation of Department/Branch"
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
                group("Formation of Branch/Department")
                {
                    Visible = not IsAppointment;
                    field("Deputation On (From)"; DeputationOnFrom)
                    {
                        ToolTip = 'Specifies the value of the DeputationOnFrom field.';
                        ApplicationArea = All;
                    }
                    field("Deputation Code (From)"; DeputationCodeFrom)
                    {
                        ToolTip = 'Specifies the value of the DeputationCodeFrom field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DeputationCodeFrom := GetDeputation(DeputationOnFrom);
                        end;
                    }
                    field("Deputation On (To)"; DeputationOnTo)
                    {
                        ToolTip = 'Specifies the value of the DeputationOnTo field.';
                        ApplicationArea = All;
                    }
                    field("Deputation Code (To)"; DeputationCodeTo)
                    {
                        ToolTip = 'Specifies the value of the DeputationCodeTo field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DeputationCodeTo := GetDeputation(DeputationOnTo);
                        end;
                    }
                    field(Remarks; Remarks)
                    {
                        ToolTip = 'Specifies the value of the Remarks field.';
                        ApplicationArea = All;
                    }
                    field("Effective date"; EffectiveDate)
                    {
                        ToolTip = 'Specifies the value of the EffectiveDate field.';
                        ApplicationArea = All;
                    }
                    field(Block; BlockedDeputationFrom)
                    {
                        Caption = ' Block Deputation Code(From)';
                        ToolTip = 'Specifies the value of the  Block Deputation Code(From) field.';
                        ApplicationArea = All;
                    }
                }
                group(Appointment)
                {
                    Visible = IsAppointment;
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
                    }
                    field("Employment Type"; EmploymentType)
                    {
                        ToolTip = 'Specifies the value of the EmploymentType field.';
                        ApplicationArea = All;
                    }
                    field("Employment Date"; EffectiveDate)
                    {
                        ToolTip = 'Specifies the value of the EffectiveDate field.';
                        ApplicationArea = All;
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
                    field(ProbationPeriod; ProbationPeriod)
                    {
                        Caption = 'Probation Period';
                        ToolTip = 'Specifies the value of the Probation Period field.';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        Message('Success');
    end;

    trigger OnPreReport()
    begin
        if not IsAppointment then begin
            if (DeputationOnFrom = DeputationOnFrom::" ") or (DeputationOnTo = DeputationOnTo::" ")
            or (DeputationCodeFrom = '') or (DeputationCodeTo = '') or (EffectiveDate = 0D) then
                Error('Please fill all the values.');

            ValidateValueForDeputationOn;
            ValidateValueForNonDeputationOn;
            if BlockedDeputationFrom then
                IfBlockDeputationCode;
        end else begin
            if (FunctionalTitle = '') or (SalaryLevel = '') or (EmploymentType = EmploymentType::" ") or
              (DeputationCodeTo = '') or (DeputationOnTo = DeputationOnTo::" ") then
                Error('Please fill all the values');
            if EmploymentType = EmploymentType::Contract then
                if ContractExpiryMonth = ContractExpiryMonth::" " then
                    Error('Contract Expiry Month must have value.');
            if EmploymentType = EmploymentType::Probation then //Min
                if ProbationPeriod = ProbationPeriod::" " then
                    Error('Probation Period must have value.');
            Employee.Get(EmpNo);
            if Employee."Deputation on" <> Employee."Deputation on"::" " then
                Error('Cannot appoint already appointed employee.');
            Employee.Validate("Functional Title", FunctionalTitle);
            Employee.Validate("Salary Level", SalaryLevel);
            Employee.Validate("Salary Grade", SalaryGrade);
            if EmploymentType = EmploymentType::Permanent then
                Employee."Confirmation Date" := EffectiveDate;
            Employee.Validate("Employment Type", EmploymentType);
            Employee.Validate("Employment Date", EffectiveDate);
            if EmploymentType = EmploymentType::Contract then
                Employee.Validate("Contract Expiry Month", ContractExpiryMonth);
            if EmploymentType = EmploymentType::Probation then //Min
                Employee.Validate("Probation Period", ProbationPeriod);
            ValdiateDeputationOnCode();
            Employee.Modify;
            PayrollEngine.InsertPayrollAttributesUsage(Employee."No.");
            ServiceHistory.Init;
            ServiceHistory.Validate("Employee No.", Employee."No.");
            ServiceHistory.Validate("Effective Date", Employee."Employment Date");
            ServiceHistory.Validate("Service Event", ServiceHistory."Service Event"::Appointment);
            ServiceHistory.Validate(Remarks, Remarks);
            ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
            ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
            ServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
            ServiceHistory.Validate("Deputation Code (To)", HRMgt.ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Validate("Deputation Value (To)", HRMgt.ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Insert(true);
        end;
    end;

    var
        DeputationOnFrom: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department;
        DeputationOnTo: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department;
        DeputationCodeFrom: Code[20];
        DeputationCodeTo: Code[20];
        Province: Record Province;
        PageProvince: Page "Provinces List";
        SubProvince: Record "Sub Province";
        PageSubProvince: Page SubProvinceList;
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        PageDimValue: Page "Dimension Values";
        Depart: Record Department;
        PageDepart: Page Departments;
        EmpHie: Record "Employee Hierarchy Master";
        PageEmpHie: Page "Employee Hierarchy Master";
        Employee: Record Employee;
        EffectiveDate: Date;
        EmpServiceHistory: Record "Employee Service History";
        HRMgt: Codeunit "HR Mgt.";
        Remarks: Text;
        ServiceHistoryCode: Code[20];
        BlockedDeputationFrom: Boolean;
        [InDataSet]
        IsAppointment: Boolean;
        EmpNo: Code[20];
        FunctionalTitle: Code[20];
        SalaryLevel: Code[20];
        EmploymentType: enum "Employee Type";
        ContractExpiryMonth: Option " ","01M","02M","03M","04M","05M","06M","07M","08M","09M","10M","11M","1Y";
        SalaryGrade: Code[20];
        ServiceHistory: Record "Employee Service History";
        PayrollEngine: Codeunit "Payroll Engine";
        ProbationPeriod: Option " ","6 Month","12 Month";

    local procedure GetDeputation(Deputation: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department): Code[20]
    begin
        case Deputation of
            Deputation::Province:
                begin
                    Province.Reset;
                    Province.SetRange(Blocked, false);//Min
                    Clear(PageProvince);
                    PageProvince.LookupMode(true);
                    PageProvince.SetRecord(Province);
                    PageProvince.SetTableView(Province);
                    if PageProvince.RunModal = Action::LookupOK then begin
                        PageProvince.GetRecord(Province);
                        exit(Province.Code);
                    end;
                end;

            Deputation::"Sub Province":
                begin
                    SubProvince.Reset;
                    SubProvince.SetRange(Blocked, false);//Min
                    Clear(PageSubProvince);
                    PageSubProvince.LookupMode(true);
                    PageSubProvince.SetRecord(SubProvince);
                    PageSubProvince.SetTableView(SubProvince);
                    if PageSubProvince.RunModal = Action::LookupOK then begin
                        PageSubProvince.GetRecord(SubProvince);
                        exit(SubProvince.Code);
                    end;
                end;

            Deputation::Branch:
                begin
                    GLSetup.Get;
                    DimValue.Reset;
                    DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
                    DimValue.SetRange(Blocked, false);//Min
                    Clear(PageDimValue);
                    PageDimValue.LookupMode(true);
                    PageDimValue.SetRecord(DimValue);
                    PageDimValue.SetTableView(DimValue);
                    if PageDimValue.RunModal = Action::LookupOK then begin
                        PageDimValue.GetRecord(DimValue);
                        exit(DimValue.Code);
                    end;
                end;

            Deputation::Department:
                begin
                    Depart.Reset;
                    Depart.SetRange(Blocked, false);//Min
                    Clear(PageDepart);
                    PageDepart.LookupMode(true);
                    PageDepart.SetRecord(Depart);
                    PageDepart.SetTableView(Depart);
                    if PageDepart.RunModal = Action::LookupOK then begin
                        PageDepart.GetRecord(Depart);
                        exit(Depart.Code);
                    end;
                end;

            Deputation::"Extension Counter":
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    EmpHie.SetRange(Blocked, false);//Min
                    Clear(PageEmpHie);
                    PageEmpHie.LookupMode(true);
                    PageEmpHie.SetRecord(EmpHie);
                    PageEmpHie.SetTableView(EmpHie);
                    if PageEmpHie.RunModal = Action::LookupOK then begin
                        PageEmpHie.GetRecord(EmpHie);
                        exit(EmpHie.Code);
                    end;
                end;

            Deputation::Unit:
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    EmpHie.SetRange(Blocked, false);//Min
                    Clear(PageEmpHie);
                    PageEmpHie.LookupMode(true);
                    PageEmpHie.SetRecord(EmpHie);
                    PageEmpHie.SetTableView(EmpHie);
                    if PageEmpHie.RunModal = Action::LookupOK then begin
                        PageEmpHie.GetRecord(EmpHie);
                        exit(EmpHie.Code);
                    end;
                end;
        end;
    end;

    local procedure FilterDeputationOnFrom()
    begin
        case DeputationOnFrom of
            DeputationOnFrom::Province:
                Employee.SetRange("Province Code", DeputationCodeFrom);

            DeputationOnFrom::"Sub Province":
                Employee.SetRange("Sub Province Code", DeputationCodeFrom);

            DeputationOnFrom::Branch:
                Employee.SetRange("Global Dimension 1 Code", DeputationCodeFrom);

            DeputationOnFrom::Department:
                Employee.SetRange("Department Code", DeputationCodeFrom);

            DeputationOnFrom::"Extension Counter":
                Employee.SetRange("Extension Counter Code", DeputationCodeFrom);

            DeputationOnFrom::Unit:
                Employee.SetRange("Unit Code", DeputationCodeFrom);
        end;
    end;

    local procedure ValdiateDeputationOnCode()
    begin
        Employee.Validate("Deputation on", DeputationOnTo);
        case DeputationOnTo of
            DeputationOnTo::Province:
                Employee.Validate("Province Code", DeputationCodeTo);

            DeputationOnTo::"Sub Province":
                Employee.Validate("Sub Province Code", DeputationCodeTo);

            DeputationOnTo::Branch:
                Employee.Validate("Global Dimension 1 Code", DeputationCodeTo);

            DeputationOnTo::Department:
                Employee.Validate("Department Code", DeputationCodeTo);

            DeputationOnTo::"Extension Counter":
                Employee.Validate("Extension Counter Code", DeputationCodeTo);

            DeputationOnTo::Unit:
                Employee.Validate("Unit Code", DeputationCodeTo);
        end;
    end;

    local procedure ValidateValueForDeputationOn()
    begin
        Employee.Reset;
        Employee.SetRange("Deputation on", DeputationOnFrom);
        FilterDeputationOnFrom;

        if Employee.Find('-') then
            repeat
                ServiceHistoryCode := HRMgt.AddToServiceHistory(Employee."No.", EmpServiceHistory."Service Event"::"Formation of Department/Unit/Functional Title", Remarks, EffectiveDate);
                ValdiateDeputationOnCode;
                Employee.Modify;

                if EmpServiceHistory.Get(ServiceHistoryCode) then begin
                    EmpServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
                    EmpServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
                    EmpServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
                    EmpServiceHistory.Validate("Deputation Code (To)", HRMgt.ExitTransferDeputationWiseCode(Employee."Deputation on", Employee."No."));
                    EmpServiceHistory.Validate("Deputation Value (To)", HRMgt.ExitTransferDeputationWiseValue(Employee."Deputation on", Employee."No."));
                    EmpServiceHistory.Modify;
                end;
            until Employee.Next = 0;
    end;

    local procedure ValidateValueForNonDeputationOn()
    begin
        Employee.Reset;
        Employee.SetFilter("Deputation on", '<>%1', DeputationOnFrom);
        FilterDeputationOnFrom;
        if Employee.Find('-') then
            repeat
                case DeputationOnTo of
                    DeputationOnTo::Province:
                        begin
                            if Province.Get(DeputationCodeTo) then begin
                                Employee."Province Name" := Province.Description;
                                Employee."Province Code" := DeputationCodeTo;
                            end;
                        end;

                    DeputationOnTo::"Sub Province":
                        begin
                            SubProvince.Reset;
                            SubProvince.SetRange(Code, DeputationCodeTo);
                            if SubProvince.FindFirst then begin
                                Employee."Sub Province Name" := SubProvince.City;
                                Employee."Sub Province Code" := DeputationCodeTo;
                            end;
                        end;

                    DeputationOnTo::Branch:
                        begin
                            GLSetup.Get;
                            if DimValue.Get(GLSetup."Global Dimension 1 Code", DeputationCodeTo) then begin
                                Employee."Branch Name" := DimValue.Name;
                                Employee."Global Dimension 1 Code" := DeputationCodeTo;
                            end;
                        end;

                    DeputationOnTo::Department:
                        begin
                            if Depart.Get(DeputationCodeTo) then begin
                                Employee."Department Name" := Depart.Name;
                                Employee."Department Code" := DeputationCodeTo;
                            end;
                        end;

                    DeputationOnTo::"Extension Counter":
                        begin
                            EmpHie.Reset;
                            EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                            EmpHie.SetRange(Code, DeputationCodeTo);
                            if EmpHie.FindFirst then begin
                                Employee."Extension Counter Name" := EmpHie.Description;
                                Employee."Extension Counter Name" := DeputationCodeTo;
                            end;
                        end;

                    DeputationOnTo::Unit:
                        begin
                            EmpHie.Reset;
                            EmpHie.SetRange(Type, EmpHie.Type::Unit);
                            EmpHie.SetRange(Code, DeputationCodeTo);
                            if EmpHie.FindFirst then begin
                                Employee."Extension Counter Name" := EmpHie.Description;
                                Employee."Unit Name" := DeputationCodeTo;
                            end;
                        end;
                end;
                Employee.Modify;
            until Employee.Next = 0;
    end;

    local procedure IfBlockDeputationCode()
    begin
        case DeputationOnFrom of
            DeputationOnFrom::Province:
                begin
                    if Province.Get(DeputationCodeFrom) then begin
                        Province.Validate(Blocked, true);
                        Province.Modify;
                    end;
                end;

            DeputationOnFrom::"Sub Province":
                begin
                    SubProvince.Reset;
                    SubProvince.SetRange(Code, DeputationCodeFrom);
                    if SubProvince.FindFirst then begin
                        SubProvince.Validate(Blocked, true);
                        SubProvince.Modify;
                    end;
                end;

            DeputationOnFrom::Branch:
                begin
                    GLSetup.Get;
                    if DimValue.Get(GLSetup."Global Dimension 1 Code", DeputationCodeFrom) then begin
                        DimValue.Validate(Blocked, true);
                        DimValue.Modify;
                    end;
                end;

            DeputationOnFrom::Department:
                begin
                    if Depart.Get(DeputationCodeFrom) then begin
                        Depart.Validate(Blocked, true);
                        Depart.Modify;
                    end;
                end;

            DeputationOnFrom::"Extension Counter":
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    EmpHie.SetRange(Code, DeputationCodeFrom);
                    if EmpHie.FindFirst then begin
                        EmpHie.Validate(Blocked, true);
                        EmpHie.Modify;
                    end;
                end;

            DeputationOnFrom::Unit:
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    EmpHie.SetRange(Code, DeputationCodeFrom);
                    if EmpHie.FindFirst then begin
                        EmpHie.Validate(Blocked, true);
                        EmpHie.Modify;
                    end;
                end;
        end;
    end;

    procedure SetAppointment(EmpCode: Code[20])
    begin
        IsAppointment := true;
        EmpNo := EmpCode;
    end;
}
