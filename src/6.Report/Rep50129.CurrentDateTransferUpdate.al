report 50129 "Current Date Transfer Update"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Date; Date)
        {
            dataitem(Employee; Employee)
            {
                DataItemTableView = where(Status = const(Active));

                trigger OnAfterGetRecord()
                begin
                    if GeneralTransferUpdate then
                        ApprovedTransferUpdateEmployee;
                    if CompensatoryLeaveEarnUpdate then
                        InsertCompensatorydaysLeave;
                    if UpdateCompensatoryDays then
                        UpdateCompensatoryDayCalc;
                    if UpdateHolidayCounterAmount then
                        UpdateHolidayCounterAmtCalc;
                    if UpdateFestivalCounterAmount then
                        UpdateFestivalCounterAmtCalc;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Employment Date", '<=%1', InitialDate);
                    SetRange(Status, Status::Active);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(InitialDate);
                InitialDate := "Period Start";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Period Start", FromDate, ToDate);
                SetRange("Period Type", "Period Type"::Date);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("From Date"; FromDate)
                {
                    ToolTip = 'Specifies the value of the FromDate field.';
                    ApplicationArea = All;
                }
                field("To Date"; ToDate)
                {
                    ToolTip = 'Specifies the value of the ToDate field.';
                    ApplicationArea = All;
                }
                field(GeneralTransferUpdate; GeneralTransferUpdate)
                {
                    Caption = 'General Transfer Update';
                    ToolTip = 'Specifies the value of the General Transfer Update field.';
                    ApplicationArea = All;
                }
                field("Compensatory Leave Earn Update"; CompensatoryLeaveEarnUpdate)
                {
                    ToolTip = 'Specifies the value of the CompensatoryLeaveEarnUpdate field.';
                    ApplicationArea = All;
                }
                field("Update Compensatory Days"; UpdateCompensatoryDays)
                {
                    ToolTip = 'Specifies the value of the UpdateCompensatoryDays field.';
                    ApplicationArea = All;
                }
                field("Update Holiday Counter Amount"; UpdateHolidayCounterAmount)
                {
                    ToolTip = 'Specifies the value of the UpdateHolidayCounterAmount field.';
                    ApplicationArea = All;
                }
                field("Update Festival Counter Amount"; UpdateFestivalCounterAmount)
                {
                    ToolTip = 'Specifies the value of the UpdateFestivalCounterAmount field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        Message('Success');
    end;

    trigger OnPreReport()
    begin
        if FromDate = 0D then
            FromDate := Today;
        if ToDate = 0D then
            ToDate := Today;

        if FromDate > ToDate then
            Error('From Date %1 must be to date %2.', FromDate, ToDate);

        if (FromDate > Today) or (ToDate > Today) then //Min
            Error('Cannot run Transfer of future date. Please check the date.');
    end;

    var
        InitialDate: Date;
        HRMgt: Codeunit "HR Mgt.";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        FromDate: Date;
        ToDate: Date;
        GeneralTransferUpdate: Boolean;
        //EmployeeActivityRec: Record "Employee Activity";
        Transfer: Record "Employee Transfer";
        EmployeeServiceHistory: Record "Employee Service History";
        //EmpActivity: Record "Employee Activity";
        CompLeaveOverTime: Record OverTime;
        PayrollGenSetup: Record "Payroll General Setup";
        EngNep: Record "English-Nepali Date";
        LeaveEarn: Record "Leave Earn";
        CompensatoryLeaveEarnUpdate: Boolean;
        UpdateCompensatoryDays: Boolean;
        UpdateHolidayCounterAmount: Boolean;
        UpdateFestivalCounterAmount: Boolean;
        //EmployeeActRec: Record "Employee Activity";
        OverTime: Record OverTime;
        EmpVar: Record Employee;

    local procedure ApprovedTransferUpdateEmployee()
    begin
        Transfer.Reset;
        Transfer.SetRange("Employee No.", Employee."No.");
        Transfer.SetFilter(Type, '%1|%2', Transfer.Type::"HR Transfer", Transfer.Type::"Employee Transfer");
        Transfer.SetFilter("Approval Status", '%1|%2', Transfer."Approval Status"::Approved, Transfer."Approval Status"::Acknowledged);
        Transfer.SetRange("Transfer Effective Date", InitialDate, InitialDate);
        if Transfer.FindFirst then begin
            EmployeeServiceHistory.Reset;
            EmployeeServiceHistory.SetRange("Document No.", Transfer."No.");
            if not EmployeeServiceHistory.FindFirst then  //Min-- For skip already created transfer Emp service history
                ServiceHistoryMgt.ApprovedTransferUpdate(Transfer);
        end;
    end;

    local procedure InsertCompensatorydaysLeave()
    var
        leaveMgt: Codeunit "Leave Mgt.";
    begin
        CompensatoryFilter;
        CompLeaveOverTime.CalcSums(CompLeaveOverTime."Compensatory Days");

        if CompLeaveOverTime."Compensatory Days" > 1 then begin
            EngNep.Reset;
            EngNep.SetRange("English Date", Today);
            if EngNep.FindFirst then;
            Clear(LeaveEarn);
            LeaveEarn.Init;
            LeaveEarn.Validate("Entry No.", leaveMgt.GetNextLeaveLedgerEntryNo());
            LeaveEarn.Validate("Leave Code", 'COMPENSATORY');
            LeaveEarn.Validate("Employee No.", Employee."No.");
            LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
            LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
            LeaveEarn.Validate("Posted Date", Today);
            LeaveEarn.Validate("Balancing Days", CompLeaveOverTime."Compensatory Days");
            LeaveEarn.Insert(true);
            CompensatoryFilter;
            if CompLeaveOverTime.FindSet then
                repeat
                    CompLeaveOverTime.Validate("OT Disbursed", true);
                    CompLeaveOverTime.Modify;
                until CompLeaveOverTime.Next = 0;
        end;
    end;

    local procedure CompensatoryFilter()
    begin
        PayrollGenSetup.Get;
        CompLeaveOverTime.Reset;
        CompLeaveOverTime.SetRange("Employee No.", Employee."No.");
        CompLeaveOverTime.SetRange(Type, CompLeaveOverTime.Type::Overtime);
        CompLeaveOverTime.SetRange("Approval Status", CompLeaveOverTime."Approval Status"::Approved);
        CompLeaveOverTime.SetRange("OT Disbursed", false);
        CompLeaveOverTime.SetRange("Encashment Code", PayrollGenSetup."Compensatory Leave");
        CompLeaveOverTime.SetRange("Start Date", PayrollGenSetup."Payroll Fiscal Year Start Date", PayrollGenSetup."Payroll Fiscal Year End Date");
    end;

    local procedure UpdateCompensatoryDayCalc()
    begin
        PayrollGenSetup.Get;
        CommonFilter;
        OverTime.SetRange("Encashment Code", PayrollGenSetup."Compensatory Leave");
        OverTime.SetRange("Compensatory Days", 0);
        if OverTime.FindSet then
            repeat
                OverTime."Compensatory Days" := Round(OverTime."Estimated Hours" / PayrollGenSetup."Compensatory Leave Hour", 0.01, '>');
                OverTime.Modify;
            until OverTime.Next = 0;
    end;

    local procedure UpdateHolidayCounterAmtCalc()
    begin
        PayrollGenSetup.Get;
        CommonFilter;
        OverTime.SetRange("Encashment Code", PayrollGenSetup."Holiday Counter");
        //EmployeeActRec.SETRANGE("OT Amount",0);
        if OverTime.FindSet then
            repeat
                EmpVar.Get(OverTime."Employee No.");
                if EmpVar."Employment Type" = EmpVar."Employment Type"::Contract then
                    OverTime."OT Amount" := PayrollGenSetup."Holiday All. Amt (Contract)"
                else
                    OverTime."OT Amount" := PayrollGenSetup."Holiday All. Amt (Regular)";
                OverTime.Modify;
            until OverTime.Next = 0;
    end;

    local procedure UpdateFestivalCounterAmtCalc()
    begin
        PayrollGenSetup.Get;
        CommonFilter;
        OverTime.SetRange("Encashment Code", PayrollGenSetup."Festival Counter");
        //EmployeeActRec.SETRANGE("OT Amount",0);
        if OverTime.FindSet then
            repeat
                EmpVar.Get(OverTime."Employee No.");
                if EmpVar."Employment Type" = EmpVar."Employment Type"::Contract then
                    OverTime."OT Amount" := PayrollGenSetup."Festival Counter(Contract)"
                else
                    OverTime."OT Amount" := PayrollGenSetup."Festival Counter(Regular)";
                OverTime.Modify;
            until OverTime.Next = 0;
    end;

    local procedure CommonFilter()
    begin
        OverTime.Reset;
        OverTime.SetCurrentKey("Requested Date");
        OverTime.SetRange(Type, OverTime.Type::Overtime);
        OverTime.SetRange("OT Disbursed", false);
        OverTime.SetRange("Requested Date", InitialDate, InitialDate);
    end;
}
