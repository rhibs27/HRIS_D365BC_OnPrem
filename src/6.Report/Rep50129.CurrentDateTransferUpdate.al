report 50129 "Current Date Transfer Update"
{
    // //Min 1.3 --- Added ServiceHistory."Service Event"::"Back From Deputation" Parameter instead of ServiceHistory."Service Event"::"Transfer"
    // //Min 3.13.2022 -- For Update data in "Employee Service History" and "Employee" Table of "Approved" and "Acknowledge" Transfer.

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
                        ApprovedTransferUpdateEmployee; //Min 3.13.2022
                    if CompensatoryLeaveEarnUpdate then
                        InsertCompensatorydaysLeave; //Min 12.14.2022
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
        FromDate: Date;
        ToDate: Date;
        GeneralTransferUpdate: Boolean;
        EmployeeActivityRec: Record "Employee Activity";
        EmployeeServiceHistory: Record "Employee Service History";
        EmpActivity: Record "Employee Activity";
        PayrollGenSetup: Record "Payroll General Setup";
        EngNep: Record "English-Nepali Date";
        LeaveEarn: Record "Leave Earn";
        CompensatoryLeaveEarnUpdate: Boolean;
        UpdateCompensatoryDays: Boolean;
        UpdateHolidayCounterAmount: Boolean;
        UpdateFestivalCounterAmount: Boolean;
        EmployeeActRec: Record "Employee Activity";
        EmpVar: Record Employee;

    local procedure ApprovedTransferUpdateEmployee()
    begin
        EmployeeActivityRec.Reset;
        EmployeeActivityRec.SetRange("Employee No.", Employee."No.");
        EmployeeActivityRec.SetFilter(Type, '%1|%2', EmployeeActivityRec.Type::"HR Transfer", EmployeeActivityRec.Type::"Employee Transfer");
        EmployeeActivityRec.SetFilter("Approval Status", '%1|%2', EmployeeActivityRec."Approval Status"::Approved, EmployeeActivityRec."Approval Status"::Acknowledged);
        EmployeeActivityRec.SetRange("Transfer Effective Date", InitialDate, InitialDate);
        if EmployeeActivityRec.FindFirst then begin
            EmployeeServiceHistory.Reset;
            EmployeeServiceHistory.SetRange("Document No.", EmployeeActivityRec."No.");
            if not EmployeeServiceHistory.FindFirst then  //Min-- For skip already created transfer Emp service history
                HRMgt.ApprovedTransferUpdate(EmployeeActivityRec);
        end;
    end;

    local procedure InsertCompensatorydaysLeave()
    begin
        CompensatoryFilter;
        EmpActivity.CalcSums(EmpActivity."Compensatory Days");

        if EmpActivity."Compensatory Days" > 1 then begin
            EngNep.Reset;
            EngNep.SetRange("English Date", Today);
            if EngNep.FindFirst then;
            Clear(LeaveEarn);
            LeaveEarn.Init;
            LeaveEarn.Validate("Leave Code", 'COMPENSATORY');
            LeaveEarn.Validate(EmpNo, Employee."No.");
            LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
            LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
            LeaveEarn.Validate("Posted Date", Today);
            LeaveEarn.Validate("Balancing Days", EmpActivity."Compensatory Days");
            LeaveEarn.Insert(true);
            CompensatoryFilter;
            if EmpActivity.FindSet then
                repeat
                    EmpActivity.Validate("OT Disbursed", true);
                    EmpActivity.Modify;
                until EmpActivity.Next = 0;
        end;
    end;

    local procedure CompensatoryFilter()
    begin
        PayrollGenSetup.Get;
        EmpActivity.Reset;
        EmpActivity.SetRange("Employee No.", Employee."No.");
        EmpActivity.SetRange(Type, EmpActivity.Type::Overtime);
        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Approved);
        EmpActivity.SetRange("OT Disbursed", false);
        EmpActivity.SetRange("Encashment Code", PayrollGenSetup."Compensatory Leave");
        EmpActivity.SetRange("Start Date", PayrollGenSetup."Payroll Fiscal Year Start Date", PayrollGenSetup."Payroll Fiscal Year End Date");
    end;

    local procedure UpdateCompensatoryDayCalc()
    begin
        PayrollGenSetup.Get;
        CommonFilter;
        EmployeeActRec.SetRange("Encashment Code", PayrollGenSetup."Compensatory Leave");
        EmployeeActRec.SetRange("Compensatory Days", 0);
        if EmployeeActRec.FindSet then
            repeat
                EmployeeActRec."Compensatory Days" := Round(EmployeeActRec."Estimated Hours" / PayrollGenSetup."Compensatory Leave Hour", 0.01, '>');
                EmployeeActRec.Modify;
            until EmployeeActRec.Next = 0;
    end;

    local procedure UpdateHolidayCounterAmtCalc()
    begin
        PayrollGenSetup.Get;
        CommonFilter;
        EmployeeActRec.SetRange("Encashment Code", PayrollGenSetup."Holiday Counter");
        //EmployeeActRec.SETRANGE("OT Amount",0);
        if EmployeeActRec.FindSet then
            repeat
                EmpVar.Get(EmployeeActRec."Employee No.");
                if EmpVar."Employment Type" = EmpVar."Employment Type"::Contract then
                    EmployeeActRec."OT Amount" := PayrollGenSetup."Holiday All. Amt (Contract)"
                else
                    EmployeeActRec."OT Amount" := PayrollGenSetup."Holiday All. Amt (Regular)";
                EmployeeActRec.Modify;
            until EmployeeActRec.Next = 0;
    end;

    local procedure UpdateFestivalCounterAmtCalc()
    begin
        PayrollGenSetup.Get;
        CommonFilter;
        EmployeeActRec.SetRange("Encashment Code", PayrollGenSetup."Festival Counter");
        //EmployeeActRec.SETRANGE("OT Amount",0);
        if EmployeeActRec.FindSet then
            repeat
                EmpVar.Get(EmployeeActRec."Employee No.");
                if EmpVar."Employment Type" = EmpVar."Employment Type"::Contract then
                    EmployeeActRec."OT Amount" := PayrollGenSetup."Festival Counter(Contract)"
                else
                    EmployeeActRec."OT Amount" := PayrollGenSetup."Festival Counter(Regular)";
                EmployeeActRec.Modify;
            until EmployeeActRec.Next = 0;
    end;

    local procedure CommonFilter()
    begin
        EmployeeActRec.Reset;
        EmployeeActRec.SetCurrentKey("Requested Date");
        EmployeeActRec.SetRange(Type, EmployeeActRec.Type::Overtime);
        EmployeeActRec.SetRange("OT Disbursed", false);
        EmployeeActRec.SetRange("Requested Date", InitialDate, InitialDate);
    end;
}
