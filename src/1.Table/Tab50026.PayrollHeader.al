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
                        NoSeriesMngt.TestManual(PRSetup."Salary Plan No. Series")
                    else if Type = Type::Resignation then
                        NoSeriesMngt.TestManual(PRSetup."Settlement No. Series")
                    else if Type = Type::Adjustment then
                        NoSeriesMngt.TestManual(PRSetup."Payroll Adj No. Series");

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
                    Month := Date2DMY("From Date", 2);

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
        }
        field(8; "Responsibility Center"; Code[10])
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
        field(12; Status; Enum "Attendance Status")
        {

        }
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
        field(17; "From Date (B.S)"; Code[10])
        {
            Editable = false;
        }
        field(18; "To Date (B.S)"; Code[10])
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
        field(21; "Pay Cycle Code"; Code[10])
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
        field(22; "Pay Cycle Term"; Code[10])
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
                    "Posting Date" := Today;//PayCyclePeriod."Pay Date";
                    if PGSetup."Previous Year Payroll Enable" then //Min 7.18.2022
                        CheckDateNotAllowedPrev(PGSetup."Prev Fiscal Year End Date")
                    else
                        CheckDateNotAllowed("Posting Date");
                end;
            end;
        }
        field(24; "Currency Code"; Code[10])
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
        field(29; Type; Enum "Payroll Header Type")
        {

        }
        field(30; "Employee Type"; enum "Employee")
        {

        }
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
            NoSeriesMngt.InitSeries(GetNoSeries, xRec."No. Series", 0D, "No.", "No. Series")
        end;

        InitRecord;
        "Assigned User ID" := UserId;
        "Document Date" := Today;
        PGSetup.Get;
        PGSetup.TestField("HRMS Month");
        if PGSetup."Previous Year Payroll Enable" then //Min 7.18.2022
            ValidatePayCyclesPrev
        else
            ValidatePayCycles;
    end;

    trigger OnRename()
    begin
        Error(Text005, TableCaption);
    end;

    var
        PGSetup: Record "Payroll General Setup";
        AttendanceSetup: Record "Attendance Setup";
        NoSeriesMngt: Codeunit NoSeriesManagement;
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
        PayLine: Record "Payroll Line";
        PayrollEngine: Codeunit "Payroll Engine";
        EncashmentSetup: Record "OT Encashment Setup";

    procedure AssistEdit(xSalaryHeader: Record "Payroll Header"): Boolean
    begin
        PRSetup.Get;
        TestNoSeries;
        if NoSeriesMngt.SelectSeries(GetNoSeries, xSalaryHeader."No. Series", "No. Series") then begin
            PRSetup.Get;
            TestNoSeries;
            NoSeriesMngt.SetSeries("No.");
            exit(true);
        end;
    end;

    procedure TestNoSeries(): Boolean
    begin
        if Type = Type::Payroll then
            PRSetup.TestField("Salary Plan No. Series")
        else if Type = Type::Resignation then
            PRSetup.TestField("Settlement No. Series")
        else if Type = Type::Adjustment then
            PRSetup.TestField("Payroll Adj No. Series");
    end;

    procedure GetNoSeries(): Code[20]
    begin
        if Type = Type::Payroll then
            exit(PRSetup."Salary Plan No. Series")
        else if Type = Type::Resignation then
            exit(PRSetup."Settlement No. Series")
        else if Type = Type::Adjustment then
            exit(PRSetup."Payroll Adj No. Series");
    end;

    procedure InitRecord()
    begin
        if Type = Type::Payroll then
            NoSeriesMngt.SetDefaultSeries("Posting No. Series", PRSetup."Salary Plan Posting No. Series")
        else if Type = Type::Resignation then
            NoSeriesMngt.SetDefaultSeries("Posting No. Series", PRSetup."Settlement Posting No. Series")
        else if Type = Type::Adjustment then
            NoSeriesMngt.SetDefaultSeries("Posting No. Series", PRSetup."Posted Payroll Adj No. Series");
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
            PayrollHeader.TestField(Status, Status::"Pending Approval");
            PayrollLine.Reset;
            PayrollLine.SetRange("Document No.", PayrollHeader."No.");
            //PayrollLine.SETRANGE("Employee No.",'SS0511');//Min Test
            if PayrollLine.FindSet then
                repeat
                    Clear(PayrollEngine);
                    PayrollEngine.InitPayrollLine(PayrollLine);
                until PayrollLine.Next = 0;

            PayrollHeader.Status := PayrollHeader.Status::Released;
            PayrollHeader.Modify;
            PayrollHeader.CalcFields("Total Net Payable");
            /*PayrollBalancingAccount.RESET;
            PayrollBalancingAccount.SETRANGE("Document No.",PayrollHeader."No.");
            PayrollBalancingAccount.DELETEALL;
            PGSetup.GET;
            IF ((PGSetup."Net Payable Account Type" = PGSetup."Net Payable Account Type"::"Bank Account") AND
                (PGSetup."Net Payable Account Code" <> '')) OR
                (PGSetup."Payment Method Code" <> '')
              THEN BEGIN
                CLEAR(PayrollBalancingAccount);
                PayrollBalancingAccount.INIT;
                PayrollBalancingAccount."Document No." := "No.";
                PayrollBalancingAccount."Line No." := 10000;
                PayrollBalancingAccount."Credit Amount" := PayrollHeader."Total Net Payable";
                IF PGSetup."Net Payable Account Type" = PGSetup."Net Payable Account Type"::"Bank Account" THEN
                  PayrollBalancingAccount."Bank Account No." := PGSetup."Net Payable Account Code"
                ELSE IF PGSetup."Payment Method Code" <> '' THEN BEGIN
                  PaymentMethod.GET(PGSetup."Payment Method Code");
                  PaymentMethod.TESTFIELD("Bal. Account Type",PaymentMethod."Bal. Account Type"::"Bank Account");
                  PaymentMethod.TESTFIELD("Bal. Account No.");
                  PayrollBalancingAccount."Bank Account No." := PaymentMethod."Bal. Account No.";
                END;
                PayrollBalancingAccount.INSERT;
            END;*/
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
            //PayrollHeader.TESTFIELD(Status,Status::Open);
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
    begin
        if PayrollHeader.FindFirst then begin
            PayrollLine.Reset;
            PayrollLine.SetRange("Document No.", PayrollHeader."No.");
            if PayrollLine.FindSet then
                repeat
                    PayrollLine."Tax for Period" := 0;
                    PayrollLine."Total Employer Contribution" := 0;
                    PayrollLine."Current Benefit" := 0;
                    PayrollLine."Balance Taxable Income" := 0;
                    PayrollLine."Current Deduction" := 0;
                    PayrollLine."Net Pay" := 0;
                    PayrollLine."1% Slab" := 0;
                    PayrollLine."10% Slab" := 10;
                    PayrollLine."30% Slab" := 0;
                    PayrollLine."36% Slab" := 0;
                    PayrollLine."39% Slab" := 0;
                    PayrollLine."Assessable Income" := 0;
                    PayrollLine.Modify;
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
        //TestField("Employee Type");

        Employee.Reset;
        Employee.SetCurrentKey("Employment Type");
        //Employee.SETFILTER("No.",'PT3265'); //Min For Check
        //Employee.SETFILTER("No.",'%1|%2|%3','MM2154','SP3875','SP3988');
        if Type = Type::Resignation then begin
            Employee.SetRange(Status, Employee.Status::Inactive);
            if "Employee Type" = "Employee Type"::Regular then
                Employee.SetFilter("Resignation Date", '<>%1', 0D)
            else
                Employee.SetFilter("Contract Expiry Date", '>%1', PGSetup."Payroll Fiscal Year Start Date");
        end else
            Employee.SetRange(Status, Employee.Status::Active);
        Employee.SetRange(Settled, false);
        if PayCyclePeriod.Get("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period") then
            Employee.SetFilter("Employment Date", '<>%1', PayCyclePeriod."Pay Date"); //Min
        if "Employee Type" = "Employee Type"::Contract then
            Employee.SetRange("Employment Type", Employee."Employment Type"::Contract);
        // else
        //     Employee.SetFilter("Employment Type", '%1|%2', Employee."Employment Type", Employee."Employment Type"::Probation);
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
                    if AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::Attendance then begin
                        PayrollEngine.GetAttendanceForPayroll(PayrollLine, Rec);
                    end
                    else if AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::"Time Sheet" then begin
                        /* UTS Commented
                        PayrollEngine.PrepareEmployeeDailyTimesheet(PayrollLine,Rec);
                        PayrollEngine.GetTimeSheetForPayroll(PayrollLine,Rec);
                        PayrollEngine.CreateTimeSheetAllocation(PayrollLine,Rec);
                        */
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
            /*IF NOT (Type = Type::Resignation) THEN
              IF NOT Irregular THEN
                PayrollLine.TESTFIELD("Present Days");
            PayrollLine.TESTFIELD("Global Dimension 1 Code");
            PayrollLine.TESTFIELD("Dimension Set ID");
            IF CheckValue THEN BEGIN
              IF PayrollLine."Net Pay" <= 0 THEN
                PayrollLine.FIELDERROR("Net Pay");
            END;*/
            until PayrollLine.Next = 0;
    end;

    procedure CheckHeader()
    begin
        /*CALCFIELDS("Bank Balancing Amount","Total Net Payable");
        IF "Bank Balancing Amount" > 0 THEN BEGIN
          IF "Total Net Payable" <> "Bank Balancing Amount" THEN
            ERROR(NetBalanceInConsistency,"No.","Total Net Payable","Bank Balancing Amount");
        END;*/
    end;

    procedure OpenBalancingAccount()
    begin
        /*PayrollBalancingAccount.RESET;
        PayrollBalancingAccount.FILTERGROUP(2);
        PayrollBalancingAccount.SETRANGE("Document No.","No.");
        PayrollBalancingAccount.FILTERGROUP(0);
        CLEAR(PayrollBalancingAccountList);

        PayrollBalancingAccountList.SETTABLEVIEW(PayrollBalancingAccount);
        PayrollBalancingAccountList.RUNMODAL;*/
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
        PayrollHeader.Validate(Status, PayrollHeader.Status::"Pending Approval");
        PayrollHeader.Modify;
    end;

    local procedure ValidatePayCycles()
    begin
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Start Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        PayCyclePeriod.SetRange("Nepali Month", PGSetup."HRMS Month");
        if PayCyclePeriod.FindFirst then begin
            Validate("Pay Cycle Code", PayCyclePeriod."Pay Cycle Code");
            Validate("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
            Validate("Pay Cycle Period", PayCyclePeriod.Period);
        end;
        Validate("Nepali Month", PGSetup."HRMS Month");
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
                    /*PayrollAttUsage.RESET; //Min 3.20.2022 -- Commented,below inside repeat function code already commented so.
                    PayrollAttUsage.SETRANGE("Employee Code",PayrollLine."Employee No.");*/
                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Code", "Pay Cycle Code");
                    PayCyclePeriod.SetRange("Pay Cycle Term", "Pay Cycle Term");
                    PayCyclePeriod.SetRange(Period, "Pay Cycle Period");
                    if PayCyclePeriod.FindFirst then;
                    GetGlobalAttributes(PayrollLine."Employee No.");
                    /*IF PayrollAttUsage.FINDFIRST THEN REPEAT //Min 3.20.2022 -- Commented,same reason as above.
                      CLEAR(Amt);
                     { Amt := PayrollEngine.ValidateAttributes(PayrollAttUsage.Code,PayrollLine,PayCyclePeriod);
                      IF Amt <> 0 THEN BEGIN
                        PayrollAttUsage.Amount := Amt;
                        PayrollAttUsage.MODIFY;
                      END;}
                    UNTIL PayrollAttUsage.NEXT =0;*/
                end;
            until PayrollLine.Next = 0;
        Message('Attributes Updated.');
    end;

    local procedure GetGlobalAttributes(EmpCode: Code[20])
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
        PayCyclePeriod.SetRange("Nepali Month", PGSetup."HRMS Month");
        if PayCyclePeriod.FindFirst then begin
            Validate("Pay Cycle Code", PayCyclePeriod."Pay Cycle Code");
            Validate("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
            Validate("Pay Cycle Period", PayCyclePeriod.Period);
        end;
        Validate("Nepali Month", PGSetup."HRMS Month");
    end;
}
