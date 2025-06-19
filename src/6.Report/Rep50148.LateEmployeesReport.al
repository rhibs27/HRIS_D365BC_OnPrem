report 50148 "Late Employees Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50148.LateEmployeesReport.rdl';
    ApplicationArea = All;
    Caption = 'Late Employees Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            dataitem(EmployeeAttendanceActivity; "Employee Attendance & Activity")
            {
                DataItemLink = "Employee No." = field("No.");
                RequestFilterFields = "Attendance Date";

                column(EmployeeNo; "Employee No.") { }
                column(Employee_Name; "Employee Name") { }
                column(CheckInTime; "Check In Time") { }
                column(CheckOutTime; "Check Out Time") { }
                column(ShiftStartTime; "Shift Start Time") { }
                column(ShiftEndTime; "Shift End Time") { }
                column(ActualHoursWorked; ActualHoursWorked) { }
                column(LateByMinutes; LateByMinutes) { }
                column(EarlyOutByMinutes; EarlyOutByMinutes) { }
                column(BranchCode; Employee."Branch Code") { }
                column(ProvinceCode; Employee."Province Code") { }
                column(DepartmentCode; Employee."Department Code") { }
                column(Designation; Employee."Job Title") { }
                column(AttendanceDate; "Attendance Date") { }
                column(Month; Month) { }

                trigger OnAfterGetRecord()
                var
                    DurationTemp: Duration;
                begin

                    ActualHoursWorked := 0;
                    LateByMinutes := 0;
                    EarlyOutByMinutes := 0;


                    if ("Check In Time" <> 0T) and ("Check Out Time" <> 0T) then begin
                        DurationTemp := "Check Out Time" - "Check In Time";
                        if DurationTemp < 0 then
                            DurationTemp := 86400000 + DurationTemp;
                        ActualHoursWorked := Round(DurationTemp / 3600000, 0.01);
                    end;


                    if ("Check In Time" <> 0T) and ("Shift Start Time" <> 0T) and ("Check In Time" > "Shift Start Time") then
                        LateByMinutes := Round(("Check In Time" - "Shift Start Time") / 60000, 1);


                    if ("Check Out Time" <> 0T) and ("Shift End Time" <> 0T) and ("Check Out Time" < "Shift End Time") then
                        EarlyOutByMinutes := Round(("Shift End Time" - "Check Out Time") / 60000, 1);
                    if "Attendance Date" <> 0D then
                        Month := Format("Attendance Date", 0, '<Month Text>');
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(FilterGroup)
                {

                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        ActualHoursWorked: Decimal;
        LateByMinutes: Integer;
        EarlyOutByMinutes: Integer;
        Month: Text[20];

}
