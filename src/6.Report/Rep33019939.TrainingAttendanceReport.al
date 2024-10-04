report 33019939 "Training Attendance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019939.TrainingAttendanceReport.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Attendance & Activity"; "Employee Attendance & Activity")
        {
            DataItemTableView = sorting("Employee No.", "Attendance Date") where("Training Check In Time" = filter(<> 0T));
            RequestFilterFields = "Employee No.", "Attendance Date";
            column(EmployeeNo_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Employee No.") { }
            column(AttendanceDate_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Attendance Date")) { }
            column(CheckInTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Check In Time")) { }
            column(CheckOutTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Check Out Time")) { }
            column(NightShiftPunchOutTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Night Shift Punch Out Time")) { }
            column(TrainingCheckInTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Training Check In Time")) { }
            column(TrainingCheckOutTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Training Check Out Time")) { }
            column(PunchoutRemarks_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Punch out Remarks")) { }
            column(AttendanceDateFilter; AttendanceDateFilter) { }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        AttendanceDateFilter := "Employee Attendance & Activity".GetFilter("Attendance Date");
    end;

    var
        AttendanceDateFilter: Text;
}
