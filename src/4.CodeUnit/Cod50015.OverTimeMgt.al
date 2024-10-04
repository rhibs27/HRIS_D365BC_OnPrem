codeunit 50015 "OverTime Mgt"
{
    procedure CheckApprovedOvertimeExists(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    var
        EmployeeActivity: Record "Employee Activity";
    begin
        EmployeeActivity.Reset;
        EmployeeActivity.SetRange("Employee No.", AllowanceAssignmentLine."Employee Code");
        EmployeeActivity.SetRange("Start Date", AllowanceAssignmentLine."From Date");
        EmployeeActivity.SetRange("Approval Status", EmployeeActivity."Approval Status"::Approved);
        EmployeeActivity.SetFilter("Actual Hours", '<>%1', 0);
        if EmployeeActivity.FindFirst then
            Error('Approved Overtime exists. You cannot choose this employee.');
    end;

    procedure CheckOvertimeEligibility(EmployeeActivity: Record "Employee Activity"; StartTime: Time; EndTime: Time; StandardWorkingHrs: Decimal; var TotalOTHrs: Decimal; var RejectionRemarks: Text): Boolean
    var
        Workshift: Record "Employee Work Shift";
        AttendanceLog: Record "Attendance Log";
        MorningOTHrs: Decimal;
        EveningOTHrs: Decimal;
        CheckInDifference: Decimal;
    begin
        HRSetup.Get;
        HRSetup.TestField("OT eligible hour");

        MorningOTHrs := 0;
        EveningOTHrs := 0;
        TotalOTHrs := 0;
        CheckInDifference := 0;

        AttendanceLog.Reset;
        AttendanceLog.SetRange("Employee ID", EmployeeActivity."Employee No.");
        AttendanceLog.SetRange(Date, EmployeeActivity."Start Date");
        if AttendanceLog.FindFirst then begin
            if (AttendanceLog."Check In Time" = 0T) or (AttendanceLog."Check Out Time" = 0T) then begin
                RejectionRemarks := 'System rejected. No punch in or punch out found.';
                exit(false);
            end;

            if LeaveMgt.GetNonWokingDays(EmployeeActivity."Start Date", EmployeeActivity."End Date", EmployeeActivity."Employee No.") = 0 then begin
                if AttendanceLog."Check Out Time" >= EndTime then begin
                    if (AttendanceLog."Check Out Time" - AttendanceLog."Check In Time") < StandardWorkingHrs then begin
                        RejectionRemarks := StrSubstNo('System rejected. Working hrs is less than %1 hrs.', StandardWorkingHrs);
                        exit(false);
                    end;

                    if (AttendanceLog."Check In Time" <> 0T) and (AttendanceLog."Check In Time" <= StartTime) then
                        MorningOTHrs := Round((StartTime - AttendanceLog."Check In Time") / 3600000, 1, '<');

                    if MorningOTHrs < HRSetup."OT eligible hour" then
                        MorningOTHrs := 0;

                    if (AttendanceLog."Check Out Time" <> 0T) and (AttendanceLog."Check Out Time" > EndTime) then
                        EveningOTHrs := Round((AttendanceLog."Check Out Time" - EndTime) / 3600000, 1, '<');

                    if AttendanceLog."Check In Time" > StartTime then begin
                        CheckInDifference := Round((AttendanceLog."Check In Time" - StartTime) / 3600000, 1, '<');
                        EveningOTHrs -= CheckInDifference;
                    end;

                    if EveningOTHrs < HRSetup."OT eligible hour" then
                        EveningOTHrs := 0;

                    TotalOTHrs := MorningOTHrs + EveningOTHrs;

                end else begin
                    RejectionRemarks := 'System rejected. Punch out does not exceed standard punch out time.';
                    exit(false);
                end;
            end else begin
                TotalOTHrs := (AttendanceLog."Check Out Time" - AttendanceLog."Check In Time") / 3600000;
                if TotalOTHrs < HRSetup."OT eligible hour" then
                    TotalOTHrs := 0;
            end;
        end else begin
            RejectionRemarks := 'System rejected. Attendance Log not found.';
            exit(false);
        end;

        if TotalOTHrs <> 0 then
            exit(true)
        else begin
            RejectionRemarks := 'System rejected. OT hours does not meet OT eligible hour.';
            exit(false);
        end;
    end;

    procedure AddOvertimeAttachment(EmpActNo: Code[20]; EmpNo: Code[20])
    var
        TempIncomingDoc: Record "Incoming Document";
        Employee: Record Employee;
        SalaryLevel: Record "Salary Level";
    begin
        Employee.Get(EmpNo);
        SalaryLevel.Get(Employee."Salary Level");
        if not SalaryLevel."OT Attachment Mandatory" then
            exit;

        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", EmpNo);
        TempIncomingDoc.SetRange("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::Overtime);
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.Find('-') then
            repeat
                if TempIncomingDoc."File Name" = '' then      //attachment mandatory for leave
                    Error('Attachment must be uploaded');
                TempIncomingDoc.Validate("No.", EmpActNo);
                TempIncomingDoc.Modify;
            until TempIncomingDoc.Next = 0;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        LeaveMgt: Codeunit "Leave Mgt.";



}
