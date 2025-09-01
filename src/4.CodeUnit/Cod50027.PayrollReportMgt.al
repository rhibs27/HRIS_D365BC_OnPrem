//This codeunit is used to store payroll calculation for reports
//It contains complex payroll projection calculation without using payroll lines
//Temporary table of Detailed employee ledger entry is used to store the data.
codeunit 50027 "Payroll Report Mgt."
{
    var
        EmployeeFilter: Code[20];
        AttendanceSetupReady: Boolean;
        AttendanceSetup: Record "Attendance Setup";
        PgSetup: record "Payroll General Setup";

    procedure SetEmployeeCode(empCode: Code[20])
    begin
        EmployeeFilter := empCode;
    end;

    procedure getAttributeAmount(EmpCode: Code[20]; PayrollCode: Code[20]): Decimal
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayAttr: Record "Payroll Attributes";
        BasicAmt: Decimal;
        PayrollAttributesUsage1: Record "Payroll Attributes Usage";
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        PayrollAttributesUsage.Get(PayrollCode, EmpCode);
        PayAttr.Get(PayrollCode);
        PayrollAttributesUsage.CalcFields(Type, "Formula Exists", Subtype);
        if not PayrollAttributesUsage."Formula Exists" then begin
            if PayrollAttributesUsage.Type = PayrollAttributesUsage.Type::Benefits then
                exit(PayrollAttributesUsage.Amount);
            if PayrollAttributesUsage.Type = PayrollAttributesUsage.Type::Deduction then
                exit(-PayrollAttributesUsage.Amount);
        end
        else begin
            BasicAmt := 0;
            PayrollAttributesUsage1.Reset;
            PayrollAttributesUsage1.SetRange("Employee Code", EmpCode);
            PayrollAttributesUsage1.SetRange(Subtype, PayrollAttributesUsage1.Subtype::Basic);
            if PayrollAttributesUsage1.FindLast then
                BasicAmt := PayrollAttributesUsage1.Amount;

            // exit(EvaluateAmount(SkipOneTimeAttr(PayAttr.Formula), BasicAmt))
            exit(EvaluateAmount(PayAttr.Formula, BasicAmt))
        end;
    end;

    local procedure getTotalTaxPaid(PPline: Record "Posted Payroll Line"): Decimal
    var
        PgSetup: Record "Payroll General Setup";
        Employee: Record Employee;
    begin
        PgSetup.Get;
        Employee.Reset;
        Employee.SetRange("No.", PPline."Employee No.");
        Employee.SetFilter("Date Filter", '%1..%2', PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        Employee.FindFirst;
        Employee.CalcFields("Social Security Tax", "Remuneration & Benefits Tax");

        exit(Employee."Social Security Tax" + Employee."Remuneration & Benefits Tax");
    end;

    local procedure getTotalSSTPaid(PPline: Record "Posted Payroll Line"): Decimal
    var
        PgSetup: Record "Payroll General Setup";
        Employee: Record Employee;
    begin
        PgSetup.Get;
        Employee.Reset;
        Employee.SetRange("No.", PPline."Employee No.");
        Employee.SetFilter("Date Filter", '%1..%2', PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        Employee.FindFirst;
        Employee.CalcFields("Social Security Tax");
        exit(Employee."Social Security Tax");
    end;

    local procedure EvaluateAmount(Expression: Code[100]; BasicAmt: Decimal): Decimal
    var
        OperatorStack: array[100] of Code[20];
        NumberStack: array[100] of Decimal;
        DecNumber: Decimal;
        ContiguousNumber: Boolean;
        CurrExpr: Code[100];
        Counter: Integer;
        Num1: Decimal;
        Num2: Decimal;
        operator: Code[10];
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;
    begin
        ResolveColumn(Expression, BasicAmt);
        Expression := DelChr(Expression, '=', ',');
        Counter := 0;
        ExNo := StrLen(Expression);
        OsNo := 0;
        NsNo := 0;
        repeat
            Counter += 1;
            if Expression[Counter] = '(' then begin
                OsNo += 1;
                OperatorStack[OsNo] := Format(Expression[Counter]);
            end else
                if Expression[Counter] = ')' then begin
                    if OsNo <> 0 then
                        while (OperatorStack[OsNo] <> '(') and (OsNo <> 0) do begin
                            Num2 := NumberStack[NsNo];
                            NumberStack[NsNo] := 0;
                            NsNo -= 1;
                            Num1 := NumberStack[NsNo];
                            NumberStack[NsNo] := 0;
                            NsNo -= 1;
                            operator := OperatorStack[OsNo];
                            OperatorStack[OsNo] := '';
                            OsNo -= 1;
                            NsNo += 1;
                            NumberStack[NsNo] := CalculateValue(Num1, Num2, operator);
                            if OsNo = 0 then
                                break;
                        end;
                    if (OsNo <> 0) then begin
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                    end;
                end
                else
                    if Expression[Counter] in ['+', '-', '*', '/'] then begin
                        if OsNo <> 0 then
                            while (OsNo <> 0) and (CheckPrecedence(OperatorStack[OsNo]) >= CheckPrecedence(Format(Expression[Counter]))) do begin
                                Num2 := NumberStack[NsNo];
                                NumberStack[NsNo] := 0;
                                NsNo -= 1;
                                Num1 := NumberStack[NsNo];
                                NumberStack[NsNo] := 0;
                                NsNo -= 1;
                                operator := OperatorStack[OsNo];
                                OperatorStack[OsNo] := '';
                                OsNo -= 1;
                                NsNo += 1;
                                NumberStack[NsNo] := CalculateValue(Num1, Num2, operator);
                                if OsNo = 0 then
                                    break;
                            end;
                        OsNo += 1;
                        OperatorStack[OsNo] := Format(Expression[Counter]);
                    end else begin
                        CurrExpr := '';
                        repeat
                            ContiguousNumber := false;
                            if Expression[Counter] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'] then
                                CurrExpr := CurrExpr + Format(Expression[Counter]);
                            if Counter < ExNo then
                                if Evaluate(DecNumber, Format(Expression[Counter + 1])) or (Expression[Counter + 1] = '.') then begin
                                    ContiguousNumber := true;
                                    Counter += 1;
                                end;
                        until not ContiguousNumber;
                        Evaluate(DecNumber, CurrExpr);
                        NsNo += 1;
                        NumberStack[NsNo] := DecNumber;
                    end;
        until Counter = ExNo;

        while (OsNo <> 0) do begin
            Num2 := NumberStack[NsNo];
            NumberStack[NsNo] := 0;
            NsNo -= 1;
            Num1 := NumberStack[NsNo];
            NumberStack[NsNo] := 0;
            NsNo -= 1;
            operator := OperatorStack[OsNo];
            OperatorStack[OsNo] := '';
            OsNo -= 1;
            NsNo += 1;
            NumberStack[NsNo] := CalculateValue(Num1, Num2, operator);
        end;
        exit(NumberStack[NsNo]);
    end;

    local procedure CalculateValue(Number1: Decimal; Number2: Decimal; Opt: Code[10]): Decimal
    begin
        case Opt of
            '*':
                exit(Number1 * Number2);
            '/':
                exit(Number1 / Number2);
            '+':
                exit(Number1 + Number2);
            '-':
                exit(Number1 - Number2);
        end;
    end;

    local procedure CheckPrecedence(Opt: Code[10]): Integer
    begin
        if (Opt = '*') or (Opt = '/') then
            exit(2);
        if (Opt = '+') or (Opt = '-') then
            exit(1);
        exit(0);
    end;

    procedure ResolveColumn(var Expression: Code[100]; BasicAmt: Decimal)
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributes: Record "Payroll Attributes";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BasicAmount: Decimal;
    begin
        Expression := DelChr(Expression, '=');
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Benefits);
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Basic);
        PayrollAttributes.FindFirst;

        BasicAmount := BasicAmt;
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
        PayrollAttributesUsage.SetRange("Employee Code", EmployeeFilter);
        if PayrollAttributesUsage.FindFirst then
            //PayrollAttributesUsage.TestField(Amount);
            BasicAmount := PayrollAttributesUsage.Amount;

        StrPosition := StrPos(Expression, PayrollAttributes."Column Name");
        if StrPosition > 0 then begin
            Expression := DelStr(Expression, StrPosition, StrLen(PayrollAttributes."Column Name"));
            // if BasicFromLine then
            //     Expression := InsStr(Expression, Format(BasicSalaryAfterDeduction), StrPosition)
            // else
            Expression := InsStr(Expression, Format(BasicAmount), StrPosition)
        end;
        StrLength := StrLen(Expression);
        repeat
            if Expression[StrLength] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                      'Y', 'Z'] then begin
                PayrollAttributes.Reset;
                PayrollAttributes.SetRange("Column Name", Format(Expression[StrLength]));
                if PayrollAttributes.FindFirst then begin
                    StrPosition := StrPos(Expression, Format(Expression[StrLength]));
                    Expression := DelStr(Expression, StrPosition, StrLen(Format(Expression[StrLength])));

                    PayrollAttributesUsage.Reset;
                    PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
                    PayrollAttributesUsage.SetRange("Employee Code", EmployeeFilter);
                    if PayrollAttributesUsage.FindFirst then
                        //IF PayrollAttributesUsage.Amount <> 0 THEN
                        Expression := InsStr(Expression, Format(PayrollAttributesUsage.Amount), StrPosition)
                    else
                        Expression := InsStr(Expression, '0', StrPosition);
                end;
            end;
            StrLength -= 1;
        until StrLength = 0;
    end;

    procedure GetPayrollAttributes(Employee: Record Employee)
    var
        AttributeAmount: Decimal;
        PGSetup: Record "Payroll General Setup";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollAttributesUsage1: Record "Payroll Attributes Usage";
        basicAmt: Decimal;
        PayrollEngine: Codeunit "Payroll Engine";
    begin

        PGSetup.Get;
        GetGlobalAttributes(Employee);
        GetLevelToGeogAttributes(Employee);

        PayrollAttributesUsage1.Reset();
        PayrollAttributesUsage1.SetRange(Subtype, PayrollAttributesUsage1.Subtype::Basic);
        PayrollAttributesUsage1.SetRange("Employee Code", Employee."No.");
        PayrollAttributesUsage1.CalcSums(Amount);
        if PayrollAttributesUsage1.FindFirst() then
            basicAmt := PayrollAttributesUsage1.Amount;

        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        PayrollAttributesUsage.SetRange("Formula Exists", true);
        if PayrollAttributesUsage.FindFirst then
            repeat
                PayrollAttributes.Reset;
                PayrollAttributes.SetRange(Status, PayrollAttributes.Status::Active);
                PayrollAttributes.SetRange(Code, PayrollAttributesUsage.Code);
                if PayrollAttributes.FindFirst then begin
                    AttributeAmount := 0;
                    if PayrollAttributes.Formula <> '' then
                        // AttributeAmount := EvaluateAmount(PayrollAttributes.Formula, basicAmt);
                    AttributeAmount := EvaluateAmount(SkipOneTimeAttr(PayrollAttributes.Formula), basicAmt);

                    PayrollAttributesUsage.Amount := AttributeAmount;
                    PayrollAttributesUsage.Modify();
                end;
            until PayrollAttributesUsage.Next = 0;
    end;

    procedure GetGlobalAttributes(Employee: Record Employee)
    var
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        AttributeAmount: Decimal;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PayrollAttUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
    begin
        PayrollColumnConfiguration.Reset;
        PayrollColumnConfiguration.SetRange("Table No.", Database::"Level Wise Attributes");
        if PayrollColumnConfiguration.FindSet then begin
            RecRefs.Open(Database::"Level Wise Attributes");
            repeat
                if PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code") then begin
                    AttributeAmount := 0;
                    if PayrollAttributes.Status = PayrollAttributes.Status::Active then begin
                        FieldRefs := RecRefs.Field(1);
                        FieldRefs.SetRange(Employee."Salary Grade");
                        FieldRefs := RecRefs.Field(2);
                        FieldRefs.SetRange(Employee."Salary Level");
                        RecRefs.FindFirst;
                        FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
                        Evaluate(AttributeAmount, Format(FieldRefs.Value));
                        PayrollAttUsage.Reset();
                        PayrollAttUsage.SetRange("Employee Code", Employee."No.");
                        PayrollAttUsage.SetRange(Code, PayrollAttributes.Code);
                        if PayrollAttUsage.FindFirst() then begin
                            if not PayrollAttUsage."Static Amount" then
                                PayrollAttUsage.Amount := AttributeAmount;
                            PayrollAttUsage.Modify();
                        end;
                    end;
                end;
            until PayrollColumnConfiguration.Next = 0;
        end;
    end;

    procedure GetLevelToGeogAttributes(Employee: Record Employee)
    var
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        AttributeAmount: Decimal;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PayrollAttUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
    begin
        // PayrollColumnConfiguration.Reset;
        // PayrollColumnConfiguration.SetRange("Table No.", Database::"Level-Geographical Allowances");
        // if PayrollColumnConfiguration.FindSet then begin
        //     RecRefs.Open(Database::"Level-Geographical Allowances");
        //     repeat
        //         if PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code") then begin
        //             AttributeAmount := 0;
        //             if PayrollAttributes.Status = PayrollAttributes.Status::Active then begin
        //                 Employee.CalcFields("Geographical Category");
        //                 FieldRefs := RecRefs.Field(1);
        //                 FieldRefs.SetRange(Employee."Salary Level");
        //                 FieldRefs := RecRefs.Field(2);
        //                 FieldRefs.SetRange(Employee."Geographical Category");

        //                 RecRefs.FindFirst;
        //                 FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
        //                 Evaluate(AttributeAmount, Format(FieldRefs.Value));
        //                 PayrollAttUsage.Reset();
        //                 PayrollAttUsage.SetRange("Employee Code", Employee."No.");
        //                 PayrollAttUsage.SetRange(Code, PayrollAttributes.Code);
        //                 if PayrollAttUsage.FindFirst() then begin
        //                     PayrollAttUsage.Amount := AttributeAmount;
        //                     PayrollAttUsage.Modify();
        //                 end;
        //             end;
        //         end;
        //     until PayrollColumnConfiguration.Next = 0;
        // end;
    end;

    procedure GetDesignationDescription(DesignationCode: Code[20]): Text
    // var
    //     HRMaster: Record "HR Master";
    begin

        // if HRMaster.Get(HRMaster.Type::Designation, DesignationCode) then
        //     exit(HRMaster.Description)
        // else
        //     exit('')
    end;

    // procedure GetMonthlyTaxableSlab(PostedPayrollLine: Record "Posted Payroll Line"; SST: Boolean): Decimal;
    // var
    //     PPLine: Record "Posted Payroll Line";
    //     Employee: Record Employee;
    //     PGSetup: Record "Payroll General Setup";
    //     RemainingMonth: Integer;

    // begin
    //     Employee.Get(PostedPayrollLine."Employee No.");
    //     PGSetup.Get();
    //     RemainingMonth := 12;
    //     PPLine.Reset();
    //     PPLine.SetRange("Employee No.", PostedPayrollLine."Employee No.");
    //     PPLine.SetRange("Pay Cycle term", PostedPayrollLine."Pay Cycle term");
    //     PPLine.SetFilter("Pay Cycle Period", '<%1', PostedPayrollLine."Pay Cycle Period");
    //     PPLine.CalcSums("Monthly Taxable RIT", "Monthly Taxable SST");

    //     //terminated employee
    //     if Employee.Status = Employee.Status::Terminated then
    //         if Employee."Termination Date" <> 0D then
    //             if (PGSetup."Payroll Fiscal Year Start Date" < Employee."Termination Date") and
    //             (PGSetup."Payroll Fiscal Year End Date" > Employee."Termination Date") then
    //                 RemainingMonth := GetPayPeriodForTermination(Employee, PostedPayrollLine."Pay Cycle Code", PostedPayrollLine."Pay Cycle term");

    //     //contract expiry employee
    //     if Employee."Employment Type" = Employee."Employment Type"::Contract then
    //         if Employee."Contract Expiry Date" <> 0D then
    //             if (PGSetup."Payroll Fiscal Year Start Date" < Employee."Contract Expiry Date") and
    //                     (PGSetup."Payroll Fiscal Year End Date" > Employee."Contract Expiry Date") then
    //                 RemainingMonth := GetPayPeriodForContractExp(Employee, PostedPayrollLine."Pay Cycle Code", PostedPayrollLine."Pay Cycle term");

    //     //force retired employee
    //     if Employee."Force Retirement Date" <> 0D then
    //         if (Employee."Force Retirement Date" < PGSetup."Payroll Fiscal Year End Date") then
    //             RemainingMonth := GetPayPeriodForForceRetirement(Employee, PostedPayrollLine."Pay Cycle Code", PostedPayrollLine."Pay Cycle term");

    //     if not SST then begin
    //         if RemainingMonth - PostedPayrollLine."Pay Cycle Period" + 1 > 0 then
    //             exit(Round((PostedPayrollLine."Taxable Income" - PostedPayrollLine."1 Slab Amount" - PPLine."Monthly Taxable RIT") / (RemainingMonth - PostedPayrollLine."Pay Cycle Period" + 1), 0.01, '='))
    //         else
    //             exit(PostedPayrollLine."Taxable Income" - PostedPayrollLine."1 Slab Amount" - PPLine."Monthly Taxable RIT");
    //     end
    //     else
    //         if RemainingMonth - PostedPayrollLine."Pay Cycle Period" + 1 > 0 then
    //             exit(Round((PostedPayrollLine."1 Slab Amount" - PPLine."Monthly Taxable SST") / (RemainingMonth - PostedPayrollLine."Pay Cycle Period" + 1), 0.01, '='))
    //         else
    //             exit(PostedPayrollLine."1 Slab Amount" - PPLine."Monthly Taxable SST");
    // end;

    procedure GetPayPeriodForTermination(Emp: Record Employee; PayCode: Code[20]; PayTerm: Code[20]): Integer
    var
        PayPeriod: Record "Pay Cycle Period";
    begin

        if Emp."Termination Date" = 0D then
            Error('Invalid termination date');
        PayPeriod.Reset();
        PayPeriod.SetRange("Pay Cycle Code", PayCode);
        PayPeriod.SetRange("Pay Cycle Term", PayTerm);
        PayPeriod.SetFilter("Start Date", '<=%1', Emp."Termination Date" - 1);
        PayPeriod.SetFilter("End Date", '>= %1', Emp."Termination Date" - 1);
        if PayPeriod.FindFirst() then
            exit(PayPeriod.Period)
        else
            Error('Pay period doest match');
    end;

    procedure GetPayPeriodForContractExp(Emp: Record Employee; PayCode: Code[20]; PayTerm: Code[20]): Integer
    var
        PayPeriod: Record "Pay Cycle Period";
    begin

        if Emp."Contract Expiry Date" = 0D then
            Error('Invalid contract expire date');
        PayPeriod.Reset();
        PayPeriod.SetRange("Pay Cycle Code", PayCode);
        PayPeriod.SetRange("Pay Cycle Term", PayTerm);
        PayPeriod.SetFilter("Start Date", '<%1', Emp."Contract Expiry Date" - 1);
        PayPeriod.SetFilter("End Date", '>= %1', Emp."Contract Expiry Date" - 1);
        if PayPeriod.FindFirst() then
            exit(PayPeriod.Period)
        else
            exit(12);
    end;

    procedure GetPayPeriodForForceRetirement(Emp: Record Employee; PayCode: Code[20]; PayTerm: Code[20]): Integer
    var
        PayPeriod: Record "Pay Cycle Period";
    begin

        // if Emp."Force Retirement Date" = 0D then
        //     Error('Invalid force retirement date');
        // PayPeriod.Reset();
        // PayPeriod.SetRange("Pay Cycle Code", PayCode);
        // PayPeriod.SetRange("Pay Cycle Term", PayTerm);
        // PayPeriod.SetFilter("Start Date", '<=%1', Emp."Force Retirement Date" - 1);
        // PayPeriod.SetFilter("End Date", '>= %1', Emp."Force Retirement Date" - 1);
        // if PayPeriod.FindFirst() then
        //     exit(PayPeriod.Period)
        // else
        //     Error('Pay period doest match');
    end;

    procedure ShowHidePayrollColumn(var VariableFieldVisible: array[120] of Boolean; FieldStartNo: Integer)
    var
        i: Integer;
    begin
        Clear(VariableFieldVisible);
        for i := 1 to ArrayLen(VariableFieldVisible) do begin
            VariableFieldVisible[i] := ShowColumn(Database::"Payroll Line", FieldStartNo + i - 1)
        end;
    end;

    procedure ShowColumn(TableID: Integer; FieldID: Integer): Boolean
    var
        PayColumnConfig: Record "Payroll Column Configuration";
    begin
        PayColumnConfig.Reset;
        PayColumnConfig.SetRange("Table No.", TableID);
        PayColumnConfig.SetRange("Field No.", FieldID);
        if PayColumnConfig.IsEmpty then
            exit(false)
        else
            exit(true);
    end;

    local procedure GetAttendanceSetup()
    begin
        // AttendanceSetup.Get;
        // AttendanceSetupReady := true;
    end;

    // procedure IsHourCalculation(): Boolean
    // begin
    //     if not AttendanceSetupReady then
    //         GetAttendanceSetup;
    //     exit(AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Hours);
    // end;

    // procedure IsTimeSheetEnabled(): Boolean
    // begin
    //     if not AttendanceSetupReady then
    //         GetAttendanceSetup;
    //     exit(AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::TimeSheet);
    // end;

    //test
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnCustomDocumentMergerEx', '', false, false)]
    // local procedure restrictReport(LayoutData: InStream;
    //                                 ObjectID: Integer;
    //                                 ObjectPayload: JsonObject;
    //                                 ReportAction: Option;
    //                                 var DocumentStream: OutStream;
    //                                 var IsHandled: Boolean;
    //                                 XmlData: InStream)
    // begin
    //     if
    //         (ObjectID in [52183460, 52183451]) then begin
    //         case ReportAction of
    //             ReportAction::SaveAsExcel:
    //                 Error('you not suppose to do it');
    //         end;
    //     end;
    // end;

    procedure SkipOneTimeAttr(Expression: Code[100]): Code[100]
    var

        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributes: Record "Payroll Attributes";
        NewAttrExp: Code[250];
        DoubleChar: Boolean;
        SkipPosition: Integer;
        Exp1: Code[100];
    begin

        StrLength := StrLen(Expression);
        repeat
            if Expression[StrLength] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                      'Y', 'Z'] then begin

                if StrLength - 1 > 0 then
                    if Expression[StrLength - 1] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                                         'Y', 'Z'] then begin
                        DoubleChar := true;
                        SkipPosition := StrLength - 1;
                    end;
                if StrLength <> SkipPosition then begin

                    if DoubleChar then
                        NewAttrExp := Format(Expression[StrLength - 1]) + Format(Expression[StrLength])
                    else
                        NewAttrExp := Format(Expression[StrLength]);

                    PayrollAttributes.Reset;
                    PayrollAttributes.SetRange("Column Name", NewAttrExp);
                    if PayrollAttributes.FindFirst then begin
                        StrPosition := StrPos(Expression, NewAttrExp);
                        if not PayrollAttributes."Apply Every Month" then begin
                            Expression := DelStr(Expression, StrPosition, StrLen(Format(NewAttrExp)));
                            Expression := InsStr(Expression, '0', StrPosition);
                        end;
                    end;
                    DoubleChar := false;
                end;
            end;

            StrLength -= 1;
        until StrLength = 0;

        Exp1 := Expression;
        exit(Exp1);
    end;

    //this function is used to get the annual accessible income of an employee based on the payroll attributes usage
    // it calculates the total annual earnings and total retirement contributions
    procedure GetAnnualAccessibleIncome(EmpCode: Code[20];
                                        PostedPayrollNo: Code[20];
                                        PayCycleTerm: Code[20];
                                        var TotalAnnualEarning: Decimal;
                                        var TotalRetirement: Decimal;
                                        var TotalPF: decimal)
    var
        LastEntryNo: Integer;
        TaxSetupHdr: Record "Tax Setup Header";
        RemainingMonth: Integer;
        EmployeePayrollOpen: Record "Employee Payroll Opening";
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry";
        TempDetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry" temporary;
        Employee: Record Employee;
    begin
        //1. finds if payroll has posted for employee
        //if found, then it will get the last posted month and project the earning for remaining months
        //if not found, then it will project the earning for all months of the pay cycle term
        //2. it will then get the total annual earnings and total retirement contributions
        Employee.get(EmpCode);
        SetEmployeeCode(EmpCode);
        TempDetailedEmpLedgerEntry.DeleteAll();
        LastEntryNo := 90000000;

        EmployeePayrollOpen.Reset();
        EmployeePayrollOpen.SetRange("Employee No.", EmpCode);
        EmployeePayrollOpen.SetRange("Fiscal Year", PaycycleTerm);
        if EmployeePayrollOpen.FindFirst() then;

        TaxSetupHdr.Get(Employee."Tax Code");

        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetFilter("Employee No.", EmpCode);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindLast then begin
            CreateTempDetailedLedgerFromPAttrUsage(DetailedEmpLedgerEntry."Pay Cycle Period" + 1, PayCycleTerm, EmpCode, LastEntryNo, TempDetailedEmpLedgerEntry);
        end
        else begin
            CreateTempDetailedLedgerFromPAttrUsage(1, PayCycleTerm, EmpCode, LastEntryNo, TempDetailedEmpLedgerEntry);
        end;


        Clear(DetailedEmpLedgerEntry);
        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetRange("Employee No.", EmpCode);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindFirst then
            repeat
                TempDetailedEmpLedgerEntry.Init;
                TempDetailedEmpLedgerEntry := DetailedEmpLedgerEntry;
                if TempDetailedEmpLedgerEntry."Attribute Type" = TempDetailedEmpLedgerEntry."Attribute Type"::Deduction then
                    TempDetailedEmpLedgerEntry.Amount := Abs(DetailedEmpLedgerEntry.Amount);
                TempDetailedEmpLedgerEntry.Insert;
            until DetailedEmpLedgerEntry.Next = 0;

        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Type", '%1|%2', TempDetailedEmpLedgerEntry."Attribute Type"::"Basic Earning", TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings");
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalAnnualEarning := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total Benefit Opening";

        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::Deduction);
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Sub Type", '%1|%2|%3|%4|%5',
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employer Contribution",
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::CIT,
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employee Contribution",
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::RF,
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Lump Sum Contribution"
                                        );

        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalRetirement := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total RF Opening";

        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::Deduction);
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Sub Type", '%1|%2',
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employer Contribution",
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employee Contribution"
                                        );
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalPF := TempDetailedEmpLedgerEntry.Amount;

        TempDetailedEmpLedgerEntry.DeleteAll();
    end;

    local procedure CheckIfProjectable(AttrCode: Code[20]): Boolean
    var
        PayrollAtr: Record "Payroll Attributes";
    begin
        if PayrollAtr.Get(AttrCode) then begin
            if PayrollAtr.Irregular then
                if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
                    exit(true)
                else
                    exit(false);
            if PayrollAtr."Non-Taxable" then
                exit(false);

            // if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
            //     exit(true); // will see it

            if PayrollAtr."Apply Every Month" then
                exit(true);

            if (PayrollAtr.Type = PayrollAtr.Type::Deduction) then begin

                if PayrollAtr.Subtype in [PayrollAtr.Subtype::"Social Security Tax", PayrollAtr.Subtype::"Tax on Remuneration & Benefits"] then
                    exit(true);

                exit(false);
            end;
            exit(true);  //because its benefit
        end;
        exit(false);
    end;

    procedure GetTax(StartAmount: Decimal; endAmount: Decimal; var RemainingTaxableAmount: Decimal): Decimal
    var
        RemainingAmountCopy: Decimal;
    begin
        if (endAmount - StartAmount) <= RemainingTaxableAmount then begin
            RemainingTaxableAmount := RemainingTaxableAmount - (endAmount - StartAmount + 1);
            exit(endAmount - StartAmount + 1)
        end
        else begin
            RemainingAmountCopy := RemainingTaxableAmount;
            RemainingTaxableAmount := 0;
            exit(RemainingAmountCopy);
        end;
    end;

    local procedure GetTax2(StartAmount: Decimal; endAmount: Decimal; RemainTaxable: Decimal; TempTax: Decimal; TaxSetupLine: Record "Tax Setup Line"): Decimal
    begin

        if RemainTaxable > 0 then
            exit(endAmount - StartAmount + 1)
        else
            if TaxSetupLine."Tax Rate" > 1 then
                exit(Round(TempTax * 100 / TaxSetupLine."Tax Rate", 0.01, '='))
            else
                exit(Round(TempTax * 100, 0.01, '='));
    end;

    procedure CreateTempDetailedLedgerFromPAttrUsage(StartPeriod: Integer;
                                                    PayCycleTerm: Code[20];
                                                    EmpCode: Code[20];
                                                    var TempEntryNo: Integer;
                                                    var TempDetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry" temporary)
    var
        i: Integer;
        PayrollAttrUsage: Record "Payroll Attributes Usage";
        PayAttr: Record "Payroll Attributes";
        InsertData: Boolean;
        FirstIteration: Boolean;
        PgSetup: Record "Payroll General Setup";
        EmpVar: Record Employee;
    begin

        FirstIteration := true;
        PgSetup.Get();
        EmpVar.Get(EmpCode);

        for i := StartPeriod to GetLastPayCycleForEmployee(EmpCode, PayCycleTerm) do begin
            PayrollAttrUsage.Reset();
            PayrollAttrUsage.SetRange("Employee Code", EmpCode);
            if PayrollAttrUsage.FindSet() then
                repeat
                    InsertData := false;
                    PayrollAttrUsage.CalcFields(Type, Subtype, "Formula Exists");
                    if CheckIfProjectable(PayrollAttrUsage.Code) then
                        InsertData := true;
                    PayAttr.Get(PayrollAttrUsage.Code);
                    if (PayAttr."Pay Frequency" <> 0) and (getPaidFrequency(PayAttr.Code, TempDetailedEmpLedgerEntry) >= PayAttr."Pay Frequency") then
                        InsertData := false;
                    if InsertData then begin
                        TempDetailedEmpLedgerEntry.Init();
                        TempDetailedEmpLedgerEntry."Entry No." := TempEntryNo;
                        TempDetailedEmpLedgerEntry."Employee No." := EmpCode;
                        TempDetailedEmpLedgerEntry.Validate("Payroll Attribute Code", PayrollAttrUsage.Code);
                        if PayAttr.Type = PayAttr.Type::Benefits then
                            if PayAttr.Subtype = PayAttr.Subtype::Basic then
                                TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::"Basic Earning"
                            else
                                TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings";
                        if PayAttr.Type = PayAttr.Type::Deduction then
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::Deduction;

                        TempDetailedEmpLedgerEntry."Attribute Sub Type" := PayAttr.Subtype;

                        // TempDetailedEmpLedgerEntry."Specific Component" := PayAttr."Specific Component";
                        // TempDetailedEmpLedgerEntry."Pension Specific" := PayAttr."Pension Specific";
                        // TempDetailedEmpLedgerEntry."Settlement Specific" := PayAttr."Settlement Specific";
                        TempDetailedEmpLedgerEntry."Non-Taxable" := PayAttr."Non-Taxable";
                        TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                        TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                        TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;
                        if PayrollAttrUsage."Formula Exists" then begin
                            if PayrollAttrUsage.Amount <> 0 then
                                TempDetailedEmpLedgerEntry.Amount := PayrollAttrUsage.Amount
                            else
                                TempDetailedEmpLedgerEntry.Amount := getAttributeAmount(EmpCode, PayrollAttrUsage.Code)
                        end
                        else
                            TempDetailedEmpLedgerEntry.Amount := PayrollAttrUsage.Amount;

                        // if PayAttr.Subtype = PayAttr.Subtype::Grade then
                        //     TempDetailedEmpLedgerEntry.Amount := GetGradeAmt(EmpVar, TempDetailedEmpLedgerEntry.Amount, TempDetailedEmpLedgerEntry."Pay Cycle Period");  //update according to grade plan

                        //tempcode non payment as 12 month>>
                        // if PayAttr.Type = PayAttr.Type::"Non-Payment" then
                        //     if not FirstIteration then
                        //         TempDetailedEmpLedgerEntry.Amount := 0;

                        //get interest income amt
                        // if PayAttr."Specific Component" = PayAttr."Specific Component"::"Interest Income" then
                        //     TempDetailedEmpLedgerEntry.Amount := getInterestIncome(TempDetailedEmpLedgerEntry."Employee No.",
                        //                                                         PayAttr.Code,
                        //                                                         TempDetailedEmpLedgerEntry."Pay Cycle Term",
                        //                                                         TempDetailedEmpLedgerEntry."Pay Cycle Period"
                        //                                                         );

                        TempDetailedEmpLedgerEntry.Insert();
                        TempEntryNo += 1;
                    end;
                until PayrollAttrUsage.Next() = 0;

            FirstIteration := false;
        end;
    end;

    procedure getPaidFrequency(attrCode: Code[20]; var TempDetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry"): Integer
    begin
        TempDetailedEmpLedgerEntry.SetRange("Payroll Attribute Code", attrCode);
        exit(TempDetailedEmpLedgerEntry.Count);
    end;


    procedure GetLastPayCycleForEmployee(empCode: Code[20]; PayCycleTerm: Code[20]): Integer
    var
        PGSetup: Record "Payroll General Setup";
        EmpRec: Record Employee;
        PayrollRepMgt: Codeunit "Payroll Report Mgt.";
        RemainingMonth: Integer;
    begin
        RemainingMonth := 12;
        EmpRec.Get(empCode);
        PGSetup.Get();

        //terminated employee
        if EmpRec.Status = EmpRec.Status::Terminated then
            if EmpRec."Termination Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Termination Date") and
                (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Termination Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForTermination(EmpRec, 'MONTHLY', PayCycleTerm);

        //contract expiry EmpRec
        if EmpRec."Employment Type" = EmpRec."Employment Type"::Contract then
            if EmpRec."Contract Expiry Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Contract Expiry Date") and
                        (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Contract Expiry Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForContractExp(EmpRec, 'MONTHLY', PayCycleTerm);

        //force retired EmpRec
        // if EmpRec."Force Retirement Date" <> 0D then
        //     if (EmpRec."Force Retirement Date" < PGSetup."Payroll Fiscal Year End Date") then
        //         RemainingMonth := PayrollRepMgt.GetPayPeriodForForceRetirement(EmpRec, 'MONTHLY', PayCycleTerm);

        exit(RemainingMonth);
    end;

    // procedure GetGradeAmt(Emp: Record Employee; var GradeAmt: Decimal; payPeriod: Integer): Decimal
    // var
    //     GradePlan: Record "Grade Plan";
    //     levelwiseAttr: Record "Level Wise Attributes";
    // begin
    //     GradePlan.Reset();
    //     GradePlan.SetRange("Employee No.", Emp."No.");
    //     GradePlan.SetRange("Salary Level", Emp."Salary Level");
    //     GradePlan.SetRange(Verified, true);
    //     GradePlan.SetRange(Applied, false);
    //     GradePlan.SetFilter("Salary Grade", '<>%1', Emp."Salary Grade");
    //     GradePlan.SetFilter("Pay Cycle Period", '<>%1&<=%2', 0, payPeriod);
    //     if GradePlan.FindLast() then
    //         //get the applied month
    //         if levelwiseAttr.Get(GradePlan."Salary Grade", Emp."Salary Level") then
    //             GradeAmt := levelwiseAttr."Level Rate";

    //     exit(GradeAmt);
    // end;

    // procedure getInterestIncome(empCode: Code[20]; PattrCode: Code[20]; PayCycleTerm: Code[20]; payCycleperiod: Integer): Decimal
    // var
    //     InterestIncome: Record "Payroll Interest Income";
    // begin
    //     InterestIncome.Reset();
    //     InterestIncome.SetRange("Employee Code", empCode);
    //     InterestIncome.SetRange("Payroll Attribute", PattrCode);
    //     InterestIncome.SetRange("Pay Cycle Term", PayCycleTerm);
    //     InterestIncome.SetRange("Pay Cycle Period", payCycleperiod);
    //     InterestIncome.CalcSums("Interest Perquisite");
    //     exit(InterestIncome."Interest Perquisite")
    // end;

    // procedure PassParPortal(empCode: Code[20]; FiscalYear: Code[20])
    // begin
    //     EmployeeFilter := empCode;
    //     PayCycleTerm := FiscalYear;
    // end;

    procedure GetPayrollprojectionMonthForEmployee(EmpCode: Code[20];
                                                PayCycleTerm: Code[20];
                                                var PayrollProjectionMonth: Integer)
    var
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry";
    begin
        DetailedEmpLedgerEntry.SetRange("Employee No.", EmpCode);
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindLast() then
            PayrollProjectionMonth := GetLastPayCycleForEmployee(EmpCode, PayCycleTerm) - DetailedEmpLedgerEntry."Pay Cycle Period"
        else
            PayrollProjectionMonth := GetLastPayCycleForEmployee(EmpCode, PayCycleTerm);
    end;

}
