//This codeunit is used to store payroll calculation for reports
//It contains complex payroll projection calculation without using payroll lines
//Temporary table of Detailed employee ledger entry is used to store the data.
codeunit 50027 "Payroll Report Mgt."
{
    var
        EmployeeFilter: Code[20];
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
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;
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
            BasicAmt := GetBasicAmount(EmpCode);

            if BasicAmt = 0 then begin
                Employee.Get(EmpCode);
                SalaryLevel.Get(Employee."Salary Level");
                BasicAmt := SalaryLevel."Basic Salary";
            end;
            exit(EvaluateAmount(PayAttr.Formula, BasicAmt))
        end;
    end;

    procedure EvaluateAmount(Expression: Code[100]; BasicFromLine: Decimal): Decimal
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
        operat: Code[20];
    begin
        ResolveColumn(Expression, BasicFromLine);
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
            end else if Expression[Counter] = ')' then begin
                if OsNo <> 0 then
                    while (OperatorStack[OsNo] <> '(') and (OsNo <> 0) do begin
                        Num2 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        Num1 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        operat := OperatorStack[OsNo];
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                        NsNo += 1;
                        NumberStack[NsNo] := CalculateValue(Num1, Num2, operat);
                        if OsNo = 0 then
                            break;
                    end;
                if (OsNo <> 0) then begin
                    OperatorStack[OsNo] := '';
                    OsNo -= 1;
                end;
            end
            else if Expression[Counter] in ['+', '-', '*', '/'] then begin
                if OsNo <> 0 then
                    while (OsNo <> 0) and (CheckPrecedence(OperatorStack[OsNo]) >= CheckPrecedence(Format(Expression[Counter]))) do begin
                        Num2 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        Num1 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        operat := OperatorStack[OsNo];
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                        NsNo += 1;
                        NumberStack[NsNo] := CalculateValue(Num1, Num2, operat);
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
                    if Counter < ExNo then begin
                        if Evaluate(DecNumber, Format(Expression[Counter + 1])) or (Expression[Counter + 1] = '.') then begin
                            ContiguousNumber := true;
                            Counter += 1;
                        end;
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
            operat := OperatorStack[OsNo];
            OperatorStack[OsNo] := '';
            OsNo -= 1;
            NsNo += 1;
            NumberStack[NsNo] := CalculateValue(Num1, Num2, operat);
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

    procedure ResolveColumn(var Expression: Code[100]; BasicFromLine: Decimal)
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributes: Record "Payroll Attributes";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BasicAmount: Decimal;
        Substring1: Text;
        SubString2: Text;
        SubString3: Text;
        Length: Integer;
    begin
        Expression := DelChr(Expression, '=');
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Benefits);
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Basic);
        PayrollAttributes.FindFirst;

        BasicAmount := BasicFromLine;
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
        PayrollAttributesUsage.SetRange("Employee Code", EmployeeFilter);
        if PayrollAttributesUsage.FindFirst then
            BasicAmount := PayrollAttributesUsage.Amount;


        StrPosition := StrPos(Expression, PayrollAttributes."Column Name");
        if StrPosition > 0 then begin
            Expression := DelStr(Expression, StrPosition, StrLen(PayrollAttributes."Column Name"));
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
                    if PayrollAttributesUsage.FindFirst then begin
                        if PayrollAttributesUsage.Amount < 0 then begin
                            Length := StrLen(Expression);
                            Substring1 := CopyStr(Expression, 1, StrPosition - 2);
                            SubString2 := CopyStr(Expression, StrPosition);
                            SubString3 := CopyStr(Expression, StrPosition - 1, 1);
                            if SubString3 = '-' then
                                Expression := InsStr(Substring1 + SubString2, '+' + Format(Abs(PayrollAttributesUsage.Amount)), StrPosition - 1)
                            else if SubString3 = '+' then
                                Expression := InsStr(Substring1 + SubString2, '-' + Format(Abs(PayrollAttributesUsage.Amount)), StrPosition - 1)
                        end else
                            Expression := InsStr(Expression, Format(PayrollAttributesUsage.Amount), StrPosition)
                    end else
                        Expression := InsStr(Expression, Format(0), StrPosition);
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
    begin

        PGSetup.Get;
        GetGlobalAttributes(Employee);
        GetAttributesFromAllowanceConfiguration(Employee."No.");

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

    procedure GetPayPeriod(RecordDate: Date; PayCode: Code[20]; PayTerm: Code[20]): Integer
    var
        PayPeriod: Record "Pay Cycle Period";
    begin

        if RecordDate = 0D then
            Error('Invalid date');
        PayPeriod.Reset();
        PayPeriod.SetRange("Pay Cycle Code", PayCode);
        PayPeriod.SetRange("Pay Cycle Term", PayTerm);
        PayPeriod.SetFilter("Start Date", '<=%1', RecordDate - 1);
        PayPeriod.SetFilter("End Date", '>= %1', RecordDate - 1);
        if PayPeriod.FindFirst() then
            exit(PayPeriod.Period)
        else
            Error('Pay period doest match');
    end;

    procedure GetPayPeriodForResignation(PayCode: Code[20]; PayTerm: Code[20]): Integer
    var
        PayPeriod: Record "Pay Cycle Period";
        Emp: Record Employee;
    begin
        if Emp."Resignation Date" = 0D then
            Error('Invalid resignation date');

        PayPeriod.Reset();
        PayPeriod.SetRange("Pay Cycle Code", PayCode);
        PayPeriod.SetRange("Pay Cycle Term", PayTerm);
        PayPeriod.SetFilter("Start Date", '<=%1', Emp."Resignation Date" - 1);
        PayPeriod.SetFilter("End Date", '>= %1', Emp."Resignation Date" - 1);
        if PayPeriod.FindFirst() then
            exit(PayPeriod.Period)
        else
            Error('Pay period does not match');
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

    procedure GetAnnualAccessibleIncome(EmpCode: Code[20];
                                        PostedPayrollNo: Code[20];
                                        PayCycleTerm: Code[20];
                                        var TotalAnnualEarning: Decimal;
                                        var TotalRetirement: Decimal;
                                        var TotalPF: decimal)
    var
        LastEntryNo: Integer;
        TaxSetupHdr: Record "Tax Setup Header";
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

                        TempDetailedEmpLedgerEntry."Non-Taxable" := PayAttr."Non-Taxable";
                        TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY'); // get it from current pay period
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
                    RemainingMonth := PayrollRepMgt.GetPayPeriod(EmpRec."Termination Date", PGSetup."Pay Cycle Code", PGSetup."Pay Cycle Term");

        //contract expiry EmpRec
        if EmpRec."Employment Type" = EmpRec."Employment Type"::Contract then
            if EmpRec."Contract Expiry Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Contract Expiry Date") and
                        (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Contract Expiry Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForContractExp(EmpRec, 'MONTHLY', PayCycleTerm);


        exit(RemainingMonth);
    end;

    procedure GetAttributesFromAllowanceConfiguration(EmpNo: Code[20])
    var
        AllowanceConfiguration: Record "Allowance Configuration";
        PayrollAttrUses: Record "Payroll Attributes Usage";
        PayrollAttrUses2: Record "Payroll Attributes Usage";
        AllowanceAmt: Decimal;
    begin
        PGSetup.Get();
        if not PGSetup."Use Allowance Configuration" then
            exit;

        AllowanceConfiguration.Reset();
        if AllowanceConfiguration.FindSet() then
            repeat
                AllowanceAmt := 0;
                AllowanceAmt := GetAllowanceConfigurationAmountforEmployee(AllowanceConfiguration,
                                                                            '',
                                                                            EmpNo);

                if PayrollAttrUses.Get(AllowanceConfiguration."Payroll Attribute", EmpNo) then begin
                    if not MultipleConfigForSameAttribute(AllowanceConfiguration) then
                        PayrollAttrUses.Amount := AllowanceAmt
                    else
                        if AllowanceAmt <> 0 then
                            PayrollAttrUses.Amount := AllowanceAmt;
                    if not PayrollAttrUses."Static Amount" then
                        PayrollAttrUses.Modify();
                end
                else begin
                    if AllowanceAmt <> 0 then begin
                        Clear(PayrollAttrUses2);
                        PayrollAttrUses2.Init();
                        PayrollAttrUses2.Validate(Code, AllowanceConfiguration."Payroll Attribute");
                        PayrollAttrUses2.Validate("Employee Code", EmpNo);
                        PayrollAttrUses2.Validate(Amount, AllowanceAmt);
                        if PayrollAttrUses2.Insert() then;
                    end;
                end;
            until AllowanceConfiguration.Next() = 0;
    end;

    procedure GetAllowanceConfigurationAmountforEmployee(AllowanceConfiguration: Record "Allowance Configuration"; PayrollDocNo: code[20]; EmployeeCode: Code[20]): Decimal
    begin
        case AllowanceConfiguration.Source of
            AllowanceConfiguration.Source::Leave, AllowanceConfiguration.Source::Direct, AllowanceConfiguration.Source::Assignment, AllowanceConfiguration.Source::Shift:
                exit(GetAllowanceAmountFromAssignmentMemoLedger(PayrollDocNo,
                                            EmployeeCode,
                                            AllowanceConfiguration."Payroll Attribute",
                                            AllowanceConfiguration."Leave Code",
                                            0D,
                                            WorkDate()));


            AllowanceConfiguration.Source::" ":
                if AllowanceConfiguration.IsValidAllowanceConfigurationForEmployee(AllowanceConfiguration, EmployeeCode, WorkDate()) then
                    if AllowanceConfiguration.Formula <> '' then
                        exit(AllowanceConfiguration.EvaluateAmountForEmployee(AllowanceConfiguration.Formula, EmployeeCode))
                    else
                        exit(AllowanceConfiguration.Amount);
        end;
    end;

    procedure MultipleConfigForSameAttribute(AllConfig: Record "Allowance Configuration"): Boolean
    var
        AllConfig2: Record "Allowance Configuration";
    begin
        AllConfig2.SetRange("Payroll Attribute", AllConfig."Payroll Attribute");
        if AllConfig2.Count > 1 then
            exit(true)
        else
            exit(false);
    end;

    procedure GetAllowanceAmountFromAssignmentMemoLedger(PayrollDocNo: Code[20];
                                       EmployeeCode: Code[20];
                                        PayrollAttr: Code[20];
                                        LeaveCode: Code[20];
                                        FromDate: Date;
                                        ToDate: Date): Decimal
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        Amt: Decimal;
    begin
        AssignmentMemoLedgerEntry.SetLoadFields("Employee Activity Type", Reversed, "Employee No.", "Posting Date", "Payroll Attribute Code", Open, "Payroll Document No.", Amount);
        AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Request Allowance");
        AssignmentMemoLedgerEntry.SetRange(Reversed, false);
        AssignmentMemoLedgerEntry.SetRange("Employee No.", EmployeeCode);
        AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", PayrollAttr);
        AssignmentMemoLedgerEntry.SetRange("Posting Date", FromDate, ToDate);
        AssignmentMemoLedgerEntry.SetFilter("Payroll Document No.", '%1|%2', '', PayrollDocNo);
        AssignmentMemoLedgerEntry.SetRange("Blocked for Payroll", false);
        AssignmentMemoLedgerEntry.SetRange("Open", true);
        AssignmentMemoLedgerEntry.CalcSums(Amount);
        Amt := AssignmentMemoLedgerEntry."Amount";
        exit(round(Amt, 0.01, '='));
    end;

    procedure GetBasicAmount(EmpCode: Code[20]): Decimal
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BasicAmount: Decimal;
    begin
        PayrollAttributesUsage.SetRange(Subtype, PayrollAttributesUsage.Subtype::Basic);
        PayrollAttributesUsage.SetRange("Employee Code", EmpCode);
        if PayrollAttributesUsage.FindFirst then
            BasicAmount := PayrollAttributesUsage.Amount;
    end;
}
