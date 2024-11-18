table 50039 "Payroll Journal Line"
{
    DataClassification = CustomerContent;
    // version PRM19.01.01


    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Account Type"; Enum "Bal. Account Type")
        {
            Caption = 'Account Type';
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE IF ("Account Type" = CONST(Customer)) Customer
            ELSE IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                case "Account Type" of
                    "Account Type"::"G/L Account":
                        GetGLAccount;
                    "Account Type"::Customer:
                        GetCustomerAccount;
                    "Account Type"::Vendor:
                        GetVendorAccount;
                    "Account Type"::"Bank Account":
                        GetBankAccount;
                    "Account Type"::"Fixed Asset":
                        GetFAAccount;
                    "Account Type"::"IC Partner":
                        GetICPartnerAccount;
                end;
            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;

            trigger OnValidate()
            begin
                if not (("Posting Date" >= "From Date") and ("Posting Date" <= "To Date")) then
                    Error(Text006, "From Date", "To Date");
            end;
        }
        field(6; "Document Type"; Enum "Employee Document Type")
        {
            Caption = 'Document Type';
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(9; "Attribute Code"; Code[20])
        {
            TableRelation = "Payroll Attributes";

            trigger OnValidate()
            begin
                "Account No." := '';
                "Attribute Type" := "Attribute Type"::" ";
                "Attribute Sub Type" := "Attribute Sub Type"::" ";
                "Non-Taxable" := false;
                if "Attribute Code" <> '' then begin
                    PayrollAttributes.Get("Attribute Code");
                    "Non-Taxable" := PayrollAttributes."Non-Taxable";
                    Validate("Account Type", "Account Type"::"G/L Account");
                    Validate("Account No.", PayrollAttributes."G/L Account No.");
                    UpdateAttribute(Rec, PayrollAttributes);
                end;
            end;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(11; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                UpdateLineBalance;
            end;
        }
        field(12; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                Correction := "Debit Amount" < 0;
                Amount := "Debit Amount";
                Validate(Amount);
            end;
        }
        field(13; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                Correction := "Credit Amount" < 0;
                Amount := -"Credit Amount";
                Validate(Amount);
            end;
        }
        field(14; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance (LCY)';
            Editable = false;
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(17; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(18; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Payroll Journal Batch";
        }
        field(19; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(20; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(21; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(22; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(23; "From Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                if ("To Date" <> 0D) and ("From Date" <> 0D) then
                    if "From Date" >= "To Date" then
                        Error(Text000, FieldCaption("From Date"), FieldCaption("To Date"), 'greater');
                if "From Date" <> 0D then
                    Month := Date2DMY("From Date", 2);

                "From Date (B.S)" := EngNep.getNepaliDate("From Date");
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
                EngNep.Reset;
                EngNep.SetRange("English Date", "From Date");
                if EngNep.FindFirst then begin
                    "Nepali Month" := EngNep."Nepali Month";
                    "Nepali Year" := EngNep."Nepali Year";
                end;
            end;
        }
        field(24; "To Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                if ("To Date" <> 0D) and ("From Date" <> 0D) then
                    if "From Date" >= "To Date" then
                        Error(Text000, FieldCaption("To Date"), FieldCaption("From Date"), 'lesser');
                "To Date (B.S)" := EngNep.getNepaliDate("To Date");
            end;
        }
        field(25; Month; Enum "English Month")
        {
            Editable = false;
        }
        field(26; "From Date (B.S)"; Code[10])
        {
            Editable = false;
        }
        field(27; "To Date (B.S)"; Code[10])
        {
            Editable = false;
        }
        field(28; "Nepali Month"; Enum "Nepali Month")
        {
            Editable = false;
        }
        field(29; "Nepali Year"; Integer)
        {
            Editable = false;
        }
        field(30; "Pay Cycle Code"; Code[10])
        {
            TableRelation = "Pay Cycle";

            trigger OnValidate()
            begin
                "Pay Cycle Period" := 0;
                "Pay Cycle Term" := '';
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
            end;
        }
        field(31; "Pay Cycle Term"; Code[10])
        {
            TableRelation = "Pay Cycle Term".Term WHERE("Pay Cycle Code" = FIELD("Pay Cycle Code"));

            trigger OnValidate()
            begin
                "Pay Cycle Period" := 0;
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
            end;
        }
        field(32; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period WHERE("Pay Cycle Code" = FIELD("Pay Cycle Code"),
                                                             "Pay Cycle Term" = FIELD("Pay Cycle Term"));

            trigger OnValidate()
            begin
                TestField("Pay Cycle Code");
                TestField("Pay Cycle Term");
                if PayCyclePeriod.Get("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period") then begin
                    Validate("To Date", 0D);
                    Validate("From Date", 0D);
                    Validate("From Date", PayCyclePeriod."Start Date");
                    Validate("To Date", PayCyclePeriod."End Date");
                    Validate("Pay Period Start Date", PayCyclePeriod."Start Date");
                    Validate("Pay Period End Date", PayCyclePeriod."End Date");
                    "Posting Date" := PayCyclePeriod."Pay Date";
                end;
            end;
        }
        field(33; "Attribute Type"; Enum "Attribute Type")
        {

        }
        field(34; "Attribute Sub Type"; Enum "Attribute Sub Type")
        {

        }
        field(35; "Reversing Entry"; Boolean)
        {
            Caption = 'Reversing Entry';
            Editable = false;
        }
        field(36; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(37; Remarks; Text[250])
        {
        }
        field(38; "Present Days"; Decimal)
        {
            Caption = 'P';
            Description = 'P';
        }
        field(39; "Absent Days"; Decimal)
        {
            Caption = 'A';
            Description = 'A';
        }
        field(40; "Paid Days"; Decimal)
        {
            Description = 'Paid Days';
            Editable = false;
        }
        field(41; "Late Days"; Decimal)
        {
            Caption = 'Late Day';
            Description = 'Late Day';
        }
        field(42; "Week off Days"; Decimal)
        {
            Caption = 'W';
            Description = 'W';
        }
        field(43; "Leave Days"; Decimal)
        {
            Caption = 'L';
            Description = 'L';
        }
        field(44; "Tour Days"; Decimal)
        {
            Caption = 'Tour';
            Description = 'Tour';
        }
        field(45; "Half Days"; Decimal)
        {
            Caption = 'Half Day';
            Description = 'Half Day';
        }
        field(46; "Total Days"; Decimal)
        {
            Caption = 'T';
            Description = 'T';
            Editable = false;
        }
        field(47; "OT Hrs (30MIN)"; Decimal)
        {
            Caption = 'OT Hrs (30MIN)';
            Description = 'OT Hrs (30MIN)';
            Editable = false;
        }
        field(48; "OT Days"; Decimal)
        {
            Description = 'OT Days';
        }
        field(49; "Late Rate"; Decimal)
        {
            Description = 'Late Rate';
            Editable = false;
        }
        field(50; "Pay Period Start Date"; Date)
        {
        }
        field(51; "Pay Period End Date"; Date)
        {
        }
        field(52; "Non-Taxable"; Boolean)
        {
        }
        field(53; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(54; "Assigned User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(55; "Do not group Lines"; Boolean)
        {
        }
        field(56; "Posting No."; Code[20])
        {
        }
        field(57; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                CreateDim(DATABASE::Employee, "Employee No.");
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
                UpdateShortcutDimFromDimSetID;
                if "Employee No." <> '' then begin
                    Employee.Get("Employee No.");
                    Validate("Employee Name", Employee.FullName);
                    TestField("From Date");
                    TestField("To Date");
                    if not PayrollEngine.IsValidEmployee(Employee, "From Date", "To Date") then
                        Error(Text001, "Employee No.");
                end;
            end;
        }
        field(58; "Employee Name"; Text[250])
        {
        }
        field(59; Narration; Text[250])
        {
        }
        field(60; "Bal. Account Type"; Enum "Bal. Account Type")
        {
            Caption = 'Bal. Account Type';
            Description = 'Use for cit payment,pf contribution not use';
        }
        field(61; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            Description = 'Use for cit payment,pf contribution not use';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            var
                COA: Record "G/L Account";
                DefaultDimensions: Record "Default Dimension";
            begin
            end;
        }
        field(62; "Posted Payroll Plan No."; Code[20])
        {
            TableRelation = "Posted Payroll Header";
        }
        field(63; "Posted Payroll Plan Line No."; Integer)
        {
        }
        field(64; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(65; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(66; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(67; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(68; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(69; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(70; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(71; "Deputation Value"; Text[50])
        {
        }
        field(72; "Sol ID"; Code[20])
        {
        }
        field(73; "Fiscal Year"; Code[10])
        {
        }
        field(74; Type; Enum "Payroll Header Type")
        {

        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            SumIndexFields = "Balance (LCY)";
        }
        key(Key2; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        SourceCodeSetup.Get;
        SourceCodeSetup.TestField("Payroll Journal");
        "Source Code" := SourceCodeSetup."Payroll Journal";
        "Assigned User ID" := UserId;
        "Document Date" := Today;
    end;

    var
        EngNep: Record "English-Nepali Date";
        PayrollJournalLine: Record "Payroll Journal Line";
        PayCyclePeriod: Record "Pay Cycle Period";
        DimSetEntry: Record "Dimension Set Entry";
        PayrollAttributes: Record "Payroll Attributes";
        SourceCodeSetup: Record "Source Code Setup";
        Employee: Record Employee;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        PayrollEngine: Codeunit "Payroll Engine";
        HideValidationDialog: Boolean;
        Text000: Label '"%1" cannot be %3 than "%2".';
        GLSetupShortcutDimCode: array[8] of Code[20];
        Text001: Label 'Employee %1 is not valid employee.';
        Text006: Label 'Posting Date must be within the range %1 and %2.';

    procedure EmptyLine(): Boolean
    begin
        exit(
          ("Account No." = '') and (Amount = 0));
    end;

    procedure IsOpenedFromBatch(): Boolean
    var
        PayrollJournalBatch: Record "Payroll Journal Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GetFilter("Journal Batch Name");
        if BatchFilter <> '' then begin
            PayrollJournalBatch.SetFilter(Code, BatchFilter);
            PayrollJournalBatch.FindFirst;
        end;

        exit(("Journal Batch Name" <> '') or (BatchFilter <> ''));
    end;

    procedure SetUpNewLine(LastPayrollJournalLine: Record "Payroll Journal Line"; Balance: Decimal; BottomLine: Boolean)
    var
        GenJnlBatch: Record "Payroll Journal Batch";
    begin
        GenJnlBatch.Get("Journal Batch Name");
        PayrollJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        PayrollJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if PayrollJournalLine.FindFirst then begin
            "Posting Date" := LastPayrollJournalLine."Posting Date";
            "Document Date" := LastPayrollJournalLine."Posting Date";
            "Document No." := LastPayrollJournalLine."Document No.";
            if BottomLine and
               (Balance - (LastPayrollJournalLine."Balance (LCY)") = 0) and
               not LastPayrollJournalLine.EmptyLine
            then
                "Document No." := IncStr("Document No.");
        end else begin
            "Posting Date" := WorkDate;
            "Document Date" := WorkDate;
            if GenJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", "Posting Date");
            end;
        end;
        "Account Type" := LastPayrollJournalLine."Account Type";
        "Document Type" := LastPayrollJournalLine."Document Type";
        "Posting No. Series" := GenJnlBatch."Posting No. Series";
        Description := '';
    end;

    procedure UpdateLineBalance()
    begin
        if ((Amount > 0) and (not Correction)) or
           ((Amount < 0) and Correction)
        then begin
            "Debit Amount" := Amount;
            "Credit Amount" := 0
        end else begin
            "Debit Amount" := 0;
            "Credit Amount" := -Amount;
        end;
        "Balance (LCY)" := Amount;
    end;

    procedure SetHideValidation(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure GetShortcutDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
        ShortcutDimCode: array[8] of Code[20];
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
        "Shortcut Dimension 3 Code" := ShortcutDimCode[3];
        "Shortcut Dimension 4 Code" := ShortcutDimCode[4];
        "Shortcut Dimension 5 Code" := ShortcutDimCode[5];
        "Shortcut Dimension 6 Code" := ShortcutDimCode[6];
        "Shortcut Dimension 7 Code" := ShortcutDimCode[7];
        "Shortcut Dimension 8 Code" := ShortcutDimCode[8];
    end;

    local procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        TableID: List of [Dictionary of [Integer, Code[20]]];
        No: array[10] of Code[20];
    begin
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID", DATABASE::Employee);
    end;

    procedure UpdateShortcutDimFromDimSetID()
    begin
        GetGLSetup;
        "Shortcut Dimension 3 Code" := '';
        "Shortcut Dimension 4 Code" := '';
        "Shortcut Dimension 5 Code" := '';
        "Shortcut Dimension 6 Code" := '';
        "Shortcut Dimension 7 Code" := '';
        "Shortcut Dimension 8 Code" := '';

        if GLSetupShortcutDimCode[3] <> '' then
            if DimSetEntry.Get("Dimension Set ID", GLSetupShortcutDimCode[3]) then
                "Shortcut Dimension 3 Code" := DimSetEntry."Dimension Value Code";
        if GLSetupShortcutDimCode[4] <> '' then
            if DimSetEntry.Get("Dimension Set ID", GLSetupShortcutDimCode[4]) then
                "Shortcut Dimension 4 Code" := DimSetEntry."Dimension Value Code";
        if GLSetupShortcutDimCode[5] <> '' then
            if DimSetEntry.Get("Dimension Set ID", GLSetupShortcutDimCode[5]) then
                "Shortcut Dimension 5 Code" := DimSetEntry."Dimension Value Code";
        if GLSetupShortcutDimCode[6] <> '' then
            if DimSetEntry.Get("Dimension Set ID", GLSetupShortcutDimCode[6]) then
                "Shortcut Dimension 6 Code" := DimSetEntry."Dimension Value Code";
        if GLSetupShortcutDimCode[7] <> '' then
            if DimSetEntry.Get("Dimension Set ID", GLSetupShortcutDimCode[7]) then
                "Shortcut Dimension 7 Code" := DimSetEntry."Dimension Value Code";
        if GLSetupShortcutDimCode[8] <> '' then
            if DimSetEntry.Get("Dimension Set ID", GLSetupShortcutDimCode[8]) then
                "Shortcut Dimension 8 Code" := DimSetEntry."Dimension Value Code";
    end;

    local procedure GetGLSetup()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
        GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
        GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
        GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
        GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
        GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
        GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
        GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
    end;

    procedure CopyFromPayrollLine(var PayrollLine: Record "Payroll Line")
    begin
        "Employee No." := PayrollLine."Employee No.";
        Remarks := PayrollLine.Remarks;
        "Present Days" := PayrollLine."Present Days";
        "Absent Days" := PayrollLine."Absent Days";
        "Paid Days" := PayrollLine."Paid Days";
        "Late Days" := PayrollLine."Late Days";
        "Week off Days" := PayrollLine."Week off Days";
        "Leave Days" := PayrollLine."Leave Days";
        "Tour Days" := PayrollLine."Tour Days";
        "Half Days" := PayrollLine."Half Days";
        "Total Days" := PayrollLine."Total Days";
        "OT Hrs (30MIN)" := PayrollLine."OT Hrs";
        "OT Days" := PayrollLine."OT Days";
        "Late Days" := PayrollLine."Late Rate";
        "Deputation On" := PayrollLine."Deputation On";
        "Deputation Value" := PayrollLine."Deputation Value";
        "Sol ID" := PayrollLine."Sol ID";
        "Shortcut Dimension 1 Code" := PayrollLine."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := PayrollLine."Global Dimension 2 Code";
        "Dimension Set ID" := PayrollLine."Dimension Set ID";
    end;

    procedure CopyFromPayrollHeader(var PayrollHeader: Record "Payroll Header")
    begin
        "Posting Date" := PayrollHeader."Posting Date";
        "Document Date" := PayrollHeader."Document Date";
        "Pay Cycle Code" := PayrollHeader."Pay Cycle Code";
        "Pay Cycle Term" := PayrollHeader."Pay Cycle Term";
        "Pay Cycle Period" := PayrollHeader."Pay Cycle Period";
        "Pay Period Start Date" := PayrollHeader."From Date";
        "Pay Period End Date" := PayrollHeader."To Date";
        "Nepali Year" := PayrollHeader."Nepali Year";
        "Nepali Month" := PayrollHeader."Nepali Month";
        "Posting No. Series" := PayrollHeader."Posting No. Series";
        "From Date" := PayrollHeader."From Date";
        "From Date (B.S)" := PayrollHeader."From Date (B.S)";
        "To Date" := PayrollHeader."To Date";
        "To Date (B.S)" := PayrollHeader."To Date (B.S)";
        Month := PayrollHeader.Month;
        "Assigned User ID" := PayrollHeader."Assigned User ID";
        Type := PayrollHeader.Type;
    end;

    procedure UpdateAttribute(var PayrollJournalLine: Record "Payroll Journal Line" temporary; PayrollAttributes: Record "Payroll Attributes")
    begin
        PayrollJournalLine."Attribute Code" := PayrollAttributes.Code;
        PayrollJournalLine."Non-Taxable" := PayrollAttributes."Non-Taxable";
        case PayrollAttributes.Type of
            PayrollAttributes.Type::Deduction:
                PayrollJournalLine."Attribute Type" := PayrollJournalLine."Attribute Type"::Deduction;
            PayrollAttributes.Type::"Non-Payment":
                PayrollJournalLine."Attribute Type" := PayrollJournalLine."Attribute Type"::"Non-Payment";
            PayrollAttributes.Type::Benefits:
                PayrollJournalLine."Attribute Type" := PayrollJournalLine."Attribute Type"::"Other Earnings";
        end;
        case PayrollAttributes.Subtype of
            PayrollAttributes.Subtype::" ":
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::" ";
            PayrollAttributes.Subtype::Advance:
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::Advance;
            PayrollAttributes.Subtype::CIT:
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::CIT;
            PayrollAttributes.Subtype::Donation:
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::Donation;
            PayrollAttributes.Subtype::"Employee Contribution":
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::"Employee Contribution";
            PayrollAttributes.Subtype::"Employer Contribution":
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::"Employer Contribution";
            PayrollAttributes.Subtype::Loan:
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::Loan;
            PayrollAttributes.Subtype::Medical:
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::Medical;
            PayrollAttributes.Subtype::"Tax on Remuneration & Benefits":
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::"Tax on Remuneration & Benefits";
            PayrollAttributes.Subtype::"Tax on Interest":
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::"Tax on Interest";
            PayrollAttributes.Subtype::"Lump Sum Contribution":
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::"Lump Sum Contribution";
            PayrollAttributes.Subtype::RF:
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::RF;
            PayrollAttributes.Subtype::Gratuity:
                PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::Gratuity;
            PayrollAttributes.Subtype::"Social Security Tax":
                begin
                    PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::"Social Security Tax";
                end;
            PayrollAttributes.Subtype::Basic:
                begin
                    PayrollJournalLine."Attribute Type" := PayrollJournalLine."Attribute Type"::"Basic Earning";
                    PayrollJournalLine."Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type"::Basic;
                end;
        end;
    end;

    procedure SetEmployeeWisePosting(AttributeCode: Code[20]): Boolean
    var
        PayrollAttributes: Record "Payroll Attributes";
    begin
        if AttributeCode <> '' then
            if PayrollAttributes.Get(AttributeCode) then
                exit(PayrollAttributes."Posting Method" = PayrollAttributes."Posting Method"::"Employee Wise");
    end;

    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            Rec, "Dimension Set ID", StrSubstNo('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        IsChanged := OldDimSetID <> "Dimension Set ID";
    end;

    procedure CheckDocNoBasedOnNoSeries(LastDocNo: Code[20]; NoSeriesCode: Code[10]; var NoSeriesMgtInstance: Codeunit NoSeriesManagement)
    begin
        if NoSeriesCode = '' then
            exit;

        if (LastDocNo = '') or ("Document No." <> LastDocNo) then
            TestField("Document No.", NoSeriesMgtInstance.GetNextNo(NoSeriesCode, "Posting Date", false));
    end;

    local procedure GetGLAccount()
    var
        GLAcc: Record "G/L Account";
    begin
        if GLAcc.Get("Account No.") then
            UpdateDescription(GLAcc.Name)
        else
            Description := '';
    end;

    local procedure GetCustomerAccount()
    var
        Cust: Record Customer;
    begin
        if Cust.Get("Account No.") then
            UpdateDescription(Cust.Name)
        else
            Description := '';
    end;

    local procedure GetVendorAccount()
    var
        Vend: Record Vendor;
    begin
        if Vend.Get("Account No.") then
            UpdateDescription(Vend.Name)
        else
            Description := '';
    end;

    local procedure GetBankAccount()
    var
        BankAcc: Record "Bank Account";
    begin
        BankAcc.Get("Account No.");
        BankAcc.TestField(Blocked, false);
        UpdateDescription(BankAcc.Name);
    end;

    local procedure GetFAAccount()
    var
        FA: Record "Fixed Asset";
    begin
        if FA.Get("Account No.") then begin
            FA.TestField(Blocked, false);
            FA.TestField(Inactive, false);
            FA.TestField("Budgeted Asset", false);
            UpdateDescription(FA.Description);
        end else
            Description := '';
    end;

    local procedure GetICPartnerAccount()
    var
        ICPartner: Record "IC Partner";
    begin
        ICPartner.Get("Account No.");
        UpdateDescription(ICPartner.Name);
    end;

    local procedure UpdateDescription(Name: Text[50])
    begin
        Description := Name;
    end;
}

