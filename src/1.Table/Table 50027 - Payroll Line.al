table 50027 "Payroll Line"
{
    DataClassification = CustomerContent;
    // version PRM19.01.01

    // //Min 3.20.2022 -- IsValidComponent,function commented because, data filter does not match according condition applied on these function.

    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                CheckDuplicateEmployee;
                //CheckSettlement; //pram (requirement not fixed)
                GetPayrollHeader;
                Clear(PayrollEngine);
                Employee.Get("Employee No.");
                Employee.TestField("Deputation on");
                Employee.TestField("Salary Grade");
                Employee.TestField("Salary Level");
                Employee.TestField("Employment Date");
                Employee.TestField(Settled, false);
                if not (PayrollHeader.Type = PayrollHeader.Type::Resignation) then
                    Employee.TestField(Status, Employee.Status::Active);
                Employee.TestField("Tax Code");
                //Employee.TESTFIELD("Employee Designation"); UTS commented
                Validate(Type, PayrollHeader.Type);
                if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
                    if Employee."Resignation Date" <> 0D then
                        Error('Employee %1 has resigned.', Employee."Full Name");
                    case PayrollHeader."Employee Type" of
                        PayrollHeader."Employee Type"::Contract:
                            if Employee."Employment Type" <> Employee."Employment Type"::Contract then
                                Error('Employment type of employee %1 must be contract', Employee."Full Name");

                        PayrollHeader."Employee Type"::Regular:
                            if not (Employee."Employment Type" in [Employee."Employment Type"::Permanent, Employee."Employment Type"::Probation]) then
                                Error('Employment type of employee %1 must be  probation or permanent', Employee."Full Name");
                    end;
                    if PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period") then begin
                        if Employee."Employment Date" = PayCyclePeriod."Pay Date" then //Min
                            Error('You Cannot Insert Employee of Employement Date %1', PayCyclePeriod."Pay Date");
                    end;
                end;
                //start pram
                Validate("Employee Name", Employee.FullName);
                Validate("Deputation On", Employee."Deputation on");
                Validate("Sol ID", Employee."Sol Id");
                Validate("CIT No.", Employee."CIT No.");
                Validate("PF No.", Employee."PF No.");
                Validate("Functional Title", Employee."Functional Title");
                Validate("Salary Grade", Employee."Salary Grade");
                Validate("Salary Level", Employee."Salary Level");
                Validate("Pan No.", Employee."PAN No.");
                Validate(Gender, Employee.Gender);
                Validate("Marital Status", Employee."Marital Status");
                //end

                HRSetup.Get;

                Validate("Global Dimension 1 Code", PayrollHeader."Global Dimension 1 Code");
                Validate("Global Dimension 2 Code", PayrollHeader."Global Dimension 2 Code");
                "Bank Account No." := Employee."Bank Account No.";
                "Bank Name" := Employee."Bank Name";
                //ValidateShortcutDimCode(GetDimensionNo(HRSetup."Employee Dimension"),DefaultDimension."Dimension Value Code");

                if PayrollHeader.Type = PayrollHeader.Type::Resignation then
                    ValidateSettlementFields;
                PayrollLine.Reset;
                PayrollLine.SetRange("Document No.", "Document No.");
                PayrollLine.SetCurrentKey(Number);
                if PayrollLine.FindLast then
                    Validate(Number, PayrollLine.Number + 1)
                else
                    Validate(Number, 1);
                //CheckPremiumInsurance("Employee No.");//Min
            end;
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
            Editable = true;
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

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(14; Remarks; Text[250]) { }
        field(15; "Present Days"; Decimal)
        {
            Description = 'P';

            trigger OnValidate()
            begin
                GetTotalDays;
            end;
        }
        field(16; "Absent Days"; Decimal)
        {
            Description = 'A';

            trigger OnValidate()
            begin
                GetTotalDays;
            end;
        }
        field(17; "Paid Days"; Decimal)
        {
            Description = 'Paid Days';
            Editable = false;
        }
        field(18; "Late Days"; Decimal)
        {
            Description = 'Late Day';
        }
        field(19; "Week off Days"; Decimal)
        {
            Description = 'W';

            trigger OnValidate()
            begin
                GetTotalDays;
            end;
        }
        field(20; "Leave Days"; Decimal)
        {
            Description = 'L';

            trigger OnValidate()
            begin
                GetTotalDays;
            end;
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
        }
        field(25; "OT Days"; Decimal)
        {
            Description = 'OT Days';

            trigger OnValidate()
            begin
                GetTotalDays;
            end;
        }
        field(26; "Late Rate"; Decimal)
        {
            Description = 'Late Rate';
            Editable = false;
        }
        field(27; "Paid Hours"; Decimal)
        {
            Editable = false;
        }
        field(28; "Unpaid Hours"; Decimal) { }
        field(29; "Total Present Hours"; Decimal)
        {
            trigger OnValidate()
            begin
                "Paid Hours" := "Total Present Hours" + "Leave Hours" + "Week Off Hours";
            end;
        }
        field(30; "Standard Hours"; Decimal)
        {
            Editable = false;
        }
        field(31; "Week Off Hours"; Decimal)
        {
            trigger OnValidate()
            begin
                "Paid Hours" := "Total Present Hours" + "Leave Hours" + "Week Off Hours";
            end;
        }
        field(32; "Leave Hours"; Decimal)
        {
            trigger OnValidate()
            begin
                "Paid Hours" := "Total Present Hours" + "Leave Hours" + "Week Off Hours";
            end;
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
        field(42; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(43; Number; Integer)
        {
            Editable = false;
        }
        field(44; "Currency Code"; Code[10])
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
        field(46; "Source Code"; Code[10])
        {
            Description = 'Pranisha';
        }
        field(47; "Variable Field 50487"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50487';
            Description = 'added for nic';
        }
        field(48; "Variable Field 50488"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50488';
            Description = 'added for nic';
        }
        field(49; "Variable Field 50489"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50489';
            Description = 'added for nic';
        }
        field(50; "Variable Field 50490"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50490';
            Description = 'added for nic';
        }
        field(51; "Variable Field 50491"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50491';
            Description = 'added for nic';
        }
        field(52; "Variable Field 50492"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50492';
            Description = 'added for nic';
        }
        field(53; "Variable Field 50493"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50493';
            Description = 'added for nic';
        }
        field(54; "Variable Field 50494"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50494';
            Description = 'added for nic';
        }
        field(55; "Variable Field 50495"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50495';
            Description = 'added for nic';
        }
        field(56; "Variable Field 50496"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50496';
            Description = 'added for nic';
        }
        field(57; "Variable Field 50497"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50497';
            Description = 'added for nic';
        }
        field(58; "Variable Field 50498"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50498';
            Description = 'added for nic';
        }
        field(59; "Variable Field 50499"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50499';
            Description = 'added for nic';
        }
        field(60; "Variable Field 50500"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            CaptionClass = '8,60024,50500';
            Description = 'added for nic';
        }
        field(61; "Variable Field 50501"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50501';
        }
        field(62; "Variable Field 50502"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50502';
        }
        field(63; "Variable Field 50503"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50503';
        }
        field(64; "Variable Field 50504"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50504';
        }
        field(65; "Variable Field 50505"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50505';
        }
        field(66; "Variable Field 50506"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50506';
        }
        field(67; "Variable Field 50507"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50507';
        }
        field(68; "Variable Field 50508"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50508';
        }
        field(69; "Variable Field 50509"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50509';
        }
        field(70; "Variable Field 50510"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50510';
        }
        field(71; "Variable Field 50511"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50511';
        }
        field(72; "Variable Field 50512"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50512';
        }
        field(73; "Variable Field 50513"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50513';
        }
        field(74; "Variable Field 50514"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50514';
        }
        field(75; "Variable Field 50515"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50515';
        }
        field(76; "Variable Field 50516"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50516';
        }
        field(77; "Variable Field 50517"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50517';
        }
        field(78; "Variable Field 50518"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50518';
        }
        field(79; "Variable Field 50519"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50519';
        }
        field(80; "Variable Field 50520"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50520';
        }
        field(81; "Variable Field 50521"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50521';
        }
        field(82; "Variable Field 50522"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50522';
        }
        field(83; "Variable Field 50523"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50523';
        }
        field(84; "Variable Field 50524"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50524';
        }
        field(85; "Variable Field 50525"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50525';
        }
        field(86; "Variable Field 50526"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50526';
        }
        field(87; "Variable Field 50527"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50527';
        }
        field(88; "Variable Field 50528"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50528';
        }
        field(89; "Variable Field 50529"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50529';
        }
        field(90; "Variable Field 50530"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50530';
        }
        field(91; "Variable Field 50531"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50531';
        }
        field(92; "Variable Field 50532"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50532';
        }
        field(93; "Variable Field 50533"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50533';
        }
        field(94; "Variable Field 50534"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50534';
        }
        field(95; "Variable Field 50535"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50535';
        }
        field(96; "Variable Field 50536"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50536';
        }
        field(97; "Variable Field 50537"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50537';
        }
        field(98; "Variable Field 50538"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50538';
        }
        field(99; "Variable Field 50539"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50539';
        }
        field(100; "Variable Field 50540"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,60024,50540';
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
            Editable = false;
        }
        field(123; "Past Benefit"; Decimal)
        {
            Editable = false;
        }
        field(124; "Assessable Income"; Decimal)
        {
            Editable = false;
        }
        field(125; "Past Retirement Fund"; Decimal)
        {
            Editable = false;
        }
        field(126; "Projected Retirement Fund"; Decimal)
        {
            Editable = false;
        }
        field(127; "Actual RF Contribution"; Decimal)
        {
            Editable = false;
        }
        field(128; "1/3 of Assessable Income"; Decimal)
        {
            Editable = false;
        }
        field(129; "Eligible RF Deduction"; Decimal)
        {
            Editable = false;
        }
        field(130; "Life Insurance Premium"; Decimal)
        {
            Editable = false;
        }
        field(131; "Health Insurance Premium"; Decimal)
        {
            Editable = false;
        }
        field(132; "Taxable Income"; Decimal)
        {
            Editable = false;
        }
        field(133; "Disable Person Reduction"; Decimal)
        {
            Editable = false;
        }
        field(134; "Female Tax Credit"; Decimal)
        {
            Editable = false;
        }
        field(135; "Total Tax Liability"; Decimal)
        {
            Editable = false;
        }
        field(136; "Payable Tax Liability"; Decimal)
        {
            Editable = false;
        }
        field(137; "Net Tax Liability"; Decimal)
        {
            Editable = false;
        }
        field(138; "Social Security Tax(Annual)"; Decimal)
        {
            Editable = false;
        }
        field(139; "Tax on Remuneration(Annual)"; Decimal)
        {
            Editable = false;
        }
        field(140; "Total Tax Paid"; Decimal)
        {
            Editable = false;
        }
        field(141; "Carry Forwarded Sick"; Decimal)
        {
            Editable = false;
        }
        field(142; "Carry Forward Annual"; Decimal)
        {
            Editable = false;
        }
        field(143; "Prorata Sick"; Decimal)
        {
            Editable = false;
        }
        field(144; "Prorata Annual"; Decimal)
        {
            Editable = false;
        }
        field(145; "Used Leave Sick"; Decimal)
        {
            Editable = false;
        }
        field(146; "Used Leave Annual"; Decimal)
        {
            Editable = false;
        }
        field(147; "Gratuity & leave Encash Tax"; Decimal)
        {
        }
        field(148; "Projection Month"; Decimal)
        {
        }
        field(149; "Deputation On"; Enum "Deputation Type")
        {

            trigger OnValidate()
            begin
                Validate("Deputation Value", ExitTransferDeputationWise("Deputation On"));
            end;
        }
        field(150; "Deputation Value"; Code[20])
        {
        }
        field(151; "Sol ID"; Code[10])
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
        field(160; "Marital Status"; enum "Marital Status")
        {

        }
        field(161; "Total SST Paid"; Decimal) { }
        field(162; "Total Tax Remuneration Paid"; Decimal) { }
        field(163; "LWP Days"; Decimal) { }
        field(164; "Prior Leave Days"; Decimal) { }
        field(165; "Property Insurance Premium"; Decimal) { }
        field(166; Selected; Boolean) { }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Net Pay";
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        TestStatusOpen;

        GetPayrollHeader;

        /* UTS commented
        TimeSheetSummary.RESET;
        TimeSheetSummary.SETCURRENTKEY("Employee Code","From Date","To Date");
        TimeSheetSummary.SETRANGE("Employee Code","Employee No.");
        TimeSheetSummary.SETRANGE("From Date",PayrollHeader."From Date");
        TimeSheetSummary.SETRANGE("To Date",PayrollHeader."To Date");
        TimeSheetSummary.DELETEALL;

        JournalAllocation.RESET;
        JournalAllocation.SETRANGE("Document No.","Document No.");
        JournalAllocation.SETRANGE("Journal Line No.","Line No.");
        JournalAllocation.DELETEALL;
        */
        EmployeeAdj.Reset;
        EmployeeAdj.SetRange("Payroll Document No.", "Document No.");
        EmployeeAdj.SetRange("Employee No.", "Employee No.");
        EmployeeAdj.DeleteAll;
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
        LockTable;
        CheckDuplicateEmployee;
        PGSetup.Get;
        AttendanceSetup.Get;

        if AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::Attendance then begin
            PayrollEngine.GetAttendanceForPayroll(Rec, PayrollHeader);
        end
        else if AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::"Time Sheet" then begin
            //PayrollEngine.PrepareEmployeeDailyTimesheet(Rec,PayrollHeader);
            //PayrollEngine.GetTimeSheetForPayroll(Rec,PayrollHeader);
            //PayrollEngine.CreateTimeSheetAllocation(Rec,PayrollHeader);
        end;

        SourceCodeSetup.Get;
        SourceCodeSetup.TestField("Payroll Plan");
        "Source Code" := SourceCodeSetup."Payroll Plan";
    end;

    trigger OnModify()
    begin
        //TestStatusOpen;
    end;

    trigger OnRename()
    begin
        Error(Text005, TableCaption);
    end;

    var
        PayrollHeader: Record "Payroll Header";
        PayCyclePeriod: Record "Pay Cycle Period";
        Text005: Label 'You cannot rename a %1.';
        Text000: Label 'Total Days (T) must be %1 for Employee %2.';
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        BasicSalarywithGrade: Record "Level Wise Attributes";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
        PGSetup: Record "Payroll General Setup";
        AttendanceSetup: Record "Attendance Setup";
        Currency: Record Currency;
        PayrollEngine: Codeunit "Payroll Engine";
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;
        BasicSalaryAfterDeduction: Decimal;
        Text002: Label 'You cannot change %1 on this document. You have to configure it either in Payroll Attribute Usage or in Payroll Attributes page.';
        Text003: Label 'Summation of Paid Hours & Unpaid Hours must be %1 for Employee %2.';
        Text004: Label 'Employee %1 already exists on Line No. %2.';
        SourceCodeSetup: Record "Source Code Setup";
        EmpActRec: Record "Employee Activity";
        LeaveEarn: Record "Leave Earn";
        UsedDays: Decimal;
        EngNep: Record "English-Nepali Date";
        PromotionHistory: Record "Promotion History";
        PayrollLine: Record "Payroll Line";
        EmployeeAdj: Record "Employee Payroll Adjustment";
        SettlementRecovery: Decimal;
        EmployeeLedgerEntry: Record "Employee Ledger Entry";

    procedure GetTotalDays()
    begin
        "Total Days" := "Present Days" + "Week off Days" + "Leave Days" + "Absent Days";
        //"OT Hrs (30MIN)" := "OT Days" * 30/60;
    end;

    procedure GetPayrollHeader()
    begin
        PayrollHeader.Get("Document No.");
        if PayrollHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            Currency.Get(PayrollHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;

    procedure CheckDocument()
    begin
        GetPayrollHeader;
        TestTotalDays(PayrollHeader);
    end;

    procedure TestTotalDays(PayrollHeader: Record "Payroll Header")
    var
        PayPeriodDays: Decimal;
        PayPeriodHours: Decimal;
    begin
        AttendanceSetup.Get;
        PGSetup.Get;
        PayrollHeader.TestField("Pay Cycle Code");
        PayrollHeader.TestField("Pay Cycle Term");
        PayrollHeader.TestField("Pay Cycle Period");
        PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period");
        PayPeriodDays := PayCyclePeriod."End Date" - PayCyclePeriod."Start Date" + 1;
        PayPeriodHours := PayPeriodDays * AttendanceSetup."Working Hour per day";

        if not (PayrollHeader.Irregular or (PayrollHeader.Type = PayrollHeader.Type::Resignation)) then begin
            if PayPeriodDays <> "Total Days" then
                Error(Text000, PayPeriodDays, "Employee No.");
        end;

        if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Hour then
            if ("Paid Hours" + "Unpaid Hours") <> PayPeriodHours then
                Error(Text003, PayPeriodHours, "Employee No.");
    end;

    procedure ValidateEmployee()
    begin
        GetPayrollHeader;
        Employee.Get("Employee No.");
        Employee.TestField("Salary Grade");
        Employee.TestField("Salary Level");
        Employee.TestField("Employment Date");
        if not (PayrollHeader.Type = PayrollHeader.Type::Resignation) then
            Employee.TestField(Status, Employee.Status::Active);
        Employee.TestField("Tax Code");
        HRSetup.Get;
        //HRSetup.TESTFIELD("Employee Dimension");
        HRSetup.TestField("Base Interest Rate");
        AttendanceSetup.Get;
        /*DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID",DATABASE::Employee);
        DefaultDimension.SETRANGE("No.",Employee."No.");
        DefaultDimension.SETRANGE("Dimension Code",HRSetup."Employee Dimension");
        IF NOT DefaultDimension.FINDFIRST THEN
          ERROR(Text001,Employee."No.");*/
        BasicSalarywithGrade.Get(Employee."Salary Grade", Employee."Salary Level");
        if not PayrollHeader.Irregular then begin
            TestTotalDays(PayrollHeader);
            //TESTFIELD("Present Days");
        end;
        if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Hour then
            TestField("Paid Hours");
        Validate("Global Dimension 1 Code", Employee."Global Dimension 1 Code");
        Validate("Global Dimension 2 Code", Employee."Global Dimension 2 Code");
        "Bank Account No." := Employee."Bank Account No.";
        "Bank Name" := Employee."Bank Name";
        //ValidateShortcutDimCode(GetDimensionNo(HRSetup."Employee Dimension"),DefaultDimension."Dimension Value Code");
        Modify;
        GetPayrollAttributes;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    local procedure GetDimensionNo(DimensionCode: Code[20]) DimensionNo: Integer
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        DimensionNo := 0;
        if GLSetup."Global Dimension 1 Code" = DimensionCode then
            DimensionNo := 1;
        if GLSetup."Global Dimension 2 Code" = DimensionCode then
            DimensionNo := 2;
        if GLSetup."Shortcut Dimension 3 Code" = DimensionCode then
            DimensionNo := 3;
        if GLSetup."Shortcut Dimension 4 Code" = DimensionCode then
            DimensionNo := 4;
        if GLSetup."Shortcut Dimension 5 Code" = DimensionCode then
            DimensionNo := 5;
        if GLSetup."Shortcut Dimension 6 Code" = DimensionCode then
            DimensionNo := 6;
        if GLSetup."Shortcut Dimension 7 Code" = DimensionCode then
            DimensionNo := 7;
        if GLSetup."Shortcut Dimension 8 Code" = DimensionCode then
            DimensionNo := 8;
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', '', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;

    local procedure GetPayrollAttributes()
    var
        AbsentDeductionAmount: Decimal;
        AttributeAmount: Decimal;
        EmpSalAdv: Record "Employee Loan/Advance";
        LoanOutstandingfromFinacle: Record "Loan Outstanding from Finacle";
    begin
        GetPayrollHeader;
        if not PayrollHeader.Irregular then
            /*IF "Present Days" = 0 THEN
              EXIT;*/
        PGSetup.Get;
        PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period");
        AbsentDeductionAmount := 0;
        BasicSalaryAfterDeduction := GetBasicSalaryAfterDeduction;
        "Late Rate" := Round("Basic Salary" / 30 / 3, 1, '=');
        Clear(SettlementRecovery);
        EmpSalAdv.Reset;
        EmpSalAdv.SetRange("Employee Code", "Employee No.");
        EmpSalAdv.SetRange("Approval Status", EmpSalAdv."Approval Status"::Approved);
        EmpSalAdv.SetRange(Settled, false);
        EmpSalAdv.SetRange("Loan Type", EmpSalAdv."Loan Type"::"Salary Advance");
        if EmpSalAdv.FindFirst then
            Validate("Salary Advance No.", EmpSalAdv."No.");
        Modify;
        ResetValues;
        Clear(PromotionHistory);
        PromotionHistory.Reset;
        PromotionHistory.SetRange("Employee No.", "Employee No.");
        PromotionHistory.SetRange("Promoted Date", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
        if PromotionHistory.FindFirst then;
        GetGlobalAttributes; //temporary
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        //PayrollAttributesUsage.SETFILTER(Code,'PF-BENEFIT');//Min -- for Check
        if PayrollAttributesUsage.FindFirst then
            repeat
                //IF PayrollAttributes.GET(PayrollAttributesUsage.Code) THEN BEGIN
                PayrollAttributes.Reset;
                if not PayrollHeader.Irregular then
                    PayrollAttributes.SetRange(Irregular, false)
                else
                    PayrollAttributes.SetRange(Irregular, true);
                //PayrollAttributes.SETRANGE("Apply Every Month",TRUE);
                PayrollAttributes.SetRange(Code, PayrollAttributesUsage.Code);
                if PayrollAttributes.FindFirst then begin
                    AttributeAmount := 0;
                    if IsValidComponent then begin
                        if PayrollAttributesUsage.Amount <> 0 then begin
                            if PGSetup."Loan Attribute" = PayrollAttributes.Code then begin
                                if (PayrollAttributesUsage."Is Loan EMI Applicable") then
                                    if (PayrollAttributesUsage."Last EMI Date" = 0D) then begin
                                        AttributeAmount := PayrollAttributesUsage.Amount;
                                    end else
                                        if (PayrollAttributesUsage."Last EMI Date" >= PayrollHeader."From Date") then
                                            AttributeAmount := PayrollAttributesUsage.Amount;
                            end else
                                AttributeAmount := PayrollAttributesUsage.Amount;
                        end else
                            if PayrollAttributesUsage.Formula <> '' then
                                AttributeAmount := EvaluateAmount(PayrollAttributesUsage.Formula, false)
                            else
                                if PayrollAttributes.Formula <> '' then
                                    AttributeAmount := EvaluateAmount(PayrollAttributes.Formula, false)
                                else
                                    AttributeAmount := PayrollEngine.ValidateAttributes(PayrollAttributes.Code, Rec, PayCyclePeriod);
                        if PayrollAttributes."Apply Every Month" then begin
                            PayrollAttributesUsage.Amount := AttributeAmount;
                            PayrollAttributesUsage.Modify;
                        end;
                        if PayrollAttributes."Deduct on Absent" then begin
                            AttributeAmount := GetAmountAfterAbsentism(AttributeAmount);
                        end;   //temporary
                        if PayrollAttributes."Differential Interest" then begin //calculate differential interest
                            LoanOutstandingfromFinacle.Reset;
                            LoanOutstandingfromFinacle.SetRange("Employee No.", Employee."No.");
                            LoanOutstandingfromFinacle.SetFilter("Outstanding Amount", '<>0');
                            LoanOutstandingfromFinacle.SetRange("Is Manual", false);
                            if LoanOutstandingfromFinacle.FindSet then
                                repeat
                                    case LoanOutstandingfromFinacle."Loan Type" of
                                        LoanOutstandingfromFinacle."Loan Type"::"Personal Loan":
                                            AttributeAmount += CalculateDifferentialnterest(2, LoanOutstandingfromFinacle."Outstanding Amount");
                                        LoanOutstandingfromFinacle."Loan Type"::"Home Loan", LoanOutstandingfromFinacle."Loan Type"::"Home Loan Insurance Tieup":
                                            AttributeAmount += CalculateDifferentialnterest(3, LoanOutstandingfromFinacle."Outstanding Amount");
                                        LoanOutstandingfromFinacle."Loan Type"::"Vehicle Loan":
                                            AttributeAmount += CalculateDifferentialnterest(4, LoanOutstandingfromFinacle."Outstanding Amount");
                                    end;
                                until LoanOutstandingfromFinacle.Next = 0;
                        end;
                        /*IF PayrollAttributes.Subtype IN [PayrollAttributes.Subtype::"Employee Contribution",PayrollAttributes.Subtype::"Employer Contribution"] THEN
                           BasicAdjustmentPF(AttributeAmount);*/
                        RoundAmount(AttributeAmount);
                        if AttributeAmount <> 0 then //pradhan
                            SaveValues(AttributeAmount, PayrollAttributes.Code);
                    end;
                end;
            //END; //Min 3.20.2022 -- Commented
            until PayrollAttributesUsage.Next = 0;
        if PGSetup."Late Deduction Component" <> '' then begin
            if PayrollAttributes.Get(PGSetup."Late Deduction Component") then begin
                if PayrollAttributes.Status = PayrollAttributes.Status::Active then begin
                    AttributeAmount := "Late Rate" * "Late Days";
                    RoundAmount(AttributeAmount);
                    SaveValues(AttributeAmount, PayrollAttributes.Code);
                end;
            end;
        end;
        /*
        IF PGSetup."OT Benefit Component" <> '' THEN BEGIN
          IF PayrollAttributes.GET(PGSetup."OT Benefit Component") THEN BEGIN
            IF PayrollAttributes.Status = PayrollAttributes.Status::Active THEN BEGIN
              IF PayrollAttributesUsage.GET(PayrollAttributes.Code,Employee."No.") THEN BEGIN
                AttributeAmount := ("Basic Salary" / "Total Days" / AttendanceSetup."Working Hour per day" * "OT Hrs");
                RoundAmount(AttributeAmount);
                SaveValues(AttributeAmount,PayrollAttributes.Code);
              END;
            END;
          END;
        END;
        */
        //AT >>
        if "Total Insurance Claim Amount" > 0 then begin
            if PGSetup."Insurance Recover" <> '' then begin
                if PayrollAttributes.Get(PGSetup."Insurance Recover") then begin
                    if PayrollAttributes.Status = PayrollAttributes.Status::Active then begin
                        if PayrollAttributesUsage.Get(PayrollAttributes.Code, Employee."No.") then begin
                            HRSetup.Get;
                            AttributeAmount := ((HRSetup."Policy End Date" - "Resignation Date") / 365) * HRSetup."Medical Insurance Premium";
                            RoundAmount(AttributeAmount);
                            SaveValues(AttributeAmount, PayrollAttributes.Code);
                        end;
                    end;
                end;
            end;
        end;
        //AT <<
        if PayrollHeader.Type = PayrollHeader.Type::Resignation then begin
            if PGSetup."Settlement Recovery" <> '' then begin
                if PayrollAttributes.Get(PGSetup."Settlement Recovery") then begin
                    RoundAmount(SettlementRecovery);
                    SaveValues(SettlementRecovery, PayrollAttributes.Code);
                end;
            end;
        end;
    end;

    local procedure IsValidComponent(): Boolean
    begin
        if PayrollAttributes.Status = PayrollAttributes.Status::Active then begin
            if PayrollAttributesUsage."Pay Cycle Period" <> 0 then begin
                if (PayrollAttributesUsage."Pay Cycle Code" = PayrollHeader."Pay Cycle Code") and
                    (PayrollAttributesUsage."Pay Cycle Term" = PayrollHeader."Pay Cycle Term") and
                      (PayrollAttributesUsage."Pay Cycle Period" = PayrollHeader."Pay Cycle Period") then begin
                    exit(IsValidPeriod);
                end;
            end
            else begin
                if PayrollAttributes."Pay Cycle Period" <> 0 then begin
                    if (PayrollAttributes."Pay Cycle Code" = PayrollHeader."Pay Cycle Code") and
                        (PayrollAttributes."Pay Cycle Term" = PayrollHeader."Pay Cycle Term") and
                          (PayrollAttributes."Pay Cycle Period" = PayrollHeader."Pay Cycle Period") then begin
                        exit(IsValidPeriod);
                    end;
                end
                else
                    exit(IsValidPeriod);
            end;
        end;
    end;

    local procedure IsValidPeriod(): Boolean
    begin
        exit(true);
        /*IF (PayrollAttributesUsage."Pay Period Start Date" <> 0D) AND (PayrollAttributesUsage."Pay Period End Date" <> 0D) THEN BEGIN
          IF (PayrollAttributesUsage."Pay Period Start Date" <= PayrollHeader."From Date") AND
              (PayrollAttributesUsage."Pay Period End Date" >= PayrollHeader."To Date")
           THEN
            EXIT(TRUE);
        END
        ELSE IF (PayrollAttributesUsage."Pay Period Start Date" <> 0D) AND (PayrollAttributesUsage."Pay Period End Date" = 0D) THEN BEGIN
          IF (PayrollAttributesUsage."Pay Period Start Date" > PayrollHeader."From Date") AND
              (PayrollAttributesUsage."Pay Period Start Date" <= PayrollHeader."To Date") THEN
          EXIT(TRUE);
          IF PayrollAttributesUsage."Pay Period Start Date" <= PayrollHeader."From Date" THEN
            EXIT(TRUE);
        END
        ELSE IF (PayrollAttributesUsage."Pay Period Start Date" = 0D) AND (PayrollAttributesUsage."Pay Period End Date" <> 0D) THEN BEGIN
          IF PayrollAttributesUsage."Pay Period End Date" >= PayrollHeader."To Date" THEN
            EXIT(TRUE);
        END
        ELSE
          EXIT(TRUE);
        */
    end;

    procedure EvaluateAmount(Expression: Code[100]; BasicFromLine: Boolean): Decimal
    var
        OperatorStack: array[100] of Code[10];
        NumberStack: array[100] of Decimal;
        DecNumber: Decimal;
        ContiguousNumber: Boolean;
        CurrExpr: Code[100];
        Counter: Integer;
        Num1: Decimal;
        Num2: Decimal;
        operat: Code[10];
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
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BasicAmount: Decimal;
        Substring1: Text;
        SubString2: Text;
        SubString3: Text;
        Length: Integer;
    begin
        Expression := DelChr(Expression, '=');
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Benefits);
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Basic);
        PayrollAttributes.FindFirst;

        BasicAmount := "Basic Salary";
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        if PayrollAttributesUsage.FindFirst then begin
            PayrollAttributesUsage.TestField(Amount);
            BasicAmount := PayrollAttributesUsage.Amount;
        end;

        StrPosition := StrPos(Expression, PayrollAttributes."Column Name");
        if StrPosition > 0 then begin
            Expression := DelStr(Expression, StrPosition, StrLen(PayrollAttributes."Column Name"));
            if BasicFromLine then
                Expression := InsStr(Expression, Format(BasicSalaryAfterDeduction), StrPosition)
            else
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
                    PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
                    if PayrollAttributesUsage.FindFirst then begin
                        //IF PayrollAttributesUsage.Amount <> 0 THEN          //pradhan
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

    local procedure IsContribution(): Boolean
    begin
        exit((PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Employee Contribution") or
              (PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Employer Contribution"))
    end;

    local procedure GetBasicSalaryAfterDeduction(): Decimal
    begin
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Basic);
        PayrollAttributes.FindFirst;

        "Basic Salary" := BasicSalarywithGrade."Total Basic Salary";
        if PayrollAttributesUsage.Get(PayrollAttributes.Code, "Employee No.") then begin
            //PayrollAttributesUsage.TESTFIELD(Amount);
            if PayrollAttributesUsage.Amount <> 0 then
                "Basic Salary" := PayrollAttributesUsage.Amount;
        end;

        exit(GetAmountAfterAbsentism(PayrollAttributesUsage.Amount));
    end;

    procedure SaveValues(FieldValue: Decimal; AttributeCode: Code[20])
    var
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
    begin
        PayrollColumnConfiguration.Reset;
        PayrollColumnConfiguration.SetRange("Table No.", Database::"Payroll Line");
        PayrollColumnConfiguration.SetRange("Variable Field Code", AttributeCode);
        if PayrollColumnConfiguration.FindFirst then begin
            RecRefs.Open(Database::"Payroll Line");
            FieldRefs := RecRefs.Field(1);
            FieldRefs.SetRange(PayrollHeader."No.");
            FieldRefs := RecRefs.Field(2);
            FieldRefs.SetRange("Line No.");
            RecRefs.FindFirst;
            FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
            FieldRefs.Validate(FieldValue);
            RecRefs.Modify;

        end;
    end;

    local procedure GetAmountAfterAbsentism(CalculatedAmount: Decimal): Decimal
    var
        PostedPayHeader: Record "Posted Payroll Header";
    begin
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
            if not PayrollHeader.Irregular then begin
                if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Day then
                    exit((CalculatedAmount / "Total Days") * ("Present Days" + "Week off Days" + "Leave Days") +
                        (CalculatedAmount / PayrollEngine.GetPreviousPayCycleCodeDays(PayrollHeader) * ("Prior Present Days" - "Prior Absent Days"))) //deduct on prior absent.
                else
                    exit((CalculatedAmount / ("Total Days" * AttendanceSetup."Working Hour per day")) * ("Paid Hours"))
            end;
        end else begin
            if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Day then begin
                EmployeeLedgerEntry.Reset();
                EmployeeLedgerEntry.SetRange("Employee No.", "Employee No.");
                EmployeeLedgerEntry.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
                EmployeeLedgerEntry.SetRange("Pay Cycle Period", PayrollHeader."Pay Cycle Period");
                EmployeeLedgerEntry.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
                EmployeeLedgerEntry.SetRange(Type, EmployeeLedgerEntry.Type::Payroll);
                if (EmployeeLedgerEntry.FindFirst) and (not (PayrollAttributes.Code in [PGSetup.Gratuity, PGSetup."Leave Encashment"])) then
                    exit(-(CalculatedAmount / PayrollHeader."Total Days" * "Absent Days"));

                if "Prior Absent Days" + "Prior Leave Days" + "Prior Present Days" = 0 then
                    exit((CalculatedAmount / PayrollHeader."Total Days") * ("Total Days" - "Absent Days"))
                else
                    exit((CalculatedAmount / PayrollHeader."Total Days") * ("Total Days" - "Absent Days") +
                        (CalculatedAmount / ("Prior Absent Days" + "Prior Leave Days" + "Prior Present Days") *
                        (("Prior Absent Days" + "Prior Leave Days" + "Prior Present Days") - "Prior Absent Days"))) //deduct on prior absent.
            end else
                exit((CalculatedAmount / (PayrollHeader."Total Days" * AttendanceSetup."Working Hour per day")) * ("Paid Hours"))
        end;
    end;

    procedure RoundAmount(var Amount: Decimal)
    begin
        Amount := Round(Amount, Currency."Amount Rounding Precision");
    end;

    procedure ResetValues()
    var
        FieldID: Integer;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
    begin
        RecRefs.Open(Database::"Payroll Line");
        for FieldID := 50490 to 50540 do begin
            FieldRefs := RecRefs.Field(1);
            FieldRefs.SetRange(PayrollHeader."No.");
            FieldRefs := RecRefs.Field(2);
            FieldRefs.SetRange("Line No.");
            RecRefs.FindFirst;
            FieldRefs := RecRefs.Field(FieldID);
            FieldRefs.Validate(0);
            RecRefs.Modify;
        end;
    end;

    procedure TestStatusOpen()
    begin
        GetPayrollHeader;
        PayrollHeader.TestField(Status, PayrollHeader.Status::Open);
    end;

    procedure CheckFlexibility(FieldID: Integer)
    var
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
    begin
        if PayrollColumnConfiguration.Get(Database::"Payroll Line", FieldID) then begin
            begin
                if PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code") then
                    if not PayrollAttributes."Plan Flexible" then
                        Error(Text002, PayrollAttributes.Code);
            end;
        end;
    end;

    procedure GetAttendance()
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        EmployeeAttendanceList: Page "Employee Attendance & Activity";
    begin
        GetPayrollHeader;
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.FilterGroup(2);
        EmployeeAttendanceActivity.SetRange("Employee No.", "Employee No.");
        EmployeeAttendanceActivity.SetRange("Attendance Date", PayrollHeader."From Date", PayrollHeader."To Date");
        EmployeeAttendanceActivity.FilterGroup(0);
        Clear(EmployeeAttendanceList);
        EmployeeAttendanceList.SetTableView(EmployeeAttendanceActivity);
        EmployeeAttendanceList.Editable(false);
        EmployeeAttendanceList.RunModal;
    end;

    local procedure GetGlobalAttributes()
    var
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        AttributeAmount: Decimal;
        FieldID: Integer;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PriorPromotionAmt: Decimal;
    begin
        PayrollColumnConfiguration.Reset;
        PayrollColumnConfiguration.SetRange("Table No.", DATABASE::"Level Wise Attributes");
        if PayrollColumnConfiguration.FindSet then begin
            RecRefs.Open(DATABASE::"Level Wise Attributes");
            repeat
                if PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code") then begin
                    AttributeAmount := 0;
                    //IF IsValidComponent THEN BEGIN //Min 3.20.2022 -- Commented
                    FieldRefs := RecRefs.Field(1);
                    FieldRefs.SetRange(Employee."Salary Grade");
                    FieldRefs := RecRefs.Field(2);
                    FieldRefs.SetRange(Employee."Salary Level");
                    RecRefs.FindFirst;
                    FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
                    Evaluate(AttributeAmount, Format(FieldRefs.Value));
                    if PromotionHistory."Promoted Date" <> 0D then begin
                        AttributeAmount := AttributeAmount / "Total Days" * (PayCyclePeriod."End Date" - PromotionHistory."Promoted Date" + 1);
                        RecRefs.Reset;
                        FieldRefs := RecRefs.Field(1);
                        FieldRefs.SetRange(PromotionHistory."Previous Salary Grade");
                        FieldRefs := RecRefs.Field(2);
                        FieldRefs.SetRange(PromotionHistory."Previous Salary Level Code");
                        RecRefs.FindFirst;
                        FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
                        Evaluate(PriorPromotionAmt, Format(FieldRefs.Value));
                        PriorPromotionAmt := PriorPromotionAmt / "Total Days" * (PromotionHistory."Promoted Date" - PayCyclePeriod."Start Date");
                        AttributeAmount := AttributeAmount + PriorPromotionAmt;
                    end;
                    /*IF PayrollAttributes."Deduct on Absent" THEN BEGIN //pradhan -- calculating of after dedcution
                       AttributeAmount := GetAmountAfterAbsentism(AttributeAmount);
                     END;*/
                    RoundAmount(AttributeAmount);
                    if PayrollHeader.Type = PayrollHeader.Type::Resignation then
                        DeductForRecovery(AttributeAmount);
                    if not PayrollHeader.Irregular then
                        SaveValues(AttributeAmount, PayrollAttributes.Code);
                    PayrollAttributesUsageModify(PayrollAttributes.Code, AttributeAmount);
                end;
            //END; //Min 3.20.2022 -- Commented
            until PayrollColumnConfiguration.Next = 0;
        end;

    end;

    procedure CheckDuplicateEmployee()
    var
        PayrollLine: Record "Payroll Line";
    begin
        PayrollLine.Reset;
        PayrollLine.SetRange("Document No.", "Document No.");
        PayrollLine.SetRange("Employee No.", "Employee No.");
        PayrollLine.SetFilter("Line No.", '<>%1', "Line No.");
        if PayrollLine.FindFirst then
            Error(Text004, "Employee No.", PayrollLine."Line No.");
    end;

    local procedure PayrollAttributesUsageModify(PayrollCode: Code[20]; Amt: Decimal)
    var
        PayrollAttUsage: Record "Payroll Attributes Usage";
    begin
        if PayrollAttUsage.Get(PayrollCode, "Employee No.") then begin
            PayrollAttUsage.Amount := Amt;
            PayrollAttUsage.Modify;
        end;
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

    local procedure CheckSettlement()
    var
        PostedPayrollHeader: Record "Posted Payroll Header";
        PostedPayrollline: Record "Posted Payroll Line";
    begin
        EmpActRec.Reset;
        EmpActRec.SetRange(Type, EmpActRec.Type::Resignation);
        EmpActRec.SetRange("Employee No.", "Employee No.");
        EmpActRec.SetRange("Approval Status", EmpActRec."Approval Status"::Approved);
        if not EmpActRec.FindFirst then
            Error('Resignation not approved yet.');

        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Resignation);
        if PostedPayrollHeader.FindFirst then
            repeat
                PostedPayrollline.Reset;
                PostedPayrollline.SetRange("Document No.", PostedPayrollHeader."No.");
                PostedPayrollline.SetRange("Employee No.", "Employee No.");
                if PostedPayrollline.FindFirst then
                    Error('Settlement already processed in document no. %1', PostedPayrollHeader."No.");
            until PostedPayrollHeader.Next = 0;
    end;

    local procedure ValidateSettlementFields()
    var
        LeaveTypeSetup: Record "Leave Type Setup";
    begin
        Employee.Get("Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Permanent then begin

            Validate("Gratuity Years", Round((Employee."Resignation Date" - Employee."Employment Date") / 365, 0.001, '='));
        end;
        EmpActRec.Reset;
        EmpActRec.SetRange("Employee No.", "Employee No.");
        EmpActRec.SetRange(Type, EmpActRec.Type::Resignation);
        EmpActRec.SetRange("Approval Status", EmpActRec."Approval Status"::Approved);
        if EmpActRec.FindFirst then begin
            if Employee."Resignation Date" = 0D then
                Validate("Resignation Date", Employee."Contract Expiry Date")
            else
                Validate("Resignation Date", Employee."Resignation Date");

            //LFA days
            Clear(LeaveEarn);
            Clear(LeaveTypeSetup);
            LeaveTypeSetup.SetRange("AML Eligible", true);
            if LeaveTypeSetup.FindFirst then begin
                Clear(UsedDays);
                LeaveEarn.Reset;
                LeaveEarn.SetRange(EmpNo, "Employee No.");
                LeaveEarn.SetRange("Leave Code", LeaveTypeSetup.Code);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Used);
                LeaveEarn.SetRange("Fiscal year", EngNep."Fiscal Year");
                LeaveEarn.CalcSums("Balancing Days");
                UsedDays := LeaveEarn."Balancing Days";

                if UsedDays > 0 then
                    Validate(LFA, UsedDays - PayrollEngine.CalculateProRataLeaveSettlement(LeaveTypeSetup.Code, Employee."Employment Date", "Resignation Date"));
            end;
        end;

        //AT >>

        EmpActRec.Reset;
        EmpActRec.SetRange("Employee No.", "Employee No.");
        EmpActRec.SetRange(Type, EmpActRec.Type::"Medical Insurance Claim");
        EmpActRec.SetRange("Approval Status", EmpActRec."Approval Status"::Approved);
        if EmpActRec.FindFirst then
            repeat
                "Total Insurance Claim Amount" += EmpActRec."Total Insurance Claim Amount";
            until EmpActRec.Next = 0;
        //AT <<
    end;


    local procedure ExitTransferDeputationWise(DeputationOn: Enum "Deputation Type"): Text
    var
        DimValue: Record "Dimension Value";
        Depart: Record Department;
        EmpHie: Record "Employee Hierarchy Master";
        SubProvince: Record "Sub Province";
        Province: Record Province;
        GLSetup: Record "General Ledger Setup";
    begin
        Clear(DimValue);
        GLSetup.Get;
        Clear(Depart);
        Clear(EmpHie);
        Clear(SubProvince);
        Clear(Province);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if DimValue.Get(GLSetup."Global Dimension 1 Code", Employee."Global Dimension 1 Code") then
                        exit(DimValue.Code);
                end;

            DeputationOn::Department:
                begin
                    if Depart.Get(Employee."Department Code") then
                        exit(Depart.Code);
                end;

            DeputationOn::"Extension Counter":
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    if EmpHie.FindFirst then
                        exit(EmpHie.Code);
                end;

            DeputationOn::"Sub Province":
                begin
                    SubProvince.Reset;
                    SubProvince.SetRange(Code, Employee."Sub Province Code");
                    if SubProvince.FindFirst then
                        exit(SubProvince.Code);
                end;

            DeputationOn::Unit:
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    if EmpHie.FindFirst then
                        exit(EmpHie.Code);
                end;

            DeputationOn::Province:
                begin
                    if Province.Get(Employee."Province Code") then
                        exit(Province.Code);
                end;
        end;
    end;

    local procedure BasicAdjustmentPF(var AttributeAmount: Decimal)
    var
        PayrollAttUsage: Record "Payroll Attributes Usage";
        AdjustPFAmt: Decimal;
    begin
        PGSetup.TestField("Basic Adjustment Code");
        if PayrollAttUsage.Get(PGSetup."Basic Adjustment Code", "Employee No.") then begin
            AdjustPFAmt := 0.1 * PayrollAttUsage.Amount;
            AttributeAmount += AdjustPFAmt;
        end;
    end;


    local procedure CalculateDifferentialnterest(LoanType: Enum "Loan Type"; OutstandingAmt: Decimal): Decimal
    var
        EmployeeLoanInterest: Record "Employee Loan Interest";
        DiffIntAmt: Decimal;
        CalcDate: Date;
        EmployeeLoanInterest1: Record "Employee Loan Interest";
        CalcDate1: Date;
    begin
        EmployeeLoanInterest.Reset;
        EmployeeLoanInterest.SetRange("Loan Type", LoanType);
        EmployeeLoanInterest.SetRange("Starting Date", PayrollHeader."From Date", PayrollHeader."To Date");
        if EmployeeLoanInterest.FindLast then begin
            repeat
                if CalcDate = 0D then
                    CalcDate := PayrollHeader."To Date" + 1;
                //IF CalcDate1 = 0D THEN
                CalcDate1 := EmployeeLoanInterest."Starting Date";
                if PayrollHeader."Previous Year Payroll" then //Min 7.18.2022
                    DiffIntAmt += ((OutstandingAmt / (PGSetup."Prev Fiscal Year End Date" - PGSetup."Prev Fiscal Year Start Date" + 1) *
                                    ((HRSetup."Base Interest Rate" - EmployeeLoanInterest."Interest Rate") / 100) *
                                       (CalcDate - CalcDate1)))
                else
                    DiffIntAmt += ((OutstandingAmt / (PGSetup."Payroll Fiscal Year End Date" - PGSetup."Payroll Fiscal Year Start Date" + 1) *
                                    ((HRSetup."Base Interest Rate" - EmployeeLoanInterest."Interest Rate") / 100) *
                                       (CalcDate - CalcDate1)));

                CalcDate := CalcDate1;
                if (EmployeeLoanInterest."Starting Date" < PayrollHeader."From Date") then
                    CalcDate1 := EmployeeLoanInterest."Starting Date"
                else
                    CalcDate1 := PayrollHeader."From Date";
            until EmployeeLoanInterest.Next(-1) = 0;
            if PayrollHeader."Previous Year Payroll" then begin //Min 7.18.2022
                EmployeeLoanInterest1.Reset;
                EmployeeLoanInterest1.SetRange("Loan Type", LoanType);
                EmployeeLoanInterest1.SetFilter("Starting Date", '<%1', CalcDate1);
                if EmployeeLoanInterest1.FindLast then
                    DiffIntAmt += ((OutstandingAmt / (PGSetup."Prev Fiscal Year End Date" - PGSetup."Prev Fiscal Year Start Date" + 1) *
                                      ((HRSetup."Base Interest Rate" - EmployeeLoanInterest1."Interest Rate") / 100) *
                                          (CalcDate - CalcDate1)))
            end else begin
                EmployeeLoanInterest.Reset;
                EmployeeLoanInterest.SetRange("Loan Type", LoanType);
                EmployeeLoanInterest.SetFilter("Starting Date", '<%1', PayrollHeader."From Date");
                if EmployeeLoanInterest.FindLast then
                    DiffIntAmt += ((OutstandingAmt / (PGSetup."Prev Fiscal Year End Date" - PGSetup."Prev Fiscal Year Start Date" + 1) *
                                      ((HRSetup."Base Interest Rate" - EmployeeLoanInterest."Interest Rate") / 100) *
                                          (PayrollHeader."To Date" - PayrollHeader."From Date" + 1)));
            end;
        end;
        if not PayrollHeader."Previous Year Payroll" then begin //Min 7.18.2022
            EmployeeLoanInterest1.Reset;
            EmployeeLoanInterest1.SetRange("Loan Type", LoanType);
            EmployeeLoanInterest1.SetFilter("Starting Date", '<%1', CalcDate1);
            if EmployeeLoanInterest1.FindLast then
                DiffIntAmt += ((OutstandingAmt / (PGSetup."Payroll Fiscal Year End Date" - PGSetup."Payroll Fiscal Year Start Date" + 1) *
                                  ((HRSetup."Base Interest Rate" - EmployeeLoanInterest1."Interest Rate") / 100) *
                                      (CalcDate - CalcDate1)))
        end else begin
            EmployeeLoanInterest.Reset;
            EmployeeLoanInterest.SetRange("Loan Type", LoanType);
            EmployeeLoanInterest.SetFilter("Starting Date", '<%1', PayrollHeader."From Date");
            if EmployeeLoanInterest.FindLast then
                DiffIntAmt += ((OutstandingAmt / (PGSetup."Payroll Fiscal Year End Date" - PGSetup."Payroll Fiscal Year Start Date" + 1) *
                                  ((HRSetup."Base Interest Rate" - EmployeeLoanInterest."Interest Rate") / 100) *
                                      (PayrollHeader."To Date" - PayrollHeader."From Date" + 1)));
        end;
        exit(DiffIntAmt);
    end;

    local procedure DeductForRecovery(AttribiuteAmt: Decimal)
    var
        EmpActivity: Record "Employee Activity";
        resignationDays: Integer;
    begin
        if "Resignation Date" = 0D then
            exit;
        EmpActivity.Reset();
        EmpActivity.SetRange("Employee No.", "Employee No.");
        EmpActivity.SetRange(Type, EmpActivity.Type::Resignation);
        Employee.Get("Employee No.");
        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Approved);
        if EmpActivity.FindFirst then begin
            if (EmpActivity."Waiver Case" = EmpActivity."Waiver Case"::Recovery) and (not EmpActivity."Apply for Waiver") then begin
                case Employee."Employment Type" of
                    Employee."Employment Type"::Contract:
                        begin
                            HRSetup.TestField("Resignation Period Contract");
                            resignationDays := HRSetup."Resignation Period Contract";
                        end;

                    Employee."Employment Type"::Probation:
                        begin
                            HRSetup.TestField("Resignation Period Probation");
                            resignationDays := HRSetup."Resignation Period Probation";
                        end;

                    Employee."Employment Type"::Permanent:
                        begin
                            HRSetup.TestField("Resignation Period Permanent");
                            resignationDays := HRSetup."Resignation Period Permanent";
                        end;
                end;
                if PayrollAttributes.Type = PayrollAttributes.Type::Benefits then
                    SettlementRecovery += AttribiuteAmt / resignationDays * (resignationDays - ("Resignation Date" - EmpActivity."Requested Date" + 1))
                else
                    SettlementRecovery -= AttribiuteAmt / resignationDays * (resignationDays - ("Resignation Date" - EmpActivity."Requested Date" + 1));
            end;
        end else
            Error('Cannot find resignation of employee %1', "Employee Name");
    end;

    local procedure CheckPremiumInsurance(EmployeeNo: Code[20])
    begin
        /*PayrollGeneralSetup.GET;
        EmpLoanAdvance.RESET;
        EmpLoanAdvance.SETRANGE("Employee Code",EmployeeNo);
        EmpLoanAdvance.SETRANGE("Repayment Mode",EmpLoanAdvance."Repayment Mode"::"Insurance Tieup");
        EmpLoanAdvance.SETRANGE("Approval Status",EmpLoanAdvance."Approval Status"::Approved);
        EmpLoanAdvance.SETRANGE(Settled,FALSE);
        EmpLoanAdvance.CALCSUMS(EMI);
        HLInsAmt := EmpLoanAdvance.EMI * 12;

        EmployeeInsurance.RESET;
        EmployeeInsurance.SETRANGE("Employee No.",EmployeeNo);
        EmployeeInsurance.SETRANGE(Type,EmployeeInsurance.Type::"Life Insurance");
        EmployeeInsurance.SETRANGE(Status,EmployeeInsurance.Status::Screened);
        EmployeeInsurance.CALCSUMS("Annual Premium Amount");

        LifeInsuranceAmt := HLInsAmt + EmployeeInsurance."Annual Premium Amount";

        IF LifeInsuranceAmt > PayrollGeneralSetup."Life Insurance Minimum Amt" THEN
          FinalLifeInsAmount := PayrollGeneralSetup."Life Insurance Minimum Amt"
        ELSE
          FinalLifeInsAmount := LifeInsuranceAmt;

        EmpInsHealth.RESET;
        EmpInsHealth.SETRANGE("Employee No.",EmployeeNo);
        EmpInsHealth.SETRANGE(Type,EmpInsHealth.Type::"Medical Insurance");
        EmpInsHealth.SETRANGE(Status,EmployeeInsurance.Status::Screened);
        IF EmpInsHealth.FINDFIRST THEN REPEAT
          HealthInsAmt += EmpInsHealth."Annual Premium Amount";
          UNTIL EmpInsHealth.NEXT=0;

        IF HealthInsAmt > PayrollGeneralSetup."Health Insurance Minimum Amt" THEN
          FinalHealthInsAmt := PayrollGeneralSetup."Health Insurance Minimum Amt"
        ELSE
          FinalHealthInsAmt := HealthInsAmt;

        EmpInsProperty.RESET;
        EmpInsProperty.SETRANGE("Employee No.",EmployeeNo);
        EmpInsProperty.SETRANGE(Type,EmpInsProperty.Type::"Property Insurance");
        EmpInsProperty.SETRANGE(Status,EmpInsProperty.Status::Screened);
        IF EmpInsProperty.FINDFIRST THEN REPEAT
          PropertyInsAmt += EmpInsProperty."Annual Premium Amount";
          UNTIL EmpInsProperty.NEXT=0;

        IF PropertyInsAmt > PayrollGeneralSetup."Property Insurance Minimum Amt" THEN
          FinalPropertyInsAmt := PayrollGeneralSetup."Property Insurance Minimum Amt"
        ELSE
          FinalPropertyInsAmt := PropertyInsAmt;

        "Tax Exempted Insurance Premium" := FinalLifeInsAmount + FinalHealthInsAmt + FinalPropertyInsAmt;
        */
    end;
}
