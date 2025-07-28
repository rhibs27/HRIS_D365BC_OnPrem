report 50149 "Employee Attendance Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Employee Attendance Report';
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/EmployeeAttendanceReport.rdl';

    dataset
    {
        dataitem("Employee Attendance"; "Employee Attendance & Activity")
        {
            RequestFilterFields = "Employee No.", "Attendance Date", "Province Code", "Branch Code", "Department Code";

            column(Employee_No_; "Employee No.")
            {
            }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(Employee_Name; "Employee Name")
            {
            }
            column(Attendance_Date; "Attendance Date")
            {
            }
            column(Check_In_Time; "Check In Time")
            {
            }
            column(Check_Out_Time; "Check Out Time")
            {
            }
            column(Status; Status)
            {
            }
            column(Day_Type; "Day Type")
            {
            }
            column(Present_Day; "Present Day")
            {
            }
            column(Absent_Day; "Absent Day")
            {
            }
            column(Leave_Day; "Leave Day")
            {
            }
            column(Week_Off_Day; "Week Off Day")
            {
            }
            column(Half_Day; "Half Day")
            {
            }
            column(Late_Check_In_Day; "Late Check In Day")
            {
            }
            column(Early_Check_Out_Day; "Early Check Out Day")
            {
            }
            column(OT_Hrs; "OT Hrs")
            {
            }
            column(OT_Day; "OT Day")
            {
            }
            column(Province_Code; "Province Code")
            {
            }
            column(Province_Name; "Province Name")
            {
            }
            column(Branch_Code; "Branch Code")
            {
            }
            column(Branch_Name; "Branch Name")
            {
            }
            column(Department_Code; "Department Code")
            {
            }
            column(Department_Name; "Department Name")
            {
            }
            column(Employee_Working_Shift; "Employee Working Shift")
            {
            }
            column(Shift_Start_Time; "Shift Start Time")
            {
            }
            column(Shift_End_Time; "Shift End Time")
            {
            }
            column(Standard_Work_Time; "Standard Work Time")
            {
            }
            column(Actual_Work_Time; "Actual Work Time")
            {
            }
            column(Work_Time_Difference; "Work Time Difference")
            {
            }
            column(Late_Remarks; "Late Remarks")
            {
            }
            column(Holiday_Remarks; "Holiday Remarks")
            {
            }
            column(Leave_Description; "Leave Description")
            {
            }
            column(Tour_Day; "Tour Day")
            {
            }
            column(Training_Day; "Training Day")
            {
            }

            // Filter Information
            column(AttendanceDateFilter; "Employee Attendance".GetFilter("Attendance Date"))
            {
            }
            column(EmployeeNoFilter; "Employee Attendance".GetFilter("Employee No."))
            {
            }
            column(ProvinceCodeFilter; "Employee Attendance".GetFilter("Province Code"))
            {
            }
            column(BranchCodeFilter; "Employee Attendance".GetFilter("Branch Code"))
            {
            }
            column(DepartmentCodeFilter; "Employee Attendance".GetFilter("Department Code"))
            {
            }

            // Summary Calculations
            column(TotalEmployees; TotalEmployees)
            {
            }
            column(TotalPresent; TotalPresent)
            {
            }
            column(TotalAbsent; TotalAbsent)
            {
            }
            column(TotalLeave; TotalLeave)
            {
            }
            column(TotalWeekOff; TotalWeekOff)
            {
            }
            column(TotalHalfDay; TotalHalfDay)
            {
            }
            column(TotalLateCheckIn; TotalLateCheckIn)
            {
            }
            column(TotalEarlyCheckOut; TotalEarlyCheckOut)
            {
            }
            column(TotalOvertimeHours; TotalOvertimeHours)
            {
            }

            // Status Display
            column(AttendanceStatus; GetAttendanceStatus())
            {
            }

            trigger OnPreDataItem()
            begin
                // Initialize counters
                TotalEmployees := 0;
                TotalPresent := 0;
                TotalAbsent := 0;
                TotalLeave := 0;
                TotalWeekOff := 0;
                TotalHalfDay := 0;
                TotalLateCheckIn := 0;
                TotalEarlyCheckOut := 0;
                TotalOvertimeHours := 0;

                // Apply additional filters based on request page options
                if AttendanceDateFrom <> 0D then
                    SetFilter("Attendance Date", '>=%1', AttendanceDateFrom);

                if AttendanceDateTo <> 0D then
                    SetFilter("Attendance Date", '<=%1', AttendanceDateTo);

                if ShowAbsentOnly then
                    SetRange("Absent Day", 1);

                if ShowPresentOnly then
                    SetRange("Present Day", 1);

                if not IncludeLeaveEmployees then
                    SetFilter("Leave Day", '<>%1', 1);

                if not IncludeWeekOffEmployees then
                    SetFilter("Week Off Day", '<>%1', 1);
            end;

            trigger OnAfterGetRecord()
            begin
                // Calculate summary totals
                TotalEmployees += 1;
                TotalPresent += "Present Day";
                TotalAbsent += "Absent Day";
                TotalLeave += "Leave Day";
                TotalWeekOff += "Week Off Day";
                TotalHalfDay += "Half Day";
                TotalLateCheckIn += "Late Check In Day";
                TotalEarlyCheckOut += "Early Check Out Day";
                TotalOvertimeHours += "OT Hrs";
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowAbsentOnly; ShowAbsentOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Absent Employees Only';
                        ToolTip = 'Select to show only absent employees.';
                    }

                    field(ShowPresentOnly; ShowPresentOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Present Employees Only';
                        ToolTip = 'Select to show only present employees.';
                    }

                    field(IncludeLeaveEmployees; IncludeLeaveEmployees)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Leave Employees';
                        ToolTip = 'Select to include employees on leave in the report.';
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            if AttendanceDateFrom = 0D then
                AttendanceDateFrom := Today;
            if AttendanceDateTo = 0D then
                AttendanceDateTo := Today;
        end;
    }

    var
        CompanyInfo: Record "Company Information";
        TotalEmployees: Integer;
        TotalPresent: Decimal;
        TotalAbsent: Decimal;
        TotalLeave: Decimal;
        TotalWeekOff: Decimal;
        TotalHalfDay: Decimal;
        TotalLateCheckIn: Decimal;
        TotalEarlyCheckOut: Decimal;
        TotalOvertimeHours: Decimal;

        ShowSummaryOnly: Boolean;
        ShowAbsentOnly: Boolean;
        ShowPresentOnly: Boolean;
        IncludeLeaveEmployees: Boolean;
        IncludeWeekOffEmployees: Boolean;
        AttendanceDateFrom: Date;
        AttendanceDateTo: Date;

        ReportTitleLbl: Label 'Employee Attendance Report';

    local procedure GetAttendanceStatus(): Text[20]
    begin
        if "Employee Attendance"."Present Day" = 1 then
            exit('Present');
        if "Employee Attendance"."Absent Day" = 1 then
            exit('Absent');
        if "Employee Attendance"."Leave Day" = 1 then
            exit('On Leave');
        if "Employee Attendance"."Week Off Day" = 1 then
            exit('Week Off');
        exit('Unknown');
    end;
}