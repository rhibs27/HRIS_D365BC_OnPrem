report 50149 "Employee Attendance Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Employee Attendance Report';
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/EmployeeAttendanceReport.rdl';
    dataset
    {
        dataitem("Employee Attendance"; "Employee Attendance & Activity")
        {
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
            column(Unit_Code; "Unit Code")
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
            column(AttendanceDateFilter; AttendanceDateFilter)
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
            column(UnitCodeFilter; "Employee Attendance".GetFilter("Unit Code"))
            {
            }
            // Request Page Filter Values
            column(AttendanceDateFrom; AttendanceDateFrom)
            {
            }
            column(AttendanceDateTo; AttendanceDateTo)
            {
            }
            column(ShowPresentOnly; ShowPresentOnly)
            {
            }
            column(ShowAbsentOnly; ShowAbsentOnly)
            {
            }
            column(IncludeLeaveEmployees; IncludeLeaveEmployees)
            {
            }
            column(IncludeWeekOffEmployees; IncludeWeekOffEmployees)
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
            column(AttendanceStatus; GetAttendanceStatus())
            {
            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
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
                // Apply date range filters
                if (AttendanceDateFrom <> 0D) and (AttendanceDateTo <> 0D) then begin
                    SetRange("Attendance Date", AttendanceDateFrom, AttendanceDateTo);
                    AttendanceDateFilter := StrSubstNo('%1..%2', AttendanceDateFrom, AttendanceDateTo);
                end else if AttendanceDateFrom <> 0D then begin
                    SetFilter("Attendance Date", '>=%1', AttendanceDateFrom);
                    AttendanceDateFilter := StrSubstNo('>=%1', AttendanceDateFrom);
                end else if AttendanceDateTo <> 0D then begin
                    SetFilter("Attendance Date", '<=%1', AttendanceDateTo);
                    AttendanceDateFilter := StrSubstNo('<=%1', AttendanceDateTo);
                end else
                    AttendanceDateFilter := '';
                // Apply attendance status filters - these are mutually exclusive
                if ShowPresentOnly then begin
                    SetRange("Present Day", 1);
                end else if ShowAbsentOnly then begin
                    SetRange("Absent Day", 1);
                end;
                // Apply leave filters
                if not IncludeLeaveEmployees then
                    SetFilter("Leave Day", '<>%1', 1)
                else
                    SetRange("Leave Day", 1);
                if EmployeeNoFilter <> '' then
                    SetFilter("Employee No.", EmployeeNoFilter);
                if ProvinceCodeFilter <> '' then
                    SetFilter("Province Code", ProvinceCodeFilter);
                if BranchCodeFilter <> '' then
                    SetFilter("Branch Code", BranchCodeFilter);
                if DepartmentCodeFilter <> '' then
                    SetFilter("Department Code", DepartmentCodeFilter);
                if UnitCodeFilter <> '' then
                    SetFilter("Unit Code", UnitCodeFilter);
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
                group(DateRange)
                {
                    Caption = 'Apply Filter';
                    field(ShowPresentOnly; ShowPresentOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Present Employees Only';
                        ToolTip = 'Select to show only present employees.';
                    }
                    field(ShowAbsentOnly; ShowAbsentOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Absent Employees Only';
                        ToolTip = 'Select to show only absent employees.';
                    }
                    field(IncludeLeaveEmployees; IncludeLeaveEmployees)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Leave Employees';
                        ToolTip = 'Select to include employees on leave in the report.';
                    }
                    field(AttendanceDateFrom; AttendanceDateFrom)
                    {
                        ApplicationArea = All;
                        Caption = 'Attendance Date From';
                        ToolTip = 'Specify the start date for the attendance report.';
                        trigger OnValidate()
                        begin
                            if (AttendanceDateFrom <> 0D) and (AttendanceDateTo <> 0D) then
                                if AttendanceDateFrom > AttendanceDateTo then
                                    Error('From Date cannot be later than To Date.');
                        end;
                    }
                    field(AttendanceDateTo; AttendanceDateTo)
                    {
                        ApplicationArea = All;
                        Caption = 'Attendance Date To';
                        ToolTip = 'Specify the end date for the attendance report.';
                        trigger OnValidate()
                        begin
                            if (AttendanceDateFrom <> 0D) and (AttendanceDateTo <> 0D) then
                                if AttendanceDateTo < AttendanceDateFrom then
                                    Error('To Date cannot be earlier than From Date.');
                        end;
                    }
                }
                group(EmployeeFilters)
                {
                    Caption = 'Employee Filters';
                    field(EmployeeNoFilter; EmployeeNoFilter)
                    {
                        ApplicationArea = All;
                        TableRelation = Employee;
                        Caption = 'Employee No.';
                    }
                    field(ProvinceCodeFilter; ProvinceCodeFilter)
                    {
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Province), Blocked = filter(false));
                        ApplicationArea = All;
                        Caption = 'Province Code';
                    }
                    field(BranchCodeFilter; BranchCodeFilter)
                    {
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Branch), Blocked = filter(false));
                        ApplicationArea = All;
                        Caption = 'Branch Code';
                    }
                    field(DepartmentCodeFilter; DepartmentCodeFilter)
                    {
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Department), Blocked = filter(false));
                        ApplicationArea = All;
                        Caption = 'Department Code';
                    }
                    field(UnitCodeFilter; UnitCodeFilter)
                    {
                        TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Unit), Blocked = filter(false));
                        ApplicationArea = All;
                        Caption = 'Unit Code';
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
            GetCurrentEmployeeDeputation;
        end;
    }
    var
        EmployeeNoFilter: Code[20];
        ProvinceCodeFilter: Code[20];
        BranchCodeFilter: Code[20];
        DepartmentCodeFilter: Code[20];
        UnitCodeFilter: Code[20];
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
        AttendanceDateFilter: Text;
        ReportTitleLbl: Label 'Employee Attendance Report';
        HRMgt: Codeunit "HR Mgt.";

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

    local procedure GetCurrentEmployeeDeputation(): Code[20]
    var
        Employee: Record Employee;
        HRmgn: Codeunit "HR Mgt.";
    begin
        if not HrMgt.IsSaaS() then
            Employee.Get(HRmgn.GetEmployeeNo);
        if (Employee."Branch Code" <> '') and (employee."Deputation on" = Employee."Deputation on"::Branch) then
            BranchCodeFilter := employee."Branch Code";
        if (Employee."Province Code" <> '') and (employee."Deputation on" = Employee."Deputation on"::Province) then
            ProvinceCodeFilter := employee."Province Code";
        if (Employee."Department Code" <> '') and (employee."Deputation on" = Employee."Deputation on"::Department) then
            DepartmentCodeFilter := employee."Department Code";
    end;
}