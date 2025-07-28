codeunit 50024 "Service History Mgt"
{
    var
        Employee, Employee1 : Record Employee;
        HrMgt: Codeunit "HR Mgt.";

    procedure AddToServiceHistory(DocNo: Code[20]; ServiceEvent: Enum "Service Event"; RemarksVar: Text; EffectiveDate: Date): Code[20]
    var
        EmpServiceHis: Record "Employee Service History";
        Candidate: Record Candidate;
        EmployeeTransfer: Record "Employee Transfer";
    begin
        case ServiceEvent of
            ServiceEvent::Appointment:
                begin
                    Candidate.Get(DocNo);
                    EmpServiceHis.Init;
                    EmpServiceHis.Validate("Service Event", EmpServiceHis."Service Event"::Appointment);
                    EmpServiceHis.Validate("Employee No.", Candidate."Employee No.");
                    EmpServiceHis.Validate("Functional Title (To)", Candidate."Functional Title");
                    EmpServiceHis.Validate("Salary Level (To)", Candidate."Job Title");
                    EmpServiceHis.Validate("Salary Grade (From)", Candidate."Salary Grade");
                    EmpServiceHis.Validate("Salary Grade (To)", Candidate."Salary Grade");
                    EmpServiceHis.Validate("Effective Date", EffectiveDate);
                    EmpServiceHis.Validate(Remarks, RemarksVar);
                    EmpServiceHis.Insert(true);
                end;
            //Min 1.2 -- Added option String "Temporary Deputation","Back From Deputation" and "Officiating Arrangement".
            ServiceEvent::Confirmation, ServiceEvent::"Contract Renew", ServiceEvent::"Addition in Job Function",
            ServiceEvent::"Assignment in Job Function", ServiceEvent::"Formation of Department/Unit/Functional Title",
            ServiceEvent::"Internal Appointment", ServiceEvent::"Back From Deputation":
                begin
                    Employee.Get(DocNo);
                    EmpServiceHis.Init;
                    EmpServiceHis.Validate("Service Event", ServiceEvent);
                    EmpServiceHis.Validate("Employee No.", Employee."No.");
                    EmpServiceHis.Validate("Functional Title (From)", Employee."Functional Title");
                    EmpServiceHis.Validate("Salary Level (From)", Employee."Salary Level");
                    EmpServiceHis.Validate("Effective Date", EffectiveDate);
                    EmpServiceHis.Validate("Deputation On(From)", Employee."Deputation on");
                    EmpServiceHis.Validate("Deputation Code (From)", ExitTransferDeputationWiseCode(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
                    EmpServiceHis.Validate("Deputation Value (From)", ExitTransferDeputationWiseValue(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
                    EmpServiceHis.Validate(Remarks, RemarksVar);
                    EmpServiceHis.Validate("Salary Grade (From)", Employee."Salary Grade");
                    if ServiceEvent <> ServiceEvent::"Internal Appointment" then
                        EmpServiceHis.Validate("Salary Grade (To)", Employee."Salary Grade");
                    EmpServiceHis.Insert(true);
                end;
            ServiceEvent::Transfer, ServiceEvent::"Temporary Deputation", ServiceEvent::"Officiating Arrangement":
                begin
                    EmployeeTransfer.Get(DocNo);
                    Employee.get(EmployeeTransfer."Employee No.");
                    EmpServiceHis.Init;
                    EmpServiceHis.Validate("Service Event", ServiceEvent);
                    EmpServiceHis.Validate("Employee No.", EmployeeTransfer."Employee No.");
                    EmpServiceHis.Validate("Functional Title (From)", Employee."Functional Title");
                    EmpServiceHis.Validate("Salary Level (From)", Employee."Salary Level");
                    EmpServiceHis.Validate("Effective Date", EffectiveDate);
                    EmpServiceHis.Validate("Deputation On(From)", Employee."Deputation on");
                    EmpServiceHis.Validate("Deputation Code (From)", Employee."Deputation On Code");
                    EmpServiceHis.Validate("Deputation Value (From)", ExitTransferDeputationWiseValue(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
                    EmpServiceHis.Validate(Remarks, RemarksVar);
                    EmpServiceHis.Validate("Salary Grade (From)", Employee."Salary Grade");
                    EmpServiceHis.Validate("Functional Title (To)", EmployeeTransfer."Functional Title (To)");
                    EmpServiceHis.Validate("Deputation On (To)", EmployeeTransfer."Deputation On (To)");
                    EmpServiceHis.Validate("Deputation Code (To)", EmployeeTransfer."Deputation on Code To");
                    // EmpServiceHis.Validate("Deputation Value (to)", ExitTransferDeputationWiseValue(EmpServiceHis."Deputation Code (To)", EmpServiceHis."Employee No."));
                    EmpServiceHis.Validate("Salary Grade (From)", Employee."Salary Grade");
                    EmpServiceHis.Validate("Salary Grade (From)", Employee."Salary Grade");
                    if ServiceEvent <> ServiceEvent::"Internal Appointment" then
                        EmpServiceHis.Validate("Salary Grade (To)", Employee."Salary Grade");
                    EmpServiceHis.Insert(true);
                end;
        end;
        exit(EmpServiceHis."Service History Code");
    end;

    procedure AddToServiceHistoryAppointment(DocNo: Code[20]; ServiceEvent: Enum "Service Event"; RemarksVar: Text; EffectiveDate: Date; VacanyNo: Code[20]; EmployeeNo: Code[20]): Code[20]
    var
        EmpServiceHis: Record "Employee Service History";
        Candidate: Record Candidate;
    begin
        case ServiceEvent of
            ServiceEvent::Appointment:
                begin
                    Candidate.Get(DocNo, VacanyNo);
                    EmpServiceHis.Init;
                    EmpServiceHis.Validate("Service Event", EmpServiceHis."Service Event"::Appointment);
                    EmpServiceHis.Validate("Employee No.", EmployeeNo);
                    EmpServiceHis.Validate("Functional Title (To)", Candidate."Functional Title");
                    EmpServiceHis.Validate("Salary Level (To)", Candidate."Job Title");
                    EmpServiceHis.Validate("Salary Grade (From)", Candidate."Salary Grade");
                    EmpServiceHis.Validate("Salary Grade (To)", Candidate."Salary Grade");
                    EmpServiceHis.Validate("Effective Date", EffectiveDate);
                    EmpServiceHis.Validate(Remarks, RemarksVar);
                    EmpServiceHis.Insert(true);
                end;
            //Min 1.2 -- Added option String "Temporary Deputation","Back From Deputation" and "Officiating Arrangement".
            ServiceEvent::Confirmation, ServiceEvent::"Contract Renew", ServiceEvent::"Addition in Job Function",
            ServiceEvent::"Assignment in Job Function", ServiceEvent::"Formation of Department/Unit/Functional Title",
            ServiceEvent::"Internal Appointment", ServiceEvent::Transfer, ServiceEvent::"Temporary Deputation", ServiceEvent::"Back From Deputation", ServiceEvent::"Officiating Arrangement":
                begin
                    Employee.Get(DocNo);
                    EmpServiceHis.Init;
                    EmpServiceHis.Validate("Service Event", ServiceEvent);
                    EmpServiceHis.Validate("Employee No.", Employee."No.");
                    EmpServiceHis.Validate("Functional Title (From)", Employee."Functional Title");
                    EmpServiceHis.Validate("Salary Level (From)", Employee."Salary Level");
                    EmpServiceHis.Validate("Effective Date", EffectiveDate);
                    EmpServiceHis.Validate("Deputation On(From)", Employee."Deputation on");
                    EmpServiceHis.Validate("Deputation Code (From)", ExitTransferDeputationWiseCode(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
                    EmpServiceHis.Validate("Deputation Value (From)", ExitTransferDeputationWiseValue(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
                    EmpServiceHis.Validate(Remarks, RemarksVar);
                    EmpServiceHis.Validate("Salary Grade (From)", Employee."Salary Grade");
                    if ServiceEvent <> ServiceEvent::"Internal Appointment" then
                        EmpServiceHis.Validate("Salary Grade (To)", Employee."Salary Grade");
                    EmpServiceHis.Insert(true);
                end;

        end;
        exit(EmpServiceHis."Service History Code");
    end;

    procedure ExitTransferDeputationWiseValue(DeputationOn: Enum "Deputation Type"; EmpCode: Code[20]): Text
    var
        // DimValue: Record "Dimension Value";
        // Depart: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        // SubProvince: Record "Sub Province";
        Province: Record Province;
        GLSetup: Record "General Ledger Setup";
        OrganizationStructureList: Record "Organization Structure List";
    begin
        // Clear(DimValue);
        // Clear(Depart);
        // Clear(EmpHie);
        // Clear(SubProvince);
        Clear(Province);
        GLSetup.Get;
        Employee.Get(EmpCode);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.type::Branch, Employee."Global Dimension 1 Code") then
                        exit(OrganizationStructureList.Name);
                end;

            DeputationOn::Department:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.type::Department, Employee."Department Code") then
                        exit(OrganizationStructureList.Name);

                end;

            DeputationOn::"Extension Counter":
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    // EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    // if EmpHie.FindFirst then
                    if OrganizationStructureList.Get(OrganizationStructureList.type::"Extension Counter", Employee."Extension Counter Code") then
                        exit(OrganizationStructureList.Name);
                end;

            // DeputationOn::"Sub Province":
            //     begin
            //         SubProvince.Reset;
            //         SubProvince.SetRange(Code, Employee."Sub Province Code");
            //         if SubProvince.FindFirst then
            //             exit(SubProvince.City);
            //     end;

            DeputationOn::Unit:
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    // EmpHie.SetRange(Code, Employee."Unit Code");
                    // if EmpHie.FindFirst then
                    //     exit(EmpHie.Description);
                    if OrganizationStructureList.Get(OrganizationStructureList.type::"Extension Counter", Employee."Union Code") then
                        exit(OrganizationStructureList.Name);
                end;

            DeputationOn::Province:
                begin
                    if Province.Get(Employee."Province Code") then
                        exit(Province.Description);
                end;
        end;
    end;

    procedure ExitTransferDeputationWiseCode(DeputationOn: Enum "Deputation Type"; EmpCode: Code[20]): Text
    var
        // DimValue: Record "Dimension Value";
        // Depart: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        // SubProvince: Record "Sub Province";
        Province: Record Province;
        GLSetup: Record "General Ledger Setup";
        OrganizationStructureList: Record "Organization Structure List";
    begin
        // Clear(DimValue);
        // Clear(Depart);
        // Clear(EmpHie);
        // Clear(SubProvince);
        Clear(Province);
        GLSetup.Get;
        Employee.Get(EmpCode);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Employee."Global Dimension 1 Code") then
                        exit(OrganizationStructureList.Code);
                end;

            DeputationOn::Department:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, Employee."Department Code") then
                        exit(OrganizationStructureList.Code);

                end;

            DeputationOn::"Extension Counter":
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    // EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    // if EmpHie.FindFirst then
                    //     exit(EmpHie.Code);
                    OrganizationStructureList.reset();
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Employee."Extension Counter Code") then
                        exit(OrganizationStructureList.Code);
                end;

            // DeputationOn::"Sub Province":
            //     begin
            //         SubProvince.Reset;
            //         SubProvince.SetRange(Code, Employee."Sub Province Code");
            //         if SubProvince.FindFirst then
            //             exit(SubProvince.Code);
            //     end;

            DeputationOn::Unit:
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    // EmpHie.SetRange(Code, Employee."Unit Code");
                    // if EmpHie.FindFirst then
                    //     exit(EmpHie.Code);
                    OrganizationStructureList.reset();
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, Employee."Unit Code") then
                        exit(OrganizationStructureList.Code);
                end;

            DeputationOn::Province:
                begin
                    if Province.Get(Employee."Province Code") then
                        exit(Province.Code);
                end;
        end;
    end;

    procedure PopUpForJobAssignment(EmpVar: Record Employee)
    var
        JobAssignmentPageBuilder: FilterPageBuilder;
        ServiceHistory: Record "Employee Service History";
        DateVar: Date;
        EmployeeEdit: Record "Employee Edit";
        ServiceCode: Code[20];
    begin

        JobAssignmentPageBuilder.AddRecord('Assignment in Job Function', EmployeeEdit);
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit."Deputation On");
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit."Province Code");
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit."Branch Code");
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit."Department Code");
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit."Extension Counter Code");
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit."Unit Code");
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit."Functional Title");
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit."Requested Date");
        JobAssignmentPageBuilder.AddField('Assignment in Job Function', EmployeeEdit.Remarks);
        if JobAssignmentPageBuilder.RunModal then begin
            EmployeeEdit.SetView(JobAssignmentPageBuilder.GetView('Assignment in Job Function'));
            if EmployeeEdit.GetFilter("Functional Title") = '' then
                Error('Functional Title cannot be blank.');
            if EmployeeEdit.GetFilter("Deputation On") = Format(EmployeeEdit."Deputation On"::" ") then
                Error('Deputation on must have value.');
            Evaluate(DateVar, EmployeeEdit.GetFilter("Requested Date"));
            if EmployeeEdit.GetFilter(Remarks) = '' then
                Error('Remarks cannot be blank.');

            if DateVar = 0D then
                Error('Date must have value.');
            ServiceCode := AddToServiceHistory(EmpVar."No.", ServiceHistory."Service Event"::"Assignment in Job Function", EmployeeEdit.GetFilter(Remarks), DateVar);

            case EmployeeEdit.GetFilter("Deputation On") of
                Format(EmployeeEdit."Deputation On"::Province):
                    begin
                        if EmployeeEdit.GetFilter("Province Code") = '' then
                            Error('Province Code must have value.');
                        EmpVar.Validate("Deputation on", EmpVar."Deputation on"::Province);
                        EmpVar.Validate("Province Code", EmployeeEdit.GetFilter("Province Code"));
                    end;

                Format(EmployeeEdit."Deputation On"::Branch):
                    begin
                        if EmployeeEdit.GetFilter("Branch Code") = '' then
                            Error('Branch Code must have value.');
                        EmpVar.Validate("Deputation on", EmpVar."Deputation on"::Branch);
                        EmpVar.Validate("Branch Code", EmployeeEdit.GetFilter("Branch Code"));
                    end;

                Format(EmployeeEdit."Deputation On"::Department):
                    begin
                        if EmployeeEdit.GetFilter("Department Code") = '' then
                            Error('Department Code must have value.');
                        EmpVar.Validate("Deputation on", EmpVar."Deputation on"::Department);
                        EmpVar.Validate("Department Code", EmployeeEdit.GetFilter("Department Code"));
                    end;

                Format(EmployeeEdit."Deputation On"::Unit):
                    begin
                        if EmployeeEdit.GetFilter("Unit Code") = '' then
                            Error('Unit Code must have value.');
                        if EmployeeEdit.GetFilter("Department Code") = '' then
                            Error('Department is mandatory for unit');
                        EmpVar.Validate("Deputation on", EmpVar."Deputation on"::Unit);
                        EmpVar.Validate("Department Code", EmployeeEdit.GetFilter("Department Code"));
                        EmpVar.Validate("Unit Code", EmployeeEdit.GetFilter("Unit Code"));
                    end;

                Format(EmployeeEdit."Deputation On"::"Extension Counter"):
                    begin
                        if EmployeeEdit.GetFilter("Province Code") = '' then
                            Error('Extension Counter Code must have value.');
                        if EmployeeEdit.GetFilter("Branch Code") = '' then
                            Error('Branch is mandatory for extension counter');
                        EmpVar.Validate("Deputation on", EmpVar."Deputation on"::"Extension Counter");
                        EmpVar.Validate("Branch Code", EmployeeEdit.GetFilter("Branch Code"));
                        EmpVar.Validate("Extension Counter Code", EmployeeEdit.GetFilter("Extension Counter Code"));
                    end;

            end;

            EmpVar.Validate("Functional Title", EmployeeEdit.GetFilter("Functional Title"));
            EmpVar.Modify;

            if ServiceHistory.Get(ServiceCode) then begin
                ServiceHistory.Validate("Functional Title (To)", EmpVar."Functional Title");
                ServiceHistory.Validate("Salary Level (To)", EmpVar."Salary Level");
                ServiceHistory.Validate("Deputation On (To)", EmpVar."Deputation on");
                ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Modify;
            end;

            Message('Updated');
        end;
    end;

    procedure PopUpForJobAddition(EmpVar: Record Employee)
    var
        JobAdditionPageBuilder: FilterPageBuilder;
        ServiceHistory: Record "Employee Service History";
        DateVar: Date;
        EmpActivity: Record "Employee Activity";
        ServiceCode: Code[20];
    begin

        JobAdditionPageBuilder.AddRecord('Assignment in Job Addition', EmpActivity);
        JobAdditionPageBuilder.AddField('Assignment in Job Addition', EmpActivity."Functional Title");
        JobAdditionPageBuilder.AddField('Assignment in Job Addition', EmpActivity."Start Date");
        JobAdditionPageBuilder.AddField('Assignment in Job Addition', EmpActivity.Remarks);

        if JobAdditionPageBuilder.RunModal then begin
            EmpActivity.SetView(JobAdditionPageBuilder.GetView('Assignment in Job Addition'));

            if EmpActivity.GetFilter("Functional Title") = '' then
                Error('Functional Title cannot be blank.');
            Evaluate(DateVar, EmpActivity.GetFilter("Start Date"));
            if EmpActivity.GetFilter(Remarks) = '' then
                Error('Remarks cannot be blank.');

            if DateVar = 0D then
                Error('Date must have value.');
            ServiceCode := AddToServiceHistory(EmpVar."No.", ServiceHistory."Service Event"::"Addition in Job Function", EmpActivity.GetFilter(Remarks), DateVar);



            EmpVar.Validate("Functional Title", EmpActivity.GetFilter("Functional Title"));
            EmpVar.Modify;
            if ServiceHistory.Get(ServiceCode) then begin
                ServiceHistory.Validate("Functional Title (To)", EmpVar."Functional Title");
                ServiceHistory.Validate("Salary Level (To)", EmpVar."Salary Level");
                ServiceHistory.Validate("Deputation On (To)", EmpVar."Deputation on");
                ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Modify;
            end;
            Message('Updated');
        end;
    end;

    procedure PopUpForContractRenew(EmpVar: Record Employee)
    var
        JobAdditionPageBuilder: FilterPageBuilder;
        ServiceHistory: Record "Employee Service History";
        DateVar: Date;
        EmpActivity: Record "Employee Activity";
        ServiceCode: Code[20];
        ContractRenewDate: Date;
    begin
        EmpVar.TestField("Employment Type", EmpVar."Employment Type"::Contract);
        JobAdditionPageBuilder.AddRecord('Assignment in Contract Renews', Employee1);
        JobAdditionPageBuilder.AddField('Assignment in Contract Renews', Employee1."Contract Renew Date");
        JobAdditionPageBuilder.AddField('Assignment in Contract Renews', Employee1."Contract Expiry Month");
        JobAdditionPageBuilder.AddRecord('Assignment in Contract Renew', EmpActivity);
        JobAdditionPageBuilder.AddField('Assignment in Contract Renew', EmpActivity.Remarks);

        if JobAdditionPageBuilder.RunModal then begin
            Employee1.SetView(JobAdditionPageBuilder.GetView('Assignment in Contract Renews'));
            EmpActivity.SetView(JobAdditionPageBuilder.GetView('Assignment in Contract Renew'));

            Evaluate(ContractRenewDate, Employee1.GetFilter("Contract Renew Date"));
            if ContractRenewDate = 0D then
                Error('Contract Renew Date must have value.');


            if EmpActivity.GetFilter(Remarks) = '' then
                Error('Remarks cannot be blank.');

            //check for pending leave request
            EmpActivity.Reset;
            EmpActivity.SetRange("Employee No.", EmpVar."No.");
            EmpActivity.SetRange(Type, EmpActivity.Type::"Leave Request");
            EmpActivity.SetFilter("Approval Status", '%1|%2|%3', EmpActivity."Approval Status"::Open,
                                  EmpActivity."Approval Status"::Recommended, EmpActivity."Approval Status"::Pending);
            if EmpActivity.FindFirst then
                Error('Leave request of employee %1 is still pending', EmpVar."Full Name");

            ServiceCode := AddToServiceHistory(EmpVar."No.", ServiceHistory."Service Event"::"Contract Renew", EmpActivity.GetFilter(Remarks), ContractRenewDate);

            EmpVar.Validate("Contract Renew Date", ContractRenewDate);
            Evaluate(EmpVar."Contract Expiry Month", Employee1.GetFilter("Contract Expiry Month"));
            EmpVar.Validate("Contract Expiry Date", CalcDate(StrSubstNo('<%1>', Employee1.GetFilter("Contract Expiry Month")), ContractRenewDate));
            EmpVar.Validate(Status, EmpVar.Status::Active);
            EmpVar.Modify;
            CollapseLeaveRequest(EmpVar."No.");
            if ServiceHistory.Get(ServiceCode) then begin
                ServiceHistory.Validate("Functional Title (To)", EmpVar."Functional Title");
                ServiceHistory.Validate("Salary Level (To)", EmpVar."Salary Level");
                ServiceHistory.Validate("Deputation On (To)", EmpVar."Deputation on");
                ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Modify;
            end;
            Message('Updated');
        end;
    end;

    local procedure CollapseLeaveRequest(EmpCode: Code[20])
    var
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveEarn: Record "Leave Earn";
    begin
        LeaveTypeSetup.Reset;
        LeaveTypeSetup.SetRange("Leave For Employee Type", LeaveTypeSetup."Leave For Employee Type"::Contract);
        LeaveTypeSetup.SetRange("Employee No. Filter", EmpCode);
        if LeaveTypeSetup.FindFirst then
            repeat
                LeaveTypeSetup.CalcFields("Remaining Days");
                if LeaveTypeSetup."Remaining Days" > 0 then begin
                    LeaveEarn.Reset;
                    LeaveEarn.Init;
                    LeaveEarn.Validate("Leave Code", LeaveTypeSetup.Code);
                    LeaveEarn.Validate(EmpNo, EmpCode);
                    LeaveEarn.Validate("Fiscal year", HrMgt.ReturnFiscalYear(Today));
                    LeaveEarn.Validate("Posted Date", Today);
                    LeaveEarn.Validate("Balancing Days", -LeaveTypeSetup."Remaining Days");
                    LeaveEarn.Validate(Remarks, 'Leave Collapsed.');
                    LeaveEarn.Validate(Type, LeaveEarn.Type::Collapsed);
                    LeaveEarn.Insert(true);
                end;
            until LeaveTypeSetup.Next = 0;
    end;

    local procedure ValidateTransferField(EmployeeTransferRec: Record "Employee Transfer")
    var
        FunctionalTitle: Record "Functional Title";
    begin
        Employee.Get(EmployeeTransferRec."Employee No.");
        Employee."Deputation on" := EmployeeTransferRec."Deputation On (To)";
        case Employee."Deputation on" of
            Employee."Deputation on"::Province:
                Employee.Validate("Province Code", EmployeeTransferRec."Province Code (To)");
            // Employee."Deputation on"::"Sub Province":
            //     Employee.Validate("Sub Province Code", EmployeeTransferRec."Sub Province Code (To)");
            Employee."Deputation on"::Branch:
                Employee.Validate("Global Dimension 1 Code", EmployeeTransferRec."Shortcut Dimension 1 Code (To)");
            Employee."Deputation on"::Department:
                Employee.Validate("Department Code", EmployeeTransferRec."Department Code (To)");
            Employee."Deputation on"::"Extension Counter":
                Employee.Validate("Extension Counter Code", EmployeeTransferRec."Extension Counter (To)");
            Employee."Deputation on"::Unit:
                Employee.Validate("Unit Code", EmployeeTransferRec."Unit (To)");
        end;
        Employee."Functional Title" := EmployeeTransferRec."Functional Title (To)";
        if FunctionalTitle.Get(EmployeeTransferRec."Functional Title (To)") then;
        Employee."Functional Title Desc" := FunctionalTitle.Description;
        Employee."Last Placement Date" := EmployeeTransferRec."Transfer Effective Date"; //Min -- Assign "Transfer Effective Date".
        Employee.Modify;
    end;

    local procedure ReinstateTransfer(EmpAct: Record "Employee Activity")
    var
        EmpVar: Record Employee;
        ServiceCode: Code[20];
        ServiceHistory: Record "Employee Service History";
    begin
        EmpVar.Get(EmpAct."Employee No.");
        ServiceCode := AddToServiceHistory(EmpVar."No.", ServiceHistory."Service Event"::Transfer, 'Reinstating Transfer', EmpAct."End Date");
        EmpVar.Validate("Functional Title", EmpAct."Functional Title");
        EmpVar.Validate("Deputation on", EmpAct."Deputation On");
        case EmpVar."Deputation on" of
            EmpVar."Deputation on"::Branch:
                EmpVar.Validate("Global Dimension 1 Code", EmpAct."Shortcut Dimension 1 Code");
            EmpVar."Deputation on"::Province:
                EmpVar.Validate("Province Code", EmpAct."Province Code");
            // EmpVar."Deputation on"::"Sub Province":
            //     EmpVar.Validate("Sub Province Code", EmpAct."Sub Province Code");
            EmpVar."Deputation on"::Unit:
                EmpVar.Validate("Unit Code", EmpAct."Unit Code");
            EmpVar."Deputation on"::"Extension Counter":
                EmpVar.Validate("Extension Counter Code", EmpAct."Extension Counter Code");
            EmpVar."Deputation on"::Department:
                EmpVar.Validate("Department Code", EmpAct.Department);
        end;
        EmpVar.Modify;
        if ServiceHistory.Get(ServiceCode) then begin
            ServiceHistory.Validate("Functional Title (To)", EmpVar."Functional Title");
            ServiceHistory.Validate("Salary Level (To)", EmpVar."Salary Level");
            ServiceHistory.Validate("Deputation On (To)", EmpVar."Deputation on");
            ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Modify;
        end;
    end;

    procedure PopUpChangingJobPositionEmployee(EmployeeRec: Record Employee)
    var
        EmployeePageBuilder: FilterPageBuilder;
        EmpRec: Record Employee;
    begin
        EmployeePageBuilder.AddRecord('Change Salary Level', EmpRec);
        EmployeePageBuilder.AddField('Change Salary Level', EmpRec."Salary Level");
        if EmployeePageBuilder.RunModal then begin
            EmpRec.SetView(EmployeePageBuilder.GetView('Change Salary Level'));
            if EmpRec.GetFilter("Salary Level") = '' then
                Error('Salary Level cannot be blank.');
            EmployeeRec.Validate("Salary Level", EmpRec.GetFilter("Salary Level"));
            EmployeeRec.Modify;
            Message('Job Position updated.');
        end;
    end;

    procedure ReinstateCancelTransfer(EmpHrTransfer: Record "Employee Transfer")
    var
        EmpVar: Record Employee;
        ServiceCode: Code[20];
        ServiceHistory: Record "Employee Service History";
    begin
        EmpVar.Get(EmpHrTransfer."Employee No.");
        //ServiceCode := AddToServiceHistory(EmpVar."No.",ServiceHistory."Service Event"::Transfer,'Reinstating Transfer',EmpAct."Transfer Effective Date");
        EmpVar.Validate("Functional Title", EmpHrTransfer."Functional Title");
        EmpVar.Validate("Deputation on", EmpHrTransfer."Deputation On");
        case EmpVar."Deputation on" of
            EmpVar."Deputation on"::Branch:
                EmpVar.Validate("Global Dimension 1 Code", EmpHrTransfer."Shortcut Dimension 1 Code");
            EmpVar."Deputation on"::Province:
                EmpVar.Validate("Province Code", EmpHrTransfer."Province Code");
            // EmpVar."Deputation on"::"Sub Province":
            //     EmpVar.Validate("Sub Province Code", EmpHrTransfer."Sub Province Code");
            EmpVar."Deputation on"::Unit:
                EmpVar.Validate("Unit Code", EmpHrTransfer."Unit Code");
            EmpVar."Deputation on"::"Extension Counter":
                EmpVar.Validate("Extension Counter Code", EmpHrTransfer."Extension Counter Code");
            EmpVar."Deputation on"::Department:
                EmpVar.Validate("Department Code", EmpHrTransfer.Department);
        end;
        EmpVar.Modify;
        /*IF ServiceHistory.GET(ServiceCode) THEN BEGIN
          ServiceHistory.VALIDATE("Functional Title (To)",EmpVar."Functional Title");
          ServiceHistory.VALIDATE("Salary Level (To)",EmpVar."Salary Level");
          ServiceHistory.VALIDATE("Deputation On (To)",EmpVar."Deputation on");
          ServiceHistory.VALIDATE("Deputation Code (To)",ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
          ServiceHistory.VALIDATE("Deputation Value (To)",ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
          ServiceHistory.MODIFY;
        END;*/

    end;

    procedure UpdateMissedTransfer(var EmployeeTransferRec: Record "Employee Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
        ServiceHistoryCode: Code[20];
        ServiceHistory: Record "Employee Service History";
        PreviousServiceHistory: Record "Employee Service History";
    begin
        /*IF "Approver Code" <> GetEmployeeNo THEN
  ERROR('You are not eligible to approved this document');*/
        /*TESTFIELD("Approval Status","Approval Status"::Screened);
        VALIDATE("Approval Status", "Approval Status"::Approved);
        VALIDATE("Approved Date",TODAY);*/
        if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::"Temporary" then
            ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::"Temporary Deputation", EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
        if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::Officiating then
            ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::"Officiating Arrangement", EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
        if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::General then
            ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::Transfer, EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
        EmployeeTransferRec.Modify;
        ValidateTransferField(EmployeeTransferRec);

        if ServiceHistory.Get(ServiceHistoryCode) then begin
            ServiceHistory.Validate("Functional Title (To)", EmployeeTransferRec."Functional Title (To)");
            ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
            ServiceHistory.Validate("Deputation On (To)", EmployeeTransferRec."Deputation On (To)");
            ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Validate("Document No.", EmployeeTransferRec."No.");
            PreviousServiceHistory.Reset;
            PreviousServiceHistory.SetRange("Employee No.", ServiceHistory."Employee No.");
            PreviousServiceHistory.SetFilter("Service History Code", '<>%1', ServiceHistoryCode);
            PreviousServiceHistory.SetCurrentKey("Effective Date");
            if (PreviousServiceHistory.FindLast) then
                if (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") or
                  (EmployeeTransferRec."Transfer Category" in [EmployeeTransferRec."Transfer Category"::Officiating, EmployeeTransferRec."Transfer Category"::"Temporary"]) then
                    ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
            ServiceHistory.Modify;
        end;
        //SendMailFromTemplate(DATABASE::"Employee Activity",Type::"Employee Transfer","Approval Status"::Approved,Remarks,'',"No.",0);
        Message('Document has been updated.');

    end;

    procedure ApprovedTransferUpdate(var EmployeeTransferRec: Record "Employee Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
        ServiceHistoryCode: Code[20];
        ServiceHistory: Record "Employee Service History";
        PreviousServiceHistory: Record "Employee Service History";
    begin
        if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::"Temporary" then
            ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::"Temporary Deputation", EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
        if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::Officiating then
            ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::"Officiating Arrangement", EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
        if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::General then
            ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::Transfer, EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
        EmployeeTransferRec.Modify;
        ValidateTransferField(EmployeeTransferRec);
        if ServiceHistory.Get(ServiceHistoryCode) then begin
            ServiceHistory.Validate("Functional Title (To)", EmployeeTransferRec."Functional Title (To)");
            ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
            ServiceHistory.Validate("Deputation On (To)", EmployeeTransferRec."Deputation On (To)");
            ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Validate("Document No.", EmployeeTransferRec."No.");
            PreviousServiceHistory.Reset;
            PreviousServiceHistory.SetRange("Employee No.", ServiceHistory."Employee No.");
            PreviousServiceHistory.SetFilter("Service History Code", '<>%1', ServiceHistoryCode);
            PreviousServiceHistory.SetCurrentKey("Effective Date");
            if (PreviousServiceHistory.FindLast) then
                if (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") or
                  (EmployeeTransferRec."Transfer Category" in [EmployeeTransferRec."Transfer Category"::Officiating, EmployeeTransferRec."Transfer Category"::"Temporary"]) then
                    ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
            ServiceHistory.Modify;
        end;
    end;
}
