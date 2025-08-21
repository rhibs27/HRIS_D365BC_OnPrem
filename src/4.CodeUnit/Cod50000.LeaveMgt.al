codeunit 50000 "Leave Mgt."
{
    procedure OpenLeaveRequest(EmpCode: Code[20])
    var
        leaveRequest, LeaveRequest2 : record leave;
        Approval: Record "Approval HRMS";
    begin
        Clear(Employee);
        // Clear blank Approval line 
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
        IsHandled: Boolean;
        LeaveReq: Record Leave;
        CalculatedDays: Decimal;
    begin
        if StartDate > EndDate then
            Error(DateError, StartDate, EndDate);
        if Type = Type::"Leave Request" then begin
            if LeaveTypeSetup.Get(LeaveCode) then begin
                if LeaveType = LeaveType::"Full Day" then
                    Difference := 1
                else
                    Difference := 0.5;

                IsfridayandCasual(LeaveReq, StartDate, EndDate, LeaveCode, EmpCode, IsHandled, CalculatedDays);
                if IsHandled then
                    exit(CalculatedDays);
                OnCalculateNoOfDaysinLeave(LeaveTypeSetup, StartDate, EndDate, Empcode, IsHandled);  //to handle LTA  in EBL
                if not IsHandled then begin

                    if LeaveTypeSetup."Exclude Non Working Days" then
                        exit(EndDate - StartDate + Difference - GetNonWorkingDays(StartDate, EndDate, Empcode))
                    else
                        exit(EndDate - StartDate + Difference);

                end;
            end else
                exit(EndDate - StartDate + 1);
        end;
    end;

    procedure GetNonWorkingDays(StartDate: Date; EndDate: Date; EmpCode: Code[20]): Integer
    var
        Description: Text;
        Provinces: Text;
        Gender: Enum "Employee Gender";
        OrganizationStructureList: Record "Organization Structure List";
        CalendarDate: Record Date;
        Counter: Integer;
        AlreadyAdded: Boolean;
        BaseCalendar: Record "Base Calendar";
        InOutValley: Enum "Outside/Inside Valley";
        PostingRegion: Enum Region;
        Branch: Text;
        Community: Enum "Community Type";
        Disabled: Boolean;
    begin
        Counter := 0;
        PayrollSetup.Get;
        Employee.Get(EmpCode);
        CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Date);
        CalendarDate.SetRange("Period Start", StartDate, EndDate);
        if CalendarDate.Find('-') then
            repeat
                Clear(AlreadyAdded);
                if HRMgt.CheckDateStatus(PayrollSetup."Base Calendar", CalendarDate."Period Start", Description, Provinces, Gender, InOutValley, PostingRegion, Branch, Community, Disabled) then begin
                    CalendarDescription := Description;
                    if (Provinces = '') and (Gender = Gender::" ") and (InOutValley = InOutValley::" ") and (PostingRegion = PostingRegion::" ") and (Branch = '') and (community = community::" ") and (not Disabled) then
                        Counter += 1
                    else begin
                        if Provinces <> '' then begin
                            OrganizationStructureList.Reset;
                            OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Province);
                            OrganizationStructureList.SetFilter(Code, Provinces);
                            if OrganizationStructureList.Find('-') then
                                repeat
                                    if (Employee."Province Code" = OrganizationStructureList.Code) and (not AlreadyAdded) then begin
                                        Counter += 1;
                                        AlreadyAdded := true;
                                        break;
                                    end;
                                until OrganizationStructureList.Next = 0;
                        end;

                        if (Gender = Employee.Gender) and (Gender <> Gender::" ") and (not AlreadyAdded) then begin
                            Counter += 1;
                            AlreadyAdded := true;
                        end;

                        if (PostingRegion = Employee."Posting Region") and (PostingRegion <> PostingRegion::" ") and (not AlreadyAdded) then begin
                            Counter += 1;
                            AlreadyAdded := true;
                        end;

                        if (Branch <> '') and (not AlreadyAdded) then begin
                            OrganizationStructureList.Reset;
                            OrganizationStructureList.SetRange(Type, OrganizationStructureList.type::Branch);
                            OrganizationStructureList.SetFilter(Code, Branch);
                            if OrganizationStructureList.Find('-') then
                                repeat
                                    if (OrganizationStructureList.Code = Employee."Branch Code") and (not AlreadyAdded) then begin
                                        Counter += 1;
                                        AlreadyAdded := true;
                                        break;
                                    end;
                                until OrganizationStructureList.Next = 0;
                        end;
                        if (InOutValley = Employee."Inside/Outside Valley") and (InOutValley <> InOutValley::" ") and (not AlreadyAdded) then begin
                            Counter += 1;
                            AlreadyAdded := true;
                        end;
                        if (Community <> Community::" ") and (not AlreadyAdded) then
                            if Community = Employee.Community then begin
                                Counter += 1;
                                AlreadyAdded := true
                            end;
                        if Disabled and (not AlreadyAdded) then
                            if Disabled = Employee.disabled then begin
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
            LeaveEarn.SetRange("Employee No.", Employee."No.");
            LeaveEarn.CalcSums("Balancing Days");
            if not (LeaveEarn."Balancing Days" = NoofDays) then
                Error('Please select correct date as requested days must be equal to leave balance. Requested Days : %1 and Balance Days : %2', NoofDays, LeaveEarn."Balancing Days");
        end;

        LeaveTypeSetup.SetRange("Employee No. Filter", EmpCode);
        LeaveTypeSetup.SetRange(Code, LeaveCode);
        if LeaveTypeSetup.FindFirst then
            LeaveTypeSetup.CalcFields("Remaining Days");
        if (LeaveTypeSetup."Leave Category" <> LeaveTypeSetup."Leave Category"::Substitute) and (not LeaveTypeSetup."Skip Balance Check") then
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
            Leave.SetRange(Cancelled, false);
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
        LeavePeriod: Record "Accounting Period";
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
        LeavetypSetup.SetFilter("Leave Category", '<>%1', LeavetypSetup."Leave Category"::Substitute);
        LeavetypSetup.SetRange("Needed HR Permission", false);
        LeavetypSetup.SetRange("Skip Balance Check", false);
        if LeavetypSetup.FindSet() then
            repeat
                Clear(LeaveEarn);
                LeaveEarn.SetRange("Leave Code", LeavetypSetup.Code);
                LeaveEarn.SetRange("Employee No.", EmpCode);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                if not LeavetypSetup."Services Period" then
                    LeaveEarn.SetRange("Fiscal year", EngNep."Fiscal Year");
                if not LeaveEarn.FindFirst then begin
                    LeaveEarn.Init;
                    LeaveEarn.Validate("Entry No.", GetNextLeaveLedgerEntryNo());
                    LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                    LeaveEarn.Validate("Employee No.", EmpCode);
                    LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
                    LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                    LeaveEarn.Validate("Posted Date", Today);
                    if LeavetypSetup."AML Eligible" then begin
                        if Employee."Confirmation Date" <= LeavePeriod.GetCurrentLeaveYearStartDate() then begin
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
    begin
        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("English Date", CalcDate('-1Y+1M', Today));
        if EnglishNepaliDate.FindFirst then;
        LeavetypSetup.Reset;
        LeavetypSetup.SetFilter("Leave Category", '<>%1', LeavetypSetup."Leave Category"::Substitute);
        LeavetypSetup.SetRange("Needed HR Permission", false);
        LeavetypSetup.SetRange("Skip Balance Check", false);
        LeavetypSetup.SetRange("Employee No. Filter", Employee."No.");
        if LeavetypSetup.Find('-') then
            repeat
                LeavetypSetup.CalcFields("Remaining Days");
                HRSetup.Get;
                if LeavetypSetup."Remaining Days" > 0 then begin
                    if not LeavetypSetup."Carry Forwardable" then begin
                        LeaveEarn.Init;
                        LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                        LeaveEarn.Validate("Employee No.", Employee."No.");
                        LeaveEarn.Validate(Type, LeaveEarn.Type::"Balance via Fiscal Year");
                        LeaveEarn.Validate("Fiscal year", EnglishNepaliDate."Fiscal Year");
                        LeaveEarn.Validate("Posted Date", Today);
                        LeaveEarn.Validate("Balancing Days", -LeavetypSetup."Remaining Days");
                        LeaveEarn.Validate("Entry No.", GetNextLeaveLedgerEntryNo());
                        LeaveEarn.Insert();
                    end else if LeavetypSetup."Encashable Limit" < LeavetypSetup."Remaining Days" then begin
                        LeaveEarn.Init;
                        LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                        LeaveEarn.Validate("Employee No.", Employee."No.");
                        LeaveEarn.Validate(Type, LeaveEarn.Type::Encashed);
                        LeaveEarn.Validate("Fiscal year", EnglishNepaliDate."Fiscal Year");
                        LeaveEarn.Validate("Posted Date", Today);
                        LeaveEarn.Validate("Balancing Days", -(LeavetypSetup."Remaining Days" - LeavetypSetup."Encashable Limit"));
                        LeaveEarn.Validate("Entry No.", GetNextLeaveLedgerEntryNo());
                        LeaveEarn.Insert();
                    end;
                end;
            until LeavetypSetup.Next = 0;
    end;

    procedure UpdateLeaveEmployeeContract(EmpCode: Code[20]; JoiningDate: Date; EmployeeType: Option " ",Permanent,Probation,Contract; Gender: Option " ",Female,Male; MaritalStatus: Option)
    var
        LeaveEarn: Record "Leave Earn";
        LeavetypSetup: Record "Leave Type Setup";
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
        LeavetypSetup.SetFilter("Leave Category", '<>%1', LeavetypSetup."Leave Category"::Substitute);
        LeavetypSetup.SetRange("Needed HR Permission", false);
        LeavetypSetup.SetRange("Skip Balance Check", false);
        if LeavetypSetup.Find('-') then
            repeat
                Clear(LeaveEarn);
                LeaveEarn.SetRange("Leave Code", LeavetypSetup.Code);
                LeaveEarn.SetRange("Employee No.", EmpCode);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                if not LeaveEarn.FindFirst then begin
                    LeaveEarn.Init;
                    LeaveEarn.Validate("Entry No.", GetNextLeaveLedgerEntryNo());
                    LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                    LeaveEarn.Validate("Employee No.", EmpCode);
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
    var
        LeavePeriod: Record "Accounting Period";
    begin
        PayrollSetup.Get;
        if (Today < LeavePeriod.GetCurrentLeaveYearStartDate()) or (Today > LeavePeriod.GetCurrentLeaveYearEndDate()) then
            Error('Date must between %1 and %2', LeavePeriod.GetCurrentLeaveYearStartDate(), LeavePeriod.GetCurrentLeaveYearEndDate());
    end;

    procedure CalculateProDataLeave(LeaveCode: Code[20]; JoiningDate: Date): Decimal
    var
        LeaveTypeSetup: Record "Leave Type Setup";
        LeavePeriod: Record "Accounting Period";
    begin
        LeaveTypeSetup.Get(LeaveCode);
        if JoiningDate > LeavePeriod.GetCurrentLeaveYearStartDate() then begin
            HRSetup.Get();
            if HRSetup."Leave Rounding Precision" <> 0 then
                exit(Round((LeavePeriod.GetCurrentLeaveYearEndDate() - JoiningDate + 1) / 365 * LeaveTypeSetup."Days Earned Per Year", HRSetup."Leave Rounding Precision", '='))
            else
                exit(Round((LeavePeriod.GetCurrentLeaveYearEndDate() - JoiningDate + 1) / 365 * LeaveTypeSetup."Days Earned Per Year", 1, '<'));
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

        if LeaveTypeSetup."Min. Service Year Eligibility" <> 0 then begin
            DateExpr := '<' + Format(LeaveTypeSetup."Min. Service Year Eligibility") + 'Y>';
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
            EmpLeaveEarn.SetRange("Employee No.", EmpCode);
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
        LeaveEarn.SetRange("Employee No.", EmpCode);
        LeaveEarn.SetRange("Leave Code", LeaveTypecode);
        LeaveEarn.SetRange("Posted Date", 0D, PostDate);
        LeaveEarn.CalcSums("Balancing Days");
        exit(LeaveEarn."Balancing Days");
    end;


    procedure CheckForCompensatory(LeaveCode: Code[20]; EmpCode: Code[20]; CompensatoryDate: Date; NoOfDays: Decimal): Boolean
    var
        LeaveType: Record "Leave Type Setup";
        ErrorNoOfDays: Label 'No. days must be 1.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        ErrorPresent: Label 'Cannot apply compenstory leave for %1.';
        EmpActivity: Record "Employee Activity";
        LeavePeriod: Record "Accounting Period";
    begin
        LeaveType.Get(LeaveCode);
        PayrollSetup.Get;
        if LeaveType."Leave Category" = LeaveType."Leave Category"::Substitute then begin
            if NoOfDays <> 1 then
                Error(ErrorNoOfDays);
            if not (CompensatoryDate in [LeavePeriod.GetCurrentLeaveYearStartDate() .. LeavePeriod.GetCurrentLeaveYearEndDate()]) then
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
                    LeaveEarn.Validate("Entry No.", GetNextLeaveLedgerEntryNo());
                    LeaveEarn.Validate("Leave Code", LeaveType.Code);
                    LeaveEarn.Validate("Employee No.", Empcode);
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
        LeaveType.SetFilter("Leave Category", '<>%1', LeaveType."Leave Category"::Substitute);
        LeaveType.SetRange("Needed HR Permission", false);
        LeaveType.SetRange("Skip Balance Check", false);
        if LeaveType.Find('-') then
            repeat
                LeaveEarn.Init;
                LeaveEarn.Validate("Entry No.", GetNextLeaveLedgerEntryNo());
                LeaveEarn.Validate("Leave Code", LeaveType.Code);
                LeaveEarn.Validate("Employee No.", Empcode);
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
        ConfirmLeave: Label 'Do you want to send leave request ?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        LeaveTypeSetup: Record "Leave Type Setup";
        Ishandled: Boolean;
        LeavePeriod: Record "Accounting Period";
    begin
        LeaveTypeSetup.Get(Leave."Leave Code");
        OnBeforeLeaveApproved(Leave, Ishandled);
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
        //check for fiscal year start date
        if not (LeaveTypeSetup."Leave at Once" and LeaveTypeSetup."Needed HR Permission") then
            if (Leave."Start Date" < LeavePeriod.GetCurrentLeaveYearStartDate()) or (Leave."End Date" > LeavePeriod.GetCurrentLeaveYearEndDate()) then
                Error('Leave Start date must be within %1 - %2', LeavePeriod.GetCurrentLeaveYearStartDate(), LeavePeriod.GetCurrentLeaveYearEndDate());

        //Bereavement Leave
        if GuiAllowed then
            if LeaveTypeSetup."Leave Category" = LeaveTypeSetup."Leave Category"::"Bereavement Leave" then
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
        HRMgt.SendMailFromTemplate(DATABASE::Leave, Leave.Type::"Leave Request", Leave."Approval Status"::Pending, leave.Remarks, Leave."Employee No.", Leave."No.", 0);   //For email
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
        TempLeaveEarn.Validate("Employee No.", Employee."No.");
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
        IsHandled: Boolean;
        LeaveTypeSetup: Record "Leave Type Setup";
        ServiceInactivity: Record "Service Inactivity Ledger";
        NextEntryNo: Integer;
        EmpVar: Record Employee;
    begin
        leave.Get(leaveNo);
        OnBeforeLeaveApproved(leave, IsHandled);
        if not IsHandled then begin
            CreateLeaveLedger(leave."Employee No.",
                     leave."Leave Code",
                     leave."Start Date",
                     leaveEarn.Type::Used,
                     -leave."No. of Days",
                     GetNextLeaveLedgerEntryNo(),
                     leaveNo,
                     leave.Remarks,
                     '');
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
            ServiceInactivity.Validate("Source Doc No", leave."No.");
            ServiceInactivity.Insert(true);

            //update service period of employee
            EmpVar.Get(leave."Employee No.");
            EmpVar.Validate("Employment Date");
            EmpVar.Modify();
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
        LeaveEarn.Validate("Employee No.", EmpNo);
        LeaveEarn.Validate(Type, EarnType);
        LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(RequestedDate));
        LeaveEarn.Validate("Posted Date", Today);
        LeaveEarn.Validate("Balancing Days", Days);
        LeaveEarn.Validate("Leave Request No", DocumentNo);
        LeaveEarn.Validate("Entry No.", GetNextLeaveLedgerEntryNo());
        LeaveEarn.Insert(true);
    end;

    procedure ApproveCancelledLeave(CancelLeaveCode: Code[20])
    var
        LeaveEarn: Record "Leave Earn";
        CancelDocument: Record "Cancel Document";
        ServiceInactivity: Record "Service Inactivity Ledger";
        EmpVar: Record Employee;
        NextEntryNo: Integer;
    begin
        CancelDocument.Get(CancelLeaveCode);
        CancelDocument.TestField(Type, CancelDocument.Type::"Leave Request");
        if CancelDocument.Type = CancelDocument.Type::"Leave Request" then begin
            CreateLeaveLedger(CancelDocument."Employee No.",
                     CancelDocument."Leave Code",
                     CancelDocument."Start Date",
                     leaveEarn.Type::Cancelled,
                     CancelDocument."No. of Days",
                     GetNextLeaveLedgerEntryNo(),
                     CancelDocument."No.",
                     CancelDocument.Remarks,
                     '');

            LeaveTypeSetup.get(CancelDocument."Leave Code");
            if LeaveTypeSetup."Exclude in Service Period" then begin
                ServiceInactivity.SetRange("Source Doc No", CancelDocument."Cancelled Document No.");
                ServiceInactivity.SetRange("Employee No.", CancelDocument."Employee No.");
                if ServiceInactivity.FindFirst() then
                    ServiceInactivity.Delete();

                //update service period of employee
                EmpVar.Get(CancelDocument."Employee No.");
                EmpVar.Validate("Employment Date");
                EmpVar.Modify();
            end;
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

    procedure GenerateLeave(EmpCode: Code[20]; PostingDate: Date): Boolean
    var
        LeaveLedgerEntry: Record "Leave Earn";
        LeaveTypeSetup: Record "Leave Type Setup";
        LeavePeriod, LeavePeriod1 : Record "Accounting Period";
        EmpVar, EmpVar2 : Record Employee;
        AttendanceMgt: Codeunit "Attendance Mgt";
        LastEntryNo: Integer;
        AnnualCreditLimit, ActualCreditLimit, LeaveDaysToCredit, ServiceYears, AttendanceDays, NoOfCreditPeriods : Decimal;
        ProRataStartDate, ProRataEndDate, CreditPeriodStartDate, CreditPeriodEndDate, LeaveYearStartDate, LeaveYearEndDate : Date;
        SkipLeaveEarn: Boolean;
    begin
        Clear(LastEntryNo);
        Clear(ProRataStartDate);
        Clear(ProRataEndDate);
        HRSetup.Get();
        LastEntryNo := GetNextLeaveLedgerEntryNo();
        LeaveYearStartDate := LeavePeriod.GetLeaveYearStartDate(PostingDate);
        LeaveYearEndDate := LeavePeriod.GetLeaveYearEndDate(PostingDate);

        EmpVar.Reset();
        if EmpCode <> '' then
            EmpVar.SetRange("No.", EmpCode);
        EmpVar.SetRange(Status, EmpVar.Status::Active);
        EmpVar.SetFilter("Termination Date", '%1|>=%2', 0D, LeaveYearStartDate);
        EmpVar.SetFilter("Employment Date", '<=%1', PostingDate);
        OnGenerateLeaveOnAfterSelectEmployee(Employee);   //if further filter is required
        if EmpVar.FindSet() then begin
            repeat
                if EmpVar."Employment Date" < LeaveYearStartDate then
                    CreditPeriodStartDate := LeaveYearStartDate
                else
                    CreditPeriodStartDate := EmpVar."Employment Date";
                if PostingDate < LeaveYearEndDate then
                    CreditPeriodEndDate := PostingDate
                else
                    CreditPeriodEndDate := LeaveYearEndDate;
                if (EmpVar."Termination Date" <> 0D) and (EmpVar."Termination Date" < CreditPeriodEndDate) then
                    CreditPeriodEndDate := EmpVar."Termination Date";
                ServiceYears := CalculateYearsBetweenDates(EmpVar."Employment Date", PostingDate);

                LeaveTypeSetup.Reset();
                LeaveTypeSetup.SetFilter("Credit Method", '%1|%2', LeaveTypeSetup."Credit Method"::Automatic, LeaveTypeSetup."Credit Method"::Attendance);
                LeaveTypeSetup.SetFilter("Days Earned Per Year", '>0');
                LeaveTypeSetup.SetFilter("Leave For Employee Type", '%1|%2', EmpVar."Employment Type", LeaveTypeSetup."Leave For Employee Type"::" ");
                if EmpVar."Employment Type" <> EmpVar."Employment Type"::Contract then
                    LeaveTypeSetup.SetRange("Emplymt. Contract Code", '');

                LeaveTypeSetup.SetFilter("Marital Status", '%1|%2', EmpVar."Marital Status", LeaveTypeSetup."Marital Status"::" ");
                LeaveTypeSetup.SetFilter(Gender, '%1|%2', EmpVar.Gender, LeaveTypeSetup.Gender::" ");
                LeaveTypeSetup.SetFilter("Min. Service Year Eligibility", '0|<=%1', ServiceYears);
                LeaveTypeSetup.SetRange("Needed HR Permission", false);
                OnGenerateLeaveOnSelectLeaveTypeSetup(LeaveTypeSetup, EmpVar);  //if further filter is required

                if LeaveTypeSetup.FindFirst() then
                    repeat
                        Clear(SkipLeaveEarn);
                        NoOfCreditPeriods := 0;

                        if (EmpVar."Employment Type" = EmpVar."Employment Type"::Contract) and
                            (LeaveTypeSetup."Emplymt. Contract Code" <> '') then begin
                            EmpVar2.Reset();
                            EmpVar2.SetRange("No.", EmpVar."No.");
                            EmpVar2.SetFilter("Emplymt. Contract Code", LeaveTypeSetup."Emplymt. Contract Code");
                            if not EmpVar2.FindFirst() then
                                SkipLeaveEarn := true;
                        end;
                        OnGenerateLeaveOnBeforeLeaveCalculation(LeaveTypeSetup, EmpVar, SkipLeaveEarn);
                        if not SkipLeaveEarn then begin

                            AnnualCreditLimit := LeaveTypeSetup."Days Earned Per Year";

                            OnGenerateLeaveOnAfterSetAnnualCreditLimit(LeaveTypeSetup, EmpVar, AnnualCreditLimit, PostingDate);
                            if LeaveTypeSetup."Credit Method" = LeaveTypeSetup."Credit Method"::Automatic then begin
                                //credit frequency monthly
                                if LeaveTypeSetup."Credit Frequency" = LeaveTypeSetup."Credit Frequency"::Monthly then begin
                                    LeavePeriod.Reset();
                                    LeavePeriod.SetFilter("Starting Date", '>=%1&<=%2', CreditPeriodStartDate, CreditPeriodEndDate);
                                    NoOfCreditPeriods := LeavePeriod.Count;
                                    if LeavePeriod.FindFirst() then
                                        if LeavePeriod."Starting Date" > CreditPeriodStartDate then
                                            NoOfCreditPeriods += 1;
                                    if LeaveTypeSetup."Credit At" = LeaveTypeSetup."Credit At"::"End" then begin
                                        if LeavePeriod.FindLast() then;
                                        LeavePeriod1.Reset();
                                        LeavePeriod1.SetFilter("Starting Date", '>%1', LeavePeriod."Starting Date");
                                        LeavePeriod1.FindFirst();
                                        if (LeavePeriod1."Starting Date" - 1) > CreditPeriodEndDate then
                                            NoOfCreditPeriods -= 1;
                                    end;

                                    CalculateProrataLeavePeriod(NoOfCreditPeriods, EmpVar."Employment Date");
                                    ActualCreditLimit := Round(AnnualCreditLimit / 12 * NoOfCreditPeriods, 0.01, '=');
                                end else
                                    //credit frequency annual
                                    if LeaveTypeSetup."Credit Frequency" = LeaveTypeSetup."Credit Frequency"::Annual then begin
                                        ProRataStartDate := LeavePeriod.GetLeaveYearStartDate(PostingDate);
                                        if EmpVar."Employment Date" > ProRataStartDate then
                                            ProRataStartDate := EmpVar."Employment Date";

                                        ProRataEndDate := LeavePeriod.GetLeaveYearEndDate(PostingDate);
                                        if EmpVar."Termination Date" <> 0D then
                                            ProRataEndDate := EmpVar."Termination Date";
                                        if ProRataEndDate >= LeavePeriod.GetLeaveYearEndDate(PostingDate) then
                                            ProRataEndDate := LeavePeriod.GetLeaveYearEndDate(PostingDate);
                                        if (EmpVar."Employment Date" <= LeavePeriod.GetLeaveYearStartDate(PostingDate)) and (ProRataEndDate = LeavePeriod.GetLeaveYearEndDate(PostingDate)) then
                                            ActualCreditLimit := AnnualCreditLimit
                                        else begin

                                            LeavePeriod.Reset();
                                            LeavePeriod.SetFilter("Starting Date", '>=%1&<=%2', ProRataStartDate, ProRataEndDate);
                                            NoOfCreditPeriods := LeavePeriod.Count;
                                            if LeavePeriod.FindFirst() then
                                                if LeavePeriod."Starting Date" > ProRataStartDate then
                                                    NoOfCreditPeriods += 1;

                                            CalculateProrataLeavePeriod(NoOfCreditPeriods, EmpVar."Employment Date");
                                            ActualCreditLimit := Round(AnnualCreditLimit / 12 * NoOfCreditPeriods, 0.01, '=');
                                        end;
                                    end
                                    else
                                        ActualCreditLimit := 0;

                                LeaveLedgerEntry.Reset();
                                LeaveLedgerEntry.SetRange("Leave Code", LeaveTypeSetup.Code);
                                LeaveLedgerEntry.SetRange(Type, LeaveLedgerEntry.Type::Earned);
                                LeaveLedgerEntry.SetRange("Employee No.", EmpVar."No.");
                                LeaveLedgerEntry.SetRange("Posted Date", CreditPeriodStartDate, CreditPeriodEndDate);
                                LeaveLedgerEntry.CalcSums("Balancing Days");
                                if LeaveLedgerEntry."Balancing Days" < ActualCreditLimit then begin
                                    if HRSetup."Leave Rounding Precision" <> 0 then
                                        LeaveDaysToCredit := Round(ActualCreditLimit - LeaveLedgerEntry."Balancing Days", HRSetup."Leave Rounding Precision", '=')
                                    else
                                        LeaveDaysToCredit := Round(ActualCreditLimit - LeaveLedgerEntry."Balancing Days", 0.5, '<')
                                end else
                                    LeaveDaysToCredit := 0;
                                if LeaveDaysToCredit > 0 then
                                    EarnMinimumLeave(EmpVar."No.", LeaveTypeSetup, LeaveDaysToCredit, CreditPeriodEndDate, LastEntryNo);
                            end
                            else
                                if LeaveTypeSetup."Credit Method" = LeaveTypeSetup."Credit Method"::Attendance then begin
                                    AttendanceDays := AttendanceMgt.GetPresentDays(EmpVar."No.", CreditPeriodStartDate, CreditPeriodEndDate);
                                    if LeaveTypeSetup."Attendance Days" = 0 then
                                        ActualCreditLimit := Round(((AnnualCreditLimit / (LeaveYearEndDate - LeaveYearStartDate + 1)) * AttendanceDays), 0.5, '<')
                                    else
                                        ActualCreditLimit := Round((AttendanceDays / LeaveTypeSetup."Attendance Days"), 0.5, '<');

                                    if LeaveTypeSetup."Days Earned Per Year" <> 0 then
                                        if ActualCreditLimit > LeaveTypeSetup."Days Earned Per Year" then
                                            ActualCreditLimit := LeaveTypeSetup."Days Earned Per Year";

                                    LeaveLedgerEntry.Reset();
                                    LeaveLedgerEntry.SetRange("Leave Code", LeaveTypeSetup.Code);
                                    LeaveLedgerEntry.SetRange(Type, LeaveLedgerEntry.Type::Earned);
                                    LeaveLedgerEntry.SetRange("Employee No.", EmpVar."No.");
                                    LeaveLedgerEntry.SetRange("Posted Date", CreditPeriodStartDate, CreditPeriodEndDate);
                                    LeaveLedgerEntry.CalcSums("Balancing Days");
                                    if LeaveLedgerEntry."Balancing Days" < ActualCreditLimit then begin
                                        if HRSetup."Leave Rounding Precision" <> 0 then
                                            LeaveDaysToCredit := Round(ActualCreditLimit - LeaveLedgerEntry."Balancing Days", HRSetup."Leave Rounding Precision", '=')
                                        else
                                            LeaveDaysToCredit := Round(ActualCreditLimit - LeaveLedgerEntry."Balancing Days", 0.5, '<')
                                    end else
                                        LeaveDaysToCredit := 0;
                                    if LeaveDaysToCredit > 0 then
                                        EarnMinimumLeave(EmpVar."No.", LeaveTypeSetup, LeaveDaysToCredit, CreditPeriodEndDate, LastEntryNo);
                                end;

                        end;
                    until LeaveTypeSetup.Next() = 0;
            until EmpVar.Next() = 0;
            exit(true);
        end;
    end;

    local procedure CalculateYearsBetweenDates(StartDate: Date; EndDate: Date): Decimal
    var
        StartYearValue, MiddleYearsValue, EndYearValue : Decimal;
        StartYearNumber, EndYearNumber, DaysInStartYear, DaysInEndYear : Integer;
    begin
        if EndDate < StartDate then
            exit(0);
        StartYearNumber := Date2DMY(StartDate, 3);
        EndYearNumber := Date2DMY(EndDate, 3);
        DaysInStartYear := DMY2Date(31, 12, StartYearNumber) - DMY2Date(1, 1, StartYearNumber) + 1;
        DaysInEndYear := DMY2Date(31, 12, EndYearNumber) - DMY2Date(1, 1, EndYearNumber) + 1;
        StartYearValue := ((StartDate - DMY2Date(31, 12, StartYearNumber)) + 1) / DaysInStartYear;
        EndYearValue := ((DMY2Date(31, 12, EndYearNumber) - EndDate) + 1) / DaysInEndYear;
        MiddleYearsValue := EndYearNumber - StartYearNumber - 1;
        exit(StartYearValue + MiddleYearsValue + EndYearValue);
    end;

    procedure EarnMinimumLeave(EmpCode: Code[20]; LeaveTypeSetup: Record "Leave Type Setup"; EarnLeave: Decimal; EarnDate: Date; var LastEntryNo: Integer)
    var
        LeaveLedgerEntry: Record "Leave Earn";
    begin
        LastEntryNo := CreateLeaveLedger(EmpCode,
                      LeaveTypeSetup.Code,
                      EarnDate,
                      LeaveLedgerEntry.Type::Earned,
                      EarnLeave,
                      LastEntryNo,
                      '',
                      'Leave Earned',
                      '');
    end;

    procedure CreateLeaveLedger(empCode: Code[20]; leaveCode: Code[20];
                                       PostingDate: Date;
                                       LeaveEarnType: Enum "Leave Earn Type";
                                                          BalanceDays: Decimal;
                                       entryNo: Integer;
                                       ExtDocumentNo: Code[20];
                                       Remarks: Text[100];
                                       Office: Code[20]): Integer
    var
        leaveLedger: Record "Leave Earn";
        EngNep: Record "English-Nepali Date";
        EmpVar: Record Employee;
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", PostingDate);
        if EngNep.FindFirst then;
        EmpVar.Get(empCode);
        Clear(leaveLedger);
        leaveLedger.Init();
        leaveLedger."Entry No." := entryNo;
        leaveLedger.Validate("Employee No.", empCode);
        leaveLedger.Validate("Leave Code", leaveCode);
        leaveLedger.Validate("Posted Date", PostingDate);
        leaveLedger.Validate(Type, LeaveEarnType);
        leaveLedger.Validate("Balancing Days", BalanceDays);
        leaveLedger.Validate("Leave Request No", ExtDocumentNo);
        leaveLedger."Fiscal Year" := EngNep."Fiscal Year";
        leaveLedger.Remarks := Remarks;
        leaveLedger.Insert(true);
        exit(entryNo + 1);
    end;

    procedure GetNextLeaveLedgerEntryNo(): Integer
    var
        leaveLedgerEntry: Record "Leave Earn";
    begin
        leaveLedgerEntry.Reset();
        if leaveLedgerEntry.FindLast() then
            exit(leaveLedgerEntry."Entry No." + 1)
        else
            exit(1);
    end;

    procedure LeaveEncash(EmpCode: Code[20]; EncashmentDate: Date)
    var
        EmpVar: Record Employee;
        LeaveTypeSetup: Record "Leave Type Setup";
        entryNo: Integer;
        ExtendedEncashLimit: Decimal;
    begin
        EmpVar.Reset();
        if EmpCode <> '' then
            EmpVar.SetRange("No.", EmpCode);
        if EmpVar.FindSet() then
            repeat
                LeaveTypeSetup.Reset();
                LeaveTypeSetup.SetRange(Encashable, true);
                LeaveTypeSetup.SetFilter("Encashable Limit", '<>%1', 0);
                LeaveTypeSetup.SetFilter("Employee No. Filter", EmpVar."No.");
                LeaveTypeSetup.SetFilter("Date Filter", '..%1', EncashmentDate);
                LeaveTypeSetup.SetFilter("Remaining Days", '<>%1', 0);
                if LeaveTypeSetup.FindSet() then
                    repeat
                        LeaveTypeSetup.CalcFields("Remaining Days");
                        ExtendedEncashLimit := LeaveTypeSetup."Encashable Limit";
                        OnLeaveEncashOnbeforeCheckEncashLimit(LeaveTypeSetup, EmpVar, ExtendedEncashLimit);  //use it if employee has different encash limit.
                        if LeaveTypeSetup."Remaining Days" > ExtendedEncashLimit then
                            CreateLeaveLedger(EmpCode,
                                                LeaveTypeSetup.Code,
                                                EncashmentDate,
                                                "Leave Earn Type"::Encashed,
                                                LeaveTypeSetup."Remaining Days" - ExtendedEncashLimit,
                                                GetNextLeaveLedgerEntryNo,
                                                '',
                                                'Leave Encashed',
                                                '');
                    until LeaveTypeSetup.Next() = 0;
            until EmpVar.Next() = 0;

    end;

    procedure CalculateProrataLeavePeriod(var LeaveCreditPeriods: Decimal; EmployementDate: Date)
    var
        LeavePeriod, LeavePeriod2 : Record "Accounting Period";
        LeaveYearStartDate, EmployementMonthStartDate, EmployementMonthEndDate : Date;
        IsHandled: Boolean;
    begin
        //for employee who join at the middle of month of current leave year

        LeaveYearStartDate := LeavePeriod.GetCurrentLeaveYearStartDate();
        if LeaveYearStartDate >= EmployementDate then
            exit;

        LeavePeriod.Reset();
        LeavePeriod.SetFilter("Starting Date", '<%1', EmployementDate);
        if LeavePeriod.FindLast() then
            EmployementMonthStartDate := LeavePeriod."Starting Date";

        LeavePeriod.SetFilter("Starting Date", '>%1', EmployementDate);
        if LeavePeriod.FindFirst() then
            EmployementMonthEndDate := LeavePeriod."Starting Date" - 1;

        LeaveCreditPeriods += Round((EmployementMonthEndDate - EmployementDate + 1) / (EmployementMonthEndDate - EmployementMonthStartDate + 1), 0.01, '=')
                            - 1
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeLeaveApproved(leave: Record Leave; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGenerateLeaveOnAfterSelectEmployee(var Employee: Record Employee)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGenerateLeaveOnSelectLeaveTypeSetup(var LeaveTypeSetup: Record "Leave Type Setup"; var EmpVar: Record Employee)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLeaveEncashOnbeforeCheckEncashLimit(var LeaveTypeSetup: Record "Leave Type Setup";
                                                            var EmpVar: record Employee; var ExtendedEncashLimit: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateNoOfDaysinLeave(var LeaveTypeSetup: Record "Leave Type Setup"; var StartDate: Date; var EndDate: Date;
                                        var Empcode: code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGenerateLeaveOnBeforeLeaveCalculation(var LeaveTypeSetup: Record "Leave Type Setup"; var EmpVar: Record Employee; var SkipLeaveEarn: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGenerateLeaveOnAfterSetAnnualCreditLimit(var LeaveTypeSetup: Record "Leave Type Setup";
                 var EmpVar: Record Employee; var AnnualCreditLimit: Decimal; var PostingDate: Date)

    begin
        //Same employee type, same leave but days earned per year is different on the basis of employment date (EBL)
    end;

    [IntegrationEvent(false, false)]
    procedure IsfridayandCasual(leaveReq: Record Leave; StartDate: Date; EndDate: Date; LeaveCode: Code[20]; EmpCode: Code[20]; var IsHandled: Boolean; var CalculatedDays: Decimal)
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
        ApproverMgt: Codeunit "Approver Mgt";
        LeaveTypeSetup: Record "Leave Type Setup";
        AttendanceMgt: Codeunit "Attendance Mgt";
}
