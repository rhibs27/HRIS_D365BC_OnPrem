table 50048 "Employee Attendance & Activity"
{
    DrillDownPageId = "Employee Attendance & Activity";
    LookupPageId = "Employee Attendance & Activity";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(2; "Attendance Date"; Date)
        {
            Editable = false;
        }
        field(3; "Check In Time"; Time)
        {
            BlankNumbers = BlankZero;
        }
        field(4; "Check Out Time"; Time)
        {
            BlankNumbers = BlankZero;
        }
        field(5; Status; enum "Approval Status")
        {
            Editable = false;

        }

        field(6; "Day Type"; Enum "Day Type")
        {

        }
        field(7; "Employee Working Shift"; Code[20])
        {
            TableRelation = "Employee Work Shift";
        }
        field(8; "Shift Start Time"; Time) { }
        field(9; "Shift End Time"; Time) { }
        field(10; "Check In Difference"; Duration) { }
        field(11; "Check Out Difference"; Duration) { }
        field(12; "Standard Work Time"; Duration) { }
        field(13; "Actual Work Time"; Duration) { }
        field(14; "Work Time Difference"; Duration) { }
        field(15; "Present Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Present Day" = 1 then
                    "Absent Day" := 0;
            end;
        }
        field(16; "Week Off Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
        field(17; "Leave Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
        field(18; "Absent Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Absent Day" = 1 then
                    "Present Day" := 0;
            end;
        }
        field(19; "Tour Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
        field(20; "Half Day"; Decimal)
        {
            Caption = 'Half Day';
            MaxValue = 0.5;
            MinValue = 0;
        }
        field(21; "Late Check In Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
        field(22; "OT Hrs"; Decimal) { }
        field(23; "OT Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
        field(24; "Early Check Out Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
        field(25; "Outdoor Duty Day"; Decimal) { }
        field(26; "Late Remarks"; Text[100])
        {
        }
        field(27; "Late Day"; Decimal) { }
        field(28; "Daily Food Allowance"; Decimal) { }
        field(29; "Employee Activity Found"; Boolean) { }
        field(30; "Attendance Date (B.S)"; Text[20]) { }
        field(31; "Source No."; Code[20])
        {
        }
        field(32; "Created Datetime"; DateTime)
        {
        }
        field(33; "Holiday Remarks"; Text[250])
        {
        }
        field(34; "Pay Type"; Enum "Leave Pay Type")
        {

        }
        field(35; "Friday Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(36; "Holiday Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(37; "Vault Key Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(38; "Evening Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(39; "Morning Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(40; "Cash Risk Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(41; "Festival Counter Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(42; "Leave Description"; Text[50])
        {
            Editable = false;
        }
        field(43; "Punch Out Reviewer"; Code[20])
        {
            TableRelation = Employee;
        }
        field(44; "Punch Out Check Reviewer"; Code[20])
        {
            TableRelation = Employee;
        }
        field(45; "Punch out Remarks"; Text[250]) { }
        field(46; "Overtime Disbursed"; Boolean) { }
        field(47; "Night Shift Punch Out Time"; Time) { }
        field(48; "Training Check In Time"; Time) { }


        field(49; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(50; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(51; "Salary Grade"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Grade";
        }
        field(52; Week; Enum Week)
        {

        }
        field(53; "Training Day"; Decimal) { }

        field(54; "Training Check Out Time"; Time) { }
        field(55; "Province Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Province));
        }
        field(56; "Province Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(57; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Branch));
        }
        field(58; "Branch Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department));
        }
        field(60; "Department Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(61; "Transfer Day"; Decimal) { }

        field(101; "Head Teller Allowance Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(102; "Teller Allowance Days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(103; "ATM Custodian Allowance days"; Decimal)
        {
            Description = 'allowance assignment';
        }
        field(104; "Attendance Update"; Boolean) { }
        field(105; "Late Deduction"; Boolean)
        {
            Description = 'Late Deduction';
        }
        field(106; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Unit));
        }
        field(107; "Leave Code"; Code[20])
        {
            Caption = 'Leave Code';
            TableRelation = "Leave Type Setup";
        }
        field(108; "Dashain Allowance Days"; Decimal)
        {
            Caption = 'Dashain Allowance Days';
        }
        field(109; "OverNight Shift"; Boolean)
        {
            Caption = 'OverNight Shift';
        }
        field(110; "Check-In Device IP"; text[20])
        {

        }
        field(111; "Check-Out Device IP"; text[20])
        {

        }
        field(112; "Extension Counter"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::"Extension Counter"));
        }
        field(113; "Leave Type"; Enum "Leave Type")
        {
            DataClassification = ToBeClassified;
        }
        field(200; "Entry Type"; Enum "Attendance Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(201; "Present in Holiday"; Decimal) { }
        field(202; Remarks; Text[150]) { }

    }

    keys
    {
        key(Key1; "Employee No.", "Attendance Date", "Employee Working Shift") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Created Datetime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Created Datetime" := CurrentDateTime;
    end;

    var
        Employee: Record Employee;

    procedure CopyFromEmployee(Employee: Record Employee)
    begin
        "Province Code" := Employee."Province Code";
        "Province Name" := Employee."Province Name";
        "Branch Code" := Employee."Branch Code";
        "Branch Name" := Employee."Branch Name";
        "Department Code" := Employee."Department Code";
        "Department Name" := Employee."Department Name";
        "Unit Code" := Employee."Union Code";
        "Extension Counter" := Employee."Extension Counter Code";
    end;
}
