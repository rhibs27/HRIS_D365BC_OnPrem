codeunit 50026 "Attendance Mgt"
{
    //this is used from company specific extension

    procedure TextToDuration(InputText: Text): Duration
    var
        Millisec: BigInteger;
    begin
        if not Evaluate(Millisec, InputText) then
            exit;

        exit(Millisec * 3600000); // Convert milliseconds to duration
    end;

    procedure DailyAttendanceUpdate(StartDate: Date; EndDate: Date; EmployeeNo: Code[20]): Boolean
    var
        ProcessDailyAttendance: Report "Process Daily Attendance";
        Employee: Record Employee;
    begin
        Employee.SetRange("No.", EmployeeNo);
        Employee.SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
        ProcessDailyAttendance.SetTableView(Employee);
        ProcessDailyAttendance.UseRequestPage(false);
        ProcessDailyAttendance.Run();
        exit(true);
    end;

    procedure GetPresentDays(EmpCode: Code[20]; PStartDate: Date; PEndDate: Date): Decimal
    var
        EmpAtt: Record "Employee Attendance & Activity";
        actualPresentDays: Decimal;
        AttendanceDate: Date;
    begin
        actualPresentDays := 0;
        Clear(AttendanceDate);
        EmpAtt.Reset();
        EmpAtt.SetRange("Employee No.", EmpCode);
        EmpAtt.SetRange("Attendance Date", PStartDate, PEndDate);
        EmpAtt.CalcSums("Present Day", "Week Off Day", "Tour Day", "Training Day", "Leave Day");
        actualPresentDays := EmpAtt."Present Day" + EmpAtt."Week Off Day" + EmpAtt."Tour Day" + EmpAtt."Training Day" + EmpAtt."Leave Day";
        exit(actualPresentDays);
    end;

    procedure CheckOverNightShift(WorkShiftCode: Code[20]): Boolean
    var
        EmployeeWorkShift: Record "Employee Work Shift";
    begin
        if EmployeeWorkShift.Get(WorkShiftCode) then begin
            if EmployeeWorkShift.OverNight then
                exit(true)
        end;
    end;

    procedure ApproveLateAttendance(docNo: Code[20])
    var
        EmpAttenActivity: Record "Employee Attendance & Activity";
        AttenMissed: Record "Attendance Missed";
    begin
        AttenMissed.Get(docNo);
        if AttenMissed.Type <> AttenMissed.Type::"Late Attendance" then
            exit;

        if DailyAttendanceUpdate(AttenMissed."Start Date", AttenMissed."Start Date", AttenMissed."Employee No.") then begin
            EmpAttenActivity.SetRange("Employee No.", AttenMissed."Employee No.");
            EmpAttenActivity.SetRange("Attendance Date", AttenMissed."Start Date");
            if EmpAttenActivity.FindSet() then
                EmpAttenActivity.ModifyAll("Late Remarks", AttenMissed.Remarks);
        end;
    end;

    procedure CheckEmployeePresent(EmpCode: Code[20]; AttendanceDate: Date): Boolean
    var
        EmpAtt: Record "Employee Attendance & Activity";
    begin
        EmpAtt.Reset();
        EmpAtt.SetRange("Employee No.", EmpCode);
        EmpAtt.SetRange("Attendance Date", AttendanceDate);
        if EmpAtt.FindFirst() then
            if EmpAtt."Present Day" <> 0 then
                exit(true);
    end;

    var
        AttendanceLog: Record "Attendance Log";
        EngNep: Record "English-Nepali Date";
        CalendarDescription: Text;
        Employee: Record Employee;

}
