tableextension 50027 "Accounting Period Ext" extends "Accounting Period"
{
    fields
    {
        field(50001; "Nepali Month"; Enum "Nepali Month")
        {

        }
        field(50002; "New Leave Year"; Boolean)
        {
            DataClassification = AccountData;
            Caption = 'New Leave Year';
            trigger OnValidate()
            begin
                if "Leave Year Closed" then
                    Error('A leave period of closed leave year cannot be modified.');
            end;
        }
        field(50003; "Leave Year Closed"; Boolean)
        {
            DataClassification = AccountData;
            Caption = 'Leave Year Closed';
        }
    }
    procedure GetLeaveYearStartDate(ForDate: Date): Date;
    var
        LeavePeriod: Record "Accounting Period";

    begin
        LeavePeriod.Reset();
        LeavePeriod.SetRange("New Leave Year", true);
        LeavePeriod.SetFilter("Starting Date", '<=%1', ForDate);
        LeavePeriod.FindLast();
        exit(LeavePeriod."Starting Date");
    end;

    procedure GetLeaveYearEndDate(ForDate: Date): Date;
    var
        LeavePeriod: Record "Accounting Period";

    begin
        LeavePeriod.Reset();
        LeavePeriod.SetRange("New Leave Year", true);
        LeavePeriod.SetFilter("Starting Date", '>%1', ForDate);
        LeavePeriod.FindFirst();
        exit(LeavePeriod."Starting Date" - 1);
    end;

    procedure GetCurrentLeaveYearStartDate(): Date;
    var
        LeavePeriod: Record "Accounting Period";
    begin
        // LeavePeriod.Reset();
        // LeavePeriod.SetRange("New Leave Year", true);
        // LeavePeriod.SetRange("Leave Year Closed", false);
        // LeavePeriod.FindFirst();
        // exit(LeavePeriod."Starting Date");
        LeavePeriod.Reset();
        LeavePeriod.SetRange("New Leave Year", true);
        LeavePeriod.SetFilter("Starting Date", '<=%1', WorkDate());
        LeavePeriod.FindLast();
        exit(LeavePeriod."Starting Date");
    end;

    procedure GetCurrentLeaveYearEndDate(): Date;
    var
        LeavePeriod: Record "Accounting Period";
    begin
        // LeavePeriod.Reset();
        // LeavePeriod.SetRange("New Leave Year", true);
        // LeavePeriod.SetRange("Leave Year Closed", false);
        // LeavePeriod.FindFirst();
        // LeavePeriod.Next();
        // exit(LeavePeriod."Starting Date" - 1);
        LeavePeriod.Reset();
        LeavePeriod.SetRange("New Leave Year", true);
        LeavePeriod.SetFilter("Starting Date", '>%1', WorkDate());
        LeavePeriod.FindFirst();
        exit(LeavePeriod."Starting Date" - 1);
    end;

    procedure CloseLeaveYear(LapseBoolean: Boolean)
    var
        LeavePeriod: Record "Accounting Period";
        OpenPeriodStartDate: Date;
        OpenPeriodEndDate: Date;
        Employee: Record Employee;
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveLedgerEntry: Record "Leave Earn";
        NCFLeaveCode: Text;
        TotalLeaveDays: Decimal;
        leaveLedgerEntryNo: Integer;
        HRMgt: Codeunit "HR Mgt.";
        LeaveText: Text;
        LeaveMgt: Codeunit "Leave Mgt.";
    begin
        Clear(leaveLedgerEntryNo);
        Clear(LeaveText);
        LeavePeriod.Reset();
        LeavePeriod.SetRange("Leave Year Closed", false);
        LeavePeriod.FindFirst();
        OpenPeriodStartDate := LeavePeriod."Starting Date";
        LeavePeriod.SetRange("New Leave Year", true);
        LeavePeriod.FindFirst();
        if LeavePeriod."Starting Date" = OpenPeriodStartDate then begin
            LeavePeriod.Next();
            OpenPeriodEndDate := LeavePeriod."Starting Date" - 1;
        end else
            OpenPeriodEndDate := LeavePeriod."Starting Date" - 1;
        LeaveText := 'Leave Lapsed for' + Format(OpenPeriodStartDate) + ' to ' + Format(OpenPeriodEndDate);
        if Confirm('Leave periods from %1 to %2 will be closed. Do you want to proceed?', false, OpenPeriodStartDate, OpenPeriodEndDate) then begin
            LeavePeriod.Reset();
            LeavePeriod.SetRange("Starting Date", OpenPeriodStartDate, OpenPeriodEndDate);
            LeavePeriod.ModifyAll("Leave Year Closed", true);


            if LapseBoolean then begin
                LeaveTypeSetup.SetRange("Carry Forwardable", false);
                LeaveTypeSetup.SetFilter("Credit Method", '<>%1', LeaveTypeSetup."Credit Method"::"On Approval");
                if LeaveTypeSetup.FindSet() then
                    repeat
                        Employee.Reset();
                        Employee.SetFilter("Termination Date", '%1|>%2', 0D, OpenPeriodStartDate);
                        if Employee.FindSet() then
                            repeat
                                Clear(TotalLeaveDays);
                                leaveLedgerEntryNo := LeaveMgt.GetNextLeaveLedgerEntryNo();
                                LeaveLedgerEntry.SetRange("Employee No.", Employee."No.");
                                LeaveLedgerEntry.SetFilter("Leave Code", LeaveTypeSetup.Code);
                                LeaveLedgerEntry.SetRange("Posted Date", OpenPeriodStartDate, OpenPeriodEndDate);
                                LeaveLedgerEntry.CalcSums("Balancing Days");
                                TotalLeaveDays := LeaveLedgerEntry."Balancing Days";
                                if TotalLeaveDays > 0 then
                                    LeaveMgt.CreateLeaveLedger(Employee."No.", LeaveTypeSetup.Code, OpenPeriodEndDate, Enum::"Leave Earn Type"::Collapsed, -TotalLeaveDays, leaveLedgerEntryNo, '', LeaveText, '');
                            until Employee.Next() = 0;
                    until LeaveTypeSetup.Next() = 0;
            end;
        end;
    end;
}
