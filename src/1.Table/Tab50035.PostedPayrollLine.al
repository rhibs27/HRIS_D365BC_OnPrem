table 50035 "Posted Payroll Line"
{
    Permissions = tabledata "Employee Ledger Entry" = RIM,
                tabledata "Detailed Employee Ledger Entry" = RIM,
                tabledata "Payable Employee Ledger Entry" = RIM;
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
        field(46; "Source Code"; Code[20])
        {
        }
        field(47; "ATM Custodian Days"; Decimal)
        {

        }
        field(48; "Head Teller Days"; Decimal)
        {
        }
        field(49; "Teller Days"; Decimal)
        {
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
        field(1000; "Bank Name"; Text[50]) { }
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
        field(1021; "Projected Benefit"; Decimal) { }
        field(1022; "Past Benefit"; Decimal) { }
        field(1023; "Assessable Income"; Decimal) { }
        field(1024; "Past Retirement Fund"; Decimal) { }
        field(1025; "Projected Retirement Fund"; Decimal) { }
        field(1026; "Actual RF Contribution"; Decimal) { }
        field(1027; "1/3 of Assessable Income"; Decimal) { }
        field(1028; "Eligible RF Deduction"; Decimal) { }
        field(1029; "Life Insurance Premium"; Decimal) { }
        field(1030; "Health Insurance Premium"; Decimal) { }
        field(1031; "Taxable Income"; Decimal) { }
        field(1032; "Disable Person Reduction"; Decimal) { }
        field(1033; "Female Tax Credit"; Decimal) { }
        field(1034; "Total Tax Liability"; Decimal) { }
        field(1035; "Payable Tax Liability"; Decimal) { }
        field(1036; "Net Tax Liability"; Decimal) { }
        field(1037; "Social Security Tax(Annual)"; Decimal) { }
        field(1038; "Tax on Remuneration(Annual)"; Decimal) { }
        field(1039; "Total Tax Paid"; Decimal) { }
        field(1040; "Carry Forwarded Sick"; Decimal) { }
        field(1041; "Carry Forward Annual"; Decimal) { }
        field(1042; "Prorata Sick"; Decimal) { }
        field(1043; "Prorata Annual"; Decimal) { }
        field(1044; "Used Leave Sick"; Decimal) { }
        field(1045; "Used Leave Annual"; Decimal) { }
        field(1046; "Gratuity & leave Encash Tax"; Decimal) { }
        field(1047; "Projection Month"; Decimal) { }
        field(1048; "Deputation On"; Enum "Deputation Type") { }
        field(1049; "Deputation Code"; Code[20]) { }  //
        field(1050; "Sol ID"; Code[20]) { }
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
        }
        field(1059; "Marital Status"; Enum "Marital Status") { }
        field(1060; "Total SST Paid"; Decimal) { }
        field(1061; "Total Tax Remuneration Paid"; Decimal) { }
        field(1062; "LWP Days"; Decimal) { }
        field(1063; "Prior Leave Days"; Decimal) { }
        field(1064; "Property Insurance Premium"; Decimal) { }

        //
        field(1066; "Current Non-Payments"; Decimal) { }
        field(1067; "Projected Non-Payments"; Decimal) { }
        field(1068; "Past Non-Payments"; Decimal) { }
        field(1069; "39% Slab"; Decimal) { }
        field(1070; "Post Resignation Days"; Decimal) { }

        field(1071; "Post Payroll Days"; Decimal) { Description = 'Post Payroll Days'; Editable = false; }
        field(1072; "Absent Days Before Promotion"; Decimal)
        {
            Description = 'A';
        }
        field(1073; "Absent Days After Promotion"; Decimal)
        {
            Description = 'A';
        }
        field(1075; "CIT Posted 1"; Boolean) { }
        field(1076; "PF Posted 1"; Boolean) { }
        field(1077; "IC Posted 1"; Boolean) { Description = 'Income Tax 1 ( Social Security Tax and Tax on Remuneration)'; }
        field(1078; "IC Posted 2"; Boolean) { Description = 'Income Tax 2 ( Social Security Tax and Tax on Remuneration)'; }
        field(1079; "CIT Posted 2"; Boolean) { }
        field(1080; "PF Posted 2"; Boolean) { }
        field(1081; "Posting Date"; Date) { }
        field(1082; Reversed; Boolean) { }

    }

    keys
    {
        key(Key1; "Document No.", "Line No.") { }
        key(key2; "Salary Level", "Salary Grade") { }
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
        for FieldID := 61 to 220 do begin
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
        TimeSheetSummary.Reset();
        TimeSheetSummary.FILTERGROUP(2);
        TimeSheetSummary.SetRange("Employee Code","Employee No.");
        TimeSheetSummary.SetRange("From Date",PostedPayrollHeader."From Date");
        TimeSheetSummary.SetRange("To Date",PostedPayrollHeader."To Date");
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
