table 50043 "Attendance Line"
{
    // version ATM19.01.01

    DrillDownPageId = "Attendance Detail";
    LookupPageId = "Attendance Detail";
    DataClassification = CustomerContent;

    fields
    {
        field(48; "Document No."; Code[20])
        {
            TableRelation = "Attendance Header"."No.";
        }
        field(5; Status; Enum "Attendance Status")
        {
            Editable = false;

        }
        field(40; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(41; "Pay Cycle Term"; Code[10])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(42; "Pay Cycle Code"; Code[10])
        {
            TableRelation = "Pay Cycle";
        }
        field(43; "Nepali Year"; Integer)
        {
            Editable = false;
        }
        field(6; "Nepali Month"; Enum "Nepali Month")
        {
            Editable = false;
        }
        field(44; "From Date"; Date)
        {
            Editable = false;
        }
        field(45; "To Date"; Date)
        {
            Editable = false;
        }
        field(25; Month; Enum "English Month")
        {
            Editable = false;
        }
        field(46; "From Date (B.S)"; Code[10])
        {
            Editable = false;
        }
        field(47; "To Date (B.S)"; Code[10])
        {
            Editable = false;
        }
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
            trigger OnValidate()
            begin
                GetCheckInOutDifference;
                CalcAcutalWorkTime("Check In Time", "Check Out Time");
            end;
        }
        field(4; "Check Out Time"; Time)
        {
            trigger OnValidate()
            begin
                GetCheckInOutDifference;
                CalcAcutalWorkTime("Check In Time", "Check Out Time");
            end;
        }
        field(26; Remarks; Text[100])
        {
        }
        field(27; "Approved Activity"; Boolean)
        {
        }
        field(28; "Day Type"; Enum "Day Type")
        {

        }
        field(29; "Entry Type"; Enum "Attendance Entry Type")
        {
        }
        field(7; "Employee Working Shift"; Code[10])
        {
            TableRelation = "Employee Work Shift";

            trigger OnValidate()
            begin
                if "Employee Working Shift" <> '' then begin
                    EmployeeWorkShift.Get("Employee Working Shift");
                    Validate("Shift Start Time", EmployeeWorkShift."Start Time");
                    Validate("Shift End Time", EmployeeWorkShift."End Time");
                    "Standard Work Time" := EmployeeWorkShift."Work Time";
                end else begin
                    Validate("Shift Start Time", 0T);
                    Validate("Shift End Time", 0T);
                    "Standard Work Time" := 0;
                end;
            end;
        }
        field(8; "Shift Start Time"; Time)
        {
            trigger OnValidate()
            begin
                GetCheckInOutDifference;
            end;
        }
        field(9; "Shift End Time"; Time)
        {
            trigger OnValidate()
            begin
                GetCheckInOutDifference;
            end;
        }
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
                if ("Present Day" = 1) then
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
        field(23; "OT Days"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
        field(24; "Early Check Out Day"; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
        field(30; "Holiday Remarks"; Text[250]) { }
        field(31; "Punch Out Reviewer"; Code[20])
        {
            TableRelation = Employee;
        }
        field(32; "Punch Out Check Reviewer"; Code[20])
        {
            TableRelation = Employee;
        }
        field(33; "Punch out Remarks"; Text[250]) { }
        field(34; "Night Shift Punch Out Time"; Time) { }
        field(35; "Training Check In Time"; Time) { }
        field(36; "Training Check Out Time"; Time) { }
        field(37; "Salary Level Code"; Code[10])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(38; "Salary Grade"; Code[10])
        {
            Editable = false;
            TableRelation = "Salary Grade";
        }
        field(39; Week; Enum Week)
        {
        }
        field(50; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(49; "Employee Name"; Text[50])
        {
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Employee No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Employee No.", "Attendance Date") { }
        key(Key2; "Employee No.", "Attendance Date") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        //CheckStatusOpen;
        //ERROR('');
    end;

    trigger OnInsert()
    begin
        CheckStatusOpen;
    end;

    trigger OnModify()
    begin
        //CheckStatusOpen;
    end;

    var
        EmployeeWorkShift: Record "Employee Work Shift";

    local procedure ValidateDays()
    begin
    end;

    local procedure NotPresent(): Boolean
    begin
        exit("Present Day" = 0);
    end;

    local procedure LeaveExists(): Boolean
    begin
        exit("Leave Day" > 0);
    end;

    local procedure TourExists(): Boolean
    begin
        exit("Tour Day" = 1);
    end;

    local procedure WeekOffDay(): Boolean
    begin
        exit("Week Off Day" = 1);
    end;

    local procedure HalfDayPresent(): Boolean
    begin
        exit("Present Day" = 0.5);
    end;

    local procedure CheckStatusOpen()
    var
        AttendanceHeader: Record "Attendance Header";
    begin
        AttendanceHeader.Get("Document No.");
        AttendanceHeader.TestField(Status, AttendanceHeader.Status::Open);
        AttendanceHeader.TestField(Posted, false);
    end;

    procedure Posted(): Boolean
    var
        AttendanceHeader: Record "Attendance Header";
    begin
        AttendanceHeader.Get("Document No.");
        exit(AttendanceHeader.Posted);
    end;

    procedure CopyFromAttendanceHeader(AttendanceHeader: Record "Attendance Header")
    begin
        "From Date" := AttendanceHeader."From Date";
        "To Date" := AttendanceHeader."To Date";
        Month := AttendanceHeader.Month;
        "From Date (B.S)" := AttendanceHeader."From Date (B.S)";
        "To Date (B.S)" := AttendanceHeader."To Date (B.S)";
        "Nepali Month" := AttendanceHeader."Nepali Month";
        "Nepali Year" := AttendanceHeader."Nepali Year";
        "Pay Cycle Code" := AttendanceHeader."Pay Cycle Code";
        "Pay Cycle Term" := AttendanceHeader."Pay Cycle Term";
        "Pay Cycle Period" := AttendanceHeader."Pay Cycle Period";
    end;

    local procedure GetCheckInOutDifference()
    begin
        if ("Shift Start Time" <> 0T) and ("Check In Time" <> 0T) then
            "Check In Difference" := "Shift Start Time" - "Check In Time";
        if ("Shift End Time" <> 0T) and ("Check Out Time" <> 0T) then
            "Check Out Difference" := "Shift End Time" - "Check Out Time";
    end;

    local procedure CalcAcutalWorkTime(StartTime: Time; EndTime: Time)
    begin
        if ("Check In Time" = 0T) or ("Check Out Time" = 0T) then
            "Actual Work Time" := 0
        else begin
            //IF EndTime <= StartTime THEN
            //ERROR(Text000);
            if (StartTime <> 0T) and (EndTime <> 0T) then
                "Actual Work Time" := EndTime - StartTime;
        end;
    end;
}
