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

    procedure CheckOvertimeEligibility(var OverTime: Record OverTime; StartTime: Time; EndTime: Time; StandardWorkingHrs: Decimal; var TotalOTHrs: Decimal; var RejectionRemarks: Text): Boolean
    var
        // WorkShift: Record "Employee Work Shift";
        // AttendanceLog: Record "Attendance Log";
        EmployeeAttendance: Record "Employee Attendance & Activity";
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
        EmployeeAttendance.Reset;
        EmployeeAttendance.SetRange("Employee No.", OverTime."Employee No.");
        EmployeeAttendance.SetRange("Attendance Date", OverTime."Start Date");
        if EmployeeAttendance.FindFirst then begin
            if (EmployeeAttendance."Check In Time" = 0T) or (EmployeeAttendance."Check Out Time" = 0T) then begin
                Error('Check in or Check out not found.');
                //exit(false);
            end;
            if LeaveMgt.GetNonWorkingDays(OverTime."Start Date", OverTime."Start Date", OverTime."Employee No.") = 0 then begin
                // if AttendanceLog."Check Out Time" >= EndTime then begin
                if (EmployeeAttendance."Check Out Time" - EmployeeAttendance."Check In Time") < StandardWorkingHrs then begin
                    Error(StrSubstNo('Working hrs %1 hrs is less than Standard Working Hrs .', StandardWorkingHrs));
                    //exit(false);
                end;
                if (EmployeeAttendance."Check In Time" <> 0T) and (EmployeeAttendance."Check In Time" <= StartTime) then
                    MorningOTHrs := Round((StartTime - EmployeeAttendance."Check In Time") / 3600000, 0.01, '<');

                if MorningOTHrs < HRSetup."OT eligible hour" then
                    MorningOTHrs := 0;

                if (EmployeeAttendance."Check Out Time" <> 0T) and (EmployeeAttendance."Check Out Time" > EndTime) then
                    EveningOTHrs := Round((EmployeeAttendance."Check Out Time" - EndTime) / 3600000, 0.01, '<');

                if EmployeeAttendance."Check In Time" > StartTime then begin
                    CheckInDifference := Round((EmployeeAttendance."Check In Time" - StartTime) / 3600000, 0.01, '<');
                    EveningOTHrs -= CheckInDifference;
                end;
                if EveningOTHrs < HRSetup."OT eligible hour" then
                    EveningOTHrs := 0;
                OverTime."Morning OT Hours" := MorningOTHrs;
                OverTime."Evening OT Hours" := EveningOTHrs;
                TotalOTHrs := MorningOTHrs + EveningOTHrs;
                // end else begin
                //     RejectionRemarks := 'System rejected. Punch out does not exceed standard punch out time.';
                //     exit(false);
                // end;
            end else begin
                TotalOTHrs := Round((EmployeeAttendance."Check Out Time" - EmployeeAttendance."Check In Time") / 3600000, 0.01, '<');
                // if TotalOTHrs < HRSetup."OT eligible hour" then
                //     Error('Total OT hour %1 is less than OT eligible hour %2"', TotalOTHrs, HRSetup."OT eligible hour");
                //TotalOTHrs := 0;
            end;
        end else begin
            Error('Attendance Log not found.');
            // exit(false);
        end;
        exit(true);
    end;

    procedure OpenOTForms(EmpCode: Code[20])
    var
        //EmpAct: Record "Employee Activity" temporary;
        OverTime: Record OverTime temporary;
        SalaryLevel: Record "Salary Level";
        OTEligibleError: Label 'Employee %1 is not eligible for OT.';
        Approval: Record "Approval HRMS";
    begin
        Clear(Employee);
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::Overtime);
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        Employee.Get(EmpCode);
        SalaryLevel.Get(Employee."Salary Level");
        if not SalaryLevel."OT Eligible" then
            Error(OTEligibleError, Employee.FullName);
        OverTime.Init;
        OverTime.Validate("Employee No.", EmpCode);
        OverTime.Validate("Functional Title", Employee."Functional Title");
        OverTime.Validate(Type, OverTime.Type::Overtime);
        OverTime.Validate("Approval Status", OverTime."Approval Status"::Open);
        OverTime.Validate("Requested Date", Today);
        OverTime.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
        OverTime.Validate(Department, Employee."Department Code");
        OverTime.Insert;
        PAGE.Run(PAGE::"Overtime Card", OverTime);
    end;

    procedure ApplyForOverTimeApprovalForms(TempOvertime: Record "OverTime" temporary): Boolean
    var
        EmpOvertime: Record "OverTime";
        ConfirmForm: Label 'Do you want to send request ?';
        ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
        EmpOvertime2: Record "Overtime";
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        SalaryLevel: Record "Salary Level";
        IsHandled: Boolean;
    begin
        if GuiAllowed then
            if not Confirm(ConfirmForm, false) then
                exit;
        OnBeforeApplyOvertime(TempOvertime);
        TempOvertime.TestField("Start Date");
        TempOvertime.TestField("Actual OT Hours");
        TempOvertime.TestField("Overtime Claim Type");
        PayrollSetup.Get;
        PayrollSetup.TestField("Friday Counter");
        PayrollSetup.TestField("Holiday Counter");
        PayrollSetup.TestField("Evening Counter");

        case TempOvertime.Type of
            TempOvertime.Type::Overtime:
                begin
                    EmpOvertime.Reset;
                    EmpOvertime.SetRange(Type, EmpOvertime.Type::Overtime);
                    EmpOvertime.SetRange("Employee No.", TempOvertime."Employee No.");
                    EmpOvertime.SetRange("Start Date", TempOvertime."Start Date");
                    EmpOvertime.SetFilter("Approval Status", '<>%1', TempOvertime."Approval Status"::Rejected); //Min 8.7.2022
                    if EmpOvertime.FindFirst then
                        Error('Overtime already submitted for %1', TempOvertime."Start Date");

                    AllowanceAssignmentLine.Reset;
                    AllowanceAssignmentLine.SetRange("Employee Code", TempOvertime."Employee No.");
                    AllowanceAssignmentLine.SetRange("From Date", TempOvertime."Start Date");
                    AllowanceAssignmentLine.SetFilter("Allowance Type", '%1|%2|%3', PayrollSetup."Friday Counter",
                                                      PayrollSetup."Evening Counter", PayrollSetup."Holiday Counter");
                    AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
                    if AllowanceAssignmentLine.FindFirst then
                        Error('%1 is already approved for the date %2. Overtime submission not allowed.',
                                    AllowanceAssignmentLine."Allowance Type", TempOvertime."Start Date");
                    if TempOvertime.Remarks = '' then
                        Error('Please enter reason for OT before submitting.');
                end;
        end;
        // if TempOvertime."No. of Days" <= 0 then
        //     Error(ErrorNoOfDays); santosh commented for over time
        if TempOvertime."Overtime Claim Type" = TempOvertime."Overtime Claim Type"::Encashment then begin
            TempOvertime.TestField("OT Amount");
        end;
        if TempOvertime."Overtime Claim Type" = TempOvertime."Overtime Claim Type"::"Substitute Leave" then begin
            TempOvertime.TestField("Compensatory Days");
        end;
        EmpOvertime.Init;
        EmpOvertime.TransferFields(TempOvertime);
        EmpOvertime.Validate("Approval Status", EmpOvertime."Approval Status"::"Pending");
        EmpOvertime.Validate("User ID", UserId);
        EmpOvertime.Insert(true);
        //OverTimeMgt.AddOvertimeAttachment(EmpOvertime."No.", EmpOvertime."Employee No."); no require attachment
        Message('Document has been sent for apporval.');
        case EmpOvertime.Type of
            EmpOvertime.Type::"Out of Office":
                HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmpOvertime.Type::"Out of Office", EmpOvertime."Approval Status"::Open, '', EmpOvertime."Employee No.", EmpOvertime."No.", 0);   //For email
            EmpOvertime.Type::Overtime:
                HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmpOvertime.Type::Overtime, EmpOvertime."Approval Status"::Open, '', EmpOvertime."Employee No.", EmpOvertime."No.", 0);   //For email
            EmpOvertime.Type::"Bulk Cash":
                HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmpOvertime.Type::"Bulk Cash", EmpOvertime."Approval Status"::Open, '', EmpOvertime."Employee No.", EmpOvertime."No.", 0);   //For email
        end;
        exit(true);
    end;


    procedure OpenOutofOfficeForms(EmpCode: Code[20])
    var
        OverTime: Record OverTime temporary;
    begin
        Clear(Employee);
        Employee.Get(EmpCode);
        OverTime.Init;
        OverTime.Validate("Employee No.", EmpCode);
        OverTime.Validate("Functional Title", Employee."Functional Title");
        OverTime.Validate(Type, OverTime.Type::"Out of Office");
        OverTime.Validate("Approval Status", OverTime."Approval Status"::Open);
        OverTime.Validate("Requested Date", Today);
        OverTime.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
        OverTime.Validate(Department, Employee."Department Code");
        OverTime.Insert;
        PAGE.Run(PAGE::"Overtime Card", OverTime);
    end;

    procedure CheckOvertime(var OverTime: Record OverTime)
    var
        WorkShift: Record "Employee Work Shift";
        StartTime: Time;
        EndTime: Time;
        StandardWorkingHrs: Decimal;
        ActualOTHrs: Decimal;
        EmployeeWorkShift, RejectionRemarks : Text;
        ShiftLine: Record "Shift Line";
    begin
        ShiftLine.Reset();
        ShiftLine.SetRange("Employee No", OverTime."Employee No.");
        ShiftLine.SetRange("Roster Date", OverTime."Start Date");
        ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
        if ShiftLine.FindFirst() then
            EmployeeWorkShift := ShiftLine."Employee Work Shift"
        else begin
            Employee.Get(OverTime."Employee No.");
            EmployeeWorkShift := Employee."Employee Work Shift"
        end;
        Workshift.Reset;
        if not WorkShift.get(EmployeeWorkShift) then
            Error('Work shift not Found in Employee WorkShift');
        Workshift.TestField("Start Time");
        Workshift.TestField("End Time");
        Workshift.TestField("Friday End Time");
        Workshift.TestField("Winter Start Date");
        Workshift.TestField("Winter End Date");
        Workshift.TestField("Winter End Time");
        StartTime := 0T;
        EndTime := 0T;
        StandardWorkingHrs := 0;
        StartTime := WorkShift."Start Time";

        if HRMgt.IsWinter(OverTime."Start Date", Workshift) then begin
            if HRMgt.IsFriday(OverTime."Start Date") then
                EndTime := WorkShift."Friday End Time"
            else
                EndTime := WorkShift."Winter End Time";
        end else begin
            if HRMgt.IsFriday(OverTime."Start Date") then
                EndTime := WorkShift."Friday End Time"
            else
                EndTime := WorkShift."End Time";
        end;

        StandardWorkingHrs := (EndTime - StartTime) / 3600000;
        if OverTimeMgt.CheckOvertimeEligibility(OverTime, StartTime, EndTime, StandardWorkingHrs, ActualOTHrs, RejectionRemarks) then begin
            OverTime."Total OT Hours" := ActualOTHrs;
            OverTime."Actual OT Hours" := ActualOTHrs;
        end;

    end;

    procedure OTAmountCalculate(employeeNo: Code[20]; OverTimeDate: Date; EncashmentCode: Code[20]; ActualOTHours: Decimal): Decimal
    var
        SalaryLevelRec: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        OTAmount: Decimal;
    begin
        Employee.Reset();
        Employee.Get(employeeNo);
        if OverTimeDate > 20221207D then begin
            PayrollSetup.Get;
            if EmployeeAttendanceActivity.Get(employeeNo, OverTimeDate) then begin
                SalaryLevelRec.Get(Employee."Salary Level");
                SalaryGrade.Get(Employee."Salary Grade");
                if EncashmentCode = PayrollSetup.Overtime then begin
                    if Employee."Salary Level" = PayrollSetup."TA Salary Level" then
                        OTAmount := ((ActualOTHours * PayrollSetup."Over Time Calculation" / 100) * (SalaryLevelRec."TA OT Basic Salary" + (SalaryGrade."Grade Percentage" / 100 * SalaryLevelRec."TA OT Basic Salary")))
                    else if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        OTAmount := ((ActualOTHours * PayrollSetup."Over Time Calculation" / 100) * (Employee."Contract Salary Amount" + (SalaryGrade."Grade Percentage" / 100 * Employee."Contract Salary Amount")))
                    else
                        OTAmount := ((ActualOTHours * PayrollSetup."Over Time Calculation" / 100) * (SalaryLevelRec."Basic Salary" + (SalaryGrade."Grade Percentage" / 100 * SalaryLevelRec."Basic Salary")));
                end;
                exit(OTAmount);
            end;
        end;
    end;

    procedure ApproveOverTime(overTimeNo: Code[20])
    var
        OverTime: Record OverTime;
    begin
        OverTime.Get(overTimeNo);
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Attendance Date", OverTime."Start Date");
        EmployeeAttendanceActivity.SetRange("Employee No.", OverTime."Employee No.");
        if EmployeeAttendanceActivity.Findfirst then begin
            EmployeeAttendanceActivity."OT Day" := 1;
            EmployeeAttendanceActivity."OT Hrs" := overTime."Actual OT Hours";
            EmployeeAttendanceActivity.Modify(true);
        end;
        EmployeeActMgt.UpdateOvertimeInEmployeeAct(OverTime);
        if OverTime."Overtime Claim Type" = OverTime."Overtime Claim Type"::"Substitute Leave" then
            leaveEarnOverTime(overTimeNo);
    end;

    procedure leaveEarnOverTime(overTimeNo: Code[20])
    var
        OverTime: Record OverTime;
        leaveTypeSetup: Record "Leave Type Setup";
    begin
        OverTime.Get(overTimeNo);
        leaveTypeSetup.SetRange("Leave Category", leaveTypeSetup."Leave Category"::Substitute);
        if not leaveTypeSetup.FindFirst() then
            Error('Leave Type not found for Compensatory leave.');
        LeaveEarn.Init;
        LeaveEarn.Validate("Entry No.", leaveMgt.GetNextLeaveLedgerEntryNo());
        LeaveEarn.Validate("Leave Code", leaveTypeSetup."Code");
        LeaveEarn.Validate("Employee No.", OverTime."Employee No.");
        LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
        LeaveEarn.Validate("Fiscal year", OverTime."Fiscal Year");
        LeaveEarn.Validate("Posted Date", Today);
        LeaveEarn.Validate("Balancing Days", OverTime."Compensatory Days");
        LeaveEarn.Validate("Overtime Request No", OverTime."No.");
        LeaveEarn.Validate("Overtime Date", OverTime."Start Date");
        LeaveEarn.Insert(true);
    end;

    procedure OpenOTBulk(EmpCode: Code[20])
    var
        OverTime, OverTime1 : Record OverTime;
        OTEligibleError: Label 'Employee %1 is not eligible for OT.';
        Approval: Record "Approval HRMS";
    begin
        Clear(Employee);
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Overtime Bulk");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        OverTime1.Reset();
        OverTime1.SetRange("Employee No.", EmpCode);
        OverTime1.SetRange("Approval Status", OverTime1."Approval Status"::open);
        if OverTime1.Findfirst() then begin
            Message('This Employee Already has open Bulk Overtime Request.Click Ok to Open');
            PAGE.Run(PAGE::"Overtime Bulk Card", OverTime1)
        end else begin
            OverTime.Init;
            OverTime.Validate("Employee No.", EmpCode);
            OverTime.Validate(Type, OverTime.Type::"Overtime Bulk");
            OverTime.Validate("Approval Status", OverTime."Approval Status"::Open);
            OverTime.Validate("Requested Date", Today);
            OverTime.Insert(true);
            PAGE.Run(PAGE::"Overtime Bulk Card", OverTime);
        end;
    end;

    procedure GetOvertimeLineDetails(OvertimeNo: Code[20])
    var
        WorkShift: Record "Employee Work Shift";
        StartTime, EndTime : Time;
        ActualOTHrs, MorningOTHrs, EveningOTHrs, StandardWorkingHrs : Decimal;
        CheckInDifference, TotalOTHrs : Decimal;
        OvertimeLine: Record "Overtime Line";
        IsHandled: Boolean;
        Overtime: Record OverTime;
        ShiftLine: Record "Shift Line";
        EmployeeWorkShift: Text;
    begin
        Overtime.Reset;
        Overtime.Get(OvertimeNo);
        Overtime.TestField("Get Employee", true);
        OvertimeLine.Reset;
        OvertimeLine.SetRange("No.", OvertimeNo);
        if OvertimeLine.FindSet() then
            repeat
                ShiftLine.Reset();
                ShiftLine.SetRange("Employee No", OverTime."Employee No.");
                ShiftLine.SetRange("Roster Date", OverTime."Start Date");
                ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
                if ShiftLine.FindFirst() then
                    EmployeeWorkShift := ShiftLine."Employee Work Shift"
                else begin
                    Employee.Get(OverTime."Employee No.");
                    EmployeeWorkShift := Employee."Employee Work Shift"
                end;
                Workshift.Reset;
                if not WorkShift.get(EmployeeWorkShift) then
                    Error('Work shift not Found in Employee WorkShift');
                Workshift.TestField("Start Time");
                Workshift.TestField("End Time");
                Workshift.TestField("Friday End Time");
                Workshift.TestField("Winter Start Date");
                Workshift.TestField("Winter End Date");
                Workshift.TestField("Winter End Time");
                StartTime := 0T;
                EndTime := 0T;
                StandardWorkingHrs := 0;
                StartTime := WorkShift."Start Time";
                if HRMgt.IsWinter(OvertimeLine."Overtime Date", Workshift) then begin
                    if HRMgt.IsFriday(OvertimeLine."Overtime Date") then
                        EndTime := WorkShift."Friday End Time"
                    else
                        EndTime := WorkShift."Winter End Time";
                end else begin
                    if HRMgt.IsFriday(OvertimeLine."Overtime Date") then
                        EndTime := WorkShift."Friday End Time"
                    else
                        EndTime := WorkShift."End Time";
                end;
                StandardWorkingHrs := (EndTime - StartTime) / 3600000;

                HRSetup.Get;
                HRSetup.TestField("OT eligible hour");
                MorningOTHrs := 0;
                EveningOTHrs := 0;
                TotalOTHrs := 0;
                CheckInDifference := 0;
                OnBeforeCheckOTHrs(OvertimeLine, StartTime, EndTime, IsHandled);
                if not IsHandled then
                    if LeaveMgt.GetNonWorkingDays(OvertimeLine."Overtime Date", OvertimeLine."Overtime Date", OvertimeLine."Employee Code") = 0 then begin
                        if (OvertimeLine."Check In Time" <= StartTime) then
                            MorningOTHrs := Round((StartTime - OvertimeLine."Check In Time") / 3600000, 0.01, '<');

                        if MorningOTHrs < HRSetup."OT eligible hour" then
                            MorningOTHrs := 0;

                        if (OvertimeLine."Check Out Time" <> 0T) and (OvertimeLine."Check Out Time" > EndTime) then
                            EveningOTHrs := Round((OvertimeLine."Check Out Time" - EndTime) / 3600000, 0.01, '<');

                        if OvertimeLine."Check In Time" > StartTime then begin
                            CheckInDifference := Round((OvertimeLine."Check In Time" - StartTime) / 3600000, 0.01, '<');
                            EveningOTHrs -= CheckInDifference;
                        end;
                        if EveningOTHrs < HRSetup."OT eligible hour" then
                            EveningOTHrs := 0;
                        OvertimeLine."Morning OT Hours" := MorningOTHrs;
                        OvertimeLine."Evening OT Hours" := EveningOTHrs;
                        OvertimeLine."Total OT Hours" := MorningOTHrs + EveningOTHrs;
                        OvertimeLine."Actual OT hours" := OvertimeLine."Total OT Hours";
                        OverTimeMgt.OTAmountCalculate(OvertimeLine."Employee Code", OvertimeLine."Overtime Date", '', OvertimeLine."Actual OT hours");
                    end else begin
                        OvertimeLine."Total OT Hours" := Round((OvertimeLine."Check Out Time" - OvertimeLine."Check In Time") / 3600000, 0.01, '<');
                        OvertimeLine."Actual OT hours" := OvertimeLine."Total OT Hours";
                        OverTimeMgt.OTAmountCalculate(OvertimeLine."Employee Code", OvertimeLine."Overtime Date", '', OvertimeLine."Actual OT hours");
                    end;
                OvertimeLine.Modify();
                if OvertimeLine."Total OT Hours" <= 0 then begin
                    OvertimeLine.Delete(true);
                end;
            until OvertimeLine.Next() = 0;
        Overtime."Calculate Overtime" := true;
        Overtime.Modify();
    end;

    procedure GetEmployee(var OverTime: Record OverTime)
    var
        OvertimeLine, OvertimeLineCheck : Record "Overtime Line";
        EmployeeAttendance: Record "Employee Attendance & Activity";
        CurrentDate: Date;
    begin
        OvertimeLineCheck.Reset;
        OvertimeLineCheck.SetRange("No.", OverTime."No.");
        OvertimeLineCheck.SetRange("Approval Status", OvertimeLineCheck."Approval Status"::Open);
        OvertimeLineCheck.DeleteAll(); // Delete existing lines for the Overtime record      
        Employee.Reset();
        if OverTime."Deputation Type" = OverTime."Deputation Type"::Department then
            Employee.SetRange("Deputation on", Employee."Deputation on"::Department)
        else begin
            Employee.SetRange("Deputation on", Employee."Deputation on"::Branch);
            Employee.SetRange("Deputation On code", OverTime."Deputation Code");
        end;
        Employee.SetRange("Staff level", Employee."Staff level"::"Non Clerical Staff");
        if Employee.FindSet() then
            repeat
                // Loop through each date in the range
                CurrentDate := OverTime."Start Date";
                while CurrentDate <= OverTime."End Date" do begin
                    // Check if overtime line already exists for this specific employee and date
                    OvertimeLineCheck.Reset;
                    OvertimeLineCheck.SetRange("Employee Code", Employee."No.");
                    OvertimeLineCheck.SetRange("Overtime Date", CurrentDate);
                    OvertimeLineCheck.SetFilter("Approval Status", '<>%1', OvertimeLine."Approval Status"::Canceled);
                    // Only create overtime line if it doesn't exist for this specific date
                    if not OvertimeLineCheck.FindFirst() then begin
                        // Check if employee attendance exists for this date
                        EmployeeAttendance.Reset;
                        if EmployeeAttendance.Get(Employee."No.", CurrentDate) then begin
                            // Only create overtime line if both check-in and check-out times exist
                            if (EmployeeAttendance."Check In Time" <> 0T) and (EmployeeAttendance."Check Out Time" <> 0T) then begin
                                OvertimeLine.Init();
                                OverTimeLine.Validate("No.", OverTime."No.");
                                OvertimeLine.Validate("Employee Code", Employee."No.");
                                OvertimeLine.Validate("Employee Name", Employee.FullName);
                                OvertimeLine.Validate("Employee Work Shift", Employee."Employee Work Shift");
                                OvertimeLine.Validate("Deputation Type", OverTime."Deputation Type");
                                OvertimeLine.Validate(Code, OverTime."Deputation Code");
                                OvertimeLine.Validate(Name, OverTime."Deputation Name");
                                OvertimeLine.Validate(Type, OverTime.Type);
                                OvertimeLine.Validate("Overtime Date", CurrentDate);
                                OvertimeLine.Validate("Check In Time", EmployeeAttendance."Check In Time");
                                OvertimeLine.Validate("Check Out Time", EmployeeAttendance."Check Out Time");
                                OvertimeLine.Validate("Approval Status", OvertimeLine."Approval Status"::Open);
                                GetLineNo(OvertimeLine);
                                OvertimeLine.Insert();
                            end;
                        end;
                    end;
                    CurrentDate := CurrentDate + 1;
                end;
            until Employee.Next() = 0;
        OverTime."Get Employee" := true;
        OverTime."Calculate Overtime" := false; // Reset Calculate Overtime flag
        OverTime.Modify();

    end;

    procedure GetLineNo(var OvertimeLine: Record "Overtime Line")
    var
        OvertimeLine1: Record "Overtime Line";
    begin
        OvertimeLine1.Reset;
        OvertimeLine1.SetCurrentKey("No.", "Line No.");
        OvertimeLine1.SetRange("No.", OvertimeLine."No.");
        if OvertimeLine1.FindLast then
            OvertimeLine."Line No." := OvertimeLine1."Line No." + 10000
        else
            OvertimeLine."Line No." := 10000;
    end;

    procedure SendApprovalOvertimeBulk(var Overtime: Record OverTime; var OvertimeLine: Record "Overtime Line")
    var
        OverLineCheck: Record "Overtime Line";
        ApproverMgt: Codeunit "Approver Mgt";
    begin
        Overtime.TestField("Get Employee", true);
        Overtime.TestField("Calculate Overtime", true);
        ApproverMgt.UpdateFirstApproverStatus(Overtime."No.");
        OverLineCheck.Copy(OvertimeLine);
        if OverLineCheck.FindFirst then
            repeat
                OverLineCheck.TestField("Employee Code");
                OverLineCheck.TestField("Overtime Date");
                OverLineCheck.TestField("Total OT Hours");
                OverLineCheck.TestField("OT Amount");
            until OverLineCheck.Next = 0;
        Overtime.Validate("Approval Status", Overtime."Approval Status"::"Pending");
        Overtime.Modify(true);
        OvertimeLine.ModifyAll("Approval Status", OvertimeLine."Approval Status"::"Pending");
    end;

    procedure ApproveRejectOvertimeLine(Approved: Boolean; DocumentNo: Code[20])
    var
        overtime: Record OverTime;
        OvertimeLine: Record "Overtime Line";
        ApprovalLine: Record "Approval HRMS";
        ApproverMgt: Codeunit "Approver Mgt";
    begin
        overtime.Get(DocumentNo);
        OvertimeLine.Reset;
        OvertimeLine.SetRange("No.", DocumentNo);
        OvertimeLine.SetRange("Approval Status", OvertimeLine."Approval Status"::"Pending");
        if OvertimeLine.Findset() then
            repeat
                if Approved then begin
                    InsertOvertimeLineInAttendance(OvertimeLine);
                    EmployeeActMgt.UpdateOvertimeLineInEmployeeAct(OvertimeLine);
                    OvertimeLine.Validate("Approval Status", OvertimeLine."Approval Status"::Approved);
                    OvertimeLine.Validate("Approved Date", Today);
                    OvertimeLine.Modify();
                end;
            until OvertimeLine.Next() = 0;
        if not Approved then begin
            OvertimeLine.ModifyAll("Approval Status", OvertimeLine."Approval Status"::open);
            ApprovalLine.Reset();
            ApprovalLine.SetRange("Document No.", DocumentNo);
            ApprovalLine.DeleteAll(true);
            ApproverMgt.InsertApproval(overtime."Employee No.", DocumentNo, overtime."Type"::"Overtime Bulk", overtime."Approval Status"::open);
        end;

    end;

    procedure InsertOvertimeLineInAttendance(OvertimeLine: Record "Overtime Line")
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
    begin
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Attendance Date", OvertimeLine."Overtime Date");
        EmployeeAttendanceActivity.SetRange("Employee No.", OvertimeLine."Employee Code");
        if EmployeeAttendanceActivity.FindFirst then begin
            EmployeeAttendanceActivity."OT Day" := 1;
            EmployeeAttendanceActivity."OT Hrs" := OvertimeLine."Actual OT Hours";
        end;
        EmployeeAttendanceActivity.Modify;
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeApplyOvertime(Overtime: Record OverTime)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCheckOTHrs(var OvertimeLine: Record "Overtime Line"; StartTime: Time; EndTime: Time; var IsHandled: Boolean)
    begin
    end;

    var
        HRSetup: Record "Human Resources Setup";
        LeaveMgt: Codeunit "Leave Mgt.";
        Employee: Record Employee;
        PayrollSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        LeaveEarn: Record "Leave Earn";
        EmployeeActMgt: Codeunit EmployeeActivityMgt;
}
