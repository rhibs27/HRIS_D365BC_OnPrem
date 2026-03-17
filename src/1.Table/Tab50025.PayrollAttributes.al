table 50025 "Payroll Attributes"
{
    DrillDownPageId = "Payroll Attributes";
    LookupPageId = "Payroll Attributes";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50]) { }
        field(3; Type; enum "Payroll Type")
        {
            Description = 'Benefits,Deduction,Non-Payment';
        }
        field(4; Subtype; Enum "Payroll SubType")
        {
            Description = ' ,Employer Contribution,Employee Contribution,CIT,Advance,Loan,Basic,Donation,Medical,Tax on Remuneration & Benefits,Social Security Tax,Tax on Interest';
        }
        field(5; "G/L Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Column Name"; Code[20])
        {
            Editable = false;
        }
        field(7; "Column No."; Integer)
        {
            Editable = false;
        }
        field(8; Formula; Code[100])
        {
            trigger OnValidate()
            begin
                CheckFormula(Formula);
            end;
        }
        field(9; "Usage Flexible"; Boolean) { }
        field(10; "Plan Flexible"; Boolean) { }
        field(11; Status; enum "Payroll Status") { }
        field(12; "Apply Every Month"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Apply Every Month" then begin
                    "Pay Cycle Code" := '';
                    "Pay Cycle Period" := 0;
                    "Pay Cycle Term" := '';
                end;
            end;
        }
        field(13; "Deduct on Absent"; Boolean) { }
        field(14; "Non-Taxable"; Boolean) { }
        field(15; "Posting Method"; enum "Payroll Posting Method") { }
        field(16; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(17; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(18; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(19; "Pay Frequency"; Integer) { }
        field(20; "Enable Dimension 2 Code Alloc."; Boolean)
        {
            Caption = 'Enable Dimension 2 Code Allocation';
        }
        field(21; "Delete Amount After Posting"; Boolean)
        {
            Caption = 'Delete Amount on Employee Attribute Usage After Posting';
        }
        field(22; Irregular; Boolean) { }
        field(23; "Employee Type"; Enum "Employee Type") { }
        field(24; "Payroll Type"; Code[20])
        {
            TableRelation = "Mutually Excl. Payroll Group".Type;
        }
        field(25; "Branch Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(26; "No. of Staffs"; Integer)
        {
            CalcFormula = count("Allowance Assignment Line" where("Allowance Type" = field(Code),
                                                                   Code = field("Branch Filter"),
                                                                   "No." = field("Entry No. Filter"), "substitute Type" = Filter(<> "Allowance Substitute"::Substituted)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(27; "No. of Days"; Decimal)
        {
            CalcFormula = sum("Allowance Assignment Line"."No. of Days" where("Allowance Type" = field(Code),
                                                                               Code = field("Branch Filter"),
                                                                               "No." = field("Entry No. Filter")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(28; "Entry No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(29; "Mutually Exclusive"; Boolean) { }
        field(30; "CBS GL Code"; Code[20]) { }
        field(31; "CBS Expense Code"; Code[20]) { }
        field(32; "Tax at once"; Boolean) { }
        field(33; "Finacle GL Name"; Text[100]) { }
        field(34; "Tax Info Report Type"; Enum "Tax Info Report Type") { }
        field(35; "Differential Interest"; Boolean) { }
        field(36; "Column Id"; Integer)
        {
            trigger OnValidate()
            begin
                if xRec."Column Id" <> "Column Id" then begin
                    PayrollAttributes.Reset;
                    PayrollAttributes.SetRange("Column Id", "Column Id");
                    if PayrollAttributes.FindFirst then
                        Error('Column id already exist in %1', PayrollAttributes.Code);
                end;
            end;
        }
        field(37; "Static GL Ledger"; Boolean)
        {
            trigger OnValidate()
            begin
                if not "Static GL Ledger" then
                    Clear("Static GL Ledger Account");
            end;
        }
        field(38; "Static GL Ledger Account"; Code[20]) { }
        field(39; "Activity Type"; enum "Employee Activity Type")
        {
            ValuesAllowed = " ", "Transfer Claim";  //include it in spefiific attribute
        }
        field(40; "Transfer Claim Flexible"; Boolean) { }
        field(41; "Specific Attributes"; Enum "Specific Payroll Attributes") { }
        field(42; "Emplymt. Contract Code"; Code[10])
        {
            Caption = 'Emplymt. Contract Code';
            TableRelation = "Employment Contract";
        }
        field(43; "RF Contribution Type"; Enum "RF Contribution Type")
        {
            Caption = 'RF Contribution Type';
        }
        field(44; "Formula Column ID"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Use Attr. for Home loan GS"; Boolean)
        {
        }
        field(46; "Use Attr. for Vehicle loan GS"; Boolean)
        {
        }
        field(47; "Use Attr. for Salary Adv. GS"; Boolean)
        {
        }
        field(48; "Use Attr. for Home loan EL"; Boolean)
        {
        }
        field(49; "Use Attr. for Vehicle loan EL"; Boolean)
        {
        }
        field(50; "Use Attr. for Salary Adv. EL"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        PayAttUsage.Reset;
        PayAttUsage.SetRange(Code, Code);
        if PayAttUsage.FindFirst then
            Error('Attribute Code Exist in Payroll Attributes Usage');
    end;

    trigger OnInsert()
    var
        PayComp: Record "Payroll Attributes";
        LastColumnName: Code[20];
    begin
        PayComp.Reset;
        PayComp.SetCurrentKey("Column No.");
        if PayComp.FindLast then begin
            LastColumnName := PayComp."Column Name";
            if (StrLen(LastColumnName) = 1) and (LastColumnName <> 'Z') then begin
                if IncStr(LastColumnName) = '' then begin
                    LastColumnName[StrLen(LastColumnName)] := LastColumnName[StrLen(LastColumnName)] + 1;
                end else
                    LastColumnName := IncStr(LastColumnName);
            end
            else if LastColumnName = 'Z' then begin
                LastColumnName := 'AA';
            end
            else begin
                if IncStr(LastColumnName) = '' then begin
                    LastColumnName[StrLen(LastColumnName)] := LastColumnName[StrLen(LastColumnName)] + 1;
                end else
                    LastColumnName := IncStr(LastColumnName);
            end;
            "Column No." := PayComp."Column No." + 1;
        end
        else begin
            LastColumnName := 'A';
            "Column No." := 1;
        end;
        "Column Name" := LastColumnName;
    end;

    var
        PayAttUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";

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
}
