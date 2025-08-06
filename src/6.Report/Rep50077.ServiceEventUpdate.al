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
                        ValuesAllowed = Appointment, "Period Extend", Confirmation, "Change Of Employment status", "Change Details";//"On The Job Training", "Contract Renew", "Expired Contract";
                        ToolTip = 'Specifies the value of the Service Event field.';
                        ApplicationArea = All;
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            UpdateFieldVisibility();
                            LoadAutoPopulate();
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

                        // Test : Was using ProbationPeriod instead of TraineePeriod
                        field(TraineePeriod; TraineePeriod)
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

                    field("Employment Type Period Extend"; EmploymentTypePeriodExtend)
                    {
                        Caption = 'Employment Type';
                        Editable = false;
                        ToolTip = 'Auto selected based on the Employee card.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("New Period"; NewPeriod)
                    {
                        Caption = 'New Period';
                        ApplicationArea = All;
                        ToolTip = 'Specify the new period start date.';
                    }

                    field("New Period End Date"; NewPeriodEndDate)
                    {
                        Caption = 'New Period End Date';
                        ApplicationArea = All;
                        ShowMandatory = true;
                        ToolTip = 'Specify the new period end date.';
                    }

                    field(Remarksperiodextend; Remarks)
                    {
                        Caption = 'Remarks';
                        ApplicationArea = All;
                        ToolTip = 'Additional remarks for period extension.';
                    }
                }
                group("Change Of Employment Status")
                {
                    visible = ShowChangeOfEmploymentStatusFields;
                    caption = 'Change Of Employment Status';

                    field("Current Status"; CurrentStatus)
                    {
                        Caption = 'Current Status';
                        Editable = false;
                        ToolTip = 'Auto selected based on the Employee card.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }

                    field("New Status"; NewStatus)
                    {
                        Caption = 'New Status';
                        ToolTip = 'Select the new employment status for the employee.';
                        ApplicationArea = All;
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin

                            Clear(InactiveDate);
                            Clear(CauseOfInactivity);
                            Clear(TerminationDate);
                            Clear(GroundsForTermination);

                            case NewStatus of
                                NewStatus::Inactive,
                                NewStatus::Terminated:
                                    LoadEmployeeTerminationDetails();
                            end;
                            UpdateFieldVisibility();
                        end;
                    }


                    field("Status Change Date"; EffectiveDate)
                    {
                        Caption = 'Effective Date';
                        ToolTip = 'Specify the date when the status change becomes effective.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }

                    group("Inactive Status Details")
                    {
                        ShowCaption = false;
                        Visible = ShowForInactive;

                        field("Inactive Date"; InactiveDate)
                        {
                            ApplicationArea = All;
                            Caption = 'Inactive Date';
                            ToolTip = 'Specify the date the employee became inactive.';
                            ShowMandatory = true;
                        }

                        field("Cause of Inactivity"; CauseOfInactivity)
                        {
                            ApplicationArea = All;
                            Caption = 'Cause of Inactivity';
                            ToolTip = 'Specify the reason for inactivity.';
                            ShowMandatory = true;
                        }
                    }

                    group("Terminated Status Details")
                    {
                        ShowCaption = false;
                        Visible = ShowForTerminated;

                        field("Termination Date"; TerminationDate)
                        {
                            ApplicationArea = All;
                            Caption = 'Termination Date';
                            ToolTip = 'Specify the date the employee was terminated.';
                            ShowMandatory = true;
                        }

                        field("Grounds for Termination"; GroundsForTermination)
                        {
                            ApplicationArea = All;
                            Caption = 'Grounds for Termination';
                            ToolTip = 'Specify the reason or grounds for termination.';
                            ShowMandatory = true;
                        }
                    }

                    field("Remarks Change Status"; Remarks)
                    {
                        ApplicationArea = All;
                        Caption = 'Remarks';
                        ToolTip = 'Any additional remarks or notes for employment status change.';
                        ShowMandatory = true;
                    }
                }
                group("Change Details")
                {
                    Caption = 'Change Details';
                    Visible = ShowChangeDetailsFields;

                    field("Functional Title Change"; FunctionalTitle)
                    {
                        Caption = 'Functional Title';
                        TableRelation = "Functional Title";
                        ToolTip = 'Modify the Functional Title of the employee.';
                        ApplicationArea = All;
                    }
                    field("Salary Level Change"; SalaryLevel)
                    {
                        Caption = 'Salary Level';
                        TableRelation = "Salary Level";
                        ToolTip = 'Modify the Salary Level of the employee.';
                        ApplicationArea = All;
                    }
                    field("Salary Grade Change"; SalaryGrade)
                    {
                        Caption = 'Salary Grade';
                        TableRelation = "Salary Grade";
                        ToolTip = 'Modify the Salary Grade of the employee.';
                        ApplicationArea = All;
                    }
                    field("Employment Type Change"; EmploymentType)
                    {
                        Caption = 'Employment Type';
                        ToolTip = 'Modify the Employment Type of the employee.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            UpdateFieldVisibility();
                        end;
                    }
                    field("Effective Date Change"; EffectiveDate)
                    {
                        Caption = 'Effective Date';
                        ToolTip = 'Specify the date when changes become effective.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("Deputation On Change"; DeputationOnTo)
                    {
                        Caption = 'Deputation On';
                        ToolTip = 'Modify the Deputation assignment of the employee.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if DeputationOnTo <> DeputationOnTo::Branch then
                                Clear(ProvinceCode);
                        end;
                    }
                    field("Province Code Change"; ProvinceCode)
                    {
                        Caption = 'Province Code';
                        ToolTip = 'Modify the Province Code of the employee.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ProvinceCode := GetDeputation(DeputationOnTo::Province);
                        end;
                    }
                    field("Branch Code Change"; BranchCode)
                    {
                        Caption = 'Branch Code';
                        ToolTip = 'Modify the Branch Code of the employee.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            BranchCode := GetDeputation(DeputationOnTo::Branch);
                        end;
                    }
                    field("Department Code Change"; DepartmentCode)
                    {
                        Caption = 'Department Code';
                        ToolTip = 'Modify the Department Code of the employee.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DepartmentCode := GetDeputation(DeputationOnTo::Department);
                        end;
                    }
                    field("Sub-Department Code Change"; SubDepartmentCode)
                    {
                        Caption = 'Sub-Department Code';
                        ToolTip = 'Modify the Sub-Department Code of the employee.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            SubDepartmentCode := GetDeputation(DeputationOnTo::Unit);
                        end;
                    }

                    group("Change Details - Probation")
                    {
                        ShowCaption = false;
                        Visible = ShowProbationPeriod;

                        field("Probation Period Change"; ProbationPeriod)
                        {
                            Caption = 'Probation Period';
                            ToolTip = 'Modify the Probation Period of the employee.';
                            ApplicationArea = All;
                        }
                    }

                    group("Change Details - Trainee")
                    {
                        ShowCaption = false;
                        Visible = ShowTraineePeriod;

                        field("Trainee Period Change"; TraineePeriod)
                        {
                            Caption = 'Trainee Period';
                            ToolTip = 'Modify the Trainee Period of the employee.';
                            ApplicationArea = All;
                        }
                    }

                    group("Change Details - Contract")
                    {
                        ShowCaption = false;
                        Visible = ShowContractPeriod;

                        field("Contract Period Change"; ContractExpiryMonth)
                        {
                            Caption = 'Contract Period';
                            ToolTip = 'Modify the Contract Period of the employee.';
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

                    group("Change Details - Status")
                    {
                        ShowCaption = false;

                        field("Status Change Details"; NewStatus)
                        {
                            Caption = 'Status';
                            ToolTip = 'Modify the Status of the employee.';
                            ApplicationArea = All;

                            trigger OnValidate()
                            begin
                                Clear(InactiveDate);
                                Clear(CauseOfInactivity);
                                Clear(TerminationDate);
                                Clear(GroundsForTermination);

                                case NewStatus of
                                    NewStatus::Inactive,
                                    NewStatus::Terminated:
                                        LoadEmployeeTerminationDetails();
                                end;
                                UpdateFieldVisibility();
                            end;
                        }

                        group("Change Details - Inactive")
                        {
                            ShowCaption = false;
                            Visible = ShowForInactive;

                            field("Inactive Date Change"; InactiveDate)
                            {
                                ApplicationArea = All;
                                Caption = 'Inactive Date';
                                ToolTip = 'Modify the Inactive Date of the employee.';
                                TableRelation = Employee."Inactive Date";
                            }

                            field("Cause of Inactivity Change"; CauseOfInactivity)
                            {
                                ApplicationArea = All;
                                Caption = 'Cause of Inactivity';
                                ToolTip = 'Modify the Cause of Inactivity of the employee.';
                                TableRelation = Employee."Cause of Inactivity Code";
                            }
                        }

                        group("Change Details - Terminated")
                        {
                            ShowCaption = false;
                            Visible = ShowForTerminated;

                            field("Termination Date Change"; TerminationDate)
                            {
                                ApplicationArea = All;
                                Caption = 'Termination Date';
                                ToolTip = 'Modify the Termination Date of the employee.';
                                TableRelation = Employee."Termination Date";
                            }

                            field("Grounds for Termination Change"; GroundsForTermination)
                            {
                                ApplicationArea = All;
                                Caption = 'Grounds for Termination';
                                ToolTip = 'Modify the Grounds for Termination of the employee.';
                                TableRelation = Employee."Grounds for Term. Code";
                            }
                        }
                    }

                    field("Remarks Change Details"; Remarks)
                    {
                        Caption = 'Remarks';
                        ToolTip = 'Additional remarks for the changes made.';
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

        if ServiceEvent = ServiceEvent::"Period Extend" then begin
            if NewPeriodEndDate = 0D then
                Error('Please enter New Period End Date.');
            UpdateEmployeePeriodExtend(Employee, NewPeriodEndDate);
        end;

        if ServiceEvent = ServiceEvent::"Change Of Employment status" then begin
            if EffectiveDate = 0D then
                Error('Please fill Effective Date for status change');

            case NewStatus of
                NewStatus::Inactive:
                    begin
                        if InactiveDate = 0D then
                            Error('Please fill Inactive Date');
                        if CauseOfInactivity = '' then
                            Error('Please fill Cause of Inactivity');
                        if InactiveDate > EffectiveDate then
                            Error('Inactive Date cannot be later than Effective Date');

                        Employee.Validate(Status, Employee.Status::Inactive);
                        Employee.Validate("Inactive Date", InactiveDate);
                        Employee.Validate("Cause of Inactivity Code", CauseOfInactivity);
                        Clear(Employee."Termination Date");
                        Clear(Employee."Grounds for Term. Code");
                    end;

                NewStatus::Terminated:
                    begin
                        if TerminationDate = 0D then
                            Error('Please fill Termination Date');
                        if GroundsForTermination = '' then
                            Error('Please fill Grounds for Termination');
                        if TerminationDate > EffectiveDate then
                            Error('Termination Date cannot be later than Effective Date');

                        Employee.Validate(Status, Employee.Status::Terminated);
                        Employee.Validate("Termination Date", TerminationDate);
                        Employee.Validate("Grounds for Term. Code", GroundsForTermination);
                        Clear(Employee."Inactive Date");
                        Clear(Employee."Cause of Inactivity Code");
                    end;

                NewStatus::Active:
                    begin
                        Employee.Validate(Status, Employee.Status::Active);
                        Clear(Employee."Inactive Date");
                        Clear(Employee."Cause of Inactivity Code");
                        Clear(Employee."Termination Date");
                        Clear(Employee."Grounds for Term. Code");
                    end;
            end;
            if NewStatus = NewStatus::Active then
                Employee.Validate("Employment Date", EffectiveDate);
        end;

        if ServiceEvent = ServiceEvent::"Change Details" then begin
            if EffectiveDate = 0D then
                Error('Please fill Effective Date for change details');
            if FunctionalTitle <> '' then
                Employee.Validate("Functional Title", FunctionalTitle);
            if SalaryLevel <> '' then
                Employee.Validate("Salary Level", SalaryLevel);
            if SalaryGrade <> '' then
                Employee.Validate("Salary Grade", SalaryGrade);
            if EmploymentType <> EmploymentType::" " then
                Employee.Validate("Employment Type", EmploymentType);
            if DeputationOnTo <> DeputationOnTo::" " then
                Employee.Validate("Deputation on", DeputationOnTo);
            if ProvinceCode <> '' then
                Employee.Validate("Province Code", ProvinceCode);
            if BranchCode <> '' then
                Employee.Validate("Branch Code", BranchCode);
            if DepartmentCode <> '' then
                Employee.Validate("Department Code", DepartmentCode);
            if SubDepartmentCode <> '' then
                Employee.Validate("Unit Code", SubDepartmentCode);

            if EmploymentType = EmploymentType::Probation then
                if ProbationPeriod <> ProbationPeriod::" " then begin
                    Employee.Validate("Probation Period", ProbationPeriod);
                    if ProbationPeriod = ProbationPeriod::"6 Month" then
                        ProbationFormula := '6M';
                    if ProbationPeriod = ProbationPeriod::"12 Month" then
                        ProbationFormula := '1Y';
                    ProbationEndDate := CalcDate(ProbationFormula, EffectiveDate);
                    Employee.Validate("Trainee/Probation End date", ProbationEndDate);
                end;

            if EmploymentType = EmploymentType::Temporary then
                if format(TraineePeriod) <> '' then begin
                    Employee.Validate("Trainee Period", TraineePeriod);
                    if TraineePeriod = TraineePeriod::"6 Month" then
                        TraineeFormula := '6M';
                    if TraineePeriod = TraineePeriod::"12 Month" then
                        TraineeFormula := '1Y';
                    TraineeEndDate := CalcDate(TraineeFormula, EffectiveDate);
                    Employee.Validate("Trainee/Probation End date", TraineeEndDate);
                end;

            if EmploymentType in [EmploymentType::Contract, EmploymentType::Outsource] then
                if ContractExpiryMonth <> ContractExpiryMonth::" " then
                    Employee.Validate("Contract Expiry Month", ContractExpiryMonth);


            case NewStatus of
                NewStatus::Active:
                    begin
                        Employee.Validate(Status, Employee.Status::Active);
                        Clear(Employee."Inactive Date");
                        Clear(Employee."Cause of Inactivity Code");
                        Clear(Employee."Termination Date");
                        Clear(Employee."Grounds for Term. Code");
                    end;
                NewStatus::Inactive:
                    begin
                        Employee.Validate(Status, Employee.Status::Inactive);
                        if InactiveDate <> 0D then
                            Employee.Validate("Inactive Date", InactiveDate);
                        if CauseOfInactivity <> '' then
                            Employee.Validate("Cause of Inactivity Code", CauseOfInactivity);
                        Clear(Employee."Termination Date");
                        Clear(Employee."Grounds for Term. Code");
                    end;
                NewStatus::Terminated:
                    begin
                        Employee.Validate(Status, Employee.Status::Terminated);
                        if TerminationDate <> 0D then
                            Employee.Validate("Termination Date", TerminationDate);
                        if GroundsForTermination <> '' then
                            Employee.Validate("Grounds for Term. Code", GroundsForTermination);
                        Clear(Employee."Inactive Date");
                        Clear(Employee."Cause of Inactivity Code");
                    end;
            end;
            Employee.Validate("Employment Date", EffectiveDate);
        end;

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
        EmploymentTypePeriodExtend: Enum "Employee Type";
        ContractExpiryMonth: Enum "Contract Expiry Date";
        SalaryGrade: Code[20];
        ServiceHistory: Record "Employee Service History";
        PayrollEngine: Codeunit "Payroll Engine";
        ProbationPeriod: Enum "Probation Period";
        TraineePeriod: Enum "Trainee Period";
        NewPeriod: Date;
        NewPeriodEndDate: Date;
        CurrentStatus: enum "Employee Status";
        NewStatus: enum "New Status";
        InactiveDate: Date;
        CauseOfInactivity: Code[10];
        TerminationDate: Date;
        GroundsForTermination: Code[10];

        // Visibility Controls
        ShowAppointmentFields: Boolean;
        ShowConfirmationFields: Boolean;
        ShowProbationPeriod: Boolean;
        ShowForInactive: Boolean;
        ShowForTerminated: Boolean;
        ShowChangeOfEmploymentStatusFields: Boolean;
        ShowTraineePeriod: Boolean;
        ShowContractPeriod: Boolean;
        ShowPeriodExtendFields: Boolean;
        ShowChangeDetailsFields: Boolean;

    local procedure UpdateFieldVisibility()
    begin
        ShowAppointmentFields := false;
        ShowConfirmationFields := false;
        ShowProbationPeriod := false;
        ShowTraineePeriod := false;
        ShowContractPeriod := false;
        ShowPeriodExtendFields := false;
        ShowChangeOfEmploymentStatusFields := false;
        ShowForInactive := false;
        ShowForTerminated := false;
        ShowChangeDetailsFields := false;

        case ServiceEvent of
            ServiceEvent::Appointment:
                ShowAppointmentFields := true;
            ServiceEvent::Confirmation:
                ShowConfirmationFields := true;
            ServiceEvent::"Period Extend":
                ShowPeriodExtendFields := true;
            ServiceEvent::"Change Of Employment status":
                ShowChangeOfEmploymentStatusFields := true;
            ServiceEvent::"Change Details":
                ShowChangeDetailsFields := true;
        end;

        case EmploymentType of
            EmploymentType::Probation:
                ShowProbationPeriod := true;
            EmploymentType::Temporary:
                ShowTraineePeriod := true;
            EmploymentType::Contract, EmploymentType::Outsource:
                ShowContractPeriod := true;
        end;

        case NewStatus of
            NewStatus::Inactive:
                ShowForInactive := true;
            NewStatus::Terminated:
                ShowForTerminated := true;
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

    local procedure UpdateEmployeePeriodExtend(Employee: Record Employee; NewDate: Date)
    begin
        case Employee."Employment Type" of
            Employee."Employment Type"::Probation,
            Employee."Employment Type"::Temporary:
                begin
                    Employee.Validate("Trainee/Probation End Date", NewDate);
                    Employee.Modify();
                end;

            Employee."Employment Type"::Contract,
            Employee."Employment Type"::Outsource:
                begin
                    Employee.Validate("Contract Renew Date", NewDate);
                    Employee.Modify();
                end;
        end;
    end;


    local procedure LoadAutoPopulate()
    var
        EmployeeRec: Record Employee;
    begin
        if EmployeeRec.Get(EmpNo) then begin
            EmploymentTypePeriodExtend := EmployeeRec."Employment Type";
            CurrentStatus := EmployeeRec.Status;
            case EmployeeRec.Status of
                EmployeeRec.Status::Inactive:
                    begin
                        InactiveDate := EmployeeRec."Inactive Date";
                        CauseOfInactivity := EmployeeRec."Cause of Inactivity Code";
                    end;
                EmployeeRec.Status::Terminated:
                    begin
                        TerminationDate := EmployeeRec."Termination Date";
                        GroundsForTermination := EmployeeRec."Grounds for Term. Code";
                    end;
            end;
        end;
    end;

    local procedure LoadEmployeeTerminationDetails()
    var
        EmployeeRec: Record Employee;
    begin
        if EmployeeRec.Get(EmpNo) then begin
            InactiveDate := EmployeeRec."Inactive Date";
            CauseOfInactivity := EmployeeRec."Cause of Inactivity Code";
            TerminationDate := EmployeeRec."Termination Date";
            GroundsForTermination := EmployeeRec."Grounds for Term. Code";
        end;
    end;
}
