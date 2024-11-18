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

    procedure OpenOTForms(EmpCode: Code[20])
    var
        //EmpAct: Record "Employee Activity" temporary;
        OverTime: Record OverTime temporary;
        SalaryLevel: Record "Salary Level";
        OTEligibleError: Label 'Employee %1 is not eligible for OT.';
    begin
        Clear(Employee);
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

    procedure RecommendEmployeeOverTimeAPI(EmpOverTimeCode: Code[20]; employeeNo: Code[20])
    var
        // EmpAct: Record "Employee Activity";
        OverTime: Record OverTime;
    begin
        OverTime.Get(EmpOverTimeCode);
        OverTime.TestField("Approval Status", OverTime."Approval Status"::"Pending Approval");
        CheckEmployeeOverTimeApprovalAPI(OverTime, employeeNo);
        OverTime.Validate("Approval Status", OverTime."Approval Status"::Recommended);
        OverTime.Modify;
        Message('The document has been recommended.');
    end;

    procedure ApprovedRejectOverTimeApprovalAPI(Approved: Boolean; EmpOverTimeCode: Code[20]; employeeNo: code[20])
    var

        OverTime: Record OverTime;

        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';

    begin
        OverTime.Get(EmpOverTimeCode);
        if Approved then begin
            OverTime.TestField("Approval Status", OverTime."Approval Status"::Recommended);
            CheckEmployeeOverTimeApprovalAPI(OverTime, employeeNo);
            OverTime.Validate("Approval Status", OverTime."Approval Status"::Approved);
            HRMgt.SendMailFromTemplate(DATABASE::OverTime, OverTime.Type, OverTime."Approval Status"::Approved, '', OverTime."Approver Code", OverTime."No.", 0);   //For email
            Message('The document has been approved.');
        end else
            if (OverTime."Approval Status" in [OverTime."Approval Status"::"Pending Approval", OverTime."Approval Status"::Recommended]) then begin
                OverTime.TestField("Rejection Remarks");
                CheckEmployeeOverTimeApprovalAPI(OverTime, employeeNo);
                if OverTime."Approval Status" = OverTime."Approval Status"::"Pending Approval" then
                    HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", OverTime.Type, OverTime."Approval Status"::Rejected, '', OverTime."Recommender Code", OverTime."No.", 0)  //For email
                else
                    HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", OverTime.Type, OverTime."Approval Status"::Rejected, '', OverTime."Approver Code", OverTime."No.", 0);   //For email
                OverTime.Validate("Approval Status", OverTime."Approval Status"::Rejected);
                Message('The document has been rejected.');
            end else
                Error('Cannot reject the document.');
        OverTime.Posted := true;
        OverTime."Approved Date" := Today;
        OverTime.Modify;
    end;

    procedure CheckEmployeeOverTimeApprovalAPI(OverTime: Record OverTime; employeeNo: Code[20])
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
    begin
        Employee.Reset;
        Employee.SetRange("No.", employeeNo);
        Employee.FindFirst;
        if OverTime."Approval Status" = OverTime."Approval Status"::"Pending Approval" then
            if StrPos(OverTime."Recommender Code", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);
        if OverTime."Approval Status" = OverTime."Approval Status"::Recommended then
            if StrPos(OverTime."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);

        //IF EmpAct."Approval Status" = EmpAct."Approval Status"::Approved THEN
        //IF STRPOS(EmpAct."Incoming Branch Rep. Person", Employee."No.") = 0 THEN
        //ERROR(AcknowledgeError);
    end;

    procedure ApplyForOverTimeApprovalForms(TempOvertime: Record "OverTime" temporary): Boolean
    var
        EmpOvertime: Record "OverTime";
        ConfirmForm: Label 'Do you want to send request ?';
        ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
        EmpOvertime2: Record "Overtime";
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        SalaryLevel: Record "Salary Level";
    begin
        if GuiAllowed then
            if not Confirm(ConfirmForm, false) then
                exit;
        TempOvertime.TestField("Start Date");
        TempOvertime.TestField("End Date");
        TempOvertime.TestField("Estimated Hours");
        //TempEmpAct.TESTFIELD(Remarks);
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

        EmpOvertime.Init;
        EmpOvertime.TransferFields(TempOvertime);
        EmpOvertime.Validate("Approval Status", EmpOvertime."Approval Status"::"Pending Approval");
        EmpOvertime.Validate("User ID", UserId);
        EmpOvertime.Insert(true);
        OverTimeMgt.AddOvertimeAttachment(EmpOvertime."No.", EmpOvertime."Employee No.");
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
        //EmpAct: Record "Employee Activity" temporary;
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

    var
        HRSetup: Record "Human Resources Setup";
        LeaveMgt: Codeunit "Leave Mgt.";
        Employee: Record Employee;
        PayrollSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";



}
