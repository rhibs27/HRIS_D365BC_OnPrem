page 50240 "Attendance Activity Entity"
{


    DeleteAllowed = false;
    Editable = false;
    EntityName = 'attendanceActivityEntity';
    EntitySetName = 'attendanceActivityEntities';
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
                field(employeeNo; Rec."Employee No.") { }
                field(employeeName; Rec."Employee Name") { }
                field(attendanceDate; Rec."Attendance Date") { }
                field(dayType; Rec."Day Type") { }
                field(checkInTime; getTimeinFormat(Rec."Check In Time")) { }
                field(checkOutTime; getTimeinFormat(Rec."Check Out Time")) { }
                field(lateRemarks; Rec."Late Remarks") { }
                field(holidayRemarks; Rec."Holiday Remarks") { }
                field(presentDay; Rec."Present Day") { }
                field(weekOffDay; Rec."Week Off Day")
                {
                }
                field(absentDay; Rec."Absent Day")
                {
                }
                field(sourceNo; Rec."Source No.") { }
                field(leaveDay; Rec."Leave Day") { }
                field(tourDay; Rec."Tour Day") { }
                field(leaveDescription; Rec."Leave Description") { }
            }
        }
    }

    trigger OnOpenPage()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetAscending("Attendance Date", false);
    end;

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
