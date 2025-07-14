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
                field(checkInTime; HrMgt.getTimeInFormat(Rec."Check In Time")) { }
                field(checkOutTime; HrMgt.getTimeInFormat(Rec."Check Out Time")) { }
                field(employeeWorkingShift; Rec."Employee Working Shift") { }
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
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetAscending("Attendance Date", false);
    end;

    var
        HrMgt: Codeunit "HR Mgt.";

}
