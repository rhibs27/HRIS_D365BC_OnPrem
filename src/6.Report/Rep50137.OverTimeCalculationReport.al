report 50137 "OverTime Calculation Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019938.ExtramileageCalculationRepor.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Attendance & Activity"; "Employee Attendance & Activity")
        {
            RequestFilterFields = "Employee No.", "Attendance Date", "Day Type", "Overtime Disbursed";
            column(EmployeeNo_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Employee No.") { }
            column(DayType_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Day Type") { }
            column(PunchoutRemarks_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Punch out Remarks") { }
            column(OvertimeDisbursed_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Overtime Disbursed") { }
            column(AttendanceDate_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Attendance Date")) { }
            column(CheckInTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Check In Time")) { }
            column(CheckOutTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Check Out Time")) { }
            column(LateRemarks_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Late Remarks") { }
            column(EmployeeName_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Employee Name") { }
            column(SalaryLevelCode; SalaryLevelCode) { }
            column(ApprovalStatus; ApprovalStatus) { }

            trigger OnAfterGetRecord()
            begin
                Clear(SalaryLevelCode);
                Clear(ApprovalStatus);
                OverTime.Reset;
                OverTime.SetRange("Employee No.", "Employee No.");
                OverTime.SetRange(Type, OverTime.Type::Overtime);
                OverTime.SetRange("Start Date", "Attendance Date");
                if OverTime.FindFirst then begin
                    SalaryLevelCode := OverTime."Salary Level Code";
                    ApprovalStatus := OverTime."Approval Status";
                end;
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        SalaryLevelCode: Code[20];
        ApprovalStatus: Enum "Approval Status";
        OverTime: Record "Overtime";
}
