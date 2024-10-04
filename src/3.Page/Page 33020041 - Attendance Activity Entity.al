page 33020041 "Attendance Activity Entity"
{
    // version ATM.19.01.01,APINICASIA1.00

    DeleteAllowed = false;
    Editable = false;
    EntityName = 'AttendanceActivityEntity';
    EntitySetName = 'AttendanceActivityEntities';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Employee Attendance & Activity";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(EmployeeNo; Rec."Employee No.") { }
                field(EmployeeName; Rec."Employee Name") { }
                field(AttendanceDate; Rec."Attendance Date") { }
                field(DayType; Rec."Day Type") { }
                field(CheckInTime; getTimeinFormat(Rec."Check In Time")) { }
                field(CheckOutTime; getTimeinFormat(Rec."Check Out Time")) { }
                field(LateRemarks; Rec."Late Remarks") { }
                field(HolidayRemarks; Rec."Holiday Remarks") { }
                field(PresentDay; Rec."Present Day") { }
                field(SourceNo; Rec."Source No.") { }
                field(LeaveDay; Rec."Leave Day") { }
                field(TourDay; Rec."Tour Day") { }
            }
        }
    }

    actions { }

    local procedure getTimeinFormat(varTime: Time): Text
    var
        Milliseconds: Integer;
        Hours: Integer;
        Minutes: Integer;
        Seconds: Integer;
        HoursText: Text;
        MinutesText: Text;
        SecondsText: Text;
        TimeText: Text;
    begin
        if varTime = 0T then
            exit('');
        Milliseconds := varTime - 000000T;

        Hours := Round(Milliseconds div 1000 div 60 div 60, 1, '=');
        if Hours < 10 then
            HoursText := '0' + Format(Hours)
        else
            HoursText := Format(Hours);
        Milliseconds -= Hours * 1000 * 60 * 60;
        TimeText := 'AM';
        Minutes := Round(Milliseconds div 1000 div 60, 1, '=');
        if Minutes < 10 then
            MinutesText := '0' + Format(Minutes)
        else
            MinutesText := Format(Minutes);
        if Hours = 12 then
            TimeText := 'PM';
        Milliseconds -= Minutes * 1000 * 60;

        Seconds := Round(Milliseconds div 1000, 1, '=');
        if Seconds < 10 then
            SecondsText := '0' + Format(Seconds)
        else
            SecondsText := Format(Seconds);
        Milliseconds -= Seconds * 1000;

        if Hours > 12 then begin
            Hours := Hours mod 12;
            TimeText := 'PM';
            if Hours < 10 then
                HoursText := '0' + Format(Hours)
            else
                HoursText := Format(Hours);
        end;
        exit(HoursText + ':' + MinutesText + ' ' + TimeText);
    end;
}
