report 50000 "Validate Travel Claim"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Employee No."; EmpCode)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmpCode field.';
                    ApplicationArea = All;
                }
                field("Leave Code"; LeaveCode)
                {
                    TableRelation = "Leave Type Setup";
                    ToolTip = 'Specifies the value of the LeaveCode field.';
                    ApplicationArea = All;
                }
                field("Balance Leave Days"; BalanceLeaveDays)
                {
                    ToolTip = 'Specifies the value of the BalanceLeaveDays field.';
                    ApplicationArea = All;
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
        //ValidateTravelClaim
        //ValidateEmployeeEmail;
        //ValidateBranch;
        //ValidateDetailedLedgeer;
        //ValidateDeputation;
        //DeleteTempTransferAttachment;
        //GetEmployeeFromEmployeeId;
        //ValdiateAllowanceLineCode;
        InsertAllowanceHeader;
        //ValidateRiskAllowanceAmt;
        //CollpasedLeaveBalance;
        //ValidateFiscalYear;
    end;

    var
        EmpAct: Record "Employee Activity";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        Branchall: Record "Branchwise/Extension Allowance";
        AllowanceHeader: Record "Allowance Assignment Header";
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        WeekVar: Option " ","Week 1","Week 2","Week 3","Week 4";
        Month: Enum "English Month";
        Year: Integer;
        // EmpHie: Record "Employee Hierarchy Master";
        OrganizationStructureList: Record "Organization Structure List";
        EntryNo: Integer;
        PGSetup: Record "Payroll General Setup";
        AllowanceLine: Record "Allowance Assignment Line";
        LeaveEarn: Record "Leave Earn";
        EmpCode: Code[20];
        LeaveCode: Code[20];
        BalanceLeaveDays: Decimal;
        LoanMgt: Codeunit "Loan Mgt.";

    local procedure ValidateTravelClaim()
    begin
        EmpAct.Reset;
        EmpAct.SetRange(Type, EmpAct.Type::"Travel Claim");
        //EmpAct.SETRANGE("No.",'TRACLAIM76_77-00009');
        if EmpAct.Find('-') then
            repeat
                EmpAct.Validate("Out of Pocket Expense", TravelMgt.GetOutOfExpenseDuration(EmpAct."Depature Time", EmpAct."Arrival Time", EmpAct."Start Date", EmpAct."End Date"));
                /*EmpAct2.GET(EmpAct."Travel Order No.");
                Employee.GET(EmpAct2."Employee No.");

                SalaryLevel.GET(Employee."Salary Level");
                IF EmpAct2."Travel With" <> '' THEN BEGIN//AT
                  Employee1.GET(EmpAct2."Travel With");
                  SalaryLevel1.GET(Employee1."Salary Level");
                END;
                EmpAct.VALIDATE("Travel With",EmpAct2."Travel With");
                EmpAct.VALIDATE("Total Estimated Cost",HRMgt.CalculateTotalEstimatedCost(EmpAct2."No."));
                EmpAct.VALIDATE("Total Claimed Amount");
                EmpAct.VALIDATE("Estimated Conveyance Expense",HRMgt.CalculateTotalEstimatedConv(EmpAct2."No."));
                EmpAct.VALIDATE("Estimated Fooding Cost",HRMgt.CalculateTotalFooding(EmpAct2."No."));
                EmpAct.VALIDATE("Estimated Lodging Cost",HRMgt.CalculateTotalLodging(EmpAct2."No."));
                EmpAct.VALIDATE("Estimated Transportation Cost",HRMgt.CalculateTotalTransport(EmpAct2."No."));
                EmpAct.VALIDATE("Other Estimated Cost",HRMgt.CalculateTotalOtherExpense(EmpAct2."No."));

                EmpAct.VALIDATE("Type Of Visit",EmpAct2."Type Of Visit");
                EmpAct.VALIDATE("Mode Of Travel",EmpAct2."Mode Of Travel");
                EmpAct.VALIDATE(Destination,EmpAct2.Destination);
                EmpAct.VALIDATE(Description,EmpAct2.Description);
                EmpAct.VALIDATE("Depature From",EmpAct2."Depature From");
                IF EmpAct."Travel Countries" = EmpAct."Travel Countries"::Nepal THEN BEGIN
                  IF SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" THEN BEGIN//AT
                    EmpAct.VALIDATE("Fooding Allowance Limit",SalaryLevel1."Nepal Fooding Allowance" * EmpAct."No. of Days");
                    EmpAct.VALIDATE("Fooding Per Day Limit",SalaryLevel1."Nepal Fooding Allowance");
                  END ELSE BEGIN
                    EmpAct.VALIDATE("Fooding Allowance Limit",SalaryLevel."Nepal Fooding Allowance"*EmpAct."No. of Days");
                    EmpAct.VALIDATE("Fooding Per Day Limit",SalaryLevel."Nepal Fooding Allowance");
                  END;
                  IF SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" THEN BEGIN//AT
                    EmpAct.VALIDATE("Lodging Allowance Limit",SalaryLevel1."Nepal Lodging Allowance"* (EmpAct."No. of Days"-1));
                    EmpAct.VALIDATE("Lodging Per Day Limit",SalaryLevel1."Nepal Lodging Allowance");
                  END ELSE BEGIN
                    EmpAct.VALIDATE("Lodging Allowance Limit",SalaryLevel."Nepal Lodging Allowance"* (EmpAct."No. of Days"-1));
                    EmpAct.VALIDATE("Lodging Per Day Limit",SalaryLevel."Nepal Lodging Allowance");
                  END;
                END
                ELSE IF EmpAct."Travel Countries" = EmpAct."Travel Countries"::India THEN BEGIN
                  IF SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" THEN BEGIN//AT
                    EmpAct.VALIDATE("Fooding Allowance Limit",SalaryLevel1."India Fooding Allowance"*EmpAct."No. of Days");
                    EmpAct.VALIDATE("Fooding Per Day Limit",SalaryLevel1."India Fooding Allowance");

                  END ELSE BEGIN
                    EmpAct.VALIDATE("Fooding Allowance Limit",SalaryLevel."India Fooding Allowance"*EmpAct."No. of Days");
                    EmpAct.VALIDATE("Fooding Per Day Limit",SalaryLevel."India Fooding Allowance");
                  END;
                  IF SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" THEN BEGIN//AT
                    EmpAct.VALIDATE("Lodging Allowance Limit",SalaryLevel1."India Lodging Allowance"* (EmpAct."No. of Days"-1));
                    EmpAct.VALIDATE("Lodging Per Day Limit",SalaryLevel1."India Lodging Allowance");

                  END ELSE BEGIN
                    EmpAct.VALIDATE("Lodging Allowance Limit",SalaryLevel."India Lodging Allowance"* (EmpAct."No. of Days"-1));
                    EmpAct.VALIDATE("Lodging Per Day Limit",SalaryLevel."India Lodging Allowance");
                  END;
                END;
              */
                EmpAct.Modify;
            until EmpAct.Next = 0;
    end;

    local procedure ValidateEmployeeEmail()
    begin
        Employee.Reset;
        Employee.ModifyAll("Company E-Mail", 'hrms@nicasiabank.com');
    end;

    local procedure ValidateBranch()
    begin
        Clear(Branchall);
        if Branchall.Find('-') then
            repeat
                Branchall.Rename(Branchall.Type::Branch, Branchall.Code, Branchall."Allowance Type");
            until Branchall.Next = 0;
    end;

    local procedure ValidateDetailedLedgeer()
    var
        DetailedLedgerEntry: Record "Detailed Employee Ledger Entry";
        PayrollAttribtes: Record "Payroll Attributes";
        EngNep: Record "English-Nepali Date";
    begin
        DetailedLedgerEntry.Reset;
        if DetailedLedgerEntry.Find('-') then
            repeat
                Clear(EngNep);
                EngNep.SetRange("English Date", DetailedLedgerEntry."Pay Period Start Date");
                if EngNep.FindFirst then;
                Employee.Get(DetailedLedgerEntry."Employee No.");
                PayrollAttribtes.Get(DetailedLedgerEntry."Payroll Attribute Code");
                if PayrollAttribtes.Type in [PayrollAttribtes.Type::Benefits, PayrollAttribtes.Type::"Non-Payment"] then begin
                    if Employee."Deputation on" in [Employee."Deputation on"::"Province"] then
                        DetailedLedgerEntry.Validate("Finacle GL No", Employee."Sol Id" + PayrollAttribtes."GL Code for Region")
                    else
                        DetailedLedgerEntry.Validate("Finacle GL No", Employee."Sol Id" + PayrollAttribtes."GL Code For Branch");
                end else begin
                    DetailedLedgerEntry.Validate("Finacle GL No", PayrollAttribtes."GL Code For Branch");
                end;
                if PayrollAttribtes."Finacle GL Name" <> '' then
                    DetailedLedgerEntry.Validate("Finacle GL Name", StrSubstNo('%1 %2-%3', PayrollAttribtes."Finacle GL Name", EngNep."Nepali Year", EngNep."Nepali Month"))
                else
                    DetailedLedgerEntry.Validate("Finacle GL Name", ' ');
                DetailedLedgerEntry.Modify;
            until DetailedLedgerEntry.Next = 0;
    end;

    local procedure ValidateDeputation()
    begin
        Employee.Reset;
        if Employee.Find('-') then
            repeat
                //  Employee.ValidateSolID;
                case Employee."Deputation on" of
                    Employee."Deputation on"::Branch:
                        Employee.Validate("Global Dimension 1 Code");
                    Employee."Deputation on"::Department:
                        Employee.Validate("Department Code");
                    Employee."Deputation on"::"Extension Counter":
                        Employee.Validate("Extension Counter Code");
                    Employee."Deputation on"::Province:
                        Employee.Validate("Province Code");
                    // Employee."Deputation on"::"Sub Province":
                    //     Employee.Validate("Sub Province Code");
                    Employee."Deputation on"::Unit:
                        Employee.Validate("Unit Code");
                end;
                Employee.Modify;
            until Employee.Next = 0;
    end;

    local procedure DeleteTempTransferAttachment()
    var
        IncomingDoc: Record "Incoming Document";
    begin
        EmpAct.Reset;
        EmpAct.SetRange(Type, EmpAct.Type::"HR Transfer");
        EmpAct.SetRange("Transfer Category", EmpAct."Transfer Category"::"Temporary");
        if EmpAct.Find('-') then
            repeat
                IncomingDoc.Reset;
                IncomingDoc.SetRange("No.", EmpAct."No.");
                IncomingDoc.SetRange("Table ID", Database::"Employee Activity");
                IncomingDoc.DeleteAll;
            until EmpAct.Next = 0;
    end;

    local procedure GetEmployeeFromEmployeeId()
    var
        NotifyToEmail: Text;
        NotifyToEmpId: Text;
    begin
        EmpAct.Reset;
        EmpAct.SetFilter(Type, '%1|%2', EmpAct.Type::"HR Transfer", EmpAct.Type::"Employee Transfer");
        EmpAct.SetFilter("Notify to", '<>%1', '');
        if EmpAct.Find('-') then
            repeat
                NotifyToEmail := EmpAct."Notify to";
                NotifyToEmail := ConvertStr(NotifyToEmail, ';', '|');
                Clear(Employee);
                Clear(NotifyToEmpId);
                Employee.SetFilter("Company E-Mail", NotifyToEmail);
                if Employee.Find('-') then
                    repeat
                        if NotifyToEmpId = '' then
                            NotifyToEmpId := Employee."No."
                        else
                            NotifyToEmpId += '|' + Employee."No.";
                    until Employee.Next = 0;
                EmpAct.Validate("Notify to", NotifyToEmpId);
                EmpAct.Modify;
            until EmpAct.Next = 0;
    end;

    local procedure ValdiateAllowanceLineCode()
    var
        AllowanceLine: Record "Allowance Assignment Line";
    begin
        AllowanceLine.Reset;
        if AllowanceLine.Find('-') then
            repeat
                AllowanceLine.Validate(Code);
                AllowanceLine.Modify;
            until AllowanceLine.Next = 0;
    end;

    procedure InsertAllowanceHeader()
    begin
        if WeekVar = WeekVar::" " then
            Error('Please fill week');
        if Month = Month::" " then
            Error('Please fill month');
        if Year = 0 then
            Error('Please fill year');

        AllowanceHeader.Reset;
        AllowanceHeader.SetCurrentKey("Entry No.");
        if AllowanceHeader.FindLast then
            EntryNo := AllowanceHeader."Entry No." + 1
        else
            EntryNo := 1;
        GLSetup.Get;
        DimValue.Reset;
        DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
        if DimValue.Find('-') then
            repeat

                AllowanceHeader.Reset;
                AllowanceHeader.SetRange(Type, AllowanceHeader.Type::Branch);
                AllowanceHeader.SetRange(Code, DimValue.Code);
                AllowanceHeader.SetRange(Week, WeekVar);
                AllowanceHeader.SetRange("English Month", Month);
                AllowanceHeader.SetRange("English Year", Year);
                if not AllowanceHeader.FindFirst then begin
                    AllowanceHeader.Init;
                    AllowanceHeader.Validate("Entry No.", EntryNo);
                    AllowanceHeader.Validate(Type, AllowanceHeader.Type::Branch);
                    AllowanceHeader.Validate(Code, DimValue.Code);
                    AllowanceHeader.Validate("English Year", Year);
                    AllowanceHeader.Validate("English Month", Month);
                    AllowanceHeader.Validate(Week, WeekVar);
                    AllowanceHeader.Insert(true);
                    EntryNo := EntryNo + 1;
                end;
            until DimValue.Next = 0;

        OrganizationStructureList.Reset;
        OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::"Extension Counter");
        if OrganizationStructureList.Find('-') then
            repeat

                AllowanceHeader.Reset;
                AllowanceHeader.SetRange(Type, AllowanceHeader.Type::"Extension Counter");
                AllowanceHeader.SetRange(Code, OrganizationStructureList.Code);
                AllowanceHeader.SetRange(Week, WeekVar);
                AllowanceHeader.SetRange("English Month", Month);
                AllowanceHeader.SetRange("English Year", Year);
                if not AllowanceHeader.FindFirst then begin
                    AllowanceHeader.Init;
                    AllowanceHeader.Validate("Entry No.", EntryNo);
                    AllowanceHeader.Validate(Type, AllowanceHeader.Type::"Extension Counter");
                    AllowanceHeader.Validate(Code, OrganizationStructureList.Code);
                    AllowanceHeader.Validate("English Year", Year);
                    AllowanceHeader.Validate("English Month", Month);
                    AllowanceHeader.Validate(Week, WeekVar);
                    EntryNo := EntryNo + 1;
                    AllowanceHeader.Insert(true)
                end;
            until OrganizationStructureList.Next = 0;
    end;

    local procedure ValidateRiskAllowanceAmt()
    begin
        PGSetup.Get;
        AllowanceLine.Reset;
        if AllowanceLine.Find('-') then
            repeat
                AllowanceLine.Validate("Allowance Amount",
                Round(LoanMgt.SetAllowanceAmount(AllowanceLine."Employee Code", AllowanceLine."Allowance Type", AllowanceLine."From Date"), 0.01, '='));
                AllowanceLine.Modify;
            until AllowanceLine.Next = 0;
        /*AllowanceLine.SETRANGE("Allowance Type",PGSetup."Risk Allowance");
        IF AllowanceLine.FIND('-') THEN REPEAT
          Employee.GET(AllowanceLine."Employee Code");
          PayCyclePeriod.RESET;
          PayCyclePeriod.SETFILTER("Allowance Start Date",'<=%1',AllowanceLine."From Date");
          PayCyclePeriod.SETFILTER("Allowance End Date",'>=%1',AllowanceLine."From Date");
          IF Employee."Employment Type" <> Employee."Employment Type"::Contract THEN BEGIN
            LevelwiseAttribute.RESET;
            IF LevelwiseAttribute.GET(Employee."Salary Grade",Employee."Salary Level") THEN;
            IF PayCyclePeriod.FINDFIRST THEN
              AllowanceLine.VALIDATE("Allowance Amount",PGSetup."Cash Risk Percent"/100*LevelwiseAttribute."Total Basic Salary"/(PayCyclePeriod."Allowance End Date" -PayCyclePeriod."Allowance Start Date" +1));
          END ELSE BEGIN
            IF PayCyclePeriod.FINDFIRST THEN
              AllowanceLine.VALIDATE("Allowance Amount",PGSetup."Cash Risk Percent"/100*Employee."Contract Salary Amount"/(PayCyclePeriod."Allowance End Date" -PayCyclePeriod."Allowance Start Date" +1));
          END;
          AllowanceLine.MODIFY;
        UNTIL AllowanceLine.NEXT =0;
        */
    end;

    local procedure CollpasedLeaveBalance()
    begin
        LeaveEarn.Reset;
        LeaveEarn.Init;
        LeaveEarn.Validate("Leave Code", LeaveCode);
        LeaveEarn.Validate(EmpNo, EmpCode);
        LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(Today));
        LeaveEarn.Validate("Posted Date", Today);
        LeaveEarn.Validate("Balancing Days", -Abs(BalanceLeaveDays));
        LeaveEarn.Validate(Remarks, 'Leave Collapsed.');
        LeaveEarn.Validate(Type, LeaveEarn.Type::Collapsed);
        LeaveEarn.Insert(true);
    end;

    local procedure ValidateFiscalYear()
    var
        GLEntry: Record "G/L Entry";
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry";
        EmpLedgerEntry: Record "Employee Ledger Entry";
    begin
        GLEntry.Reset;
        GLEntry.ModifyAll("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
        EmpLedgerEntry.Reset;
        EmpLedgerEntry.ModifyAll("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.ModifyAll("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
    end;
}
