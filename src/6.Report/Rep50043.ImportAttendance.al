report 50043 "Import Attendance"
{
    // version ATM19.01.01

    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(FilteredEmployee; Employee)
        {
            DataItemTableView = where("NAV Login ID" = filter(<> ''), Settled = const(false));

            trigger OnAfterGetRecord()
            begin

                ImportEmployee;
            end;

            trigger OnPostDataItem()
            begin
                ISV_ONAFTERPOSTREPORT(AttendanceHeader);
                ProgressWindow.Close;
            end;

            trigger OnPreDataItem()
            begin
                ProgressWindow.Open(Text000);

                GetSetup;
                DeleteAttendanceDetails;
                if AttendanceType = AttendanceType::General then
                    FilteredEmployee.SetFilter("Employment Type", '%1|%2', FilteredEmployee."Employment Type"::Permanent, FilteredEmployee."Employment Type"::Probation)
                else begin
                    FilteredEmployee.SetRange("Employment Type", FilteredEmployee."Employment Type"::Contract);
                    PGSetup.Get;
                    // FilteredEmployee.SETFILTER("Contract Expiry Date",'>%1',PGSetup."Payroll Fiscal Year Start Date");
                    FilteredEmployee.SetRange(Status, FilteredEmployee.Status::Active);
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout { }

        actions { }

        trigger OnOpenPage()
        begin
            if AttendanceHeader."Global Dimension 1 Code" <> '' then
                FilteredEmployee.SetFilter("Global Dimension 1 Code", AttendanceHeader."Global Dimension 1 Code");
            if AttendanceHeader."Global Dimension 2 Code" <> '' then
                FilteredEmployee.SetFilter("Global Dimension 2 Code", AttendanceHeader."Global Dimension 2 Code");
        end;
    }

    labels { }

    var
        Text000: Label '#1############### of #2###############';
        AttendanceSetup: Record "Attendance Setup";
        AttendanceHeader: Record "Attendance Header";
        AttendanceLine: Record "Attendance Line";
        AttendanceSummary: Record "Attendance Summary";
        ProgressWindow: Dialog;
        AttendanceType: Option General,Contract;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
        EndDate: Date;
        PayCyclPeriod: Record "Pay Cycle Period";
        PGSetup: Record "Payroll General Setup";

    local procedure DeleteAttendanceDetails()
    begin
        /*AttendanceLine.RESET;
        AttendanceLine.SETRANGE("Document No.",AttendanceHeader."No.");
        AttendanceLine.DELETEALL;
        */
        AttendanceSummary.Reset;
        AttendanceSummary.SetRange("Document No.", AttendanceHeader."No.");
        AttendanceSummary.DeleteAll;
    end;

    local procedure GetSetup()
    begin
        AttendanceSetup.Get;
        AttendanceSetup.TestField("Base Calender");
    end;

    procedure ImportEmployee()
    var
        PayrollEngine: Codeunit "Payroll Engine";
        Date: Record Date;
        Employee: Record Employee;
    begin
        Clear(PayrollEngine);
        if PayrollEngine.IsValidEmployee(FilteredEmployee, AttendanceHeader."From Date", AttendanceHeader."To Date") then begin
            EndDate := AttendanceHeader."To Date";
            if AttendanceHeader.Type = AttendanceHeader.Type::Permanent then begin
                PayCyclPeriod.Reset;
                PayCyclPeriod.SetRange("Pay Cycle Code", AttendanceHeader."Pay Cycle Code");
                PayCyclPeriod.SetRange("Pay Cycle Term", AttendanceHeader."Pay Cycle Term");
                PayCyclPeriod.SetRange(Period, AttendanceHeader."Pay Cycle Period");
                if PayCyclPeriod.FindFirst then begin
                    PayCyclPeriod.TestField("Pay Date");
                    EndDate := PayCyclPeriod."Pay Date";
                end;
            end;

            Date.Reset;
            Date.SetRange("Period Type", Date."Period Type"::Date);
            Date.SetFilter("Period Start", '%1..%2', AttendanceHeader."From Date", Today);
            if Date.FindSet then
                repeat
                    EmpAttendanceActivity.Reset;
                    EmpAttendanceActivity.SetRange("Employee No.", FilteredEmployee."No.");
                    EmpAttendanceActivity.SetRange("Attendance Date", Date."Period Start");
                    if Date."Period Start" >= FilteredEmployee."Employment Date" then begin
                        if not EmpAttendanceActivity.FindFirst then begin
                            Clear(AttendanceLine);
                            AttendanceLine.Reset;
                            AttendanceLine.SetRange("Employee No.", FilteredEmployee."No.");
                            AttendanceLine.SetRange("Attendance Date", Date."Period Start");
                            if not AttendanceLine.FindFirst then begin
                                AttendanceLine.Init;
                                AttendanceLine."Document No." := AttendanceHeader."No.";
                                AttendanceLine."Employee No." := FilteredEmployee."No.";
                                AttendanceLine.Validate("Employee Working Shift", Employee."Employee Work Shift");
                                AttendanceLine."Attendance Date" := Date."Period Start";
                                //AttendanceLine.CopyFromAttendanceHeader(AttendanceHeader);

                                AttendanceLine.Insert(false);
                            end;
                            PayrollEngine.PrepareEmployeeDailyActivity(FilteredEmployee."No.", Date."Period Start", Date."Period Start", true);
                        end;
                    end;
                until Date.Next = 0;

            Clear(AttendanceSummary);
            AttendanceSummary.Init;
            AttendanceSummary."Document No." := AttendanceHeader."No.";
            AttendanceSummary."Employee No." := FilteredEmployee."No.";
            AttendanceSummary."Employee Name" := FilteredEmployee."First Name" + ' ' + FilteredEmployee."Middle Name" + ' ' + FilteredEmployee."Last Name";
            AttendanceSummary.CopyFromAttendanceHeader(AttendanceHeader);
            AttendanceSummary.Insert(true);
            /* Date.RESET;
             Date.SETRANGE("Period Type",Date."Period Type"::Date);
             Date.SETFILTER("Period Start",'%1..%2',"From Date","To Date");
             IF Date.FINDSET THEN REPEAT
               CLEAR(AttendanceLine);
               AttendanceLine.INIT;
               AttendanceLine."Document No." := "No.";
               AttendanceLine."Employee No." := FilteredEmployee."No.";
               //UTS1.00
               Employee.GET(AttendanceLine."Employee No.");
               Employee.TESTFIELD("Employee Work Shift");
               AttendanceLine.VALIDATE("Employee Working Shift",Employee."Employee Work Shift");
               //UTS1.00
               AttendanceLine."Attendance Date" := Date."Period Start";
               AttendanceLine.CopyFromAttendanceHeader(AttendanceHeader);
               IF IsHoliday(Date."Period Start",AttendanceLine.Remarks) THEN BEGIN
                 AttendanceLine."Day Type" := AttendanceLine."Day Type"::Holiday;
                 AttendanceLine."Week Off Day" := 1;
               END;
               AttendanceLine.INSERT(TRUE);

               AttendanceLog.RESET;
               AttendanceLog.SETRANGE(Date,Date."Period Start");
               AttendanceLog.SETRANGE("Employee ID",AttendanceLine."Employee No.");
               IF AttendanceLog.FINDSET THEN BEGIN
                 REPEAT
                  IF AttendanceLine."Check In Time" = 0T THEN
                   AttendanceLine.VALIDATE("Check In Time",AttendanceLog."Check In Time");
                  IF AttendanceLine."Check In Time" <> 0T THEN
                    AttendanceLine.VALIDATE("Check Out Time",AttendanceLog.Time);
                  IF (AttendanceLine."Check In Time" <> 0T) AND (AttendanceLine."Check Out Time" <> 0T) AND
                   (AttendanceLine."Day Type" <> AttendanceLine."Day Type"::Holiday) THEN BEGIN
                    AttendanceLine."Day Type" := AttendanceLine."Day Type"::"Working Day";
                    AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
                    AttendanceLine.VALIDATE("Present Day",1);
                  END ELSE BEGIN
                   AttendanceLine."Day Type" := AttendanceLine."Day Type"::"Working Day";
                   AttendanceLine.VALIDATE("Present Day",0);
                   //AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Absent;
                   //AttendanceLine."Absent Day" := 1;
                  END;
                  AttendanceLine.MODIFY(TRUE);
                  PayrollEngine.PrepareEmployeeDailyActivity(AttendanceLine."Employee No.",AttendanceHeader."From Date",AttendanceHeader."To Date",TRUE);
                 UNTIL AttendanceLog.NEXT = 0;
               END;
               LineNo += 10000;
             UNTIL Date.NEXT = 0;*/
        end;
    end;

    local procedure IsHoliday(Date: Date; Remarks: Text[100]): Boolean
    begin
        //EXIT(CalendarMgmt.CheckDateStatus(AttendanceSetup."Base Calender",Date,Remarks,'',0));
    end;

    procedure SetAttendanceDocument(var NewAttendanceHeader: Record "Attendance Header")
    begin
        AttendanceHeader := NewAttendanceHeader;

        AttendanceHeader.TestField("From Date");
        AttendanceHeader.TestField("To Date");
        AttendanceHeader.TestField("Pay Cycle Code");
        AttendanceHeader.TestField("Pay Cycle Term");
        AttendanceHeader.TestField("Pay Cycle Period");
        AttendanceType := NewAttendanceHeader.Type;
    end;

    [IntegrationEvent(true, true)]
    procedure ISV_ONAFTERPOSTREPORT(var NewAttendanceHeader: Record "Attendance Header")
    begin
    end;
}
