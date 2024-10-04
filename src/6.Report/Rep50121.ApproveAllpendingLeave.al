report 50121 ApproveAllpendingLeave
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where(Status = const(Active), "Employment Type" = filter(Contract | Probation | Permanent));

            trigger OnAfterGetRecord()
            begin
                //CreateBalanceDays();
                //Redo();
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        Message('Done');
    end;

    trigger OnPreReport()
    begin
        PGSetup.Get();
    end;

    var
        EmpAttendActivity: Record "Employee Attendance & Activity";
        PGSetup: Record "Payroll General Setup";
        LeaveEarn: Record "Leave Earn";
        BalanceDays: Decimal;

    local procedure CreateBalanceDays()
    begin
        Clear(BalanceDays);
        LeaveEarn.Reset();
        LeaveEarn.SetRange(EmpNo, Employee."No.");
        LeaveEarn.SetRange(Type, LeaveEarn.Type::"Balance via Fiscal Year");
        LeaveEarn.CalcSums("Balancing Days");
        BalanceDays := Abs(LeaveEarn."Balancing Days");
        EmpAttendActivity.Reset;
        EmpAttendActivity.SetRange("Employee No.", Employee."No.");
        EmpAttendActivity.SetRange("Attendance Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        EmpAttendActivity.SetRange("Absent Day", 1);
        EmpAttendActivity.SetRange("Week Off Day", 0);
        EmpAttendActivity.SetRange("Leave Day", 0);
        EmpAttendActivity.SetRange("Present Day", 0);
        EmpAttendActivity.SetRange("Source No.", '');
        if EmpAttendActivity.Find('-') then
            repeat
                EmpAttendActivity."Leave Day" := 1;
                if BalanceDays > 0 then begin
                    EmpAttendActivity."Present Day" := 1;
                    EmpAttendActivity."Absent Day" := 0;
                end;
                EmpAttendActivity."Late Remarks" := 'Fiscal year end balancing.';
                EmpAttendActivity.Modify;
                BalanceDays := BalanceDays - 1;
            until EmpAttendActivity.Next = 0;
    end;

    local procedure Redo()
    begin
        EmpAttendActivity.Reset;
        EmpAttendActivity.SetRange("Late Remarks", 'Fiscal year end balancing.');
        EmpAttendActivity.SetRange("Employee No.", Employee."No.");
        if EmpAttendActivity.Find('-') then
            repeat
                EmpAttendActivity."Absent Day" := 1;
                EmpAttendActivity."Leave Day" := 0;
                EmpAttendActivity."Present Day" := 0;
                EmpAttendActivity.Modify;
            until EmpAttendActivity.Next = 0;
    end;
}
