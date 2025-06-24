report 50148 "Late Employees Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50148.LateEmployeesReport.rdl';
    ApplicationArea = All;
    Caption = 'Late Employees Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(EmployeeAttendanceActivity; "Employee Attendance & Activity")
        {
            RequestFilterFields = "Employee No.", "Attendance Date";

            column(EmployeeNo; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(CheckInTime; format("Check In Time")) { }
            column(CheckOutTime; Format("Check Out Time")) { }
            column(ShiftStartTime; Format("Shift Start Time")) { }
            column(ShiftEndTime; Format("Shift End Time")) { }
            column(ActualHoursWorked; ActualHoursWorked) { }
            column(LateByMinutes; LateByMinutes) { }
            column(EarlyOutByMinutes; EarlyOutByMinutes) { }
            column(BranchCode; BranchCode) { }
            column(ProvinceCode; ProvinceCode) { }
            column(DepartmentCode; DepartmentCode) { }
            column(Designation; Designation) { }
            column(AttendanceDate; "Attendance Date") { }
            column(Month; Month) { }
            column(LateApprovalDocNo; LateDocNo) { }
            column(Remarks; attendancemissed.Remarks) { }

            trigger OnPreDataItem()
            begin

                SetRange("Attendance Date", AttendanceDateFrom, AttendanceDateTo);


                SetFilter("Check In Time", '<>%1', 0T);
                SetFilter("Shift Start Time", '<>%1', 0T);
            end;

            trigger OnAfterGetRecord()
            var
                DurationTemp: Duration;
                Hours: Integer;
                Minutes: Integer;
                Seconds: Integer;
                CheckInDateTime: DateTime;
                CheckOutDateTime: DateTime;
                Employee: Record Employee;
            begin

                if not (("Check In Time" <> 0T) and ("Shift Start Time" <> 0T) and ("Check In Time" > "Shift Start Time")) then
                    CurrReport.Skip();

                ActualHoursWorked := '';
                LateByMinutes := '';
                EarlyOutByMinutes := '';
                BranchCode := '';
                ProvinceCode := '';
                DepartmentCode := '';
                Designation := '';


                if Employee.Get("Employee No.") then begin
                    BranchCode := Employee."Branch Code";
                    ProvinceCode := Employee."Province Code";
                    DepartmentCode := Employee."Department Code";
                    Designation := Employee."Job Title";
                end;

                if ("Check In Time" <> 0T) and ("Check Out Time" <> 0T) then begin
                    CheckInDateTime := CreateDateTime("Attendance Date", "Check In Time");
                    if "Check Out Time" < "Check In Time" then
                        CheckOutDateTime := CreateDateTime("Attendance Date" + 1, "Check Out Time")
                    else
                        CheckOutDateTime := CreateDateTime("Attendance Date", "Check Out Time");

                    DurationTemp := CheckOutDateTime - CheckInDateTime;

                    if DurationTemp > 86400000 then
                        DurationTemp := 86400000;

                    Hours := DurationTemp DIV 3600000;
                    Minutes := (DurationTemp MOD 3600000) DIV 60000;
                    Seconds := (DurationTemp MOD 60000) DIV 1000;

                    ActualHoursWorked := StrSubstNo('%1:%2:%3',
                        Format(Hours, 0, '<Integer,2><Filler Character,0>'),
                        Format(Minutes, 0, '<Integer,2><Filler Character,0>'),
                        Format(Seconds, 0, '<Integer,2><Filler Character,0>')
                    );
                end;

                if ("Check In Time" <> 0T) and ("Shift Start Time" <> 0T) and ("Check In Time" > "Shift Start Time") then begin
                    DurationTemp := "Check In Time" - "Shift Start Time";
                    Hours := DurationTemp DIV 3600000;
                    Minutes := (DurationTemp MOD 3600000) DIV 60000;
                    Seconds := (DurationTemp MOD 60000) DIV 1000;

                    LateByMinutes := StrSubstNo('%1:%2:%3',
                        Format(Hours, 0, '<Integer,2><Filler Character,0>'),
                        Format(Minutes, 0, '<Integer,2><Filler Character,0>'),
                        Format(Seconds, 0, '<Integer,2><Filler Character,0>')
                    );
                end;

                if ("Check Out Time" <> 0T) and ("Shift End Time" <> 0T) then begin
                    if ("Check Out Time" < "Check In Time") then begin
                        EarlyOutByMinutes := '';
                    end else if ("Check Out Time" < "Shift End Time") then begin
                        DurationTemp := "Shift End Time" - "Check Out Time";
                        Hours := DurationTemp DIV 3600000;
                        Minutes := (DurationTemp MOD 3600000) DIV 60000;
                        Seconds := (DurationTemp MOD 60000) DIV 1000;
                        if Hours < 24 then begin
                            EarlyOutByMinutes := StrSubstNo('%1:%2:%3',
                                Format(Hours, 0, '<Integer,2><Filler Character,0>'),
                                Format(Minutes, 0, '<Integer,2><Filler Character,0>'),
                                Format(Seconds, 0, '<Integer,2><Filler Character,0>')
                            );
                        end else begin
                            EarlyOutByMinutes := '';
                        end;
                    end;
                end;

                if "Attendance Date" <> 0D then
                    Month := Format("Attendance Date", 0, '<Month Text>');

                AttendanceMissed.Reset();
                AttendanceMissed.SetRange(Type, AttendanceMissed.Type::"Late Attendance");
                AttendanceMissed.SetRange("Start Date", "Attendance Date");
                AttendanceMissed.SetRange("Employee No.", EmployeeAttendanceActivity."Employee No.");
                if AttendanceMissed.FindFirst() then
                    LateDocNo := AttendanceMissed."No."
                else
                    LateDocNo := '';


            end;
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
                    Caption = 'Date Range Filter';
                    field(AttendanceDateFrom; AttendanceDateFrom)
                    {
                        ApplicationArea = All;
                        Caption = 'Attendance Date From';
                        ToolTip = 'Select the start date for the attendance report';
                        ShowMandatory = true;
                    }
                    field(AttendanceDateTo; AttendanceDateTo)
                    {
                        ApplicationArea = All;
                        Caption = 'Attendance Date To';
                        ToolTip = 'Select the end date for the attendance report';
                        ShowMandatory = true;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }

        trigger OnOpenPage()
        begin

            AttendanceDateFrom := CalcDate('<-CM>', Today);
            AttendanceDateTo := CalcDate('<CM>', Today);
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin

            if (AttendanceDateFrom = 0D) or (AttendanceDateTo = 0D) then begin
                Message('Please select both Attendance Date From and Attendance Date To.');
                exit(false);
            end;


            if AttendanceDateFrom > AttendanceDateTo then begin
                Message('Attendance Date From cannot be greater than Attendance Date To.');
                exit(false);
            end;

            exit(true);
        end;
    }

    var
        ActualHoursWorked: Text[20];
        LateByMinutes: Text[20];
        EarlyOutByMinutes: Text[20];
        Month: Text[20];
        AttendanceDateFrom: Date;
        AttendanceDateTo: Date;
        BranchCode: Code[20];
        ProvinceCode: Code[20];
        DepartmentCode: Code[20];
        Designation: Text[50];
        AttendanceMissed: Record "Attendance Missed";
        LateDocNo: Code[20];

}