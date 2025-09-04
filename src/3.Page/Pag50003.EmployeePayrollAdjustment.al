page 50003 "Employee Payroll Adjustment"
{

    //   -- Added field "Grade Adjustment Code" and "Officiat Basic Adjustment Code" in "Payroll General Setup" Table
    //   -- Purpose --> Filter add for 10% calculation in "Grade" and "Officiat-Basic" Payroll Attribute code in "Payroll Adjustment".

    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Payroll Adjustment";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Attribute Code field.';
                    ApplicationArea = All;
                }
                field("Attributes Description"; Rec."Attributes Description")
                {
                    ToolTip = 'Specifies the value of the Attributes Description field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Load Dashain Bonus")
            {
                Image = GainLossEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Load Dashain Bonus action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    FilterPage: FilterPageBuilder;
                    EmployeeCode: Code[20];
                begin
                    FilterPage.AddRecord('Employee No.', Employee);
                    FilterPage.AddField('Employee No.', Employee."No.");
                    if FilterPage.RunModal() then begin
                        Employee.SetView(FilterPage.GetView('Employee No.'));
                        EmployeeCode := Employee.GetFilter("No.");

                        if EmployeeCode = '' then
                            if not Confirm('No employee is selected. Do you want to generate dashain bonus of all employees?', false) then
                                exit;

                        EmployeePayrollAdjustment.Reset;
                        EmployeePayrollAdjustment.SetRange("Payroll Document No.", PayrollDocNo);
                        EmployeePayrollAdjustment.DeleteAll;

                        PayrollEngine.LoadDashainBonus(EmployeeType::Permanent, PayrollDocNo, EmployeeCode);
                        PayrollEngine.LoadDashainBonus(EmployeeType::Contract, PayrollDocNo, EmployeeCode);
                        CurrPage.Update(true);

                        Message('Dashain bonus calculated successfully.');
                    end;
                end;
            }
            action("Load Leave Fare Allowance")
            {
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Load Leave Fare Allowance action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    EmpType: Enum "Employee Type";
                begin
                    if not Confirm('Do you want to generate leave fare allowance ?', false) then
                        exit;

                    EmployeePayrollAdjustment.Reset;
                    EmployeePayrollAdjustment.SetRange("Payroll Document No.", PayrollDocNo);
                    EmployeePayrollAdjustment.DeleteAll;

                    PayrollEngine.LoadLeaveFareAllowance(EmpType::Permanent, PayrollDocNo);
                    CurrPage.Update(true);

                    Message('Leave fare allowances loaded successfully.');
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.FilterGroup(2);
        PayrollDocNo := Rec.GetFilter("Payroll Document No.");
        Rec.FilterGroup(0);
        Rec."Payroll Document No." := PayrollDocNo;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LWPDays: Integer;
        IsHandled: Boolean;
    begin
        PGSetup.Get;
        Rec.FilterGroup(2);
        PayrollDocNo := Rec.GetFilter("Payroll Document No.");
        Rec.FilterGroup(0);
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", PayrollDocNo);
        PayrollLine.SetCurrentKey("Document No.", "Line No.");
        PayrollLine.DeleteAll;
        if PayrollLine.FindLast then
            LineNo := PayrollLine."Line No." + 10000
        else
            LineNo := 10000;
        PayrollAdj.Reset;
        PayrollAdj.SetRange("Payroll Document No.", PayrollDocNo);
        if PayrollAdj.Find('-') then
            repeat
                RecRefs.Open(Database::"Payroll Line");
                FieldRefs := RecRefs.Field(1);
                FieldRefs.SetRange(PayrollDocNo);
                FieldRefs := RecRefs.Field(3);
                FieldRefs.SetRange(PayrollAdj."Employee No.");
                if not RecRefs.FindFirst then begin
                    RecRefs.Init;
                    FieldRefs := RecRefs.Field(1);
                    FieldRefs.Validate(PayrollDocNo);
                    FieldRefs := RecRefs.Field(2);
                    FieldRefs.Validate(LineNo);
                    FieldRefs := RecRefs.Field(3);
                    FieldRefs.Validate(PayrollAdj."Employee No.");
                    ValidatePayrollLineAmt;
                    OnBeforeInsertPayrollLine(PayrollAdj."Employee No.", LWPDays, IsHandled);
                    if IsHandled then begin
                        FieldRefs := RecRefs.Field(1062);
                        FieldRefs.Validate(LWPDays);
                    end;
                    RecRefs.Insert;
                end else begin
                    ValidatePayrollLineAmt;
                    RecRefs.Modify;
                end;
                LineNo += 10000;
                RecRefs.Close;
            until PayrollAdj.Next = 0;
        CalculateFormulaeAttributes;
        PayrollHeader.Get(PayrollDocNo);
        PayrollHeader.Validate(Status, PayrollHeader.Status::Pending);
        PayrollHeader.Modify;
    end;

    var
        PayrollAdj: Record "Employee Payroll Adjustment";
        PayrollLine: Record "Payroll Line";
        PayrollColumnConfig: Record "Payroll Column Configuration";
        PayrollDocNo: Text;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        LineNo: Integer;
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;
        Employee: Record Employee;
        EmpPayrollAdj: Record "Employee Payroll Adjustment";
        PGSetup: Record "Payroll General Setup";
        PayrollHeader: Record "Payroll Header";
        PayrollEngine: Codeunit "Payroll Engine";
        EmployeeType: enum "Employee Type";
        EmployeePayrollAdjustment: Record "Employee Payroll Adjustment";


    local procedure ValidatePayrollLineAmt()
    begin
        PayrollColumnConfig.Reset;
        PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
        PayrollColumnConfig.SetRange("Variable Field Code", PayrollAdj."Attribute Code");
        if PayrollColumnConfig.FindFirst then begin
            FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
            FieldRefs.Validate(PayrollAdj.Amount);
        end;
    end;

    local procedure CalculateFormulaeAttributes()
    var
        PayrollAttUsage: Record "Payroll Attributes Usage";
        PayrollAttributes1: Record "Payroll Attributes";
        AttributeAmt: Decimal;
        EmpAdjust: Record "Employee Payroll Adjustment";
    begin

        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", PayrollDocNo);
        if PayrollLine.Find('-') then
            repeat
                PayrollAttributes1.Reset;
                PayrollAttributes1.SetFilter(Formula, '<>%1', '');
                Employee.Get(PayrollLine."Employee No.");

                if PayrollAttributes1.Find('-') then
                    repeat
                        PayrollAttUsage.Reset;
                        PayrollAttUsage.SetRange(Code, PayrollAttributes1.Code);
                        PayrollAttUsage.SetRange("Employee Code", PayrollLine."Employee No.");
                        if PayrollAttUsage.FindFirst then begin
                            RecRefs.Open(Database::"Payroll Line");
                            FieldRefs := RecRefs.Field(1);
                            FieldRefs.SetRange(PayrollDocNo);
                            FieldRefs := RecRefs.Field(3);
                            FieldRefs.SetRange(PayrollLine."Employee No.");
                            RecRefs.FindFirst;
                            PayrollColumnConfig.Reset;
                            PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                            PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributes1.Code);
                            AttributeAmt := 0;
                            EmpAdjust.Reset;
                            EmpAdjust.SetRange("Payroll Document No.", PayrollDocNo);
                            EmpAdjust.SetRange("Employee No.", Employee."No.");
                            EmpAdjust.SetRange("Attribute Code", PayrollAttUsage.Code);
                            if not EmpAdjust.FindFirst then begin
                                if PayrollColumnConfig.FindFirst then begin
                                    FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                                    //AttributeAmt := EvaluateAmount(PayrollAttributes1.Formula,FALSE);
                                    if PayrollAttributes1.Subtype in [PayrollAttributes1.Subtype::"Employee Contribution", PayrollAttributes1.Subtype::"Employer Contribution"] then
                                        BasicAdjustmentPF(AttributeAmt);
                                    //IF PayrollAttributes1.Code = 'LFA' THEN
                                    //  CalculateLFA(AttributeAmt);
                                    FieldRefs.Validate(AttributeAmt);
                                end;
                            end;

                            RecRefs.Modify;
                            RecRefs.Close;
                        end;
                    until PayrollAttributes1.Next = 0;
            until PayrollLine.Next = 0;
    end;

    procedure EvaluateAmount(Expression: Code[100]; BasicFromLine: Boolean): Decimal
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

    procedure ResolveColumn(var Expression: Code[100]; BasicFromLine: Boolean)
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributes: Record "Payroll Attributes";
        Substring1: Text;
        SubString2: Text;
        SubString3: Text;
        Length: Integer;
    begin
        Expression := DelChr(Expression, '=');

        StrLength := StrLen(Expression);
        repeat
            if Expression[StrLength] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                      'Y', 'Z'] then begin
                PayrollAttributes.Reset;
                PayrollAttributes.SetRange("Column Name", Format(Expression[StrLength]));
                if PayrollAttributes.FindFirst then begin
                    StrPosition := StrPos(Expression, Format(Expression[StrLength]));
                    Expression := DelStr(Expression, StrPosition, StrLen(Format(Expression[StrLength])));

                    EmpPayrollAdj.Reset;
                    EmpPayrollAdj.SetRange("Payroll Document No.", PayrollDocNo);
                    EmpPayrollAdj.SetRange("Attribute Code", PayrollAttributes.Code);
                    EmpPayrollAdj.SetRange("Employee No.", Employee."No.");
                    if EmpPayrollAdj.FindFirst then begin
                        //IF EmpPayrollAdj.Amount <> 0 THEN           
                        if EmpPayrollAdj.Amount < 0 then begin
                            Length := StrLen(Expression);
                            if StrPosition - 2 < 1 then
                                Substring1 := CopyStr(Expression, 1, 1)
                            else
                                Substring1 := CopyStr(Expression, 1, StrPosition - 2);
                            SubString2 := CopyStr(Expression, StrPosition);
                            SubString3 := CopyStr(Expression, StrPosition - 1, 1);
                            if SubString3 = '-' then
                                Expression := InsStr(Substring1 + SubString2, '+' + Format(Abs(EmpPayrollAdj.Amount)), StrPosition - 1)
                            else if (SubString3 = '+') or (Substring1 = '(') then
                                Expression := InsStr(Substring1 + SubString2, '-' + Format(Abs(EmpPayrollAdj.Amount)), StrPosition - 1)
                        end else
                            Expression := InsStr(Expression, Format(EmpPayrollAdj.Amount), StrPosition)
                    end else
                        Expression := InsStr(Expression, Format(0), StrPosition);
                end;
            end;
            StrLength -= 1;
        until StrLength = 0;
    end;

    local procedure CheckPrecedence(Opt: Code[20]): Integer
    begin
        if (Opt = '*') or (Opt = '/') then
            exit(2);
        if (Opt = '+') or (Opt = '-') then
            exit(1);
        exit(0);
    end;

    local procedure CalculateValue(Number1: Decimal; Number2: Decimal; Opt: Code[20]): Decimal
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

    local procedure BasicAdjustmentPF(var AttributeAmt: Decimal)
    var
        AdjustPFAmt: Decimal;
        EmpPayAdj: Record "Employee Payroll Adjustment";
    begin
        PGSetup.TestField("Basic Adjustment Code");
        EmpPayAdj.Reset;
        EmpPayAdj.SetRange("Employee No.", Employee."No.");
        EmpPayAdj.SetRange("Payroll Document No.", PayrollDocNo);
        EmpPayAdj.SetFilter("Attribute Code", '%1|%2|%3', PGSetup."Basic Adjustment Code", PGSetup."Grade Adjustment Code", PGSetup."Officiat Basic Adjustment Code");
        if EmpPayAdj.FindSet then
            repeat
                AdjustPFAmt := 0.1 * EmpPayAdj.Amount;
                AttributeAmt += AdjustPFAmt;
            until EmpPayAdj.Next = 0;
    end;

    local procedure CalculateLFA(var AttributeAmt: Decimal)
    var
        EmpPayAdj: Record "Employee Payroll Adjustment";
        AdjustPFAmt: Decimal;
    begin
        PGSetup.TestField("Basic Adjustment Code");
        EmpPayAdj.Reset;
        EmpPayAdj.SetRange("Employee No.", Employee."No.");
        EmpPayAdj.SetRange("Payroll Document No.", PayrollDocNo);
        //EmpPayAdj.SetRange("Attribute Code",'');
        if EmpPayAdj.FindFirst then begin
            AdjustPFAmt := EmpPayAdj.Amount;
            AttributeAmt += AdjustPFAmt;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertPayrollLine(EmployeeNo: Code[20]; var LWPDays: Integer; var IsHandled: Boolean)
    begin
        //This event can be used to insert values in the payroll line for the employee before entering the process
        //You can add custom logic here if needed.
    end;
}
