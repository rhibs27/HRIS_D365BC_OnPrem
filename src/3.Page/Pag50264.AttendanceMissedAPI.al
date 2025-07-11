page 50264 "Attendance Missed API"
{
    SourceTable = "Employee Attendance & Activity";
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'attendanceMiss';
    EntitySetName = 'attendanceMissApi';
    DelayedInsert = true;
    PageType = API;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(employeeNo; Rec."Employee No.")
                {
                }
                field(employeeName; Rec."Employee Name")
                {

                }
                field(employeeWorkingShift; Rec."Employee Working Shift")
                {
                }
                field(attendanceDate; Rec."Attendance Date")
                {
                }
                field(checkInTime; Hrmgt.getTimeInFormat(Rec."Check In Time"))
                {
                }
                field(checkOutTime; Hrmgt.getTimeInFormat(Rec."Check Out Time"))
                {
                }
                field(presentDay; Rec."Present Day")
                {
                }
                field(leaveDay; Rec."Leave Day")
                {
                }
                field(absentDay; Rec."Absent Day")
                {
                }
            }
        }
    }
    var
        Hrmgt: Codeunit "HR Mgt.";

    trigger OnOpenPage()
    begin
        LoadAttendanceIssues();
    end;

    local procedure LoadAttendanceIssues()
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        HrMgt: Codeunit "HR Mgt.";
        PayrollGenSetup: Record "Payroll General Setup";
    begin
        // Clear temporary table
        Rec.DeleteAll();
        PayrollGenSetup.Get();

        // Load only records with issues into temporary table
        EmployeeAttendanceActivity.Reset();
        EmployeeAttendanceActivity.SetRange("Employee No.", Hrmgt.GetEmployeeNo());
        EmployeeAttendanceActivity.SetRange("Attendance Date", PayrollGenSetup."Payroll Fiscal Year Start Date", Today - 1);
        if EmployeeAttendanceActivity.FindSet() then
            repeat
                if HasAttendanceIssue(EmployeeAttendanceActivity) then begin
                    Rec := EmployeeAttendanceActivity;
                    Rec.Insert();
                end;
            until EmployeeAttendanceActivity.Next() = 0;
    end;

    local procedure HasAttendanceIssue(EmployeeAttendanceActivity: Record "Employee Attendance & Activity"): Boolean
    begin
        // Absent days  Present days with missing times 
        if (EmployeeAttendanceActivity."Present Day" = 1) and ((EmployeeAttendanceActivity."Check In Time" = 0T) or (EmployeeAttendanceActivity."Check Out Time" = 0T)) then
            exit(true)
        else if EmployeeAttendanceActivity."Absent Day" = 1 then
            exit(true);
        exit(false);
    end;
}
