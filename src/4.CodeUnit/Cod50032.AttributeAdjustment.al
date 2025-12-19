codeunit 50032 "Attribute Adjustment Mgt"
{
    trigger OnRun()
    begin

    end;

    procedure OnApprovalOfAttributeAdjustment(DocumentNo: Code[20])
    var
        AttribAdjLine: Record "Attribute Adjustment Line";
    begin
        AttribAdjLine.Reset();
        AttribAdjLine.SetRange("Document No.", DocumentNo);
        if AttribAdjLine.FindSet() then
            repeat
                InsertIntoAttributeUsageHistory(AttribAdjLine);
            until AttribAdjLine.Next() = 0;
    end;

    local procedure InsertIntoAttributeUsageHistory(AttributeAdjustmentLine: Record "Attribute Adjustment Line")
    var
        AttributesUsageHistory: Record "Attributes Usage History";
    begin
        AttributesUsageHistory.Init();
        AttributesUsageHistory."Employee No." := AttributeAdjustmentLine."Employee No.";
        AttributesUsageHistory."Employee Name" := AttributeAdjustmentLine."Employee Name";
        AttributesUsageHistory."Attribute Code" := AttributeAdjustmentLine."Attribute Code";
        AttributesUsageHistory."Old Amount" := AttributeAdjustmentLine."Old Amount";
        AttributesUsageHistory."New Amount" := AttributeAdjustmentLine."New Amount";
        AttributesUsageHistory."Start Date" := AttributeAdjustmentLine."Effective Start Date";
        AttributesUsageHistory."End Date" := AttributeAdjustmentLine."Effective End Date";
        AttributesUsageHistory."Source Document Type" := AttributeAdjustmentLine."Adjustment Type";
        AttributesUsageHistory."Source Document No." := AttributeAdjustmentLine."Document No.";
        AttributesUsageHistory.Insert(true);

        if not AttributeAdjustmentLine."System Calculated" then
            UpdatePayrollAttributeUsage(AttributeAdjustmentLine."Employee No.", AttributeAdjustmentLine."Attribute Code", AttributeAdjustmentLine."New Amount");
    end;

    local procedure UpdatePayrollAttributeUsage(EmployeeNo: Code[20]; AttributeCode: Code[20]; AttributeAmount: Decimal)
    var
        AttributeUsage: Record "Payroll Attributes Usage";
    begin
        if AttributeUsage.Get(AttributeCode, EmployeeNo) then begin
            AttributeUsage.Amount := AttributeAmount;
            AttributeUsage.Modify();
        end
        else begin
            AttributeUsage.Init();
            AttributeUsage.Code := AttributeCode;
            AttributeUsage."Employee Code" := EmployeeNo;
            AttributeUsage.Amount := AttributeAmount;
            AttributeUsage.Insert();
        end;
    end;

    procedure UpdatePayrollAttributesInAttributeAdjustmentLine(AttributeAdjustmentHeader: Record "Attribute Adjustment Header")
    var
        PayrollAttributes: Record "Payroll Attributes";
        AttributeAdjustmentLine, NewAttributeAdjustmentLine : Record "Attribute Adjustment Line";
        TempEmployee: Record Employee temporary;
        PayCyclePeriod: Record "Pay Cycle Period";
        PayrollAttribUsage: Record "Payroll Attributes Usage";
        Formula: Code[100];
    begin
        AttributeAdjustmentLine.SetRange("Document No.", AttributeAdjustmentHeader."Document No.");
        if AttributeAdjustmentLine.FindSet() then
            repeat
                TempEmployee.SetRange("No.", AttributeAdjustmentLine."Employee No.");
                if not TempEmployee.FindFirst() then begin
                    TempEmployee.Init();
                    TempEmployee."No." := AttributeAdjustmentLine."Employee No.";
                    TempEmployee.Insert();
                end;
            until AttributeAdjustmentLine.Next() = 0;

        if TempEmployee.IsEmpty() then
            exit;

        PayCyclePeriod.Get(AttributeAdjustmentHeader."Pay Cycle Code", AttributeAdjustmentHeader."Pay Cycle Term", AttributeAdjustmentHeader."Pay Cycle Period");

        //Delete Existing System Generated Adjustment Lines to avoid duplication
        AttributeAdjustmentLine.Reset();
        AttributeAdjustmentLine.SetRange("System Calculated", true);
        AttributeAdjustmentLine.SetRange("Document No.", AttributeAdjustmentHeader."Document No.");
        if AttributeAdjustmentLine.FindSet() then
            AttributeAdjustmentLine.DeleteAll();

        TempEmployee.Reset();
        TempEmployee.FindSet();
        repeat
            PayrollAttribUsage.SetRange("Formula Exists", true);
            PayrollAttribUsage.SetRange("Employee Code", TempEmployee."No.");
            if PayrollAttribUsage.FindSet() then
                repeat
                    Clear(NewAttributeAdjustmentLine);
                    Clear(Formula);
                    NewAttributeAdjustmentLine.Init();
                    NewAttributeAdjustmentLine."Document No." := AttributeAdjustmentHeader."Document No.";
                    NewAttributeAdjustmentLine."Line No." := GetLineNo(AttributeAdjustmentHeader."Document No.");
                    NewAttributeAdjustmentLine.Validate("Employee No.", TempEmployee."No.");
                    NewAttributeAdjustmentLine."Adjustment Type" := AttributeAdjustmentHeader."Adjustment Type";
                    NewAttributeAdjustmentLine."Attribute Code" := PayrollAttribUsage.Code;
                    Formula := GetPayrollAttributeFormula(PayrollAttribUsage.Code);
                    NewAttributeAdjustmentLine."New Amount" := EvaluateAmountOnAttributeAdjustment(Formula, AttributeAdjustmentHeader, TempEmployee."No.", true); // all new amount
                    NewAttributeAdjustmentLine."Old Amount" := EvaluateAmountOnAttributeAdjustment(Formula, AttributeAdjustmentHeader, TempEmployee."No.", false); // all old amount
                    NewAttributeAdjustmentLine."System Calculated" := true;
                    GetEffectiveStartDateEndDate(NewAttributeAdjustmentLine);
                    NewAttributeAdjustmentLine.Insert();
                until PayrollAttribUsage.Next() = 0;
        until TempEmployee.Next() = 0;

        TempEmployee.DeleteAll();
    end;

    procedure GetPayrollAttributeFormula(AttributeCode: Code[20]): Code[100]
    var
        PayrollAttributes: Record "Payroll Attributes";
    begin
        PayrollAttributes.SetLoadFields(Code, Formula);
        PayrollAttributes.Get(AttributeCode);
        exit(PayrollAttributes.Formula);
    end;

    local procedure GetLineNo(DocumentNo: Code[20]): Integer
    var
        AttributeAdjustmentLine: Record "Attribute Adjustment Line";
    begin
        AttributeAdjustmentLine.SetLoadFields("Document No.", "Line No.");
        AttributeAdjustmentLine.SetRange("Document No.", DocumentNo);
        if AttributeAdjustmentLine.FindLast() then
            exit(AttributeAdjustmentLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetEffectiveStartDateEndDate(var AdjLine: Record "Attribute Adjustment Line")
    var
        AttributeAdjustmentLine: Record "Attribute Adjustment Line";
    begin
        AttributeAdjustmentLine.SetLoadFields("Document No.", "Employee No.", "Effective Start Date", "Effective End Date");
        AttributeAdjustmentLine.SetRange("Document No.", AdjLine."Document No.");
        AttributeAdjustmentLine.SetRange("Employee No.", AdjLine."Employee No.");
        if not AttributeAdjustmentLine.FindLast() then
            exit;
        AdjLine."Effective Start Date" := AttributeAdjustmentLine."Effective Start Date";
        AdjLine."Effective End Date" := AttributeAdjustmentLine."Effective End Date";
    end;

    local procedure EvaluateAmountOnAttributeAdjustment(Expression: Code[100]; AttributeAdjustmentHeader: Record "Attribute Adjustment Header"; EmpCode: Code[20]; IsNewAmount: Boolean): Decimal
    var
        OperatorStack: array[100] of Code[20];
        NumberStack: array[100] of Decimal;
        DecNumber: Decimal;
        ContiguousNumber: Boolean;
        CurrExpr: Code[100];
        Counter: Integer;
        Num1: Decimal;
        Num2: Decimal;
        operat: Code[20];
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;
        BasicSalaryAfterDeduction: Decimal;
    begin
        ResolveColumnOnAttributeAdjustment(Expression, AttributeAdjustmentHeader, EmpCode, IsNewAmount);
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
                        NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
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
                        NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
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
            NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
        end;
        exit(NumberStack[NsNo]);
    end;

    procedure ResolveColumnOnAttributeAdjustment(var Expression: Code[100]; AttributeAdjustmentHeader: Record "Attribute Adjustment Header"; EmpCode: Code[20]; IsNewAmount: Boolean)
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributes: Record "Payroll Attributes";
        AttributeAdjustmentLine: Record "Attribute Adjustment Line";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BasicAmount: Decimal;
        Substring1: Text;
        SubString2: Text;
        SubString3: Text;
        Length: Integer;
        CalculatedAmount: Decimal;
    begin
        Expression := DelChr(Expression, '=');

        StrPosition := StrPos(Expression, PayrollAttributes."Column Name");
        if StrPosition > 0 then begin
            Expression := DelStr(Expression, StrPosition, StrLen(PayrollAttributes."Column Name"));
            Expression := InsStr(Expression, Format(BasicAmount), StrPosition)
        end;
        StrLength := StrLen(Expression);
        repeat
            if Expression[StrLength] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'] then begin
                PayrollAttributes.Reset;
                PayrollAttributes.SetRange("Column Name", Format(Expression[StrLength]));
                if PayrollAttributes.FindFirst then begin
                    StrPosition := StrPos(Expression, Format(Expression[StrLength]));
                    Expression := DelStr(Expression, StrPosition, StrLen(Format(Expression[StrLength])));

                    AttributeAdjustmentLine.SetRange("Document No.", AttributeAdjustmentHeader."Document No.");
                    AttributeAdjustmentLine.SetRange("Employee No.", EmpCode);
                    AttributeAdjustmentLine.SetRange("Attribute Code", PayrollAttributes.Code);
                    if AttributeAdjustmentLine.FindFirst() then begin
                        if IsNewAmount then
                            CalculatedAmount := AttributeAdjustmentLine."New Amount"
                        else
                            CalculatedAmount := AttributeAdjustmentLine."Old Amount";

                        if CalculatedAmount < 0 then begin
                            Length := StrLen(Expression);
                            Substring1 := CopyStr(Expression, 1, StrPosition - 2);
                            SubString2 := CopyStr(Expression, StrPosition);
                            SubString3 := CopyStr(Expression, StrPosition - 1, 1);
                            if SubString3 = '-' then
                                Expression := InsStr(Substring1 + SubString2, '+' + Format(Abs(CalculatedAmount)), StrPosition - 1)
                            else if SubString3 = '+' then
                                Expression := InsStr(Substring1 + SubString2, '-' + Format(Abs(CalculatedAmount)), StrPosition - 1)
                        end else
                            Expression := InsStr(Expression, Format(CalculatedAmount), StrPosition)
                    end else
                        Expression := InsStr(Expression, Format(0), StrPosition);
                end;
            end;
            StrLength -= 1;
        until StrLength = 0;
    end;

    local procedure CalculateValueOnBasisOfOperator(Number1: Decimal; Number2: Decimal; Opt: Code[20]): Decimal
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

    local procedure CheckPrecedence(Opt: Code[20]): Integer
    begin
        if (Opt = '*') or (Opt = '/') then
            exit(2);
        if (Opt = '+') or (Opt = '-') then
            exit(1);
        exit(0);
    end;

}