report 50146 "Attendance Update"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                if "Employment Date" = 0D then
                    CurrReport.Skip;
                InsertAttendanceLine;
            end;
        }
    }
    trigger OnPreReport()
    begin
        AttendanceSetup.Get;
        // DocNo := NoSeriesMgt.GetNextNo(AttendanceSetup."Attendance Line No. Series", Today, true);
    end;

    Var
        AttendanceSetUp: Record "Attendance Setup";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        AttendanceLog: Record "Attendance Log";
        AttendanceLine: Record "Attendance Line";
        DocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        WorkShift: Record "Employee Work Shift";
        HrMgt: Codeunit "HR Mgt.";
        StartTime, EndTime : time;
        CalendarDescription: text;


    local procedure InsertAttendanceLine()
    var
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        Clear(AttendanceLine);
        WorkShift.get(Employee."Employee Work Shift");
        Workshift.TestField("Start Time");
        Workshift.TestField("End Time");
        Workshift.TestField("Friday End Time");
        Workshift.TestField("Winter Start Date");
        Workshift.TestField("Winter End Date");
        Workshift.TestField("Winter End Time");
        StartTime := 0T;
        EndTime := 0T;
        StartTime := WorkShift."Start Time";
        if HRMgt.IsWinter(Today, Workshift) then begin
            if HRMgt.IsFriday(Today) then
                EndTime := WorkShift."Friday End Time"
            else
                EndTime := WorkShift."Winter End Time";
        end else begin
            if HRMgt.IsFriday(Today) then
                EndTime := WorkShift."Friday End Time"
            else
                EndTime := WorkShift."End Time";
        end;
        // AttendanceLine.Reset;
        // AttendanceLine.SetRange("Employee No.", Employee."No.");
        // AttendanceLine.SetRange("Attendance Date", Today);
        // if not AttendanceLine.FindFirst then begin
        //     AttendanceLine.Init;
        //     AttendanceLine."Document No." := DocNo;
        //     AttendanceLine."Employee No." := Employee."No.";
        //     AttendanceLine.Validate("Employee Working Shift", Employee."Employee Work Shift");
        //     AttendanceLine."Attendance Date" := Today;
        //     // AttendanceLine.CopyFromAttendanceHeader(AttendanceHeader);
        //     AttendanceLine.Insert(false);
        // end;

        // AttendanceLog.Reset;
        // AttendanceLog.SetRange(Date, Today);
        // AttendanceLog.SetRange("Employee ID", AttendanceLine."Employee No.");
        // if AttendanceLog.FindFirst then begin
        //     AttendanceLine.Validate("Check In Time", AttendanceLog."Check In Time");
        //     if (AttendanceLine."Check In Time" <> 0T) then begin
        //         AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
        //         AttendanceLine.Validate("Present Day", 1);
        //         AttendanceLine.Modify();
        //     end;
        // end;

        // if (AttendanceSetUp."Check Out From") > Time() then begin
        //     AttendanceLog.Reset;
        //     AttendanceLog.SetRange(Date, Today);
        //     AttendanceLog.SetRange("Employee ID", AttendanceLine."Employee No.");
        //     if AttendanceLog.Findlast then begin
        //         AttendanceLine.Validate("Check Out Time", AttendanceLog."Check In Time");
        //         if (AttendanceLine."Check In Time" <> 0T) then begin
        //             AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
        //             AttendanceLine.Validate("Present Day", 1);
        //             AttendanceLine.Modify();
        //         end;
        //     end;
        // end;
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.get(Employee."No.", Today);
        if not EmployeeAttendanceActivity.FindFirst then begin
            EmployeeAttendanceActivity.Init;
            EmployeeAttendanceActivity."Employee No." := Employee."No.";
            EmployeeAttendanceActivity."Attendance Date" := Today;
            EmployeeAttendanceActivity."Shift Start Time" := StartTime;
            EmployeeAttendanceActivity."Shift End Time" := EndTime;
            if IsHoliday(Today, '') then begin
                EmployeeAttendanceActivity."Day Type" := AttendanceLine."Day Type"::Holiday;
                EmployeeAttendanceActivity."Week Off Day" := 1;
                EmployeeAttendanceActivity."Holiday Remarks" := CalendarDescription;
            end else begin
                EmployeeAttendanceActivity."Day Type" := AttendanceLine."Day Type"::"Working Day";
                EmployeeAttendanceActivity."Holiday Remarks" := '';
                EmployeeAttendanceActivity."Week Off Day" := 0;
            end;
            EmployeeAttendanceActivity.Validate("Employee Working Shift", Employee."Employee Work Shift");
            EmployeeAttendanceActivity.Insert();
        end;

        AttendanceLog.Reset;
        AttendanceLog.SetLoadFields(Date, "Employee ID", "Log Time");
        AttendanceLog.SetRange(Date, Today);
        AttendanceLog.SetRange("Employee ID", AttendanceLine."Employee No.");
        if AttendanceLog.FindFirst then begin
            AttendanceLine.Validate("Check In Time", AttendanceLog."Log Time");
            if (AttendanceLine."Check In Time" <> 0T) then begin
                AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
                AttendanceLine.Validate("Present Day", 1);
                AttendanceLine.Modify();
            end;
        end;

        // if (AttendanceSetUp."Check Out From") > Time() then begin
        //     AttendanceLog.Reset;
        //     AttendanceLog.SetRange(Date, Today);
        //     AttendanceLog.SetRange("Employee ID", AttendanceLine."Employee No.");
        //     if AttendanceLog.Findlast then begin
        //         AttendanceLine.Validate("Check Out Time", AttendanceLog."Log Time");
        //         if (AttendanceLine."Check In Time" <> 0T) then begin
        //             AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
        //             AttendanceLine.Validate("Present Day", 1);
        //             AttendanceLine.Modify();
        //         end;
        //     end;
        // end;
    end;

    local procedure IsHoliday(Date: Date; Remarks: Text[100]): Boolean
    var
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        RetrunBool: Boolean;
    begin
        RetrunBool := false;
        Clear(CalendarDescription);
        RetrunBool := LeaveMgt.GetNonWorkingDays(Today, Today, Employee."No.") <> 0;
        CalendarDescription := HRMgt.ReturnCalendarDescription;
        exit(RetrunBool);
    end;

}
// AttendanceLog.Reset;
// AttendanceLog.SetRange(Date, Today);
// AttendanceLog.SetRange("Employee ID", Employee."No.");
// if AttendanceLog.FindFirst then
//     if EmployeeAttendanceActivity.Get(Employee."No.", Today) then begin
//         EmployeeAttendanceActivity.Validate("Check In Time", AttendanceLog."Check In Time");
//         EmployeeAttendanceActivity.Validate("Present Day", 1);
//         EmployeeAttendanceActivity.modify()
//     end else begin
//         EmployeeAttendanceActivity.Init();
//         EmployeeAttendanceActivity.Validate("Check In Time", AttendanceLog."Check In Time");
//         EmployeeAttendanceActivity.Validate("Present Day", 1);
//         EmployeeAttendanceActivity.modify()
//         if AttendanceLine.FindSet then
//             repeat
//                 Clear(EmployeeAttendanceActivity);
//                 EmployeeAttendanceActivity.TransferFields(AttendanceLine);
//                 EmployeeAttendanceActivity."Created Datetime" := CurrentDateTime;
//                 EmployeeAttendanceActivity.Insert;
//             until AttendanceLine.Next = 0;
//     end;



//     // to get Checkout time
//     if EmployeeAttendanceActivity.Get(Employee."No.", InitialDate) then
//         if not EmployeeAttendanceActivity."Attendance Update" then begin
//             AttendanceLog.Reset;
//             AttendanceLog.SetRange(Date, InitialDate);
//             AttendanceLog.SetRange("Employee ID", AttendanceLine."Employee No.");
//             if AttendanceLog.Findlast then begin
//                 AttendanceLine.Validate("Check Out Time", AttendanceLog."Check Out Time");
//             end;
//         end;
//     EngNep.Reset; //Min 1.25.2023
//     EngNep.SetRange("English Date", InitialDate);
//     if EngNep.FindFirst then
//         AttendanceLine.Week := EngNep.Week;
//     AttendanceLine.Modify(false);

//     PayrollEngine.PrepareEmployeeDailyActivity(AttendanceLine."Employee No.", InitialDate, InitialDate, true);

//     ChangeStatusToApproveFromHold;
// end;

