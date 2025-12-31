table 50036 "Payroll Attributes Usage"
{
    DataClassification = CustomerContent;
    // version PRM19.01.01

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll Attributes";

            trigger OnValidate()
            begin
                if PayrollAtt.Get(Code) then
                    Validate("Payroll Type", PayrollAtt."Payroll Type")
                else
                    Clear("Payroll Type");
            end;
        }
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; Type; Enum "Payroll Type")
        {
            CalcFormula = lookup("Payroll Attributes".Type where(Code = field(Code)));
            Description = 'Benefits,Deduction,Non-Payment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Subtype; enum "Payroll SubType")
        {
            CalcFormula = lookup("Payroll Attributes".Subtype where(Code = field(Code)));
            Description = ' ,Employer Contribution,Employee Contribution,CIT,Advance,Loan,Basic,Donation,Medical,Tax on Remuneration & Benefits,Social Security Tax,Grade,Add Salary';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Formula Exists"; Boolean)
        {
            CalcFormula = exist("Payroll Attributes" where(Code = field(Code),
                                                            Formula = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; Amount; Decimal)
        {
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                Formula := '';
                CheckFlexibility(Code);
                if PayrollAtt.Get(Code) then begin
                    if PayrollAtt.Type = PayrollAtt.Subtype::"Lump Sum Contribution" then begin
                        DetailedEmployeeLedgEntry.Reset;
                        DetailedEmployeeLedgEntry.SetRange("Employee No.", "Employee Code");
                        DetailedEmployeeLedgEntry.SetRange("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
                        DetailedEmployeeLedgEntry.SetRange("Payroll Attribute Code", Code);
                        if DetailedEmployeeLedgEntry.FindFirst then begin
                            DetailedEmployeeLedgEntry.Disabled := true;
                            DetailedEmployeeLedgEntry.Modify;
                        end;
                    end;
                end;
            end;
        }
        field(7; Description; Text[100]) { }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                if "Global Dimension 2 Code" <> '' then
                    if not Confirm(Text003, false, FieldCaption("Global Dimension 2 Code"), Code, "Employee Code", "Global Dimension 2 Code") then
                        Error('');
            end;
        }
        field(9; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(10; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Period"."Pay Cycle Term" where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(11; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(12; Formula; Code[100])
        {
            trigger OnValidate()
            begin
                Amount := 0;
                CheckFormula(Formula);
            end;
        }
        field(13; "Payroll Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Mutually Excl. Payroll Group".Type;
        }
        field(14; "Is Loan EMI Applicable"; Boolean) { }
        field(15; "Last EMI Date"; Date) { }
        field(16; "Start Date"; Date)
        {
            //Editable = false;
        }
        field(17; "End Date"; Date)
        {
            //Editable = false;
        }
        field(20; "Static Amount"; Boolean)
        {
            //if checked amount will not be replaced on getglobalattribute
        }
        field(21; "Specific Attributes"; enum "Specific Payroll Attributes")
        {
            CalcFormula = lookup("Payroll Attributes"."Specific Attributes" where(Code = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "RF Contribution Type"; Enum "RF Contribution Type")
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(23; Irregular; Boolean)
        {
            CalcFormula = lookup("Payroll Attributes".Irregular where(Code = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code", "Employee Code") { }
    }

    fieldgroups { }

    var
        Text002: Label 'You cannot change %1 on this page. You have to configure it in Payroll Attributes Page.';
        Text003: Label 'If you keep a value in %1, program will ignore dimension allocation for this Attribute while posting Payroll Plan and will 100% allocate %1 %4 for attribute %2 for employee %3. Do you want to continue?';
        PayrollAtt: Record "Payroll Attributes";
        HRMgt: Codeunit "HR Mgt.";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";

    procedure CheckFormula(Formula: Code[80])
    var
        i: Integer;
        ParenthesesLevel: Integer;
        HasOperator: Boolean;
        Text001: Label 'The parenthesis at position %1 is misplaced.';
        Text002: Label 'You cannot have two consecutive operators. The error occurred at position %1.';
        Text003: Label 'There is an operand missing after position %1.';
        Text004: Label 'There are more left parentheses than right parentheses.';
        Text005: Label 'There are more right parentheses than left parentheses.';
    begin
        ParenthesesLevel := 0;
        for i := 1 to StrLen(Formula) do begin
            if Formula[i] = '(' then
                ParenthesesLevel := ParenthesesLevel + 1
            else
                if Formula[i] = ')' then
                    ParenthesesLevel := ParenthesesLevel - 1;
            if ParenthesesLevel < 0 then
                Error(Text001, i);
            if Formula[i] in ['+', '-', '*', '/', '^'] then begin
                if HasOperator then
                    Error(Text002, i)
                else
                    HasOperator := true;
                if i = StrLen(Formula) then
                    Error(Text003, i)
                else
                    if Formula[i + 1] = ')' then
                        Error(Text003, i);
            end else
                HasOperator := false;
        end;
        if ParenthesesLevel > 0 then
            Error(Text004)
        else
            if ParenthesesLevel < 0 then
                Error(Text005);
    end;

    local procedure CheckFlexibility(AttributeCode: Code[20])
    var
        PayrollAttributes: Record "Payroll Attributes";
    begin
        if PayrollAttributes.Get(AttributeCode) then
            if not PayrollAttributes."Usage Flexible" then
                Error(Text002, PayrollAttributes.Code);
    end;

    procedure ValidateAttributes(AttributeAmount: Decimal)
    begin
        Amount := AttributeAmount;
        Modify;
    end;
}
