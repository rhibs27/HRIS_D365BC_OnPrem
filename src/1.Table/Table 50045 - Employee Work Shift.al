table 50045 "Employee Work Shift"
{
    // version ATM19.01.01

    DrillDownPageId = "Employee Work Shift";
    LookupPageId = "Employee Work Shift";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(3; "Work Time"; Duration)
        {
            Editable = false;
        }
        field(4; "Registered Employees"; Integer)
        {
            CalcFormula = count(Employee where("Employee Work Shift" = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Start Time"; Time)
        {
            trigger OnValidate()
            begin
                CalcWorkTime("Start Time", "End Time");
            end;
        }
        field(6; "End Time"; Time)
        {
            trigger OnValidate()
            begin
                CalcWorkTime("Start Time", "End Time");
            end;
        }
        field(7; "Working Hour"; Duration)
        {
            Editable = false;
        }
        field(8; "Lunch Start"; Time) { }
        field(9; "Winter End Time"; Time) { }
        field(10; "Friday End Time"; Time) { }
        field(11; "Winter Start Date"; Date) { }
        field(12; "Winter End Date"; Date) { }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }

    var
        Text000: Label 'Start time cannot be greater or equal to End time.';

    local procedure CalcWorkTime(StartTime: Time; EndTime: Time)
    begin
        if ("Start Time" = 0T) or ("End Time" = 0T) then
            "Work Time" := 0
        else begin
            if EndTime <= StartTime then
                Error(Text000);
            if (StartTime <> 0T) and (EndTime <> 0T) then
                "Work Time" := EndTime - StartTime;
        end;
    end;
}
