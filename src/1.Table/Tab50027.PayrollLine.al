table 50027 "Payroll Line"
{
    //regular payroll attributes 120 (field 61 to 180)
    //other payroll field 40. which can be incremented as per need
    DataClassification = CustomerContent;
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
                GetPayrollHeader;
                Clear(PayrollEngine);
                Employee.Get("Employee No.");
                Employee.TestField("Deputation on");
                Employee.TestField("Salary Level");
                Employee.TestField("Salary Grade");
                Employee.TestField("Employment Date");
                Employee.TestField(Settled, false);
                Employee.TestField("Tax Code");
                Employee.TestField("Do not Calculate Salary", false);
                if not (PayrollHeader.Type in [PayrollHeader.Type::Settlement, PayrollHeader.Type::Adjustment, PayrollHeader.Type::Resignation]) then
                    Employee.TestField(Status, Employee.Status::Active);

                Validate(Type, PayrollHeader.Type);
                if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
                    // if Employee."Resignation Date" <> 0D then
                    //     Error('Employee %1 has resigned.', Employee."Full Name");

                    if PayrollHeader."Employee Type" <> PayrollHeader."Employee Type"::" " then
                        if Employee."Employment Type" <> PayrollHeader."Employee Type" then
                            Error('Employment type of employee %1 must be %2', Employee."Full Name", PayrollHeader."Employee Type".Names());

                    if PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period") then begin
                        if Employee."Employment Date" = PayCyclePeriod."Pay Date" then
                            Error('You Cannot Insert Employee of Employement Date %1', PayCyclePeriod."Pay Date");
                    end;
                end;

                Validate("Employee Type", Employee."Employment Type");
                Validate("Employee Name", Employee.FullName);
                Validate("Deputation On", Employee."Deputation on");
                if "Deputation Value" = '' then
                    Validate("Deputation Value", Employee."Deputation On Code");
                Validate("Sol ID", Employee."Sol Id");
                Validate("CIT No.", Employee."CIT No.");
                Validate("PF No.", Employee."PF No.");
                Validate("Functional Title", Employee."Functional Title");
                Validate("Salary Grade", Employee."Salary Grade");
                Validate("Salary Level", Employee."Salary Level");
                Validate("Pan No.", Employee."PAN No.");
                Validate(Gender, Employee.Gender);
                Validate("Marital Status", Employee."Marital Status");
                Validate("Employee Type", Employee."Employment Type");
                Validate("Province Code", Employee."Province Code");
                Validate("Branch Code", Employee."Branch Code");
                Validate("Department Code", Employee."Department Code");
                Validate("Unit Code", Employee."Unit Code");
                Validate("Extenion Counter Code", Employee."Extension Counter Code");

                HRSetup.Get;
                Validate("Global Dimension 1 Code", Employee."Global Dimension 1 Code");
                Validate("Global Dimension 2 Code", Employee."Global Dimension 2 Code");
                "Bank Account No." := Employee."Bank Account No.";
                "Bank Name" := Employee."Bank Name";

                if PayrollHeader.Type = PayrollHeader.Type::Settlement then
                    ValidateSettlementFields;
                PayrollLine.Reset;
                PayrollLine.SetRange("Document No.", "Document No.");
                PayrollLine.SetCurrentKey(Number);
                if PayrollLine.FindLast then
                    Validate(Number, PayrollLine.Number + 1)
                else
                    Validate(Number, 1);

                //any further calculation goes to onaftervalidate trigger
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
        field(6; "Taxable Income"; Decimal)
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
        field(33; "Employee Name"; Text[100]) { }
        field(34; "Employee Type"; enum "Employee Type") { }
        field(35; "Bank Account No."; Code[20])
        {
            Editable = false;
        }
        field(36; "CIT No."; Code[20])
        {
            Editable = false;
        }
        field(37; "PF No."; Code[20])
        {
            Editable = false;
        }
        field(38; Division; Code[20]) { }
        field(39; "Salary Level"; Code[20])
        {
            TableRelation = "Salary Level";
            Editable = false;
        }
        field(40; "Salary Grade"; Code[20])
        {
            TableRelation = "Salary Grade";
            Editable = false;
        }
        field(41; "Pan No."; Code[20])
        {
            Editable = false;
        }
        field(42; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
            Editable = false;
        }
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
        field(46; "Source Code"; Code[20])
        {
            Description = 'Pranisha';
        }
        field(47; "ATM Custodian Days"; Decimal) { }
        field(48; "Head Teller Days"; Decimal) { }
        field(49; "Teller Days"; Decimal) { }
        field(50; "Night Shifts"; Decimal) { }
        field(51; "Dashain Allowance Days"; Decimal) { }
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
        field(101; "Variable Field 50541"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,101';
        }
        field(102; "Variable Field 50542"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,102';
        }
        field(103; "Variable Field 50543"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,103';
        }
        field(104; "Variable Field 50544"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,104';
        }
        field(105; "Variable Field 50545"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,105';
        }
        field(106; "Variable Field 50546"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,106';
        }
        field(107; "Variable Field 50547"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,107';
        }
        field(108; "Variable Field 50548"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,108';
        }
        field(109; "Variable Field 50549"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,109';
        }
        field(110; "Variable Field 50550"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,110';
        }
        field(111; "Variable Field 50551"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,111';
        }
        field(112; "Variable Field 50552"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,112';
        }
        field(113; "Variable Field 50553"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,113';
        }
        field(114; "Variable Field 50554"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,114';
        }
        field(115; "Variable Field 50555"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,115';
        }
        field(116; "Variable Field 50556"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,116';
        }
        field(117; "Variable Field 50557"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,117';
        }
        field(118; "Variable Field 50558"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,118';
        }
        field(119; "Variable Field 50559"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,119';
        }
        field(120; "Variable Field 50560"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,120';
        }
        field(121; "Variable Field 50561"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,121';
        }
        field(122; "Variable Field 50562"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,122';
        }
        field(123; "Variable Field 50563"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,123';
        }
        field(124; "Variable Field 50564"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,124';
        }
        field(125; "Variable Field 50565"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,125';
        }
        field(126; "Variable Field 50566"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,126';
        }
        field(127; "Variable Field 50567"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,127';
        }
        field(128; "Variable Field 50568"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,128';
        }
        field(129; "Variable Field 50569"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,129';
        }
        field(130; "Variable Field 50570"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,130';
        }
        field(131; "Variable Field 50571"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,131';
        }
        field(132; "Variable Field 50572"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,132';
        }
        field(133; "Variable Field 50573"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,133';
        }
        field(134; "Variable Field 50574"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,134';
        }
        field(135; "Variable Field 50575"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,135';
        }
        field(136; "Variable Field 50576"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,136';
        }
        field(137; "Variable Field 50577"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,137';
        }
        field(138; "Variable Field 50578"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,138';
        }
        field(139; "Variable Field 50579"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,139';
        }
        field(140; "Variable Field 50580"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,140';
        }
        field(141; "Variable Field 50581"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,141';
        }
        field(142; "Variable Field 50582"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,142';
        }
        field(143; "Variable Field 50583"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,143';
        }
        field(144; "Variable Field 50584"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,144';
        }
        field(145; "Variable Field 50585"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,145';
        }
        field(146; "Variable Field 50586"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,146';
        }
        field(147; "Variable Field 50587"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,147';
        }
        field(148; "Variable Field 50588"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,148';
        }
        field(149; "Variable Field 50589"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,149';
        }
        field(150; "Variable Field 50590"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,150';
        }
        field(151; "Variable Field 50591"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,151';
        }
        field(152; "Variable Field 50592"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,152';
        }
        field(153; "Variable Field 50593"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,153';
        }
        field(154; "Variable Field 50594"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,154';
        }
        field(155; "Variable Field 50595"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,155';
        }
        field(156; "Variable Field 50596"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,156';
        }
        field(157; "Variable Field 50597"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,157';
        }
        field(158; "Variable Field 50598"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,158';
        }
        field(159; "Variable Field 50599"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,159';
        }
        field(160; "Variable Field 50600"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,160';
        }
        field(161; "Variable Field 50601"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,161';
        }
        field(162; "Variable Field 50602"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,162';
        }
        field(163; "Variable Field 50603"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,163';
        }
        field(164; "Variable Field 50604"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,164';
        }
        field(165; "Variable Field 50605"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,165';
        }
        field(166; "Variable Field 50606"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,166';
        }
        field(167; "Variable Field 50607"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,167';
        }
        field(168; "Variable Field 50608"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,168';
        }
        field(169; "Variable Field 50609"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,169';
        }
        field(170; "Variable Field 50610"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,170';
        }
        field(171; "Variable Field 50611"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,171';
        }
        field(172; "Variable Field 50612"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,172';
        }
        field(173; "Variable Field 50613"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,173';
        }
        field(174; "Variable Field 50614"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,174';
        }
        field(175; "Variable Field 50615"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,175';
        }
        field(176; "Variable Field 50616"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,176';
        }
        field(177; "Variable Field 50617"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,177';
        }
        field(178; "Variable Field 50618"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,178';
        }
        field(179; "Variable Field 50619"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,179';
        }
        field(180; "Variable Field 50620"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,180';
        }
        field(181; "Variable Field 50621"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,181';
        }
        field(182; "Variable Field 50622"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,182';
        }
        field(183; "Variable Field 50623"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,183';
        }
        field(184; "Variable Field 50624"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,184';
        }
        field(185; "Variable Field 50625"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,185';
        }
        field(186; "Variable Field 50626"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,186';
        }
        field(187; "Variable Field 50627"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,187';
        }
        field(188; "Variable Field 50628"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,188';
        }
        field(189; "Variable Field 50629"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,189';
        }
        field(190; "Variable Field 50630"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,190';
        }
        field(191; "Variable Field 50631"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,191';
        }
        field(192; "Variable Field 50632"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,192';
        }
        field(193; "Variable Field 50633"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,193';
        }
        field(194; "Variable Field 50634"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,194';
        }
        field(195; "Variable Field 50635"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,195';
        }
        field(196; "Variable Field 50636"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,196';
        }
        field(197; "Variable Field 50637"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,197';
        }
        field(198; "Variable Field 50638"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,198';
        }
        field(199; "Variable Field 50639"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,199';
        }
        field(200; "Variable Field 50640"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,200';
        }
        field(201; "Variable Field 50641"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,201';
        }
        field(202; "Variable Field 50642"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,202';
        }
        field(203; "Variable Field 50643"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,203';
        }
        field(204; "Variable Field 50644"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,204';
        }
        field(205; "Variable Field 50645"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,205';
        }
        field(206; "Variable Field 50646"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,206';
        }
        field(207; "Variable Field 50647"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,207';
        }
        field(208; "Variable Field 50648"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,208';
        }
        field(209; "Variable Field 50649"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,209';
        }
        field(210; "Variable Field 50650"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,210';
        }
        field(211; "Variable Field 50651"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,211';
        }
        field(212; "Variable Field 50652"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,212';
        }
        field(213; "Variable Field 50653"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,213';
        }
        field(214; "Variable Field 50654"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,214';
        }
        field(215; "Variable Field 50655"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,215';
        }
        field(216; "Variable Field 50656"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,216';
        }
        field(217; "Variable Field 50657"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,217';
        }
        field(218; "Variable Field 50658"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,218';
        }
        field(219; "Variable Field 50659"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,219';
        }
        field(220; "Variable Field 50660"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = '8,50027,220';
        }
        field(1000; "Bank Name"; Text[50]) { Editable = false; }
        field(1001; "Evening Counter Days"; Decimal) { Description = 'allowance assignment'; }
        field(1002; "Holiday Counter Days"; Decimal) { Description = 'allowance assignment'; }
        field(1003; "Bulk Cash Transfer Days"; Decimal) { }
        field(1004; "Cash Risk Days"; Decimal) { Description = 'allowance assignment'; }
        field(1005; "Friday Counter Days"; Decimal) { Description = 'allowance assignment'; }
        field(1006; "Festival Counter Days"; Decimal) { Description = 'allowance assignment'; }
        field(1007; "Vault Key Days"; Decimal) { Description = 'allowance assignment'; }
        field(1008; "Faciliating Hours"; Decimal) { }
        field(1009; "Gratuity Years"; Decimal) { }
        field(1011; "Resignation Date"; Date) { }
        field(1012; "Annual Leave Days"; Decimal) { }
        field(1013; "Sick Leave Days"; Decimal) { }
        field(1014; "Total Adjusted Leave Days"; Decimal) { }
        field(1015; "Total Insurance Claim Amount"; Decimal) { }
        field(1016; LFA; Decimal) { }
        field(1017; "Morning Counter Days"; Decimal) { Description = 'allowance assignment'; }
        field(1018; "Prior Absent Days"; Decimal) { }
        field(1019; "Prior Present Days"; Decimal) { }
        field(1020; "Salary Advance No."; Code[20]) { }
        field(1021; "Projected Benefit"; Decimal) { Editable = false; }
        field(1022; "Past Benefit"; Decimal) { Editable = false; }
        field(1023; "Assessable Income"; Decimal) { Editable = false; }
        field(1024; "Past Retirement Fund"; Decimal) { Editable = false; }
        field(1025; "Projected Retirement Fund"; Decimal) { Editable = false; }
        field(1026; "Actual RF Contribution"; Decimal) { Editable = false; }
        field(1027; "1/3 of Assessable Income"; Decimal) { Editable = false; }
        field(1028; "Eligible RF Deduction"; Decimal) { Editable = false; }
        field(1029; "Life Insurance Premium"; Decimal) { Editable = false; }
        field(1030; "Health Insurance Premium"; Decimal) { Editable = false; }
        field(1031; "Taxable Income After RF"; Decimal) { Editable = false; }
        field(1032; "Disable Person Reduction"; Decimal) { Editable = false; }
        field(1033; "Female Tax Credit"; Decimal) { Editable = false; }
        field(1034; "Total Tax Liability"; Decimal) { Editable = false; }
        field(1035; "Payable Tax Liability"; Decimal) { Editable = false; }
        field(1036; "Net Tax Liability"; Decimal) { Editable = false; }
        field(1037; "Social Security Tax(Annual)"; Decimal) { Editable = false; }
        field(1038; "Tax on Remuneration(Annual)"; Decimal) { Editable = false; }
        field(1039; "Total Tax Paid"; Decimal) { Editable = false; }
        field(1040; "Carry Forwarded Sick"; Decimal) { Editable = false; }
        field(1041; "Carry Forward Annual"; Decimal) { Editable = false; }
        field(1042; "Prorata Sick"; Decimal) { Editable = false; }
        field(1043; "Prorata Annual"; Decimal) { Editable = false; }
        field(1044; "Used Leave Sick"; Decimal) { Editable = false; }
        field(1045; "Used Leave Annual"; Decimal) { Editable = false; }
        field(1046; "Gratuity & leave Encash Tax"; Decimal) { }
        field(1047; "Projection Month"; Decimal) { }
        field(1048; "Deputation On"; Enum "Deputation Type")
        {
            Editable = false;
            trigger OnValidate()
            begin
                Validate("Deputation Value", ExitTransferDeputationWise("Deputation On"));
            end;
        }
        field(1049; "Deputation Value"; Code[20]) { }
        field(1050; "Sol ID"; Code[20]) { Editable = false; }
        field(1051; "1% Slab"; Decimal) { }
        field(1052; "10% Slab"; Decimal) { }
        field(1053; "20% Slab"; Decimal) { }
        field(1054; "30% Slab"; Decimal) { }
        field(1055; "36% Slab"; Decimal) { }
        field(1056; Type; Enum "Payroll Header Type") { }
        field(1057; "Remote Area Deduction"; Decimal) { }
        field(1058; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
            Editable = false;
        }
        field(1059; "Marital Status"; enum "Marital Status") { Editable = false; }
        field(1060; "Total SST Paid"; Decimal) { }
        field(1061; "Total Tax Remuneration Paid"; Decimal) { }
        field(1062; "LWP Days"; Decimal) { }
        field(1063; "Prior Leave Days"; Decimal) { }
        field(1064; "Property Insurance Premium"; Decimal) { }
        field(1065; Selected; Boolean) { }
        field(1066; "Current Non-Payments"; Decimal) { Editable = false; }
        field(1067; "Projected Non-Payments"; Decimal) { Editable = false; }
        field(1068; "Past Non-Payments"; Decimal) { Editable = false; }
        field(1069; "39% Slab"; Decimal) { }
        field(1070; "Post Resignation Days"; Decimal) { }
        field(1071; "Post Payroll Days"; Decimal)
        {
            Description = 'Post Payroll Days';
            Editable = false;
            trigger OnValidate()
            begin
                GetTotalDays;
            end;
        }
        field(1072; "Absent Days Before Promotion"; Decimal)
        {
            Description = 'A';
        }
        field(1073; "Absent Days After Promotion"; Decimal)
        {
            Description = 'A';
        }
        field(1074; "SST Base Amount"; Decimal)
        {
            Editable = false;
        }
        field(1075; "RIT Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1100; "Province Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = const(Province));
        }
        field(1101; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
        }
        field(1102; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
        }
        field(1103; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = const(Unit));
        }
        field(1104; "Extenion Counter Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = const("Extension Counter"));
        }
    }
    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Net Pay";
        }
        key(Key2; "Salary Level", "Salary Grade") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        TestStatusOpen;

        GetPayrollHeader;

        EmployeeAdj.Reset;
        EmployeeAdj.SetRange("Payroll Document No.", "Document No.");
        EmployeeAdj.SetRange("Employee No.", "Employee No.");
        EmployeeAdj.DeleteAll;

        UnmarkPayrollDocNo("Document No.", "Employee No.");
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
        LockTable;
        CheckDuplicateEmployee;
        PGSetup.Get;
        AttendanceSetup.Get;
        Employee.Get("Employee No.");
        if Type = Type::Resignation then begin
            Employee.TestField("Resignation Date");
            Validate("Resignation Date", Employee."Resignation Date");
        end;
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
        LeaveEarn: Record "Leave Earn";
        UsedDays: Decimal;
        EngNep: Record "English-Nepali Date";
        PromotionHistory: Record "Promotion";
        PayrollLine: Record "Payroll Line";
        EmployeeAdj: Record "Employee Payroll Adjustment";
        SettlementRecovery: Decimal;
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        PrevAttributeAmt: Decimal;
        CurrentAttributeAmt: Decimal;
        CurrentAttributeAmtAbsent: Decimal;
        PromotionFound: Boolean;

    procedure GetTotalDays()
    begin
        "Total Days" := "Present Days" + "Week off Days" + "Leave Days" + "Absent Days" + "Post Payroll Days" + "Post Resignation Days";
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

        if not (PayrollHeader.Irregular or (PayrollHeader.Type = PayrollHeader.Type::Settlement)) then begin
            if PayPeriodDays <> "Total Days" then
                Error(Text000, PayPeriodDays, "Employee No.");
        end;

        if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Hour then
            if ("Paid Hours" + "Unpaid Hours") <> PayPeriodHours then
                Error(Text003, PayPeriodHours, "Employee No.");
    end;

    procedure ValidateEmployee()
    begin
        OnBeforeValidateEmployee("Employee No.");
        GetPayrollHeader;
        Employee.Get("Employee No.");
        Employee.TestField("Employment Date");
        if not (PayrollHeader.Type in [PayrollHeader.Type::Settlement, PayrollHeader.Type::Adjustment]) then
            Employee.TestField(Status, Employee.Status::Active);
        Employee.TestField("Tax Code");
        Employee.TestField("Bank Account No.");
        HRSetup.Get;
        AttendanceSetup.Get;
        if BasicSalarywithGrade.Get(Employee."Salary Grade", Employee."Salary Level") then;
        if not PayrollHeader.Irregular then begin
            TestTotalDays(PayrollHeader);
        end;
        if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Hour then
            TestField("Paid Hours");
        Validate("Global Dimension 1 Code", Employee."Global Dimension 1 Code");
        Validate("Global Dimension 2 Code", Employee."Global Dimension 2 Code");
        "Bank Account No." := Employee."Bank Account No.";
        "Bank Name" := Employee."Bank Name";

        OnValidateEmployeeOnBeforeModifyLine(Rec);  //use it to check all the necessary validation before processing
                                                    // HRSetup.TestField("Base Interest Rate");  again not every company has such setup
                                                    // Employee.TestField("Salary Grade");  //not every company can have salary level and grade used
                                                    // Employee.TestField("Salary Level");
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
    begin
        GetPayrollHeader;
        if not PayrollHeader.Irregular then
            PGSetup.Get;
        PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period");

        AbsentDeductionAmount := 0;
        BasicSalaryAfterDeduction := GetBasicSalaryAfterDeduction;
        if PGSetup."Total Days From" = PGSetup."Total Days From"::Year then
            "Late Rate" := Round("Basic Salary" / PGSetup."Total Days" * 12, 1, '=') //For NIMB
        else
            "Late Rate" := Round("Basic Salary" / "Total Days", 1, '='); // For base

        Clear(SettlementRecovery);
        Clear(PromotionFound);
        Modify;
        ResetValues;

        RFContributionGetAttribute("Employee No.", PayrollHeader);
        GetGlobalAttributes();
        CalculateAbsenteeismBeforeAndAfterPromotion();
        UpdateSalaryAdvanceNo();
        CalculateLateDeduction();
        CalculateOTBenefit();
        GetTotalInsuranceClaim();

        if PayrollHeader.Type = PayrollHeader.Type::Settlement then
            GetSettlementRecovery();

        GetAttributesFromAllowanceConfiguration();
        CalculateAllowanceAssignmentLineAmount();
        OnGetPayrollAttributesOnBeforeSaveValue(Rec);

        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        if PayrollAttributesUsage.FindFirst then
            repeat
                PayrollAttributes.Reset;  //here reset is used instead of get to select only irregular attribute on processing irregular payroll
                                          //because irregular in not defined in payroll attribute uses table
                if not PayrollHeader.Irregular then
                    PayrollAttributes.SetRange(Irregular, false)
                else
                    PayrollAttributes.SetRange(Irregular, true);
                PayrollAttributes.SetRange(Code, PayrollAttributesUsage.Code);
                if PayrollAttributes.FindFirst then begin
                    AttributeAmount := 0;
                    if IsValidComponent then begin
                        if PayrollAttributesUsage.Amount <> 0 then begin
                            if PayrollAttributesUsage."Static Amount" then
                                AttributeAmount := PayrollAttributesUsage.Amount
                            else begin
                                if PayrollAttributesUsage.Formula <> '' then
                                    AttributeAmount := EvaluateAmount(PayrollAttributesUsage.Formula, false)
                                else
                                    if PayrollAttributes.Formula <> '' then
                                        AttributeAmount := EvaluateAmount(PayrollAttributes.Formula, false)
                                    else
                                        AttributeAmount := PayrollAttributesUsage.Amount;
                            end;
                        end else
                            if PayrollAttributesUsage.Formula <> '' then
                                AttributeAmount := EvaluateAmount(PayrollAttributesUsage.Formula, false)
                            else
                                if PayrollAttributes.Formula <> '' then
                                    AttributeAmount := EvaluateAmount(PayrollAttributes.Formula, false)
                                else
                                    AttributeAmount := PayrollEngine.ValidateAttributes(PayrollAttributes.Code, Rec, PayCyclePeriod);
                        if PayrollAttributes."Deduct on Absent" then
                            AttributeAmount := GetAmountAfterAbsenteeism(AttributeAmount);

                        CalculateDifferentialInterestAmount(AttributeAmount);

                        CalculateProRataAmtFromStartDate("Employee No.", PayrollAttributes.Code, AttributeAmount);
                        CalculateProRataAmtFromEndDate("Employee No.", PayrollAttributes.Code, AttributeAmount);

                        AttributeAmount := AttributeAmount + GetBackdatedAmountEmployeeWiseDateWise("Employee No.", PayrollAttributes.Code) + GetAmountFromDeductionEntries("Employee No.", PayrollAttributes.Code, true);
                        if PayrollAttributes.Subtype in [PayrollAttributes.Subtype::CIT, PayrollAttributes.Subtype::RF] then
                            AttributeAmount := AttributeAmount + GetOneTimeRFContributionAmount(PayrollAttributes.Code);
                        RoundAmount(AttributeAmount);
                        if AttributeAmount <> 0 then
                            SaveValues(AttributeAmount, PayrollAttributes.Code);
                    end;
                end;
            until PayrollAttributesUsage.Next = 0;
    end;

    procedure GetOneTimeRFContributionAmount(PayrollAttributesCode: Code[20]): Decimal
    var
        RetirementFundHeader: Record "Retirement Fund";
    begin
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
            RetirementFundHeader.Reset();
            RetirementFundHeader.SetRange("Employee No.", "Employee No.");
            RetirementFundHeader.SetRange("Attribute Code", PayrollAttributesCode);
            RetirementFundHeader.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
            RetirementFundHeader.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
            RetirementFundHeader.SetRange("Payroll Month", PayrollHeader."Nepali Month");
            RetirementFundHeader.SetRange("Approval Status", RetirementFundHeader."Approval Status"::Approved);
            if RetirementFundHeader.FindLast() then
                exit(RetirementFundHeader."One Time Contribution");
        end;
    end;

    local procedure IsValidComponent(): Boolean
    begin
        if PayrollAttributes.Status = PayrollAttributes.Status::Active then begin
            if PayrollAttributesUsage."Pay Cycle Period" <> 0 then begin
                if (PayrollAttributesUsage."Pay Cycle Code" = PayrollHeader."Pay Cycle Code") and
                    (PayrollAttributesUsage."Pay Cycle Term" = PayrollHeader."Pay Cycle Term") and
                      (PayrollAttributesUsage."Pay Cycle Period" = PayrollHeader."Pay Cycle Period") then begin
                    exit(true);
                end;
            end
            else begin
                if PayrollAttributes."Pay Cycle Period" <> 0 then begin
                    if (PayrollAttributes."Pay Cycle Code" = PayrollHeader."Pay Cycle Code") and
                        (PayrollAttributes."Pay Cycle Term" = PayrollHeader."Pay Cycle Term") and
                          (PayrollAttributes."Pay Cycle Period" = PayrollHeader."Pay Cycle Period") then begin
                        exit(true);
                    end;
                end
                else
                    exit(true);
            end;
        end;
    end;

    local procedure RFContributionGetAttribute(EmployeeNo: Code[20]; PayrollHeader: Record "Payroll Header")
    var
        PayrollAttrUses: Record "Payroll Attributes Usage";
        RetirementFundHeader: Record "Retirement Fund";
        RFContributionLine: Record "RF Contribution";
    begin
        PayrollAttrUses.SetRange("Employee Code", EmployeeNo);
        PayrollAttrUses.SetFilter(Subtype, '%1|%2', PayrollAttrUses.Subtype::RF, PayrollAttrUses.Subtype::CIT);
        PayrollAttrUses.SetRange(Type, PayrollAttrUses.Type::Deduction);
        if PayrollAttrUses.FindSet() then
            repeat
                RetirementFundHeader.Reset();
                RetirementFundHeader.SetRange("Employee No.", PayrollAttrUses."Employee Code");
                RetirementFundHeader.SetRange("Attribute Code", PayrollAttrUses.Code);
                RetirementFundHeader.SetRange("Approval Status", RetirementFundHeader."Approval Status"::Approved);
                if not RetirementFundHeader.FindLast() then
                    exit;
                RFContributionLine.Reset();
                if RetirementFundHeader.Type = RetirementFundHeader.Type::Manual then begin
                    //  RFContributionLine.SetRange("Nepali Month ", PayrollHeader."Nepali Month");
                    RFContributionLine.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
                    RFContributionLine.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
                    RFContributionLine.SetRange("Pay Cycle Period", PayrollHeader."Pay Cycle Period");
                end;
                RFContributionLine.SetRange("Employee No.", PayrollAttrUses."Employee Code");
                RFContributionLine.SetRange(Type, PayrollAttrUses."RF Contribution Type");
                RFContributionLine.SetRange("Document No.", RetirementFundHeader."No.");
                RFContributionLine.SetRange("Approval Status", RFContributionLine."Approval Status"::Approved);
                if RFContributionLine.FindLast() then begin
                    if RFContributionLine.Type = RFContributionLine.Type::Percent then
                        PayrollAttrUses.Validate(Amount, (GetAmountRFContribution(RetirementFundHeader."Employee No.") * RFContributionLine.Amount) / 100)
                    else
                        PayrollAttrUses.Validate(Amount, RFContributionLine.Amount);
                    PayrollAttrUses.Modify();
                end
            until PayrollAttributes.Next() = 0;
    end;

    procedure GetAmountRFContribution(EmployeeCode: Code[20]): Decimal
    var
        LevelWiseAttributes: Record "Level Wise Attributes";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BaseAmount: Decimal;
    begin
        Employee.SetLoadFields("Salary Grade", "Salary Level");
        Employee.Get(EmployeeCode);

        LevelWiseAttributes.SetLoadFields("Total Basic Salary");
        if LevelWiseAttributes.Get(Employee."Salary Grade", Employee."Salary Level") then
            if LevelWiseAttributes."Total Basic Salary" <> 0 then
                exit(LevelWiseAttributes."Total Basic Salary");

        PayrollAttributesUsage.SetRange("Employee Code", EmployeeCode);
        PayrollAttributesUsage.SetRange(Subtype, PayrollAttributesUsage.Subtype::Basic, PayrollAttributesUsage.Subtype::Grade);
        PayrollAttributesUsage.CalcSums(Amount);
        BaseAmount := PayrollAttributesUsage.Amount;
        // Add event conditionally if needed
        OnBeforeExitOfBaseAmountForCIT(EmployeeCode, BaseAmount);
        exit(BaseAmount);
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
            // PayrollAttributesUsage.TestField(Amount);
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
                        //IF PayrollAttributesUsage.Amount <> 0 THEN
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

    local procedure GetBasicSalaryAfterDeduction(): Decimal
    begin
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Basic);
        PayrollAttributes.FindFirst;

        "Basic Salary" := BasicSalarywithGrade."Total Basic Salary";
        if PayrollAttributesUsage.Get(PayrollAttributes.Code, "Employee No.") then begin
            //PayrollAttributesUsage.TestField(Amount);
            if PayrollAttributesUsage.Amount <> 0 then
                "Basic Salary" := PayrollAttributesUsage.Amount;
        end;

        exit(GetAmountAfterAbsenteeism(PayrollAttributesUsage.Amount));
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

    local procedure GetAmountAfterAbsenteeism(CalculatedAmount: Decimal): Decimal
    var
        TotalDaysInMonth: Decimal;
        TotalAmount: Decimal;
        IsHandled: Boolean;
        RFContribution: Enum "RF Contribution Type";
    begin
        if CalculatedAmount < 0 then
            exit(CalculatedAmount);

        if PayrollAttributes.Subtype in [PayrollAttributes.Subtype::CIT, PayrollAttributes.Subtype::RF] then
            if PayrollAttributesUsage."RF Contribution Type" in [RFContribution::Fixed, RFContribution::Manual, RFContribution::Optimum] then
                exit(CalculatedAmount);

        if PGSetup."Total Days From" = PGSetup."Total Days From"::Year then
            TotalDaysInMonth := PGSetup."Total Days" / 12
        else
            TotalDaysInMonth := "Total Days";
        if PayrollHeader.Type in [PayrollHeader.Type::Payroll, PayrollHeader.Type::Resignation] then begin
            if not PayrollHeader.Irregular then begin
                // if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Day then
                //     exit((CalculatedAmount / TotalDaysInMonth) * ("Present Days" + "Week off Days" + "Leave Days") +
                //         (CalculatedAmount / PayrollEngine.GetPreviousPayCycleCodeDays(PayrollHeader) * ("Prior Present Days" - "Prior Absent Days"))) //deduct on prior absent.
                if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Day then begin
                    OnBeforeCalculateTotalAmount("Total Days", "LWP Days", TotalAmount, IsHandled);
                    if IsHandled then
                        exit(TotalAmount);
                    TotalAmount := (CalculatedAmount) + (CalculatedAmount / PayrollEngine.GetPreviousPayCycleCodeDays(PayrollHeader) * ("Prior Present Days" - "Prior Absent Days")) - ((CalculatedAmount * ("LWP Days" + "Late Days")) / TotalDaysInMonth);
                    if TotalAmount > 0 then
                        exit(TotalAmount)
                    else
                        exit(0);
                end else
                    exit((CalculatedAmount / (TotalDaysInMonth * AttendanceSetup."Working Hour per day")) * ("Paid Hours"))
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
                    exit((CalculatedAmount / TotalDaysInMonth) * ("Total Days" - "Absent Days"))
                else
                    exit((CalculatedAmount / TotalDaysInMonth) * ("Total Days" - "Absent Days") +
                        (CalculatedAmount / ("Prior Absent Days" + "Prior Leave Days" + "Prior Present Days") *
                        (("Prior Absent Days" + "Prior Leave Days" + "Prior Present Days") - "Prior Absent Days"))) //deduct on prior absent.
            end else
                exit((CalculatedAmount / (TotalDaysInMonth * AttendanceSetup."Working Hour per day")) * ("Paid Hours"))
        end;
    end;

    local procedure GetAmountAfterAbsentismCurrent(CalculatedAmountCurrent: Decimal; CalculatedAmountPrevious: Decimal): Decimal
    var
        TotalAmount: Decimal;
    begin
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
            if not PayrollHeader.Irregular then begin
                if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Day then begin
                    TotalAmount := ((CalculatedAmountCurrent / "Total Days") * ("Absent Days After Promotion")) + ((CalculatedAmountPrevious / "Total Days") * ("Absent Days After Promotion"));
                    exit(TotalAmount) //deduct on prior absent.
                end else
                    exit((CalculatedAmountCurrent / ("Total Days" * AttendanceSetup."Working Hour per day")) * ("Paid Hours"))
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
                    exit(-(CalculatedAmountCurrent / PayrollHeader."Total Days" * "Absent Days"));

                if "Prior Absent Days" + "Prior Leave Days" + "Prior Present Days" = 0 then
                    exit((CalculatedAmountCurrent / PayrollHeader."Total Days") * ("Total Days" - "Absent Days"))
                else
                    exit((CalculatedAmountCurrent / PayrollHeader."Total Days") * ("Total Days" - "Absent Days") +
                        (CalculatedAmountCurrent / ("Prior Absent Days" + "Prior Leave Days" + "Prior Present Days") *
                        (("Prior Absent Days" + "Prior Leave Days" + "Prior Present Days") - "Prior Absent Days"))) //deduct on prior absent.
            end else
                exit((CalculatedAmountCurrent / (PayrollHeader."Total Days" * AttendanceSetup."Working Hour per day")) * ("Paid Hours"))
        end;
    end;

    local procedure GetAmountAfterAbsentismPromotionPrevious(CalculatedAmount: Decimal): Decimal
    begin
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
            if not PayrollHeader.Irregular then begin
                if AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Day then
                    exit((CalculatedAmount / PayrollEngine.GetPreviousPayCycleCodeDays(PayrollHeader) * ("Prior Present Days" - "Prior Absent Days"))) //deduct on prior absent.
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
        for FieldID := 61 to 220 do begin
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
                    FieldRefs := RecRefs.Field(1);
                    FieldRefs.SetRange(Employee."Salary Grade");
                    FieldRefs := RecRefs.Field(2);
                    FieldRefs.SetRange(Employee."Salary Level");
                    RecRefs.FindFirst;
                    FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
                    Evaluate(AttributeAmount, Format(FieldRefs.Value));
                    CurrentAttributeAmt := AttributeAmount;
                    if PromotionHistory."Promotion Date" <> 0D then begin
                        AttributeAmount := AttributeAmount / "Total Days" * (PayCyclePeriod."End Date" - PromotionHistory."Promotion Date" + 1);
                        RecRefs.Reset;
                        FieldRefs := RecRefs.Field(1);
                        FieldRefs.SetRange(PromotionHistory."Previous Salary Grade");
                        FieldRefs := RecRefs.Field(2);
                        FieldRefs.SetRange(PromotionHistory."Previous Salary Level");
                        RecRefs.FindFirst;
                        FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
                        Evaluate(PriorPromotionAmt, Format(FieldRefs.Value));
                        PrevAttributeAmt := GetAmountAfterAbsentismPromotionPrevious(PriorPromotionAmt);
                        CurrentAttributeAmtAbsent := GetAmountAfterAbsentismCurrent(CurrentAttributeAmt, PriorPromotionAmt);
                        PriorPromotionAmt := PriorPromotionAmt / "Total Days" * (PromotionHistory."Promotion Date" - PayCyclePeriod."Start Date");
                        AttributeAmount := AttributeAmount + PriorPromotionAmt + PrevAttributeAmt - CurrentAttributeAmtAbsent;
                    end;
                    RoundAmount(AttributeAmount);
                    if PayrollAttributesUsage.Get(PayrollAttributes.Code, "Employee No.") then begin // update to payroll line only if payrollattruses found
                        if PayrollHeader.Type = PayrollHeader.Type::Settlement then
                            DeductForRecovery(AttributeAmount);
                        if (not PayrollHeader.Irregular) then
                            SaveValues(AttributeAmount, PayrollAttributes.Code);
                        PayrollAttributesUsageModify(PayrollAttributes.Code, AttributeAmount);
                    end;
                end;
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
            if not PayrollAttUsage."Static Amount" then
                PayrollAttUsage.Amount := Amt;
            PayrollAttUsage.Modify;
        end;
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

    local procedure CheckSettlement()
    var
        PostedPayrollHeader: Record "Posted Payroll Header";
        PostedPayrollline: Record "Posted Payroll Line";
        Resignation: Record Resignation;
    begin
        Resignation.SetRange("Employee No.", "Employee No.");
        Resignation.SetRange("Approval Status", Resignation."Approval Status"::Approved);
        if not Resignation.FindFirst then
            Error('Resignation not approved yet.');

        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Settlement);
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
        MedicalInsurranceClaim: Record "Medical Insurance Claim";
        Resignation: Record Resignation;
    begin
        Employee.Get("Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Permanent then begin

            Validate("Gratuity Years", Round((Employee."Resignation Date" - Employee."Employment Date") / 365, 0.001, '='));
        end;

        Resignation.SetRange("Employee No.", Employee."No.");
        Resignation.SetRange("Approval Status", Resignation."Approval Status"::Approved);
        if Resignation.FindFirst then begin
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
                LeaveEarn.SetRange("Employee No.", "Employee No.");
                LeaveEarn.SetRange("Leave Code", LeaveTypeSetup.Code);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Used);
                LeaveEarn.SetRange("Fiscal year", EngNep."Fiscal Year");
                LeaveEarn.CalcSums("Balancing Days");
                UsedDays := LeaveEarn."Balancing Days";

                if UsedDays > 0 then
                    Validate(LFA, UsedDays - PayrollEngine.CalculateProRataLeaveSettlement(LeaveTypeSetup.Code, Employee."Employment Date", "Resignation Date"));
            end;
        end;

        MedicalInsurranceClaim.SetRange("Employee No.", Employee."No.");
        MedicalInsurranceClaim.SetRange("Approval Status", MedicalInsurranceClaim."Approval Status"::Approved);
        MedicalInsurranceClaim.CalcSums("Total Insurance Claim Amount");
        "Total Insurance Claim Amount" := MedicalInsurranceClaim."Total Insurance Claim Amount";
    end;

    local procedure ExitTransferDeputationWise(DeputationOn: Enum "Deputation Type"): Text
    var
        OrganizationStructureList: Record "Organization Structure List";
    // DimValue: Record "Dimension Value";
    // Depart: Record Department;
    // EmpHie: Record "Employee Hierarchy Master";
    // SubProvince: Record "Sub Province";
    // Province: Record Province;
    // GLSetup: Record "General Ledger Setup";
    begin
        // Clear(DimValue);
        // GLSetup.Get;
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Employee."Global Dimension 1 Code") then
                        exit(OrganizationStructureList.Code);
                end;

            DeputationOn::Department:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, Employee."Department Code") then
                        exit(OrganizationStructureList.Code);
                end;

            DeputationOn::"Extension Counter":
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Employee."Extension Counter Code") then
                        exit(OrganizationStructureList.Code);
                end;

            // DeputationOn::"Sub Province":
            //     begin
            //         SubProvince.Reset;
            //         SubProvince.SetRange(Code, Employee."Sub Province Code");
            //         if SubProvince.FindFirst then
            //             exit(SubProvince.Code);
            //     end;

            DeputationOn::Unit:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, Employee."Unit Code") then
                        exit(OrganizationStructureList.Code);
                end;

            DeputationOn::Province:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, Employee."province Code") then
                        exit(OrganizationStructureList.Code);
                end;
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

                CalcDate1 := EmployeeLoanInterest."Starting Date";
                if PayrollHeader."Previous Year Payroll" then
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
            if PayrollHeader."Previous Year Payroll" then begin
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
        if not PayrollHeader."Previous Year Payroll" then begin
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
        Resignation: Record Resignation;
        resignationDays: Integer;
    begin
        if "Resignation Date" = 0D then
            exit;

        Employee.Get("Employee No.");
        Resignation.SetRange("Employee No.", "Employee No.");
        Resignation.SetRange("Approval Status", Resignation."Approval Status"::Approved);
        if Resignation.FindFirst then begin
            if (Resignation."Waiver Case" = Resignation."Waiver Case"::Recovery) and (not Resignation."Apply for Waiver") then begin
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
                    SettlementRecovery += AttribiuteAmt / resignationDays * (resignationDays - ("Resignation Date" - Resignation."Requested Date" + 1))
                else
                    SettlementRecovery -= AttribiuteAmt / resignationDays * (resignationDays - ("Resignation Date" - Resignation."Requested Date" + 1));
            end;
        end else
            Error('Cannot find resignation of employee %1', "Employee Name");
    end;

    local procedure CheckPremiumInsurance()
    begin
        /*PayrollGeneralSetup.GET;
        EmpLoanAdvance.Reset();
        EmpLoanAdvance.SetRange("Employee Code",EmployeeNo);
        EmpLoanAdvance.SetRange("Repayment Mode",EmpLoanAdvance."Repayment Mode"::"Insurance Tieup");
        EmpLoanAdvance.SetRange("Approval Status",EmpLoanAdvance."Approval Status"::Approved);
        EmpLoanAdvance.SetRange(Settled,FALSE);
        EmpLoanAdvance.CALCSUMS(EMI);
        HLInsAmt := EmpLoanAdvance.EMI * 12;

        EmployeeInsurance.Reset();
        EmployeeInsurance.SetRange("Employee No.",EmployeeNo);
        EmployeeInsurance.SetRange(Type,EmployeeInsurance.Type::"Life Insurance");
        EmployeeInsurance.SetRange(Status,EmployeeInsurance.Status::Screened);
        EmployeeInsurance.CALCSUMS("Annual Premium Amount");

        LifeInsuranceAmt := HLInsAmt + EmployeeInsurance."Annual Premium Amount";

        IF LifeInsuranceAmt > PayrollGeneralSetup."Life Insurance Minimum Amt" THEN
          FinalLifeInsAmount := PayrollGeneralSetup."Life Insurance Minimum Amt"
        ELSE
          FinalLifeInsAmount := LifeInsuranceAmt;

        EmpInsHealth.Reset();
        EmpInsHealth.SetRange("Employee No.",EmployeeNo);
        EmpInsHealth.SetRange(Type,EmpInsHealth.Type::"Medical Insurance");
        EmpInsHealth.SetRange(Status,EmployeeInsurance.Status::Screened);
        IF EmpInsHealth.FindFirst() THEN repeat
          HealthInsAmt += EmpInsHealth."Annual Premium Amount";
          until EmpInsHealth.NEXT=0;

        IF HealthInsAmt > PayrollGeneralSetup."Health Insurance Minimum Amt" THEN
          FinalHealthInsAmt := PayrollGeneralSetup."Health Insurance Minimum Amt"
        ELSE
          FinalHealthInsAmt := HealthInsAmt;

        EmpInsProperty.Reset();
        EmpInsProperty.SetRange("Employee No.",EmployeeNo);
        EmpInsProperty.SetRange(Type,EmpInsProperty.Type::"Property Insurance");
        EmpInsProperty.SetRange(Status,EmpInsProperty.Status::Screened);
        IF EmpInsProperty.FindFirst() THEN repeat
          PropertyInsAmt += EmpInsProperty."Annual Premium Amount";
          until EmpInsProperty.NEXT=0;

        IF PropertyInsAmt > PayrollGeneralSetup."Property Insurance Minimum Amt" THEN
          FinalPropertyInsAmt := PayrollGeneralSetup."Property Insurance Minimum Amt"
        ELSE
          FinalPropertyInsAmt := PropertyInsAmt;

        "Tax Exempted Insurance Premium" := FinalLifeInsAmount + FinalHealthInsAmt + FinalPropertyInsAmt;
        */
    end;

    procedure CalculateAbsenteeismBeforeAndAfterPromotion()
    var
        EmployeeAttendActivity: Record "Employee Attendance & Activity";
    begin
        Clear(PromotionHistory);
        PromotionHistory.Reset;
        PromotionHistory.SetRange("Employee No.", "Employee No.");
        PromotionHistory.SetRange("Promotion Date", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
        if PromotionHistory.FindFirst then begin
            PromotionFound := true;
            //Absent Days for LWP before and after promotion
            EmployeeAttendActivity.Reset;
            EmployeeAttendActivity.SetRange("Employee No.", Rec."Employee No.");
            EmployeeAttendActivity.SetRange("Pay Type", EmployeeAttendActivity."Pay Type"::Unpaid);
            EmployeeAttendActivity.SetRange("Present Day", 0);
            EmployeeAttendActivity.SetRange("Attendance Date", PayrollHeader."From Date", PromotionHistory."Promotion Date" - 1);
            EmployeeAttendActivity.CalcSums("Absent Day");
            rec."Absent Days Before Promotion" := EmployeeAttendActivity."Absent Day";

            // EmployeeAttendActivity.Reset;
            // EmployeeAttendActivity.SetRange("Employee No.", Rec."Employee No.");
            // EmployeeAttendActivity.SetRange("Pay Type", EmployeeAttendActivity."Pay Type"::Unpaid);
            // EmployeeAttendActivity.SetRange("Present Day", 0);
            //if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
            //if PayrollHeader."Employee Type" = PayrollHeader."Employee Type"::Permanent then
            EmployeeAttendActivity.SetRange("Attendance Date");
            EmployeeAttendActivity.SetRange("Attendance Date", PromotionHistory."Promotion Date", PayCyclePeriod."Pay Date" - 1);
            EmployeeAttendActivity.CalcSums("Absent Day");
            Rec."Absent Days After Promotion" := EmployeeAttendActivity."Absent Day";
            // EmployeeAttendActivity.SetRange("Attendance Date");
            // // EmployeeAttendActivity.SetRange("Attendance Date", PromotionHistory."Promoted Date",);
            // EmployeeAttendActivity.SetRange("Attendance Date", PromotionHistory."Promoted Date", PayCyclePeriod."Pay Date" - 1);
            // EmployeeAttendActivity.CalcSums("Absent Day");
            // Rec."Absent Days After Promotion" := EmployeeAttendActivity."Absent Day";
            Rec.Modify();
            GetGlobalAttributes; //temporary
        end;
    end;

    procedure UpdateSalaryAdvanceNo()
    var
        EmpSalAdv: Record "Employee Loan/Advance";
    begin
        EmpSalAdv.Reset;
        EmpSalAdv.SetRange("Employee No.", "Employee No.");
        EmpSalAdv.SetRange("Approval Status", EmpSalAdv."Approval Status"::Approved);
        EmpSalAdv.SetRange(Settled, false);
        EmpSalAdv.SetRange("Loan Type", EmpSalAdv."Loan Type"::"Salary Advance");
        if EmpSalAdv.FindFirst then
            Validate("Salary Advance No.", EmpSalAdv."No.");
    end;

    procedure CalculateLatededuction()
    var
        PayrollAttr: Record "Payroll Attributes";
        PayrollAttrUses: Record "Payroll Attributes Usage";
    begin
        PayrollAttr.SetRange("Specific Attributes", PayrollAttr."Specific Attributes"::"Late Deduction");
        PayrollAttr.SetRange(Status, PayrollAttr.Status::Active);
        if PayrollAttr.FindFirst() then begin
            if PayrollAttrUses.Get(PayrollAttr.Code, "Employee No.") then begin
                PayrollAttrUses.Amount := "Late Rate" * "Late Days";
                PayrollAttrUses.Modify();
            end;
        end;
    end;

    procedure CalculateOTBenefit()
    var
        AttributeAmount: Decimal;
        PayrollAttr: Record "Payroll Attributes";
        PayrollAttrUses: Record "Payroll Attributes Usage";
    begin
        PayrollAttr.SetRange("Specific Attributes", PayrollAttr."Specific Attributes"::"OverTime Salary");
        PayrollAttr.SetRange(Status, PayrollAttr.Status::Active);
        if PayrollAttr.FindFirst() then begin
            if PayrollAttrUses.Get(PayrollAttr.Code, "Employee No.") then begin
                AttributeAmount := ("Basic Salary" / "Total Days" / AttendanceSetup."Working Hour per day" * "OT Hrs");
                RoundAmount(AttributeAmount);
                PayrollAttrUses.Amount := AttributeAmount;
                PayrollAttrUses.Modify();
            end;
        end;
    end;

    procedure CalculateAllowanceAssignmentLineAmount()
    var
        PayrollAttrUses: Record "Payroll Attributes Usage";
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
    begin
        AllowanceAssignmentLine.Reset();
        AllowanceAssignmentLine.SetRange("Employee Code", "Employee No.");
        AllowanceAssignmentLine.SetRange("Payroll Doc No.", '');
        AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
        AllowanceAssignmentLine.SetRange("From Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        AllowanceAssignmentLine.SetRange("Payroll Posted", false);
        AllowanceAssignmentLine.SetRange("Emp Act Type", AllowanceAssignmentLine."Emp Act Type"::"Allowance Assignment Claim");
        AllowanceAssignmentLine.SetFilter("Substitute Type", '%1|%2', AllowanceAssignmentLine."Substitute Type"::" ", AllowanceAssignmentLine."Substitute Type"::"Added as Substitute");
        OnAfterFilterAllowanceAssignmentLine(AllowanceAssignmentLine);
        if AllowanceAssignmentLine.FindSet() then
            repeat
                if PayrollAttrUses.Get(AllowanceAssignmentLine."Allowance Type", "Employee No.") then begin
                    PayrollAttrUses.Amount += AllowanceAssignmentLine."Allowance Amount";
                    PayrollAttrUses.Modify();
                end else begin
                    Clear(PayrollAttrUses);
                    PayrollAttrUses.Init();
                    PayrollAttrUses.Validate(Code, AllowanceAssignmentLine."Allowance Type");
                    PayrollAttrUses.Validate("Employee Code", "Employee No.");
                    PayrollAttrUses.Validate(Amount, AllowanceAssignmentLine."Allowance Amount");
                    if PayrollAttrUses.Insert() then;
                end;
                AllowanceAssignmentLine."Payroll Doc No." := "Document No.";
                AllowanceAssignmentLine.Modify();
            until AllowanceAssignmentLine.Next() = 0
    end;

    procedure GetTotalInsuranceClaim()
    var
        AttributeAmount: Decimal;
        PayrollAttr: Record "Payroll Attributes";
        PayrollAttrUses: Record "Payroll Attributes Usage";
    begin
        if "Total Insurance Claim Amount" > 0 then begin
            PayrollAttr.SetRange("Specific Attributes", PayrollAttr."Specific Attributes"::"Insurance Recover");
            PayrollAttr.SetRange(Status, PayrollAttr.Status::Active);
            if PayrollAttr.FindFirst() then begin
                if PayrollAttrUses.Get(PayrollAttr.Code, "Employee No.") then begin
                    HRSetup.Get;
                    AttributeAmount := ((HRSetup."Policy End Date" - "Resignation Date") / 365) * HRSetup."Medical Insurance Premium";
                    RoundAmount(AttributeAmount);
                    PayrollAttrUses.Modify();
                end
            end;
        end;
    end;

    procedure GetSettlementRecovery()
    var
        PayrollAttr: Record "Payroll Attributes";
        PayrollAttrUses: Record "Payroll Attributes Usage";
    begin
        PayrollAttr.SetRange("Specific Attributes", PayrollAttr."Specific Attributes"::"Insurance Recover");
        PayrollAttr.SetRange(Status, PayrollAttr.Status::Active);
        if PayrollAttr.FindFirst() then begin
            if PayrollAttrUses.Get("Employee No.", PayrollAttr.Code) then begin
                RoundAmount(SettlementRecovery);
                PayrollAttrUses.Amount := SettlementRecovery;
                PayrollAttrUses.Modify();
            end;
        end;
    end;

    local procedure CalculateDifferentialInterestAmount(var AttributeAmount: Decimal)
    var
        LoanOutstandingfromFinacle: Record "Loan Outstanding from Finacle";
    begin
        if PayrollAttributes."Differential Interest" then begin //calculate differential interest
            LoanOutstandingfromFinacle.Reset;
            LoanOutstandingfromFinacle.SetRange("Employee No.", Employee."No.");
            LoanOutstandingfromFinacle.SetFilter("Outstanding Amount", '<>0');
            LoanOutstandingfromFinacle.SetFilter("Loan Type", '<>%1|<>%2', LoanOutstandingfromFinacle."Loan Type"::" ", LoanOutstandingfromFinacle."Loan Type"::"Salary Advance");
            LoanOutstandingfromFinacle.SetRange("Is Manual", false);
            if LoanOutstandingfromFinacle.FindSet then
                repeat
                    case LoanOutstandingfromFinacle."Loan Type" of
                        LoanOutstandingfromFinacle."Loan Type"::"Home Loan", LoanOutstandingfromFinacle."Loan Type"::"Home Loan Insurance Tieup":
                            AttributeAmount += CalculateDifferentialnterest(LoanOutstandingfromFinacle."Loan Type"::"Home Loan", LoanOutstandingfromFinacle."Outstanding Amount");
                        else
                            AttributeAmount += CalculateDifferentialnterest(LoanOutstandingfromFinacle."Loan Type", LoanOutstandingfromFinacle."Outstanding Amount");
                    end;
                until LoanOutstandingfromFinacle.Next = 0;
        end;
    end;

    procedure GetAttributesFromAllowanceConfiguration()
    var
        AllowanceConfiguration: Record "Allowance Configuration";
        PayrollAttrUses: Record "Payroll Attributes Usage";
        PayrollAttrUses2: Record "Payroll Attributes Usage";
        AllowanceAmt: Decimal;
        IsHandled: Boolean;
    begin
        PGSetup.Get();
        GetPayrollHeader();
        if not PGSetup."Use Allowance Configuration" then
            exit;

        AllowanceConfiguration.Reset();
        if AllowanceConfiguration.FindSet() then
            repeat
                OnBeforeGettingAllowanceAmtFromAllowanceConfiguration(AllowanceConfiguration, Rec, IsHandled);
                if not IsHandled then begin
                    AllowanceAmt := 0;
                    AllowanceAmt := GetAllowanceConfigurationAmountforEmployee(AllowanceConfiguration,
                                                                                "Document No.",
                                                                                "Employee No.");

                    if PayrollAttrUses.Get(AllowanceConfiguration."Payroll Attribute", "Employee No.") then begin
                        if not MultipleConfigForSameAttribute(AllowanceConfiguration) then
                            PayrollAttrUses.Amount := AllowanceAmt
                        else
                            if AllowanceAmt <> 0 then
                                PayrollAttrUses.Amount := AllowanceAmt;
                        if not PayrollAttrUses."Static Amount" then
                            PayrollAttrUses.Modify();
                    end
                    else begin
                        if AllowanceAmt <> 0 then begin
                            Clear(PayrollAttrUses2);
                            PayrollAttrUses2.Init();
                            PayrollAttrUses2.Validate(Code, AllowanceConfiguration."Payroll Attribute");
                            PayrollAttrUses2.Validate("Employee Code", "Employee No.");
                            PayrollAttrUses2.Validate(Amount, AllowanceAmt);
                            if PayrollAttrUses2.Insert() then;
                        end;
                    end;
                end;
            until AllowanceConfiguration.Next() = 0;
    end;

    procedure GetAllowanceAmountFromAssignmentMemoLedger(PayrollDocNo: Code[20];
                                        EmployeeCode: Code[20];
                                         PayrollAttr: Code[20];
                                         LeaveCode: Code[20];
                                         FromDate: Date;
                                         ToDate: Date
                                       ): Decimal
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        Amt: Decimal;
        PayrollGeneralSetup: Record "Payroll General Setup";
    begin
        PayrollGeneralSetup.Get();
        if not PayrollGeneralSetup."Get Amount From Assignment" then
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Request Allowance")
        else
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Allowance Assignment Memo");
        AssignmentMemoLedgerEntry.SetRange(Reversed, false);
        AssignmentMemoLedgerEntry.SetRange("Employee No.", EmployeeCode);
        AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", PayrollAttr);
        AssignmentMemoLedgerEntry.SetRange("Posting Date", FromDate, ToDate);
        AssignmentMemoLedgerEntry.SetFilter("Payroll Document No.", '%1|%2', '', PayrollDocNo);
        AssignmentMemoLedgerEntry.SetRange("Blocked for Payroll", false);
        AssignmentMemoLedgerEntry.SetRange("Open", true);
        AssignmentMemoLedgerEntry.CalcSums(Amount);
        Amt := AssignmentMemoLedgerEntry."Amount";
        if AssignmentMemoLedgerEntry.FindSet() then
            AssignmentMemoLedgerEntry.ModifyAll("Payroll Document No.", PayrollDocNo);
        RoundAmount(Amt);
        exit(Amt);
    end;

    procedure GetAllowanceConfigurationAmountforEmployee(AllowanceConfiguration: Record "Allowance Configuration"; PayrollDocNo: code[20]; EmployeeCode: Code[20]): Decimal
    begin
        case AllowanceConfiguration.Source of
            AllowanceConfiguration.Source::Direct, AllowanceConfiguration.Source::Assignment, AllowanceConfiguration.Source::Shift, AllowanceConfiguration.Source::Leave:
                exit(GetAllowanceAmountFromAssignmentMemoLedger(PayrollDocNo,
                                            EmployeeCode,
                                            AllowanceConfiguration."Payroll Attribute",
                                            AllowanceConfiguration."Leave Code",
                                            PGSetup."Payroll Fiscal Year Start Date",  //added to claim remaining backdated allowance
                                            PayrollHeader."To Date"));

            AllowanceConfiguration.Source::" ":
                if AllowanceConfiguration.IsValidAllowanceConfigurationForEmployee(AllowanceConfiguration, EmployeeCode, PayrollHeader."To Date") then
                    if AllowanceConfiguration.Formula <> '' then
                        exit(AllowanceConfiguration.EvaluateAmountForEmployee(AllowanceConfiguration.Formula, EmployeeCode))
                    else
                        exit(AllowanceConfiguration.Amount);
        end;
    end;

    procedure MultipleConfigForSameAttribute(AllConfig: Record "Allowance Configuration"): Boolean
    var
        AllConfig2: Record "Allowance Configuration";
    begin
        AllConfig2.SetRange("Payroll Attribute", AllConfig."Payroll Attribute");
        if AllConfig2.Count > 1 then
            exit(true)
        else
            exit(false);
    end;

    procedure UnmarkPayrollDocNo(PayrollDocNo: Code[20]; EmployeeCode: Code[20])
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        OvertimeLedgerEntry: Record "OverTime Ledger Entry";
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        SalaryDeductionEntry: Record "Salary Deduction Entry";
    begin
        AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Request Allowance");
        AssignmentMemoLedgerEntry.SetRange("Employee No.", EmployeeCode);
        AssignmentMemoLedgerEntry.SetFilter("Payroll Document No.", PayrollDocNo);
        if AssignmentMemoLedgerEntry.FindSet() then
            AssignmentMemoLedgerEntry.ModifyAll("Payroll Document No.", '');

        LeaveEarn.Reset();
        LeaveEarn.SetRange("Payroll Posted", true);
        LeaveEarn.SetRange("Payroll Document No", PayrollDocNo);
        LeaveEarn.SetRange("Employee No.", EmployeeCode);
        LeaveEarn.ModifyAll("Payroll Document No", '');

        AllowanceAssignmentLine.Reset();
        AllowanceAssignmentLine.SetRange("Payroll Doc No.", PayrollDocNo);
        AllowanceAssignmentLine.SetRange("Employee Code", EmployeeCode);
        AllowanceAssignmentLine.ModifyAll("Payroll Doc No.", '');

        OvertimeLedgerEntry.Reset();
        OvertimeLedgerEntry.SetRange("Payroll No.", PayrollDocNo);
        OvertimeLedgerEntry.SetRange("Employee No.", EmployeeCode);
        AllowanceAssignmentLine.ModifyAll("Payroll Doc No.", '');

        SalaryDeductionEntry.Reset();
        SalaryDeductionEntry.SetRange("Payroll Document No.", PayrollDocNo);
        SalaryDeductionEntry.SetRange("Employee No.", EmployeeCode);
        SalaryDeductionEntry.ModifyAll("Payroll Document No.", '');
    end;

    local procedure CalculateProRataAmtFromStartDate(EmpCode: Code[20]; AttrCode: Code[20]; var ProRatedAmount: Decimal)
    var
        AttrUsageHistory: Record "Attributes Usage History";
    begin
        AttrUsageHistory.Reset();
        AttrUsageHistory.SetRange("Employee No.", EmpCode);
        AttrUsageHistory.SetRange("Attribute Code", AttrCode);
        AttrUsageHistory.SetRange(Reversed, false);
        AttrUsageHistory.SetFilter("Start Date", '%1..%2', PayrollHeader."From Date", PayrollHeader."To Date");
        if AttrUsageHistory.FindFirst() then begin
            PayCyclePeriod.Reset();
            PayCyclePeriod.SetRange("Start Date", AttrUsageHistory."Start Date");
            if PayCyclePeriod.FindFirst() then
                exit;
            ProRatedAmount := AttrUsageHistory."Old Amount" + GetDifferentialAmount(AttrUsageHistory."New Amount",
                                                                                    AttrUsageHistory."Old Amount",
                                                                                    AttrUsageHistory."Start Date",
                                                                                    PayrollHeader."To Date",
                                                                                    false);
            if (AttrUsageHistory."End Date" <> 0D) and (AttrUsageHistory."End Date" < PayrollHeader."To Date") then
                ProRatedAmount := AttrUsageHistory."Old Amount" + GetDifferentialAmount(AttrUsageHistory."New Amount",
                                                                                        AttrUsageHistory."Old Amount",
                                                                                        AttrUsageHistory."Start Date",
                                                                                        AttrUsageHistory."End Date",
                                                                                        false);
        end;
    end;

    local procedure CalculateProRataAmtFromEndDate(EmpCode: Code[20]; AttrCode: Code[20]; var ProRatedAmount: Decimal)
    var
        AttrUsageHistory: Record "Attributes Usage History";
    begin
        AttrUsageHistory.Reset();
        AttrUsageHistory.SetRange("Employee No.", EmpCode);
        AttrUsageHistory.SetRange("Attribute Code", AttrCode);
        AttrUsageHistory.SetRange(Reversed, false);
        AttrUsageHistory.SetFilter("End Date", '%1..%2', PayrollHeader."From Date", PayrollHeader."To Date");
        if AttrUsageHistory.FindFirst() then begin
            ProRatedAmount := GetDifferentialAmount(AttrUsageHistory."New Amount",
                                                    AttrUsageHistory."Old Amount",
                                                    PayrollHeader."From Date",
                                                    AttrUsageHistory."End Date",
                                                    true);
        end;
    end;

    procedure CalculateProRataAmountAfterTransfer(AttrUsage: Record "Payroll Attributes Usage"; var Amount: Decimal)
    var
        TotalDays: Decimal;
    begin
        GetPayrollHeader();
        TotalDays := "Total Days";
        if PGSetup."Total Days From" = PGSetup."Total Days From"::Year then
            TotalDays := PGSetup."Total Days" / 12;
        if (AttrUsage."Start Date" < PayrollHeader."From Date") and (AttrUsage."End Date" > PayrollHeader."To Date") then
            exit;
        if (AttrUsage."End Date" <> 0D) and (AttrUsage."End Date" < PayrollHeader."From Date") then
            Amount := 0
        else if (AttrUsage."Start Date" >= PayrollHeader."From Date") and (AttrUsage."Start Date" <= PayrollHeader."To Date") then
            Amount := Amount * (PayrollHeader."To Date" - AttrUsage."Start Date" + 1) / TotalDays
        else if (AttrUsage."End Date" >= PayrollHeader."From Date") and (AttrUsage."End Date" <= PayrollHeader."To Date") then
            Amount := Amount - Amount * (PayrollHeader."To Date" - AttrUsage."End Date") / TotalDays;
    end;

    local procedure GetBackdatedAmountEmployeeWiseDateWise(EmpCode: Code[20]; AttrCode: Code[20]): Decimal
    var
        PayrollAttrUsageHistory: Record "Attributes Usage History";
        PayCyclePeriod, PayCyclePeriodBackdated : Record "Pay Cycle Period";
        GetPayCyclePeriodStart, NoOfMonths : Integer;
        HrMgt: Codeunit "HR Mgt.";
    begin
        PayrollAttrUsageHistory.SetRange("Employee No.", EmpCode);
        PayrollAttrUsageHistory.SetRange("Attribute Code", AttrCode);
        PayrollAttrUsageHistory.SetFilter("Entry Date", '%1..%2', PayrollHeader."From Date", PayrollHeader."To Date");
        PayrollAttrUsageHistory.SetFilter("Start Date", '<>%1&<%2', 0D, PayrollHeader."From Date");
        PayrollAttrUsageHistory.SetRange(Reversed, false);
        if PayrollAttrUsageHistory.FindFirst() then begin
            GetPayCyclePeriodStart := HrMgt.GetPayCyclePeriod(PayrollAttrUsageHistory."Start Date", PayCyclePeriodBackdated);
            NoOfMonths := PayrollHeader."Pay Cycle Period" - GetPayCyclePeriodStart;
            PayCyclePeriod.Reset();
            PayCyclePeriod.SetRange("Start Date", PayrollAttrUsageHistory."Start Date");
            if PayCyclePeriod.FindFirst() then
                exit((PayrollAttrUsageHistory."New Amount" - PayrollAttrUsageHistory."Old Amount") * NoOfMonths)
            else begin
                if PayrollAttrUsageHistory."End Date" <> 0D then
                    exit((GetDifferentialAmount(PayrollAttrUsageHistory."New Amount",
                                            PayrollAttrUsageHistory."Old Amount",
                                            PayrollAttrUsageHistory."Start Date",
                                            PayrollAttrUsageHistory."End Date",
                                            true)));
                exit(GetDifferentialAmount(PayrollAttrUsageHistory."New Amount",
                                            PayrollAttrUsageHistory."Old Amount",
                                            PayrollAttrUsageHistory."Start Date",
                                            PayCyclePeriodBackdated."End Date",
                                            false) + ((PayrollAttrUsageHistory."New Amount" - PayrollAttrUsageHistory."Old Amount") * (NoOfMonths - 1)))
            end;
        end;
    end;

    local procedure GetAmountFromDeductionEntries(EmployeeNo: Code[20]; AttributeCode: Code[20]; ForReversedEntries: Boolean): Decimal
    var
        DetSalaryDeductionEntries: Record "Det Salary Deduction Entry";
    begin
        DetSalaryDeductionEntries.Reset();
        DetSalaryDeductionEntries.SetRange("Employee No.", EmployeeNo);
        DetSalaryDeductionEntries.SetRange("Attribute Code", AttributeCode);
        DetSalaryDeductionEntries.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
        DetSalaryDeductionEntries.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
        DetSalaryDeductionEntries.SetRange("Pay Cycle Period", PayrollHeader."Pay Cycle Period");
        DetSalaryDeductionEntries.SetRange(Reversed, ForReversedEntries);
        DetSalaryDeductionEntries.CalcSums(Amount);
        exit(Abs(DetSalaryDeductionEntries.Amount));
    end;

    local procedure GetDifferentialAmount(NewAmount: Decimal; OldAmount: Decimal; FromDate: Date; ToDate: Date; IsEndDateCalculation: Boolean): Decimal
    var
        NoOfDays: Integer;
        OneDayAmount: Decimal;
        DifferentialAmount: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsEndDateCalculation then
            OnBeforeExitOfDifferentialAmount(PayrollHeader, ToDate, OldAmount, DifferentialAmount, IsHandled);
        if not IsHandled then begin
            NoOfDays := ToDate - FromDate + 1;
            OneDayAmount := (NewAmount - OldAmount) / FindTotalDays();
            DifferentialAmount := OneDayAmount * NoOfDays;
        end;
        exit(DifferentialAmount)
    end;

    local procedure FindTotalDays(): Decimal
    var
        PayrollGenSetup: Record "Payroll General Setup";
    begin
        PayrollGenSetup.Get();
        if PayrollGenSetup."Total Days From" = PayrollGenSetup."Total Days From"::Year then
            exit(PayrollGenSetup."Total Days" / 12)
        else
            exit("Total Days"); // from payroll line
    end;

    local procedure PreviouslyPaidAmountToBeReduced(EmpCode: Code[20]; AttrCode: Code[20]; EffectiveDate: Date): Decimal
    var
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
    begin
        DetailedEmployeeLedgerEntry.SetRange("Employee No.", EmpCode);
        DetailedEmployeeLedgerEntry.SetRange("Payroll Attribute Code", AttrCode);
        DetailedEmployeeLedgerEntry.SetRange(Reversed, false);
        DetailedEmployeeLedgerEntry.SetFilter("Posting Date", '%1..%2', EffectiveDate, PayrollHeader."From Date");
        DetailedEmployeeLedgerEntry.CalcSums(Amount);
        exit(DetailedEmployeeLedgerEntry.Amount);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateEmployeeOnBeforeModifyLine(var PayrollLine: Record "Payroll Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetPayrollAttributesOnBeforeSaveValue(var PayrollLine: Record "Payroll Line")
    begin
        //use if needed additional company specific validation or amount update
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeValidateEmployee(EmployeeNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExitOfBaseAmountForCIT(EmployeeCode: Code[20]; var BaseAmount: Decimal)
    begin
        //Additional Allowance amount if needed to be included
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateTotalAmount(TotalDays: Decimal; LwpDays: Decimal; var Amount: Decimal; var IsHandled: Boolean)
    begin
        //If Additional calculation for amount
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExitofDifferentialAmount(PayrollHeaderRec: Record "Payroll Header"; EndDate: Date; Amount: Decimal; var ExitAmount: Decimal; var IsHandled: Boolean)
    begin
        //Additional Allowance amount if needed to be included
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeGettingAllowanceAmtFromAllowanceConfiguration(AllowanceConfiguration: Record "Allowance Configuration"; PayrollLine: Record "Payroll Line"; var IsHandled: Boolean)
    begin
        //conditional step to skip allowance amount fetching from assignment memo ledger
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFilterAllowanceAssignmentLine(var AllowanceAssignmentLine: Record "Allowance Assignment Line")
    begin
        //Additional filter on Allowance Line
    end;
}
