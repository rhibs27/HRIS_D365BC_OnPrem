table 50024 "Payroll General Setup"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Primary Key"; Code[20]) { }
        field(2; "Tax Ex. Amt. (%) on Retirement"; Decimal) { }
        field(3; "Tax Ex. Amt. not Exceeding"; Decimal) { }
        field(4; "Tax Ex. Life Insurance Amt."; Decimal) { }
        field(5; "Salary Plan No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "Payroll Fiscal Year Start Date"; Date) { }
        field(7; "Payroll Fiscal Year End Date"; Date) { }
        field(8; "Salary Plan Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Posting Method"; Enum "Payroll Posting Method")
        {

        }
        field(10; "Net Payable Account Type"; enum "Payroll Net Payable Acc Type")
        {


            trigger OnValidate()
            begin
                "Net Payable Account Code" := '';
                if "Net Payable Account Type" = "Net Payable Account Type"::"Bank Account" then
                    "Payment Method Code" := '';
            end;
        }
        field(11; "Net Payable Account Code"; Code[20])
        {
            TableRelation = if ("Net Payable Account Type" = const("Bank Account")) "Bank Account"
            else if ("Net Payable Account Type" = const("G/L Account")) "G/L Account";
        }
        field(12; "Tax Calculation Type"; Enum "Tax Calculation Type Time")
        {
        }
        field(13; "Late Deduction Component"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(14; "OT Benefit Component"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(15; "Tax Ex. Amt. (%) on Donation"; Decimal) { }
        field(16; "Tax Ex. Amt. not Exeed on Don."; Decimal)
        {
            Description = 'Tax Ex. Amt. not Exeeding on Donation';
        }
        field(17; "Tax Ex. Amt. (%) on Medical"; Decimal)
        {
            Caption = 'Tax Ex. Amt. (%) on Medical Reimbursment';
        }
        field(18; "Tax Ex. Amt. not Exeed on Med."; Decimal)
        {
            Caption = 'Tax Ex. Amt. not Exeed on Medical Reimbursment';
        }
        field(19; "Payment Method Code"; Code[20])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                if "Payment Method Code" <> '' then begin
                    TestField("Net Payable Account Type", "Net Payable Account Type"::"G/L Account");
                    PaymentMethod.Get("Payment Method Code");
                    PaymentMethod.TestField("Bal. Account Type", PaymentMethod."Bal. Account Type"::"Bank Account");
                    PaymentMethod.TestField("Bal. Account No.");
                end;
            end;
        }
        field(20; "Tax Ex. Amt Divsion"; Decimal)
        {
        }
        field(21; "HRMS Month"; Enum "Nepali Month")
        {
            trigger OnValidate()
            begin
                //ValidateHRMSMonth;
            end;
        }
        field(22; "Make Payroll Slip Confidential"; Boolean)
        { }
        field(23; "Per Step Salary Percentage"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                GradeWiseAttributes.AllCalculateTotalBasicSalary("Per Step Salary Percentage");
            end;
        }
        field(24; "Total Days"; Decimal)
        {
            Description = 'UTS';
        }
        field(25; "Bal. Account Type"; Enum "Bal. Account Type")
        {
            Caption = 'Bal. Account Type';
            Description = 'Use for cit payment,pf contribution';
        }
        field(26; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            Description = 'Use for cit payment,pf contribution';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                               Blocked = const(false))
            else if ("Bal. Account Type" = const(Customer)) Customer
            else if ("Bal. Account Type" = const(Vendor)) Vendor
            else if ("Bal. Account Type" = const("Bank Account")) "Bank Account"
            else if ("Bal. Account Type" = const("Fixed Asset")) "Fixed Asset"
            else if ("Bal. Account Type" = const("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
            end;
        }
        field(27; "CIT Payroll Attribute 1"; Code[20])
        {
            TableRelation = "Payroll Attributes" where(Type = const(Deduction),
                                                        Subtype = const(CIT));
        }
        field(28; "PF Payroll Attribute 1"; Code[20])
        {
            TableRelation = "Payroll Attributes" where(Type = const(Deduction));
        }
        field(29; "IC Payroll Attribute 1"; Code[20])
        {
            TableRelation = "Payroll Attributes" where(Type = const(Deduction));
        }
        field(30; "IC Payroll Attribute 2"; Code[20])
        {
            TableRelation = "Payroll Attributes" where(Type = const(Deduction));
        }
        field(31; "Payroll Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(32; "Payroll Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payroll Journal Template"));
        }
        field(33; "CIT Payroll Attribute 2"; Code[20])
        {
            TableRelation = "Payroll Attributes" where(Type = const(Deduction),
                                                        Subtype = const(CIT));
        }
        field(34; "PF Payroll Attribute 2"; Code[20])
        {
            TableRelation = "Payroll Attributes" where(Type = const(Deduction));
        }
        field(35; "Evening Counter (Regular)"; Decimal) { }
        field(36; "Evening Counter (Contract)"; Decimal) { }
        field(37; "Holiday All. Amt (Regular)"; Decimal) { }
        field(38; "Holiday All. Amt (Contract)"; Decimal) { }
        field(39; "bulk Cash Amt"; Decimal) { }
        field(40; "Festival Counter(Contract)"; Decimal) { }
        field(41; "Festival Counter(Regular)"; Decimal) { }
        field(42; "Vault Key Allowance(Regular)"; Decimal) { }
        field(43; "Vault Key Allowance (Contract)"; Decimal) { }
        field(44; "TA - Out of Pocket"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code;
        }
        field(45; "TA - Lodging Expense"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code;
        }
        field(46; "TA - Food Expense"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code;
        }
        field(47; "Outstn/Discomfort Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(48; "Remote Area Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code;
        }
        field(49; "BM Accomendation"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(50; "COPO/COSPO Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(51; "Officiating Allowance"; Decimal) { }
        field(52; "Faciliator Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(53; "Staff Vehicle Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(54; "Dashain Renumeration"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(55; "Bulk Cash Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(56; "Holiday Counter"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(57; "Evening Counter"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(58; "Festival Counter"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(59; "Vault Key"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(60; "Officiating Allowance Code"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(61; "Comm. Reimbursement"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(62; "Base Teaching Hours"; Decimal) { }
        field(63; "Friday Counter"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(64; "Salary Advance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(65; "BM Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(66; "COPO Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(67; "COSPO Functioal Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(68; "Leave Fare Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(69; "Base Calendar"; Code[20])
        {
            TableRelation = "Base Calendar";
        }
        field(70; "MPPD (Minutes)"; Decimal)
        {
            Description = 'AMS : Minimum Presence Required Per Day';
        }
        field(71; "MPPD Tolorence (ÙMinutes)"; Decimal)
        {
            Description = 'AMS';
        }
        field(72; "Ignore Odd Login Frequencies"; Boolean)
        {
            Description = 'AMS';
        }
        field(73; "Risk Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(74; Gratuity; Code[20])
        {
            Description = 'Gratuity';
            TableRelation = "Payroll Attributes";
        }
        field(75; "Settlement No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(76; "Settlement Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(77; "Leave Encashment"; Code[20])
        {
            Description = 'Leave Encashment';
            TableRelation = "Payroll Attributes";
        }
        field(78; "LFA Recover"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(79; "Insurance Recover"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(80; "Annual Leave"; Code[20])
        {
            TableRelation = "Leave Type Setup";
        }
        field(81; "Sick Leave"; Code[20])
        {
            TableRelation = "Leave Type Setup";
        }
        field(82; "Settlement TAX Rate"; Decimal) { }
        field(83; "Morning Counter"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(84; "Morning Counter (Regular)"; Decimal) { }
        field(85; "Morning Counter (Contract)"; Decimal) { }
        field(86; "Cash Risk Percent"; Decimal) { }
        field(87; "Contract Basic"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(88; "Tax Ex. Health Insur. Amount"; Decimal) { }
        field(89; "Parking Account No."; Code[20]) { }
        field(90; "Payroll Adj No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(91; "Posted Payroll Adj No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(92; "Allowance Grace Period"; Integer) { }
        field(93; "TA Salary Level"; Code[20])
        {
            TableRelation = "Salary Level";
        }
        field(94; "Return Tax"; Boolean) { }
        field(95; "Approval Grace Period"; Integer) { }
        field(96; "Basic Adjustment Code"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code;
        }
        field(97; "Allowance Email Days"; Integer) { }
        field(98; "Default Work Shift"; Code[20])
        {
            TableRelation = "Employee Work Shift";
        }
        field(99; "Relocation Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(100; "Dashain Start Date"; Date) { }
        field(101; "Distributable Amt. for Statuto"; Decimal) { }
        field(102; "CIT (Monthly)"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(103; "CIT (Lumpsum)"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(104; "RTF (Monthly)"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(105; "RTF (Lumpsum)"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(106; "Loan Attribute"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(107; "Settlement Recovery"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(108; "Grade Adjustment Code"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code;
        }
        field(109; "Officiat Basic Adjustment Code"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code;
        }
        field(110; "Tax Ex. Property Insurance Amt"; Decimal) { }
        field(111; "Enable RF Lumpsump Plan"; Boolean) { }
        field(112; "Prev Fiscal Year Start Date"; Date) { }
        field(113; "Prev Fiscal Year End Date"; Date) { }
        field(114; "Previous Year Payroll Enable"; Boolean) { }
        field(115; "OT Start Time"; Time) { }
        field(116; "OT End Time"; Time) { }
        field(117; "Friday OT End Time"; Time) { }
        field(118; "Extra Mileage Calculation"; Decimal) { }
        field(119; "Over Time Calculation"; Decimal) { }
        field(120; "Compensatory Leave Hour"; Decimal) { }
        field(121; "Extra Mileage"; Code[30])
        {
            TableRelation = "OT Encashment Setup";
        }
        field(122; Overtime; Code[30])
        {
            TableRelation = "OT Encashment Setup";
        }
        field(123; "Compensatory Leave"; Code[30])
        {
            TableRelation = "OT Encashment Setup";
        }
        field(124; "Year End Encashment"; Code[30])
        {
            TableRelation = "OT Encashment Setup";
        }
        field(125; "Next Fiscal Year Start Date"; Date) { }
        field(126; "Next Fiscal Year End Date"; Date) { }
        field(127; "Head Teller Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(128; "Teller Allowance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(129; "Head Teller Allow. (Contract)"; Decimal) { }
        field(130; "Head Teller Allow. (Regular)"; Decimal) { }
        field(131; "Teller Allowance (Contract)"; Decimal) { }
        field(132; "Teller Allowance (Regular)"; Decimal) { }
        field(133; "ATM Custodian contract (month)"; Decimal) { }
        field(134; "ATM Custodian regular (month)"; Decimal) { }

        field(135; "ATM Custodian"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(136; "Total Days From"; Enum MonthYear)
        {
        }
        field(137; "Resigned Plan No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(138; "Posted ResignedPlan No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(139; "LFA Source"; Enum "LFA Source")
        {
            Caption = 'LFA Source';
            Description = 'Source of LFA calculation';
        }
        field(140; "Allowance Claim Limit (days)"; Integer) { }
        field(141; "Night Shift Allowance"; Code[20]) { }

    }

    keys
    {
        key(Key1; "Primary Key") { }
    }

    fieldgroups { }

    var
        GradeWiseAttributes: Record "Level Wise Attributes";

    procedure ValidateHRMSMonth()
    begin
        if Rec."HRMS Month" <> xRec."HRMS Month" then begin
            if CheckSalaryAtMonth("HRMS Month") then
                Error('Month end has already performed for %1', "HRMS Month");
            //IF FORMAT("HRMS Month") <>  EngToNepaliDate.getNepaliMonth(TODAY) THEN
            //ERROR('Hrms month must be %1',EngToNepaliDate.getNepaliMonth(TODAY));
        end;
        //<<ratan 1.21.2021
    end;

    local procedure CheckSalaryAtMonth(HRMSMonth: Enum "Nepali Month"): Boolean
    var
        PostedPayrollheader: Record "Posted Payroll Header";
    begin
        PostedPayrollheader.Reset;
        PostedPayrollheader.SetRange("Nepali Month", "HRMS Month");
        if PostedPayrollheader.FindFirst then
            exit(true)
        else
            exit(false);
    end;
}
