report 50139 "Daily Attendance Update"
{
    // //Min 1.3 --- Added ServiceHistory."Service Event"::"Back From Deputation" Parameter instead of ServiceHistory."Service Event"::"Transfer"
    // //Min 3.13.2022 -- For Update data in "Employee Service History" and "Employee" Table of "Approved" and "Acknowledge" Transfer.
    // //Min 9.26.2022 -- For Document No.Flow in Service History of Re-instiate Transfer.
    // //Min 11.25.2022 -- Sync "Salary Level,Grade" in Emp Attendance Activity.

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
                RequestFilterFields = "No.", "Employment Type", Status;

                trigger OnAfterGetRecord()
                begin
                    if UpdateDailyAttendance then begin
                        if "Employment Date" = 0D then    // skip blank employment date employee oman
                            CurrReport.Skip;
                        InsertAttendanceLine;
                        if Employee."Employment Type" = Employee."Employment Type"::Contract then
                            StatusInactiveForExpiredContractEmployee;
                    end;
                    if ReinstateTransfer then
                        ReinstateTranferedEmployee;

                    if GeneralTransferUpdate then
                        ApprovedTransferUpdateEmployee; //Min 3.13.2022

                    if SalaryLevelGradeUpdate then //Min 11.25.2022
                        SalaryLevelGradeUpdateEmpAttenAct;

                    if AttendanceMissedCountUpdate then begin
                        Validate("Attendance Missed On", HRMgt.CheckLeaveCount("No."));
                        if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                            if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                                Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount("No.", AttendanceSetup."Activate Punch in Date" - 1))
                            else
                                Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount("No.", "Attendance Missed On"));
                        end else
                            Validate("Attendance Missed Count", HRMgt.ReturnLeaveCount("No.", "Attendance Missed On"));
                        Modify;
                    end;
                    if NightShiftAttendanceUpdate then begin
                        AttendanceLogRec.Reset;
                        AttendanceLogRec.SetRange(Date, InitialDate);
                        AttendanceLogRec.SetFilter("Night Shift Check Out Time", '<>%1', 0T);
                        AttendanceLogRec.SetRange("Employee ID", Employee."No.");
                        if AttendanceLogRec.FindFirst then begin
                            AttendLine.Reset;
                            AttendLine.SetRange("Employee No.", AttendanceLogRec."Employee ID");
                            AttendLine.SetRange("Attendance Date", AttendanceLogRec.Date);
                            if AttendLine.FindFirst then begin
                                AttendLine."Punch Out Reviewer" := AttendanceLogRec."Punch Out Reviewer";
                                AttendLine."Punch Out Check Reviewer" := AttendanceLogRec."Punch Out Check Reviewer";
                                AttendLine."Punch out Remarks" := AttendanceLogRec."Punch out Remarks";
                                AttendLine."Night Shift Punch Out Time" := AttendanceLogRec."Night Shift Check Out Time";
                                AttendLine.Modify;
                            end;
                            if EmpAttenActRec.Get(AttendanceLogRec."Employee ID", AttendanceLogRec.Date) then begin
                                EmpAttenActRec."Punch Out Reviewer" := AttendanceLogRec."Punch Out Reviewer";
                                EmpAttenActRec."Punch Out Check Reviewer" := AttendanceLogRec."Punch Out Check Reviewer";
                                EmpAttenActRec."Punch out Remarks" := AttendanceLogRec."Punch out Remarks";
                                EmpAttenActRec."Night Shift Punch Out Time" := AttendanceLogRec."Night Shift Check Out Time";
                                EmpAttenActRec.Modify;
                            end;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Employment Date", '<=%1', InitialDate);
                    SetRange(Status, Employee.Status::Active); //Min 8.26.2022
                end;
            }
            dataitem(Overtime; "Integer")
            {
                DataItemTableView = where(Number = const(1));

                trigger OnAfterGetRecord()
                begin
                    ScreenOvertime;
                    // ScreenAllowanceAssignment;
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
                field("Update Attendance"; UpdateDailyAttendance)
                {
                    ToolTip = 'Specifies the value of the UpdateDailyAttendance field.';
                    ApplicationArea = All;
                }
                field("Update Overtime"; UpdateOvertime)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the UpdateOvertime field.';
                    ApplicationArea = All;
                }
                field("Update Allowance Assignment"; UpdateAllowanceAssignment)
                {
                    ToolTip = 'Specifies the value of the UpdateAllowanceAssignment field.';
                    ApplicationArea = All;
                }
                field("Reinstate Transfer"; ReinstateTransfer)
                {
                    ToolTip = 'Specifies the value of the ReinstateTransfer field.';
                    ApplicationArea = All;
                }
                field("Sync Employees"; SyncEmployees)
                {
                    Caption = 'Sync Employees';
                    ToolTip = 'Specifies the value of the Sync Employees field.';
                    ApplicationArea = All;
                }
                field("General Transfer Update"; GeneralTransferUpdate)
                {
                    ToolTip = 'Specifies the value of the GeneralTransferUpdate field.';
                    ApplicationArea = All;
                }
                field("Salary Level Grade Update"; SalaryLevelGradeUpdate)
                {
                    ToolTip = 'Specifies the value of the SalaryLevelGradeUpdate field.';
                    ApplicationArea = All;
                }
                field("Attendance Missed Count Update"; AttendanceMissedCountUpdate)
                {
                    ToolTip = 'Specifies the value of the AttendanceMissedCountUpdate field.';
                    ApplicationArea = All;
                }
                field("Night Shift Attendance Update"; NightShiftAttendanceUpdate)
                {
                    ToolTip = 'Specifies the value of the NightShiftAttendanceUpdate field.';
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
        AttendanceSetup.Get;
        DocNo := NoSeriesMgt.GetNextNo(AttendanceSetup."Attendance Line No. Series", Today, true);
        /*IF FromDate = 0D THEN
          FromDate := TODAY-1;
        IF ToDate = 0D THEN
          ToDate := TODAY -1;*/
        if (FromDate = 0D) or (ToDate = 0D) then //Min1.9.23
            Error(Err001);
        if UpdateDailyAttendance then begin
            if Employee.GetFilter("Employment Type") = '' then
                Error(Err003);
        end;
        if FromDate > ToDate then
            Error('From Date %1 must be to date %2.', FromDate, ToDate);

        UserSetup.Get(UserId);
        if not UserSetup."Run Back Date Daily Attend." then
            if FromDate < Today - 1 then
                Error('You are not eligible to run back date daily attendance.');

        if (FromDate > Today) or (ToDate > Today) then //Min
            Error('Cannot run attendance of future date. Please check the date.');

        if SyncEmployees then
            HRMgt.SyncEmployee();
    end;

    var
        AttendanceSetup: Record "Attendance Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocNo: Code[20];
        InitialDate: Date;
        AttendanceLine: Record "Attendance Line";
        AttendanceLog: Record "Attendance Log";
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        CalendarDescription: Text;
        UpdateOvertime: Boolean;
        UpdateDailyAttendance: Boolean;
        UpdateAllowanceAssignment: Boolean;
        FromDate: Date;
        ToDate: Date;
        HRSetup: Record "Human Resources Setup";
        PRSetup: Record "Payroll General Setup";
        //EmployeeActivity: Record "Employee Activity";
        Transfer: Record "Employee/HR Transfer";
        RejectionRemarks: Text;
        [InDataSet]
        ReinstateTransfer: Boolean;
        UserSetup: Record "User Setup";
        SyncEmployees: Boolean;
        GeneralTransferUpdate: Boolean;
        //EmployeeActivityRec: Record "Employee Activity";
        EmployeeTransferRec: Record "Employee/HR Transfer";
        EmployeeServiceHistory: Record "Employee Service History";
        SalaryLevelGradeUpdate: Boolean;
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        AttendanceLineRec: Record "Attendance Line";
        AttendanceMissedCountUpdate: Boolean;
        AttendanceLogRec: Record "Attendance Log";
        NightShiftAttendanceUpdate: Boolean;
        EmpAttenActRec: Record "Employee Attendance & Activity";
        AttendLine: Record "Attendance Line";
        Err001: Label 'Please Select From Date and To Date.';
        Err003: Label 'Please Select Employement Type for update attendance.';
        EngNep: Record "English-Nepali Date";

    local procedure InsertAttendanceLine()
    var
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        Clear(AttendanceLine);
        AttendanceLine.Reset;
        AttendanceLine.SetRange("Employee No.", Employee."No.");
        AttendanceLine.SetRange("Attendance Date", InitialDate);
        if not AttendanceLine.FindFirst then begin
            AttendanceLine.Init;
            AttendanceLine."Document No." := DocNo;
            AttendanceLine."Employee No." := Employee."No.";
            AttendanceLine.Validate("Employee Working Shift", Employee."Employee Work Shift");
            AttendanceLine."Attendance Date" := InitialDate;
            //AttendanceLine.CopyFromAttendanceHeader(AttendanceHeader);
            AttendanceLine.Insert(false);
        end;

        if IsHoliday(InitialDate, AttendanceLine.Remarks) then begin
            AttendanceLine."Day Type" := AttendanceLine."Day Type"::Holiday;
            AttendanceLine."Week Off Day" := 1;
            AttendanceLine."Holiday Remarks" := CalendarDescription;
        end else begin
            AttendanceLine."Day Type" := AttendanceLine."Day Type"::"Working Day";
            AttendanceLine."Holiday Remarks" := '';
            AttendanceLine."Week Off Day" := 0;
        end;
        AttendanceLog.Reset;
        AttendanceLog.SetRange(Date, InitialDate);
        AttendanceLog.SetRange("Employee ID", AttendanceLine."Employee No.");
        if AttendanceLog.FindFirst then begin
            AttendanceLine.Validate("Check In Time", AttendanceLog."Check In Time");
            AttendanceLine.Validate("Check Out Time", AttendanceLog."Check Out Time");
            AttendanceLine.Validate("Punch Out Reviewer", AttendanceLog."Punch Out Reviewer"); //Min 8.25.2022
            AttendanceLine.Validate("Punch Out Check Reviewer", AttendanceLog."Punch Out Check Reviewer"); //Min 8.25.2022
            AttendanceLine.Validate("Punch out Remarks", AttendanceLog."Punch out Remarks"); //Min 8.29.2022
            AttendanceLine.Validate("Night Shift Punch Out Time", AttendanceLog."Night Shift Check Out Time"); //Min 12.05.2022
            if (AttendanceLine."Check In Time" <> 0T) then begin
                AttendanceLine."Entry Type" := AttendanceLine."Entry Type"::Present;
                AttendanceLine.Validate("Present Day", 1);
            end;
        end;
        EngNep.Reset; //Min 1.25.2023
        EngNep.SetRange("English Date", InitialDate);
        if EngNep.FindFirst then
            AttendanceLine.Week := EngNep.Week;
        AttendanceLine.Modify(false);

        PayrollEngine.PrepareEmployeeDailyActivity(AttendanceLine."Employee No.", InitialDate, InitialDate, true);

        ChangeStatusToApproveFromHold;
    end;

    local procedure IsHoliday(Date: Date; Remarks: Text[100]): Boolean
    var
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        RetrunBool: Boolean;
    begin
        RetrunBool := false;
        Clear(CalendarDescription);
        RetrunBool := LeaveMgt.GetNonWokingDays(InitialDate, InitialDate, Employee."No.") <> 0;
        CalendarDescription := HRMgt.ReturnCalendarDescription;
        exit(RetrunBool);
    end;

    local procedure ScreenOvertime()
    var
        //EmployeeActivity: Record "Employee Activity";
        OverTime: Record OverTime;
        Workshift: Record "Employee Work Shift";
        StartTime: Time;
        EndTime: Time;
        StandardWorkingHrs: Decimal;
        ActualOTHrs: Decimal;
        RejectionRemarks: Text;
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        SalaryLevel: Record "Salary Level";
        SalaryLevelTxt: Text;
    begin
        if not UpdateOvertime then
            exit;

        Workshift.Reset;
        Workshift.FindFirst;
        Workshift.TestField("Start Time");
        Workshift.TestField("End Time");
        Workshift.TestField("Friday End Time");
        Workshift.TestField("Winter Start Date");
        Workshift.TestField("Winter End Date");
        Workshift.TestField("Winter End Time");
        StartTime := 0T;
        EndTime := 0T;
        StandardWorkingHrs := 0;
        SalaryLevelTxt := '';

        StartTime := Workshift."Start Time";

        if HRMgt.IsWinter(InitialDate, Workshift) then begin
            if HRMgt.IsFriday(InitialDate) then
                EndTime := Workshift."Friday End Time"
            else
                EndTime := Workshift."Winter End Time";
        end else begin
            if HRMgt.IsFriday(InitialDate) then
                EndTime := Workshift."Friday End Time"
            else
                EndTime := Workshift."End Time";
        end;

        StandardWorkingHrs := (EndTime - StartTime) / 3600000;
        SalaryLevel.Reset;
        SalaryLevel.SetRange("OT Attachment Mandatory", true);
        if SalaryLevel.FindFirst then
            repeat
                if SalaryLevelTxt = '' then
                    SalaryLevelTxt := SalaryLevel.Code
                else
                    SalaryLevelTxt += '|' + SalaryLevel.Code;
            until SalaryLevel.Next = 0;

        OverTime.Reset;
        OverTime.SetRange(Type, OverTime.Type::Overtime);
        OverTime.SetRange("Start Date", InitialDate);
        OverTime.SetFilter("Salary Level Code", '<>%1', SalaryLevelTxt);
        //EmployeeActivity.SETRANGE("Employee No.",EmployeeNo);
        OverTime.SetRange("Approval Status", OverTime."Approval Status"::Approved);
        if OverTime.FindFirst then
            repeat
                if OverTimeMgt.CheckOvertimeEligibility(OverTime, StartTime, EndTime, StandardWorkingHrs, ActualOTHrs, RejectionRemarks) then begin
                    OverTime."Actual OT Hours" := ActualOTHrs;
                    // OverTime.Validate("Approval Status", OverTime."Approval Status"::Screened); temp commented santosh
                    OverTime.Modify;
                    EmployeeAttendanceActivity.Reset;
                    EmployeeAttendanceActivity.SetRange("Attendance Date", OverTime."Start Date");
                    EmployeeAttendanceActivity.SetRange("Employee No.", OverTime."Employee No.");
                    if EmployeeAttendanceActivity.FindFirst then begin
                        EmployeeAttendanceActivity."OT Day" := 1;
                        EmployeeAttendanceActivity."OT Hrs" := ActualOTHrs;
                        EmployeeAttendanceActivity.Modify(true);
                    end;
                end else begin
                    OverTime."Rejection Remarks" := RejectionRemarks;
                    OverTime."Approval Status" := OverTime."Approval Status"::Rejected;
                    OverTime.Modify;

                    EmployeeAttendanceActivity.Reset;
                    EmployeeAttendanceActivity.SetRange("Attendance Date", OverTime."Start Date");
                    EmployeeAttendanceActivity.SetRange("Employee No.", OverTime."Employee No.");
                    if EmployeeAttendanceActivity.FindFirst then begin
                        EmployeeAttendanceActivity."OT Day" := 0;
                        EmployeeAttendanceActivity."OT Hrs" := ActualOTHrs;
                        EmployeeAttendanceActivity.Modify(true);
                    end;
                end;
            until OverTime.Next = 0;
    end;

    local procedure ScreenAllowanceAssignment()
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
    begin
        if not UpdateAllowanceAssignment then
            exit;

        if (FromDate = 0D) and (ToDate = 0D) then
            Error('From Date and To Date must have value!!!');

        HRSetup.Get;
        HRSetup.TestField("Evening Counter Eligible Time");
        HRSetup.TestField("Morning Counter Eligible Time");

        PRSetup.Get;
        PRSetup.TestField("Risk Allowance");
        PRSetup.TestField("Evening Counter");
        PRSetup.TestField("Morning Counter");
        PRSetup.TestField("Holiday Counter");
        PRSetup.TestField("Friday Counter");
        PRSetup.TestField("Festival Counter");
        PRSetup.TestField("Vault Key");
        PRSetup.TestField("Risk Allowance");

        AllowanceAssignmentLine.Reset;
        AllowanceAssignmentLine.SetRange("From Date", FromDate, ToDate);
        //AllowanceAssignmentLine.SETRANGE("Approval Status",AllowanceAssignmentLine."Approval Status"::Approved);
        if AllowanceAssignmentLine.FindFirst then
            repeat

                EmployeeAttendanceActivity.Reset;
                EmployeeAttendanceActivity.SetRange("Attendance Date", AllowanceAssignmentLine."From Date");
                EmployeeAttendanceActivity.SetRange("Employee No.", AllowanceAssignmentLine."Employee Code");

                case AllowanceAssignmentLine."Allowance Type" of
                    PRSetup."Evening Counter":
                        begin
                            EmployeeAttendanceActivity.SetFilter("Check Out Time", '>=%1', HRSetup."Evening Counter Eligible Time");
                            RejectionRemarks := StrSubstNo('Check out time not applicable for evening counter.');
                        end;
                    PRSetup."Morning Counter":
                        begin
                            EmployeeAttendanceActivity.SetFilter("Check In Time", '<%1', HRSetup."Morning Counter Eligible Time");
                            EmployeeAttendanceActivity.SetRange("Present Day", 1);
                            EmployeeAttendanceActivity.SetRange("Source No.", '');
                            RejectionRemarks := StrSubstNo('Check in time not applicable for morning counter.');
                        end;
                    PRSetup."Festival Counter", PRSetup."Holiday Counter", PRSetup."Friday Counter", PRSetup."Risk Allowance":
                        begin
                            EmployeeAttendanceActivity.SetFilter("Check In Time", '<>%1', 0T);
                            RejectionRemarks := 'No Check In found.'
                        end;
                    PRSetup."Vault Key":
                        begin
                            if LeaveMgt.GetNonWokingDays(AllowanceAssignmentLine."From Date", AllowanceAssignmentLine."From Date", AllowanceAssignmentLine."Employee Code") = 0 then
                                //EmployeeAttendanceActivity.SETFILTER("Check In Time",'<>%1',0T);
                                EmployeeAttendanceActivity.SetRange("Present Day", 1);
                            RejectionRemarks := 'No Check In found.'
                        end;
                end;
                if not EmployeeAttendanceActivity.FindFirst then begin
                    AllowanceAssignmentLine."Approval Status" := AllowanceAssignmentLine."Approval Status"::Rejected;
                    AllowanceAssignmentLine."Rejection Remarks" := RejectionRemarks;
                    AllowanceAssignmentLine.Modify;
                end;
            until AllowanceAssignmentLine.Next = 0;
    end;

    local procedure InsertAllowanceAssignmentDays()
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
    begin
        if not UpdateAllowanceAssignment then
            exit;
        AllowanceAssignmentLine.Reset;
        AllowanceAssignmentLine.SetRange("From Date", FromDate, ToDate);
        AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
        if AllowanceAssignmentLine.FindFirst then
            repeat
                EmployeeAttendanceActivity.Reset;
                EmployeeAttendanceActivity.SetRange("Attendance Date", AllowanceAssignmentLine."From Date");
                EmployeeAttendanceActivity.SetRange("Employee No.", AllowanceAssignmentLine."Employee Code");
                if EmployeeAttendanceActivity.FindFirst then begin
                    case AllowanceAssignmentLine."Allowance Type" of

                        PRSetup."Evening Counter":
                            EmployeeAttendanceActivity."Evening Counter Days" := 1;

                        PRSetup."Morning Counter":
                            EmployeeAttendanceActivity."Morning Counter Days" := 1;

                        PRSetup."Festival Counter":
                            EmployeeAttendanceActivity."Festival Counter Days" := 1;

                        PRSetup."Holiday Counter":
                            EmployeeAttendanceActivity."Holiday Counter Days" := 1;

                        PRSetup."Friday Counter":
                            EmployeeAttendanceActivity."Friday Counter Days" := 1;

                        PRSetup."Risk Allowance":
                            EmployeeAttendanceActivity."Cash Risk Days" := 1;

                        PRSetup."Vault Key":
                            EmployeeAttendanceActivity."Vault Key Days" := 1;
                    end;
                    EmployeeAttendanceActivity.Modify;
                end;
            until AllowanceAssignmentLine.Next = 0;
    end;

    local procedure ReinstateTranferedEmployee()
    var
        ServiceHistory: Record "Employee Service History";
        ServiceCode: Code[20];
        //EmpActivity: Record "Employee Activity";
        TransferEmp: Record "Employee/HR Transfer";
        PreviousServiceHistory: Record "Employee Service History";
    begin
        Transfer.Reset;
        Transfer.SetRange("Employee No.", Employee."No.");
        Transfer.SetFilter("Transfer Category", '%1|%2', Transfer."Transfer Category"::"Temporary", Transfer."Transfer Category"::Officiating);
        Transfer.SetFilter(Type, '%1|%2', Transfer.Type::"HR Transfer", Transfer.Type::"Employee Transfer");
        Transfer.SetFilter("Approval Status", '%1|%2', Transfer."Approval Status"::Approved, Transfer."Approval Status"::Acknowledged); //Min -- added Filter Approved option instead of Acknowledge.
        Transfer.SetRange("End Date", InitialDate, InitialDate);
        if Transfer.FindFirst then begin
            EmployeeServiceHistory.Reset;
            EmployeeServiceHistory.SetRange("Service Event", EmployeeServiceHistory."Service Event"::"Back From Deputation");
            EmployeeServiceHistory.SetRange("Employee No.", Transfer."Employee No.");
            EmployeeServiceHistory.SetRange("Document No.", Transfer."No.");
            if not EmployeeServiceHistory.FindFirst then begin //Min 9.26.2022
                if Transfer."Approval Status" = Transfer."Approval Status"::Acknowledged then begin
                    TransferEmp.Reset;
                    TransferEmp.SetRange("Employee No.", Employee."No.");
                    TransferEmp.SetRange("Transfer Category", TransferEmp."Transfer Category"::General);
                    TransferEmp.SetFilter(Type, '%1|%2', TransferEmp.Type::"HR Transfer", TransferEmp.Type::"Employee Transfer");
                    TransferEmp.SetRange("Approval Status", TransferEmp."Approval Status"::Acknowledged);
                    TransferEmp.SetFilter("Acknowledged Date", '>%1', Transfer."Acknowledged Date");
                    if TransferEmp.FindFirst then
                        exit;
                end;
                ServiceCode := HRMgt.AddToServiceHistory(Employee."No.", ServiceHistory."Service Event"::"Back From Deputation", 'Reinstating Transfer', InitialDate); //Min 1.3
                Employee.Validate("Functional Title", Transfer."Functional Title");
                Employee.Validate("Deputation on", Transfer."Deputation On");
                case Employee."Deputation on" of
                    Employee."Deputation on"::Branch:
                        Employee.Validate("Global Dimension 1 Code", Transfer."Shortcut Dimension 1 Code");
                    Employee."Deputation on"::Province:
                        Employee.Validate("Province Code", Transfer."Province Code");
                    // Employee."Deputation on"::"Sub Province":
                    //     Employee.Validate("Sub Province Code", Transfer."Sub Province Code");
                    Employee."Deputation on"::Unit:
                        Employee.Validate("Unit Code", Transfer."Unit Code");
                    Employee."Deputation on"::"Extension Counter":
                        Employee.Validate("Extension Counter Code", Transfer."Extension Counter Code");
                    Employee."Deputation on"::Department:
                        Employee.Validate("Department Code", Transfer.Department);
                end;
                Employee.Modify;
                if ServiceHistory.Get(ServiceCode) then begin
                    ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
                    ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
                    ServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
                    ServiceHistory.Validate("Deputation Code (To)", HRMgt.ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                    ServiceHistory.Validate("Deputation Value (To)", HRMgt.ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                    ServiceHistory.Validate("Document No.", Transfer."No."); //Min 9.26.2022
                    PreviousServiceHistory.Reset;
                    PreviousServiceHistory.SetRange("Employee No.", Employee."No.");
                    PreviousServiceHistory.SetFilter("Service History Code", '<>%1', ServiceCode);
                    PreviousServiceHistory.SetCurrentKey("Effective Date");
                    if PreviousServiceHistory.FindLast then begin
                        ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
                    end;
                    ServiceHistory.Modify;
                end;
            end;
        end;
    end;

    local procedure ChangeStatusToApproveFromHold()
    begin
        Transfer.Reset;
        Transfer.SetRange("Employee No.", Employee."No.");
        Transfer.SetFilter(Type, '%1|%2', Transfer.Type::"HR Transfer", Transfer.Type::"Employee Transfer");
        Transfer.SetRange("Approval Status", Transfer."Approval Status"::"On Hold");
        Transfer.SetRange("On Hold Date", FromDate, ToDate);
        if Transfer.FindFirst then begin
            Transfer."Approval Status" := Transfer."Approval Status"::Approved;
            Transfer.Modify;
        end;
    end;

    local procedure StatusInactiveForExpiredContractEmployee()
    begin
        if Employee."Contract Expiry Date" <> 0D then
            if Employee."Contract Expiry Date" <= InitialDate then
                Employee.Validate(Status, Employee.Status::Inactive);
    end;

    local procedure ApprovedTransferUpdateEmployee()
    begin
        EmployeeTransferRec.Reset;
        EmployeeTransferRec.SetRange("Employee No.", Employee."No.");
        EmployeeTransferRec.SetFilter(Type, '%1|%2', EmployeeTransferRec.Type::"HR Transfer", EmployeeTransferRec.Type::"Employee Transfer");
        EmployeeTransferRec.SetFilter("Approval Status", '%1|%2', EmployeeTransferRec."Approval Status"::Approved, EmployeeTransferRec."Approval Status"::Acknowledged);
        EmployeeTransferRec.SetRange("Transfer Effective Date", InitialDate, InitialDate);
        if EmployeeTransferRec.FindFirst then begin
            EmployeeServiceHistory.Reset;
            EmployeeServiceHistory.SetRange("Employee No.", EmployeeTransferRec."Employee No.");
            EmployeeServiceHistory.SetFilter("Service Event", '%1|%2|%3', EmployeeServiceHistory."Service Event"::Transfer, EmployeeServiceHistory."Service Event"::"Temporary Deputation", EmployeeServiceHistory."Service Event"::"Officiating Arrangement");
            EmployeeServiceHistory.SetRange("Document No.", EmployeeTransferRec."No.");
            if not EmployeeServiceHistory.FindFirst then  //Min-- For skip already created transfer Emp service history
                HRMgt.ApprovedTransferUpdate(EmployeeTransferRec);
        end;
    end;

    local procedure SalaryLevelGradeUpdateEmpAttenAct()
    begin
        AttendanceLineRec.Reset;
        AttendanceLineRec.SetRange("Attendance Date", InitialDate, InitialDate);
        AttendanceLineRec.SetRange("Employee No.", Employee."No.");
        if AttendanceLineRec.FindFirst then begin
            AttendanceLineRec."Salary Level Code" := Employee."Salary Level";
            AttendanceLineRec."Salary Grade" := Employee."Salary Grade";
            AttendanceLineRec.Modify;
        end;
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Attendance Date", InitialDate, InitialDate);
        EmployeeAttendanceActivity.SetRange("Employee No.", Employee."No.");
        if EmployeeAttendanceActivity.FindFirst then begin
            EmployeeAttendanceActivity."Salary Level Code" := Employee."Salary Level";
            EmployeeAttendanceActivity."Salary Grade" := Employee."Salary Grade";
            EmployeeAttendanceActivity.Modify;
        end;
    end;
}
