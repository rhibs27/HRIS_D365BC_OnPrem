codeunit 50000 "Leave Mgt."
{
    procedure OpenLeaveRequest(EmpCode: Code[20])
    var
        leaveRequest, LeaveRequest2 : record leave;
        Approval: Record "Approval HRMS";
    begin
        Clear(Employee);
        // Clear Approval line 
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Leave Request");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();

        Employee.Get(EmpCode);
        leaveRequest.Reset();
        leaveRequest.SetRange("Employee No.", EmpCode);
        leaveRequest.SetRange("Approval Status", leaveRequest."Approval Status"::open);
        if leaveRequest.Findfirst() then begin
            Message('This Employee Already has open Leave Request.Click Ok to Open');
            PAGE.Run(PAGE::"Leave Request", leaveRequest)
        end else begin
            LeaveRequest2.Init;
            LeaveRequest2.Validate("Functional Title", Employee."Functional Title");
            LeaveRequest2.Validate("Employee No.", EmpCode);
            LeaveRequest2.Validate(Type, LeaveRequest2.Type::"Leave Request");
            LeaveRequest2.Validate("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
            LeaveRequest2.Validate("Approval Status", LeaveRequest2."Approval Status"::Open);
            LeaveRequest2.Validate("Employee Work Shift", Employee."Employee Work Shift");
            LeaveRequest2.Validate("Leave Type", LeaveRequest2."Leave Type"::"Full Day");
            LeaveRequest2.Validate("Requested Date", Today);
            LeaveRequest2.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
            LeaveRequest2.Validate(Department, Employee."Department Code");
            LeaveRequest2.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Leave Request", LeaveRequest2);
        end;

    end;

    procedure CalculateNoOfDays(StartDate: Date; EndDate: Date; LeaveCode: Code[20]; Type: Enum "Employee Activity Type"; LeaveType: Enum "Leave Type"; Empcode: Code[20]): Decimal
    var
        DateError: Label 'Start Date (%1) must be less than End Date (%2).';
        LeaveTypeSetup: Record "Leave Type Setup";
        Difference: Decimal;
    begin
        if StartDate > EndDate then
            Error(DateError, StartDate, EndDate);
        if Type = Type::"Leave Request" then begin
            if LeaveTypeSetup.Get(LeaveCode) then begin
                if LeaveType = LeaveType::"Full Day" then
                    Difference := 1
                else
                    Difference := 0.5;
                if LeaveTypeSetup."Exclude Non Working Days" then
                    exit(EndDate - StartDate + Difference - GetNonWorkingDays(StartDate, EndDate, Empcode))
                else
                    exit(EndDate - StartDate + Difference);
            end;
        end else
            exit(EndDate - StartDate + 1);
    end;

    procedure GetNonWorkingDays(StartDate: Date; EndDate: Date; EmpCode: Code[20]): Integer
    var
        Description: Text;
        Proviences: Text;
        Gender: Enum "Employee Gender";
        ProviencesVar: Record Province;
        CalendarDate: Record Date;
        CalendarMgmt: Codeunit "Calendar Management";
        Counter: Integer;
        AlreadyAdded: Boolean;
        BaseCalendar: Record "Base Calendar";
        InOutValley: Option " ",Outside,Inside;
        PostingRegion: Option " ",Hilly,Terai;
        Branch: Text;
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        Community: Enum "Community Type";
    begin
        Counter := 0;
        PayrollSetup.Get;
        Employee.Get(EmpCode);
        BaseCalendar.Reset;
        BaseCalendar.FindFirst;
        CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Date);
        CalendarDate.SetRange("Period Start", StartDate, EndDate);
        if CalendarDate.Find('-') then
            repeat
                Clear(AlreadyAdded);
                if HRMgt.CheckDateStatus(BaseCalendar.Code, CalendarDate."Period Start", Description, Proviences, Gender, InOutValley, PostingRegion, Branch, Community) then begin
                    CalendarDescription := Description;
                    if (Proviences = '') and (Gender = Gender::" ") and (InOutValley = InOutValley::" ") and (PostingRegion = PostingRegion::" ") and (Branch = '') and (community = community::" ") then
                        Counter += 1
                    else begin
                        if Proviences <> '' then begin
                            ProviencesVar.Reset;
                            ProviencesVar.SetFilter(Code, Proviences);
                            if ProviencesVar.Find('-') then
                                repeat
                                    if (Employee."Province Code" = ProviencesVar.Code) and (not AlreadyAdded) then begin
                                        Counter += 1;
                                        AlreadyAdded := true;
                                        break;
                                    end;
                                until ProviencesVar.Next = 0;
                        end;

                        if (Gender = Employee.Gender) and (Gender <> Gender::" ") and (not AlreadyAdded) then begin
                            Counter += 1;
                            AlreadyAdded := true;
                            // BREAK;
                        end;

                        if (PostingRegion = Employee."Posting Region") and (PostingRegion <> PostingRegion::" ") and (not AlreadyAdded) then begin
                            Counter += 1;
                            AlreadyAdded := true;
                            //BREAK;
                        end;

                        if (Branch <> '') and (not AlreadyAdded) then begin
                            GLSetup.Get;
                            DimValue.Reset;
                            DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
                            DimValue.SetFilter(Code, Branch);
                            if DimValue.Find('-') then
                                repeat
                                    if (DimValue.Code = Employee."Global Dimension 1 Code") and (not AlreadyAdded) then begin
                                        Counter += 1;
                                        AlreadyAdded := true;
                                        break;
                                    end;
                                until DimValue.Next = 0;
                        end;
                        if (InOutValley = Employee."Inside/Outside Valley") and (InOutValley <> InOutValley::" ") and (not AlreadyAdded) then begin
                            Counter += 1;
                            AlreadyAdded := true;
                        end;

                        if Community = Employee.Community then begin
                            Counter += 1;
                            AlreadyAdded := true
                        end;

                    end;

                end;
            until CalendarDate.Next = 0;

        exit(Counter);
    end;

    procedure CheckLeaveConflict(EmpCode: Code[20]; StartDate: Date; EndDate: Date)
    var
        leave: Record Leave;
        NoOfRecrod: Integer;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
    begin
        //check for leave conflict..
        leave.Reset;
        leave.SetRange("Employee No.", EmpCode);
        leave.SetFilter(Type, '%1|%2', leave.Type::"Leave Request", leave.Type::"Attendance Missed");
        leave.SetFilter("Approval Status", '%1|%2', leave."Approval Status"::Pending, leave."Approval Status"::Approved);
        leave.SetRange("Cancelled No.", '');
        leave.SetRange(Cancelled, false);
        leave.FilterGroup(-1);
        leave.SetRange("Start Date", StartDate, EndDate);
        leave.SetRange("End Date", StartDate, EndDate);
        leave.FilterGroup(0);

        NoOfRecrod := leave.Count;
        if NoOfRecrod <> 0 then
            Error('Leave has already been request between %1 to %2', StartDate, EndDate);
        EngNep.Reset;
        EngNep.SetRange("English Date", Today);
        if EngNep.FindFirst then;

        leave.Reset;
        leave.SetRange("Employee No.", EmpCode);
        leave.SetFilter(Type, '%1|%2', leave.Type::"Leave Request", leave.Type::"Attendance Missed");
        leave.SetRange("Cancelled No.", '');
        leave.SetRange(Cancelled, false);
        leave.SetFilter("Approval Status", '%1|%2', leave."Approval Status"::Approved, leave."Approval Status"::Pending);
        if leave.FindSet() then
            repeat
                if ((StartDate > leave."Start Date") and (StartDate < leave."End Date")) or
                    ((EndDate > leave."Start Date") and (EndDate < leave."End Date")) then
                    Error('Leave has already been request between %1 to %2', StartDate, EndDate);
            until leave.Next = 0;
        // EmpAttendanceActivity.Reset; //Min 4.11.2022
        // EmpAttendanceActivity.SetRange("Employee No.", EmpCode);
        // EmpAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
        // if EmpAttendanceActivity.FindFirst then
        //     repeat
        //         if EmpAttendanceActivity."Present Day" = 1 then
        //             Error(LeaveError, EmpAttendanceActivity."Attendance Date");
        //     until EmpAttendanceActivity.Next = 0;
    end;

    procedure CheckForLeaveCriteria(LeaveCode: Code[20]; StartDate: Date; EndDate: Date; EmpCode: Code[20]; NoofDays: Decimal)
    var
        //EmpAct: Record "Employee Activity";
        Leave: Record Leave;
        LeaveTypeSetup: Record "Leave Type Setup";
        NoLeaveDaysError: Label 'You do not have enough leave Days.';
        LeaveEarn: Record "Leave Earn";
    begin
        //check leave criteria
        LeaveTypeSetup.Get(LeaveCode);
        Employee.Get(EmpCode);
        if LeaveTypeSetup."Services Period" then begin
            Leave.Reset;
            Leave.SetRange("Employee No.", EmpCode);
            Leave.SetRange("Leave Code", LeaveCode);
            Leave.SetFilter("Approval Status", '<>%1&<>%2', Leave."Approval Status"::Rejected, Leave."Approval Status"::Canceled);
            Leave.SetRange(Posted, true);
            if Leave.Count >= LeaveTypeSetup."Times Per Service Period" then
                Error('You cannot apply for %1 leave anymore.', LeaveTypeSetup.Description);
        end;

        if not (LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::" ") then begin
            if LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::Permanent then
                Employee.TestField("Employment Type", Employee."Employment Type"::Permanent);
            if LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::Probation then
                Employee.TestField("Employment Type", Employee."Employment Type"::Probation);
            if LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::Contract then
                Employee.TestField("Employment Type", Employee."Employment Type"::Contract);
        end;

        if not (LeaveTypeSetup.Gender = LeaveTypeSetup.Gender::" ") then
            Employee.TestField(Gender, LeaveTypeSetup.Gender);

        if LeaveTypeSetup."Leave at Once" then begin
            LeaveEarn.Reset;
            LeaveEarn.SetRange("Leave Code", LeaveTypeSetup.Code);
            LeaveEarn.SetRange("Fiscal year", HRMgt.ReturnFiscalYear(StartDate));
            LeaveEarn.SetRange(EmpNo, Employee."No.");
            LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
            if LeaveEarn.FindLast then;
            if not (LeaveEarn."Balancing Days" = NoofDays) then
                Error('Please select correct date as requested days must be equal to leave balance. Requested Days : %1 and Balance Days : %2', NoofDays, LeaveEarn."Balancing Days");
        end;

        LeaveTypeSetup.SetRange("Employee No. Filter", EmpCode);
        LeaveTypeSetup.SetRange(Code, LeaveCode);
        if LeaveTypeSetup.FindFirst then
            LeaveTypeSetup.CalcFields("Remaining Days");
        if (not LeaveTypeSetup.Compensatory) and (not LeaveTypeSetup."Skip Balance Check") then
            if LeaveTypeSetup."Remaining Days" < NoofDays then
                Error(NoLeaveDaysError);
    end;

    procedure CheckForMulipleRequest(LeaveCode: Code[20]; EmpCode: Code[20]; StartDate: Date; EndDate: Date; NoOfDays: Decimal)
    var
        //EmpAct: Record "Employee Activity";
        Leave: Record Leave;
        LeaveTypeSetup: Record "Leave Type Setup";
        ErrorforConsecutive: Label 'Your %1 Leave has exceeded maximum days limit as %1 cannot exceed %2 consecutive days.';
    begin
        LeaveTypeSetup.Get(LeaveCode);
        if LeaveTypeSetup."Limit Max. Leave at Once" then begin
            Leave.Reset;
            Leave.SetRange("Leave Code", LeaveCode);
            Leave.SetRange("Employee No.", EmpCode);
            Leave.SetRange("Approval Status", Leave."Approval Status"::Approved);
            Leave.SetRange("End Date", StartDate - 1);
            if Leave.FindFirst then begin
                if LeaveTypeSetup."Maximum Leave at once" < NoOfDays + Leave."No. of Days" then
                    Error(ErrorforConsecutive, LeaveCode, LeaveTypeSetup."Maximum Leave at once")
                else
                    CheckForMulipleRequest(LeaveCode, EmpCode, StartDate - 1, EndDate, NoOfDays + Leave."No. of Days");
            end;
            Clear(Leave);
            Leave.SetRange("Leave Code", LeaveCode);
            Leave.SetRange("Employee No.", EmpCode);
            Leave.SetRange("Start Date", EndDate + 1);
            if Leave.FindFirst then begin
                if LeaveTypeSetup."Maximum Leave at once" < NoOfDays + Leave."No. of Days" then
                    Error(ErrorforConsecutive, LeaveCode, LeaveTypeSetup."Maximum Leave at once")
                else
                    CheckForMulipleRequest(LeaveCode, EmpCode, StartDate, EndDate + 1, NoOfDays + Leave."No. of Days");
            end;
        end;
    end;

    procedure UpdateLeaveEmployee(EmpCode: Code[20]; JoiningDate: Date; EmployeeType: Enum "Employee Type"; Gender: enum "Employee Gender"; MaritalStatus: Enum "Marital Status")
    var
        LeaveEarn: Record "Leave Earn";
        LeavetypSetup: Record "Leave Type Setup";
    begin
        CheckBetweenFiscalYear;
        PayrollSetup.Get;
        Employee.Get(EmpCode);
        if Employee."Employment Type" = Employee."Employment Type"::Permanent then
            Employee.TestField("Confirmation Date");
        EngNep.Reset;
        EngNep.SetRange("English Date", Today);
        if EngNep.FindFirst then;
        UpdatePreviousYearleave;
        LeavetypSetup.Reset;
        LeavetypSetup.SetFilter("Leave For Employee Type", '%1|%2', EmployeeType, LeavetypSetup."Leave For Employee Type"::" ");
        LeavetypSetup.SetFilter(Gender, '%1|%2', Gender, LeavetypSetup.Gender::" ");
        LeavetypSetup.SetFilter("Marital Status", '%1|%2', MaritalStatus, LeavetypSetup."Marital Status"::" ");
        LeavetypSetup.SetRange(Compensatory, false);
        LeavetypSetup.SetRange("Needed HR Permission", false);
        LeavetypSetup.SetRange("Skip Balance Check", false);
        if LeavetypSetup.FindSet() then
            repeat
                Clear(LeaveEarn);
                LeaveEarn.SetRange("Leave Code", LeavetypSetup.Code);
                LeaveEarn.SetRange(EmpNo, EmpCode);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                if not LeavetypSetup."Services Period" then
                    LeaveEarn.SetRange("Fiscal year", EngNep."Fiscal Year");
                if not LeaveEarn.FindFirst then begin
                    LeaveEarn.Init;
                    LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                    LeaveEarn.Validate(EmpNo, EmpCode);
                    LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
                    LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                    LeaveEarn.Validate("Posted Date", Today);
                    if LeavetypSetup."AML Eligible" then begin
                        if Employee."Confirmation Date" <= PayrollSetup."Payroll Fiscal Year Start Date" then begin
                            if not LeavetypSetup."Calculate Proratawise" then
                                LeaveEarn.Validate("Balancing Days", LeavetypSetup."Days Earned Per Year")
                            else
                                LeaveEarn.Validate("Balancing Days", CalculateProDataLeave(LeavetypSetup.Code, Employee."Confirmation Date"));
                            if LeaveEarn."Balancing Days" <> 0 then
                                LeaveEarn.Insert(true);
                        end;
                    end else begin
                        if not LeavetypSetup."Calculate Proratawise" then
                            LeaveEarn.Validate("Balancing Days", LeavetypSetup."Days Earned Per Year")
                        else
                            LeaveEarn.Validate("Balancing Days", CalculateProDataLeave(LeavetypSetup.Code, JoiningDate));
                        if LeaveEarn."Balancing Days" <> 0 then
                            LeaveEarn.Insert(true);
                    end;
                end;
            until LeavetypSetup.Next = 0;
    end;

    local procedure UpdatePreviousYearleave()
    var
        LeaveEarn: Record "Leave Earn";
        LeavetypSetup: Record "Leave Type Setup";
        EnglishNepaliDate: Record "English-Nepali Date";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("English Date", CalcDate('-1Y+1M', Today));
        if EnglishNepaliDate.FindFirst then;
        LeavetypSetup.Reset;
        LeavetypSetup.SetRange(Compensatory, false);
        LeavetypSetup.SetRange("Needed HR Permission", false);
        LeavetypSetup.SetRange("Skip Balance Check", false);
        LeavetypSetup.SetRange("Employee No. Filter", Employee."No.");
        if LeavetypSetup.Find('-') then
            repeat
                LeavetypSetup.CalcFields("Remaining Days");
                HRSetup.Get; //Min 7.11.2022
                if LeavetypSetup."Remaining Days" > 0 then begin
                    if not LeavetypSetup."Carry Forwardable" then begin
                        LeaveEarn.Init;
                        LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                        LeaveEarn.Validate(EmpNo, Employee."No.");
                        LeaveEarn.Validate(Type, LeaveEarn.Type::"Balance via Fiscal Year");
                        LeaveEarn.Validate("Fiscal year", EnglishNepaliDate."Fiscal Year");
                        LeaveEarn.Validate("Posted Date", Today);
                        LeaveEarn.Validate("Balancing Days", -LeavetypSetup."Remaining Days");
                        DocNo := NoSeriesMgt.GetNextNo(HRSetup."Leave Earn No.", Today, true);
                        LeaveEarn.Validate("Entry No.", DocNo);
                        LeaveEarn.Insert();
                    end else if LeavetypSetup."Encashable Limit" < LeavetypSetup."Remaining Days" then begin
                        LeaveEarn.Init;
                        LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                        LeaveEarn.Validate(EmpNo, Employee."No.");
                        LeaveEarn.Validate(Type, LeaveEarn.Type::Encashed);
                        LeaveEarn.Validate("Fiscal year", EnglishNepaliDate."Fiscal Year");
                        LeaveEarn.Validate("Posted Date", Today);
                        LeaveEarn.Validate("Balancing Days", -(LeavetypSetup."Remaining Days" - LeavetypSetup."Encashable Limit"));
                        DocNo := NoSeriesMgt.GetNextNo(HRSetup."Leave Earn No.", Today, true);
                        LeaveEarn.Validate("Entry No.", DocNo);
                        LeaveEarn.Insert();
                    end;
                end;
            until LeavetypSetup.Next = 0;
    end;

    procedure UpdateLeaveEmployeeContract(EmpCode: Code[20]; JoiningDate: Date; EmployeeType: Option " ",Permanent,Probation,Contract; Gender: Option " ",Female,Male; MaritalStatus: Option)
    var
        LeaveEarn: Record "Leave Earn";
        LeavetypSetup: Record "Leave Type Setup";
        HRSetup: Record "Human Resources Setup";
        SalaryLevel: Record "Salary Level";
        EmployeeRec: Record Employee;
    begin
        CheckBetweenFiscalYear;
        EngNep.Reset;
        EngNep.SetRange("English Date", Today);
        if EngNep.FindFirst then;

        CheckBetweenFiscalYear;
        EmployeeRec.Get(EmpCode);
        EmployeeRec.TestField("Salary Level");
        SalaryLevel.Get(EmployeeRec."Salary Level");

        LeavetypSetup.Reset;
        LeavetypSetup.SetFilter("Leave For Employee Type", '%1|%2', EmployeeType, LeavetypSetup."Leave For Employee Type"::" ");
        LeavetypSetup.SetFilter(Gender, '%1|%2', Gender, LeavetypSetup.Gender::" ");
        LeavetypSetup.SetFilter("Marital Status", '%1', MaritalStatus);
        LeavetypSetup.SetRange(Compensatory, false);
        LeavetypSetup.SetRange("Needed HR Permission", false);
        LeavetypSetup.SetRange("Skip Balance Check", false);
        if LeavetypSetup.Find('-') then
            repeat
                Clear(LeaveEarn);
                LeaveEarn.SetRange("Leave Code", LeavetypSetup.Code);
                LeaveEarn.SetRange(EmpNo, EmpCode);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                if not LeaveEarn.FindFirst then begin
                    LeaveEarn.Init;
                    LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                    LeaveEarn.Validate(EmpNo, EmpCode);
                    LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
                    LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                    LeaveEarn.Validate("Posted Date", Today);
                    if not LeavetypSetup."Calculate Proratawise" then
                        LeaveEarn.Validate("Balancing Days", SalaryLevel."Leave Balance (Contract Staff)");
                    if LeaveEarn."Balancing Days" <> 0 then
                        LeaveEarn.Insert(true);
                end;
            until LeavetypSetup.Next = 0;
    end;

    procedure CheckBetweenFiscalYear()
    begin
        PayrollSetup.Get;
        if (Today < PayrollSetup."Payroll Fiscal Year Start Date") or (Today > PayrollSetup."Payroll Fiscal Year End Date") then
            Error('Date must between %1 and %2', PayrollSetup."Payroll Fiscal Year Start Date", PayrollSetup."Payroll Fiscal Year End Date");
    end;

    procedure CalculateProDataLeave(LeaveCode: Code[20]; JoiningDate: Date): Decimal
    var
        TotalRemainingMonth: Decimal;
        LeaveTypeSetup: Record "Leave Type Setup";
        PayorllSetup: Record "Payroll General Setup";
    begin
        PayrollSetup.Get;
        LeaveTypeSetup.Get(LeaveCode);
        if JoiningDate > PayrollSetup."Payroll Fiscal Year Start Date" then begin
            //TotalRemainingMonth:=ROUND((PayrollSetup."Payroll Fiscal Year End Date"-JoiningDate)/30.5,0.01,'=');
            exit(Round((PayrollSetup."Payroll Fiscal Year End Date" - JoiningDate + 1) / 365 * LeaveTypeSetup."Days Earned Per Year", 1, '<'));
        end else
            exit(LeaveTypeSetup."Days Earned Per Year");
    end;

    procedure CheckRemainingLeaveDays(LeaveCode: Code[20]; EmpCode: Code[20]; NoofDays: Decimal)
    var
        LeaveTypeSetup: Record "Leave Type Setup";
    begin
        //check remaining leave days
        LeaveTypeSetup.Reset;
        LeaveTypeSetup.SetRange(Code, LeaveCode);
        LeaveTypeSetup.SetFilter("Employee No. Filter", EmpCode);
        if LeaveTypeSetup.FindFirst then
            LeaveTypeSetup.CalcFields("Remaining Days");

        if not LeaveTypeSetup."Skip Balance Check" then
            if LeaveTypeSetup."Remaining Days" < NoofDays then
                Error('You do not have enough remaining days for leave %1', LeaveTypeSetup.Description);
    end;

    procedure CheckForEmployeeLimit(LeaveCode: Code[20]; EmpCode: Code[20])
    var
        LeaveTypeSetup: Record "Leave Type Setup";
        DateExpr: Text;
    begin
        LeaveTypeSetup.Get(LeaveCode);
        Clear(Employee);
        Employee.Get(EmpCode);

        if LeaveTypeSetup."Employment Limit" <> 0 then begin
            DateExpr := '<' + Format(LeaveTypeSetup."Employment Limit") + 'Y>';
            if Today < CalcDate(DateExpr, Employee."Employment Date") then
                Error('You are not eligible to apply for leave %1', LeaveTypeSetup.Description);
        end;
    end;

    procedure CheckForLimitDays(LeaveCode: Code[20]; NoOfDays: Decimal)
    var
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveReq: Record Leave;
    begin
        LeaveTypeSetup.Get(LeaveCode);
        if LeaveTypeSetup."Limit Max. Leave at Once" then
            if NoOfDays > LeaveTypeSetup."Maximum Leave at once" then
                Error('Applied Leave Days for %1 cannot exceed %2.', LeaveTypeSetup.Description, LeaveTypeSetup."Maximum Leave at once");
        If (NoOfDays < LeaveTypeSetup."Minimum Leave at once") then
            Error('Applied Leave Days for %1 must be between %2 and %3.', LeaveTypeSetup.Description, LeaveTypeSetup."Minimum Leave at once", LeaveTypeSetup."Maximum Leave at once");
    end;

    procedure LookupDependability(LeaveCode: Code[20]): Text[100]
    var
        LeaveTypeSetup: Record "Leave Type Setup";
        PageLeaveTypeSetup: Page "Leave Type Setup";
        PrevLeaveCode: Text[100];
        LeaveTypeSetup2: Record "Leave Type Setup";
    begin
        Clear(PageLeaveTypeSetup);
        Clear(LeaveTypeSetup);
        LeaveTypeSetup.SetFilter("Depending Leave", '<>%1', '');
        if LeaveTypeSetup.Find('-') then
            repeat
                Clear(LeaveTypeSetup2);
                LeaveTypeSetup2.SetFilter(Code, LeaveTypeSetup."Depending Leave");
                if LeaveTypeSetup2.Find('-') then
                    repeat
                        if LeaveTypeSetup2.Code = LeaveCode then
                            exit('');
                    until LeaveTypeSetup2.Next = 0;
            until LeaveTypeSetup.Next = 0;
        if LeaveTypeSetup.Get(LeaveCode) then
            PrevLeaveCode := LeaveTypeSetup."Depending Leave";
        Clear(LeaveTypeSetup);
        LeaveTypeSetup.Reset;
        LeaveTypeSetup.FilterGroup(2);
        LeaveTypeSetup.SetFilter(Code, '<>%1', LeaveCode);
        LeaveTypeSetup.FilterGroup(0);
        PageLeaveTypeSetup.LookedUpped;
        PageLeaveTypeSetup.SetRecord(LeaveTypeSetup);
        PageLeaveTypeSetup.SetTableView(LeaveTypeSetup);
        PageLeaveTypeSetup.LookupMode(true);
        if PageLeaveTypeSetup.RunModal = ACTION::LookupOK then
            exit(PageLeaveTypeSetup.ExitLeaveCodes)
        else
            exit(PrevLeaveCode);
    end;

    procedure CheckDependability(LeaveCode: Code[20]; EmpCode: Code[20])
    var
        EmpLeaveEarn: Record "Leave Earn";
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveTypeSetup2: Record "Leave Type Setup";
        Description: Text;
    begin
        LeaveTypeSetup.Get(LeaveCode);
        if LeaveTypeSetup."Depending Leave" <> '' then begin
            LeaveTypeSetup2.Reset;
            LeaveTypeSetup2.SetFilter(Code, LeaveTypeSetup."Depending Leave");
            if LeaveTypeSetup2.Find('-') then
                repeat
                    if Description = '' then
                        Description := LeaveTypeSetup2.Description
                    else
                        Description += ' or ' + LeaveTypeSetup2.Description;
                until LeaveTypeSetup2.Next = 0;
            EmpLeaveEarn.SetRange(EmpNo, EmpCode);
            EmpLeaveEarn.SetFilter("Leave Code", LeaveTypeSetup."Depending Leave");
            EmpLeaveEarn.CalcSums("Balancing Days");
            if EmpLeaveEarn."Balancing Days" > 0 then
                Error('Your leave (%1) are unavailable. Please use another leave (%2).', LeaveTypeSetup.Description, Description);
        end;
    end;

    procedure CalculateRemainingDays(EmpCode: Code[20]; LeaveTypeCode: Code[20]; PostDate: Date): Decimal
    var
        LeaveEarn: Record "Leave Earn";
    begin
        LeaveEarn.Reset;
        LeaveEarn.SetRange(EmpNo, EmpCode);
        LeaveEarn.SetRange("Leave Code", LeaveTypecode);
        LeaveEarn.SetRange("Posted Date", 0D, PostDate);
        LeaveEarn.CalcSums("Balancing Days");
        exit(LeaveEarn."Balancing Days");
    end;


    procedure CheckForCompensatory(LeaveCode: Code[20]; EmpCode: Code[20]; CompensatoryDate: Date; NoOfDays: Decimal): Boolean
    var
        LeaveType: Record "Leave Type Setup";
        ErrorNoOfDays: Label 'No. days must be 1.';
        ErrorNonWokDays: Label 'There wasn''t a holiday on %1.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        ErrorPresent: Label 'Cannot apply compenstory leave for %1.';
        EmpActivity: Record "Employee Activity";
    begin
        LeaveType.Get(LeaveCode);
        PayrollSetup.Get; //Min
        if LeaveType.Compensatory then begin
            if NoOfDays <> 1 then
                Error(ErrorNoOfDays);
            if not (CompensatoryDate in [PayrollSetup."Payroll Fiscal Year Start Date" .. PayrollSetup."Payroll Fiscal Year End Date"]) then
                Error('Cannot apply for previous fiscal year');
            //IF GetNonWorkingDays(CompensatoryDate,CompensatoryDate,EmpCode) <> 1 THEN
            //ERROR(ErrorNonWokDays,CompensatoryDate);
            //check for compensatory
            EmpActivity.Reset;
            EmpActivity.SetRange("Employee No.", EmpCode);
            EmpActivity.SetRange(Type, EmpActivity.Type::"Leave Request");
            EmpActivity.SetRange("Compensatory Date", CompensatoryDate);
            EmpActivity.SetRange("Cancelled No.", '');
            EmpActivity.SetFilter("Approval Status", '<>%1', EmpActivity."Approval Status"::Rejected);
            if EmpActivity.FindFirst then
                Error('Compensatory leave already applied for compensatory date %1', CompensatoryDate);

            EmpActivity.Reset;
            EmpActivity.SetRange("Employee No.", EmpCode);
            EmpActivity.SetRange(Type, EmpActivity.Type::Overtime);
            EmpActivity.SetRange("Compensatory Date", CompensatoryDate);
            EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Approved);
            if EmpActivity.FindFirst then
                Error('Overtime already approved on %1 so you are not eligible for compensatory leave.', CompensatoryDate);



            EmpAttendActivity.Reset;
            EmpAttendActivity.SetRange("Employee No.", EmpCode);
            ;
            EmpAttendActivity.SetRange("Attendance Date", CompensatoryDate);
            if EmpAttendActivity.FindFirst then begin
                Clear(LeaveType);
                if EmpAttendActivity."Source No." <> '' then
                    if not EmpActivity.Get(EmpAttendActivity."Source No.") then
                        Error('Compensatory leave is not eligible for compnesatory date %1.', CompensatoryDate);
                if LeaveType.Get(EmpActivity."Leave Code") then;
                if (EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday) and
                    (LeaveType."AML Eligible") then
                    exit(true);
                if ((EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday) or
                  (LeaveType."AML Eligible") or (LeaveType."Skip Balance Check")) and (EmpAttendActivity."Check In Time" <> 0T) then
                    exit(true)
                else
                    Error(ErrorPresent, CompensatoryDate);
            end;
            //EXIT(TRUE);
        end;
    end;

    procedure UpdateLeaveForEmpTypeChanged(Empcode: Code[20]; xJobType: Option; JobType: Option)
    var
        LeaveType: Record "Leave Type Setup";
        LeaveEarn: Record "Leave Earn";
        NoMgmt: Codeunit NoSeriesManagement;
        ServiceHistory: Record "Employee Service History";
        ServiceHistoryCode: Code[20];
        ServiceHistoryMgt: Codeunit "Service History Mgt";
    begin
        Employee.Get(Empcode);
        Employee.TestField("Confirmation Date");
        HRSetup.Get;
        LeaveType.Reset;
        LeaveType.SetFilter("Employee No. Filter", Empcode);
        LeaveType.SetRange("Leave For Employee Type", xJobType);
        if LeaveType.Find('-') then
            repeat
                LeaveType.CalcFields("Remaining Days");
                if LeaveType."Remaining Days" <> 0 then begin
                    LeaveEarn.Init;
                    LeaveEarn.Validate("Entry No.", NoMgmt.GetNextNo(HRSetup."Leave Earn No.", Today, true));
                    LeaveEarn.Validate("Leave Code", LeaveType.Code);
                    LeaveEarn.Validate(EmpNo, Empcode);
                    LeaveEarn.Validate("Leave Description", LeaveType.Description);
                    LeaveEarn.Validate(Type, LeaveEarn.Type::EmpTypeChanged);
                    EngNep.Reset;
                    EngNep.SetRange("English Date", Today);
                    if EngNep.FindFirst then;
                    LeaveEarn.Validate("Posted Date", Today);
                    LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                    LeaveEarn.Validate("Balancing Days", -LeaveType."Remaining Days");
                    LeaveEarn.Insert(true);
                end;
            until LeaveType.Next = 0;

        Clear(LeaveType);
        LeaveType.Reset;
        LeaveType.SetFilter("Employee No. Filter", Empcode);
        LeaveType.SetFilter("Leave For Employee Type", '%1|%2', JobType, LeaveType."Leave For Employee Type"::" ");
        LeaveType.SetFilter(Gender, '%1|%2', Employee.Gender, LeaveType.Gender::" ");
        LeaveType.SetFilter("Marital Status", '%1', Employee."Marital Status");
        LeaveType.SetRange(Compensatory, false);
        LeaveType.SetRange("Needed HR Permission", false);
        LeaveType.SetRange("Skip Balance Check", false);
        if LeaveType.Find('-') then
            repeat
                LeaveEarn.Init;
                LeaveEarn.Validate("Entry No.", NoMgmt.GetNextNo(HRSetup."Leave Earn No.", Today, true));
                LeaveEarn.Validate("Leave Code", LeaveType.Code);
                LeaveEarn.Validate(EmpNo, Empcode);
                LeaveEarn.Validate("Leave Description", LeaveType.Description);
                LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
                EngNep.Reset;
                EngNep.SetRange("English Date", Today);
                if EngNep.FindFirst then;
                LeaveEarn.Validate("Posted Date", Today);
                LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                if LeaveType."Calculate Proratawise" then
                    LeaveEarn.Validate("Balancing Days", CalculateProDataLeave(LeaveType.Code, Employee."Confirmation Date"))
                else
                    LeaveEarn.Validate("Balancing Days", LeaveType."Days Earned Per Year");
                if LeaveEarn."Balancing Days" <> 0 then
                    LeaveEarn.Insert(true);
            until LeaveType.Next = 0;

        ServiceHistoryCode := ServiceHistoryMgt.AddToServiceHistory(Employee."No.", ServiceHistory."Service Event"::Confirmation, 'Confirmed', Employee."Confirmation Date");
        if ServiceHistory.Get(ServiceHistoryCode) then begin
            ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
            ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
            ServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
            ServiceHistory.Validate("Deputation Code (To)", ServiceHistoryMgt.ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Validate("Deputation Value (To)", ServiceHistoryMgt.ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Modify;
        end;
    end;

    procedure AddLeaveAttachment(EmpActNo: Code[20]; EmpNo: Code[20]; LeaveCode: Code[20])
    var
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", EmpNo);
        TempIncomingDoc.SetRange("Leave Type Code", LeaveCode);
        TempIncomingDoc.SetRange("No.", EmpActNo);
        if TempIncomingDoc.Find('-') then
            repeat
                AttachmentSetup.Reset;
                AttachmentSetup.SetRange("Attachment Code", TempIncomingDoc."Attachment Code");
                AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Leave Request");
                AttachmentSetup.SetRange("Leave Type Code", TempIncomingDoc."Leave Type Code");
                if AttachmentSetup.FindFirst then begin
                    if AttachmentSetup.Mandatory then
                        if TempIncomingDoc."File Name" = '' then      //attachment mandatory for leave
                            Error('Attachment must be uploaded');
                end;
            // TempIncomingDoc.Validate("No.", EmpActNo);
            // TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::"Leave Request");
            // TempIncomingDoc.Validate("Employee Code", EmpNo);
            // TempIncomingDoc.Modify;
            until TempIncomingDoc.Next = 0;
    end;

    procedure CheckLeaveApproved(EmployeeCode: Code[20]; StartDate: Date; EndDate: Date)
    var
        Leave: Record "Leave";
    begin
        Leave.Reset();
        Leave.SetRange("Employee No.", EmployeeCode);
        Leave.SetRange("Start Date", StartDate, EndDate);
        Leave.SetRange("End Date", StartDate, EndDate);
        Leave.SetRange("Approval Status", Leave."Approval Status"::Approved);
        Leave.SetRange(Cancelled, false);
        if leave.FindFirst() then
            Error('Leave for %1 is already approved on this date range', Leave."Employee Name");
    end;

    procedure ApplyForLeave(var Leave: Record "Leave"): Code[20]
    var
        Approval: record "Approval HRMS";
        ConfirmLeave: Label 'Do you want to send leave request ?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveTable: Record "Leave";
        LeaveRequestError: Label 'Your leave request no. %1 of code %2 has not been approved. Please make sure it is approved';
    begin
        LeaveTypeSetup.Get(Leave."Leave Code");
        CheckPendingLeave(leave."No.", leave."Leave Code", Leave."Employee No.");
        CheckHalfLeave(Leave."Start Date", Leave."End Date", Leave."Leave Type", Leave."Leave Code");
        CheckLeaveApproved(Leave."Employee No.", Leave."Start Date", Leave."End Date");
        // CheckEmployeeAttendance(leave."Employee No.", leave."Start Date", Leave."End Date", leave."Leave Type"); Remove this Condition After Bank request
        CheckForLeaveCriteria(Leave."Leave Code", Leave."Start Date", Leave."End Date", Leave."Employee No.", Leave."No. of Days");
        CheckForMulipleRequest(Leave."Leave Code", Leave."Employee No.", Leave."Start Date", Leave."End Date", Leave."No. of Days");
        if GuiAllowed then begin
            if not Confirm(ConfirmLeave, false) then
                exit;
        end else begin
            CheckForLimitDays(Leave."Leave Code", Leave."No. of Days");
            CheckLeaveConflict(Leave."Employee No.", Leave."Start Date", Leave."End Date");
        end;

        Leave.TestField("Start Date");
        Leave.TestField("End Date");
        Leave.TestField(Remarks);
        Leave.TestField("Leave Code");
        PayrollSetup.Get;
        //check for fisal year start date
        if not (LeaveTypeSetup."Leave at Once" and LeaveTypeSetup."Needed HR Permission") then
            if (Leave."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date") or (Leave."End Date" > PayrollSetup."Payroll Fiscal Year End Date") then
                Error('Leave Start date must be within %1 - %2', PayrollSetup."Payroll Fiscal Year Start Date", PayrollSetup."Payroll Fiscal Year End Date");

        //Bereavement Leave
        if GuiAllowed then
            if LeaveTypeSetup."Bereavement Leave" then
                Leave.TestField("For Death Of");
        if Leave."No. of Days" <= 0 then
            Error(ErrorNoOfDays);
        CheckRemainingLeaveDays(Leave."Leave Code", Leave."Employee No.", Leave."No. of Days");
        CheckDependability(Leave."Leave Code", Leave."Employee No.");
        CheckForEmployeeLimit(Leave."Leave Code", Leave."Employee No.");
        if GuiAllowed then begin
            Leave.Validate("Approval Status", Leave."Approval Status"::Pending);
            AddLeaveAttachment(Leave."No.", Leave."Employee No.", leave."Leave Code");
            ApproverMgt.UpdateFirstApproverStatus(Leave."No.");
            Leave.modify();
        end;
        HRMgt.SendMailFromTemplate(DATABASE::Leave, Leave.Type::"Leave Request", Leave."Approval Status"::Pending, '', Leave."Employee No.", Leave."No.", 0);   //For email
        exit(Leave."No.");
    end;

    procedure CheckPendingLeave(leaveRequestNo: Code[20]; LeaveCode: Code[20]; EmployeeNo: Code[20])
    var
        LeaveTable: Record "Leave";
        LeaveRequestError: Label 'Your leave request no. %1 of code %2 has not been approved. Please make sure it is approved';
    begin
        LeaveTable.Reset;
        LeaveTable.SetFilter("No.", '<>%1', leaveRequestNo);
        LeaveTable.SetRange("Employee No.", EmployeeNo);
        LeaveTable.SetRange(Type, LeaveTable.Type::"Leave Request");
        LeaveTable.SetRange("Leave Code", LeaveCode);
        LeaveTable.SetRange("Approval Status", LeaveTable."Approval Status"::Pending);
        if LeaveTable.FindFirst then
            Error(LeaveRequestError, LeaveTable."No.", LeaveTable."Leave Code");
    end;

    procedure CreateLeaveEarnContract(Employee: Record Employee)
    var
        TempLeaveEarn: Record "Leave Earn" temporary;
        LeaveEarn: Record "Leave Earn";
    begin
        Employee.TestField("Employment Type", Employee."Employment Type"::Contract);
        Employee.TestField("Employment Date");

        if not Confirm('Do you want to add leave balance for contract employee ?', false) then
            exit;
        /*LeaveEarn.RESET;
        LeaveEarn.SETRANGE(EmpNo,"No.");
        LeaveEarn.SETRANGE("Fiscal year",ReturnFiscalYear(TODAY));
        LeaveEarn.SETRANGE(Type,LeaveEarn.Type::Earned);
        IF LeaveEarn.FINDFIRST THEN
          ERROR('Leave Earn has already been carried out for this fiscal year');
          */
        TempLeaveEarn.Init;
        TempLeaveEarn.Validate(EmpNo, Employee."No.");
        TempLeaveEarn.Insert;
        PAGE.RunModal(Page::"Leave Earn", TempLeaveEarn);
    end;

    procedure OpenCancelEmpActivity(Leave: Record Leave)
    var
        //TempLeave: Record "Leave" temporary;
        TempCancelDocument: Record "Cancel Document" temporary;
        Approval: record "Approval HRMS";
        HRSetup: Record "Human Resources Setup";
    begin
        HRSetup.Get();
        if leave.Cancelled then
            Error('Leave request no. %1 is already cancelled.', Leave."No.");
        if Leave."Approved Date" + HRSetup."Cancel Document Upto (Days)" < Today then
            Error('Leave request no. %1 cannot be cancelled after %2', Leave."No.", Leave."Approved Date" + HRSetup."Cancel Document Upto (Days)");
        Leave.TestField("Approval Status", Leave."Approval Status"::Approved);
        Leave.TestField("Cancelled Document No.", '');
        // Clear Approval line 
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Leave Request");
        Approval.SetRange("Employee No", Leave."Employee No.");
        Approval.DeleteAll();
        TempCancelDocument.Init;
        TempCancelDocument.Validate(Cancelled, true);
        TempCancelDocument.Validate("Employee No.", Leave."Employee No.");
        TempCancelDocument.Validate("Employee Name", Leave."Employee Name");
        TempCancelDocument.Validate("Approval Status", TempCancelDocument."Approval Status"::Open);
        TempCancelDocument.Validate(Type, Leave.Type);
        TempCancelDocument.Validate("Leave Code", Leave."Leave Code");
        TempCancelDocument.Validate("Leave Description", Leave."Leave Description");
        TempCancelDocument.Validate("Leave Type", Leave."Leave Type");
        TempCancelDocument.Validate("Requested Date", Today);
        TempCancelDocument.Validate("Start Date", Leave."Start Date");
        TempCancelDocument.Validate("End Date", Leave."End Date");
        TempCancelDocument.Validate("No. of Days", Leave."No. of Days");
        TempCancelDocument."Cancelled Document No." := Leave."No.";
        TempCancelDocument."No." := '';
        TempCancelDocument.Insert;
        PAGE.Run(PAGE::"Cancel Document", TempCancelDocument)
    end;

    procedure CheckLeaveCount(EmployeeNo: Code[20]) CountStartDate: Date
    var
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        CountStartDate := 0D;
        EmpAttendActivity.Reset;
        EmpAttendActivity.SetRange("Employee No.", EmployeeNo);
        EmpAttendActivity.SetRange("Day Type", EmpAttendActivity."Day Type"::"Working Day");
        EmpAttendActivity.SetRange("Present Day", 0);
        EmpAttendActivity.SetRange("Leave Day", 0);
        EmpAttendActivity.SetCurrentKey("Attendance Date");
        if EmpAttendActivity.FindFirst then
            exit(EmpAttendActivity."Attendance Date")
        else
            exit(Today);
    end;

    procedure ReturnLeaveCount(EmpNo: Code[20]; FromDate: Date): Integer
    var
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        EmpAttendActivity.Reset;
        EmpAttendActivity.SetRange("Employee No.", EmpNo);
        //EmpAttendActivity.SETRANGE("Day Type",EmpAttendActivity."Day Type"::"Working Day");
        EmpAttendActivity.SetRange("Present Day", 1);
        EmpAttendActivity.SetFilter("Attendance Date", '>%1', FromDate);
        exit(EmpAttendActivity.Count);
    end;

    // procedure GenerateSickLeaveAttachment(var Leave: Record leave)
    // var
    //     TempIncomingDoc: Record "Incoming Document";
    //     AttachmentSetup: Record "Attachment Setup";
    // begin
    //     TempIncomingDoc.Reset;
    //     TempIncomingDoc.SetRange("Employee Code", Leave."Employee No.");
    //     TempIncomingDoc.SetRange(Type, TempIncomingDoc.Type::" ");
    //     TempIncomingDoc.SETRANGE("Leave Type Code", Leave."Leave Code");
    //     TempIncomingDoc.SetRange("No.", '');
    //     if TempIncomingDoc.Find('-') then
    //         repeat
    //             if TempIncomingDoc."File Name" <> '' then
    //                 Clear(TempIncomingDoc."File Name");
    //         until TempIncomingDoc.Next = 0;
    //     TempIncomingDoc.DeleteAll;
    //     Leave.TestField("Leave Code");
    //     //IF LeaveType."Bereavement Leave" OR LeaveType."Maternity/Paternity Leave" OR LeaveType."Sick Leave" THEN BEGIN
    //     AttachmentSetup.Reset;
    //     AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Leave Request");
    //     AttachmentSetup.SetRange("Leave Type Code", Leave."Leave Code");
    //     if AttachmentSetup.Find('-') then
    //         repeat
    //             TempIncomingDoc.Reset;
    //             TempIncomingDoc.Init;
    //             TempIncomingDoc.Validate(Type, TempIncomingDoc.Type::" ");
    //             TempIncomingDoc.Validate("No.", Leave."No.");
    //             TempIncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
    //             TempIncomingDoc.Validate(Description, Format(Leave.Type) + ': ' + Leave."Leave Description");
    //             TempIncomingDoc.Validate("Employee Code", Leave."Employee No.");
    //             TempIncomingDoc.Validate("Leave Type Code", Leave."Leave Code");
    //             TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::"Leave Request");
    //             TempIncomingDoc.Insert(true);
    //         until AttachmentSetup.Next = 0;
    //     //END;
    // end;

    procedure GenerateLeaveAttachment(var leave: Record Leave)
    var
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        LeaveType: Record "Leave Type Setup";
    begin
        // Delete existing Attachment Line Of Leave <<Santosh<< 4-22-25
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("No.", leave."No.");
        TempIncomingDoc.DeleteAll();
        //
        TempIncomingDoc.Reset;
        LeaveType.Get(leave."Leave Code");
        TempIncomingDoc.SetRange("Employee Code", leave."Employee No.");
        TempIncomingDoc.SetRange(Type, TempIncomingDoc.Type::" ");
        TempIncomingDoc.SETRANGE("Leave Type Code", leave."Leave Code");
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.Find('-') then
            repeat
                if TempIncomingDoc."File Name" <> '' then
                    Clear(TempIncomingDoc."File Name");
            until TempIncomingDoc.Next = 0;
        TempIncomingDoc.DeleteAll;
        leave.TestField("Leave Code");
        IF leave."No. of Days" >= LeaveType."No. of Days for Attachment" THEN BEGIN
            AttachmentSetup.Reset;
            AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Leave Request");
            AttachmentSetup.SetRange("Leave Type Code", LeaveType.Code);
            if AttachmentSetup.Findset then
                repeat
                    TempIncomingDoc.Reset;
                    TempIncomingDoc.Init;
                    Clear(TempIncomingDoc."Entry No.");
                    TempIncomingDoc.Validate(Type, TempIncomingDoc.Type::" ");
                    TempIncomingDoc.Validate("No.", leave."No.");
                    TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::"Leave Request");
                    TempIncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                    TempIncomingDoc.Validate(Description, Format(leave.Type) + ': ' + leave."Leave Description");
                    TempIncomingDoc.Validate("Employee Code", leave."Employee No.");
                    TempIncomingDoc.Validate("Leave Type Code", LeaveType.Code);
                    TempIncomingDoc.Insert(true);
                until AttachmentSetup.Next = 0;
        END;
    end;

    procedure LeaveApproved(leaveNo: Code[20])
    var
        leaveEarn: Record "Leave Earn";
        leave: Record Leave;
        EmpAttendActivity: Record "Employee Attendance & Activity";
        IsHandled: Boolean;
        LeaveTypeSetup: Record "Leave Type Setup";
        ServiceInactivity: Record "Service Inactivity Ledger";
    begin
        leave.Get(leaveNo);
        OnBeforeLeaveApproved(leave, IsHandled);
        if not IsHandled then begin
            LeaveEarn.Init;
            LeaveEarn.Validate("Leave Code", leave."Leave Code");
            LeaveEarn.Validate(EmpNo, leave."Employee No.");
            LeaveEarn.Validate(Type, LeaveEarn.Type::Used);
            LeaveEarn.Validate("Fiscal year", leave."Fiscal Year");
            LeaveEarn.Validate("Posted Date", Today);
            LeaveEarn.Validate("Balancing Days", -leave."No. of Days");
            LeaveEarn.Validate("Leave Request No", leave."No.");
            LeaveEarn.Insert(true);
        end;
        LeaveTypeSetup.get(leave."Leave Code");
        if LeaveTypeSetup."Exclude in Service Period" then begin
            //Create Service inactivity line
            clear(ServiceInactivity);
            ServiceInactivity.Init();
            ServiceInactivity."Entry No." := hrmgt.GetNextEntryNo(Database::"Service Inactivity Ledger");
            ServiceInactivity.Validate("Employee No.", leave."Employee No.");
            ServiceInactivity.Validate("Start Date", leave."Start Date");
            ServiceInactivity.Validate("End Date", leave."End Date");
            ServiceInactivity.Insert(true);
        end;
        Commit();
        // Update Daily Attendance
        if leave."Start Date" <= Today then begin
            if leave."End Date" > Today then
                AttendanceMgt.DailyAttendanceUpdate(leave."Start Date", Today, leave."Employee No.")//For Ongoing Leave
            else
                AttendanceMgt.DailyAttendanceUpdate(leave."Start Date", leave."End Date", leave."Employee No.") // For Completed Leave
        end;
    end;

    procedure InsertLeaveEarnfromJournal(
        LeaveCode: Code[20];
        EmpNo: Code[20];
        EarnType: Enum "Leave Earn Type";
        Days: Decimal;
        DocumentNo: Code[20];
        RequestedDate: Date)
    var
        LeaveEarn: Record "Leave Earn";
        HRMgt: Codeunit "HR Mgt.";
    begin
        LeaveEarn.Init;
        LeaveEarn.Validate("Leave Code", LeaveCode);
        LeaveEarn.Validate(EmpNo, EmpNo);
        LeaveEarn.Validate(Type, EarnType);
        LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(RequestedDate));
        LeaveEarn.Validate("Posted Date", Today);
        LeaveEarn.Validate("Balancing Days", Days);
        LeaveEarn.Validate("Leave Request No", DocumentNo);
        LeaveEarn.Insert(true);
    end;

    procedure ApproveCancelledLeave(CancelLeaveCode: Code[20])
    var
        LeaveEarn: Record "Leave Earn";
        EmpAttendActivity: Record "Employee Attendance & Activity";
        CancelDocument: Record "Cancel Document";
    begin
        CancelDocument.Get(CancelLeaveCode);
        CancelDocument.TestField(Type, CancelDocument.Type::"Leave Request");
        if CancelDocument.Type = CancelDocument.Type::"Leave Request" then begin
            LeaveEarn.Init;
            LeaveEarn.Validate("Leave Code", CancelDocument."Leave Code");
            LeaveEarn.Validate("Leave Description", CancelDocument."Leave Description");
            LeaveEarn.Validate("Leave Request No", CancelDocument."No.");
            LeaveEarn.Validate(EmpNo, CancelDocument."Employee No.");
            LeaveEarn.Validate("Employee Full Name", CancelDocument."Employee Name");
            LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(Today));
            LeaveEarn.Validate("Posted Date", Today);
            LeaveEarn.Validate("Balancing Days", CancelDocument."No. of Days");
            LeaveEarn.Validate(Type, LeaveEarn.Type::Cancelled);
            LeaveEarn.Insert(true);

            // Update Daily Attendance
            if CancelDocument."Start Date" <= Today then begin
                if CancelDocument."End Date" > Today then
                    AttendanceMgt.DailyAttendanceUpdate(CancelDocument."Start Date", Today, CancelDocument."Employee No.")//For Ongoing Leave
                else
                    AttendanceMgt.DailyAttendanceUpdate(CancelDocument."Start Date", CancelDocument."End Date", CancelDocument."Employee No.")// For Completed Leave
            end;
        end;
    end;

    procedure RejectLeaveCancel(LeaveCancelledCode: Code[20])
    var
        CancelledDocument: Record "Cancel Document";
        Leave: Record Leave;
    begin
        CancelledDocument.Get(LeaveCancelledCode);
        if Leave.Get(CancelledDocument."Cancelled Document No.") then begin
            leave.Validate("Cancelled No.", '');
            leave.Validate(Cancelled, false);
            leave.Modify(true);
        end else
            Error('Leave request no. %1 not found.', CancelledDocument."Cancelled Document No.");
    end;

    procedure CheckEmployeeAttendance(EmployeeCode: Code[20]; StartDate: Date; EndDate: Date; LeaveType: Enum "Leave Type")
    var
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
    begin
        if LeaveType <> LeaveType::"Full Day" then
            exit; //No need to check attendance for Half Day
        EmpAttendanceActivity.Reset;
        EmpAttendanceActivity.SetRange("Employee No.", EmployeeCode);
        EmpAttendanceActivity.SetFilter("Attendance Date", '%1..%2', StartDate, EndDate);
        if EmpAttendanceActivity.FindSet then
            repeat
                if EmpAttendanceActivity."Present Day" = 1 then
                    Error(LeaveError, EmpAttendanceActivity."Attendance Date");
            until EmpAttendanceActivity.Next = 0;
    end;

    procedure CheckHalfLeave(StartDate: date; EndDate: date; LeaveType: Enum "Leave Type"; LeaveCode: Code[20])
    var
        HalfLeaveError: Label 'Half Leaves cannot be applied in multiple days.';
    begin
        if LeaveType in [LeaveType::"First Half", LeaveType::"Second Half"] then
            if StartDate <> EndDate then
                Error(HalfLeaveError);
        if LeaveTypeSetup.Get(LeaveCode) then begin
            If LeaveType <> LeaveType::"Full Day" then
                if LeaveTypeSetup."Half Leave Allowed" then begin
                    If HrMgt.IsFriday(StartDate) then
                        Error('Half Leave is not allowed on Fridays')
                end else
                    Error('Half Leave is not allowed in %1', LeaveTypeSetup.Description);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeLeaveApproved(leave: Record Leave; var IsHandled: Boolean)
    begin
    end;

    var
        EngNep: Record "English-Nepali Date";
        LeaveError: Label 'You cannot apply leave in Present day %1.';
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        PayrollSetup: Record "Payroll General Setup";
        CalendarDescription: Text;
        HRSetup: Record "Human Resources Setup";
        AttendanceSetup: Record "Attendance Setup";
        ApproverMgt: Codeunit "Approver Mgt";
        DailyAttendanceUpdate: Report "Daily Attendance Update";
        LeaveTypeSetup: Record "Leave Type Setup";
        AttendanceMgt: Codeunit "Attendance Mgt";
}
