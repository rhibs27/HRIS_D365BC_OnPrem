codeunit 50000 "Leave Mgt."
{
    procedure OpenLeaveRequest(EmpCode: Code[20])
    var
        // EmpAct: Record "Employee Activity" temporary;
        leaveRequest: record leave temporary;
    //EmployeeActivity: Record "Employee Activity";
    begin
        Clear(Employee);
        Employee.Get(EmpCode);

        leaveRequest.Init;
        leaveRequest.Validate("Functional Title", Employee."Functional Title");
        leaveRequest.Validate("Employee No.", EmpCode);
        leaveRequest.Validate(Type, leaveRequest.Type::"Leave Request");
        leaveRequest.Validate("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
        leaveRequest.Validate("Approval Status", leaveRequest."Approval Status"::Open);
        leaveRequest.Validate("Employee Work Shift", Employee."Employee Work Shift");
        leaveRequest.Validate("Leave Type", leaveRequest."Leave Type"::"Full Day");
        leaveRequest.Validate("Requested Date", Today);
        leaveRequest.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
        leaveRequest.Validate(Department, Employee."Department Code");
        leaveRequest.Insert;
        if GuiAllowed then //NICASIA SM for Web Portal
            PAGE.Run(PAGE::"Leave Request", leaveRequest);
    end;

    procedure CalculateNoOfDays(StartDate: Date; EndDate: Date; LeaveCode: Code[20]; Type: Option " ","Leave Request","Travel Request",Settlement; LeaveType: Option "Full Day","First Half","Second Half"; Empcode: Code[20]): Decimal
    var
        DateError: Label 'Start Date (%1) must be less than End Date (%2).';
        LeaveTypeSetup: Record "Leave Type Setup";
        Difference: Decimal;
    begin
        if StartDate > EndDate then
            Error(DateError, StartDate, EndDate);
        if Type = Type::"Leave Request" then begin
            LeaveTypeSetup.Get(LeaveCode);
            if LeaveType = LeaveType::"Full Day" then
                Difference := 1
            else
                Difference := 0.5;
            if LeaveTypeSetup."Exclude Non Working Days" then
                exit(EndDate - StartDate + Difference - GetNonWokingDays(StartDate, EndDate, Empcode))
            else
                exit(EndDate - StartDate + Difference);
        end else
            exit(EndDate - StartDate + 1);
    end;

    procedure GetNonWokingDays(StartDate: Date; EndDate: Date; EmpCode: Code[20]): Integer
    var
        Description: Text;
        Proviences: Text;
        Gender: Option " ",Female,Male;
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
    // AttendanceMgt: Codeunit "Attendance Management";
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
                if HRMgt.CheckDateStatus(BaseCalendar.Code, CalendarDate."Period Start", Description, Proviences, Gender, InOutValley, PostingRegion, Branch) then begin
                    CalendarDescription := Description;
                    if (Proviences = '') and (Gender = Gender::" ") and (InOutValley = InOutValley::" ") and (PostingRegion = PostingRegion::" ") and (Branch = '') then
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


                        if (InOutValley = Employee."Inside/Outisde Valley") and (InOutValley <> InOutValley::" ") and (not AlreadyAdded) then begin
                            Counter += 1;
                            AlreadyAdded := true;
                        end;

                    end;

                end;
            until CalendarDate.Next = 0;

        exit(Counter);
    end;

    procedure CheckLeaveConflict(EmpCode: Code[20]; StartDate: Date; EndDate: Date)
    var
        //EmpAct: Record "Employee Activity";
        leave: Record Leave;
        NoOfRecrod: Integer;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
    begin
        //check for leave conflict..
        leave.Reset;
        leave.SetRange("Employee No.", EmpCode);
        //EmpAct.SETRANGE(Type,EmpAct.Type::"Leave Request");
        leave.SetFilter(Type, '%1|%2', leave.Type::"Leave Request", leave.Type::"Attendance Missed");
        leave.SetFilter("Approval Status", '<>%1', leave."Approval Status"::Rejected);
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
        //EmpAct.SETRANGE(Type,EmpAct.Type::"Leave Request");
        leave.SetFilter(Type, '%1|%2', leave.Type::"Leave Request", leave.Type::"Attendance Missed");
        leave.SetRange("Fiscal Year", EngNep."Fiscal Year");
        leave.SetRange("Cancelled No.", '');
        leave.SetRange(Cancelled, false);
        leave.SetFilter("Approval Status", '<>%1', leave."Approval Status"::Rejected);
        if leave.Find('-') then
            repeat
                if ((StartDate > leave."Start Date") and (StartDate < leave."End Date")) or
                    ((EndDate > leave."Start Date") and (EndDate < leave."End Date")) then
                    Error('Leave has already been request between %1 to %2', StartDate, EndDate);
            until leave.Next = 0;
        EmpAttendanceActivity.Reset; //Min 4.11.2022
        EmpAttendanceActivity.SetRange("Employee No.", EmpCode);
        EmpAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
        if EmpAttendanceActivity.FindFirst then
            repeat
                if EmpAttendanceActivity."Present Day" = 1 then
                    Error(LeaveError, EmpAttendanceActivity."Attendance Date");
            until EmpAttendanceActivity.Next = 0;
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
            Leave.SetFilter("Approval Status", '<>%1&<>%2', Leave."Approval Status"::Rejected, Leave."Approval Status"::Cancelled);
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
                Error(NoLeaveDaysError + EmpCode);
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

    procedure UpdateLeaveEmployee(EmpCode: Code[20]; JoiningDate: Date; EmployeeType: Option " ",Permanent,Probation,Contract; Gender: Option " ",Female,Male; MaritalStatus: Option)
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
        LeavetypSetup.SetFilter("Marital Status", '%1|%2', LeavetypSetup."Marital Status"::" ", MaritalStatus);
        LeavetypSetup.SetRange(Compensatory, false);
        LeavetypSetup.SetRange("Needed HR Permission", false);
        LeavetypSetup.SetRange("Skip Balance Check", false);
        if LeavetypSetup.Find('-') then
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
                    end else if LeavetypSetup."Encashable Limit" <= LeavetypSetup."Remaining Days" then begin
                        LeaveEarn.Init;
                        LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                        LeaveEarn.Validate(EmpNo, Employee."No.");
                        LeaveEarn.Validate(Type, LeaveEarn.Type::Encashed);
                        LeaveEarn.Validate("Fiscal year", EnglishNepaliDate."Fiscal Year");
                        LeaveEarn.Validate("Posted Date", Today);
                        LeaveEarn.Validate("Balancing Days", -LeavetypSetup."Encashable Limit");
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
        LeavetypSetup.SetFilter("Marital Status", '%1|%2', LeavetypSetup."Marital Status"::" ", MaritalStatus);
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
    begin
        LeaveTypeSetup.Get(LeaveCode);
        if LeaveTypeSetup."Limit Max. Leave at Once" then
            if NoOfDays > LeaveTypeSetup."Maximum Leave at once" then
                Error('Applied Leave Days for %1 cannot exceed %2.', LeaveTypeSetup.Description, LeaveTypeSetup."Maximum Leave at once");
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

    procedure CalculateRemainingDays(EmpCode: Code[20]; LeaveTypecode: Code[20]; PostDate: Date): Decimal
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
            //IF GetNonWokingDays(CompensatoryDate,CompensatoryDate,EmpCode) <> 1 THEN
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
        LeaveType.SetFilter("Marital Status", '%1|%2', LeaveType."Marital Status"::" ", Employee."Marital Status");
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

        ServiceHistoryCode := HRMgt.AddToServiceHistory(Employee."No.", ServiceHistory."Service Event"::Confirmation, 'Confirmed', Employee."Confirmation Date");
        if ServiceHistory.Get(ServiceHistoryCode) then begin
            ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
            ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
            ServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
            ServiceHistory.Validate("Deputation Code (To)", HRMgt.ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
            ServiceHistory.Validate("Deputation Value (To)", HRMgt.ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
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
        TempIncomingDoc.SetRange("No.", '');
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
                TempIncomingDoc.Validate("No.", EmpActNo);
                TempIncomingDoc.Modify;
            until TempIncomingDoc.Next = 0;
    end;

    procedure ApplyForLeave(Leave: Record "Leave" temporary): Code[20]
    var
        Leavevar: Record "Leave";
        ConfirmLeave: Label 'Do you want to send leave request ?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveTable: Record "Leave";
        LeaveRequestError: Label 'Your leave request no. %1 of code %2 has not been approved. Please make sure it is approved';
    begin
        LeaveTypeSetup.Get(Leave."Leave Code");
        LeaveTable.Reset;
        LeaveTable.SetRange("Employee No.", Leave."Employee No.");
        LeaveTable.SetRange(Type, LeaveTable.Type::"Leave Request");
        LeaveTable.SetRange("Leave Code", LeaveTypeSetup.Code);
        LeaveTable.SetFilter("Approval Status", '%1|%2|%3', LeaveTable."Approval Status"::Recommended, LeaveTable."Approval Status"::"Pending Approval", LeaveTable."Approval Status"::Open);
        if LeaveTable.FindFirst then
            Error(LeaveRequestError, LeaveTable."No.", LeaveTable."Leave Code");
        if GuiAllowed then begin
            if not Confirm(ConfirmLeave, false) then
                exit;
        end else begin
            CheckForLimitDays(Leave."Leave Code", Leave."No. of Days");
            if not LeaveTypeSetup.Compensatory then
                CheckLeaveConflict(Leave."Employee No.", Leave."Start Date", Leave."End Date");
            CheckForLeaveCriteria(Leave."Leave Code", Leave."Start Date", Leave."End Date", Leave."Employee No.", Leave."No. of Days");
            CheckForMulipleRequest(Leave."Leave Code", Leave."Employee No.", Leave."Start Date", Leave."End Date", Leave."No. of Days");
            if (LeaveTypeSetup."Sick Leave") and (Leave."No. of Days" >= LeaveTypeSetup."No. of Days for Attachment") then
                GenerateSickLeaveAttachment(leave);
        end;


        PayrollSetup.Get;
        //check for fisal year start date
        if (Leave."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date") or
          (Leave."End Date" > PayrollSetup."Payroll Fiscal Year End Date") then
            Error('Leave Start date must be within %1 - %2', PayrollSetup."Payroll Fiscal Year Start Date", PayrollSetup."Payroll Fiscal Year End Date");

        //Bereavement Leave
        if LeaveTypeSetup."Bereavement Leave" then
            Leave.TestField("For Death Of");
        //maternity and paternity leave
        if LeaveTypeSetup."Maternity/Paternity Leave" then
            Leave.TestField("Child's Gender");
        Leave.TestField("Start Date");
        Leave.TestField("End Date");
        Leave.TestField(Remarks);
        if Leave."No. of Days" <= 0 then
            Error(ErrorNoOfDays);
        Leave.TestField("Leave Code");

        //IF NOT CheckForCompensatory(TempEmpAct."Leave Code",TempEmpAct."Employee No.",TempEmpAct."Compensatory Date",TempEmpAct."No. of Days") THEN //Min 12.19.2022 -- Commented,Compensatory Leave route through OT Lines.
        CheckRemainingLeaveDays(Leave."Leave Code", Leave."Employee No.", Leave."No. of Days");

        CheckDependability(Leave."Leave Code", Leave."Employee No.");
        CheckForEmployeeLimit(Leave."Leave Code", Leave."Employee No.");
        Leavevar.Init;
        Leavevar.TransferFields(Leave);
        Leavevar.TestField("Approver Code");
        if Leavevar."Recommender Code" <> '' then
            Leavevar.Validate("Approval Status", Leavevar."Approval Status"::"Pending Approval")
        else
            Leavevar.Validate("Approval Status", Leavevar."Approval Status"::Recommended);
        Leavevar.Validate("User ID", UserId);

        Leavevar.Insert(true);
        if GuiAllowed then
            AddLeaveAttachment(Leavevar."No.", Leavevar."Employee No.", Leavevar."Leave Code");
        HRMgt.SendMailFromTemplate(DATABASE::Leave, Leavevar.Type::"Leave Request", Leavevar."Approval Status"::Open, '', Leavevar."Employee No.", Leavevar."No.", 0);   //For email

        exit(Leavevar."No.");
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
        PAGE.RunModal(60238, TempLeaveEarn);

    end;

    procedure OpenCancelEmpActivity(Leave: Record Leave)
    var
        TempLeave: Record "Leave" temporary;
    //TempEmpActivity: Record "Employee Activity" temporary;
    begin
        if not Confirm('Do you want to cancel document?', false) then
            exit;
        Leave.TestField("Approval Status", Leave."Approval Status"::Approved);
        Leave.TestField("Cancelled Document No.", '');
        TempLeave.Init;
        TempLeave.Validate(Cancelled, true);
        TempLeave.Validate("Employee No.", Leave."Employee No.");
        TempLeave.Validate("Employee Name", Leave."Employee Name");
        TempLeave.Validate("Approval Status", TempLeave."Approval Status"::Open);
        TempLeave.Validate(Type, Leave.Type);
        TempLeave.Validate("Leave Code", Leave."Leave Code");
        TempLeave.Validate("Requested Date", Today);
        TempLeave.Validate("Start Date", Leave."Start Date");
        TempLeave.Validate("End Date", Leave."End Date");
        TempLeave.Validate("No. of Days", Leave."No. of Days");
        TempLeave.Validate("Recommender Code", Leave."Recommender Code");
        TempLeave.Validate("Approver Code", Leave."Approver Code");
        TempLeave."Cancelled Document No." := Leave."No.";
        TempLeave.Insert;
        if PAGE.RunModal(PAGE::"Cancel Document", TempLeave) = ACTION::LookupOK then;
    end;

    procedure RecommendEmployeeLeave(EmpActCode: Code[20])
    var
        //EmpAct: Record "Employee Activity";
        leave: Record Leave;
    begin
        leave.Get(EmpActCode);
        leave.TestField("Approval Status", leave."Approval Status"::"Pending Approval");
        CheckEmployeeLeaveApproval(leave);
        leave.Validate("Approval Status", leave."Approval Status"::Recommended);
        leave.Modify;
        Message('The document has been recommended.');
    end;

    procedure RecommendEmployeeLeaveAPI(EmpActCode: Code[20]; ApproverCode: Code[20])
    var
        //EmpAct: Record "Employee Activity";
        leave: Record Leave;
    begin
        leave.Get(EmpActCode);
        leave.TestField("Approval Status", leave."Approval Status"::"Pending Approval");
        CheckEmployeeLeaveApprovalAPI(leave, ApproverCode);
        leave.Validate("Approval Status", leave."Approval Status"::Recommended);
        leave.Modify;
        Message('The document has been recommended.');
    end;

    local procedure CheckEmployeeLeaveApproval(leave: Record Leave)
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
        AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        if leave."Approval Status" = leave."Approval Status"::"Pending Approval" then
            if StrPos(leave."Recommender Code", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);
        if leave."Approval Status" = leave."Approval Status"::Recommended then
            if StrPos(leave."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);

        //IF EmpAct."Approval Status" = EmpAct."Approval Status"::Approved THEN
        //IF STRPOS(EmpAct."Incoming Branch Rep. Person", Employee."No.") = 0 THEN
        //ERROR(AcknowledgeError);
    end;

    local procedure CheckEmployeeLeaveApprovalAPI(leave: Record Leave; ApproverCode: Code[20])
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
        AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    begin
        Employee.Reset;
        Employee.SetRange("No.", ApproverCode);
        Employee.FindFirst;
        if leave."Approval Status" = leave."Approval Status"::"Pending Approval" then
            if StrPos(leave."Recommender Code", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);
        if leave."Approval Status" = leave."Approval Status"::Recommended then
            if StrPos(leave."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);

        //IF EmpAct."Approval Status" = EmpAct."Approval Status"::Approved THEN
        //IF STRPOS(EmpAct."Incoming Branch Rep. Person", Employee."No.") = 0 THEN
        //ERROR(AcknowledgeError);
    end;

    procedure ApprovedRejectLeaveApproval(Approved: Boolean; LeaveCode: Code[20])
    var

        //EmpAct: Record "Employee Activity";
        leave: Record Leave;
        LeaveEarn: Record "Leave Earn";
        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
        EmpAct2: Record "Employee Activity";
    begin
        leave.Get(LeaveCode);
        if leave.Type = leave.Type::"Leave Request" then begin
            if Approved then begin
                CheckForLeaveCriteria(leave."Leave Code", leave."Start Date", leave."End Date", leave."Employee No.", leave."No. of Days");
                leave.TestField("Approval Status", leave."Approval Status"::Recommended);
                CheckEmployeeleaveApproval(leave);
                leave.Validate("Approval Status", leave."Approval Status"::Approved);
                LeaveEarn.Init;
                LeaveEarn.Validate("Leave Code", leave."Leave Code");
                LeaveEarn.Validate(EmpNo, leave."Employee No.");
                LeaveEarn.Validate(Type, LeaveEarn.Type::Used);
                LeaveEarn.Validate("Fiscal year", leave."Fiscal Year");
                LeaveEarn.Validate("Posted Date", Today);
                LeaveEarn.Validate("Balancing Days", -leave."No. of Days");
                LeaveEarn.Validate("Leave Request No", leave."No.");
                LeaveEarn.Insert(true);

                //changes in employee attendance and activity
                EmpAttendActivity.Reset;
                EmpAttendActivity.SetRange("Employee No.", leave."Employee No.");
                EmpAttendActivity.SetRange("Attendance Date", leave."Start Date", leave."End Date");
                if EmpAttendActivity.Find('-') then
                    repeat
                        LeaveTypeSetup.Get(leave."Leave Code");
                        EmpAttendActivity."Absent Day" := 0;
                        EmpAttendActivity."Present Day" := 0;
                        if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then begin
                            if not LeaveTypeSetup."Exclude Non Working Days" then begin
                                EmpAttendActivity."Day Type" := EmpAttendActivity."Day Type"::"Working Day";
                                EmpAttendActivity."Week Off Day" := 0;
                                if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                    EmpAttendActivity."Present Day" := 1;
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                                end else begin
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                    EmpAttendActivity."Absent Day" := 1;
                                end;
                                EmpAttendActivity."Leave Day" := 1;
                            end;
                        end else if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::"Working Day" then begin
                            if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                EmpAttendActivity."Present Day" := 1;
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                            end else begin
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                EmpAttendActivity."Absent Day" := 1;
                            end;
                            EmpAttendActivity."Leave Day" := 1;
                        end;
                        EmpAttendActivity."Tour Day" := 0;
                        EmpAttendActivity."Employee Activity Found" := true;
                        EmpAttendActivity."Source No." := leave."No.";
                        EmpAttendActivity.Validate("Leave Description", leave."Leave Description");
                        EmpAttendActivity."Created Datetime" := CurrentDateTime;
                        EmpAttendActivity.Modify;
                    until EmpAttendActivity.Next = 0;
                AttendanceSetup.Get;
                Employee.Get(leave."Employee No.");
                Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                    if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                    else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                end else
                    Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                Employee.Modify;

                HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Approved, '', leave."Approver Code", leave."No.", 0);   //For email
            end else begin
                leave.TestField("Rejection Remarks");
                if not (leave."Approval Status" in [leave."Approval Status"::Recommended, leave."Approval Status"::"Pending Approval"]) then
                    Error(ApprovalStatusError, leave."Approval Status"::Recommended, leave."Approval Status"::"Pending Approval");
                CheckEmployeeLeaveApproval(leave);
                if leave."Approval Status" = leave."Approval Status"::"Pending Approval" then
                    HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Rejected, '', leave."Recommender Code", leave."No.", 0)   //For email
                else
                    HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Rejected, '', leave."Approver Code", leave."No.", 0);   //For email
                leave.Validate("Approval Status", leave."Approval Status"::Rejected);
                leave.TestField("Rejection Remarks");
                Message('The leave request has been rejected.');
            end;
        end else begin
            if Approved then begin
                leave.TestField("Approval Status", leave."Approval Status"::Recommended);
                CheckEmployeeLeaveApproval(leave);
                leave.Validate("Approval Status", leave."Approval Status"::Approved);
                if leave.Type = leave.Type::"Travel Request" then begin
                    //changes in employee attendance and activity
                    EmpAttendActivity.Reset;
                    EmpAttendActivity.SetRange("Employee No.", leave."Employee No.");
                    EmpAttendActivity.SetRange("Attendance Date", leave."Start Date", leave."End Date");
                    if EmpAttendActivity.Find('-') then
                        repeat
                            EmpAttendActivity."Absent Day" := 0;
                            EmpAttendActivity."Present Day" := 1;
                            EmpAttendActivity."Tour Day" := 1;
                            EmpAttendActivity."Leave Day" := 0;
                            EmpAttendActivity."Source No." := leave."No.";
                            EmpAttendActivity."Employee Activity Found" := true;
                            EmpAttendActivity."Created Datetime" := CurrentDateTime;

                            EmpAttendActivity.Modify;
                        until EmpAttendActivity.Next = 0;
                    Employee.Get(leave."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    AttendanceSetup.Get;
                    Employee.Get(leave."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                        if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                        else
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    end else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    Employee.Modify;
                end;

                HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Approved, '', leave."Approver Code", leave."No.", 0);   //For email
                Message('The document has been approved.');
            end else
                if (leave."Approval Status" in [leave."Approval Status"::"Pending Approval", leave."Approval Status"::Recommended]) then begin
                    leave.TestField("Rejection Remarks");
                    // if leave.Type = EmpAct.Type::"Travel Claim" then begin
                    //     EmpAct.TestField("Travel Order No.");
                    //     EmpAct2.Get(EmpAct."Travel Order No.");
                    //     EmpAct2.Validate("Travel Claimed", false);
                    //     EmpAct2.Modify;
                    // end; commented by santosh
                    CheckEmployeeLeaveApproval(leave);
                    if leave."Approval Status" = leave."Approval Status"::"Pending Approval" then
                        HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Rejected, '', leave."Recommender Code", leave."No.", 0)  //For email
                    else
                        HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Rejected, '', leave."Approver Code", leave."No.", 0);   //For email
                    leave.Validate("Approval Status", leave."Approval Status"::Rejected);
                    Message('The document has been rejected.');
                end else
                    Error('Cannot reject the document.');
        end;
        leave.Posted := true;
        leave."Approved Date" := Today;
        leave.Modify;
    end;

    procedure ApprovedRejectLeaveApprovalAPI(Approved: Boolean; LeaveCode: Code[20]; ApproverCode: Code[20])
    var

        //EmpAct: Record "Employee Activity";
        leave: Record Leave;
        LeaveEarn: Record "Leave Earn";
        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
        EmpAct2: Record "Employee Activity";
    begin
        leave.Get(LeaveCode);
        if leave.Type = leave.Type::"Leave Request" then begin
            if Approved then begin
                CheckForLeaveCriteria(leave."Leave Code", leave."Start Date", leave."End Date", leave."Employee No.", leave."No. of Days");
                leave.TestField("Approval Status", leave."Approval Status"::Recommended);
                CheckEmployeeleaveApprovalAPI(leave, ApproverCode);
                leave.Validate("Approval Status", leave."Approval Status"::Approved);
                LeaveEarn.Init;
                LeaveEarn.Validate("Leave Code", leave."Leave Code");
                LeaveEarn.Validate(EmpNo, leave."Employee No.");
                LeaveEarn.Validate(Type, LeaveEarn.Type::Used);
                LeaveEarn.Validate("Fiscal year", leave."Fiscal Year");
                LeaveEarn.Validate("Posted Date", Today);
                LeaveEarn.Validate("Balancing Days", -leave."No. of Days");
                LeaveEarn.Validate("Leave Request No", leave."No.");
                LeaveEarn.Insert(true);

                //changes in employee attendance and activity
                EmpAttendActivity.Reset;
                EmpAttendActivity.SetRange("Employee No.", leave."Employee No.");
                EmpAttendActivity.SetRange("Attendance Date", leave."Start Date", leave."End Date");
                if EmpAttendActivity.Find('-') then
                    repeat
                        LeaveTypeSetup.Get(leave."Leave Code");
                        EmpAttendActivity."Absent Day" := 0;
                        EmpAttendActivity."Present Day" := 0;
                        if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then begin
                            if not LeaveTypeSetup."Exclude Non Working Days" then begin
                                EmpAttendActivity."Day Type" := EmpAttendActivity."Day Type"::"Working Day";
                                EmpAttendActivity."Week Off Day" := 0;
                                if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                    EmpAttendActivity."Present Day" := 1;
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                                end else begin
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                    EmpAttendActivity."Absent Day" := 1;
                                end;
                                EmpAttendActivity."Leave Day" := 1;
                            end;
                        end else if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::"Working Day" then begin
                            if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                EmpAttendActivity."Present Day" := 1;
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                            end else begin
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                EmpAttendActivity."Absent Day" := 1;
                            end;
                            EmpAttendActivity."Leave Day" := 1;
                        end;
                        EmpAttendActivity."Tour Day" := 0;
                        EmpAttendActivity."Employee Activity Found" := true;
                        EmpAttendActivity."Source No." := leave."No.";
                        EmpAttendActivity.Validate("Leave Description", leave."Leave Description");
                        EmpAttendActivity."Created Datetime" := CurrentDateTime;
                        EmpAttendActivity.Modify;
                    until EmpAttendActivity.Next = 0;
                AttendanceSetup.Get;
                Employee.Get(leave."Employee No.");
                Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                    if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                    else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                end else
                    Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                Employee.Modify;

                HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Approved, '', leave."Approver Code", leave."No.", 0);   //For email
            end else begin
                leave.TestField("Rejection Remarks");
                if not (leave."Approval Status" in [leave."Approval Status"::Recommended, leave."Approval Status"::"Pending Approval"]) then
                    Error(ApprovalStatusError, leave."Approval Status"::Recommended, leave."Approval Status"::"Pending Approval");
                CheckEmployeeLeaveApprovalAPI(leave, ApproverCode);
                if leave."Approval Status" = leave."Approval Status"::"Pending Approval" then
                    HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Rejected, '', leave."Recommender Code", leave."No.", 0)   //For email
                else
                    HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Rejected, '', leave."Approver Code", leave."No.", 0);   //For email
                leave.Validate("Approval Status", leave."Approval Status"::Rejected);
                leave.TestField("Rejection Remarks");
                Message('The leave request has been rejected.');
            end;
        end else begin
            if Approved then begin
                leave.TestField("Approval Status", leave."Approval Status"::Recommended);
                CheckEmployeeLeaveApprovalAPI(leave, ApproverCode);
                leave.Validate("Approval Status", leave."Approval Status"::Approved);
                if leave.Type = leave.Type::"Travel Request" then begin
                    //changes in employee attendance and activity
                    EmpAttendActivity.Reset;
                    EmpAttendActivity.SetRange("Employee No.", leave."Employee No.");
                    EmpAttendActivity.SetRange("Attendance Date", leave."Start Date", leave."End Date");
                    if EmpAttendActivity.Find('-') then
                        repeat
                            EmpAttendActivity."Absent Day" := 0;
                            EmpAttendActivity."Present Day" := 1;
                            EmpAttendActivity."Tour Day" := 1;
                            EmpAttendActivity."Leave Day" := 0;
                            EmpAttendActivity."Source No." := leave."No.";
                            EmpAttendActivity."Employee Activity Found" := true;
                            EmpAttendActivity."Created Datetime" := CurrentDateTime;

                            EmpAttendActivity.Modify;
                        until EmpAttendActivity.Next = 0;
                    Employee.Get(leave."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    AttendanceSetup.Get;
                    Employee.Get(leave."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                        if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                        else
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    end else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    Employee.Modify;
                end;

                HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Approved, '', leave."Approver Code", leave."No.", 0);   //For email
                Message('The document has been approved.');
            end else
                if (leave."Approval Status" in [leave."Approval Status"::"Pending Approval", leave."Approval Status"::Recommended]) then begin
                    leave.TestField("Rejection Remarks");
                    // if leave.Type = EmpAct.Type::"Travel Claim" then begin
                    //     EmpAct.TestField("Travel Order No.");
                    //     EmpAct2.Get(EmpAct."Travel Order No.");
                    //     EmpAct2.Validate("Travel Claimed", false);
                    //     EmpAct2.Modify;
                    // end; commented by santosh
                    CheckEmployeeLeaveApprovalAPI(leave, ApproverCode);
                    if leave."Approval Status" = leave."Approval Status"::"Pending Approval" then
                        HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Rejected, '', leave."Recommender Code", leave."No.", 0)  //For email
                    else
                        HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Rejected, '', leave."Approver Code", leave."No.", 0);   //For email
                    leave.Validate("Approval Status", leave."Approval Status"::Rejected);
                    Message('The document has been rejected.');
                end else
                    Error('Cannot reject the document.');
        end;
        leave.Posted := true;
        leave."Approved Date" := Today;
        leave.Modify;
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

    procedure GenerateSickLeaveAttachment(var Leave: Record leave)
    var
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", Leave."Employee No.");
        TempIncomingDoc.SetRange(Type, TempIncomingDoc.Type::" ");
        TempIncomingDoc.SETRANGE("Leave Type Code", Leave."Leave Code");
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.Find('-') then
            repeat
                if TempIncomingDoc."File Name" <> '' then
                    Clear(TempIncomingDoc."File Name");
            until TempIncomingDoc.Next = 0;
        TempIncomingDoc.DeleteAll;
        Leave.TestField("Leave Code");
        //IF LeaveType."Bereavement Leave" OR LeaveType."Maternity/Paternity Leave" OR LeaveType."Sick Leave" THEN BEGIN
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Leave Request");
        AttachmentSetup.SetRange("Leave Type Code", Leave."Leave Code");
        if AttachmentSetup.Find('-') then
            repeat
                TempIncomingDoc.Reset;
                TempIncomingDoc.Init;
                TempIncomingDoc.Validate(Type, TempIncomingDoc.Type::" ");
                TempIncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                TempIncomingDoc.Validate(Description, Format(Leave.Type) + ': ' + Leave."Leave Description");
                TempIncomingDoc.Validate("Employee Code", Leave."Employee No.");
                TempIncomingDoc.Validate("Leave Type Code", Leave."Leave Code");
                TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::"Leave Request");
                TempIncomingDoc.Insert(true);
            until AttachmentSetup.Next = 0;
        //END;
    end;


    procedure ApprovedRejectLeaveApprovalALL(Approved: Boolean; LeaveCode: Code[20])
    var

        //EmpAct: Record "Employee Activity";
        leave: Record Leave;
        LeaveEarn: Record "Leave Earn";
        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
        EmpAct2: Record "Employee Activity";
    begin
        leave.Get(LeaveCode);
        if leave.Type = leave.Type::"Leave Request" then begin
            if Approved then begin
                CheckForLeaveCriteria(leave."Leave Code", leave."Start Date", leave."End Date", leave."Employee No.", leave."No. of Days");
                leave.TestField("Approval Status", leave."Approval Status"::Recommended);
                //CheckEmployeeleaveApproval(leave);
                leave.Validate("Approval Status", leave."Approval Status"::Approved);
                LeaveEarn.Init;
                LeaveEarn.Validate("Leave Code", leave."Leave Code");
                LeaveEarn.Validate(EmpNo, leave."Employee No.");
                LeaveEarn.Validate(Type, LeaveEarn.Type::Used);
                LeaveEarn.Validate("Fiscal year", leave."Fiscal Year");
                LeaveEarn.Validate("Posted Date", Today);
                LeaveEarn.Validate("Balancing Days", -leave."No. of Days");
                LeaveEarn.Validate("Leave Request No", leave."No.");
                LeaveEarn.Insert(true);

                //changes in employee attendance and activity
                EmpAttendActivity.Reset;
                EmpAttendActivity.SetRange("Employee No.", leave."Employee No.");
                EmpAttendActivity.SetRange("Attendance Date", leave."Start Date", leave."End Date");
                if EmpAttendActivity.Find('-') then
                    repeat
                        LeaveTypeSetup.Get(leave."Leave Code");
                        EmpAttendActivity."Absent Day" := 0;
                        EmpAttendActivity."Present Day" := 0;
                        if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then begin
                            if not LeaveTypeSetup."Exclude Non Working Days" then begin
                                EmpAttendActivity."Day Type" := EmpAttendActivity."Day Type"::"Working Day";
                                EmpAttendActivity."Week Off Day" := 0;
                                if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                    EmpAttendActivity."Present Day" := 1;
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                                end else begin
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                    EmpAttendActivity."Absent Day" := 1;
                                end;
                                EmpAttendActivity."Leave Day" := 1;
                            end;
                        end else if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::"Working Day" then begin
                            if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                EmpAttendActivity."Present Day" := 1;
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                            end else begin
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                EmpAttendActivity."Absent Day" := 1;
                            end;
                            EmpAttendActivity."Leave Day" := 1;
                        end;
                        EmpAttendActivity."Tour Day" := 0;
                        EmpAttendActivity."Employee Activity Found" := true;
                        EmpAttendActivity."Source No." := leave."No.";
                        EmpAttendActivity.Validate("Leave Description", leave."Leave Description");
                        EmpAttendActivity."Created Datetime" := CurrentDateTime;
                        EmpAttendActivity.Modify;
                    until EmpAttendActivity.Next = 0;
                AttendanceSetup.Get;
                Employee.Get(leave."Employee No.");
                Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                    if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                    else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                end else
                    Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                Employee.Modify;

                HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Approved, '', leave."Approver Code", leave."No.", 0);   //For email
            end else begin
                leave.TestField("Rejection Remarks");
                if not (leave."Approval Status" in [leave."Approval Status"::Recommended, leave."Approval Status"::"Pending Approval"]) then
                    Error(ApprovalStatusError, leave."Approval Status"::Recommended, leave."Approval Status"::"Pending Approval");
                //CheckEmployeeLeaveApproval(leave);
                if leave."Approval Status" = leave."Approval Status"::"Pending Approval" then
                    HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Rejected, '', leave."Recommender Code", leave."No.", 0)   //For email
                else
                    HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type::"Leave Request", leave."Approval Status"::Rejected, '', leave."Approver Code", leave."No.", 0);   //For email
                leave.Validate("Approval Status", leave."Approval Status"::Rejected);
                leave.TestField("Rejection Remarks");
                Message('The leave request has been rejected.');
            end;
        end else begin
            if Approved then begin
                leave.TestField("Approval Status", leave."Approval Status"::Recommended);
                //CheckEmployeeLeaveApproval(leave);
                leave.Validate("Approval Status", leave."Approval Status"::Approved);
                if leave.Type = leave.Type::"Travel Request" then begin
                    //changes in employee attendance and activity
                    EmpAttendActivity.Reset;
                    EmpAttendActivity.SetRange("Employee No.", leave."Employee No.");
                    EmpAttendActivity.SetRange("Attendance Date", leave."Start Date", leave."End Date");
                    if EmpAttendActivity.Find('-') then
                        repeat
                            EmpAttendActivity."Absent Day" := 0;
                            EmpAttendActivity."Present Day" := 1;
                            EmpAttendActivity."Tour Day" := 1;
                            EmpAttendActivity."Leave Day" := 0;
                            EmpAttendActivity."Source No." := leave."No.";
                            EmpAttendActivity."Employee Activity Found" := true;
                            EmpAttendActivity."Created Datetime" := CurrentDateTime;

                            EmpAttendActivity.Modify;
                        until EmpAttendActivity.Next = 0;
                    Employee.Get(leave."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    AttendanceSetup.Get;
                    Employee.Get(leave."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                        if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                        else
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    end else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    Employee.Modify;
                end;

                HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Approved, '', leave."Approver Code", leave."No.", 0);   //For email
                Message('The document has been approved.');
            end else
                if (leave."Approval Status" in [leave."Approval Status"::"Pending Approval", leave."Approval Status"::Recommended]) then begin
                    leave.TestField("Rejection Remarks");
                    // if leave.Type = EmpAct.Type::"Travel Claim" then begin
                    //     EmpAct.TestField("Travel Order No.");
                    //     EmpAct2.Get(EmpAct."Travel Order No.");
                    //     EmpAct2.Validate("Travel Claimed", false);
                    //     EmpAct2.Modify;
                    // end; commented by santosh
                    //CheckEmployeeLeaveApproval(leave);
                    if leave."Approval Status" = leave."Approval Status"::"Pending Approval" then
                        HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Rejected, '', leave."Recommender Code", leave."No.", 0)  //For email
                    else
                        HRMgt.SendMailFromTemplate(DATABASE::Leave, leave.Type, leave."Approval Status"::Rejected, '', leave."Approver Code", leave."No.", 0);   //For email
                    leave.Validate("Approval Status", leave."Approval Status"::Rejected);
                    Message('The document has been rejected.');
                end else
                    Error('Cannot reject the document.');
        end;
        leave.Posted := true;
        leave."Approved Date" := Today;
        leave.Modify;
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
}
