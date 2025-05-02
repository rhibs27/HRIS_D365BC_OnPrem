table 50048 "Employee Attendance & Activity"
{
    // version ATM19.01.01
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
        }
        field(4; "Check Out Time"; Time)
        {
        }
        field(5; Status; Enum "Attendance Status")
        {
            Editable = false;

        }

        field(6; "Day Type"; Enum "Day Type")
        {

        }
        field(7; "Employee Working Shift"; Code[10])
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
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Salary Level Code"; Code[10])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(51; "Salary Grade"; Code[10])
        {
            Editable = false;
            TableRelation = "Salary Grade";
        }
        field(52; Week; Enum Week)
        {

        }
        field(53; "Training Day"; Decimal) { }

        field(54; "Training Check Out Time"; Time) { }

    }

    keys
    {
        key(Key1; "Employee No.", "Attendance Date") { }
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
        EmpAttAct: Record "Employee Attendance & Activity";

    procedure updateReviewerCheckReviewer()
    var
        EmpAttendanceFilterPageBuilder: FilterPageBuilder;
        EmployeeNo: Code[20];
        AttendanceDate: Date;
        PunchoutReviewer: Code[20];
        PunchoutCheckReviewer: Code[20];
        PunchoutReviewerMsg: Label 'Reviewer of %1 on %2 has been Updated Sucessfully.';
        PunchoutCheckReviewerMsg: Label 'Check Reviewer of %1 on %2 has been Updated Sucessfully.';
        ErrorMsg1: Label 'Please Select Either Reviewer or Check Reviewer.';
        ErrorMsg2: Label 'Attendance Date must have a Value, to Change either Reviewer and Check Reviewer.';
    begin
        EmpAttendanceFilterPageBuilder.AddRecord('Employee Attendance & Activity', Rec);
        EmpAttendanceFilterPageBuilder.AddField('Employee Attendance & Activity', "Employee No.");
        EmpAttendanceFilterPageBuilder.AddField('Employee Attendance & Activity', "Attendance Date");
        EmpAttendanceFilterPageBuilder.AddField('Employee Attendance & Activity', "Punch Out Reviewer");
        EmpAttendanceFilterPageBuilder.AddField('Employee Attendance & Activity', "Punch Out Check Reviewer");
        EmpAttendanceFilterPageBuilder.RunModal;
        EmpAttAct.SetView(EmpAttendanceFilterPageBuilder.GetView('Employee Attendance & Activity'));
        EmployeeNo := EmpAttAct.GetFilter("Employee No.");
        Evaluate(AttendanceDate, EmpAttAct.GetFilter("Attendance Date"));
        PunchoutReviewer := EmpAttAct.GetFilter("Punch Out Reviewer");
        PunchoutCheckReviewer := EmpAttAct.GetFilter("Punch Out Check Reviewer");

        if (EmployeeNo <> '') and (AttendanceDate = 0D) then
            Error(ErrorMsg2);
        if (EmployeeNo <> '') and (AttendanceDate <> 0D) then
            if (PunchoutReviewer = '') and (PunchoutCheckReviewer = '') then
                Error(ErrorMsg1);
        if PunchoutReviewer <> '' then begin
            Validate("Punch Out Reviewer", PunchoutReviewer);
            Modify;
            Message(PunchoutReviewerMsg, EmployeeNo, AttendanceDate);
        end;
        if PunchoutCheckReviewer <> '' then begin
            Validate("Punch Out Check Reviewer", PunchoutCheckReviewer);
            Modify;
            Message(PunchoutCheckReviewerMsg, EmployeeNo, AttendanceDate);
        end;
    end;
}
