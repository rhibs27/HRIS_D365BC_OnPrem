codeunit 50022 "Allowance Assignment Mgt"
{
    procedure OpenAllowanceRequest(EmpCode: Code[20])
    var
        AllowanceAssignment, AllowanceAssignment2 : Record "Allowance Assignment Header";
        Approval: Record "Approval HRMS";
    begin
        Clear(Employee);
        // Clear Approval line 
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Allowance Assignment");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        Employee.Get(EmpCode);
        AllowanceAssignment.Reset();
        AllowanceAssignment.SetRange("Employee No.", EmpCode);
        AllowanceAssignment.SetRange("Activity Type", AllowanceAssignment."Activity Type"::"Allowance Assignment");
        AllowanceAssignment.SetRange("Approval Status", AllowanceAssignment."Approval Status"::open);
        if AllowanceAssignment.Findfirst() then begin
            Message('This Employee Already has open Allowance Request.Click Ok to Open');
            PAGE.Run(PAGE::"Allowance Assignment Card", AllowanceAssignment)
        end else begin
            AllowanceAssignment2.Init;
            AllowanceAssignment2.Validate("Employee No.", EmpCode);
            AllowanceAssignment2.Validate("Activity Type", AllowanceAssignment2."Activity Type"::"Allowance Assignment");
            AllowanceAssignment2.Validate("Approval Status", AllowanceAssignment2."Approval Status"::Open);
            AllowanceAssignment2.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Allowance Assignment Card", AllowanceAssignment2);
        end;
    end;

    procedure SendApprovalAllowanceAssignment(var AllowanceAssignment: Record "Allowance Assignment Header"; var AllowanceLine: Record "Allowance Assignment Line")
    var
        AllowanceLineCheck: Record "Allowance Assignment Line";
        ApproverMgt: Codeunit "Approver Mgt";
        PayrollGenSetup: Record "Payroll General Setup";
    begin
        PayrollGenSetup.get();
        PayrollGenSetup.TestField("Vault Key");
        PayrollGenSetup.TestField("ATM Custodian");
        ApproverMgt.UpdateFirstApproverStatus(AllowanceAssignment."No.");
        AllowanceLineCheck.Copy(AllowanceLine);
        if AllowanceLineCheck.FindFirst then
            repeat
                AllowanceLineCheck.TestField("Employee Code");
                AllowanceLineCheck.TestField("From Date");
                // AllowanceLineCheck.TestField("To Date");
                AllowanceLineCheck.TestField("Allowance Type");
                if AllowanceLineCheck."Allowance Type" in [PayrollGenSetup."Vault Key", PayrollGenSetup."ATM Custodian"] then begin
                    if AllowanceLineCheck.Panel = AllowanceLineCheck.Panel::" " then
                        Error('Must select panel for allowance type Atm custodian allowance and Key custodian allowance of line no. %1', AllowanceLineCheck."Line No.");
                end;
            until AllowanceLineCheck.Next = 0;
        AllowanceAssignment.Validate("Approval Status", AllowanceAssignment."Approval Status"::"Pending");
        AllowanceAssignment.Modify(true);
        AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::"Pending");
    end;

    procedure ApproveRejectAllowanceAssignment(Approved: Boolean; EntryNo: Code[20])
    var
        EmpAllowance: Record "Allowance Assignment Header";
        PGSetup: Record "Payroll General Setup";
        EmpRec: Record Employee;
        AllowanceLine: Record "Allowance Assignment Line";
        ApprovalLine: Record "Approval HRMS";
        ApproverMgt: Codeunit "Approver Mgt";
    begin
        EmpAllowance.Get(EntryNo);
        AllowanceLine.Reset;
        AllowanceLine.SetRange("No.", EntryNo);
        AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::"Pending");
        if AllowanceLine.Findset() then
            repeat
                if Approved then begin
                    AllowanceLine.Validate("Approval Status", AllowanceLine."Approval Status"::Approved);
                    AllowanceLine.Validate("Approved Date", Today);
                    AllowanceLine.Modify();
                end;
            until AllowanceLine.Next() = 0;
        if Approved and (EmpAllowance."Activity Type" = EmpAllowance."Activity Type"::"Allowance Assignment Claim") then begin
            AllowanceLine.Reset;
            AllowanceLine.SetRange("No.", EntryNo);
            AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::Approved);
            AllowanceLine.SetRange("Emp Act Type", AllowanceLine."Emp Act Type"::"Allowance Assignment Claim");
            if AllowanceLine.FindSet() then
                InsertHighestPriorityAllowanceInAttendance(AllowanceLine."Employee Code", AllowanceLine."From Date");
        end;
        if not Approved then begin
            if EmpAllowance."Activity Type" = EmpAllowance."Activity Type"::"Allowance Assignment" then begin
                AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::open);
                ApprovalLine.Reset();
                ApprovalLine.SetRange("Document No.", EntryNo);
                ApprovalLine.DeleteAll(true);
                ApproverMgt.InsertApproval(EmpAllowance."Employee No.", EntryNo, EmpAllowance."Activity Type", EmpAllowance."Approval Status");
            end else if EmpAllowance."Activity Type" = EmpAllowance."Activity Type"::"Allowance Assignment Claim" then begin
                AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::Rejected);
            end;

        end;
    end;

    procedure CheckFunctionalTitleForRiskAllowance(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        FunctionalTitle: Record "Functional Title";
    begin
        Employee.Get(AllowanceAssignmentLine."Employee Code");
        FunctionalTitle.Get(Employee."Functional Title");
        if not FunctionalTitle."Risk Title" then
            Error('Employee not eligbile for this allowance type.');
    end;

    procedure CheckFunctionalTitleForEveningCounter(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        FunctionalTitle: Record "Functional Title";
        AllowanceLineVar: Record "Allowance Assignment Line";
        FunctionTitle: Record "Functional Title";
        Counter: Integer;
        PGSetup: Record "Payroll General Setup";
    begin
        Employee.Get(AllowanceAssignmentLine."Employee Code");
        Clear(Counter);
        HRSetup.Get;
        PGSetup.Get;
        FunctionalTitle.Get(Employee."Functional Title");
        if (not FunctionalTitle."Evening Counter Eligible") and (not FunctionalTitle."Risk Title") then
            Error('Employee not eligbile for this allowance type.');
        if FunctionalTitle."Evening Counter Eligible" then
            exit;
        if FunctionalTitle."Risk Title" then begin
            AllowanceLineVar.Reset;
            AllowanceLineVar.SetRange(Code, AllowanceAssignmentLine.Code);
            AllowanceLineVar.SetRange(Type, AllowanceAssignmentLine.Type);
            AllowanceLineVar.SetRange("From Date", AllowanceAssignmentLine."From Date");
            AllowanceLineVar.SetRange("Allowance Type", PGSetup."Evening Counter");
            AllowanceLineVar.SetFilter("Line No.", '<>%1', AllowanceAssignmentLine."Line No.");
            if AllowanceLineVar.Find('-') then
                repeat
                    Employee.Reset;
                    Employee.Get(AllowanceLineVar."Employee Code");
                    if FunctionTitle.Get(Employee."Functional Title") then
                        if (FunctionTitle."Risk Title") and (not FunctionTitle."Evening Counter Eligible") then
                            Counter += 1;

                until AllowanceLineVar.Next = 0;
            if Counter >= HRSetup."No of risk employee in Evening" then
                Error('Risk employee must be not exceed %1 in evening counter.', HRSetup."No of risk employee in Evening");
        end;
    end;

    procedure CheckFunctionalTitleForHolidayCounter(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        FunctionalTitle: Record "Functional Title";
    begin
        Employee.Get(AllowanceAssignmentLine."Employee Code");
        FunctionalTitle.Get(Employee."Functional Title");
        if not FunctionalTitle."Holiday Counter Eligible" then
            Error('Employee not eligbile for this allowance type.');
    end;

    procedure CheckEmployeeAlreadyExistsforSameEmployee(No: Code[20]; LineNo: Integer; EmpNo: Code[20]; Allowancetype: Code[20]; FromDate: Date)
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
    begin
        AllowanceAssignmentLine.Reset;
        AllowanceAssignmentLine.SetRange("No.", No);
        AllowanceAssignmentLine.SetFilter("Line No.", '<>%1', LineNo);
        AllowanceAssignmentLine.SetRange("Employee Code", EmpNo);
        AllowanceAssignmentLine.SetRange("Allowance Type", Allowancetype);
        AllowanceAssignmentLine.SetFilter("Approval Status", '<>%1', AllowanceAssignmentLine."Approval Status"::Rejected);
        AllowanceAssignmentLine.SetRange("From Date", FromDate);
        if AllowanceAssignmentLine.FindFirst then
            Error('Employee already exist for same allowance type.');
    end;

    procedure CheckSalaryLevelForVaultKey(AllowanceAssignLine: Record "Allowance Assignment Line")
    begin
        Employee.Get(AllowanceAssignLine."Employee Code");
        SalaryLevel.Get(Employee."Salary Level");
        if not SalaryLevel."Vault Key Eligible" then
            Error('Employee not eligbile for this allowance type.');
    end;

    procedure CheckForPanel(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        AllowanceAssignLine: Record "Allowance Assignment Line";
    begin
        AllowanceAssignLine.Reset;
        AllowanceAssignLine.SetRange("Allowance Type", AllowanceAssignmentLine."Allowance Type");
        AllowanceAssignLine.SetRange("From Date", AllowanceAssignmentLine."From Date");
        AllowanceAssignLine.SetRange("No.", AllowanceAssignmentLine."No.");
        AllowanceAssignLine.SetFilter("Line No.", '<>%1', AllowanceAssignmentLine."Line No.");
        AllowanceAssignLine.SetRange(Code, AllowanceAssignmentLine.Code);
        AllowanceAssignLine.SetRange(Type, AllowanceAssignmentLine.Type);
        AllowanceAssignLine.SetRange(Panel, AllowanceAssignmentLine.Panel);
        if AllowanceAssignLine.FindFirst then
            Error('%1 already exist for date %2', AllowanceAssignmentLine.Panel, AllowanceAssignmentLine."From Date");
    end;

    // Modified procedure to insert only the highest amount allowance
    procedure InsertHighestPriorityAllowanceInAttendance(EmployeeCode: Code[20]; AttendanceDate: Date)
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        HighestAmountAllowanceType: Code[20];
        HighestAmount: Decimal;
        CurrentAmount: Decimal;
    begin
        HighestAmount := 0;
        // Find all approved allowances for this employee on this date
        AllowanceAssignmentLine.Reset;
        AllowanceAssignmentLine.SetRange("Employee Code", EmployeeCode);
        AllowanceAssignmentLine.SetRange("From Date", AttendanceDate);
        AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
        AllowanceAssignmentLine.SetRange("Emp Act Type", AllowanceAssignmentLine."Emp Act Type"::"Allowance Assignment Claim");
        if AllowanceAssignmentLine.Findset() then
            repeat
                CurrentAmount := GetAllowanceAmount(AllowanceAssignmentLine."Allowance Type");
                if CurrentAmount > HighestAmount then begin
                    HighestAmount := CurrentAmount;
                    HighestAmountAllowanceType := AllowanceAssignmentLine."Allowance Type";
                end;
            until AllowanceAssignmentLine.Next() = 0;

        // Update attendance with the highest amount allowance
        if HighestAmountAllowanceType <> '' then begin
            EmployeeAttendanceActivity.Reset;
            EmployeeAttendanceActivity.SetRange("Attendance Date", AttendanceDate);
            EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
            if EmployeeAttendanceActivity.FindFirst then begin
                UpdateAttendanceWithAllowance(EmployeeAttendanceActivity, HighestAmountAllowanceType);
                EmployeeAttendanceActivity.Modify;
            end;
        end;
    end;
    // Function to get allowance amount from Payroll General Setup
    procedure GetAllowanceAmount(AllowanceType: Code[20]): Decimal
    begin
        PGSetup.Get();
        case AllowanceType of
            PGSetup."Head Teller Allowance":
                exit(PGSetup."Head Teller Allow. (Regular)");
            PGSetup."Vault Key":
                exit(PGSetup."Vault Key Allowance(Regular)");
            PGSetup."Teller Allowance":
                exit(PGSetup."Teller Allowance (Regular)");
            PGSetup."ATM Custodian":
                exit(PGSetup."ATM Custodian regular (month)");
            PGSetup."Evening Counter":
                exit(PGSetup."Evening Counter (Regular)");
            PGSetup."Morning Counter":
                exit(PGSetup."Morning Counter (Regular)");
            PGSetup."Festival Counter":
                exit(PGSetup."Festival Counter(Regular)");
            PGSetup."Holiday Counter":
                exit(PGSetup."Holiday All. Amt (Regular)");
            PGSetup."Friday Counter":
                exit(PGSetup."Festival Counter(Regular)");
            else
                exit(0);
        end;
    end;
    // procedure to update attendance fields
    procedure UpdateAttendanceWithAllowance(var EmployeeAttendanceActivity: Record "Employee Attendance & Activity"; AllowanceType: Code[20])
    begin
        PGSetup.Get();
        case AllowanceType of
            PGSetup."Evening Counter":
                EmployeeAttendanceActivity."Evening Counter Days" := 1;
            PGSetup."Morning Counter":
                EmployeeAttendanceActivity."Morning Counter Days" := 1;
            PGSetup."Festival Counter":
                EmployeeAttendanceActivity."Festival Counter Days" := 1;
            PGSetup."Holiday Counter":
                EmployeeAttendanceActivity."Holiday Counter Days" := 1;
            PGSetup."Friday Counter":
                EmployeeAttendanceActivity."Friday Counter Days" := 1;
            PGSetup."Risk Allowance":
                EmployeeAttendanceActivity."Cash Risk Days" := 1;
            PGSetup."Vault Key":
                EmployeeAttendanceActivity."Vault Key Days" := 1;
            PGSetup."Head Teller Allowance":
                EmployeeAttendanceActivity."Head Teller Allowance Days" := 1;
            PGSetup."Teller Allowance":
                EmployeeAttendanceActivity."Teller Allowance Days" := 1;
            PGSetup."ATM Custodian":
                EmployeeAttendanceActivity."ATM Custodian Allowance days" := 1;
        end;
    end;

    procedure SetAllowanceAmount(EmpNo: Code[20]; AllowanceType: Code[20]; FromDate: Date): Decimal
    var
        PayCyclePeriod: Record "Pay Cycle Period";
        NoOfDays: Decimal;

    begin
        PGSetup.Get;
        if FromDate = 0D then
            Error('Date must have value');
        Clear(NoOfDays);
        if Employee.Get(EmpNo) then;
        NoOfDays := CalcDate('CM', FromDate) - CalcDate('-CM', FromDate) + 1;

        EngNep.Reset;
        case AllowanceType of
            PGSetup."Evening Counter":
                begin
                    if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        exit(PGSetup."Evening Counter (Contract)")
                    else
                        exit(PGSetup."Evening Counter (Regular)");
                end;

            PGSetup."Holiday Counter":
                begin
                    if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        exit(PGSetup."Holiday All. Amt (Contract)")
                    else
                        exit(PGSetup."Holiday All. Amt (Regular)");
                end;

            PGSetup."Festival Counter":
                begin
                    if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        exit(PGSetup."Festival Counter(Contract)")
                    else
                        exit(PGSetup."Festival Counter(Regular)");
                end;

            PGSetup."Vault Key":
                begin
                    if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        exit(Round(PGSetup."Vault Key Allowance (Contract)" / NoOfDays, 0.00001, '='))
                    else
                        exit(Round(PGSetup."Vault Key Allowance(Regular)" / NoOfDays, 0.00001, '='));
                end;

            PGSetup."Morning Counter":
                begin
                    if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        exit(PGSetup."Morning Counter (Contract)")
                    else
                        exit(PGSetup."Morning Counter (Regular)");
                end;
            PGSetup."Head Teller Allowance":
                begin
                    if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        exit(PGSetup."Head Teller Allow. (Contract)")
                    else
                        exit(PGSetup."Head Teller Allow. (Regular)");
                end;
            PGSetup."Teller Allowance":
                begin
                    if Employee."Employment Type" = Employee."Employment Type"::"Contract" then
                        exit(PGSetup."Teller Allowance (Contract)")
                    else
                        exit(PGSetup."Teller Allowance (Regular)");
                end;
            PGSetup."ATM Custodian":
                begin
                    if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        exit(PGSetup."ATM Custodian contract (month)")
                    else
                        exit(PGSetup."ATM Custodian regular (month)")
                end;

            PGSetup."Risk Allowance":
                begin
                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetFilter("Allowance Start Date", '<=%1', FromDate);
                    PayCyclePeriod.SetFilter("Allowance End Date", '>=%1', FromDate);
                    if Employee."Employment Type" <> Employee."Employment Type"::Contract then begin
                        LevelwiseAttribute.Reset;
                        PGSetup.TestField("TA Salary Level");
                        if LevelwiseAttribute.Get(Employee."Salary Grade", Employee."Salary Level") then;
                        SalaryLevel.Get(Employee."Salary Level");
                        if SalaryLevel.Code = PGSetup."TA Salary Level" then
                            exit(Round(PGSetup."Cash Risk Percent" / 100 * SalaryLevel."TA OT Basic Salary" / NoOfDays, 0.00001, '='))
                        else
                            exit(Round(PGSetup."Cash Risk Percent" / 100 * LevelwiseAttribute."Total Basic Salary" / NoOfDays, 0.00001, '='));
                    end else begin
                        exit(Round(PGSetup."Cash Risk Percent" / 100 * Employee."Contract Salary Amount" / NoOfDays, 0.00001, '='));
                    end;
                end;
            PGSetup."Friday Counter":
                begin
                    SalaryLevel.Get(Employee."Salary Level");
                    exit(SalaryLevel."Friday Allowance");
                end;
        end;
    end;

    procedure RejectAllowanceAssigment(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        AllowanceAssignmentPageBuilder: FilterPageBuilder;
        AllowanceAssignmentLine1, AllowanceAssignmentLine2 : Record "Allowance Assignment Line";
    begin
        Employee.Get(HrMgt.GetEmployeeNo);
        AllowanceAssignmentPageBuilder.AddRecord('Reject Allowance Assignment', AllowanceAssignmentLine2);
        AllowanceAssignmentPageBuilder.ADdField('Reject Allowance Assignment', AllowanceAssignmentLine2."Rejection Remarks");
        if AllowanceAssignmentPageBuilder.RunModal then begin
            AllowanceAssignmentLine2.SetView(AllowanceAssignmentPageBuilder.GetView('Reject Allowance Assignment'));
            if AllowanceAssignmentLine2.GetFilter("Rejection Remarks") = '' then
                Error('Rejection remarks must have value');
            AllowanceAssignmentLine.TestField("Approval Status", AllowanceAssignmentLine."Approval Status"::"Pending");
            AllowanceAssignmentLine.Validate("Rejection Remarks", AllowanceAssignmentLine2.GetFilter("Rejection Remarks"));
            AllowanceAssignmentLine.Validate("Approval Status", AllowanceAssignmentLine."Approval Status"::Rejected);
            AllowanceAssignmentLine.Modify;
            AllowanceAssignmentLine1.Get(AllowanceAssignmentLine."No.", AllowanceAssignmentLine."Substitute of Line No.");
            AllowanceAssignmentLine1.Validate("Substitute Type", AllowanceAssignmentLine."Substitute Type"::" ");
            AllowanceAssignmentLine1.Modify();
            Message('Success');
        end;
    end;

    procedure InsertAllowanceLine(DocumentNo: Code[20]; AllowanceType: Code[20]; Panel: Enum Panel; EmployeeNo: Code[20]; FromDate: date; ToDate: date)
    var
        AllowanceAssignLine: Record "Allowance Assignment Line";
        AllowanceAssignHeader: Record "Allowance Assignment Header";
        AssignDate: Date;
    begin
        AllowanceAssignHeader.Get(DocumentNo);
        AssignDate := FromDate;
        for FromDate := FromDate to ToDate do begin
            AllowanceAssignLine.Init();
            AllowanceAssignLine.Validate("No.", DocumentNo);
            AllowanceAssignLine.Validate("Emp Act Type", AllowanceAssignLine."Emp Act Type"::"Allowance Assignment");
            AllowanceAssignLine.Validate(Code, AllowanceAssignHeader.Code);
            AllowanceAssignLine.Validate(Name, AllowanceAssignHeader.Name);
            AllowanceAssignLine.Validate(Type, AllowanceAssignHeader.Type);
            AllowanceAssignLine.Validate("Allowance Type", AllowanceType);
            AllowanceAssignLine.Validate(Panel, Panel);
            AllowanceAssignLine.Validate("Employee Code", EmployeeNo);
            AllowanceAssignLine.Validate("From Date", FromDate);
            AllowanceAssignLine.Validate("Approval Status", AllowanceAssignLine."Approval Status"::Open);
            AllowanceAssignLine.Validate("Substitute Type", AllowanceAssignLine."Substitute Type"::" ");
            GetLineNo(AllowanceAssignLine);
            AllowanceAssignLine.Insert();
            AssignDate := FromDate + 1;
        end;
    end;

    procedure GetLineNo(var AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        AllowanceLine: Record "Allowance Assignment Line";
    begin
        AllowanceLine.Reset;
        AllowanceLine.SetCurrentKey("No.", "Line No.");
        AllowanceLine.SetRange("No.", AllowanceAssignmentLine."No.");
        if AllowanceLine.FindLast then
            AllowanceAssignmentLine."Line No." := AllowanceLine."Line No." + 10000
        else
            AllowanceAssignmentLine."Line No." := 10000;
    end;

    procedure OpenAllowanceClaimRequest(EmpCode: Code[20])
    var
        AllowanceAssignment, AllowanceAssignment2 : Record "Allowance Assignment Header";
        Approval: Record "Approval HRMS";
        BranchType: Enum "Branchwise/Extension Type";
    begin
        Clear(Employee);
        // Clear Approval line 
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Allowance Assignment claim");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        //for get Nepali month start and end date
        PayCyclePeriod.SetFilter("Allowance Start Date", '<=%1', Today);
        PayCyclePeriod.SetFilter("Pay Date", '>=%1', Today);
        if PayCyclePeriod.FindFirst() then begin
        end else
            Error('Payroll PayCyclePeriod Not found');
        if not ((PayCyclePeriod."Allowance End Date" <= Today) and (Today > PayCyclePeriod."Pay Date" - 1)) then
            Error('You can not Create Allowance claim before %1 and After %2', PayCyclePeriod."Allowance End Date", PayCyclePeriod."Pay Date" - 1);
        Employee.Get(EmpCode);
        AllowanceAssignment.Reset();
        AllowanceAssignment.SetRange("Employee No.", EmpCode);
        AllowanceAssignment.SetRange("Activity Type", AllowanceAssignment."Activity Type"::"Allowance Assignment Claim");
        AllowanceAssignment.SetRange("Approval Status", AllowanceAssignment."Approval Status"::open);
        if AllowanceAssignment.Findfirst() then begin
            If GuiAllowed then begin
                Message('This Employee Already has open Allowance Claim Request .Click Ok to Open');
                PAGE.Run(PAGE::"Allowance Assignment Card", AllowanceAssignment)
            end else
                Error('%1 has already open Allowance Assignment Claim %2.', Employee."Full Name", AllowanceAssignment."No.");
        end else begin
            //Check if allowance claim exist or not 
            CheckAllowanceApproved(EmpCode);
            AllowanceAssignment2.Init;
            AllowanceAssignment2.Validate("Employee No.", EmpCode);
            AllowanceAssignment2.Validate("Activity Type", AllowanceAssignment2."Activity Type"::"Allowance Assignment Claim");
            Evaluate(BranchType, Format(Employee."Deputation on"));
            AllowanceAssignment2.Validate(Type, BranchType);
            AllowanceAssignment2.Validate(Code, Employee."Deputation On Code");
            AllowanceAssignment2.Validate("From Date", PayCyclePeriod."Allowance Start Date");
            AllowanceAssignment2.Validate("To date", PayCyclePeriod."Allowance End Date");
            AllowanceAssignment2.Validate("Approval Status", AllowanceAssignment2."Approval Status"::Open);
            AllowanceAssignment2.Insert(true);
            GetAllowanceClaimLine(AllowanceAssignment2."No.");
            if GuiAllowed then
                PAGE.Run(PAGE::"Allowance Assignment Card", AllowanceAssignment2);
        end;
    end;

    procedure CheckAllowanceApproved(EmpCode: Code[20])
    var
        ALlowanceAssignmentLineApproved: Record "Allowance Assignment Line";
    begin
        ALlowanceAssignmentLineApproved.Reset();
        ALlowanceAssignmentLineApproved.SetRange("Employee Code", EmpCode);
        ALlowanceAssignmentLineApproved.SetRange("From Date", PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
        ALlowanceAssignmentLineApproved.SetRange("Approval Status", ALlowanceAssignmentLineApproved."Approval Status"::Approved);
        ALlowanceAssignmentLineApproved.SetRange("Emp Act Type", ALlowanceAssignmentLineApproved."Emp Act Type"::"Allowance Assignment");
        ALlowanceAssignmentLineApproved.SetFilter("Substitute Type", '%1|%2', ALlowanceAssignmentLineApproved."Substitute Type"::" ", ALlowanceAssignmentLineApproved."Substitute Type"::"Added as Substitute");
        if ALlowanceAssignmentLineApproved.Count() < 1 then
            Error('Approved Allowance not found from %1 to %2 Period', PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
    end;

    procedure GetAllowanceClaimLine(AllowanceAssignmentCode: Code[20])
    var
        AllowanceAssignmentHeader: Record "Allowance Assignment Header";
        ALlowanceAssignmentLineApproved, AllowanceAssignmentLineClaim, ALlowanceAssignmentLineCheck : Record "Allowance Assignment Line";
        Approval: Record "Approval HRMS";
    begin
        //Delete Overtime line
        AllowanceAssignmentHeader.Get(AllowanceAssignmentCode);
        Employee.get(AllowanceAssignmentHeader."Employee No.");
        ALlowanceAssignmentLineCheck.Reset;
        ALlowanceAssignmentLineCheck.SetRange("No.", AllowanceAssignmentCode);
        ALlowanceAssignmentLineCheck.SetRange("Approval Status", ALlowanceAssignmentLineCheck."Approval Status"::Open);
        ALlowanceAssignmentLineCheck.DeleteAll(); // Delete existing lines for the record    

        ALlowanceAssignmentLineApproved.Reset();
        ALlowanceAssignmentLineApproved.SetRange("Employee Code", AllowanceAssignmentHeader."Employee No.");
        ALlowanceAssignmentLineApproved.SetRange("From Date", AllowanceAssignmentHeader."From Date", AllowanceAssignmentHeader."To date");
        ALlowanceAssignmentLineApproved.SetRange("Approval Status", ALlowanceAssignmentLineApproved."Approval Status"::Approved);
        ALlowanceAssignmentLineApproved.SetRange("Emp Act Type", ALlowanceAssignmentLineApproved."Emp Act Type"::"Allowance Assignment");
        ALlowanceAssignmentLineApproved.SetFilter("Substitute Type", '%1|%2', ALlowanceAssignmentLineApproved."Substitute Type"::" ", ALlowanceAssignmentLineApproved."Substitute Type"::"Added as Substitute");
        if ALlowanceAssignmentLineApproved.FindSet() then
            repeat
                AllowanceAssignmentLineClaim.Init();
                AllowanceAssignmentLineClaim."No." := AllowanceAssignmentCode;
                AllowanceAssignmentLineClaim."Line No." := 0;
                AllowanceAssignmentLineClaim."Allowance Claim From" := ALlowanceAssignmentLineApproved."No.";
                AllowanceAssignmentLineClaim."Employee Code" := ALlowanceAssignmentLineApproved."Employee Code";
                AllowanceAssignmentLineClaim."Employee Name" := ALlowanceAssignmentLineApproved."Employee Name";
                AllowanceAssignmentLineClaim.Type := AllowanceAssignmentHeader.Type;
                AllowanceAssignmentLineClaim.Code := AllowanceAssignmentHeader.Code;
                AllowanceAssignmentLineClaim.Name := AllowanceAssignmentHeader.Name;
                AllowanceAssignmentLineClaim."Emp Act Type" := ALlowanceAssignmentLineApproved."Emp Act Type"::"Allowance Assignment Claim";
                AllowanceAssignmentLineClaim."Allowance Type" := ALlowanceAssignmentLineApproved."Allowance Type";
                AllowanceAssignmentLineClaim.Panel := ALlowanceAssignmentLineApproved.Panel;
                AllowanceAssignmentLineClaim."From Date" := ALlowanceAssignmentLineApproved."From Date";
                AllowanceAssignmentLineClaim."Approval Status" := ALlowanceAssignmentLineApproved."Approval Status"::Open;
                AllowanceAssignmentLineClaim."Substitute Type" := ALlowanceAssignmentLineApproved."Substitute Type";
                AllowanceAssignmentLineClaim."Allowance Amount" := ALlowanceAssignmentLineApproved."Allowance Amount";
                AllowanceAssignmentLineClaim.Insert(true);
            until ALlowanceAssignmentLineApproved.Next() = 0;
    end;

    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        SalaryLevel: Record "Salary Level";
        PGSetup: Record "Payroll General Setup";
        LevelWiseAttribute: Record "Level Wise Attributes";
        EngNep: Record "English-Nepali Date";
        GLSetup: Record "General Ledger Setup";
        HrMgt: Codeunit "HR Mgt.";
        PayCyclePeriod: Record "Pay Cycle Period";

}
