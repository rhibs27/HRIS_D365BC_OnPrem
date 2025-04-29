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

    procedure SendApprovalAllowanceAssignment(var AllowanceAssignment: Record "Allowance Assignment Header"; var AllowanceLine: Record "Allowance Assignment Line"; ApproveBool: Boolean)
    var
        Confirmation: Label 'Confirm action?';
        AllowanceLineCheck: Record "Allowance Assignment Line";
    begin
        if not Confirm(Confirmation, false) then
            exit;
        // if AllowanceAssignment."Approver ID" = '' then
        //     Error('Please select an approver.');

        AllowanceLineCheck.Copy(AllowanceLine);
        if AllowanceLineCheck.FindFirst then
            repeat
                AllowanceLineCheck.TestField("Employee Code");
                AllowanceLineCheck.TestField("From Date");
                AllowanceLineCheck.TestField("To Date");
                AllowanceLineCheck.TestField("Allowance Type");

            until AllowanceLineCheck.Next = 0;

        if ApproveBool then begin
            AllowanceAssignment.Validate("Approval Status", AllowanceAssignment."Approval Status"::"Pending");
            AllowanceAssignment.Modify(true);

            AllowanceLine.SetFilter("Approval Status", '<>%1', AllowanceLine."Approval Status"::Approved);
            AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::Screened);
        end else begin
            AllowanceAssignment.Validate("Approval Status", AllowanceAssignment."Approval Status"::Open);
            AllowanceAssignment.Modify(true);

            //AllowanceLine.SETFILTER("Approval Status", '<>%1', AllowanceLine."Approval Status"::Released);
            AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::"Pending Approval");


        end;
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
        // PGSetup.Get;
        EmpAllowance.Get(EntryNo);
        // // EmpAllowance.TestField("Approval Status", EmpAllowance."Approval Status"::"Pending");
        // if CalcDate('<CM>', EmpAllowance."To date") + PGSetup."Approval Grace Period" < Today then
        //     Error('Approval for allowance assignment has exceeded.Please contact corresponding Department.');
        // AllowanceLine.Reset;
        // AllowanceLine.SetRange("No.", EntryNo);
        // AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::Open);
        // if AllowanceLine.FindFirst then
        //     Error('This document has an open record.Please advise your staff to delete the open records.');
        // Employee.GET(GetEmployeeCode());
        // EmpRec.GET(EmpAllowance."Approver ID");
        // PGSetup.GET;
        // PGSetup.TESTFIELD("BM Functional Title");
        // if GetEmployeeCode() <> EmpAllowance."Approver ID" then
        //     Error('You are not eligible to approve or reject this doucment', EmpRec."Full Name");

        // if Approved then
        //     EmpAllowance.Validate("Approval Status", EmpAllowance."Approval Status"::Approved)
        // else
        //     EmpAllowance.Validate("Approval Status", EmpAllowance."Approval Status"::Rejected);
        // EmpAllowance.Posted := true;
        // // EmpAllowance."Approver ID" := GetEmployeeCode();
        // EmpAllowance."Approved Date" := Today;
        // EmpAllowance.Modify(true);

        AllowanceLine.Reset;
        AllowanceLine.SetRange("No.", EntryNo);
        AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::"Pending Approval");
        if Approved then begin
            AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::Approved);
            AllowanceLine.ModifyAll("Approved Date", Today);
        end else begin
            AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::open);
            ApprovalLine.Reset();
            ApprovalLine.SetRange("Document No.", EntryNo);
            ApprovalLine.DeleteAll(true);
            ApproverMgt.InsertApproval(EmpAllowance."Employee No.", EntryNo, EmpAllowance."Activity Type"::"Allowance Assignment");
        end;

    end;

    // procedure ApproveRejectAllowanceAssignmentAPI(Approved: Boolean; No: Code[20]; EmpNo: Code[20])
    // var
    //     EmpAllowance: Record "Allowance Assignment Header";
    //     PGSetup: Record "Payroll General Setup";
    //     EmpRec: Record Employee;
    //     AllowanceLine: Record "Allowance Assignment Line";
    // begin
    //     // PGSetup.Get;
    //     EmpAllowance.Get(No);
    // EmpAllowance.TestField("Approval Status", EmpAllowance."Approval Status"::"Pending");
    // if CalcDate('<CM>', EmpAllowance."To date") + PGSetup."Approval Grace Period" < Today then
    //     Error('Approval for allowance assignment has exceeded.Please contact corresponding Department.');
    // AllowanceLine.Reset;
    // AllowanceLine.SetRange("No.", No);
    // AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::Open);

    // if AllowanceLine.FindFirst then
    //     Error('This document has an open record.Please advise your staff to delete the open records.');
    //Employee.GET(GetEmployeeCode());
    //EmpRec.GET(EmpAllowance."Approver ID");
    //PGSetup.GET;
    //PGSetup.TESTFIELD("BM Functional Title");
    // if EmpNo <> EmpAllowance."Approver ID" then
    //     Error('You are not eligible to approve or reject this doucment', EmpRec."Full Name");

    // if Approved then
    //     EmpAllowance.Validate("Approval Status", EmpAllowance."Approval Status"::Approved)
    // else
    //     EmpAllowance.Validate("Approval Status", EmpAllowance."Approval Status"::Rejected);
    // EmpAllowance.Posted := true;
    // EmpAllowance."Approver ID" := EmpNo;
    // EmpAllowance."Approved Date" := Today;
    //     EmpAllowance.Modify(true);

    //     AllowanceLine.Reset;
    //     AllowanceLine.SetRange("No.", No);
    //     AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::"Pending Approval");
    //     if Approved then
    //         AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::Approved)
    //     else
    //         AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::Rejected);
    //     // AllowanceLine.ModifyAll("Approved Id", EmpNo);
    //     AllowanceLine.ModifyAll("Approved Date", Today);
    // end;

    procedure ReturnAllowanceAssignment(No: Code[20])
    var
        EmpAllowance: Record "Allowance Assignment Header";
        PGSetup: Record "Payroll General Setup";
        EmpRec: Record Employee;
        AllowanceLine: Record "Allowance Assignment Line";
    begin
        EmpAllowance.Get(No);
        EmpAllowance.TestField("Approval Status", EmpAllowance."Approval Status"::"Pending");


        // if GetEmployeeCode <> EmpAllowance."Approver ID" then
        //     Error("ERROR BM", EmpRec."Full Name");


        EmpAllowance.Posted := true;
        // EmpAllowance."Approver ID" := GetEmployeeCode();
        EmpAllowance."Approved Date" := Today;
        EmpAllowance.Modify(true);

        AllowanceLine.Reset;
        AllowanceLine.SetRange("No.", No);
        AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::"Pending Approval");
        AllowanceLine.ModifyAll("Approval Status", AllowanceLine."Approval Status"::Open);
        // AllowanceLine.ModifyAll("Approved Id", HrMgt.GetEmployeeNo());
        AllowanceLine.ModifyAll("Approved Date", Today);
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

    procedure ScreenAllowanceAssignment(AllowanceAssignmentLine: Record "Allowance Assignment Line"; Screen: Boolean; DateFilter: Text)
    var
        AllowanceHeader: Record "Allowance Assignment Header";
    begin
        if Screen then begin
            if DateFilter = '' then
                Error('Enter Month and Year before screening the documents.');
            AllowanceAssignmentLine.Reset;
            AllowanceAssignmentLine.SetFilter("From Date", DateFilter);
            AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
            if AllowanceAssignmentLine.FindFirst then begin
                repeat
                    AllowanceAssignmentLine.TestField("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
                    AllowanceAssignmentLine."Approval Status" := AllowanceAssignmentLine."Approval Status"::Screened;
                    AllowanceAssignmentLine."Screened By" := UserId;
                    AllowanceAssignmentLine."Screened Date" := CurrentDateTime;
                    AllowanceAssignmentLine.Modify;
                    if AllowanceHeader.Get(AllowanceAssignmentLine."No.") and
                          (AllowanceHeader."Approval Status" <> AllowanceHeader."Approval Status"::Screened) then begin
                        AllowanceHeader."Approval Status" := AllowanceHeader."Approval Status"::Screened;
                        AllowanceHeader.Modify;
                    end;
                until AllowanceAssignmentLine.Next = 0;
            end;
        end else begin
            AllowanceAssignmentLine.TestField("Approval Status", AllowanceAssignmentLine."Approval Status"::Screened);
            AllowanceAssignmentLine."Approval Status" := AllowanceAssignmentLine."Approval Status"::Approved;
            AllowanceAssignmentLine."Screened By" := '';
            AllowanceAssignmentLine."Screened Date" := 0DT;
            AllowanceAssignmentLine.Modify;
        end;
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

    procedure InsertAllowanceAssignmentDays()
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        FromDate: Date;
        Todate: Date;
        PRSetup: Record "Payroll General Setup";
        AllowancePageBuilder: FilterPageBuilder;
        AllowAssignLine: Record "Allowance Assignment Line";
    begin
        PRSetup.Get;

        AllowancePageBuilder.AddRecord('Update to Employee Attendance', AllowAssignLine);
        AllowancePageBuilder.ADdField('Update to Employee Attendance', AllowAssignLine."From Date");
        AllowancePageBuilder.ADdField('Update to Employee Attendance', AllowAssignLine."To Date");
        if AllowancePageBuilder.RunModal then begin
            AllowAssignLine.SetView(AllowancePageBuilder.GetView('Update to Employee Attendance'));
            Evaluate(FromDate, AllowAssignLine.GetFilter("From Date"));
            Evaluate(Todate, AllowAssignLine.GetFilter("To Date"));

            AllowanceAssignmentLine.Reset;
            AllowanceAssignmentLine.SetRange("From Date", FromDate, Todate);
            AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Screened);
            if AllowanceAssignmentLine.FindFirst then
                repeat

                    EmployeeAttendanceActivity.Reset;
                    EmployeeAttendanceActivity.SetRange("Attendance Date", AllowanceAssignmentLine."From Date");
                    EmployeeAttendanceActivity.SetRange("Employee No.", AllowanceAssignmentLine."Employee Code");
                    if EmployeeAttendanceActivity.FindFirst then begin
                        case AllowanceAssignmentLine."Allowance Type" of

                            PRSetup."Evening Counter":
                                EmployeeAttendanceActivity."Evening Counter Days" := 1;

                            PRSetup."Morning Counter":
                                EmployeeAttendanceActivity."Morning Counter Days" := 1;

                            PRSetup."Festival Counter":
                                EmployeeAttendanceActivity."Festival Counter Days" := 1;

                            PRSetup."Holiday Counter":
                                EmployeeAttendanceActivity."Holiday Counter Days" := 1;

                            PRSetup."Friday Counter":
                                EmployeeAttendanceActivity."Friday Counter Days" := 1;

                            PRSetup."Risk Allowance":
                                EmployeeAttendanceActivity."Cash Risk Days" := 1;

                            PRSetup."Vault Key":
                                EmployeeAttendanceActivity."Vault Key Days" := 1;
                        end;
                        EmployeeAttendanceActivity.Modify;
                    end;

                until AllowanceAssignmentLine.Next = 0;
            Message('Update to employee attendance and activity');
        end;
    end;

    procedure InsertAllowanceHeader()
    var
        AllowanceHeader: Record "Allowance Assignment Header";
        AllowanceHeadFilterPage: FilterPageBuilder;
        AllowanceHeaderText: Label 'Allowance Month';
        AllowanceHeader1: Record "Allowance Assignment Header";
        EnglishMonth: Enum "English Month";
        EnglishYear: Integer;
        counter: Integer;
        OrganizationStructureList: Record "Organization Structure List";
    begin
        AllowanceHeadFilterPage.AddTable(AllowanceHeaderText, DATABASE::"Allowance Assignment Header");
        AllowanceHeadFilterPage.ADdField(AllowanceHeaderText, AllowanceHeader."English Month");
        AllowanceHeadFilterPage.ADdField(AllowanceHeaderText, AllowanceHeader."English Year");
        if AllowanceHeadFilterPage.RunModal then begin
            Employee.Reset;
            Employee.SetRange("NAV Login ID", UserId);
            Employee.FindFirst;
            // if not Employee.Screener then
            //     Error('You are not allowed to generate allowance.');
            AllowanceHeader1.SetView(AllowanceHeadFilterPage.GetView(AllowanceHeaderText));
            Evaluate(EnglishMonth, AllowanceHeader1.GetFilter("English Month"));
            Evaluate(EnglishYear, AllowanceHeader1.GetFilter("English Year"));
            if EnglishMonth = EnglishMonth::" " then
                Error('English month must have value.');
            if EnglishYear = 0 then
                Error('English year must have value.');
            GLSetup.Get;
            // branch
            OrganizationStructureList.Reset;

            // DimensionValue.SetRange("Global Dimension No.", 1);
            OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Branch);
            OrganizationStructureList.SetRange(Blocked, false);
            // DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
            if OrganizationStructureList.Find('-') then
                repeat
                    counter := 1;
                    while counter <= 4 do begin
                        //AllowanceHeader.RESET;
                        Clear(AllowanceHeader);
                        AllowanceHeader.SetRange(Week, counter);
                        AllowanceHeader.SetRange(Type, AllowanceHeader.Type::Branch);
                        AllowanceHeader.SetRange(Code, OrganizationStructureList.Code);
                        AllowanceHeader.SetRange("English Month", EnglishMonth);
                        AllowanceHeader.SetRange("English Year", EnglishYear);
                        if not AllowanceHeader.FindFirst then begin
                            AllowanceHeader.Init;
                            AllowanceHeader.Validate(Code, OrganizationStructureList.Code);
                            AllowanceHeader.Validate(Type, AllowanceHeader.Type::Branch);
                            AllowanceHeader.Validate(Name, OrganizationStructureList.Name);
                            AllowanceHeader.Validate("English Year", EnglishYear);
                            AllowanceHeader.Week := counter;
                            AllowanceHeader.Validate("English Month", EnglishMonth);
                            // AllowanceHeader.GetApprover();
                            AllowanceHeader.Validate("Last Modified By", UserId);
                            AllowanceHeader.Validate("Last Modified Date", Today);
                            AllowanceHeader.Insert(true);
                        end;
                        counter += 1;
                    end;
                until OrganizationStructureList.Next = 0;

            OrganizationStructureList.Reset;
            OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::"Extension Counter");
            OrganizationStructureList.SetRange(Blocked, false);
            if OrganizationStructureList.Find('-') then
                repeat
                    counter := 1;
                    while counter <= 4 do begin
                        //AllowanceHeader.RESET;
                        Clear(AllowanceHeader);
                        AllowanceHeader.SetRange(Week, counter);
                        AllowanceHeader.SetRange(Type, AllowanceHeader.Type::"Extension Counter");
                        AllowanceHeader.SetRange(Code, OrganizationStructureList.Code);
                        AllowanceHeader.SetRange("English Month", EnglishMonth);
                        AllowanceHeader.SetRange("English Year", EnglishYear);
                        if not AllowanceHeader.FindFirst then begin
                            AllowanceHeader.Init;
                            AllowanceHeader.Validate(Code, OrganizationStructureList.Code);
                            AllowanceHeader.Validate(Type, AllowanceHeader.Type::"Extension Counter");
                            AllowanceHeader.Validate(Name, OrganizationStructureList.Name);
                            AllowanceHeader.Validate("English Year", EnglishYear);
                            AllowanceHeader.Week := counter;
                            AllowanceHeader.Validate("English Month", EnglishMonth);
                            // AllowanceHeader.GetApprover();
                            AllowanceHeader.Validate("Last Modified By", UserId);
                            AllowanceHeader.Validate("Last Modified Date", Today);
                            AllowanceHeader.Insert(true);
                        end;
                        counter += 1;
                    end;
                until OrganizationStructureList.Next = 0;
            Message('Created.');
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
        Employee.Get(EmpNo);
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
                        //IF LevelwiseAttribute."Level Code" = PGSetup."TA Salary Level" THEN //Min 12.20.2022 -- Commented
                        if SalaryLevel.Code = PGSetup."TA Salary Level" then //Min 12.20.2022
                            exit(Round(PGSetup."Cash Risk Percent" / 100 * SalaryLevel."TA OT Basic Salary" / NoOfDays, 0.00001, '='))
                        //IF PayCyclePeriod.FINDFIRST THEN
                        else
                            exit(Round(PGSetup."Cash Risk Percent" / 100 * LevelwiseAttribute."Total Basic Salary" / NoOfDays, 0.00001, '='));
                    end else begin
                        //IF PayCyclePeriod.FINDFIRST THEN
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
        AllowanceAssignmentLine2: Record "Allowance Assignment Line";
    begin
        Employee.Get(HrMgt.GetEmployeeNo);
        // if not Employee.Screener then
        //     Error('You are not eligible to reject this allowance');
        AllowanceAssignmentPageBuilder.AddRecord('Reject Allowance Assignment', AllowanceAssignmentLine2);
        AllowanceAssignmentPageBuilder.ADdField('Reject Allowance Assignment', AllowanceAssignmentLine2."Rejection Remarks");
        if AllowanceAssignmentPageBuilder.RunModal then begin
            AllowanceAssignmentLine2.SetView(AllowanceAssignmentPageBuilder.GetView('Reject Allowance Assignment'));
            if AllowanceAssignmentLine2.GetFilter("Rejection Remarks") = '' then
                Error('Rejection remarks must have value');
            AllowanceAssignmentLine.TestField("Approval Status", AllowanceAssignmentLine."Approval Status"::Screened);
            AllowanceAssignmentLine.Validate("Rejection Remarks", AllowanceAssignmentLine2.GetFilter("Rejection Remarks"));
            AllowanceAssignmentLine.Validate("Approval Status", AllowanceAssignmentLine."Approval Status"::Rejected);
            AllowanceAssignmentLine.Modify;
            Message('Success');
        end;
    end;


    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        SalaryLevel: Record "Salary Level";
        PGSetup: Record "Payroll General Setup";
        LevelwiseAttribute: Record "Level Wise Attributes";
        EngNep: Record "English-Nepali Date";
        GLSetup: Record "General Ledger Setup";
        HrMgt: Codeunit "HR Mgt.";

}
