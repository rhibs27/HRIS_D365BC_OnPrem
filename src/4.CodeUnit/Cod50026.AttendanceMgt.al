codeunit 50026 "Attendance Mgt"
{
    //this is used from company specific extension

    procedure TextToDuration(InputText: Text): Duration
    var
        Millisec: BigInteger;
    begin
        if not Evaluate(Millisec, InputText) then
            exit;

        exit(Millisec * 3600000); // Convert milliseconds to duration
    end;

    procedure DailyAttendanceUpdate(StartDate: Date; EndDate: Date; EmployeeNo: Code[20]): Boolean
    var
        ProcessDailyAttendance: Report "Process Daily Attendance";
        Employee: Record Employee;
    begin
        Employee.SetRange("No.", EmployeeNo);
        Employee.SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
        ProcessDailyAttendance.SetTableView(Employee);
        ProcessDailyAttendance.UseRequestPage(false);
        ProcessDailyAttendance.Run();
        exit(true);
    end;

    procedure GetPresentDays(EmpCode: Code[20]; PStartDate: Date; PEndDate: Date): Decimal
    var
        EmpAtt: Record "Employee Attendance & Activity";
        actualPresentDays: Decimal;
        AttendanceDate: Date;
    begin
        actualPresentDays := 0;
        Clear(AttendanceDate);
        EmpAtt.Reset();
        EmpAtt.SetRange("Employee No.", EmpCode);
        EmpAtt.SetRange("Attendance Date", PStartDate, PEndDate);
        EmpAtt.CalcSums("Present Day", "Week Off Day", "Tour Day", "Training Day", "Leave Day");
        actualPresentDays := EmpAtt."Present Day" + EmpAtt."Week Off Day" + EmpAtt."Tour Day" + EmpAtt."Training Day" + EmpAtt."Leave Day";
        exit(actualPresentDays);
    end;

    procedure CheckOverNightShift(WorkShiftCode: Code[20]): Boolean
    var
        EmployeeWorkShift: Record "Employee Work Shift";
    begin
        if EmployeeWorkShift.Get(WorkShiftCode) then begin
            if EmployeeWorkShift.OverNight then
                exit(true)
        end;
    end;

    procedure ApproveLateAttendance(docNo: Code[20])
    var
        EmpAttenActivity: Record "Employee Attendance & Activity";
        AttenMissed: Record "Attendance Missed";
    begin
        AttenMissed.Get(docNo);
        if AttenMissed.Type <> AttenMissed.Type::"Late Attendance" then
            exit;

        if DailyAttendanceUpdate(AttenMissed."Start Date", AttenMissed."Start Date", AttenMissed."Employee No.") then begin
            EmpAttenActivity.SetRange("Employee No.", AttenMissed."Employee No.");
            EmpAttenActivity.SetRange("Attendance Date", AttenMissed."Start Date");
            if EmpAttenActivity.FindSet() then
                EmpAttenActivity.ModifyAll("Late Remarks", AttenMissed.Remarks);
        end;
    end;

    procedure CheckEmployeePresent(EmpCode: Code[20]; AttendanceDate: Date): Boolean
    var
        EmpAtt: Record "Employee Attendance & Activity";
    begin
        EmpAtt.Reset();
        EmpAtt.SetRange("Employee No.", EmpCode);
        EmpAtt.SetRange("Attendance Date", AttendanceDate);
        if EmpAtt.FindFirst() then
            if EmpAtt."Present Day" <> 0 then
                exit(true);
    end;

    procedure GetNonWorkingDaysFromAttendance(StartDate: Date; EndDateDate: Date; DeputationOn: Enum "Deputation Type"; DeputationOnCode: Code[20]; ProvinceCode: Code[20]; EmpCode: Code[20]): Integer
    var
        Description: Text;
        Provinces: Text;
        Gender: Enum "Employee Gender";
        OrganizationStructureList, EmployeeOrganizationStructureList : Record "Organization Structure List";
        DistrictList: Record District;
        MunicipalityList: Record Municipality;
        CalendarDate: Record Date;
        Counter: Integer;
        isNonWorkingDay, FilterMatched : Boolean;
        InOutValley: Enum "Outside/Inside Valley";
        PostingRegion: Enum Region;
        Branch, District, MunicipalityFilter : Text;
        Community: Enum "Community Type";
        EmployeeFilter: Text[500];
        Disabled: Boolean;
        EmployeeRec: Record Employee;
    begin
        if EmployeeOrganizationStructureList.Get(DeputationOn, DeputationOnCode) then;
        Counter := 0;
        PayrollSetup.Get;
        Employee.Get(EmpCode);
        CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Date);
        CalendarDate.SetRange("Period Start", StartDate, EndDateDate);
        if CalendarDate.Find('-') then
            repeat
                isNonWorkingDay := true;
                if HRMgt.CheckDateStatus(PayrollSetup."Base Calendar", CalendarDate."Period Start", Description, Provinces, Gender, InOutValley, PostingRegion, Branch, District, MunicipalityFilter, Community, EmployeeFilter, Disabled) then begin
                    CalendarDescription := Description;
                    if (Provinces = '') and (Gender = Gender::" ") and (InOutValley = InOutValley::" ") and (PostingRegion = PostingRegion::" ") and (Branch = '') and (District = '') and (MunicipalityFilter = '') and (community = community::" ") and (EmployeeFilter = '') and (not Disabled) then
                        Counter += 1
                    else begin
                        if Provinces <> '' then begin
                            Clear(FilterMatched);
                            OrganizationStructureList.Reset;
                            OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Province);
                            OrganizationStructureList.SetFilter(Code, Provinces);
                            if OrganizationStructureList.Find('-') then
                                repeat
                                    if (ProvinceCode = OrganizationStructureList.Code) then begin
                                        FilterMatched := true;
                                        break;
                                    end;
                                until OrganizationStructureList.Next = 0;
                            isNonWorkingDay := isNonWorkingDay and FilterMatched;
                        end;
                        if Gender <> Gender::" " then
                            isNonWorkingDay := isNonWorkingDay and (Employee.Gender = gender);
                        if PostingRegion <> PostingRegion::" " then
                            isNonWorkingDay := isNonWorkingDay and (PostingRegion = EmployeeOrganizationStructureList.Region);
                        if Branch <> '' then begin
                            Clear(FilterMatched);
                            OrganizationStructureList.Reset;
                            OrganizationStructureList.SetRange(Type, OrganizationStructureList.type::Branch);
                            OrganizationStructureList.SetFilter(Code, Branch);
                            if OrganizationStructureList.Find('-') then
                                repeat
                                    if (OrganizationStructureList.Code = EmployeeOrganizationStructureList.Code) then begin
                                        FilterMatched := true;
                                        break;
                                    end;
                                until OrganizationStructureList.Next = 0;
                            isNonWorkingDay := isNonWorkingDay and FilterMatched;
                        end;
                        if District <> '' then begin
                            Clear(FilterMatched);
                            DistrictList.Reset;
                            DistrictList.Setfilter("District Name", District);
                            if DistrictList.Find('-') then
                                repeat
                                    if (DistrictList."District Name" = HRMgt.GetEmployeeDeputationDistrictName(DeputationOn, DeputationOnCode)) then begin
                                        break;
                                    end;
                                until DistrictList.Next = 0;
                            isNonWorkingDay := isNonWorkingDay and FilterMatched;
                        end;
                        if (MunicipalityFilter <> '') then begin
                            Clear(FilterMatched);
                            MunicipalityList.Reset;
                            MunicipalityList.Setfilter(Code, MunicipalityFilter);
                            if MunicipalityList.Find('-') then
                                repeat
                                    if (MunicipalityList.Code = HRMgt.GetEmployeeDeputationMunicipalityCode(DeputationOn, DeputationOnCode)) then begin
                                        FilterMatched := true;
                                        break;
                                    end;
                                until MunicipalityList.Next = 0;
                            isNonWorkingDay := isNonWorkingDay and FilterMatched;
                        end;
                        if InOutValley <> InOutValley::" " then
                            isNonWorkingDay := isNonWorkingDay and (EmployeeOrganizationStructureList."InsideOutside Valley" = InOutValley);
                        if Community <> Community::" " then
                            isNonWorkingDay := isNonWorkingDay and (Employee.Community = Community);
                        if EmployeeFilter <> '' then begin
                            Clear(FilterMatched);
                            EmployeeRec.Reset;
                            EmployeeRec.Setfilter("No.", EmployeeFilter);
                            if EmployeeRec.Find('-') then
                                repeat
                                    if (EmployeeRec."No." = EmpCode) then begin
                                        FilterMatched := true;
                                        break;
                                    end;
                                until EmployeeRec.Next = 0;
                            isNonWorkingDay := isNonWorkingDay and FilterMatched;
                        end;
                        if Disabled then
                            isNonWorkingDay := isNonWorkingDay and (Employee.Disabled = disabled);
                        //check OR condition
                        GetNonWorkingDaysOR(PayrollSetup."Base Calendar", CalendarDate."Period Start", DeputationOn, DeputationOnCode, ProvinceCode, Employee, isNonWorkingDay);
                        if isNonWorkingDay then  //The day is holiday for that employee
                            Counter += 1;
                    end;
                end;
            until CalendarDate.Next = 0;
        exit(Counter);
    end;

    procedure GetNonWorkingDaysOR(BaseCalCode: Code[20]; TargetDate: Date; DeputationOn: Enum "Deputation Type"; DeputationOnCode: Code[20]; ProvinceCode: Code[20]; Employee: Record Employee; var isNonWorkingDay: Boolean)
    var
        Description: Text;
        Provinces: Text;
        Gender: Enum "Employee Gender";
        OrganizationStructureList, EmployeeOrganizationStructureList : Record "Organization Structure List";
        DistrictList: Record District;
        MunicipalityList: Record Municipality;
        FilterMatched: Boolean;
        InOutValley: Enum "Outside/Inside Valley";
        PostingRegion: Enum Region;
        Branch, District, MunicipalityFilter : Text;
        Community: Enum "Community Type";
        EmployeeFilter: Text[500];
        Disabled: Boolean;
        EmployeeRec: Record Employee;
    begin
        if EmployeeOrganizationStructureList.Get(DeputationOn, DeputationOnCode) then;
        if LeaveMgt.CheckDateStatusOR(PayrollSetup."Base Calendar", TargetDate, Description, Provinces, Gender, InOutValley, PostingRegion, Branch, District, MunicipalityFilter, Community, EmployeeFilter, Disabled) then begin
            CalendarDescription := Description;
            if Provinces <> '' then begin
                Clear(FilterMatched);
                OrganizationStructureList.Reset;
                OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Province);
                OrganizationStructureList.SetFilter(Code, Provinces);
                if OrganizationStructureList.Find('-') then
                    repeat
                        if (ProvinceCode = OrganizationStructureList.Code) then begin
                            FilterMatched := true;
                            break;
                        end;
                    until OrganizationStructureList.Next = 0;
                isNonWorkingDay := isNonWorkingDay or FilterMatched;
            end;
            if Gender <> Gender::" " then
                isNonWorkingDay := isNonWorkingDay or (Employee.Gender = gender);
            if PostingRegion <> PostingRegion::" " then
                isNonWorkingDay := isNonWorkingDay or (PostingRegion = EmployeeOrganizationStructureList.Region);
            if Branch <> '' then begin
                Clear(FilterMatched);
                OrganizationStructureList.Reset;
                OrganizationStructureList.SetRange(Type, OrganizationStructureList.type::Branch);
                OrganizationStructureList.SetFilter(Code, Branch);
                if OrganizationStructureList.Find('-') then
                    repeat
                        if (OrganizationStructureList.Code = EmployeeOrganizationStructureList.Code) then begin
                            FilterMatched := true;
                            break;
                        end;
                    until OrganizationStructureList.Next = 0;
                isNonWorkingDay := isNonWorkingDay or FilterMatched;
            end;
            if District <> '' then begin
                Clear(FilterMatched);
                DistrictList.Reset;
                DistrictList.Setfilter("District Name", District);
                if DistrictList.Find('-') then
                    repeat
                        if (DistrictList."District Name" = HRMgt.GetEmployeeDeputationDistrictName(DeputationOn, DeputationOnCode)) then begin
                            break;
                        end;
                    until DistrictList.Next = 0;
                isNonWorkingDay := isNonWorkingDay or FilterMatched;
            end;
            if (MunicipalityFilter <> '') then begin
                Clear(FilterMatched);
                MunicipalityList.Reset;
                MunicipalityList.Setfilter(Code, MunicipalityFilter);
                if MunicipalityList.Find('-') then
                    repeat
                        if (MunicipalityList.Code = HRMgt.GetEmployeeDeputationMunicipalityCode(DeputationOn, DeputationOnCode)) then begin
                            FilterMatched := true;
                            break;
                        end;
                    until MunicipalityList.Next = 0;
                isNonWorkingDay := isNonWorkingDay or FilterMatched;
            end;
            if InOutValley <> InOutValley::" " then
                isNonWorkingDay := isNonWorkingDay or (EmployeeOrganizationStructureList."InsideOutside Valley" = InOutValley);
            if Community <> Community::" " then
                isNonWorkingDay := isNonWorkingDay or (Employee.Community = Community);
            if EmployeeFilter <> '' then begin
                Clear(FilterMatched);
                EmployeeRec.Reset;
                EmployeeRec.Setfilter("No.", EmployeeFilter);
                if EmployeeRec.Find('-') then
                    repeat
                        if (EmployeeRec."No." = Employee."No.") then begin
                            FilterMatched := true;
                            break;
                        end;
                    until EmployeeRec.Next = 0;
                isNonWorkingDay := isNonWorkingDay or FilterMatched;
            end;
            if Disabled then
                isNonWorkingDay := isNonWorkingDay or (Employee.Disabled = disabled);
        end;
    end;

    procedure ReturnCalendarDescription(): Text
    begin
        exit(CalendarDescription);
    end;

    procedure GetWeekendCount(StartDate: Date; EndDate: Date): Integer
    var
        BaseCalChange: Record "Base Calendar Change";
        TargetDate: Date;
        Counter: Integer;
    begin
        Counter := 0;
        BaseCalChange.SetRange("Recurring System", BaseCalChange."Recurring System"::"Weekly Recurring");
        if BaseCalChange.FindFirst() then begin
            for TargetDate := StartDate to EndDate do begin
                if DATE2DWY(TargetDate, 1) = BaseCalChange.Day then
                    Counter += 1;
            end;
            exit(Counter);
        end;
    end;

    procedure GetTotalWorkingDays(StartDate: Date; EndDate: Date; EmployeeNo: Code[20]): Integer
    var
        TotalDays: Integer;
        NonWorkingDays: Integer;
    begin
        TotalDays := EndDate - StartDate + 1;
        NonWorkingDays := LeaveMgt.GetNonWorkingDays(StartDate, EndDate, EmployeeNo);
        exit(TotalDays - NonWorkingDays);
    end;

    var
        CalendarDescription: Text;
        Employee: Record Employee;
        PayrollSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
}
