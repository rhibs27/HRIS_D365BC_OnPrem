table 50035 "Posted Payroll Line"
{
    DataClassification = CustomerContent;
    // version PRM19.01.01

    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;
        }
        field(4; "Basic Salary"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(5; "Net Pay"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DecimalPlaces = 0 : 4;
            Editable = false;
        }
        field(6; "Balance Taxable Income"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(7; "Tax for Period"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Editable = false;
        }
        field(8; "Current Benefit"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DecimalPlaces = 0 : 4;
            Editable = false;
        }
        field(9; "Current Deduction"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DecimalPlaces = 0 : 4;
            Editable = false;
        }
        field(10; "Total Employer Contribution"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(11; "Total Tax Credit"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(14; Remarks; Text[250]) { }
        field(15; "Present Days"; Decimal)
        {
            Description = 'P';
        }
        field(16; "Absent Days"; Decimal)
        {
            Description = 'A';
        }
        field(17; "Paid Days"; Decimal)
        {
            Description = 'Paid Days';
            Editable = false;
        }
        field(18; "Late Days"; Decimal)
        {
            Caption = 'Late Day';
            Description = 'Late Day';
        }
        field(19; "Week off Days"; Decimal)
        {
            Description = 'W';
        }
        field(20; "Leave Days"; Decimal)
        {
            Description = 'L';
        }
        field(21; "Tour Days"; Decimal)
        {
            Description = 'Tour';
        }
        field(22; "Half Days"; Decimal)
        {
            Description = 'Half Day';
        }
        field(23; "Total Days"; Decimal)
        {
            Description = 'T';
            Editable = false;
        }
        field(24; "OT Hrs"; Decimal)
        {
            Description = 'OT Hrs';
            Editable = false;
        }
        field(25; "OT Days"; Decimal)
        {
            Description = 'OT Days';
        }
        field(26; "Late Rate"; Decimal)
        {
            Description = 'Late Rate';
            Editable = false;
        }
        field(27; "Paid Hours"; Decimal) { }
        field(28; "Unpaid Hours"; Decimal) { }
        field(29; "Total Present Hours"; Decimal)
        {
            Editable = false;
        }
        field(30; "Standard Hours"; Decimal)
        {
            Editable = false;
        }
        field(31; "Week Off Hours"; Decimal)
        {
        }
        field(32; "Leave Hours"; Decimal)
        {
        }
        field(33; "Employee Name"; Text[100])
        {
        }
        field(34; "Employee Type"; enum "Employee Type")
        {

        }
        field(35; "Bank Account No."; Code[20]) { }
        field(36; "CIT No."; Code[20]) { }
        field(37; "PF No."; Code[20]) { }
        field(38; Division; Code[20]) { }
        field(39; "Salary Level"; Code[20]) { }
        field(40; "Salary Grade"; Code[20]) { }
        field(41; "Pan No."; Code[20]) { }
        field(42; "Functional Title"; Code[20]) { }
        field(43; Number; Integer)
        {
            Editable = false;
        }
        field(44; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }

        field(45; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }

        field(47; "Variable Field 50487"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,47';
            Description = 'added for bank';
        }
        field(48; "Variable Field 50488"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,48';
            Description = 'added for bank';
        }
        field(49; "Variable Field 50489"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,49';
        }
        field(50; "Variable Field 50490"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,50';
            Description = 'added for bank';
        }
        field(51; "Variable Field 50491"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,52';
            Description = 'added for bank';
        }
        field(52; "Variable Field 50492"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,52';
            Description = 'added for bank';
        }
        field(53; "Variable Field 50493"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,53';
            Description = 'added for bank';
        }
        field(54; "Variable Field 50494"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,54';
            Description = 'added for bank';
        }
        field(55; "Variable Field 50495"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,55';
            Description = 'added for bank';
        }
        field(56; "Variable Field 50496"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,56';
            Description = 'added for bank';
        }
        field(57; "Variable Field 50497"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,57';
            Description = 'added for bank';
        }
        field(58; "Variable Field 50498"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,58';
            Description = 'added for bank';
        }
        field(59; "Variable Field 50499"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,59';
            Description = 'added for bank';
        }
        field(60; "Variable Field 50500"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,50027,60';
            Description = 'added for bank';
        }
        field(61; "Variable Field 50501"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,61';
        }
        field(62; "Variable Field 50502"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,62';
        }
        field(63; "Variable Field 50503"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,63';
        }
        field(64; "Variable Field 50504"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,64';
        }
        field(65; "Variable Field 50505"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,65';
        }
        field(66; "Variable Field 50506"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,66';
        }
        field(67; "Variable Field 50507"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,67';
        }
        field(68; "Variable Field 50508"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,68';
        }
        field(69; "Variable Field 50509"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,69';
        }
        field(70; "Variable Field 50510"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,70';
        }
        field(71; "Variable Field 50511"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,71';
        }
        field(72; "Variable Field 50512"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,72';
        }
        field(73; "Variable Field 50513"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,73';
        }
        field(74; "Variable Field 50514"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,74';
        }
        field(75; "Variable Field 50515"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,75';
        }
        field(76; "Variable Field 50516"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,76';
        }
        field(77; "Variable Field 50517"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,77';
        }
        field(78; "Variable Field 50518"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,78';
        }
        field(79; "Variable Field 50519"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,79';
        }
        field(80; "Variable Field 50520"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,80';
        }
        field(81; "Variable Field 50521"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,81';
        }
        field(82; "Variable Field 50522"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,82';
        }
        field(83; "Variable Field 50523"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,83';
        }
        field(84; "Variable Field 50524"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,84';
        }
        field(85; "Variable Field 50525"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,85';
        }
        field(86; "Variable Field 50526"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,86';
        }
        field(87; "Variable Field 50527"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,87';
        }
        field(88; "Variable Field 50528"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,88';
        }
        field(89; "Variable Field 50529"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,89';
        }
        field(90; "Variable Field 50530"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,90';
        }
        field(91; "Variable Field 50531"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,91';
        }
        field(92; "Variable Field 50532"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,92';
        }
        field(93; "Variable Field 50533"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,93';
        }
        field(94; "Variable Field 50534"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,94';
        }
        field(95; "Variable Field 50535"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,95';
        }
        field(96; "Variable Field 50536"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,96';
        }
        field(97; "Variable Field 50537"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,97';
        }
        field(98; "Variable Field 50538"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,98';
        }
        field(99; "Variable Field 50539"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,99';
        }
        field(100; "Variable Field 50540"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,100';
        }
        field(101; "Bank Name"; Text[50]) { }
        field(102; "Evening Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(103; "Holiday Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(104; "Bulk Cash Transfer Days"; Decimal) { }
        field(105; "Cash Risk Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(106; "Friday Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(107; "Festival Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(108; "Vault Key Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(109; "Faciliating Hours"; Decimal)
        {
        }
        field(110; "Gratuity Years"; Decimal)
        {
        }
        field(111; "Document Type"; Enum "Payroll Document Type")
        {

        }
        field(112; "Resignation Date"; Date) { }
        field(113; "Annual Leave Days"; Decimal) { }
        field(114; "Sick Leave Days"; Decimal) { }
        field(115; "Total Adjusted Leave Days"; Decimal) { }
        field(116; "Total Insurance Claim Amount"; Decimal) { }
        field(117; LFA; Decimal) { }
        field(118; "Morning Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(119; "Prior Absent Days"; Decimal) { }
        field(120; "Prior Present Days"; Decimal) { }
        field(121; "Salary Advance No."; Code[20]) { }

        field(122; "Projected Benefit"; Decimal)
        {
        }
        field(123; "Past Benefit"; Decimal)
        {
        }
        field(124; "Assessable Income"; Decimal)
        {
        }
        field(125; "Past Retirement Fund"; Decimal)
        {
        }
        field(126; "Projected Retirement Fund"; Decimal)
        {
        }
        field(127; "Actual RF Contribution"; Decimal)
        {
        }
        field(128; "1/3 of Assessable Income"; Decimal)
        {
        }
        field(129; "Eligible RF Deduction"; Decimal)
        {
        }
        field(130; "Life Insurance Premium"; Decimal)
        {
        }
        field(131; "Health Insurance Premium"; Decimal)
        {
        }
        field(132; "Taxable Income"; Decimal)
        {
        }
        field(133; "Disable Person Reduction"; Decimal)
        {
        }
        field(134; "Female Tax Credit"; Decimal)
        {
        }
        field(135; "Total Tax Liability"; Decimal)
        {
        }
        field(136; "Payable Tax Liability"; Decimal)
        {
        }
        field(137; "Net Tax Liability"; Decimal)
        {
        }
        field(138; "Social Security Tax(Annual)"; Decimal)
        {
        }
        field(139; "Tax on Remuneration(Annual)"; Decimal)
        {
        }
        field(140; "Total Tax Paid"; Decimal)
        {
        }
        field(141; "Carry Forwarded Sick"; Decimal)
        {
        }
        field(142; "Carry Forward Annual"; Decimal)
        {
        }
        field(143; "Prorata Sick"; Decimal)
        {
        }
        field(144; "Prorata Annual"; Decimal)
        {
        }
        field(145; "Used Leave Sick"; Decimal)
        {
        }
        field(146; "Used Leave Annual"; Decimal)
        {
        }
        field(147; "Gratuity & leave Encash Tax"; Decimal)
        {
        }
        field(148; "Projection Month"; Decimal)
        {
        }
        field(149; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(150; "Deputation Code"; Code[20])
        {
        }
        field(151; "Sol ID"; Code[20])
        {
        }
        field(152; "1% Slab"; Decimal)
        {
        }
        field(153; "10% Slab"; Decimal)
        {
        }
        field(154; "20% Slab"; Decimal)
        {
        }
        field(155; "30% Slab"; Decimal)
        {
        }
        field(156; "36% Slab"; Decimal)
        {
        }
        field(157; Type; Enum "Payroll Header Type")
        {
        }
        field(158; "Remote Area Deduction"; Decimal)
        {
        }
        field(159; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
        }
        field(160; "Marital Status"; Enum "Marital Status")
        {

        }
        field(161; "Total SST Paid"; Decimal) { }
        field(162; "Total Tax Remuneration Paid"; Decimal) { }
        field(163; "LWP Days"; Decimal) { }
        field(164; "Prior Leave Days"; Decimal) { }
        field(165; "Property Insurance Premium"; Decimal) { }
        field(167; "Current Non-Payments"; Decimal) { }
        field(170; "Projected Non-Payments"; Decimal) { }
        field(171; "Past Non-Payments"; Decimal) { }
        field(181; "Posting Date"; Date) { }
        field(175; "CIT Posted 1"; Boolean) { }
        field(176; "PF Posted 1"; Boolean) { }
        field(177; "IC Posted 1"; Boolean)
        {
            Description = 'Income Tax 1 ( Social Security Tax and Tax on Remuneration)';
        }
        field(178; "IC Posted 2"; Boolean)
        {
            Description = 'Income Tax 2 ( Social Security Tax and Tax on Remuneration)';
        }
        field(179; "CIT Posted 2"; Boolean)
        {
        }
        field(180; "PF Posted 2"; Boolean)
        {
        }
        field(172; "39% Slab"; Decimal)
        {
        }
        field(173; "Post Resignation Days"; Decimal)
        {
        }
        field(174; "Post Payroll Days"; Decimal)
        {
            Description = 'Post Payroll Days';
            Editable = false;
        }
        field(182; Reversed; Boolean) { }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.") { }
    }

    fieldgroups { }

    var
        DimMgt: Codeunit DimensionManagement;
        PostedPayrollHeader: Record "Posted Payroll Header";
        Text000: Label 'Line No. %1 on document %2 has already been reversed.';

    procedure InitFromPayrollLine(PostedPayrollHeader: Record "Posted Payroll Header"; PayrollLine: Record "Payroll Line")
    begin
        Init;
        TransferFields(PayrollLine);
        "Posting Date" := PostedPayrollHeader."Posting Date";
        "Document No." := PostedPayrollHeader."No.";
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "Document No.", "Line No."));
    end;

    procedure ReverseLine(var ParentPostedPayrollLine: Record "Posted Payroll Line")
    var
        PostedPayrollLine: Record "Posted Payroll Line";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";
        NewDetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";
        LastEntryNo: Integer;
    begin

        //Check if already reversed
        if AlreadyReversed then
            Error(Text000, ParentPostedPayrollLine."Line No.", ParentPostedPayrollLine."Document No.");

        // Insert Posted Payroll Line with all fields multiply by -1.
        Clear(PostedPayrollLine);
        PostedPayrollLine.Init;
        PostedPayrollLine.TransferFields(ParentPostedPayrollLine);
        PostedPayrollLine."Line No." += 1;
        PostedPayrollLine.Reversed := true;
        PostedPayrollLine.Insert(true);
        ReverseAmounts(PostedPayrollLine);

        // Mark All old entries as reversed and insert reversed by entry no in older entries.

        // In new entries add applies-to entry No.

        // Create Payroll Journal Line Based on Detailed employee ledger entry
        EmployeeLedgerEntry.LockTable;
        DetailedEmployeeLedgEntry.LockTable;
        DetailedEmployeeLedgEntry.Reset;
        if DetailedEmployeeLedgEntry.FindLast then
            LastEntryNo := DetailedEmployeeLedgEntry."Entry No."
        else
            LastEntryNo += 1;
        DetailedEmployeeLedgEntry.Reset;
        DetailedEmployeeLedgEntry.SetRange("Document No.", ParentPostedPayrollLine."Document No.");
        DetailedEmployeeLedgEntry.SetRange("Employee No.", ParentPostedPayrollLine."Employee No.");
        DetailedEmployeeLedgEntry.SetFilter("Entry No.", '<=%1', LastEntryNo);
        if DetailedEmployeeLedgEntry.FindSet then
            repeat
                Clear(NewDetailedEmployeeLedgEntry);
                NewDetailedEmployeeLedgEntry.Init;
                NewDetailedEmployeeLedgEntry.TransferFields(DetailedEmployeeLedgEntry);
                NewDetailedEmployeeLedgEntry."Entry No." := LastEntryNo + 1;
                NewDetailedEmployeeLedgEntry.Amount := NewDetailedEmployeeLedgEntry.Amount * -1;
                NewDetailedEmployeeLedgEntry.Reversed := true;
                NewDetailedEmployeeLedgEntry.Insert;
                LastEntryNo += 1;
                DetailedEmployeeLedgEntry.Reversed := true;
                DetailedEmployeeLedgEntry.Modify;
            until DetailedEmployeeLedgEntry.Next = 0;
        // Use Payroll-Jnl. Post Line codeunit to post the reversal.

        ParentPostedPayrollLine.Reversed := true;
        ParentPostedPayrollLine.Modify(true);
    end;

    local procedure GetSign(Reverse: Boolean): Integer
    begin
        if Reverse then
            exit(-1)
        else
            exit(1);
    end;

    local procedure AlreadyReversed(): Boolean
    begin
        exit(Reversed);
    end;

    local procedure ReverseAmounts(var PostedPayrollLine: Record "Posted Payroll Line")
    var
        FieldID: Integer;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        FieldValue: Decimal;
    begin
        PostedPayrollLine."Net Pay" := PostedPayrollLine."Net Pay" * GetSign(true);
        PostedPayrollLine."Tax for Period" := PostedPayrollLine."Tax for Period" * GetSign(true);
        PostedPayrollLine."Current Benefit" := PostedPayrollLine."Current Benefit" * GetSign(true);
        PostedPayrollLine."Current Deduction" := PostedPayrollLine."Current Deduction" * GetSign(true);
        PostedPayrollLine."Total Employer Contribution" := PostedPayrollLine."Total Employer Contribution" * GetSign(true);
        PostedPayrollLine."Total Tax Credit" := PostedPayrollLine."Total Tax Credit" * GetSign(true);
        PostedPayrollLine.Modify;

        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollLine."Document No.");
        FieldRefs := RecRefs.Field(2);
        FieldRefs.SetRange(PostedPayrollLine."Line No.");
        RecRefs.FindFirst;
        for FieldID := 50 to 100 do begin
            FieldRefs := RecRefs.Field(FieldID);
            Evaluate(FieldValue, Format(FieldRefs.Value));
            FieldValue *= GetSign(true);
            FieldRefs.Validate(FieldValue);
            RecRefs.Modify;
        end;
    end;

    procedure GetTimeSheet()
    begin
        /*
        GetPayrollHeader;
        TimeSheetSummary.RESET;
        TimeSheetSummary.FILTERGROUP(2);
        TimeSheetSummary.SETRANGE("Employee Code","Employee No.");
        TimeSheetSummary.SETRANGE("From Date",PostedPayrollHeader."From Date");
        TimeSheetSummary.SETRANGE("To Date",PostedPayrollHeader."To Date");
        TimeSheetSummary.FILTERGROUP(0);
        CLEAR(TimeSheetSummaryList);
        TimeSheetSummaryList.SETTABLEVIEW(TimeSheetSummary);
        TimeSheetSummaryList.RUNMODAL;
        */
    end;

    procedure GetPayrollHeader()
    begin
        PostedPayrollHeader.Get("Document No.");
    end;
}
