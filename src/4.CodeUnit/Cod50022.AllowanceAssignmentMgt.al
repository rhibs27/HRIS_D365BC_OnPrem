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
        if not PayrollGenSetup."Use Allowance Configuration" then begin
            PayrollGenSetup.TestField("Vault Key");
            PayrollGenSetup.TestField("ATM Custodian");
        end;
        ApproverMgt.UpdateFirstApproverStatus(AllowanceAssignment."No.");
        if AllowanceAssignment."Activity Type" <> AllowanceAssignment."Activity Type"::"Request Allowance" then begin
            AllowanceLineCheck.Copy(AllowanceLine);
            if AllowanceLineCheck.FindFirst then
                repeat
                    AllowanceLineCheck.TestField("Employee Code");
                    AllowanceLineCheck.TestField("From Date");
                    AllowanceLineCheck.TestField("Allowance Type");
                    // AllowanceLineCheck.TestField("To Date");
                    // CheckEmployeeAlreadyExistsForSameEmployee(AllowanceLineCheck."No.", AllowanceLineCheck."Line No.", AllowanceLineCheck."Employee Code", AllowanceLineCheck."Allowance Type", AllowanceLineCheck."From Date", AllowanceLineCheck."Emp Act Type");
                    CheckMutuallyExclusive(AllowanceLineCheck);
                    CheckDate(AllowanceLineCheck);
                    CheckMaximumEmployeeInBranch(AllowanceLineCheck);
                    ValidateAllowanceType(AllowanceLineCheck);
                    if AllowanceLineCheck."Allowance Type" in [PayrollGenSetup."Vault Key", PayrollGenSetup."ATM Custodian"] then begin
                        if AllowanceLineCheck.Panel = AllowanceLineCheck.Panel::" " then
                            Error('Must select panel for allowance type Atm custodian allowance and Key custodian allowance of line no. %1', AllowanceLineCheck."Line No.");
                    end;
                until AllowanceLineCheck.Next = 0;
        end;
        AllowanceAssignment.Validate("Approval Status", AllowanceAssignment."Approval Status"::"Pending");
        AllowanceAssignment.Modify(true);
        AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::"Pending");
    end;

    procedure ApproveRejectAllowanceAssignment(Approved: Boolean; EntryNo: Code[20])
    var
        EmpAllowance: Record "Allowance Assignment Header";
        AllowanceLine: Record "Allowance Assignment Line";
        ApprovalLine: Record "Approval HRMS";
        ApproverMgt: Codeunit "Approver Mgt";
        IsHandled: Boolean;
    begin
        AllowanceAssignmentApprovalReject(Approved, EntryNo, IsHandled);
        If not IsHandled then begin
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
                        HrMgt.CreateEmpActLedger(AllowanceLine."Emp Act Type", EmpAllowance."No.", AllowanceLine."Employee Code", AllowanceLine."From Date", False, 1);
                        if AllowanceLine."Emp Act Type" = AllowanceLine."Emp Act Type"::"Allowance Assignment Claim" then
                            UpdateClaimInAllowanceRequest(AllowanceLine);
                    end;
                until AllowanceLine.Next() = 0;
            if Approved and (EmpAllowance."Activity Type" = EmpAllowance."Activity Type"::"Allowance Assignment Claim") then begin
                AllowanceLine.Reset;
                AllowanceLine.SetRange("No.", EntryNo);
                AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::Approved);
                AllowanceLine.SetRange("Emp Act Type", AllowanceLine."Emp Act Type"::"Allowance Assignment Claim");
                if AllowanceLine.FindSet() then
                    repeat
                        if AllowanceLine."From Date" <= Today then
                            AttendanceMgt.DailyAttendanceUpdate(AllowanceLine."From Date", AllowanceLine."From Date", AllowanceLine."Employee Code");
                    until AllowanceLine.next = 0;
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
                end
                else if EmpAllowance."Activity Type" = EmpAllowance."Activity Type"::"Request Allowance" then begin
                    AllowanceLine.Reset;
                    AllowanceLine.SetRange("No.", EntryNo);
                    AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::"Pending");
                    if AllowanceLine.Findset() then
                        AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::Rejected);
                end;
            end;
        end;
    end;

    local procedure UpdateClaimInAllowanceRequest(AllowanceClaimLine: Record "Allowance Assignment Line")
    var
        AllowanceLine: Record "Allowance Assignment Line";
    begin
        if AllowanceLine.Get(AllowanceClaimLine."Allowance Claim From", AllowanceClaimLine."Allowance Claim from Line No") then begin
            AllowanceLine.Validate("Allowance Claimed", true);
            AllowanceLine.Modify();
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

    procedure CheckEmployeeAlreadyExistsForSameEmployee(No: Code[20]; LineNo: Integer; EmpNo: Code[20]; AllowanceType: Code[20]; FromDate: Date; EmpActType: Enum "Employee Activity Type")
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
    begin
        AllowanceAssignmentLine.Reset;
        AllowanceAssignmentLine.SetRange("Employee Code", EmpNo);
        AllowanceAssignmentLine.SetRange("Emp Act Type", EmpActType);
        AllowanceAssignmentLine.SetRange("Allowance Type", AllowanceType);
        AllowanceAssignmentLine.Setfilter("Substitute Type", '%1|%2', AllowanceAssignmentLine."Substitute Type"::" ", AllowanceAssignmentLine."Substitute Type"::"Added as Substitute");
        AllowanceAssignmentLine.SetFilter("Approval Status", '<>%1', AllowanceAssignmentLine."Approval Status"::Rejected);
        AllowanceAssignmentLine.SetRange("From Date", FromDate);
        if AllowanceAssignmentLine.FindFirst then
            Error('Employee already exist for same allowance type in same day in Allowance No %1 and Line no %2', AllowanceAssignmentLine."No.", AllowanceAssignmentLine."Line No.");
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
    procedure InsertHighestPriorityAllowanceInAttendance(EmployeeCode: Code[20]; AttendanceDate: Date; Var EmployeeAttendanceActivity: Record "Employee Attendance & Activity")
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        HighestAmountAllowanceType: Code[20];
        HighestAmount: Decimal;
        CurrentAmount: Decimal;
    begin
        HighestAmount := 0;
        // Find all approved allowances for this employee on this date
        AllowanceAssignmentLine.SetLoadFields("Employee Code", "From Date", "Approval Status", "Emp Act Type", "Allowance Type");
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
            UpdateAttendanceWithAllowance(EmployeeAttendanceActivity, HighestAmountAllowanceType);
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
            PGSetup."Dashain Allowance":
                exit(PGSetup."Dashain Allowance Amount");
            else
                exit(0);
        end;
    end;
    // procedure to update attendance fields
    procedure UpdateAttendanceWithAllowance(var EmployeeAttendanceActivity: Record "Employee Attendance & Activity"; AllowanceType: Code[20])
    begin
        PGSetup.Get();
        ClearAllowanceFromAttendance(EmployeeAttendanceActivity);
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
            PGSetup."Dashain Allowance":
                EmployeeAttendanceActivity."Dashain Allowance Days" := 1;
        end;
    end;

    local procedure ClearAllowanceFromAttendance(var EmployeeAttendanceActivity: Record "Employee Attendance & Activity")
    begin
        Clear(EmployeeAttendanceActivity."Evening Counter Days");
        Clear(EmployeeAttendanceActivity."Morning Counter Days");
        Clear(EmployeeAttendanceActivity."Festival Counter Days");
        Clear(EmployeeAttendanceActivity."Holiday Counter Days");
        Clear(EmployeeAttendanceActivity."Friday Counter Days");
        Clear(EmployeeAttendanceActivity."Cash Risk Days");
        Clear(EmployeeAttendanceActivity."Vault Key Days");
        Clear(EmployeeAttendanceActivity."Head Teller Allowance Days");
        Clear(EmployeeAttendanceActivity."Teller Allowance Days");
        Clear(EmployeeAttendanceActivity."ATM Custodian Allowance days");
        Clear(EmployeeAttendanceActivity."Dashain Allowance Days");
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
            PGSetup."Dashain Allowance":
                begin
                    exit(PGSetup."Dashain Allowance Amount");
                end;
        end;
    end;

    procedure RejectAllowanceAssigment(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        AllowanceAssignmentPageBuilder: FilterPageBuilder;
        AllowanceAssignmentLine1, AllowanceAssignmentLine2 : Record "Allowance Assignment Line";
    begin
        if not HrMgt.IsSaaS() then
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
            AllowanceAssignLine.Validate("Emp Act Type", AllowanceAssignHeader."Activity Type");
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
        OnBeforeOpenAllowanceAssignmentClaim(EmpCode);
        Clear(Employee);
        PGSetup.Get();
        // Clear Approval line
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Allowance Assignment claim");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        // //for get Nepali month start and end date
        // PayCyclePeriod.SetFilter("Allowance Start Date", '<=%1', Today);
        // PayCyclePeriod.SetFilter("Pay Date", '>=%1', Today);
        // if PayCyclePeriod.FindFirst() then begin
        // end else
        //     Error('Payroll PayCyclePeriod Not found');
        // if ((Today <= PayCyclePeriod."Allowance End Date") or (Today > (PayCyclePeriod."Allowance End Date" + PGSetup."Allowance Claim Limit (days)"))) then
        //     Error('You can not Create Allowance claim before %1 and After %2', PayCyclePeriod."Allowance End Date", PayCyclePeriod."Pay Date" - 1);
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
            // CheckAllowanceApproved(EmpCode);
            AllowanceAssignment2.Init;
            AllowanceAssignment2.Validate("Employee No.", EmpCode);
            AllowanceAssignment2.Validate("Activity Type", AllowanceAssignment2."Activity Type"::"Allowance Assignment Claim");
            if Employee."Deputation on" = Employee."Deputation on"::Department then begin
                if Employee."Unit Code" = '' then begin
                    Evaluate(BranchType, Format(Employee."Deputation on"));
                    AllowanceAssignment2.Validate(Type, BranchType);
                    AllowanceAssignment2.Validate(Code, Employee."Deputation On Code");
                end else begin
                    Evaluate(BranchType, Format(Employee."Deputation on"::Unit));
                    AllowanceAssignment2.Validate(Type, BranchType);
                    AllowanceAssignment2.Validate(Code, Employee."Unit Code");
                end;
            end else if Employee."Deputation on" = Employee."Deputation on"::Branch then begin
                if Employee."Extension Counter Code" = '' then begin
                    Evaluate(BranchType, Format(Employee."Deputation on"));
                    AllowanceAssignment2.Validate(Type, BranchType);
                    AllowanceAssignment2.Validate(Code, Employee."Deputation On Code");
                end else begin
                    Evaluate(BranchType, Format(Employee."Deputation on"::"Extension Counter"));
                    AllowanceAssignment2.Validate(Type, BranchType);
                    AllowanceAssignment2.Validate(Code, Employee."Extension Counter Code");
                end;
            end else if Employee."Deputation on" = Employee."Deputation on"::Province then begin
                Evaluate(BranchType, Format(Employee."Deputation on"));
                AllowanceAssignment2.Validate(Type, BranchType);
                AllowanceAssignment2.Validate(Code, Employee."Deputation On Code");
            end;
            AllowanceAssignment2.Validate("Approval Status", AllowanceAssignment2."Approval Status"::Open);
            AllowanceAssignment2.Insert(true);
            // GetAllowanceClaimLine(AllowanceAssignment2."No.");
            if GuiAllowed then
                PAGE.Run(PAGE::"Allowance Assignment Card", AllowanceAssignment2);
        end;
    end;
    // procedure CheckAllowanceApproved(EmpCode: Code[20])
    // var
    //     ALlowanceAssignmentLineApproved: Record "Allowance Assignment Line";
    // begin
    //     ALlowanceAssignmentLineApproved.Reset();
    //     ALlowanceAssignmentLineApproved.SetRange("Employee Code", EmpCode);
    //     ALlowanceAssignmentLineApproved.SetRange("From Date", PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
    //     ALlowanceAssignmentLineApproved.SetRange("Approval Status", ALlowanceAssignmentLineApproved."Approval Status"::Approved);
    //     ALlowanceAssignmentLineApproved.SetRange("Emp Act Type", ALlowanceAssignmentLineApproved."Emp Act Type"::"Allowance Assignment");
    //     ALlowanceAssignmentLineApproved.SetRange("Allowance Claimed", false);
    //     ALlowanceAssignmentLineApproved.SetFilter("Substitute Type", '%1|%2', ALlowanceAssignmentLineApproved."Substitute Type"::" ", ALlowanceAssignmentLineApproved."Substitute Type"::"Added as Substitute");
    //     if ALlowanceAssignmentLineApproved.Count() < 1 then
    //         Error('Approved Allowance not found from %1 to %2 Period', PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
    // end;
    // procedure GetAllowanceClaimLine(AllowanceAssignmentCode: Code[20])
    // var
    //     AllowanceAssignmentHeader: Record "Allowance Assignment Header";
    //     ALlowanceAssignmentLineApproved, AllowanceAssignmentLineClaim, ALlowanceAssignmentLineCheck : Record "Allowance Assignment Line";
    //     Approval: Record "Approval HRMS";
    // begin
    //     AllowanceAssignmentHeader.Get(AllowanceAssignmentCode);
    //     Employee.get(AllowanceAssignmentHeader."Employee No.");
    //     ALlowanceAssignmentLineCheck.Reset;
    //     ALlowanceAssignmentLineCheck.SetRange("No.", AllowanceAssignmentCode);
    //     ALlowanceAssignmentLineCheck.SetRange("Approval Status", ALlowanceAssignmentLineCheck."Approval Status"::Open);
    //     ALlowanceAssignmentLineCheck.DeleteAll(); // Delete existing lines for the record
    //     ALlowanceAssignmentLineApproved.Reset();
    //     ALlowanceAssignmentLineApproved.SetRange("Employee Code", AllowanceAssignmentHeader."Employee No.");
    //     ALlowanceAssignmentLineApproved.SetRange("From Date", AllowanceAssignmentHeader."From Date", AllowanceAssignmentHeader."To date");
    //     ALlowanceAssignmentLineApproved.SetRange("Approval Status", ALlowanceAssignmentLineApproved."Approval Status"::Approved);
    //     ALlowanceAssignmentLineApproved.SetRange("Allowance Claimed", false);
    //     ALlowanceAssignmentLineApproved.SetRange("Emp Act Type", ALlowanceAssignmentLineApproved."Emp Act Type"::"Allowance Assignment");
    //     ALlowanceAssignmentLineApproved.SetFilter("Substitute Type", '%1|%2', ALlowanceAssignmentLineApproved."Substitute Type"::" ", ALlowanceAssignmentLineApproved."Substitute Type"::"Added as Substitute");
    //     if ALlowanceAssignmentLineApproved.FindSet() then
    //         repeat
    //             AllowanceAssignmentLineClaim.Init();
    //             AllowanceAssignmentLineClaim."No." := AllowanceAssignmentCode;
    //             AllowanceAssignmentLineClaim."Line No." := 0;
    //             AllowanceAssignmentLineClaim."Allowance Claim From" := ALlowanceAssignmentLineApproved."No.";
    //             AllowanceAssignmentLineClaim."Allowance Claim from Line No" := ALlowanceAssignmentLineApproved."Line No.";
    //             AllowanceAssignmentLineClaim."Employee Code" := ALlowanceAssignmentLineApproved."Employee Code";
    //             AllowanceAssignmentLineClaim."Employee Name" := ALlowanceAssignmentLineApproved."Employee Name";
    //             AllowanceAssignmentLineClaim.Type := AllowanceAssignmentHeader.Type;
    //             AllowanceAssignmentLineClaim.Code := AllowanceAssignmentHeader.Code;
    //             AllowanceAssignmentLineClaim.Name := AllowanceAssignmentHeader.Name;
    //             AllowanceAssignmentLineClaim."Emp Act Type" := ALlowanceAssignmentLineApproved."Emp Act Type"::"Allowance Assignment Claim";
    //             AllowanceAssignmentLineClaim."Allowance Type" := ALlowanceAssignmentLineApproved."Allowance Type";
    //             AllowanceAssignmentLineClaim.Panel := ALlowanceAssignmentLineApproved.Panel;
    //             AllowanceAssignmentLineClaim."From Date" := ALlowanceAssignmentLineApproved."From Date";
    //             AllowanceAssignmentLineClaim."Approval Status" := ALlowanceAssignmentLineApproved."Approval Status"::Open;
    //             AllowanceAssignmentLineClaim."Substitute Type" := ALlowanceAssignmentLineApproved."Substitute Type";
    //             AllowanceAssignmentLineClaim."Allowance Amount" := ALlowanceAssignmentLineApproved."Allowance Amount";
    //             AllowanceAssignmentLineClaim.Insert(true);
    //         until ALlowanceAssignmentLineApproved.Next() = 0;
    // end;
    procedure OpenAllowance(EmpCode: Code[20])
    var
        AllowanceAssignment, AllowanceAssignment2 : Record "Allowance Assignment Header";
        Approval: Record "Approval HRMS";
    begin
        Clear(Employee);
        PGSetup.Get();
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Request Allowance");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        Employee.Get(EmpCode);
        AllowanceAssignment.Reset();
        AllowanceAssignment.SetRange("Employee No.", EmpCode);
        AllowanceAssignment.SetRange("Activity Type", AllowanceAssignment."Activity Type"::"Request Allowance");
        AllowanceAssignment.SetRange("Approval Status", AllowanceAssignment."Approval Status"::open);
        if AllowanceAssignment.Findfirst() then begin
            If GuiAllowed then begin
                Message('This Employee Already has open Allowance Claim Request .Click Ok to Open');
                PAGE.Run(PAGE::"Request Allowance Card", AllowanceAssignment)
            end
        end else begin
            AllowanceAssignment2.Init;
            AllowanceAssignment2.Validate("Employee No.", EmpCode);
            AllowanceAssignment2.Validate("Activity Type", AllowanceAssignment2."Activity Type"::"Request Allowance");
            AllowanceAssignment2.Validate("From Date", PGSetup."Payroll Fiscal Year Start Date");
            AllowanceAssignment2.Validate("To date", PGSetup."Payroll Fiscal Year end Date");
            AllowanceAssignment2.Validate("Approval Status", AllowanceAssignment2."Approval Status"::Open);
            AllowanceAssignment2.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"request allowance Card", AllowanceAssignment2);
        end;
    end;

    procedure CheckMaximumEmployeeInBranch(AllowanceLineRec: Record "Allowance Assignment Line")
    var
        AllowanceLine: Record "Allowance Assignment Line";
        BranchWiseAllowance: Record "BranchWise/Extension Allowance";
        TEXT002: Label 'Total No. of Employees in %1 in %2 exceeds %3.';
        AllowanceCount: Integer;
    begin
        AllowanceLine.Reset;
        AllowanceLine.SetRange(Type, AllowanceLineRec.Type);
        AllowanceLine.SetRange("Allowance Type", AllowanceLineRec."Allowance Type");
        AllowanceLine.SetRange(Code, AllowanceLineRec.Code);
        AllowanceLine.SetRange("From Date", AllowanceLineRec."From Date");
        AllowanceLine.Setfilter("Substitute Type", '%1|%2', AllowanceLine."Substitute Type"::" ", AllowanceLine."Substitute Type"::"Added as Substitute");
        AllowanceLine.SetFilter("Approval Status", '%1|%2', AllowanceLine."Approval Status"::Pending, AllowanceLine."Approval Status"::Approved);
        AllowanceCount := AllowanceLine.count();
        if BranchWiseAllowance.Get(AllowanceLineRec.Type, AllowanceLineRec.Code, AllowanceLineRec."Allowance Type") then
            if BranchWiseAllowance."Max. No. of Staffs" <> 0 then
                if AllowanceCount >= BranchWiseAllowance."Max. No. of Staffs" then
                    Error(TEXT002, AllowanceLineRec.Name, AllowanceLineRec."Allowance Type",
                            BranchWiseAllowance.FieldCaption("Max. No. of Staffs"));
    end;

    procedure CheckDate(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        AllowanceHeader: Record "Allowance Assignment Header";
    begin
        AllowanceHeader.Get(AllowanceAssignmentLine."No.");
        AllowanceHeader.TestField("From Date");
        AllowanceHeader.TestField("To date");
        if AllowanceAssignmentLine."From Date" <> 0D then
            if (AllowanceAssignmentLine."From Date" < AllowanceHeader."From Date") or (AllowanceAssignmentLine."From Date" > AllowanceHeader."To date") then
                Error('Date is not within period.');

        if AllowanceAssignmentLine."To Date" <> 0D then
            if AllowanceAssignmentLine."To Date" > AllowanceHeader."To date" then
                Error('Date is not within period.');
        // CalculateNoOfDays(Rec);
    end;

    procedure ValidateAllowanceType(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        AttendanceMgt: Codeunit "Attendance Mgt";
        PGSetup: Record "Payroll General Setup";
    begin
        AllowanceAssignmentLine.TestField("Allowance Type");
        PGSetup.Get();
        case AllowanceAssignmentLine."Allowance Type" of
            PGSetup."Dashain Allowance":
                begin
                    if not HrMgt.IsDashinTihar(AllowanceAssignmentLine."From Date") then
                        Error('Selected date is not Dashain Tihar.');
                    if not AttendanceMgt.CheckEmployeePresent(AllowanceAssignmentLine."Employee Code", AllowanceAssignmentLine."From Date") then
                        Error('Attendance Not Found On %1', AllowanceAssignmentLine."From Date");
                end;
        end;
    end;

    procedure CheckMutuallyExclusive(AllowanceAssignmentLineRec: Record "Allowance Assignment Line")
    var
        PayrollAttribute: Record "Payroll Attributes";
        PayrollAttribute1: Record "Payroll Attributes";
        AllowanceLine: Record "Allowance Assignment Line";
        TEXT001: Label '%1 and %2 cannot be assigned on same date %3.';
    begin
        //if one mutual exclusive allowance is already selected, no other mutually exclusive allowance is allowed.
        AllowanceLine.Reset;
        AllowanceLine.SetRange("No.", AllowanceAssignmentLineRec."No.");
        AllowanceLine.SetFilter("Line No.", '<>%1', AllowanceAssignmentLineRec."Line No.");
        AllowanceLine.SetFilter("From Date", '<=%1', AllowanceAssignmentLineRec."From Date");
        AllowanceLine.SetFilter("To Date", '>=%1', AllowanceAssignmentLineRec."From Date");
        AllowanceLine.SetFilter("Allowance Type", '<>%1', AllowanceAssignmentLineRec."Allowance Type");
        AllowanceLine.SetRange(Type, AllowanceAssignmentLineRec.Type);
        if AllowanceLine.FindFirst then
            repeat
                PayrollAttribute.Get(AllowanceAssignmentLineRec."Allowance Type");
                if PayrollAttribute."Mutually Exclusive" then begin
                    PayrollAttribute1.Get(AllowanceLine."Allowance Type");
                    if PayrollAttribute1."Mutually Exclusive" then
                        Error(TEXT001, AllowanceLine."Allowance Type", AllowanceAssignmentLineRec."Allowance Type", AllowanceLine."From Date");
                end;
            until AllowanceLine.Next = 0;
    end;

    procedure CheckCutOffDate(FromDate: Date; ToDate: Date; Month: Enum "Nepali Month")
    begin
        PGSetup.Get();
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetRange("Pay Cycle Code", PGSetup."Pay Cycle Code");
        PayCyclePeriod.SetRange("Pay Cycle Term", PGSetup."Pay Cycle Term");
        PayCyclePeriod.SetRange("Nepali Month", Month);
        if PayCyclePeriod.FindFirst() then begin
            PayCyclePeriod.TestField("Allowance Start Date");
            PayCyclePeriod.TestField("Allowance End Date");
            if (ToDate > PayCyclePeriod."Allowance End Date") then
                Error('Allowance claim End Date cannot be After %1', PayCyclePeriod."Allowance End Date");
        end;
    end;


    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        SalaryLevel: Record "Salary Level";
        PGSetup: Record "Payroll General Setup";
        LevelWiseAttribute: Record "Level Wise Attributes";
        HrMgt: Codeunit "HR Mgt.";
        AttendanceMgt: Codeunit "Attendance Mgt";
        PayCyclePeriod: Record "Pay Cycle Period";

    [IntegrationEvent(false, false)]
    procedure AllowanceAssignmentApprovalReject(Var Approved: Boolean; var EntryNo: Code[20]; var IsHandeled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeOpenAllowanceAssignmentClaim(EmployeeNo: Code[20])
    begin
    end;

}
