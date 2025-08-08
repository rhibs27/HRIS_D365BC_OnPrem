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
                        ValuesAllowed = Appointment, "Period Extend", Confirmation, "Change Of Employment status", "Change Details";
                        ToolTip = 'Specifies the value of the Service Event field.';
                        ApplicationArea = All;
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            UpdateFieldVisibility();
                            LoadAutoPopulate();
                            if ServiceEvent in [ServiceEvent::Appointment, ServiceEvent::Confirmation] then
                                ValidateServiceEventExists();
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
                    }

                    field("Deputation On"; DeputationOnTo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the DeputationOnTo field.';

                        trigger OnValidate()
                        begin
                            ClearDeputationCodes();
                        end;
                    }

                    field("Province Code"; ProvinceCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Province Code';
                        ToolTip = 'Specifies the value of the Province Code field.';
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Province), Blocked = filter(false));

                        trigger OnValidate()
                        begin
                            if ProvinceCode <> PrevProvinceCode then begin
                                Clear(BranchCode);
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ProvinceCode := GetDeputation(DeputationOnTo::Province);
                            if ProvinceCode <> PrevProvinceCode then begin
                                Clear(BranchCode);
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;
                    }

                    field("Branch Code"; BranchCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Branch Code';
                        ToolTip = 'Specifies the value of the Branch Code field.';
                        // Removed TableRelation since we'll handle it through lookup

                        trigger OnValidate()
                        begin
                            if BranchCode <> PrevBranchcode then begin
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if ProvinceCode = '' then begin
                                Message('Please select Province Code first.');
                                exit(false);
                            end;
                            BranchCode := GetBranchDeputation(ProvinceCode);
                            if BranchCode <> PrevBranchcode then begin
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;
                    }

                    field("Department Code"; DepartmentCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Department Code';
                        ToolTip = 'Specifies the value of the Department Code field.';
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Department), Blocked = filter(false));

                        trigger OnValidate()
                        begin
                            if DepartmentCode <> PrevDepartmentCode then
                                Clear(SubDepartmentCode);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DepartmentCode := GetDeputation(DeputationOnTo::Department);
                            if DepartmentCode <> PrevDepartmentCode then
                                Clear(SubDepartmentCode);
                        end;
                    }

                    field("Sub-Department Code"; SubDepartmentCode)
                    {
                        Caption = 'Sub-Department Code';
                        ToolTip = 'Specifies the value of the Sub-Department Code field.';
                        ApplicationArea = All;
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Unit), Blocked = filter(false));

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            SubDepartmentCode := GetDeputation(DeputationOnTo::Unit);
                        end;
                    }

                    field(Remarks; Remarks)
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

                        field("Probation End Date"; ProbationEndDate)
                        {
                            ToolTip = 'Specifies the value of the Probation Period field.';
                            ApplicationArea = All;
                        }
                    }

                    group("Trainee Details")
                    {
                        ShowCaption = false;
                        Visible = ShowTraineePeriod;

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
                            ClearDeputationCodes();
                        end;
                    }
                    field("Province Code Conf"; ProvinceCode)
                    {
                        Caption = 'Province Code';
                        ToolTip = 'Specifies the value of the Province Code field.';
                        ApplicationArea = All;
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Province), Blocked = filter(false));

                        trigger OnValidate()
                        begin
                            if ProvinceCode <> PrevProvinceCode then begin
                                Clear(BranchCode);
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ProvinceCode := GetDeputation(DeputationOnTo::Province);
                            if ProvinceCode <> PrevProvinceCode then begin
                                Clear(BranchCode);
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;
                    }
                    field("Branch Code Conf"; BranchCode)
                    {
                        Caption = 'Branch Code';
                        ToolTip = 'Specifies the value of the Branch Code field.';
                        ApplicationArea = All;
                        // Removed TableRelation since we'll handle it through lookup

                        trigger OnValidate()
                        begin
                            if BranchCode <> PrevBranchcode then begin
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if ProvinceCode = '' then begin
                                Message('Please select Province Code first.');
                                exit(false);
                            end;
                            BranchCode := GetBranchDeputation(ProvinceCode);
                            if BranchCode <> PrevBranchcode then begin
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;
                    }
                    field("Department Code Conf"; DepartmentCode)
                    {
                        Caption = 'Department Code';
                        ToolTip = 'Specifies the value of the Department Code field.';
                        ApplicationArea = All;
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Department), Blocked = filter(false));

                        trigger OnValidate()
                        begin
                            if DepartmentCode <> PrevDepartmentCode then
                                Clear(SubDepartmentCode);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DepartmentCode := GetDeputation(DeputationOnTo::Department);
                            if DepartmentCode <> PrevDepartmentCode then
                                Clear(SubDepartmentCode);
                        end;
                    }
                    field("Sub-Department Code Conf"; SubDepartmentCode)
                    {
                        Caption = 'Sub-Department Code';
                        ToolTip = 'Specifies the value of the Sub-Department Code field.';
                        ApplicationArea = All;
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Unit), Blocked = filter(false));

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
                        }

                        field("Cause of Inactivity"; CauseOfInactivity)
                        {
                            ApplicationArea = All;
                            Caption = 'Cause of Inactivity';
                            ToolTip = 'Specify the reason for inactivity.';
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
                        }

                        field("Grounds for Termination"; GroundsForTermination)
                        {
                            ApplicationArea = All;
                            Caption = 'Grounds for Termination';
                            ToolTip = 'Specify the reason or grounds for termination.';
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
                    }
                    field("Deputation On Change"; DeputationOnTo)
                    {
                        Caption = 'Deputation On';
                        ToolTip = 'Modify the Deputation assignment of the employee.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ClearDeputationCodes();
                        end;
                    }
                    field("Province Code Change"; ProvinceCode)
                    {
                        Caption = 'Province Code';
                        ToolTip = 'Modify the Province Code of the employee.';
                        ApplicationArea = All;
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Province), Blocked = filter(false));

                        trigger OnValidate()
                        begin
                            if ProvinceCode <> PrevProvinceCode then begin
                                Clear(BranchCode);
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ProvinceCode := GetDeputation(DeputationOnTo::Province);
                            if ProvinceCode <> PrevProvinceCode then begin
                                Clear(BranchCode);
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;
                    }
                    field("Branch Code Change"; BranchCode)
                    {
                        Caption = 'Branch Code';
                        ToolTip = 'Modify the Branch Code of the employee.';
                        ApplicationArea = All;
                        // Removed TableRelation since we'll handle it through lookup

                        trigger OnValidate()
                        begin
                            if BranchCode <> PrevBranchcode then begin
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if ProvinceCode = '' then begin
                                Message('Please select Province Code first.');
                                exit(false);
                            end;
                            BranchCode := GetBranchDeputation(ProvinceCode);
                            if BranchCode <> PrevBranchcode then begin
                                Clear(DepartmentCode);
                                Clear(SubDepartmentCode);
                            end;
                        end;
                    }
                    field("Department Code Change"; DepartmentCode)
                    {
                        Caption = 'Department Code';
                        ToolTip = 'Modify the Department Code of the employee.';
                        ApplicationArea = All;
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Department), Blocked = filter(false));

                        trigger OnValidate()
                        begin
                            if DepartmentCode <> PrevDepartmentCode then
                                Clear(SubDepartmentCode);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            DepartmentCode := GetDeputation(DeputationOnTo::Department);
                            if DepartmentCode <> PrevDepartmentCode then
                                Clear(SubDepartmentCode);
                        end;
                    }
                    field("Sub-Department Code Change"; SubDepartmentCode)
                    {
                        Caption = 'Sub-Department Code';
                        ToolTip = 'Modify the Sub-Department Code of the employee.';
                        ApplicationArea = All;
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Unit), Blocked = filter(false));

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
                    field(RemarksVar; Remarks)
                    {
                        Caption = 'Remarks';
                        ToolTip = 'Specifies the value of the Remarks field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("Employment Type1"; EmploymentType)
                    {
                        Caption = 'Employment Type';
                        ToolTip = 'Specifies the value of the EmploymentType field.';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("Effective Date2"; EffectiveDate)
                    {
                        ToolTip = 'Specifies the value of the EffectiveDate field.';
                        ApplicationArea = All;
                    }
                    field("ContractExpiry Month Hidden"; ContractExpiryMonth)
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

        trigger OnOpenPage()
        begin
            UpdateFieldVisibility();
            PrevProvinceCode := ProvinceCode;
            PrevBranchcode := BranchCode;
            PrevDepartmentCode := DepartmentCode;
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

        if ServiceEvent in [ServiceEvent::Appointment, ServiceEvent::Confirmation] then
            ValidateServiceEventExists();

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
            if ProvinceCode <> '' then
                Employee.Validate("Province Code", ProvinceCode);
            if BranchCode <> '' then
                Employee.Validate("Branch Code", BranchCode);
            if DepartmentCode <> '' then
                Employee.Validate("Department Code", DepartmentCode);
            if SubDepartmentCode <> '' then
                Employee.Validate("Unit Code", SubDepartmentCode);

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

        if ServiceEvent = ServiceEvent::"Contract Renew" then begin
            if EffectiveDate = 0D then
                Error('Please fill Effective Date field');
            if (EmploymentType = EmploymentType::" ") then
                Error('Please fill Employment Type values');
            if EmploymentType = EmploymentType::Contract then
                if ContractExpiryMonth = ContractExpiryMonth::" " then
                    Error('Contract Expiry Month must have value.');
            if EmploymentType = EmploymentType::Probation then
                if ProbationPeriod = ProbationPeriod::" " then
                    Error('Probation Period must have value.')
                else
                    Employee.Validate("Probation Period", ProbationPeriod);
        end;

        if ServiceEvent = ServiceEvent::"Re Appointment" then begin
            if ContractCode = '' then
                Error('Please fill Contract Code fields')
            else
                Employee.Validate("Emplymt. Contract Code", ContractCode);
        end;

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

        if ServiceEvent = ServiceEvent::Appointment then
            Employee.Validate("Employment Date", EffectiveDate)
        else if ServiceEvent = ServiceEvent::"Contract Renew" then
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

        // Apply proper validation for deputation codes based on DeputationOnTo
        ValidateDeputationOnCode();

        Employee.Modify;
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
        PrevProvinceCode: Code[20];
        PrevBranchcode: code[20];
        PrevDepartmentCode: code[20];

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
        ContractCode: Code[20];
        ProbationEndDate: Date;

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

    local procedure ClearDeputationCodes()
    begin
        case DeputationOnTo of
            DeputationOnTo::Province:
                begin
                    Clear(BranchCode);
                    Clear(DepartmentCode);
                    Clear(SubDepartmentCode);
                end;
            DeputationOnTo::Branch:
                begin
                    Clear(DepartmentCode);
                    Clear(SubDepartmentCode);
                end;
            DeputationOnTo::Department:
                begin
                    Clear(ProvinceCode);
                    Clear(BranchCode);
                    Clear(SubDepartmentCode);
                end;
            DeputationOnTo::Unit:
                begin
                    Clear(ProvinceCode);
                    Clear(BranchCode);
                    Clear(DepartmentCode);
                end;
            else begin
                Clear(ProvinceCode);
                Clear(BranchCode);
                Clear(DepartmentCode);
                Clear(SubDepartmentCode);
            end;
        end;
    end;

    local procedure GetDeputation(DeputationType: Enum "Deputation Type"): Code[20]
    var
        OrgStructureList: Record "Organization Structure List";
    begin
        OrgStructureList.Reset();
        OrgStructureList.SetRange(Type, DeputationType);
        OrgStructureList.SetRange(Blocked, false);

        if Page.RunModal(Page::"Organization Structure list", OrgStructureList) = Action::OK then
            exit(OrgStructureList.Code)
        else
            exit(OrgStructureList.Code);
    end;

    local procedure GetBranchDeputation(SelectedProvinceCode: Code[20]): Code[20]
    var
        OrgStructureLine: Record "Organization Structure line";
    begin
        if SelectedProvinceCode = '' then
            exit('');

        OrgStructureLine.Reset();
        OrgStructureLine.SetRange(Type, OrgStructureLine.Type::Province);
        OrgStructureLine.SetRange(Code, SelectedProvinceCode);
        OrgStructureLine.SetRange("Reporting Type", OrgStructureLine."Reporting Type"::Branch);

        if Page.RunModal(Page::"Organization Structure Subform", OrgStructureLine) = Action::OK then
            exit(OrgStructureLine."Reporting Code")
        else
            exit(OrgStructureLine."Reporting Code");
    end;

    local procedure ValidateDeputationOnCode()
    begin
        if DeputationOnTo <> DeputationOnTo::" " then
            Employee.Validate("Deputation on", DeputationOnTo);

        case DeputationOnTo of
            DeputationOnTo::Province:
                begin
                    if ProvinceCode <> '' then
                        Employee.Validate("Province Code", ProvinceCode);
                end;
            DeputationOnTo::Branch:
                begin
                    if ProvinceCode <> '' then
                        Employee.Validate("Province Code", ProvinceCode);
                    if BranchCode <> '' then
                        Employee.Validate("Branch Code", BranchCode);
                end;
            DeputationOnTo::Department:
                begin
                    if DepartmentCode <> '' then
                        Employee.Validate("Department Code", DepartmentCode);
                end;
            DeputationOnTo::"Extension Counter":
                begin
                    if DeputationCodeTo <> '' then
                        Employee.Validate("Extension Counter Code", DeputationCodeTo);
                end;
            DeputationOnTo::Unit:
                begin
                    if SubDepartmentCode <> '' then
                        Employee.Validate("Unit Code", SubDepartmentCode);
                end;
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

    local procedure ValidateServiceEventExists()
    var
        ServiceHistoryRec: Record "Employee Service History";
    begin
        // Check if Appointment already exists
        if ServiceEvent = ServiceEvent::Appointment then begin
            ServiceHistoryRec.Reset();
            ServiceHistoryRec.SetRange("Employee No.", EmpNo);
            ServiceHistoryRec.SetRange("Service Event", ServiceHistoryRec."Service Event"::Appointment);
            if not ServiceHistoryRec.IsEmpty() then
                Error('Appointment service event already exists for this employee.');
        end;

        // Check if Confirmation already exists
        if ServiceEvent = ServiceEvent::Confirmation then begin
            ServiceHistoryRec.Reset();
            ServiceHistoryRec.SetRange("Employee No.", EmpNo);
            ServiceHistoryRec.SetRange("Service Event", ServiceHistoryRec."Service Event"::Confirmation);
            if not ServiceHistoryRec.IsEmpty() then
                Error('Confirmation service event already exists for this employee.');
        end;

        // Additional validation: Confirmation should only be allowed after Appointment
        if ServiceEvent = ServiceEvent::Confirmation then begin
            ServiceHistoryRec.Reset();
            ServiceHistoryRec.SetRange("Employee No.", EmpNo);
            ServiceHistoryRec.SetRange("Service Event", ServiceHistoryRec."Service Event"::Appointment);
            if ServiceHistoryRec.IsEmpty() then
                Error('Confirmation service event can only be created after an Appointment service event exists for this employee.');
        end;
    end;
}