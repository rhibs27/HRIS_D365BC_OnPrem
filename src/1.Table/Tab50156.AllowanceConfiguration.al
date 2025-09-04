table 50156 "Allowance Configuration"
{
    Caption = 'Allowance Configuration';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Payroll Attribute"; Code[20])
        {
            Caption = 'Payroll Attribute';
            TableRelation = "Payroll Attributes";
            trigger OnValidate()
            begin
                if PayrollAttributes.Get("Payroll Attribute") then
                    Description := PayrollAttributes.Description
                else
                    Description := '';
            end;
        }
        field(3; "Employment Type"; Enum "Employee Type")
        {
            Caption = 'Employment Type';
        }
        field(4; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift";
        }
        field(5; "Salary Level"; Code[20])
        {
            Caption = 'Salary Level';
            TableRelation = "Salary Level";
        }
        field(6; "Province Code"; Code[1000])
        {
            Caption = 'Province Code';
            //TableRelation = "Organization Structure List".Code where(Type = const(Province));
        }
        field(7; "Branch Code"; Code[1000])
        {
            Caption = 'Branch Code';
            // TableRelation = "Organization Structure List".Code where(Type = const(Branch));
        }
        field(8; "Department Code"; Code[1000])
        {
            Caption = 'Department Code';
            // TableRelation = "Organization Structure List".Code where(Type = const(Department));
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(10; Description; Text[50])
        {
            Editable = false;
        }
        field(12; "Min Service Yr. Eligibility"; Decimal)
        {

        }
        field(13; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(14; "Earning Cycle"; Enum "Encashment Period")
        {

        }
        field(15; "ATM Site"; Option)
        {
            OptionMembers = " ","On-Site","Off-Site";
        }
        field(16; Source; Option)
        {
            OptionMembers = " ",Assignment,Shift,Leave,Direct;
        }
        field(17; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";
        }
        field(18; Region; Enum Region) { }

        field(19; "Outside/Inside Valley"; enum "Outside/Inside Valley") { }
        field(20; "Remote Area Category"; Code[20])
        {
            TableRelation = "Remote Area Category";
        }
        field(21; Formula; Text[20])
        {

        }
    }
    keys
    {
        key(PK; "Entry No.", "Payroll Attribute")
        {
            Clustered = true;
        }

    }
    trigger OnInsert()
    begin
        "Entry No." := GetNextEntryNo();
    end;

    var
        PayrollAttributes: Record "Payroll Attributes";
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;


    local procedure GetNextEntryNo(): Integer
    var
        AllowanceConfig: Record "Allowance Configuration";
    begin
        AllowanceConfig.SetLoadFields();
        if AllowanceConfig.FindLast() then
            exit(AllowanceConfig."Entry No." + 1)
        else
            exit(1);
    end;

    procedure EvaluateAmountForEmployee(Expression: Code[100]; EmpNo: Code[20]): Decimal
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
        ResolveColumn(Expression, EmpNo);
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

    procedure ResolveColumn(var Expression: Code[100]; EmpCode: Code[20])
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
        Salarylevel: Record "Salary Level";
        Employee: Record Employee;
    begin
        Expression := DelChr(Expression, '=');
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Benefits);
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Basic);
        PayrollAttributes.FindFirst;

        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
        PayrollAttributesUsage.SetRange("Employee Code", EmpCode);
        PayrollAttributesUsage.SetRange(Subtype, PayrollAttributesUsage.Subtype::Basic);
        if PayrollAttributesUsage.FindFirst() then
            BasicAmount := PayrollAttributesUsage.Amount;

        if BasicAmount = 0 then begin
            Employee.Get(EmpCode);
            Salarylevel.Get(Employee."Salary Level");
            BasicAmount := Salarylevel."Basic Salary";
        end;

        CalculateGradeFromGradeEntries(EmpCode, BasicAmount);

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
                    PayrollAttributesUsage.SetRange("Employee Code", EmpCode);
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

    local procedure CheckPrecedence(Opt: Code[20]): Integer
    begin
        if (Opt = '*') or (Opt = '/') then
            exit(2);
        if (Opt = '+') or (Opt = '-') then
            exit(1);
        exit(0);
    end;

    procedure CalculateGradeFromGradeEntries(EmpCode: Code[20]; BasicAmt: Decimal)
    var
        GradeEntry: Record "Grade Entry";
        EmpVar: Record Employee;
        PayrollAttrUses: Record "Payroll Attributes Usage";
    begin
        EmpVar.Get(EmpCode);
        GradeEntry.SetRange("Employee No.", EmpCode);
        GradeEntry.SetRange("Salary Level", EmpVar."Salary Level");
        GradeEntry.CalcSums("Total Grade Percentage");
        PayrollAttrUses.SetRange("Employee Code", EmpCode);
        PayrollAttrUses.SetRange(Subtype, PayrollAttrUses.Subtype::Grade);
        if PayrollAttrUses.FindFirst() then begin
            if (not PayrollAttrUses."Static Amount") or (PayrollAttrUses.Amount = 0) then
                PayrollAttrUses.Validate(Amount, Round(BasicAmt * GradeEntry."Total Grade Percentage" / 100, 0.01, '='));
            PayrollAttrUses.Modify();
        end;
    end;

    procedure CloseRecurringAllowanceAssignment(Empcode: Code[20])
    var
        AllowanceAssignmentline: Record "Allowance Assignment Line";
        AllowanceConfig: Record "Allowance Configuration";
    begin
        AllowanceAssignmentline.SetRange("Employee Code", Empcode);

    end;
}
