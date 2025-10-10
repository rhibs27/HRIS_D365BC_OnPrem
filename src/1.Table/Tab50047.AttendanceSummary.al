table 50047 "Attendance Summary"
{
    DataClassification = CustomerContent;
    // version ATM19.01.01

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Attendance Header"."No.";
        }
        field(2; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then
                    Validate("Employee Name", Employee."Full Name")
                else
                    Clear("Employee Name");
                GetAttedanceDate;
            end;
        }
        field(3; Status; enum "Approval Status")
        {
            Editable = false;
        }
        field(4; "From Date"; Date)
        {
            Editable = false;
        }
        field(5; "To Date"; Date)
        {
            Editable = false;
        }
        field(6; Month; Enum "English Month")
        {
            Editable = false;
        }
        field(7; "From Date (B.S)"; Code[20])
        {
            Editable = false;
        }
        field(8; "To Date (B.S)"; Code[20])
        {
            Editable = false;
        }
        field(9; "Nepali Month"; Enum "Nepali Month")
        {
            Editable = false;
        }
        field(10; "Nepali Year"; Integer)
        {
            Editable = false;
        }
        field(11; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(12; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(13; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(14; "Present Day"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Present Day" where("Employee No." = field("Employee No."),
                                                                                    "Attendance Date" = field("Date Filter"),
                                                                                    "Present Day" = filter(<> 0),
                                                                                    "Leave Day" = filter(<> 1),
                                                                                    "Week Off Day" = filter(<> 1)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Week Off Day"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Week Off Day" where("Employee No." = field("Employee No."),
                                                                                     "Week Off Day" = filter(<> 0),
                                                                                     "Attendance Date" = field("Date Filter"),
                                                                                     "Pay Type" = filter(<> Unpaid)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Leave Day"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Leave Day" where("Employee No." = field("Employee No."),
                                                                                  "Day Type" = const("Working Day"),
                                                                                  "Attendance Date" = field("Date Filter"),
                                                                                  "Leave Day" = filter(<> 0),
                                                                                  "Absent Day" = filter(<> 1)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Absent Day"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Absent Day" where("Employee No." = field("Employee No."),
                                                                                   "Day Type" = const("Working Day"),
                                                                                   "Attendance Date" = field("Date Filter"),
                                                                                   "Absent Day" = filter(<> 0),
                                                                                   "Week Off Day" = const(0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Total Days"; Integer)
        {
            CalcFormula = count("Employee Attendance & Activity" where("Employee No." = field("Employee No."),
                                                                        "Attendance Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Tour Day"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Tour Day" where("Employee No." = field("Employee No."),
                                                                                 "Day Type" = const("Working Day"),
                                                                                 "Attendance Date" = field("Date Filter"),
                                                                                 "Tour Day" = filter(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Half Day"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Half Day" where("Employee No." = field("Employee No."),
                                                                                 "Day Type" = const("Working Day"),
                                                                                 "Attendance Date" = field("Date Filter"),
                                                                                 "Half Day" = filter(<> 0)));
            Caption = 'Half Day';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Late Check In Day"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Late Check In Day" where("Employee No." = field("Employee No."),
                                                                                          "Day Type" = const("Working Day"),
                                                                                          "Attendance Date" = field("Date Filter"),
                                                                                          "Late Check In Day" = filter(<> 0),
                                                                                          "Late Deduction" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "OT Hrs"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."OT Hrs" where("Employee No." = field("Employee No."),
                                                                               "Attendance Date" = field("Date Filter"),
                                                                               "OT Hrs" = filter(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "OT Days"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."OT Day" where("Employee No." = field("Employee No."),
                                                                               "Attendance Date" = field("Date Filter"),
                                                                               "OT Day" = filter(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Late Check Out Day"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Early Check Out Day" where("Employee No." = field("Employee No."),
                                                                                            "Day Type" = const("Working Day"),
                                                                                            "Attendance Date" = field("Date Filter"),
                                                                                            "Early Check Out Day" = filter(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(26; "Employee Name"; Text[100]) { }
        field(27; "Friday Counter Days"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Friday Counter Days" where("Employee No." = field("Employee No."),
                                                                                            "Attendance Date" = field("Allowance Date Filter"),
                                                                                            "Friday Counter Days" = filter(<> 0)));
            Description = 'allowance assignment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Holiday Counter Days"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Holiday Counter Days" where("Employee No." = field("Employee No."),
                                                                                             "Attendance Date" = field("Allowance Date Filter"),
                                                                                             "Holiday Counter Days" = filter(<> 0)));
            Description = 'allowance assignment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Vault Key Days"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Vault Key Days" where("Employee No." = field("Employee No."),
                                                                                       "Attendance Date" = field("Allowance Date Filter"),
                                                                                       "Vault Key Days" = filter(<> 0)));
            Description = 'allowance assignment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Evening Counter Days"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Evening Counter Days" where("Employee No." = field("Employee No."),
                                                                                             "Attendance Date" = field("Allowance Date Filter"),
                                                                                             "Evening Counter Days" = filter(<> 0)));
            Description = 'allowance assignment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Morning Counter Days"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Morning Counter Days" where("Employee No." = field("Employee No."),
                                                                                             "Attendance Date" = field("Allowance Date Filter"),
                                                                                             "Morning Counter Days" = filter(<> 0)));
            Description = 'allowance assignment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Cash Risk Days"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Cash Risk Days" where("Employee No." = field("Employee No."),
                                                                                       "Attendance Date" = field("Allowance Date Filter"),
                                                                                       "Cash Risk Days" = filter(<> 0)));
            Description = 'allowance assignment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Festival Counter Days"; Decimal)
        {
            CalcFormula = sum("Employee Attendance & Activity"."Festival Counter Days" where("Employee No." = field("Employee No."),
                                                                                              "Attendance Date" = field("Allowance Date Filter"),
                                                                                              "Festival Counter Days" = filter(<> 0)));
            Description = 'allowance assignment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "Allowance Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(35; "ATM Custodian Days"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Employee Attendance & Activity"."ATM Custodian Allowance days" where("Employee No." = field("Employee No."),
                                                                                              "Attendance Date" = field("Allowance Date Filter"),
                                                                                              "ATM Custodian Allowance days" = filter(<> 0)));
        }
        field(36; "Head Teller Days"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Employee Attendance & Activity"."Head Teller Allowance Days" where("Employee No." = field("Employee No."),
                                                                                              "Attendance Date" = field("Allowance Date Filter"),
                                                                                              "Head Teller Allowance Days" = filter(<> 0)));
        }
        field(37; "Teller Days"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Employee Attendance & Activity"."Teller Allowance Days" where("Employee No." = field("Employee No."),
                                                                                              "Attendance Date" = field("Allowance Date Filter"),
                                                                                              "Teller Allowance Days" = filter(<> 0)));

        }
    }
    keys
    {
        key(Key1; "Document No.", "Employee No.") { }
        key(Key2; "Employee No.", "From Date", "To Date") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        //CheckStatusOpen;
        AttendanceLine.Reset;
        AttendanceLine.SetRange("Document No.", "Document No.");
        AttendanceLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        CheckStatusOpen;
        GetAttedanceDate;
    end;

    trigger OnModify()
    begin
        CheckStatusOpen;
    end;

    var
        AttendanceLine: Record "Attendance Line";
        Employee: Record Employee;
        AttendanceHeader: Record "Attendance Header";

    procedure DrillDownDetails()
    var
        AttendanceLine: Record "Attendance Line";
        AttendanceDetails: Page "Attendance Detail";
    begin
        AttendanceLine.Reset;
        AttendanceLine.SetRange("Document No.", "Document No.");
        AttendanceLine.SetRange("Employee No.", "Employee No.");
        Clear(AttendanceDetails);
        AttendanceDetails.SetTableView(AttendanceLine);
        AttendanceDetails.Run;
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

    procedure GetDeviceAttendance()
    var
        AttendanceLine: Record "Attendance Line";
        AttendanceDetailList: Page "Attendance Detail";
    begin
        AttendanceLine.Reset;
        AttendanceLine.FilterGroup(2);
        //AttendanceLine.SetRange("Document No.","Document No.");
        AttendanceLine.SetRange("Employee No.", "Employee No.");
        AttendanceLine.SetRange("Attendance Date", "From Date", "To Date");
        AttendanceLine.FilterGroup(0);
        Clear(AttendanceDetailList);
        AttendanceDetailList.SetTableView(AttendanceLine);
        AttendanceDetailList.RunModal;
    end;

    local procedure GetAttedanceDate()
    begin
        if AttendanceHeader.Get("Document No.") then begin
            Validate("From Date", AttendanceHeader."From Date");
            Validate("To Date", AttendanceHeader."To Date")
        end;
    end;
}
