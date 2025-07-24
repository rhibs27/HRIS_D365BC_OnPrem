report 50120 FiscalYearEndLeave
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            dataitem(Employee; Employee)
            {
                DataItemTableView = where(Status = const(Active), "Employment Type" = const(Permanent), "No." = filter(<> 'RN0710'));

                trigger OnAfterGetRecord()
                begin
                    Clear(AbsentDays);
                    //IF NOT (Employee."Employment Type" = Employee."Employment Type"::Permanent) THEN BEGIN
                    //ValidateForNonPermanentEmployee();
                    //END;
                    if Employee."Employment Type" = Employee."Employment Type"::Permanent then begin
                        ValidateEmployeeLeave();
                        //  BalanceYearLeavePermanentEmployee();
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PGSetup.Get;
                PGSetup.TestField("Payroll Fiscal Year Start Date");
                PGSetup.TestField("Payroll Fiscal Year End Date");
                HRSetup.Get();
            end;

            trigger OnPostDataItem()
            begin
                Message('Done');
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
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveEarn: Record "Leave Earn";
        PGSetup: Record "Payroll General Setup";
        AbsentDays: Integer;
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        EngNep: Record "English-Nepali Date";
        DocNo: Code[20];
        HRSetup: Record "Human Resources Setup";

    local procedure ValidateForNonPermanentEmployee()
    var
        LeaveTypeSetup: Record "Leave Type Setup";
        leavetypeSetup2: Record "Leave Type Setup";
    begin
        EmpAttendActivity.Reset;
        EmpAttendActivity.SetRange("Employee No.", Employee."No.");
        EmpAttendActivity.SetRange("Attendance Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        EmpAttendActivity.SetRange("Absent Day", 1);
        EmpAttendActivity.SetRange("Week Off Day", 0);
        EmpAttendActivity.SetRange("Leave Day", 0);
        EmpAttendActivity.SetRange("Present Day", 0);
        EmpAttendActivity.SetRange("Source No.", '');
        AbsentDays := EmpAttendActivity.Count;
        if AbsentDays <= 0 then
            exit;

        LeaveTypeSetup.Reset;
        LeaveTypeSetup.SetRange("Bereavement Leave", false);
        LeaveTypeSetup.SetFilter("Leave For Employee Type", '%1|%2', Employee."Employment Type", LeaveTypeSetup."Leave For Employee Type"::" ");
        LeaveTypeSetup.SetRange("Bereavement Leave", false);
        LeaveTypeSetup.SetRange("Skip Balance Check", false);
        LeaveTypeSetup.SetRange(Compensatory, false);
        LeaveTypeSetup.SetRange("Needed HR Permission", false);
        //LeaveTypeSetup.SETRANGE("Employee No. Filter",Employee."No.");
        if LeaveTypeSetup.FindFirst then
            repeat
                leavetypeSetup2.Reset;
                leavetypeSetup2.SetRange(Code, LeaveTypeSetup.Code);
                leavetypeSetup2.SetRange("Employee No. Filter", Employee."No.");
                leavetypeSetup2.FindFirst;
                leavetypeSetup2.CalcFields("Remaining Days");

                LeaveEarn.Init;
                LeaveEarn.Validate("Employee No.", Employee."No.");
                LeaveEarn.Validate("Leave Code", LeaveTypeSetup.Code);
                LeaveEarn.Validate("Posted Date", Today);
                if leavetypeSetup2."Remaining Days" >= AbsentDays then begin
                    LeaveEarn.Validate("Balancing Days", -AbsentDays);
                    exit;
                    //ELSE IF leavetypeSetup2."Remaining Days" < 0 THEN BEGIN
                    //break;
                end else begin
                    if leavetypeSetup2."Remaining Days" <= 0 then
                        exit;
                    LeaveEarn.Validate("Balancing Days", -leavetypeSetup2."Remaining Days");
                    AbsentDays := AbsentDays - LeaveTypeSetup."Remaining Days";
                    if AbsentDays <= 0 then
                        exit;
                end;
                LeaveEarn.Validate(Type, LeaveEarn.Type::"Balance via Fiscal Year");
                LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(Today));
                LeaveEarn.Validate(Remarks, 'Balance Fiscal Year');
                LeaveEarn."Entry No." := LeaveMgt.GetNextLeaveLedgerEntryNo();
                LeaveEarn.Insert(true);
            until LeaveTypeSetup.Next = 0;
    end;

    local procedure ValidateEmployeeLeave()
    var
        LeavetypSetup: Record "Leave Type Setup";
    begin

        PGSetup.Get;
        if Employee."Employment Type" = Employee."Employment Type"::Permanent then
            Employee.TestField("Confirmation Date");
        EngNep.Reset;
        EngNep.SetRange("English Date", Today + 1);
        if EngNep.FindFirst then;
        //UpdatePreviousYearleave;
        LeavetypSetup.Reset;
        LeavetypSetup.SetFilter("Leave For Employee Type", '%1|%2', Employee."Employment Type", LeavetypSetup."Leave For Employee Type"::" ");
        LeavetypSetup.SetFilter(Gender, '%1|%2', Employee.Gender, LeavetypSetup.Gender::" ");
        LeavetypSetup.SetFilter("Marital Status", '%1', Employee."Marital Status");
        LeavetypSetup.SetRange(Compensatory, false);
        //LeavetypSetup.SETRANGE("Needed HR Permission",FALSE);
        LeavetypSetup.SetRange("Skip Balance Check", false);
        LeavetypSetup.SetRange("AML Eligible", true);
        if LeavetypSetup.Find('-') then
            repeat
                Clear(LeaveEarn);
                LeaveEarn.SetRange("Leave Code", LeavetypSetup.Code);
                LeaveEarn.SetRange("Employee No.", Employee."No.");
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                if not LeavetypSetup."Services Period" then
                    LeaveEarn.SetRange("Fiscal year", EngNep."Fiscal Year");
                if not LeaveEarn.FindFirst then begin
                    LeaveEarn.Init;
                    LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                    LeaveEarn.Validate("Employee No.", Employee."No.");
                    LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
                    LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                    LeaveEarn.Validate("Posted Date", Today + 1);
                    LeaveEarn.Validate(Remarks, '2078/2079 Fisal Year earned.');
                    if LeavetypSetup."AML Eligible" then begin
                        if Employee."Confirmation Date" <= PGSetup."Payroll Fiscal Year Start Date" then begin
                            if not LeavetypSetup."Calculate Proratawise" then
                                LeaveEarn.Validate("Balancing Days", LeavetypSetup."Days Earned Per Year")
                            else
                                LeaveEarn.Validate("Balancing Days", LeaveMgt.CalculateProDataLeave(LeavetypSetup.Code, Employee."Confirmation Date"));
                            if LeaveEarn."Balancing Days" <> 0 then begin
                                LeaveEarn."Entry No." := LeaveMgt.GetNextLeaveLedgerEntryNo();
                                LeaveEarn.Insert(true);
                            end;
                        end;
                    end else begin
                        if not LeavetypSetup."Calculate Proratawise" then
                            LeaveEarn.Validate("Balancing Days", LeavetypSetup."Days Earned Per Year")
                        else
                            LeaveEarn.Validate("Balancing Days", LeaveMgt.CalculateProDataLeave(LeavetypSetup.Code, Employee."Employment Date"));
                        if LeaveEarn."Balancing Days" <> 0 then begin
                            LeaveEarn."Entry No." := LeaveMgt.GetNextLeaveLedgerEntryNo();
                            LeaveEarn.Insert(true);
                        end;
                    end;
                end;
            until LeavetypSetup.Next = 0;
    end;

    local procedure BalanceYearLeavePermanentEmployee()
    var
        LeaveTypeSetup: Record "Leave Type Setup";
        leavetypeSetup2: Record "Leave Type Setup";
    begin
        LeaveTypeSetup.Reset;
        LeaveTypeSetup.SetRange("Bereavement Leave", false);
        LeaveTypeSetup.SetFilter("Leave For Employee Type", '%1|%2', Employee."Employment Type", LeaveTypeSetup."Leave For Employee Type"::" ");
        LeaveTypeSetup.SetFilter(Gender, '%1|%2', Employee.Gender, LeaveTypeSetup.Gender::" ");
        LeaveTypeSetup.SetRange("Bereavement Leave", false);
        LeaveTypeSetup.SetRange("Skip Balance Check", false);
        LeaveTypeSetup.SetRange(Compensatory, false);
        LeaveTypeSetup.SetRange("Needed HR Permission", false);
        //LeaveTypeSetup.SETRANGE("Employee No. Filter",Employee."No.");
        if LeaveTypeSetup.FindFirst then
            repeat
                leavetypeSetup2.Reset;
                leavetypeSetup2.SetRange(Code, LeaveTypeSetup.Code);
                leavetypeSetup2.SetRange("Employee No. Filter", Employee."No.");
                leavetypeSetup2.FindFirst;
                leavetypeSetup2.CalcFields("Remaining Days");
                if leavetypeSetup2."Remaining Days" < 0 then
                    break;
                LeaveEarn.Init;
                LeaveEarn.Validate("Employee No.", Employee."No.");
                LeaveEarn.Validate("Leave Code", LeaveTypeSetup.Code);
                LeaveEarn.Validate("Posted Date", Today);
                LeaveEarn.Validate("Balancing Days", -leavetypeSetup2."Remaining Days");
                LeaveEarn.Validate(Type, LeaveEarn.Type::"Balance via Fiscal Year");
                LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(Today));
                LeaveEarn.Validate(Remarks, 'Balance Fiscal Year Permanent Employee');
                LeaveEarn."Entry No." := LeaveMgt.GetNextLeaveLedgerEntryNo();
                LeaveEarn.Insert(true);
            until LeaveTypeSetup.Next = 0;
    end;
}
