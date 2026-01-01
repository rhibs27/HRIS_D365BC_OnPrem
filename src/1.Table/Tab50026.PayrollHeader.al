table 50026 "Payroll Header"
{
    DrillDownPageId = "Payroll Plan List";
    LookupPageId = "Payroll Plan List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    PRSetup.Get;
                    if Type = Type::Payroll then
                        NoSeriesCodeunit.TestManual(PRSetup."Salary Plan No. Series")
                    else if Type = Type::Settlement then
                        NoSeriesCodeunit.TestManual(PRSetup."Settlement No. Series")
                    else if Type = Type::Adjustment then
                        NoSeriesCodeunit.TestManual(PRSetup."Payroll Adj No. Series")
                    else if Type = Type::Resignation then
                        NoSeriesCodeunit.TestManual(PRSetup."Resigned Plan No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "From Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ThrowErrorOnLineExist;
                if ("To Date" <> 0D) and ("From Date" <> 0D) then
                    if "From Date" >= "To Date" then
                        Error(Text000, FieldCaption("From Date"), FieldCaption("To Date"), 'greater');
                if "From Date" <> 0D then
                    Month := Enum::"English Month".FromInteger(Date2DMY("From Date", 2));

                "From Date (B.S)" := EngNep.getNepaliDate("From Date");
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
                "Total Days" := 0;
                if ("From Date" <> 0D) and ("To Date" <> 0D) then
                    "Total Days" := "To Date" - "From Date" + 1;

                EngNep.Reset;
                EngNep.SetRange("English Date", "From Date");
                if EngNep.FindFirst then begin
                    "Nepali Month" := EngNep."Nepali Month";
                    "Nepali Year" := EngNep."Nepali Year";
                end;
            end;
        }
        field(3; "To Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ThrowErrorOnLineExist;
                if ("To Date" <> 0D) and ("From Date" <> 0D) then
                    if "From Date" >= "To Date" then
                        Error(Text000, FieldCaption("To Date"), FieldCaption("From Date"), 'lesser');
                "To Date (B.S)" := EngNep.getNepaliDate("To Date");
                "Total Days" := 0;
                if ("From Date" <> 0D) and ("To Date" <> 0D) then
                    "Total Days" := "To Date" - "From Date" + 1;
            end;
        }
        field(4; Month; Enum "English Month")
        {
            Editable = false;
        }
        field(5; Remarks; Text[50]) { }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                PayLine.Reset;
                PayLine.SetRange("Document No.", "No.");
                if PayLine.FindSet then
                    repeat
                        PayLine.Validate("Global Dimension 1 Code", "Global Dimension 1 Code");
                        PayLine.Modify;
                    until PayLine.Next = 0;
            end;
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin
                PayLine.Reset;
                PayLine.SetRange("Document No.", "No.");
                if PayLine.FindSet then
                    repeat
                        PayLine.Validate("Global Dimension 2 Code", "Global Dimension 2 Code");
                        PayLine.Modify;
                    until PayLine.Next = 0;
            end;
        }
        field(8; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(9; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Document Date"; Date) { }
        field(11; "Posting Date"; Date)
        {
            trigger OnValidate()
            begin
                if not (("Posting Date" >= "From Date") and ("Posting Date" <= "To Date")) then
                    Error(Text006, "From Date", "To Date");
                if "Posting Date" > Today then
                    Error('Posting date must be less than today');
            end;
        }
        field(12; Status; enum "Approval Status") { }
        field(13; "Posting No."; Code[20]) { }
        field(14; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; "Posting Description"; Text[50]) { }
        field(16; "Assigned User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(17; "From Date (B.S)"; Code[20])
        {
            Editable = false;
        }
        field(18; "To Date (B.S)"; Code[20])
        {
            Editable = false;
        }
        field(19; "Nepali Month"; Enum "Nepali Month")
        {
            Editable = false;
        }
        field(20; "Nepali Year"; Integer)
        {
            Editable = false;
        }
        field(21; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";

            trigger OnValidate()
            begin
                TestStatusOpen;
                "Pay Cycle Period" := 0;
                "Pay Cycle Term" := '';
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
            end;
        }
        field(22; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                "Pay Cycle Period" := 0;
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
            end;
        }
        field(23; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                TestField("Pay Cycle Code");
                TestField("Pay Cycle Term");
                if PayCyclePeriod.Get("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period") then begin
                    PGSetup.Get;
                    Validate("To Date", 0D);
                    Validate("From Date", 0D);
                    Validate("From Date", PayCyclePeriod."Start Date");
                    Validate("To Date", PayCyclePeriod."End Date");
                    "Posting Date" := PayCyclePeriod."Pay Date";
                    if PGSetup."Previous Year Payroll Enable" then
                        CheckDateNotAllowedPrev(PGSetup."Prev Fiscal Year End Date")
                    else
                        CheckDateNotAllowed("Posting Date");
                end;
            end;
        }
        field(24; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(25; "Total Net Payable"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Payroll Line"."Net Pay" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Total Days"; Integer)
        {
            Editable = false;
        }
        field(27; "Bank Balancing Amount"; Decimal)
        {
            Editable = false;
        }
        field(28; Irregular; Boolean)
        {
            trigger OnValidate()
            var
                PayrollLine: Record "Payroll Line";
            begin
                PayrollLine.Reset;
                PayrollLine.SetRange("Document No.", "No.");
                if PayrollLine.FindSet then
                    repeat
                        PayrollLine.GetPayrollHeader;
                        PayrollLine.ResetValues;
                    until PayrollLine.Next = 0;
            end;
        }
        field(29; Type; Enum "Payroll Header Type") { }
        field(30; "Employee Type"; enum "Employee Type") { }
        field(31; "Gross Payment"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Gross Payment" then
                    TestField(Irregular, true);
            end;
        }
        field(32; Narration; Text[250])
        {
            Width = 100;
        }
        field(33; "Previous Year Payroll"; Boolean) { }
        field(34; "OverTime From"; Date) { }
        field(35; "OverTime To"; Date) { }
        field(36; "Encashment Code"; Code[20])
        {
            TableRelation = "OT Encashment Setup";

            trigger OnValidate()
            begin
                "Encashment Period" := "Encashment Period"::" ";
                "Encashment Description" := '';
            end;
        }
        field(37; "Encashment Period"; Enum "Encashment Period")
        {
            trigger OnValidate()
            begin
                "Encashment Code" := '';
                EncashmentSetup.Reset;
                EncashmentSetup.SetRange(Period, "Encashment Period");
                if EncashmentSetup.FindFirst then
                    repeat
                        "Encashment Description" += '|' + EncashmentSetup."Encashment Code";
                    until EncashmentSetup.Next = 0;
            end;
        }
        field(38; "Encashment Description"; Text[100]) { }
        field(501; "Optimal Deduction"; Boolean) { }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        PRSetup.Get;

        if "No." = '' then begin
            TestNoSeries;
            HrMgt.InitNoSeriesNew(GetNoSeries, xRec."No. Series", 0D, "No.", "No. Series");
            "No." := NoSeriesCodeunit.GetNextNo("No. Series");
        end;

        InitRecord;
        "Assigned User ID" := UserId;
        "Document Date" := Today;
        PGSetup.Get;
        if PGSetup."Previous Year Payroll Enable" then
            ValidatePayCyclesPrev
        else
            ValidatePayCycles;
    end;

    trigger OnRename()
    begin
        Error(Text005, TableCaption);
    end;

    trigger OnDelete()
    begin
        if Status <> Status::Open then begin
            Error(Text009);
        end;
        PayLine.Reset;
        PayLine.SetRange("Document No.", "No.");
        if PayLine.FindSet() then;
        PayLine.DeleteAll;

        //reset payroll tag
        AllowanceAssignmentLine.Reset();
        AllowanceAssignmentLine.SetRange("Payroll Doc No.", "No.");
        if AllowanceAssignmentLine.FindSet() then
            AllowanceAssignmentLine.ModifyAll("Payroll Doc No.", '');
    end;

    var
        PGSetup: Record "Payroll General Setup";
        AttendanceSetup: Record "Attendance Setup";
        NoSeriesCodeunit: Codeunit "No. Series";
        PRSetup: Record "Payroll General Setup";
        UserMgt: Codeunit "User Setup Management";
        EngNep: Record "English-Nepali Date";
        Text000: Label '"%1" cannot be %3 than "%2".';
        Text001: Label 'Salary Plan';
        Text002: Label 'Please delete the existing lines before changing the value in Salary Header.';
        Text003: Label 'Document is now released.';
        Text004: Label 'Reopen the document to modify data.';
        PayCyclePeriod: Record "Pay Cycle Period";
        HideModificationDialog: Boolean;
        Text005: Label 'You cannot rename a %1.';
        Text006: Label 'Posting Date must be within the range %1 and %2.';
        Text007: Label 'is not within your range of allowed posting dates';
        Text008: Label 'Do you want to import employees? Existing lines will be deleted.';
        Text009: Label 'Cannot modify the document as it is not in Open status.';
        PayLine: Record "Payroll Line";
        PayrollEngine: Codeunit "Payroll Engine";
        EncashmentSetup: Record "OT Encashment Setup";
        HrMgt: Codeunit "HR Mgt.";
        AllowanceAssignmentLine: Record "Allowance Assignment Line";

    procedure AssistEdit(xSalaryHeader: Record "Payroll Header"): Boolean
    begin
        PRSetup.Get;
        TestNoSeries;
        if NoSeriesCodeunit.LookupRelatedNoSeries(GetNoSeries, xSalaryHeader."No. Series", "No. Series") then begin
            PRSetup.Get;
            TestNoSeries;
            NoSeriesCodeunit.GetNextNo("No.");
            exit(true);
        end;
    end;

    procedure TestNoSeries(): Boolean
    begin
        if Type = Type::Payroll then
            PRSetup.TestField("Salary Plan No. Series")
        else if Type = Type::Settlement then
            PRSetup.TestField("Settlement No. Series")
        else if Type = Type::Adjustment then
            PRSetup.TestField("Payroll Adj No. Series")
        else if Type = Type::Resignation then
            PRsetup.TestField("Resigned Plan No. Series");
    end;

    procedure GetNoSeries(): Code[20]
    begin
        if Type = Type::Payroll then
            exit(PRSetup."Salary Plan No. Series")
        else if Type = Type::Resignation then
            exit(PRSetup."Resigned Plan No. Series")
        else if Type = Type::Adjustment then
            exit(PRSetup."Payroll Adj No. Series")
        else if Type = Type::Settlement then
            exit(PRSetup."Settlement No. Series");
    end;

    procedure InitRecord()
    begin
        if Type = Type::Payroll then
            HrMgt.SetDefaultSeries("Posting No. Series", PRSetup."Salary Plan Posting No. Series")
        else if Type = Type::Settlement then
            HrMgt.SetDefaultSeries("Posting No. Series", PRSetup."Settlement Posting No. Series")
        else if Type = Type::Adjustment then
            HrMgt.SetDefaultSeries("Posting No. Series", PRSetup."Posted Payroll Adj No. Series")
        else if Type = Type::Resignation then
            HrMgt.SetDefaultSeries("Posting No. Series", PRSetup."Posted ResignedPlan No. Series");
        "Posting Description" := Format(Text001) + ' ' + "No.";
        "Document Date" := Today;
        "Posting Date" := Today;
        "Responsibility Center" := UserMgt.GetRespCenter(0, "Responsibility Center");
    end;

    procedure LineExists(): Boolean
    var
        SalaryLine: Record "Payroll Line";
    begin
        SalaryLine.Reset;
        SalaryLine.SetRange("Document No.", "No.");
        if SalaryLine.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    procedure CalculatePayroll(var PayrollHeader: Record "Payroll Header")
    var
        PayrollLine: Record "Payroll Line";
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        if PayrollHeader.FindFirst then begin
            PayrollHeader.TestField(Status, Status::Pending);
            PayrollLine.Reset;
            PayrollLine.SetRange("Document No.", PayrollHeader."No.");
            if PayrollLine.FindSet then
                repeat
                    Clear(PayrollEngine);
                    PayrollEngine.InitPayrollLine(PayrollLine);
                until PayrollLine.Next = 0;

            PayrollHeader.Status := PayrollHeader.Status::Released;
            PayrollHeader.Modify;
            PayrollHeader.CalcFields("Total Net Payable");

            if not HideModificationDialog then
                Message(Text003);
        end;
    end;

    procedure GetDetails(var PayrollHeader: Record "Payroll Header")
    var
        PayrollLine: Record "Payroll Line";
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        if PayrollHeader.FindFirst then begin
            //PayrollHeader.TestField(Status,Status::Open);
            PayrollLine.Reset;
            PayrollLine.SetRange("Document No.", PayrollHeader."No.");
            if PayrollLine.FindSet then
                repeat
                    Clear(PayrollEngine);
                    PayrollLine.ValidateEmployee;
                until PayrollLine.Next = 0;
        end;
        Message('Get Attributes Updated.');
    end;

    procedure ReOpenDocument(var PayrollHeader: Record "Payroll Header")
    var
        PayrollLine: Record "Payroll Line";
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        RecRef: RecordRef;
    begin
        if PayrollHeader.FindFirst then begin
            PayrollLine.Reset;
            PayrollLine.SetRange("Document No.", PayrollHeader."No.");
            if PayrollLine.FindSet then
                repeat
                    PayrollLine."Actual RF Contribution" := 0;
                    PayrollLine."Assessable Income" := 0;
                    PayrollLine."Basic Salary" := 0;
                    PayrollLine."Current Benefit" := 0;
                    PayrollLine."Current Deduction" := 0;
                    PayrollLine."Current Non-Payments" := 0;
                    PayrollLine."Eligible RF Deduction" := 0;
                    PayrollLine."Female Tax Credit" := 0;
                    PayrollLine."Gratuity & leave Encash Tax" := 0;
                    PayrollLine."Health Insurance Premium" := 0;
                    PayrollLine."Life Insurance Premium" := 0;
                    PayrollLine."Net Pay" := 0;
                    PayrollLine."Net Tax Liability" := 0;
                    PayrollLine."Past Benefit" := 0;
                    PayrollLine."Past Non-Payments" := 0;
                    PayrollLine."Past Retirement Fund" := 0;
                    PayrollLine."Payable Tax Liability" := 0;
                    PayrollLine."Projected Benefit" := 0;
                    PayrollLine."Projected Non-Payments" := 0;
                    PayrollLine."Projected Retirement Fund" := 0;
                    PayrollLine."Social Security Tax(Annual)" := 0;
                    PayrollLine."Tax for Period" := 0;
                    PayrollLine."Taxable Income" := 0;
                    PayrollLine."Tax on Remuneration(Annual)" := 0;
                    PayrollLine."Total Employer Contribution" := 0;
                    PayrollLine."Total Insurance Claim Amount" := 0;
                    PayrollLine."Total SST Paid" := 0;
                    PayrollLine."Total Tax Credit" := 0;
                    PayrollLine."Total Tax Liability" := 0;
                    PayrollLine."Total Tax Paid" := 0;
                    PayrollLine."Total Tax Remuneration Paid" := 0;
                    PayrollLine."1% Slab" := 0;
                    PayrollLine."10% Slab" := 0;
                    PayrollLine."20% Slab" := 0;
                    PayrollLine."30% Slab" := 0;
                    PayrollLine."36% Slab" := 0;
                    PayrollLine."39% Slab" := 0;
                    PayrollLine.Modify;
                    PayrollAttributes.Reset();
                    PayrollAttributes.SetFilter(Subtype, '%1|%2', PayrollAttributes.Subtype::"Social Security Tax", PayrollAttributes.Subtype::"Tax on Remuneration & Benefits");
                    if PayrollAttributes.findset then
                        repeat
                            PayrollColumnConfiguration.Reset;
                            PayrollColumnConfiguration.SetRange("Variable Field Code", PayrollAttributes.Code);
                            if PayrollColumnConfiguration.FindFirst then begin
                                RecRef.GetTable(PayrollLine);
                                RecRef.Field(PayrollColumnConfiguration."Field No.").Validate(0);
                                RecRef.Modify;
                            end;
                        until PayrollAttributes.Next() = 0;
                until PayrollLine.Next = 0;
            Status := Status::Open;
            Modify;
        end;
    end;

    procedure SetHideModificationDialog(NewHideModificationDialog: Boolean)
    begin
        HideModificationDialog := NewHideModificationDialog;
    end;

    procedure TestStatusOpen()
    begin
        if not HideModificationDialog then
            if Status <> Status::Open then
                Error(Text004);
    end;

    local procedure ThrowErrorOnLineExist()
    begin
        if LineExists then
            Error(Text002)
    end;

    procedure CheckDateNotAllowed(PostingDate: Date): Boolean
    begin
        PRSetup.Get;
        if not ((PostingDate >= PRSetup."Payroll Fiscal Year Start Date") and (PostingDate <= PRSetup."Payroll Fiscal Year End Date")) then
            FieldError("Posting Date", Text007);
    end;

    procedure ReleaseDocument()
    begin
        Status := Status::Released;
        Modify;
    end;

    procedure ImportEmployee()
    var
        PayrollLine: Record "Payroll Line";
        Employee: Record Employee;
        PayrollEngine: Codeunit "Payroll Engine";
        LineNo: Integer;
    begin
        if not HideModificationDialog then
            if not Confirm(Text008, false) then
                exit;
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", "No.");
        PayrollLine.DeleteAll;

        PGSetup.Get;
        AttendanceSetup.Get;

        Employee.Reset;
        Employee.SetCurrentKey("Employment Type");
        Employee.SetRange("Do not Calculate Salary", false);
        if Type = Type::Settlement then begin
            Employee.SetRange(Status, Employee.Status::Inactive);
            if "Employee Type" = "Employee Type"::Permanent then
                Employee.SetFilter("Resignation Date", '<>%1', 0D)
            else
                Employee.SetFilter("Contract Expiry Date", '>%1', PGSetup."Payroll Fiscal Year Start Date");
        end else begin
            Employee.SetRange(Status, Employee.Status::Active);
            Employee.SetFilter("Resignation Date", '%1|>%2', 0D, "To Date");
        end;
        if Type = Type::Resignation then begin
            // Employee.Setfilter(Status, '%1|%2', Employee.Status::Active, Employee.Status::Terminated);
            Employee.SetRange("Resignation Date", "From Date", "To Date");
        end;
        Employee.SetRange(Settled, false);
        if PayCyclePeriod.Get("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period") then
            Employee.SetFilter("Employment Date", '<%1', PayCyclePeriod."Pay Date");
        if "Employee Type" <> "Employee Type"::" " then
            Employee.SetRange("Employment Type", "Employee Type");
        if Employee.FindSet then
            repeat
                if PayrollEngine.IsValidEmployee(Employee, "From Date", "To Date") then begin
                    PayrollLine.Init;
                    PayrollLine."Document No." := "No.";
                    PayrollLine."Line No." := LineNo + 10000;
                    PayrollLine.Validate("Employee No.", Employee."No.");
                    PayrollLine.Validate("Functional Title", Employee."Functional Title");
                    PayrollLine.Validate("Employee Type", Employee."Employment Type");
                    PayrollLine.Validate("Bank Account No.", Employee."Bank Account No.");
                    PayrollLine.Validate("Resignation Date", Employee."Resignation Date");
                    if AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::Attendance then begin
                        PayrollEngine.GetAttendanceForPayroll(PayrollLine, Rec);
                    end
                    else if AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::"Time Sheet" then begin
                        // PayrollEngine.GetTimeSheetForPayroll(PayrollLine, Rec);
                    end;
                    PayrollLine.Insert(true);
                    LineNo += 10000;
                end;
            until Employee.Next = 0;
    end;

    procedure CheckLines(CheckValue: Boolean)
    var
        PayrollLine: Record "Payroll Line";
    begin
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", "No.");
        if PayrollLine.FindSet then
            repeat
                PayrollLine.TestField("Employee No.");
            until PayrollLine.Next = 0;
    end;

    procedure UpdatePayrollAttributeUsage(PayrollHeader: Record "Payroll Header")
    var
        PayrollLine: Record "Payroll Line";
        PayrollAttributeUsage: Record "Payroll Attributes Usage";
        Amount: Decimal;
        PayrollAttributes: Record "Payroll Attributes";
    begin
        PayrollHeader.TestField(Status, PayrollHeader.Status::Open);
        PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period");
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", PayrollHeader."No.");
        if PayrollLine.FindFirst then
            repeat
                PayrollAttributeUsage.Reset;
                PayrollAttributeUsage.SetRange("Employee Code", PayrollLine."Employee No.");
                if PayrollAttributeUsage.FindSet then
                    repeat
                        Clear(Amount);
                        if PayrollAttributes.Get(PayrollAttributeUsage.Code) then
                            if PayrollAttributes."Apply Every Month" then
                                Amount := PayrollEngine.ValidateAttributes(PayrollAttributeUsage.Code, PayrollLine, PayCyclePeriod);
                        if Amount <> 0 then
                            PayrollAttributeUsage.ValidateAttributes(Amount);
                    until PayrollAttributeUsage.Next = 0;
            until PayrollLine.Next = 0;
        PayrollHeader.Validate(Status, PayrollHeader.Status::Pending);
        PayrollHeader.Modify;
    end;

    local procedure ValidatePayCycles()
    begin
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Start Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if PayCyclePeriod.FindFirst then begin
            Validate("Pay Cycle Code", PayCyclePeriod."Pay Cycle Code");
            Validate("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
        end;
    end;

    procedure UpdatePayrollAttributes(PayrollHdr: Record "Payroll Header")
    var
        PayrollLine: Record "Payroll Line";
    begin
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", PayrollHdr."No.");
        if PayrollLine.FindSet then
            repeat
                PayrollEngine.InsertPayrollAttributesUsage(PayrollLine."Employee No.");
                if Type = Type::Adjustment then begin
                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Code", "Pay Cycle Code");
                    PayCyclePeriod.SetRange("Pay Cycle Term", "Pay Cycle Term");
                    PayCyclePeriod.SetRange(Period, "Pay Cycle Period");
                    if PayCyclePeriod.FindFirst then;
                    GetGlobalAttributes(PayrollLine."Employee No.");
                end;
            until PayrollLine.Next = 0;
        Message('Attributes Updated.');
    end;

    local procedure GetGlobalAttributes(EmpCode: Code[20])  //this should be go into get attribute
    var
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        AttributeAmount: Decimal;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PayrollAttributes: Record "Payroll Attributes";
        Employee: Record Employee;
        PayrollAttUsage: Record "Payroll Attributes Usage";
    begin
        Employee.Get(EmpCode);
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
                        PayrollAttUsage.Reset;
                        PayrollAttUsage.SetRange(Code, PayrollAttributes.Code);
                        PayrollAttUsage.SetRange("Employee Code", EmpCode);
                        if PayrollAttUsage.FindFirst then begin
                            if AttributeAmount <> 0 then
                                if not PayrollAttUsage."Static Amount" then
                                    PayrollAttUsage.Amount := AttributeAmount;
                            PayrollAttUsage.Modify;
                        end;
                    end;
                end;
            until PayrollColumnConfiguration.Next = 0;
        end;
    end;

    procedure CheckDateNotAllowedPrev(PostingDate: Date): Boolean
    begin
        PRSetup.Get;
        if not ((PostingDate >= PRSetup."Prev Fiscal Year Start Date") and (PostingDate <= PRSetup."Prev Fiscal Year End Date")) then
            FieldError("Posting Date", Text007);
    end;

    local procedure ValidatePayCyclesPrev()
    begin
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Start Date", PGSetup."Prev Fiscal Year Start Date", PGSetup."Prev Fiscal Year End Date");
        if PayCyclePeriod.FindFirst then begin
            Validate("Pay Cycle Code", PayCyclePeriod."Pay Cycle Code");
            Validate("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
        end;
    end;
}
