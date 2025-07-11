//This codeunit is used to store payroll calculation for reports
//It contains complex payroll projection calculation without using payroll lines
//Temperrory table of Dateiled employee ledger entry is used to store the data.
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

            exit(EvaluateAmount(SkipOneTimeAttr(PayAttr.Formula), BasicAmt))
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

    //     procedure ShowHidePayrollComponent(
    //      var Field50501Visible: Boolean;
    //   var Field50502Visible: Boolean;
    //   var Field50503Visible: Boolean;
    //   var Field50504Visible: Boolean;
    //   var Field50505Visible: Boolean;
    //   var Field50506Visible: Boolean;
    //   var Field50507Visible: Boolean;
    //   var Field50508Visible: Boolean;
    //   var Field50509Visible: Boolean;
    //   var Field50510Visible: Boolean;
    //   var Field50511Visible: Boolean;
    //   var Field50512Visible: Boolean;
    //   var Field50513Visible: Boolean;
    //   var Field50514Visible: Boolean;
    //   var Field50515Visible: Boolean;
    //   var Field50516Visible: Boolean;
    //   var Field50517Visible: Boolean;
    //   var Field50518Visible: Boolean;
    //   var Field50519Visible: Boolean;
    //   var Field50520Visible: Boolean;
    //   var Field50521Visible: Boolean;
    //   var Field50522Visible: Boolean;
    //   var Field50523Visible: Boolean;
    //   var Field50524Visible: Boolean;
    //   var Field50525Visible: Boolean;
    //   var Field50526Visible: Boolean;
    //   var Field50527Visible: Boolean;
    //   var Field50528Visible: Boolean;
    //   var Field50529Visible: Boolean;
    //   var Field50530Visible: Boolean;
    //   var Field50531Visible: Boolean;
    //   var Field50532Visible: Boolean;
    //   var Field50533Visible: Boolean;
    //   var Field50534Visible: Boolean;
    //   var Field50535Visible: Boolean;
    //   var Field50536Visible: Boolean;
    //   var Field50537Visible: Boolean;
    //   var Field50538Visible: Boolean;
    //   var Field50539Visible: Boolean;
    //   var Field50540Visible: Boolean;
    //   var Field50541Visible: Boolean;
    //   var Field50542Visible: Boolean;
    //   var Field50543Visible: Boolean;
    //   var Field50544Visible: Boolean;
    //   var Field50545Visible: Boolean;
    //   var Field50546Visible: Boolean;
    //   var Field50547Visible: Boolean;
    //   var Field50548Visible: Boolean;
    //   var Field50549Visible: Boolean;
    //   var Field50550Visible: Boolean;
    //   var Field50551Visible: Boolean;
    //   var Field50552Visible: Boolean;
    //   var Field50553Visible: Boolean;
    //   var Field50554Visible: Boolean;
    //   var Field50555Visible: Boolean;
    //   var Field50556Visible: Boolean;
    //   var Field50557Visible: Boolean;
    //   var Field50558Visible: Boolean;
    //   var Field50559Visible: Boolean;
    //   var Field50560Visible: Boolean;
    //   var Field50561Visible: Boolean;
    //   var Field50562Visible: Boolean;
    //   var Field50563Visible: Boolean;
    //   var Field50564Visible: Boolean;
    //   var Field50565Visible: Boolean;
    //   var Field50566Visible: Boolean;
    //   var Field50567Visible: Boolean;
    //   var Field50568Visible: Boolean;
    //   var Field50569Visible: Boolean;
    //   var Field50570Visible: Boolean;
    //   var Field50571Visible: Boolean;
    //   var Field50572Visible: Boolean;
    //   var Field50573Visible: Boolean;
    //   var Field50574Visible: Boolean;
    //   var Field50575Visible: Boolean;
    //   var Field50576Visible: Boolean;
    //   var Field50577Visible: Boolean;
    //   var Field50578Visible: Boolean;
    //   var Field50579Visible: Boolean;
    //   var Field50580Visible: Boolean;
    //   var Field50581Visible: Boolean;
    //   var Field50582Visible: Boolean;
    //   var Field50583Visible: Boolean;
    //   var Field50584Visible: Boolean;
    //   var Field50585Visible: Boolean;
    //   var Field50586Visible: Boolean;
    //   var Field50587Visible: Boolean;
    //   var Field50588Visible: Boolean;
    //   var Field50589Visible: Boolean;
    //   var Field50590Visible: Boolean;
    //   var Field50591Visible: Boolean;
    //   var Field50592Visible: Boolean;
    //   var Field50593Visible: Boolean;
    //   var Field50594Visible: Boolean;
    //   var Field50595Visible: Boolean;
    //   var Field50596Visible: Boolean;
    //   var Field50597Visible: Boolean;
    //   var Field50598Visible: Boolean;
    //   var Field50599Visible: Boolean;
    //   var Field50600Visible: Boolean;
    //   var Field50601Visible: Boolean;
    //   var Field50602Visible: Boolean;
    //   var Field50603Visible: Boolean;
    //   var Field50604Visible: Boolean;
    //   var Field50605Visible: Boolean;
    //   var Field50606Visible: Boolean;
    //   var Field50607Visible: Boolean;
    //   var Field50608Visible: Boolean;
    //   var Field50609Visible: Boolean;
    //   var Field50610Visible: Boolean;
    //   var Field50611Visible: Boolean;
    //   var Field50612Visible: Boolean;
    //   var Field50613Visible: Boolean;
    //   var Field50614Visible: Boolean;
    //   var Field50615Visible: Boolean;
    //   var Field50616Visible: Boolean;
    //   var Field50617Visible: Boolean;
    //   var Field50618Visible: Boolean;
    //   var Field50619Visible: Boolean;
    //   var Field50620Visible: Boolean;
    //   var Field50621Visible: Boolean;
    //   var Field50622Visible: Boolean;
    //   var Field50623Visible: Boolean;
    //   var Field50624Visible: Boolean;
    //   var Field50625Visible: Boolean;
    //   var Field50626Visible: Boolean;
    //   var Field50627Visible: Boolean;
    //   var Field50628Visible: Boolean;
    //   var Field50629Visible: Boolean;
    //   var Field50630Visible: Boolean;
    //   var Field50631Visible: Boolean;
    //   var Field50632Visible: Boolean;
    //   var Field50633Visible: Boolean;
    //   var Field50634Visible: Boolean;
    //   var Field50635Visible: Boolean;
    //   var Field50636Visible: Boolean;
    //   var Field50637Visible: Boolean;
    //   var Field50638Visible: Boolean;
    //   var Field50639Visible: Boolean;
    //   var Field50640Visible: Boolean;
    //   var Field50641Visible: Boolean;
    //   var Field50642Visible: Boolean;
    //   var Field50643Visible: Boolean;
    //   var Field50644Visible: Boolean;
    //   var Field50645Visible: Boolean;
    //   var Field50646Visible: Boolean;
    //   var Field50647Visible: Boolean;
    //   var Field50648Visible: Boolean;
    //   var Field50649Visible: Boolean;
    //   var Field50650Visible: Boolean;
    //   var Field50651Visible: Boolean;
    //      var Field50652Visible: Boolean;
    //        var Field50653Visible: Boolean;
    //      var Field50654Visible: Boolean;
    //        var Field50655Visible: Boolean;
    //     var Field50656Visible: Boolean;
    //        var Field50657Visible: Boolean;
    //      var Field50658Visible: Boolean;
    //     var Field50659Visible: Boolean;
    //     var Field50660Visible: Boolean;
    //     var Field50661Visible: Boolean;
    //     var Field50662Visible: Boolean;
    //     var Field50663Visible: Boolean;
    //     var Field50664Visible: Boolean;
    //     var Field50665Visible: Boolean;
    //     var Field50666Visible: Boolean;
    //     var Field50667Visible: Boolean;
    //     var Field50668Visible: Boolean;
    //     var Field50669Visible: Boolean;
    //     var Field50670Visible: Boolean;
    //     var Field50671Visible: Boolean;
    //     var Field50672Visible: Boolean;
    //     var Field50673Visible: Boolean;
    //     var Field50674Visible: Boolean;
    //     var Field50675Visible: Boolean;
    //     var Field50676Visible: Boolean;
    //     var Field50677Visible: Boolean;
    //     var Field50678Visible: Boolean;
    //     var Field50679Visible: Boolean;
    //     var Field50680Visible: Boolean;
    //     var Field50681Visible: Boolean;
    //       var Field50682Visible: Boolean;
    //        var Field50683Visible: Boolean;
    //        var Field50684Visible: Boolean;
    //        var Field50685Visible: Boolean;
    //        var Field50686Visible: Boolean;
    //        var Field50687Visible: Boolean;
    //        var Field50688Visible: Boolean;
    //      var Field50689Visible: Boolean;
    //     var Field50690Visible: Boolean

    //   )
    //     var
    //         PayrollLineP: Record "Payroll Line";
    //     begin
    //         Field50501Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50501"));
    //         Field50502Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50502"));
    //         Field50503Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50503"));
    //         Field50504Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50504"));
    //         Field50505Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50505"));
    //         Field50506Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50506"));
    //         Field50507Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50507"));
    //         Field50508Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50508"));
    //         Field50509Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50509"));
    //         Field50510Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50510"));
    //         Field50511Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50511"));
    //         Field50512Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50512"));
    //         Field50513Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50513"));
    //         Field50514Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50514"));
    //         Field50515Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50515"));
    //         Field50516Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50516"));
    //         Field50517Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50517"));
    //         Field50518Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50518"));
    //         Field50519Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50519"));
    //         Field50520Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50520"));
    //         Field50521Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50521"));
    //         Field50522Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50522"));
    //         Field50523Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50523"));
    //         Field50524Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50524"));
    //         Field50525Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50525"));
    //         Field50526Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50526"));
    //         Field50527Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50527"));
    //         Field50528Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50528"));
    //         Field50529Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50529"));
    //         Field50530Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50530"));
    //         Field50531Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50531"));
    //         Field50532Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50532"));
    //         Field50533Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50533"));
    //         Field50534Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50534"));
    //         Field50535Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50535"));
    //         Field50536Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50536"));
    //         Field50537Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50537"));
    //         Field50538Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50538"));
    //         Field50539Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50539"));
    //         Field50540Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50540"));

    //         Field50541Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50541"));
    //         Field50542Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50542"));
    //         Field50543Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50543"));
    //         Field50544Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50544"));
    //         Field50545Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50545"));
    //         Field50546Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50546"));
    //         Field50547Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50547"));
    //         Field50548Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50548"));
    //         Field50549Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50549"));
    //         Field50550Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50550"));
    //         Field50551Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50551"));
    //         Field50552Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50552"));
    //         Field50553Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50553"));
    //         Field50554Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50554"));
    //         Field50555Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50555"));
    //         Field50556Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50556"));
    //         Field50557Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50557"));
    //         Field50558Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50558"));
    //         Field50559Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50559"));
    //         Field50560Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50560"));
    //         Field50561Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50561"));
    //         Field50562Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50562"));
    //         Field50563Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50563"));
    //         Field50564Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50564"));
    //         Field50565Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50565"));
    //         Field50566Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50566"));
    //         Field50567Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50567"));
    //         Field50568Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50568"));
    //         Field50569Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50569"));
    //         Field50570Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50570"));
    //         Field50571Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50571"));
    //         Field50572Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50572"));
    //         Field50573Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50573"));
    //         Field50574Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50574"));
    //         Field50575Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50575"));
    //         Field50576Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50576"));
    //         Field50577Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50577"));
    //         Field50578Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50578"));
    //         Field50579Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50579"));

    //         Field50580Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50580"));
    //         Field50581Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50581"));
    //         Field50582Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50582"));
    //         Field50583Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50583"));
    //         Field50584Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50584"));
    //         Field50585Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50585"));
    //         Field50586Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50586"));
    //         Field50587Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50587"));
    //         Field50588Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50588"));
    //         Field50589Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50589"));

    //         Field50590Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50590"));
    //         Field50591Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50591"));
    //         Field50592Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50592"));
    //         Field50593Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50593"));
    //         Field50594Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50594"));
    //         Field50595Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50595"));
    //         Field50596Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50596"));
    //         Field50597Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50597"));
    //         Field50598Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50598"));
    //         Field50599Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50599"));

    //         Field50600Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50600"));
    //         Field50601Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50601"));
    //         Field50602Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50602"));
    //         Field50603Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50603"));
    //         Field50604Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50604"));
    //         Field50605Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50605"));
    //         Field50606Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50606"));
    //         Field50607Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50607"));
    //         Field50608Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50608"));
    //         Field50609Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50609"));

    //         Field50610Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50610"));
    //         Field50611Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50611"));
    //         Field50612Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50612"));
    //         Field50613Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50613"));
    //         Field50614Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50614"));
    //         Field50615Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50615"));
    //         Field50616Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50616"));
    //         Field50617Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50617"));
    //         Field50618Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50618"));
    //         Field50619Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50619"));

    //         Field50620Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50620"));
    //         Field50621Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50621"));
    //         Field50622Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50622"));
    //         Field50623Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50623"));
    //         Field50624Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50624"));
    //         Field50625Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50625"));
    //         Field50626Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50626"));
    //         Field50627Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50627"));
    //         Field50628Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50628"));
    //         Field50629Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50629"));

    //         Field50630Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50630"));
    //         Field50631Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50631"));
    //         Field50632Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50632"));
    //         Field50633Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50633"));
    //         Field50634Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50634"));
    //         Field50635Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50635"));
    //         Field50636Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50636"));
    //         Field50637Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50637"));
    //         Field50638Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50638"));
    //         Field50639Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50639"));

    //         Field50640Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50640"));
    //         Field50641Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50641"));
    //         Field50642Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50642"));
    //         Field50643Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50643"));
    //         Field50644Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50644"));
    //         Field50645Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50645"));
    //         Field50646Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50646"));
    //         Field50647Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50647"));
    //         Field50648Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50648"));
    //         Field50649Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50649"));
    //         Field50650Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50650"));

    //         Field50651Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50651"));
    //         Field50652Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50652"));
    //         Field50653Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50653"));
    //         Field50654Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50654"));
    //         Field50655Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50655"));
    //         Field50656Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50656"));
    //         Field50657Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50657"));
    //         Field50658Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50658"));
    //         Field50659Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50659"));
    //         Field50660Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50660"));
    //         Field50661Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50661"));
    //         Field50662Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50662"));
    //         Field50663Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50663"));
    //         Field50664Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50664"));
    //         Field50665Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50665"));
    //         Field50666Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50666"));
    //         Field50667Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50667"));
    //         Field50668Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50668"));
    //         Field50669Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50669"));
    //         Field50670Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50670"));
    //         Field50671Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50671"));
    //         Field50672Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50672"));
    //         Field50673Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50673"));
    //         Field50674Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50674"));
    //         Field50675Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50675"));
    //         Field50676Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50676"));
    //         Field50677Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50677"));
    //         Field50678Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50678"));
    //         Field50679Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50679"));
    //         Field50680Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50680"));
    //         Field50681Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50681"));
    //         Field50682Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50682"));
    //         Field50683Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50683"));
    //         Field50684Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50684"));
    //         Field50685Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50685"));
    //         Field50686Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50686"));
    //         Field50687Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50687"));
    //         Field50688Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50688"));
    //         Field50689Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50689"));
    //         Field50690Visible := ShowColumn(Database::"Payroll Line", PayrollLineP.FieldNo("Variable Field 50690"));
    //     end;

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
                                        var TotalRetirement: Decimal)
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
            // RemainingMonth := GetLastPayCycle(EmpCode,PayCycleTerm) - DetailedEmpLedgerEntry."Pay Cycle Period"
        end
        else begin
            CreateTempDetailedLedgerFromPAttrUsage(1, PayCycleTerm, EmpCode, LastEntryNo, TempDetailedEmpLedgerEntry);
            // RemainingMonth := GetLastPayCycle(EmpCode,PayCycleTerm);
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


        PgSetup.Get();
        Employee.Reset;
        Employee.SetRange("No.", EmpCode);
        Employee.SetFilter("Date Filter", '%1..%2', PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        Employee.FindFirst;
        Employee.CalcFields("Total Earning", "Total Retirement Contribution", "Total Donation Contribution",
                "Total Medical Re-Imbursement", "Social Security Tax", "Remuneration & Benefits Tax", "PF Contribution");

        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Type", '%1|%2', TempDetailedEmpLedgerEntry."Attribute Type"::"Basic Earning", TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings");
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalAnnualEarning := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total Benefit Opening";

        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::Deduction);
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Sub Type", '%1|%2|%3',
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employer Contribution",
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::CIT,
                                        TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employee Contribution");

        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalRetirement := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total RF Opening";


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

            if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
                exit(true);

            if PayrollAtr."Apply Every Month" then
                exit(true);

            if (PayrollAtr.Type = PayrollAtr.Type::Deduction) then begin

                if PayrollAtr.Subtype in [PayrollAtr.Subtype::"Social Security Tax", PayrollAtr.Subtype::"Tax on Remuneration & Benefits"] then
                    exit(true);

                exit(false);
            end;
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

        for i := StartPeriod to GetLastPayCycle(EmpCode, PayCycleTerm) do begin
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
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings";
                        TempDetailedEmpLedgerEntry."Attribute Sub Type" := PayAttr.Subtype;

                        // TempDetailedEmpLedgerEntry."Specific Component" := PayAttr."Specific Component";
                        // TempDetailedEmpLedgerEntry."Pension Specific" := PayAttr."Pension Specific";
                        // TempDetailedEmpLedgerEntry."Settlement Specific" := PayAttr."Settlement Specific";
                        TempDetailedEmpLedgerEntry."Non-Taxable" := PayAttr."Non-Taxable";
                        TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                        TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                        TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;
                        TempDetailedEmpLedgerEntry.Amount := PayrollAttrUsage.Amount;
                        if PayrollAttrUsage."Formula Exists" then begin

                            TempDetailedEmpLedgerEntry.Amount := getAttributeAmount(EmpCode, PayrollAttrUsage.Code);
                        end;

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
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Payroll Attribute Code", attrCode);
        exit(TempDetailedEmpLedgerEntry.Count);
    end;


    // Returns the last pay cycle period for the given employee code and pay cycle term. (last salary posted month for employee)
    procedure GetLastPayCycle(empCode: Code[20]; PayCycleTerm: Code[20]): Integer
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
}
