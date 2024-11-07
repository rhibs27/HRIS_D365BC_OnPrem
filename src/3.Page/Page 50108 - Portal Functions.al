page 50108 "Portal Functions"
{
    // version APINICASIA1.00
    PageType = API;
    APIPublisher = 'Agile';
    APIGroup = 'HRMS';
    Caption = 'portalFunctions';
    EntityName = 'portalFunction';
    EntitySetName = 'portalFunctions';
    APIVersion = 'v2.0';
    SourceTable = "Portal Function";
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(PrimaryKey; Rec.PrimaryKey) { }
            }
        }
    }

    actions { }

    var
        SystemAdminTxt: Label ' Please contact your system administrator.';
        NoEmployeeMappingErr: Label 'No Employee card found for this user in Dynamics Business Central.';
        HrMgt: Codeunit "HR Mgt.";
        LoanMgt: Codeunit "Loan Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        FileManagement: Codeunit "File Management";
        HRSetup: Record "Human Resources Setup";
        TotalServicePeriod: Decimal;
        EligibleLoan: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        Employee: Record Employee;
        PGSetup: Record "Payroll General Setup";
        AttendanceSetup: Record "Attendance Setup";
        EmpActivity: Record "Employee Activity";
        ReturnAPIValue: Text;
        UserSetup: Record "User Setup";
        CheckSalaryLevel: Record "Salary Level";
        BelowSOAmt: Decimal;

    local procedure "---API1.00 BEGIN"()
    begin
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure checkLogin(loginName: Code[50]; pwd: Text[80]): Text
    var
        Employee: Record Employee;
        AttMissedDate: Date;
        counter: Integer;
        disableLogin: Boolean;
        disabelLogintext: Text;
        isAdmin: Text;
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", '' + loginName);
        Employee.SetRange(Status, Employee.Status::Active);
        if not Employee.FindFirst then
            Error(NoEmployeeMappingErr + SystemAdminTxt);

        isAdmin := 'False';
        if UserSetup.Get(UserId) then;
        if UserSetup."Is Admin" then
            isAdmin := 'True';
        if Employee."Disable Punch in" then
            disableLogin := true;
        //check for transfer
        /*TransferVar.RESET; //Min -- commented since it was manage through approved, ack action and job queue.
        TransferVar.SETRANGE("Employee No.",Employee."No.");
        TransferVar.SETFILTER(Type,'%1|%2',TransferVar.Type::"HR Transfer",TransferVar.Type::"Employee Transfer");
        TransferVar.SETRANGE("Approval Status",TransferVar."Approval Status"::Approved);
        TransferVar.SETFILTER("Transfer Effective Date",'<=%1',TODAY);
        IF TransferVar.FINDFIRST THEN
          disableLogin := TRUE;*/
        //for attendance count
        AttMissedDate := Today;
        counter := 0;
        if Employee."Attendance Missed On" <> 0D then begin
            AttendanceSetup.Get;
            AttMissedDate := Employee."Attendance Missed On";
            if not AttendanceSetup."Deactivate Punch in Count" then
                counter := Employee."Attendance Missed Count";
        end;
        if not AttendanceSetup."Deactivate Punch in Count" then
            if (counter > 5) then
                disableLogin := true;

        if disableLogin then
            disabelLogintext := 'True'
        else
            disabelLogintext := 'False';
        exit('{"empno" : "' + Employee."No." +
              '","attmisseddate" : "' + getDateinFormat(AttMissedDate) +
              '",' + '"count" : "' + Format(counter) + '"' +
              ',"disableLogin" : "' + disabelLogintext + '"' +
              ',"recommendercode": "' + Employee."KPI Deputation Value" +
              '","approverCode": "' + Employee."Approver Code" +
              '","isAdmin": "' + isAdmin +
              '","id" :"' + DelChr(Format(Employee."No."), '=', '{}') + '"}');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure sendLateAttendance(employeeNo: Code[20]; lateRemarks: Text): Integer
    var
        DocumentType: Option " ","Leave Request","Travel Request","Travel Claim","Late Attendance",Training;
        TypeOpt: Option " ",Open,Released,Rejected,"Pending Approval";
    begin
        HrMgt.SendMailFromTemplate(0, DocumentType::"Late Attendance", TypeOpt::Open, '<br>' + lateRemarks, employeeNo, '', 0);
        exit(200);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveLateAttendance(empNo: Code[20]; lateAttendanceDate: Date; isApproved: Boolean; remarks: Text): Text
    var
        AttendanceLog: Record "Attendance Log";
    begin
        AttendanceLog.Reset;
        AttendanceLog.SetRange("Employee ID", empNo);
        AttendanceLog.SetRange(Date, lateAttendanceDate);
        if AttendanceLog.FindFirst then begin
            Employee.Reset;
            Employee.SetRange("NAV Login ID", UserId);
            if Employee.FindFirst then
                if Employee."No." <> AttendanceLog."Approver Code" then
                    Error('You are not eligible to approve or reject this document');
            if isApproved then
                AttendanceLog.Validate(Status, AttendanceLog.Status::Approved)
            else
                AttendanceLog.Validate(Status, AttendanceLog.Status::Rejected);
            AttendanceLog.Validate("Approver Remarks", remarks);
            AttendanceLog.Modify;
            exit('Approved');
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveEmployeeActivity(empActNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text; employeeNo: Code[20])
    var
        EmpActivity: Record "Employee Activity";
    begin
        EmpActivity.Get(empActNo);
        if EmpActivity.Type = EmpActivity.Type::Resignation then begin
            if isApproved then begin
                EmpActivity.Validate(Remarks, rejectionRemarks);
                EmpActivity.Modify;
                HrMgt.ApproveRejectResignationAPI(isApproved, EmpActivity, employeeNo);
            end else begin
                EmpActivity.Validate("Rejection Remarks", rejectionRemarks);
                EmpActivity.Modify;
                HrMgt.ApproveRejectResignationAPI(isApproved, EmpActivity, employeeNo);
            end;
            exit;
        end;
        if not EmpActivity.Cancelled then begin
            if isApproved and (EmpActivity."Approval Status" = EmpActivity."Approval Status"::"Pending Approval") then
                HrMgt.RecommendEmployeeActivityAPI(empActNo, employeeNo)
            else begin
                if not isApproved then begin
                    EmpActivity.Validate("Rejection Remarks", rejectionRemarks);
                    EmpActivity.Modify;
                end;
                HrMgt.ApprovedRejectApprovalAPI(isApproved, empActNo, employeeNo);
            end;
        end else begin
            EmpActivity.Get(empActNo);
            EmpActivity.Validate("Rejection Remarks", rejectionRemarks);
            EmpActivity.Modify;
            HrMgt.ApproveRejectCancelAttendanceMissedAPI(EmpActivity, isApproved, employeeNo);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure employeeCheckoutTimeUpdate(empNo: Code[20]; checkoutDate: Date; checkoutTime: Time; puchoutRemarks: Text; punchoutReviewer: Code[20]; punchoutCheckReviewer: Code[20]; NightShiftCheckOutTime: Time): Text
    var
        Attendancelog: Record "Attendance Log";
    begin
        Attendancelog.Reset;
        Attendancelog.SetRange("Employee ID", empNo);
        Attendancelog.SetRange(Date, checkoutDate);
        if Attendancelog.FindFirst then begin
            Attendancelog."Check Out Time" := checkoutTime;
            Attendancelog."Punch out Remarks" := puchoutRemarks;
            Attendancelog."Punch Out Reviewer" := punchoutReviewer; //Min 8.18.2022
            Attendancelog."Punch Out Check Reviewer" := punchoutCheckReviewer;
            Attendancelog."Night Shift Check Out Time" := NightShiftCheckOutTime; //Min 11.27.2022
            Attendancelog.Modify;
            exit('Checkout Completed');
        end else
            Error('Record not found');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitLeaveRequest(employeeNo: Code[20]; leaveCode: Code[20]; startDate: Date; endDate: Date; remarks: Text; compensatoryDate: Date; recommenderCode: Code[20]; approverCode: Code[20]; childGender: Text; forDeathof: Text; contactNo: Text): Integer
    var
        //TempEmpAct: Record "Employee Activity" temporary;
        LeaveMgt: Codeunit "Leave Mgt.";
        tempLeave: Record Leave temporary;

    begin
        tempLeave.Reset;
        tempLeave.Init;
        tempLeave.Validate("Employee No.", employeeNo);
        tempLeave.Validate("Leave Code", leaveCode);
        tempLeave.Validate(Type, tempLeave.Type::"Leave Request");

        /*
        CASE leaveType OF
          FORMAT(TempEmpAct."Leave Type"::"Full Day"):
            TempEmpAct.VALIDATE("Leave Type",TempEmpAct."Leave Type"::"Full Day");
          FORMAT(TempEmpAct."Leave Type"::"First Half"):
            TempEmpAct.VALIDATE("Leave Type",TempEmpAct."Leave Type"::"First Half");
          FORMAT(TempEmpAct."Leave Type"::"Second Half"):
            TempEmpAct.VALIDATE("Leave Type",TempEmpAct."Leave Type"::"Second Half");
        END;*/
        tempLeave.Validate("Leave Type", tempLeave."Leave Type"::"Full Day");
        tempLeave.Validate("Start Date", startDate);
        tempLeave.Validate("End Date", endDate);
        tempLeave.Validate("Requested Date", Today);
        tempLeave.Validate(Remarks, remarks);
        //TempEmpAct.VALIDATE("Compensatory Date",compensatoryDate); //Min Commented --as per change req
        tempLeave.Validate("Recommender Code", recommenderCode);
        tempLeave.Validate("Approver Code", approverCode);
        case childGender of
            Format(tempLeave."Child's Gender"::Male):
                tempLeave.Validate("Child's Gender", tempLeave."Child's Gender"::Male);

            Format(tempLeave."Child's Gender"::Female):
                tempLeave.Validate("Child's Gender", tempLeave."Child's Gender"::Female);
        end;

        case forDeathof of
            Format(tempLeave."For Death Of"::Father):
                tempLeave.Validate("For Death Of", tempLeave."For Death Of"::Father);

            Format(tempLeave."For Death Of"::Mother):
                tempLeave.Validate("For Death Of", tempLeave."For Death Of"::Mother);

            Format(tempLeave."For Death Of"::"Father In Law"):
                tempLeave.Validate("For Death Of", tempLeave."For Death Of"::"Father In Law");

            Format(tempLeave."For Death Of"::"Mother In Law"):
                tempLeave.Validate("For Death Of", tempLeave."For Death Of"::"Mother In Law");

            Format(tempLeave."For Death Of"::Spouse):
                tempLeave.Validate("For Death Of", tempLeave."For Death Of"::Spouse);

            Format(tempLeave."For Death Of"::Son): //Min 12.23.2022
                tempLeave.Validate("For Death Of", tempLeave."For Death Of"::Son);

            Format(tempLeave."For Death Of"::Daughter):
                tempLeave.Validate("For Death Of", tempLeave."For Death Of"::Daughter);
        end;
        tempLeave.Validate("Contact No.", contactNo);
        tempLeave.Insert;
        if LeaveMgt.ApplyForLeave(tempLeave) then
            exit(200);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure exitEstimationCosts(empNo: Code[20]; withEmpNo: Code[20]; travelCountry: Text): Text
    var
        EmpVar: Record Employee;
        WithEmpVar: Record Employee;
        SalLevel: Record "Salary Level";
        WithSalLevel: Record "Salary Level";
        EstLodgCost: Decimal;
        EstFoodCost: Decimal;
        EmpAct: Record "Employee Activity";
        approverCode: Code[10];
    begin
        EmpVar.Get(empNo);
        SalLevel.Get(EmpVar."Salary Level");
        if WithEmpVar.Get(withEmpNo) then;
        if not SalLevel."Travel With Not Eligible" then
            if WithSalLevel.Get(WithEmpVar."Salary Level") then;
        Clear(EstFoodCost);
        Clear(EstLodgCost);
        if travelCountry = Format(EmpAct."Travel Countries"::Nepal) then begin
            if not ((SalLevel."Nepal Fooding Allowance" > WithSalLevel."Nepal Fooding Allowance")
              and (SalLevel."Nepal Lodging Allowance" > WithSalLevel."Nepal Lodging Allowance")) then begin
                EstFoodCost := WithSalLevel."Nepal Fooding Allowance";
                EstLodgCost := WithSalLevel."Nepal Lodging Allowance";
            end else begin
                EstFoodCost := SalLevel."Nepal Fooding Allowance";
                EstLodgCost := SalLevel."Nepal Lodging Allowance";
            end;
        end
        else if travelCountry = Format(EmpAct."Travel Countries"::India) then begin
            if not ((SalLevel."India Fooding Allowance" > WithSalLevel."India Fooding Allowance")
              and (SalLevel."India Lodging Allowance" > WithSalLevel."India Lodging Allowance")) then begin
                EstFoodCost := WithSalLevel."India Fooding Allowance";
                EstLodgCost := WithSalLevel."India Lodging Allowance";
            end else begin
                EstFoodCost := SalLevel."India Fooding Allowance";
                EstLodgCost := SalLevel."India Lodging Allowance";
            end;
        end;
        if SalLevel.Rank < WithSalLevel.Rank then begin
            Employee.Reset;
            Employee.SetRange("Salary Level", 'DCEO');
            if Employee.FindFirst then
                approverCode := Employee."No.";
        end;
        exit(StrSubstNo('{"EstFoodCost" : "%1","EstLodgCost" : "%2","appoverCode" : "%3"}', EstFoodCost, EstLodgCost, approverCode));
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveCancelAndAttendanceEmployeeActivity(empActNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text; employeeNo: Code[20])
    var
        EmpActivity: Record "Employee Activity";
    begin
        EmpActivity.Get(empActNo);
        EmpActivity.Validate("Rejection Remarks", rejectionRemarks);
        EmpActivity.Modify;
        HrMgt.ApproveRejectCancelAttendanceMissedAPI(EmpActivity, isApproved, employeeNo);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveTravelActivity(empActNo: Code[20]; startDate: Date; endDate: Date; advanceCash: Decimal; empNo: Code[20]): Text
    var
        EmpActivity: Record "Employee Activity";
    begin
        EmpActivity.Get(empActNo);
        EmpActivity.Validate("Start Date", startDate);
        EmpActivity.Validate("End Date", endDate);
        if EmpActivity."Advance Cash Required" then
            EmpActivity.Validate("Advance Cash", advanceCash);
        EmpActivity.Modify;
        if (EmpActivity."Approval Status" = EmpActivity."Approval Status"::"Pending Approval") then
            HrMgt.RecommendEmployeeActivityAPI(empActNo, empNo)
        else begin
            HrMgt.ApprovedRejectApprovalAPI(true, empActNo, empNo);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure getOutofPocket(empNo: Code[20]; depatureTime: Time; arrivalTime: Time; startDate: Date; endDate: Date; empActNo: Code[20]): Text
    var
        allType: Option " ",Fooding,Lodging,OutofExpense;
    begin
        Employee.Get(empNo);
        SalaryLevel.Get(Employee."Salary Level");
        EmpActivity.Get(empActNo);
        exit('{' +
        '"totalFooding" : "' + DelChr(Format(GetAllowanceFoodingLoding(EmpActivity, allType::Fooding, endDate - startDate + 1)), '=', ',') + '",' +
          '"totalLodging" :"' + DelChr(Format(GetAllowanceFoodingLoding(EmpActivity, allType::Lodging, endDate - startDate + 1)), '=', ',') + '",' +
          '"foodingLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpActivity, allType::Fooding, false, endDate - startDate + 1)), '=', ',') + '",' +
          '"lodgingLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpActivity, allType::Lodging, false, endDate - startDate + 1)), '=', ',') + '",' +
          '"outOfPocket": "' + DelChr(Format(SalaryLevel."Out of Pocket Expense" *
                                TravelMgt.GetOutofExpneseDuration(depatureTime, arrivalTime, startDate, endDate)), '=', ',') + '"' +
          '}');
        //EXIT( SalaryLevel."Out of Pocket Expense" * HrMgt.GetOutofExpneseDuration(depatureTime,arrivalTime,startDate,endDate));
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure exitForTravelClaims(empAcitivityNo: Code[20]): Text
    var
        EmpActivity: Record "Employee Activity";
        allType: Option " ",Fooding,Lodging,OutofExpense;
    begin
        EmpActivity.Get(empAcitivityNo);

        exit(
        '{' +
          '"totalNoOfDays" : "' + DelChr(Format(TravelMgt.CalculateTotalNoDays(empAcitivityNo)), '=', ',') + '",' +
          '"totalEstimatedConv" : "' + DelChr(Format(TravelMgt.CalculateTotalEstimatedConv(empAcitivityNo)), '=', ',') + '",' +
          '"totalFooding" : "' + DelChr(Format(GetAllowanceFoodingLoding(EmpActivity, allType::Fooding, EmpActivity."Total No. of Days")), '=', ',') + '",' +
          '"totalLodging" :"' + DelChr(Format(GetAllowanceFoodingLoding(EmpActivity, allType::Lodging, EmpActivity."Total No. of Days")), '=', ',') + '",' +
          '"totalAdvance" : "' + DelChr(Format(TravelMgt.CalculateTotalAdvance(empAcitivityNo)), '=', ',') + '",' +
          '"totalTransport" : "' + DelChr(Format(TravelMgt.CalculateTotalTransport(empAcitivityNo)), '=', ',') + '",' +
          '"totalEstmiatedCost" : "' + DelChr(Format(TravelMgt.CalculateTotalEstimatedCost(empAcitivityNo)), '=', ',') + '",' +
          '"travelStartDate": "' + getDateinFormat(TravelMgt.GetTravelStartDate(empAcitivityNo)) + '",' +
          '"travelEndDate": "' + getDateinFormat(TravelMgt.GetTravelEndDate(empAcitivityNo)) + '",' +
          '"foodingPerDayLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpActivity, allType::Fooding, true, 1)), '=', ',') + '",' +
          '"foodingLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpActivity, allType::Fooding, false, EmpActivity."Total No. of Days")), '=', ',') + '",' +
          '"lodgingPerDayLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpActivity, allType::Lodging, true, 1)), '=', ',') + '",' +
          '"lodgingLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpActivity, allType::Lodging, false, EmpActivity."Total No. of Days")), '=', ',') + '",' +
          '"depatureTime": "' + getTimeinFormat(TravelMgt.GetDepatureTime(empAcitivityNo)) + '",' +
          '"arrivalTime" : "' + getTimeinFormat(TravelMgt.GetArrivalTime(empAcitivityNo)) + '"' +
        '}'
        )
    end;

    local procedure GetAllowanceFoodingLoding(EmpActivity: Record "Employee Activity"; allType: Option " ",Fooding,Lodging,OutofExpense; NoofDays: Decimal): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        EmpVar: Record Employee;
    begin
        EmpVar.Get(EmpActivity."Employee No.");
        SalaryLevel.Get(EmpVar."Salary Level");
        if EmpActivity."Travel With" <> '' then begin//AT
            if Employee.Get(EmpActivity."Travel With") then;
            if not SalaryLevel."Travel With Not Eligible" then
                if SalaryLevel1.Get(Employee."Salary Level") then;
        end;

        case EmpActivity."Travel Countries" of
            EmpActivity."Travel Countries"::Nepal:
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then//AT
                            exit(SalaryLevel1."Nepal Fooding Allowance" * NoofDays)
                        else
                            exit(SalaryLevel."Nepal Fooding Allowance" * NoofDays);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then//AT
                            exit(SalaryLevel1."Nepal Lodging Allowance" * (NoofDays - 1))
                        else
                            exit(SalaryLevel."Nepal Lodging Allowance" * (NoofDays - 1));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense" * EmpActivity."Total No. of Days");
                end;

            EmpActivity."Travel Countries"::India:
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then//AT
                            exit(SalaryLevel1."India Fooding Allowance" * NoofDays)
                        else
                            exit(SalaryLevel."India Fooding Allowance" * NoofDays);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then//AT
                            exit(SalaryLevel1."India Lodging Allowance" * (NoofDays - 1))
                        else
                            exit(SalaryLevel."India Lodging Allowance" * (NoofDays - 1));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense" * EmpActivity."Total No. of Days");
                end;

            EmpActivity."Travel Countries"::"Other Countries":
                begin
                    if allType = allType::OutofExpense then
                        exit(SalaryLevel."Out of Pocket Expense" * EmpActivity."Total No. of Days");
                end;
        end;
    end;

    local procedure GetAllowanceFoodingLodingLimit(EmpActivity: Record "Employee Activity"; allType: Option " ",Fooding,Lodging,OutofExpense; perDay: Boolean; NoOfDays: Decimal): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        EmpVar: Record Employee;
        Days: Integer;
    begin
        EmpVar.Get(EmpActivity."Employee No.");
        SalaryLevel.Get(EmpVar."Salary Level");
        if EmpActivity."Travel With" <> '' then begin//AT
            if Employee.Get(EmpActivity."Travel With") then;
            if not SalaryLevel."Travel With Not Eligible" then
                if SalaryLevel1.Get(Employee."Salary Level") then;
        end;

        if perDay then
            Days := 1
        else begin
            if allType = allType::Fooding then
                // Days := EmpActivity."Total No. of Days"
                Days := NoOfDays
            else if allType = allType::Lodging then
                //Days := EmpActivity."Total No. of Days" -1;
                Days := NoOfDays - 1;
        end;
        case EmpActivity."Travel Countries" of
            EmpActivity."Travel Countries"::Nepal:
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then//AT
                            exit(SalaryLevel1."Nepal Fooding Allowance" * Days)
                        else
                            exit(SalaryLevel."Nepal Fooding Allowance" * Days);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then//AT
                            exit(SalaryLevel1."Nepal Lodging Allowance" * (Days))
                        else
                            exit(SalaryLevel."Nepal Lodging Allowance" * (Days));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense" * Days);
                end;

            EmpActivity."Travel Countries"::India:
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then//AT
                            exit(SalaryLevel1."India Fooding Allowance" * Days)
                        else
                            exit(SalaryLevel."India Fooding Allowance" * Days);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then//AT
                            exit(SalaryLevel1."India Lodging Allowance" * (Days))
                        else
                            exit(SalaryLevel."India Lodging Allowance" * (Days));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense" * Days);
                end;

            EmpActivity."Travel Countries"::"Other Countries":
                begin
                    if allType = allType::OutofExpense then
                        exit(SalaryLevel."Out of Pocket Expense" * Days);
                end;
        end;
    end;

    local procedure getDateinFormat(DateVar: Date): Text
    var
        Day: Text;
        Month: Text;
        Year: Text;
    begin
        //day
        if Date2DMY(DateVar, 1) < 10 then
            Day := '0' + Format(Date2DMY(DateVar, 1))
        else
            Day := Format(Date2DMY(DateVar, 1));

        //month
        if Date2DMY(DateVar, 2) < 10 then
            Month := '0' + Format(Date2DMY(DateVar, 2))
        else
            Month := Format(Date2DMY(DateVar, 2));
        //year
        Year := Format(Date2DMY(DateVar, 3));

        exit(Year + '-' + Month + '-' + Day);
    end;

    local procedure getTimeinFormat(varTime: Time): Text
    var
        Milliseconds: Integer;
        Hours: Integer;
        Minutes: Integer;
        Seconds: Integer;
        HoursText: Text;
        MinutesText: Text;
        SecondsText: Text;
    begin
        Milliseconds := varTime - 000000T;

        Hours := Round(Milliseconds div 1000 div 60 div 60, 1, '=');
        if Hours < 10 then
            HoursText := '0' + Format(Hours)
        else
            HoursText := Format(Hours);
        Milliseconds -= Hours * 1000 * 60 * 60;

        Minutes := Round(Milliseconds div 1000 div 60, 1, '=');
        if Minutes < 10 then
            MinutesText := '0' + Format(Minutes)
        else
            MinutesText := Format(Minutes);
        Milliseconds -= Minutes * 1000 * 60;

        Seconds := Round(Milliseconds div 1000, 1, '=');
        if Seconds < 10 then
            SecondsText := '0' + Format(Seconds)
        else
            SecondsText := Format(Seconds);
        Milliseconds -= Seconds * 1000;

        exit(HoursText + ':' + MinutesText + ':' + SecondsText);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnMarks(answer: Text): Integer
    var
        EmpFeedback: Record "Employee Feedback";
    begin
        case answer of
            Format(EmpFeedback.Answer::"Strongly Agree"):
                exit(5);

            Format(EmpFeedback.Answer::Agree):
                exit(4);

            Format(EmpFeedback.Answer::Netural):
                exit(3);

            Format(EmpFeedback.Answer::Disagree):
                exit(2);

            Format(EmpFeedback.Answer::"Strongly Disagree"):
                exit(1);

            else
                exit(0);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnDBRRatio(empNo: Code[20]; loanType: Text; paybackMonth: Integer; appliedAdvance: Decimal): Text
    var
        DbrRatio: Decimal;
        Frequency: Integer;
        EMIVar: Decimal;
        GrossSalary: Decimal;
    begin
        Clear(Frequency);
        Clear(EMIVar);
        Clear(GrossSalary);
        Clear(DbrRatio);
        HRSetup.Get;

        //frequency
        Frequency := CalculateFrequency(empNo, loanType) + 1;

        //EMI
        EMIVar := CalculateEMI(empNo);

        //grosssalary
        GrossSalary := CalculateGrossSalary(empNo);
        if GrossSalary = 0 then
            Error('Gross salary cannot be 0. Please check.');

        //dbr
        DbrRatio := EMIVar / GrossSalary * 100;
        CheckDBRRatio(DbrRatio);

        exit(
          '{' +
            '"dbrRatio" : "' + DelChr(Format(Round(DbrRatio, 0.000001, '=')), '=', ',') + '",' +
            '"frequency" : "' + DelChr(Format(Frequency), '=', ',') + '",' +
            '"gorssSalary" :"' + DelChr(Format(GrossSalary), '=', ',') + '",' +
            '"eligibleAdvance" : "' + DelChr(Format(GrossSalary * 2), '=', ',') + '"' +
          '}'
          );
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnLoanCalculation(empNo: Code[20]; loanType: Text; repaymentMode: Text; insuranceTieup: Text; age: Decimal; repaymentPeriod: Decimal; appliedLoan: Decimal; propertyValue: Decimal; estimatedConstValue: Decimal; purposeofHousingLoan: Text): Text
    var
        DbrRatio: Decimal;
        Frequency: Integer;
        EMIVar: Decimal;
        EmpLoan: Record "Employee Loan/Advance";
        InterestRate: Decimal;
        loanOpt: Option;
        InsurancePolicy: Record "Insurance Premium Setup";
        EMIVar2: Decimal;
        GrossSalary: Decimal;
        PrevLoanAmt: Decimal;
        frequencyText: Text;
        totalLoanAmt: Decimal;
        AMSalaryLevel: Record "Salary Level";
        eligibleMonth: Decimal;
    begin
        Clear(Frequency);
        Clear(EMIVar);
        Clear(GrossSalary);
        Clear(EMIVar2);
        Clear(DbrRatio);
        Clear(EligibleLoan);
        HRSetup.Get;
        if insuranceTieup = ' ' then
            insuranceTieup := '';
        //grosssalary
        GrossSalary := CalculateGrossSalary(empNo);
        if GrossSalary = 0 then
            Error('Gross salary cannot be 0. Please check.');

        //Eligible loan
        case loanType of
            Format(EmpLoan."Loan Type"::"Home Loan"):
                begin
                    loanOpt := EmpLoan."Loan Type"::"Home Loan";
                    PrevLoanAmt := GetExistingLoanAmount(empNo, loanOpt);
                    totalLoanAmt := PrevLoanAmt + appliedLoan;
                    CheckSalaryLevel.Reset;
                    CheckSalaryLevel.SetRange("Senior Officer Level", true);
                    if CheckSalaryLevel.FindFirst then;
                    if (SalaryLevel.Rank <= CheckSalaryLevel.Rank) then
                        eligibleMonth := HRSetup."Loan Eligible Month Below SO"
                    else
                        eligibleMonth := HRSetup."Home Loan Eligible Month";
                    if SalaryLevel."Housing Loan Limit" <> 0 then begin
                        if (eligibleMonth * GrossSalary) > (SalaryLevel."Housing Loan Limit") then
                            EligibleLoan := (SalaryLevel."Housing Loan Limit" - PrevLoanAmt)
                        else
                            EligibleLoan := (eligibleMonth * GrossSalary) - PrevLoanAmt;
                    end else
                        EligibleLoan := (eligibleMonth * GrossSalary) - PrevLoanAmt;

                    if purposeofHousingLoan = Format(EmpLoan."Purpose of Housing Loan"::"Renovate/Extend/Repair") then begin
                        if EligibleLoan > (95 / 100 * (propertyValue + estimatedConstValue)) then
                            EligibleLoan := (95 / 100 * (propertyValue + estimatedConstValue));
                    end else if EligibleLoan > (90 / 100 * (propertyValue + estimatedConstValue)) then
                            EligibleLoan := (90 / 100 * (propertyValue + estimatedConstValue));
                end;

            Format(EmpLoan."Loan Type"::"Personal Loan"):
                begin
                    loanOpt := EmpLoan."Loan Type"::"Personal Loan";
                    PrevLoanAmt := GetExistingLoanAmount(empNo, loanOpt);
                    totalLoanAmt := PrevLoanAmt + appliedLoan;
                    if TotalServicePeriod >= 2 then
                        EligibleLoan := GrossSalary * 10 - PrevLoanAmt
                    else if TotalServicePeriod >= 1 then
                        EligibleLoan := GrossSalary * 4 - PrevLoanAmt;
                    CheckSalaryLevel.Reset;
                    CheckSalaryLevel.SetRange("Senior Officer Level", true);
                    if CheckSalaryLevel.FindFirst then begin
                        if (SalaryLevel.Rank <= CheckSalaryLevel.Rank) then begin
                            if TotalServicePeriod > 5 then
                                EligibleLoan := GrossSalary * 15 - PrevLoanAmt
                            else if TotalServicePeriod > 3 then
                                EligibleLoan := GrossSalary * 12 - PrevLoanAmt;
                        end;
                    end;
                end;

            Format(EmpLoan."Loan Type"::"Vehicle Loan"):
                begin
                    if repaymentPeriod > HRSetup."Max. Veh. Loan Repay Period" then
                        Error('Repayment period cannot be greater than %1 years for Vehicle Loan.', HRSetup."Max. Veh. Loan Repay Period");
                    loanOpt := EmpLoan."Loan Type"::"Vehicle Loan";
                    PrevLoanAmt := GetExistingLoanAmount(empNo, loanOpt);
                    totalLoanAmt := PrevLoanAmt + appliedLoan;
                    EligibleLoan := 90 / 100 * propertyValue;
                    AMSalaryLevel.Reset;
                    AMSalaryLevel.SetRange("Is AM", true);
                    if AMSalaryLevel.FindFirst then;
                    if SalaryLevel."Vehicle Loan Limit" <> 0 then begin
                        if AMSalaryLevel.Rank <= SalaryLevel.Rank then
                            EligibleLoan := propertyValue;
                        if SalaryLevel."Vehicle Loan Limit" < EligibleLoan then
                            EligibleLoan := SalaryLevel."Vehicle Loan Limit";
                    end;
                    if EligibleLoan > HRSetup."Vehicle Loan Eligible Month" * GrossSalary then
                        EligibleLoan := HRSetup."Vehicle Loan Eligible Month" * GrossSalary;
                end;

            Format(EmpLoan."Loan Type"::"Salary Advance"):
                begin
                    loanOpt := EmpLoan."Loan Type"::"Salary Advance";
                    EligibleLoan := 2 * GrossSalary;
                end;
            else
                loanOpt := EmpLoan."Loan Type"::" ";
        end;

        if (Format(EmpLoan."Repayment Mode"::"Insurance Tieup") = repaymentMode) and
            (loanType = Format(EmpLoan."Loan Type"::"Home Loan")) then begin
            InterestRate := 0;
            if (insuranceTieup <> '') and (age <> 0) and (repaymentPeriod <> 0) then begin
                InsurancePolicy.Reset;
                InsurancePolicy.SetFilter(
                "Insurance Company", insuranceTieup);
                InsurancePolicy.SetRange(Age, age);
                InsurancePolicy.SetRange(Period, repaymentPeriod);
                if InsurancePolicy.FindFirst then
                    InterestRate := InsurancePolicy.Value
                else
                    Error('Premium Setup is not available for this insurance company. Please contact HR department.');
            end;
        end else

            //frequency
            Frequency := CalculateFrequency(empNo, loanType);
        if loanType = Format(EmpLoan."Loan Type"::"Salary Advance") then
            frequencyText := '"frequency" : "' + DelChr(Format(Frequency), '=', ',') + '",'
        else begin
            frequencyText := '';
            if not (Format(EmpLoan."Repayment Mode"::"Insurance Tieup") = repaymentMode) then
                InterestRate := LoanMgt.GetInterestRate(Today, loanOpt);
        end;
        Employee.Get(empNo);
        SalaryLevel.Get(Employee."Salary Level");
        //EMI

        //changes for salary level greater than AM
        if loanType = Format(EmpLoan."Loan Type"::"Vehicle Loan") then
            if (SalaryLevel."Vehicle Loan Limit" <> 0) then
                InterestRate := 0;
        EMIVar := CalculateLoanEMI(InterestRate, appliedLoan, repaymentPeriod, loanType, repaymentMode);
        if loanType = Format(EmpLoan."Loan Type"::"Vehicle Loan") then begin
            if SalaryLevel."Vehicle Loan Limit" <> 0 then
                EMIVar2 := CalculateEMI(empNo)
            else
                EMIVar2 := CalculateEMI(empNo) + EMIVar;
        end else
            EMIVar2 := CalculateEMI(empNo) + EMIVar;

        //dbr
        DbrRatio := EMIVar2 / GrossSalary * 100;
        CheckSalaryLevel.Reset;
        CheckSalaryLevel.SetRange("Senior Officer Level", true);
        CheckSalaryLevel.FindFirst;
        if CheckSalaryLevel.Rank >= SalaryLevel.Rank then begin
            BelowSOAmt := LoanMgt.GetLFAAndDashainAllowance(SalaryLevel, SalaryGrade);
            DbrRatio := EMIVar2 / (GrossSalary + BelowSOAmt) * 100
        end;
        CheckDBRRatio(DbrRatio);

        if (Format(EmpLoan."Repayment Mode"::"Insurance Tieup") = repaymentMode) then
            InterestRate := 0;
        exit(
          '{' +
            '"interestRate" : ' + DelChr(Format(InterestRate), '=', ',') + ',' +
            '"emi" : ' + DelChr(Format(Round(EMIVar, 0.000001, '=')), '=', ',') + ',' +
            '"dbrRatio" : "' + DelChr(Format(Round(DbrRatio, 0.000001, '=')), '=', ',') + '",' +
            '"gorssSalary" :"' + DelChr(Format(GrossSalary), '=', ',') + '",' +
            '"prevLoanAmt" :"' + DelChr(Format(PrevLoanAmt), '=', ',') + '",' +
            '"totalLoanAmt" :"' + DelChr(Format(totalLoanAmt), '=', ',') + '",' +
            frequencyText +
            '"eligibleLoan" : "' + DelChr(Format(EligibleLoan), '=', ',') + '"' +

          '}'
          );
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure sendEmploanSalAdvForApproval(empLoanNo: Code[20]; isApproved: Boolean)
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
    begin
        EmpSalaryAdv.Get(empLoanNo);
        LoanMgt.SendApprovaLoan(EmpSalaryAdv, isApproved);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveEmpLoanSalAdv(empLoanNo: Code[20]; isApproved: Boolean; remark: Text; EmpNo: Code[20])
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
    begin
        EmpSalaryAdv.Get(empLoanNo);
        if isApproved then begin
            if EmpSalaryAdv."Approval Status" = EmpSalaryAdv."Approval Status"::"Pending Approval" then
                EmpSalaryAdv.Validate("Recommendation Remarks", remark);
        end else
            EmpSalaryAdv.Validate("Rejection Remark", remark);
        EmpSalaryAdv.Modify;
        LoanMgt.ApproveRejectLoan(EmpSalaryAdv, isApproved);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure retrunAttachmentBase64(docNo: Code[20]; entryNo: Integer): Text
    var
        //IncomingDoc: Record "Incoming Document";
        //TempBlob: Codeunit "Temp Blob";
        //FileName: Text;
        // ext: Text;
        Base64: Codeunit "Base64 Convert";
        IncomingDocAttachment: Record "Incoming Document Attachment";
        instr: InStream;
        Extension: text;
        LargeText: text;
    begin
        // IncomingDoc.Reset;
        // if docNo <> '' then
        //     IncomingDoc.SetRange("No.", docNo);
        // IncomingDoc.SetRange("Entry No.", entryNo);
        // if IncomingDoc.FindFirst then begin
        IncomingDocAttachment.Reset();
        IncomingDocAttachment.SetRange("Incoming Document Entry No.", entryNo);
        if IncomingDocAttachment.FindFirst() then begin
            Extension := IncomingDocAttachment."File Extension";
            IncomingDocAttachment.CalcFields(Content);
            IncomingDocAttachment.Content.CreateInStream(instr, TextEncoding::UTF8);
            LargeText := Base64.ToBase64(instr, false);
            // FileName := IncomingDoc."File Name";
            // FileManagement.BLOBImport(TempBlob, FileName);
            // ext := CopyStr(FileName, StrPos(FileName, '.') + 1, StrLen(FileName));
            exit('{' + '"extension": "' + Extension + '",' + '"attachBase64":"' + LargeText + '"}');
            // exit(
            // '{' +
            // '"extension" : "' + ext + '",' +
            // '"attachBase64" : "' + Base64.ToBase64(TempBlob.CreateInStream()) + '"}');
        end else
            exit('not found');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure insertAttachmentforPurposeofHousing(empLoanNo: Code[20]; purposeofHousing: Text): Text
    var
        IncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        EmpLoan: Record "Employee Loan/Advance";
        PurposeHousing: Option " ","Purchase of Land","Construction of House","Purchase of ready built house","Renovate/Extend/Repair";
    begin
        EmpLoan.Get(empLoanNo);
        case purposeofHousing of
            Format(PurposeHousing::"Construction of House"):
                PurposeHousing := PurposeHousing::"Construction of House";
            Format(PurposeHousing::"Purchase of Land"):
                PurposeHousing := PurposeHousing::"Purchase of Land";
            Format(PurposeHousing::"Purchase of ready built house"):
                PurposeHousing := PurposeHousing::"Purchase of ready built house";
            Format(PurposeHousing::"Renovate/Extend/Repair"):
                PurposeHousing := PurposeHousing::"Renovate/Extend/Repair";
        end;

        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Home Loan");
        AttachmentSetup.SetFilter("Purpose of Housing Loan", '<>%1&<>%2', PurposeHousing, EmpLoan."Purpose of Housing Loan"::" ");
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Reset;
                IncomingDoc.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDoc.SetRange("No.", EmpLoan."No.");
                if IncomingDoc.FindFirst then
                    IncomingDoc.Delete;
            until AttachmentSetup.Next = 0;
        if purposeofHousing = '' then
            exit('');
        Clear(AttachmentSetup);

        if IncomingDoc.FindLast then
            AttachmentSetup.Reset;
        AttachmentSetup.SetFilter("Purpose of Housing Loan", purposeofHousing);
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Reset;
                IncomingDoc.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDoc.SetRange("No.", empLoanNo);
                if IncomingDoc.FindFirst then
                    break
                else begin
                    IncomingDoc.Init;
                    IncomingDoc."Entry No." := IncomingDoc.GetEntryNo();
                    IncomingDoc.Description := EmpLoan.TableName;
                    IncomingDoc."Attachment Code" := AttachmentSetup."Attachment Code";
                    IncomingDoc."No." := empLoanNo;
                    IncomingDoc."Employee Code" := EmpLoan."Employee Code";
                    IncomingDoc."Table ID" := Database::"Employee Loan/Advance";
                    IncomingDoc.Insert(true);
                end;
            until AttachmentSetup.Next = 0;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure uploadAttachment(docNo: Code[20]; entryNo: Integer; fname: Text; ext: Text): Text
    var
        IncomingDoc: Record "Incoming Document";
        IncomingDocAttach: Record "Incoming Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        DirectoryName: Text;
        DocFoundEmpActivity: Boolean;
        DocFoundEmpLoan: Boolean;
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        EmployeeActivity: Record "Employee Activity";
        LoanType: Option " ","Salary Advance","Personal Loan","Home Loan","Vehicle Loan";
        ActivityType: Option " ","Leave Request","Travel Request","Travel Claim",Transfer,Overtime,"Out of Office","Bulk Cash",Resignation,"Medical Insurance Claim",Promotion,"Attendance Missed","Access Control","Changes in employee";
        DocFoundInsurance: Boolean;
        EmpInsurance: Record "Employee Insurance Information";
        AppraisalDocFound: Boolean;
        AppraisalEmp: Record Appraisal;
        base64: Codeunit "Base64 Convert";
        Outstream: OutStream;
    begin
        IncomingDoc.Get(entryNo);

        HRSetup.Get;
        DocFoundEmpActivity := false;
        DocFoundEmpLoan := false;
        AppraisalDocFound := false; //Min
        if EmployeeLoanAdvance.Get(IncomingDoc."No.") then begin
            DocFoundEmpLoan := true;
            LoanType := EmployeeLoanAdvance."Loan Type";
            if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Screened, EmployeeLoanAdvance."Approval Status"::Approved])
               and (IncomingDoc."File Name" <> '') then
                Error('Attachment already exist.');
        end;

        if not DocFoundEmpLoan then begin
            if EmployeeActivity.Get(IncomingDoc."No.") then begin
                DocFoundEmpActivity := true;
                ActivityType := EmployeeActivity.Type;
                if (EmployeeActivity."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Screened, EmployeeActivity."Approval Status"::Approved])
                 and (IncomingDoc."File Name" <> '') then
                    Error('Attachment already exist.');
            end;
        end;
        if not (DocFoundEmpActivity or DocFoundEmpLoan) then begin
            if EmpInsurance.Get(IncomingDoc."No.") then begin
                DocFoundInsurance := true;
                if EmpInsurance.Status = EmpInsurance.Status::Screened then
                    Error('Cannot upload in screened insurance.');
                if IncomingDoc."File Name" <> '' then
                    Error('Attachment already exist.');
            end;
        end;

        if not AppraisalDocFound then begin //Min
            if AppraisalEmp.Get(IncomingDoc."No.") then begin
                AppraisalDocFound := true;
                if (AppraisalEmp.Status = AppraisalEmp.Status::"Check Reviewed")
                 and (IncomingDoc."File Name" <> '') then
                    Error('Attachment already exist.');
            end;
        end;

        if IncomingDoc."File Name" <> '' then
            Error('File already exist. Please remove the file first.');

        CreateNewDir(HRSetup."Attachment Storage Location", IncomingDoc."Employee Code", DirectoryName);
        DirectoryName += '\';
        if DocFoundEmpLoan then
            CreateNewDir(DirectoryName, Format(LoanType), DirectoryName)
        else if DocFoundEmpActivity then
            CreateNewDir(DirectoryName, Format(ActivityType), DirectoryName)
        else if DocFoundInsurance then
            CreateNewDir(DirectoryName, 'Insurance', DirectoryName)
        else if AppraisalDocFound then //Min
            CreateNewDir(DirectoryName, 'Appraisal', DirectoryName);

        DirectoryName += '\';
        // TempBlob.Reset;
        FileName := FileManagement.GetDirectoryName(DirectoryName) + '\' + Format(IncomingDoc."Entry No.") + '_' + IncomingDoc."No." + '.' + ext;
        IncomingDoc."File Name" := FileName;

        IncomingDocAttach.Reset();
        IncomingDocAttach.Init();
        IncomingDocAttach."Incoming Document Entry No." := entryNo;
        IncomingDocAttach."Line No." := 10000;
        tempblob.CreateOutStream(outStream);
        IncomingDocAttach.Content.CreateOutStream(outStream, TextEncoding::UTF8);
        base64.FromBase64(fname, Outstream);
        IncomingDocAttach."File Extension" := ext;
        IncomingDocAttach."Document No." := docNo;

        IncomingDocAttach.Insert();

        //base64.FromBase64(fname);
        // instream.Read(base64);//santosh
        //FileManagement.BLOBExport(TempBlob, FileName, false);
        // IncomingDoc."File Name" := FileName; santosh
        IncomingDoc.Modify;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure removeAttachment(docNo: Code[20]; entryNo: Integer)
    var
        IncomingDocument: Record "Incoming Document";
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        EmployeeActivity: Record "Employee Activity";
        DocFoundEmpLoan: Boolean;
        DocFoundEmpActivity: Boolean;
        EmpInsurance: Record "Employee Insurance Information";
    begin
        IncomingDocument.Get(entryNo);
        if EmployeeLoanAdvance.Get(IncomingDocument."No.") then begin
            DocFoundEmpLoan := true;
            if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Screened, EmployeeLoanAdvance."Approval Status"::Approved])
               and (IncomingDocument."File Name" <> '') then
                Error('Attachment already exist.');
        end;

        if not DocFoundEmpLoan then begin
            if EmployeeActivity.Get(IncomingDocument."No.") then begin
                DocFoundEmpActivity := true;
                if EmployeeActivity.Type in [EmployeeActivity.Type::"Employee Transfer", EmployeeActivity.Type::"HR Transfer"] then begin
                    if EmployeeActivity."Approval Status" = EmployeeActivity."Approval Status"::Acknowledged then
                        Error('Acknowledge transfer attachment cannot be deleted.');
                end else if EmployeeActivity."Approval Status" in [EmployeeActivity."Approval Status"::Approved, EmployeeActivity."Approval Status"::Screened] then
                        Error('Cannot delete attachment of approved doucment.');
                /*IF (EmployeeActivity."Approval Status" IN [EmployeeLoanAdvance."Approval Status"::Screened,EmployeeActivity."Approval Status"::Approved])
                 AND (IncomingDocument."File Name" <> '') THEN
                  ERROR('Attachment already exist.');
                  */
            end;
        end;
        if not (DocFoundEmpActivity or DocFoundEmpLoan) then begin
            if EmpInsurance.Get(IncomingDocument."No.") then begin
                if EmpInsurance.Status = EmpInsurance.Status::Screened then
                    Error('Cannot delete screened document.');
            end;
        end;

        LoanMgt.DeleteAttachment(IncomingDocument);
        IncomingDocument."File Name" := '';
        IncomingDocument.Modify;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure substituteAllowanceAssignment(entryNo: Integer; lineNo: Integer; fromDate: Date; toDate: Date; empCode: Code[20]): Text
    var
        AllowanceLine: Record "Allowance Assignment Line";
        TempAllowanceLine: Record "Allowance Assignment Line";
    begin
        AllowanceLine.Get(entryNo, lineNo);
        TempAllowanceLine.Copy(AllowanceLine);
        TempAllowanceLine.Validate("From Date", fromDate);
        TempAllowanceLine.Validate("To Date", toDate);
        TempAllowanceLine.Validate("Employee Code", empCode);
        TempAllowanceLine."Line No." := 0;
        TempAllowanceLine."Substitue of Line No." := AllowanceLine."Line No.";
        TempAllowanceLine."Is Substitute" := true;
        TempAllowanceLine.TestField("From Date");
        TempAllowanceLine.TestField("To Date");
        TempAllowanceLine.TestField("Employee Code");
        TempAllowanceLine."Approval Status" := TempAllowanceLine."Approval Status"::Screened;
        TempAllowanceLine.Insert(true);
        TempAllowanceLine.UpdateSubstitue;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure sendAllowanceForApproval(entryNo: Integer; isApproved: Boolean): Text
    var
        AllowanceLine: Record "Allowance Assignment Line";
        AllowanceHead: Record "Allowance Assignment Header";
    begin
        AllowanceHead.Get(entryNo);
        AllowanceLine.Reset;
        AllowanceLine.SetRange("Entry No.", entryNo);
        LoanMgt.SendApprovalAllowanceAssignment(AllowanceHead, AllowanceLine, isApproved);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveAllowanceAssignment(entryNo: Integer; isApproved: Boolean; EmpNo: Code[20]): Text
    begin
        LoanMgt.ApproveRejectAllowanceAssignment(isApproved, entryNo);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnAllowanceAssignment(entryNo: Integer; EmpNo: Code[20]): Text
    begin
        LoanMgt.ReturnAllowanceAssignment(entryNo);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveResignationDoc(docNo: Code[20]; remarks: Text; isApproved: Boolean)
    var
        EmpActivity: Record "Employee Activity";
        DocumentApprover: Record "Document Approver";
    begin

        EmpActivity.Get(docNo);
        EmpActivity.TestField("Approval Status", EmpActivity."Approval Status"::Recommended);
        DocumentApprover.Reset;
        DocumentApprover.SetRange("Document No.", EmpActivity."No.");
        DocumentApprover.SetRange("Employee No.", HrMgt.GetEmployeeNo);
        if DocumentApprover.FindFirst then begin
            if isApproved then begin
                DocumentApprover.Validate(Remarks, remarks);
                DocumentApprover.Validate("Approval Status", DocumentApprover."Approval Status"::Approved)
            end else begin
                DocumentApprover.Validate("Rejection Remarks", remarks);
                DocumentApprover.Validate("Approval Status", DocumentApprover."Approval Status"::Rejected);
            end;
            DocumentApprover.Modify;
        end
        else
            Error('You are not eligible to approve this document.');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitOvertime(employeeNo: Code[20]; OTDate: Date; reasonforOT: Text; recommenderCode: Code[20]; approverCode: Code[20]; estimatedHrs: Decimal; encashmentCode: Code[20]): Integer
    var
        // TempEmpAct: Record "Employee Activity" temporary;
        Overtime: Record OverTime;
        TransferMgt: Codeunit "Transfer Mgt.";
    begin
        Employee.Get(employeeNo);
        /*SalaryLevel.GET(Employee."Salary Level");
        IF NOT SalaryLevel."OT Eligible" THEN
          ERROR(OTEligibleError,Employee.FullName);*/
        Overtime.Reset;
        Overtime.Init;
        Overtime.Validate(Type, Overtime.Type::Overtime);
        Overtime.Validate("Start Date", OTDate);
        Overtime.Validate("Encashment Code", encashmentCode); //Min 11.29.2022
        Overtime.Validate("Estimated Hours", estimatedHrs);
        Overtime.Validate("Employee No.", employeeNo);
        Overtime.Validate("Requested Date", Today);
        Overtime.Validate(Remarks, reasonforOT);
        Overtime.Validate("Recommender Code", recommenderCode);
        Overtime.Validate("Approver Code", approverCode);
        Overtime.Insert;
        if TransferMgt.ApplyForApprovalForms(Overtime) then
            exit(200);
    end;

    local procedure "---API1.00 END"()
    begin
    end;

    local procedure CheckLeaveCount(EmployeeNo: Code[20]) CountStartDate: Date
    var
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        CountStartDate := 0D;
        /*
        AttendaceLine.RESET;
        AttendaceLine.SETRANGE("Employee No.",EmployeeNo);
        AttendaceLine.SETRANGE("Day Type",AttendaceLine."Day Type"::"Working Day");
        AttendaceLine.SETRANGE("Check In Time",0T);
        AttendaceLine.SETRANGE("Check Out Time",0T);
        IF AttendaceLine.FIND('-') THEN
          REPEAT
          CountStartDate := AttendaceLine."Attendance Date";
          EmpActivity.RESET;
          EmpActivity.SETCURRENTKEY("Start Date");
          EmpActivity.SETRANGE("Employee No.",EmployeeNo);
          EmpActivity.SETFILTER(Type,'%1|%2|%3|%4',EmpActivity.Type::"Leave Request",EmpActivity.Type::"Travel Request",
                            EmpActivity.Type::"Out of Office",EmpActivity.Type::"Bulk Cash");
          EmpActivity.SETFILTER("Start Date",'<=%1',AttendaceLine."Attendance Date");
          EmpActivity.SETFILTER("End Date",'>=%1',AttendaceLine."Attendance Date");    //pradhan
          IF NOT EmpActivity.FINDFIRST THEN
            EXIT(CountStartDate);
        UNTIL AttendaceLine.NEXT=0;
        EXIT(TODAY);
        */

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

        /*

        Date.RESET;
        Date.SETRANGE("Period Type",Date."Period Type"::Date);
        Date.SETRANGE("Period Start",EmpActivity."Start Date",EmpActivity."End Date");
        IF Date.FINDFIRST THEN BEGIN
        REPEAT
          IF Date."Period Start" = CountStartDate THEN
            EXIT(0D);
        UNTIL Date.NEXT  = 0;
        END ELSE
        EXIT(CountStartDate);
        END ELSE
        EXIT(CountStartDate);
        END;

        EXIT(CountStartDate);
        */
    end;

    local procedure CreateNewDir(OldPathFile: Text; NewDirectoryName: Text; var AttrDir: Text)
    // PathHelper: DotNet Path;
    // SystemDirectoryServer: DotNet Directory;
    begin
        // Directory := FileMgt.GetDirectoryName(OldPathFile);
        // NewDirectoryName := DelChr(NewDirectoryName, '=', '#%&*:<>?\/{|}~');
        // // if NewDirectoryName <> '' then begin
        // //     Directory := PathHelper.Combine(Directory, NewDirectoryName);
        // //     if not SystemDirectoryServer.Exists(Directory) then
        // //         DirectoryHelper.CreateDirectory(Directory);
        // end;
        // AttrDir := Directory;
    end;

    local procedure CalculateFrequency(empNo: Code[20]; loanType: Text): Integer
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
    begin
        EmpSalaryAdv.Reset;
        EmpSalaryAdv.SetRange("Employee Code", empNo);
        EmpSalaryAdv.SetRange("Approval Status", EmpSalaryAdv."Approval Status"::Approved);
        EmpSalaryAdv.SetRange(FY, HrMgt.ReturnFiscalYear(Today));
        EmpSalaryAdv.SetFilter("Loan Type", loanType);
        exit(EmpSalaryAdv.Count);
    end;

    local procedure CalculateEMI(empNo: Code[20]): Decimal
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
        LoanOutstanding: Record "Loan Outstanding from Finacle";
        PreviosuEMI: Decimal;
        EMIPersonalLoan: Decimal;
        EmpLoanInterest: Record "Employee Loan Interest";
        Homeloan: Record "Employee Loan/Advance";
        VehicleLoan: Decimal;
    begin
        LoanOutstanding.Reset;
        LoanOutstanding.SetRange("Employee No.", empNo);
        LoanOutstanding.SetFilter("Loan Type", '%1|%2', LoanOutstanding."Loan Type"::"Home Loan", LoanOutstanding."Loan Type"::"Home Loan Insurance Tieup");
        LoanOutstanding.CalcSums(EMI);
        PreviosuEMI := LoanOutstanding.EMI;

        LoanOutstanding.Reset;
        LoanOutstanding.SetRange("Employee No.", empNo);
        LoanOutstanding.SetRange("Scheme Type", 'ODA');
        LoanOutstanding.CalcSums("Loan Limit");

        EmpLoanInterest.Reset;
        EmpLoanInterest.SetRange("Loan Type", EmpLoanInterest."Loan Type"::"Personal Loan");
        EmpLoanInterest.SetCurrentKey("Starting Date");
        if EmpLoanInterest.FindLast then;
        EMIPersonalLoan := LoanOutstanding."Loan Limit" * EmpLoanInterest."Interest Rate" / 100 / 12;

        EmpSalaryAdv.Reset;
        EmpSalaryAdv.SetRange("Employee Code", empNo);
        EmpSalaryAdv.SetRange("Approval Status", EmpSalaryAdv."Approval Status"::Approved);
        EmpSalaryAdv.SetRange(Settled, false);
        EmpSalaryAdv.SetRange("Loan Type", EmpSalaryAdv."Loan Type"::"Salary Advance");
        EmpSalaryAdv.CalcSums(EMI);

        Clear(VehicleLoan);
        if SalaryLevel."Vehicle Loan Limit" = 0 then begin
            Clear(LoanOutstanding);
            LoanOutstanding.Reset;
            LoanOutstanding.SetRange("Employee No.", empNo);
            LoanOutstanding.SetRange("Loan Type", LoanOutstanding."Loan Type"::"Vehicle Loan");
            LoanOutstanding.CalcSums(EMI);
            VehicleLoan := LoanOutstanding.EMI;
        end;

        /*
          Homeloan.RESET;
          Homeloan.SETRANGE("Employee Code", empNo);
          Homeloan.SETRANGE("Approval Status",Homeloan."Approval Status"::Approved);
          Homeloan.SETRANGE(Settled,FALSE);
          Homeloan.SETRANGE("Loan Type",Homeloan."Loan Type"::"Home Loan");
          Homeloan.SETRANGE("Repayment Mode",Homeloan."Repayment Mode"::"Insurance Tieup");
          Homeloan.CALCSUMS(EMI);
        */

        exit(EmpSalaryAdv.EMI + PreviosuEMI + EMIPersonalLoan + Homeloan.EMI + VehicleLoan);
    end;

    local procedure CalculateGrossSalary(empNo: Code[20]): Decimal
    begin
        Employee.Get(empNo);
        SalaryLevel.Get(Employee."Salary Level");
        SalaryGrade.Get(Employee."Salary Grade");
        if Employee."Confirmation Date" = 0D then
            Error('Confirmation must have value in employee %1.', Employee."Full Name");
        Evaluate(TotalServicePeriod, Format((Today - Employee."Confirmation Date") / 365));
        TotalServicePeriod := Round(TotalServicePeriod, 0.01, '=');

        exit(SalaryLevel."Basic Salary" +
                              SalaryLevel.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel."Basic Salary");
    end;

    local procedure CheckDBRRatio(DbrRatio: Decimal)
    begin
        if CheckSalaryLevel.Rank >= SalaryLevel.Rank then begin
            if DbrRatio > HRSetup."Below SO DBR" then
                Error('DBR Ratio is %1 which must less than %2.', DbrRatio, HRSetup."Below SO DBR");
        end else begin
            if DbrRatio > HRSetup."DBR Ratio" then
                Error('DBR Ratio is %1 which must less than %2.', DbrRatio, HRSetup."DBR Ratio");
        end;
    end;

    local procedure CalculateLoanEMI(interestRate: Decimal; appliedLoan: Decimal; repaymentPeriod: Integer; loanType: Text; repaymentMode: Text): Decimal
    var
        intRate: Decimal;
        PowerValue: Decimal;
        EmpLoan: Record "Employee Loan/Advance";
    begin
        case loanType of
            Format(EmpLoan."Loan Type"::"Salary Advance"):
                exit(appliedLoan / repaymentPeriod);

            Format(EmpLoan."Loan Type"::"Personal Loan"):
                exit((appliedLoan * interestRate / 100) / 12);

            Format(EmpLoan."Loan Type"::"Vehicle Loan"):
                begin
                    if repaymentPeriod > HRSetup."Max. Veh. Loan Repay Period" then
                        Error('Repayment period exceeded.');
                    intRate := (interestRate / 12) / 100;
                    PowerValue := Power((1 + intRate), (repaymentPeriod * 12));
                    if interestRate = 0 then    //changes for salary level greater than AM
                        exit(appliedLoan / (repaymentPeriod * 12))//changes for salary level greater than AM
                    else
                        exit((appliedLoan * intRate * PowerValue)  //pram 1.31.2020
                              / (PowerValue - 1));
                end;

            Format(EmpLoan."Loan Type"::"Home Loan"):
                begin
                    if repaymentMode = Format(EmpLoan."Repayment Mode"::"EMI Basis") then begin
                        intRate := (interestRate / 12) / 100;
                        PowerValue := Power((1 + intRate), (repaymentPeriod * 12));
                        exit((appliedLoan * intRate * PowerValue)
                            / (PowerValue - 1));
                    end else if repaymentMode = Format(EmpLoan."Repayment Mode"::"Insurance Tieup") then
                            exit((appliedLoan / 1000) * interestRate / 12);
                end;
        end;
    end;

    local procedure GetExistingLoanAmount(EmployeeCode: Code[20]; LoanType: Option " ","Salary Advance","Personal Loan","Home Loan","Vehicle Loan"): Decimal
    var
        LoanOutstanding: Record "Loan Outstanding from Finacle";
    begin
        if LoanType = LoanType::"Home Loan" then begin
            LoanOutstanding.Reset;
            LoanOutstanding.SetRange("Employee No.", EmployeeCode);
            LoanOutstanding.SetFilter("Loan Type", '%1|%2', LoanOutstanding."Loan Type"::"Home Loan", LoanOutstanding."Loan Type"::"Home Loan Insurance Tieup");
            LoanOutstanding.CalcSums("Outstanding Amount");
            exit(Abs(LoanOutstanding."Outstanding Amount"));
        end else if LoanType = LoanType::"Personal Loan" then begin
            LoanOutstanding.Reset;
            LoanOutstanding.SetRange("Employee No.", EmployeeCode);
            LoanOutstanding.SetRange("Loan Type", LoanType);
            LoanOutstanding.CalcSums("Loan Limit");
            exit(LoanOutstanding."Loan Limit");
        end else if LoanType = LoanType::"Vehicle Loan" then begin
            LoanOutstanding.Reset;
            LoanOutstanding.SetRange("Employee No.", EmployeeCode);
            LoanOutstanding.SetRange("Loan Type", LoanOutstanding."Loan Type"::"Vehicle Loan");
            LoanOutstanding.CalcSums("Outstanding Amount");
            exit(Abs(LoanOutstanding."Outstanding Amount"));
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveSelectionCommittee(vacancyNo: Code[20])
    begin
        HrMgt.SelectionCommitteeApproval(vacancyNo);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure generateInterviewEntries(vacancyCode: Code[20]; candidateCode: Code[20])
    begin
        HrMgt.GenerateInterviewerEntries(vacancyCode, candidateCode);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure retrunResignationWaiver(empNo: Code[20]; proposedDateofResignation: Date): Text
    var
        ResignationDays: Integer;
        requestedDate: Date;
    begin
        HRSetup.Get;
        Employee.Get(empNo);
        case Employee."Employment Type" of
            Employee."Employment Type"::Contract:
                begin
                    HRSetup.TestField("Resignation Period Contract");
                    ResignationDays := HRSetup."Resignation Period Contract";
                end;
            Employee."Employment Type"::Probation:
                begin
                    HRSetup.TestField("Resignation Period Probation");
                    ResignationDays := HRSetup."Resignation Period Probation";
                end;

            Employee."Employment Type"::Permanent:
                begin
                    HRSetup.TestField("Resignation Period Permanent");
                    ResignationDays := HRSetup."Resignation Period Permanent";
                end;
        end;

        if requestedDate = 0D then
            requestedDate := Today;

        if (proposedDateofResignation - requestedDate + 1) >= ResignationDays then
            exit('{"Waiver Case" : "Normal"}')
        else
            exit('{"Waiver Case" : "Recovery"}')
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure sendToHR(resignNo: Code[20]): Text
    var
        EmpActivity: Record "Employee Activity";
    begin
        EmpActivity.Get(resignNo);
        EmpActivity.TestField(Type, EmpActivity.Type::Resignation);
        HrMgt.ForwardToHR(EmpActivity);
        exit('success');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure generateAttachmentAPI(leavecode: Code[20]; startDate: Date; endDate: Date; employeeNo: Code[20]): Text
    var
        TempIncomingDoc: Record "Incoming Document";
        NoOfDays: Integer;
        LeaveType: Record "Leave Type Setup";
        AttachmentSetup: Record "Attachment Setup";
    begin
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", employeeNo);
        TempIncomingDoc.SetRange(Type, TempIncomingDoc.Type::" ");
        //TempIncomingDoc.SETRANGE("Leave Type Code",LeaveType.Code);
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.Find('-') then
            repeat
                if TempIncomingDoc."File Name" <> '' then
                    Clear(TempIncomingDoc."File Name");
            until TempIncomingDoc.Next = 0;
        TempIncomingDoc.DeleteAll;
        if leavecode = '' then
            Error('Leave Code must have value');
        LeaveType.Get(leavecode);
        if (startDate = 0D) or (endDate = 0D) then
            NoOfDays := 0
        else
            NoOfDays := endDate - startDate;
        if LeaveType."Sick Leave" then
            if NoOfDays < LeaveType."No. of Days for Attachment" then
                exit;
        //IF LeaveType."Bereavement Leave" OR LeaveType."Maternity/Paternity Leave" OR LeaveType."Sick Leave" THEN BEGIN
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Leave Request");
        AttachmentSetup.SetRange("Leave Type Code", LeaveType.Code);
        if AttachmentSetup.Find('-') then
            repeat
                TempIncomingDoc.Reset;
                TempIncomingDoc.Init;
                TempIncomingDoc.Validate(Type, TempIncomingDoc.Type::" ");
                TempIncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                TempIncomingDoc.Validate(Description, 'Leave Request' + ': ' + LeaveType.Description);
                TempIncomingDoc.Validate("Employee Code", employeeNo);
                TempIncomingDoc.Validate("Leave Type Code", LeaveType.Code);
                TempIncomingDoc.Insert(true);
            until AttachmentSetup.Next = 0;
        //END;
        exit('sucess');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure uploadFeedbackAttachment(basestring: Text; fname: Text; ext: Text): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        tempInstream: InStream;
        DirectoryName: Text;
        base64: Codeunit "Base64 Convert";
    begin
        if fname = '' then
            Error('File name must have value.');
        HRSetup.Get;
        CreateNewDir(HRSetup."Feedback Attach. Location", '', DirectoryName);
        DirectoryName += '\';
        FileName := FileManagement.GetDirectoryName(DirectoryName) + '\' + fname + '.' + ext;
        base64.FromBase64(basestring);
        tempInstream.Read(base64);
        FileManagement.BLOBExport(TempBlob, FileName, false);
        exit(FileName);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure downloadFeedbackAttachment(fileName: Text): Text
    var
        TempBlob: Codeunit "Temp Blob";
        base64: Codeunit "Base64 Convert";
        ext: Text;
    begin
        if fileName <> '' then begin
            FileManagement.BLOBImport(TempBlob, fileName);
            ext := CopyStr(fileName, StrPos(fileName, '.') + 1, StrLen(fileName));
            exit(
            '{' +
            '"extension" : "' + ext + '",' +
            '"attachBase64" : "' + base64.ToBase64(TempBlob.CreateInStream()) + '"}');
        end else
            exit('not found');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure removeFeedbackAttachment(fname: Text)
    begin
        //LoanMgt.DeleteAttachment(IncomingDocument);
        //IncomingDocument.MODIFY;
        Clear(fname);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveRejectAccessControl(empActivityNo: Code[20]; isApproved: Boolean; remark: Text)
    var
        EmpActivity: Record "Employee Activity";
    begin
        EmpActivity.Get(empActivityNo);
        if isApproved then begin
            if EmpActivity."Approval Status" = EmpActivity."Approval Status"::"Pending Approval" then begin
                EmpActivity.Remarks := remark;
                HrMgt.RecommendAccessControl(EmpActivity);
            end else
                Error('Approval Status must be pending or recommended.');
        end else begin
            EmpActivity."Rejection Remarks" := remark;
            HrMgt.RejectAccessControl(EmpActivity);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveRejectAccessControlLine(empActivityNo: Code[20]; lineNo: Integer; isApproved: Boolean)
    var
        AccessControlLine: Record "Access Control Request Line";
    begin
        AccessControlLine.SetRange("Document No.", empActivityNo);
        AccessControlLine.SetRange("Line No.", lineNo);
        AccessControlLine.FindFirst;
        HrMgt.ApproveRejectScreenAccessControl(AccessControlLine, isApproved);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveRejectTransfer(empActivityNo: Code[20]; isApproved: Boolean; remark: Text; employeeNo: Code[20])
    var
        EmpActivity: Record "Employee Activity";
        EmpHrTransfer: Record "Employee/HR Transfer";
    begin
        EmpHrTransfer.Get(empActivityNo);
        if isApproved then begin
            case EmpHrTransfer."Approval Status" of
                EmpHrTransfer."Approval Status"::"Pending Approval":
                    begin
                        EmpHrTransfer.Remarks := remark;
                        HrMgt.RecommendTransferAPI(EmpHrTransfer, employeeNo);
                    end;

                EmpHrTransfer."Approval Status"::Recommended:
                    begin
                        EmpHrTransfer."Reviewer Remarks" := remark;
                        HrMgt.ReviewTransferAPI(EmpHrTransfer, employeeNo);
                    end;

                EmpHrTransfer."Approval Status"::Reviewed:
                    begin
                        EmpHrTransfer."Screener Remarks" := remark;
                        TransferMgt.ScreenTransfer(EmpHrTransfer);
                    end;

                EmpActivity."Approval Status"::Screened:
                    begin
                        TransferMgt.ApproveTransfer(EmpHrTransfer);
                    end;
            end;
        end else begin
            EmpActivity."Rejection Remarks" := remark;
            TransferMgt.RejectTransfer(EmpHrTransfer);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure ackonwledgeTransfer(empActivityNo: Code[20]; dateOfJoining: Date; transferRemarks: Text)
    var
        //EmpActivity: Record "Employee Activity";
        EmployeeTransfer: Record "Employee/HR Transfer";
        TransferMgt: Codeunit "Transfer Mgt.";

    begin
        EmployeeTransfer.Get(empActivityNo);
        EmployeeTransfer.Validate("Date of Joining Of Transfer", dateOfJoining);
        EmployeeTransfer."Transfer Remarks" := transferRemarks;
        TransferMgt.AcknowledgeTransfer(EmployeeTransfer);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveRejectTransferClaim(empActivityNo: Code[20]; isApproved: Boolean; remarks: Text)
    var
        //EmpActivity: Record "Employee Activity";
        EmployeeTransfer: Record "Employee/HR Transfer";
        TransferMgt: Codeunit "Transfer Mgt.";
    begin
        EmployeeTransfer.Get(empActivityNo);
        TransferMgt.ApproveRejectTransferClaim(isApproved, EmployeeTransfer, remarks);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnTrasferClaim(empActivityNo: Code[20]; relocationDis: Decimal; oustationDis: Decimal; bMAFDis: Decimal): Text
    var
        EmpActivity: Record "Employee Activity";
    begin
        HRSetup.Get;
        EmpActivity.Get(empActivityNo);
        exit('{' +
        '"relocationAllowance" : "' + Format(CalculateRelocationAllowance(EmpActivity, relocationDis)) + '",' +
        '"outstationAllowance" : "' + Format(CalculateOutstationAllowance(EmpActivity, oustationDis)) + '",' +
        '"bMAFAllowance" : "' + Format(CalculateBMAccomodationAllowance(EmpActivity, bMAFDis)) + '",' +
        '"officiatingAllowance" : "' + Format(CalculateOfficiatingAllowance(EmpActivity)) + '",' +
        '"officiatingAllowance" : "' + Format(CalculateOfficiatingAllowance(EmpActivity)) + '",' +
        '"remoteAreaAllownce" : "' + Format(CalculateRemoteAreaAllowance(EmpActivity)) + '"' +
        '}');
    end;

    local procedure CalculateRelocationAllowance(EmpAct: Record "Employee Activity"; relocationDistance: Decimal): Decimal
    var
        DimensionValueCurrent: Record "Dimension Value";
        SalaryLevel: Record "Salary Level";
        DimensionValue: Record "Dimension Value";
        RelocationAllowance: Decimal;
    begin
        if relocationDistance = 0 then begin
            RelocationAllowance := 0;
            exit(RelocationAllowance);
            ;
        end;

        if DimensionValueCurrent.Get('BRANCH', EmpAct."Shortcut Dimension 1 Code") then;
        if not DimensionValue.Get('BRANCH', EmpAct."Shortcut Dimension 1 Code (To)") then
            exit;
        if DimensionValueCurrent."Inside/Outisde Valley" = DimensionValueCurrent."Inside/Outisde Valley"::Inside then
            if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Inside then
                exit;

        HRSetup.TestField("Relocation Dist. Criteria (H)");
        HRSetup.TestField("Relocation Dist. Criteria (T)");
        Employee.Get(EmpAct."Employee No.");
        SalaryLevel.Get(Employee."Salary Level");

        if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Outside then begin

            if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Hilly then begin
                if relocationDistance >= HRSetup."Relocation Dist. Criteria (H)" then
                    RelocationAllowance := SalaryLevel."Basic Salary";
            end else if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Terai then begin
                if relocationDistance >= HRSetup."Relocation Dist. Criteria (T)" then
                    RelocationAllowance := SalaryLevel."Basic Salary";
            end;
        end;
        exit(RelocationAllowance);
    end;

    local procedure CalculateOutstationAllowance(EmpAct: Record "Employee Activity"; outstationDistance: Decimal): Decimal
    var
        DimensionValueCurrent: Record "Dimension Value";
        SalaryLevel: Record "Salary Level";
        DimensionValue: Record "Dimension Value";
        outstationAllow: Decimal;
    begin
        if outstationDistance = 0 then begin
            outstationAllow := 0;
            exit(outstationAllow);
        end;
        Employee.Get(EmpAct."Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            exit;
        if DimensionValueCurrent.Get('BRANCH', EmpAct."Shortcut Dimension 1 Code") then;
        if not DimensionValue.Get('BRANCH', EmpAct."Shortcut Dimension 1 Code (To)") then
            exit;
        if DimensionValueCurrent."Inside/Outisde Valley" = DimensionValueCurrent."Inside/Outisde Valley"::Inside then
            if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Inside then
                exit;

        HRSetup.TestField("Outstation Dist. Criteria (H)");
        HRSetup.TestField("Outstation Dist. Criteria (T)");
        SalaryLevel.Get(Employee."Salary Level");

        // TESTFIELD(outstationDistance);
        if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Hilly then begin
            if outstationDistance >= HRSetup."Outstation Dist. Criteria (H)" then
                outstationAllow := SalaryLevel."Basic Salary" * 25 / 100;
        end else if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Terai then begin
            if outstationDistance >= HRSetup."Outstation Dist. Criteria (T)" then
                outstationAllow := SalaryLevel."Basic Salary" * 25 / 100;
        end;
        exit(outstationAllow)
    end;

    local procedure CalculateBMAccomodationAllowance(EmpAct: Record "Employee Activity"; BMAFDistance: Decimal): Decimal
    var
        DimensionValueCurrent: Record "Dimension Value";
        RemoteArea: Record "Remote Area Category";
        PGSetup: Record "Payroll General Setup";
        DimensionValue: Record "Dimension Value";
        BMAccomodationAllow: Decimal;
    begin
        if BMAFDistance = 0 then begin
            BMAccomodationAllow := 0;
            exit(BMAccomodationAllow);
        end;
        PGSetup.Get;
        PGSetup.TestField("BM Functional Title");
        if EmpAct."Functional Title (To)" <> PGSetup."BM Functional Title" then
            exit;
        if DimensionValueCurrent.Get('BRANCH', EmpAct."Shortcut Dimension 1 Code") then
            if not DimensionValue.Get('BRANCH', EmpAct."Shortcut Dimension 1 Code (To)") then
                exit(BMAccomodationAllow);
        if DimensionValueCurrent."Inside/Outisde Valley" = DimensionValueCurrent."Inside/Outisde Valley"::Inside then
            if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Inside then
                exit(BMAccomodationAllow);

        HRSetup.TestField("BMAF Dist. Criteria (H)");
        HRSetup.TestField("BMAF Dist. Criteria (T)");
        if RemoteArea.Get(DimensionValue."Remote Area Category") then begin
            if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Outside then begin
                //  TESTFIELD(BMAFDistance);
                if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Hilly then begin
                    if BMAFDistance >= HRSetup."BMAF Dist. Criteria (H)" then
                        BMAccomodationAllow := RemoteArea."BM Accomodation Amount";
                end else if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Terai then begin
                    if BMAFDistance >= HRSetup."BMAF Dist. Criteria (T)" then
                        BMAccomodationAllow := RemoteArea."BM Accomodation Amount";
                end;
            end;
        end;
        exit(BMAccomodationAllow);
    end;

    local procedure CalculateOfficiatingAllowance(EmpAct: Record "Employee Activity"): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        GrossSalary: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        OfficiatingAllow: Decimal;
    begin
        Employee.Get(EmpAct."Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            exit;
        if EmpAct."Transfer Type" <> EmpAct."Transfer Type"::"Intra Provincial" then
            exit;
        Employee.Get(EmpAct."Employee No.");
        SalaryLevel.Get(Employee."Salary Level");

        SalaryLevel1.Reset;
        SalaryLevel1.SetCurrentKey(Rank);
        SalaryLevel1.SetFilter(Rank, '>%1', SalaryLevel.Rank);
        if SalaryLevel1.FindFirst then begin
            SalaryGrade.Get(0);
            GrossSalary := SalaryLevel1."Basic Salary" +
                            SalaryLevel1.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel1."Basic Salary";
            OfficiatingAllow := GrossSalary;
        end;
        exit(OfficiatingAllow);
    end;

    local procedure CalculateRemoteAreaAllowance(EmpAct: Record "Employee Activity"): Decimal
    var
        GrossSalary: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        RemoteArea: Record "Remote Area Category";
        DimensionValue: Record "Dimension Value";
        RemoteAreaAllow: Decimal;
    begin
        if DimensionValue.Get('BRANCH', EmpAct."Shortcut Dimension 1 Code (To)") then begin
            if RemoteArea.Get(DimensionValue."Remote Area Category") then begin
                Employee.Get(EmpAct."Employee No.");
                SalaryLevel.Get(Employee."Salary Level");
                SalaryGrade.Get(Employee."Salary Grade");
                GrossSalary := SalaryLevel."Basic Salary" +
                                  SalaryLevel.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel."Basic Salary";
                RemoteAreaAllow := RemoteArea."Remote allowance Percentage" / 100 * GrossSalary;
                if RemoteArea."Remote Allowance Amount" < RemoteAreaAllow then
                    RemoteAreaAllow := RemoteArea."Remote Allowance Amount";
            end;
        end;

        exit(RemoteAreaAllow);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure GenerateEmployeeActivityAttachment(empActType: Text; employeeNo: Code[20]): Text
    var
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;
    begin
        // EmpCode := HrMgt.GetEmployeeNo;
        Employee.Get(employeeNo);

        if empActType = Format(TempIncomingDoc."Employee Activity Type"::Overtime) then begin
            SalaryLevel.Get(Employee."Salary Level");
            if not SalaryLevel."OT Attachment Mandatory" then
                exit('success');
        end;

        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", employeeNo);
        TempIncomingDoc.SetRange(Type, TempIncomingDoc.Type::" ");
        if empActType = Format(TempIncomingDoc."Employee Activity Type"::Overtime) then
            TempIncomingDoc.SetRange("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::Overtime)
        else
            TempIncomingDoc.SetRange("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::Insurance);
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.Find('-') then
            repeat
                if TempIncomingDoc."File Name" <> '' then
                    Clear(TempIncomingDoc."File Name");
            until TempIncomingDoc.Next = 0;
        TempIncomingDoc.DeleteAll;

        if empActType = Format(TempIncomingDoc."Employee Activity Type"::Overtime) then
            AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Overtime)
        else
            AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Insurance);
        if AttachmentSetup.Find('-') then
            repeat
                TempIncomingDoc.Reset;
                TempIncomingDoc.Init;
                TempIncomingDoc.Validate(Type, TempIncomingDoc.Type::" ");
                TempIncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                TempIncomingDoc.Validate("Employee Code", employeeNo);
                if empActType = Format(TempIncomingDoc."Employee Activity Type"::Overtime) then
                    TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::Overtime)
                else
                    TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::Insurance);

                TempIncomingDoc.Insert(true);
            until AttachmentSetup.Next = 0;
        exit('success');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnValutKeyAllowance(): Text
    var
        PGSetup: Record "Payroll General Setup";
    begin
        PGSetup.Get;
        exit(PGSetup."Vault Key");
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure uploadEmployeeImage(empNo: Code[20]; ext: Text; fileBaseText: Text)
    var
        FileManagement: Codeunit "File Management";
        FileName: Text;
        ClientFileName: Text;
        DirectoryName: Text;
        TempBlob: Codeunit "Temp Blob";
        Instream: InStream;
        base64: Codeunit "Base64 Convert";
        tempinstream: InStream;
    begin
        Employee.Get(empNo);
        HRSetup.Get;
        CreateNewDir(HRSetup."Attachment Storage Location", empNo, DirectoryName);
        DirectoryName += '\';
        FileName := FileManagement.GetDirectoryName(DirectoryName) + '\' + Employee."First Name" + '_image' + '.' + ext;
        base64.FromBase64(fileBaseText);
        Instream.Read(base64);
        FileManagement.BLOBExport(TempBlob, FileName, false);

        Clear(Employee.Image);
        tempinstream.Read(FileName);
        Employee.Image.ImportStream(tempinstream, ClientFileName);
        Employee.Modify;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure downloadSampleDoc(attachmentCode: Code[20]): Text
    var
        IncomingDoc: Record "Incoming Document";
        FileName: Text;
        TempBlob: Codeunit "Temp Blob";
        Base64: Codeunit "Base64 Convert";
        ext: Text;
    begin
        IncomingDoc.Reset;
        IncomingDoc.SetRange("Attachment Code", attachmentCode);
        IncomingDoc.SetRange(Type, IncomingDoc.Type::Sample);
        if IncomingDoc.FindFirst then begin
            FileName := IncomingDoc."File Name";
            FileManagement.BLOBImport(TempBlob, FileName);
            ext := CopyStr(FileName, StrPos(FileName, '.') + 1, StrLen(FileName));
            exit(
            '{' +
            '"extension" : "' + ext + '",' +
            '"attachBase64" : "' + Base64.ToBase64(TempBlob.CreateInStream()) + '"}');
        end else
            Error('not found');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure downloadPaySlip(year: Integer; month: Text; employeeNo: Code[20]) exitText: Text
    var
        PaySlip: Report "Payroll Payslip";
        MonthOption: Enum "Nepali Month";
        FileName: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        recRef: RecordRef;
        OutStr: OutStream;
        format: ReportFormat;

    begin
        Employee.Get(employeeNo);
        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange("Nepali Year", year);
        PostedPayrollHeader.SetFilter("Nepali Month", month);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Contract)
        else
            PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Regular);
        PostedPayrollHeader.FindFirst;
        case month of
            Format(MonthOption::Baisakh):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Baisakh);
                end;
            Format(MonthOption::Jestha):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Jestha);
                end;
            Format(MonthOption::Asar):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Asar);
                end;
            Format(MonthOption::Shrawn):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Shrawn);
                end;
            Format(MonthOption::Bhadra):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Bhadra);
                end;
            Format(MonthOption::Ashoj):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Ashoj);
                end;
            Format(MonthOption::Kartik):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Kartik);
                end;
            Format(MonthOption::Mangsir):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Mangsir);
                end;
            Format(MonthOption::Poush):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Poush);
                end;
            Format(MonthOption::Margh):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Margh);
                end;
            Format(MonthOption::Falgun):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Falgun);
                end;
            Format(MonthOption::Chaitra):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Chaitra);
                end;
            else
                Error('Please select a month');
        end;
        FileName := StrSubstNo('%1\temp\%2.pdf', HRSetup."Attachment Storage Location", Employee."No.");
        recRef.SetTable(PostedPayrollHeader);
        Report.SaveAs(Report::"Payroll Payslip", '', format::Pdf, OutStr, recRef);
        exitText := downloadFeedbackAttachment(FileName);
        Clear(FileName);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure onValidateKRACategory(AppraisalCode: Code[20])
    var
        AppraisalRec: Record Appraisal;
    begin
        if AppraisalRec.Get(AppraisalCode) then begin
            HrMgt.OnValidateKRACategory(AppraisalRec);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveRejectAppraisal(appraisalCode: Code[20])
    var
        AppraisalRec: Record Appraisal;
    begin
        if AppraisalRec.Get(appraisalCode) then
            HrMgt.ApproveRejectAppraisal(true, AppraisalRec);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure postInterviewEvaluationEntry(candidiateCode: Code[20]; interviewerCode: Code[20]; vacancyCode: Code[20])
    var
        EvaluationEntry: Record "Evaluation Entry";
        CandidateRec: Record Candidate;
    begin
        EvaluationEntry.Reset;
        EvaluationEntry.SetRange("Vacancy Code", vacancyCode); //Min
        EvaluationEntry.SetRange("No.", candidiateCode);
        EvaluationEntry.SetRange("Interviewer Code", interviewerCode);
        EvaluationEntry.SetRange(Posted, true);
        if EvaluationEntry.FindFirst then
            Error('Evaluation Entry is already posted.');

        /*EvaluationEntry.RESET; //Min commented -- not required during submit marks
        EvaluationEntry.SETRANGE("No.",candidiateCode);
        EvaluationEntry.SETRANGE("Interviewer Code",interviewerCode);
        EvaluationEntry.MODIFYALL(Posted,TRUE);*/

        CandidateRec.Reset; //Min -- for update "Interview By" in candidate list
        CandidateRec.SetRange("Vacancy Code", vacancyCode);
        CandidateRec.SetFilter(Status, '%1|%2', CandidateRec.Status::"Interview Scheduled", CandidateRec.Status::Interviewed);
        if CandidateRec.Find('-') then
            repeat
                CandidateRec."Interview By" := '';
                EvaluationEntry.Reset;
                EvaluationEntry.SetRange("Attribute Code", 'APTITUDE');
                EvaluationEntry.SetRange("Vacancy Code", CandidateRec."Vacancy Code");
                EvaluationEntry.SetRange("No.", CandidateRec."No.");
                EvaluationEntry.SetRange(Type, EvaluationEntry.Type::Interview);
                EvaluationEntry.SetFilter(Marks, '>0');
                if EvaluationEntry.Find('-') then
                    repeat
                        if CandidateRec."Interview By" = '' then
                            CandidateRec."Interview By" := EvaluationEntry."Interviewer Code"
                        else
                            CandidateRec."Interview By" += '|' + EvaluationEntry."Interviewer Code";
                    until EvaluationEntry.Next = 0;
                CandidateRec.Modify;
            until CandidateRec.Next = 0;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure recommendInternalCandidate(candidateCode: Code[20]; vacancyCode: Code[20]; remarksVar: Text; isApproved: Boolean)
    var
        CandidateVar: Record Candidate;
    begin
        CandidateVar.Get(candidateCode, vacancyCode);
        CandidateVar.Validate("Recommender Remarks", remarksVar);
        HrMgt.RecommendCandidate(CandidateVar, isApproved);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure applyForPromotion(candidateCode: Code[20]; vacancyCode: Code[20]; recommenderCode: Code[20]; candidateRemarks: Text)
    var
        Candidate: Record Candidate;
    begin
        Candidate.Get(candidateCode, vacancyCode);
        Candidate.Validate("Recommender Code", recommenderCode);
        Candidate.Validate("Candidate Remarks", candidateRemarks);
        HrMgt.ApplyForPromoiton(Candidate);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure updateLoan(empLoanCode: Code[20])
    var
        EmpLoan: Record "Employee Loan/Advance";
    begin
        EmpLoan.Get(empLoanCode);
        if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Open then begin
            EmpLoan.Validate("Employee Code");
            EmpLoan.Validate("Applied Loan/Advance", 0);
            EmpLoan.Validate("Requested Loan Date", Today);
            //EmpLoan.VALIDATE("Repayment Period",1); //Min Commented -- As per Sachin not req.
            EmpLoan.Modify(true);
        end;
        if (EmpLoan."Approval Status" = EmpLoan."Approval Status"::Open) and EmpLoan."Returned Loan" then begin //Min 4.15.2022
            EmpLoan.Validate("Reinstate Date", Today);
            EmpLoan.Modify(true);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure checkAllowanceApproval(branchExtensionCode: Code[20]; empCode: Code[20])
    var
        FunctionalTitle: Record "Functional Title";
    begin
        Employee.Get(empCode);
        if (branchExtensionCode = Employee."Global Dimension 1 Code") or (branchExtensionCode = Employee."Extension Counter Code") then begin
            Employee.TestField("Functional Title");
            FunctionalTitle.Get(Employee."Functional Title");
            if not FunctionalTitle."Is Allowance Approval" then
                Error('Employee not eligible for approva');
        end else
            Error('Employee not eligible for approval');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure downloadTaxDeductionInfoReport(year: Integer; month: Text; employeeNo: Code[20]) exitText: Text
    var
        TaxDeductionInfo: Report "Tax Deduction Information";
        MonthOption: Enum "Nepali Month";
        FileName: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        recRef: RecordRef;
        OutStr: OutStream;
        format: ReportFormat;

    begin
        Employee.Reset;
        Employee.SetRange("No.", employeeNo);
        Employee.FindFirst;
        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange("Nepali Year", year);
        PostedPayrollHeader.SetFilter("Nepali Month", month);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Contract)
        else
            PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Regular);
        PostedPayrollHeader.FindFirst;
        case month of
            Format(MonthOption::Baisakh):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Baisakh);
            Format(MonthOption::Jestha):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Jestha);
            Format(MonthOption::Asar):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Asar);
            Format(MonthOption::Shrawn):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Shrawn);
            Format(MonthOption::Bhadra):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Bhadra);
            Format(MonthOption::Ashoj):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Ashoj);
            Format(MonthOption::Kartik):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Kartik);
            Format(MonthOption::Mangsir):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Mangsir);
            Format(MonthOption::Poush):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Poush);
            Format(MonthOption::Margh):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Margh);
            Format(MonthOption::Falgun):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Falgun);
            Format(MonthOption::Chaitra):
                TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Chaitra);
            else
                Error('Please select a month');
        end;
        FileName := StrSubstNo('%1\temp\%2.pdf', HRSetup."Attachment Storage Location", Employee."No.");
        // TaxDeductionInfo.SetTableView(Employee);
        // TaxDeductionInfo.SaveAsPdf(FileName);
        // exitText := downloadFeedbackAttachment(FileName);

        recRef.SetTable(Employee);
        Report.SaveAs(Report::"Tax Deduction Information", '', format::Pdf, OutStr, recRef);
        exitText := downloadFeedbackAttachment(FileName);
        Clear(FileName);
    end;

    local procedure FindPayrollLine(DocNo: Code[20])
    begin
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitRetirementFund(employeeNo: Code[20]): Integer
    var
        TempRetirementFund: Record "Retirement Fund" temporary;
    begin
        TempRetirementFund.Reset;
        TempRetirementFund.Init;
        TempRetirementFund.Validate("Employee No.", employeeNo);
        TempRetirementFund.Insert;
        if HrMgt.ApplyForRetirementFund(TempRetirementFund) then
            exit(200);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure onOpenRetirementFund(): Text
    var
        RF: Record "Retirement Fund" temporary;
    begin
        HrMgt.OpenRFRequest(HrMgt.GetEmployeeNo(), RF);
        InitReturnApiValue();
        InsertAPINameValue('fiscalYear', RF."Fiscal Year");
        InsertAPINameValue('payrollMonth', Format(RF."Payroll Month"));
        InsertAPINameValue('annualAccessibleIncome', Format(RF."Annual Accessible Income"));
        InsertAPINameValue('rfContributionEligibleAmt', Format(RF."RF Contribution Eligible Amt"));
        InsertAPINameValue('providentFundDeposited', Format(RF."Provident Fund Deposited"));
        InsertAPINameValue('rfContributionDeposited', Format(RF."RF Contribution Deposited"));
        InsertAPINameValue('citContributionDeposited', Format(RF."CIT Contribution Deposited")); //Min
        InsertAPINameValue('providentFundProjected', Format(RF."Provident Fund Projected"));
        InsertAPINameValue('actualProjectedContribution', Format(RF."Actual/Projected Contribution"));
        InsertAPINameValue('additionalSpaceforRF', Format(RF."Additional Space for RF Cont."));
        InsertAPINameValue('projectedMonth', Format(RF."Projection Month"));
        InsertAPINameValue('nICARTFAmount', Format(RF."NICA RTF Amount (Month)"));
        InsertAPINameValue('cITAmount', Format(RF."CIT Amount (Month)"));
        InsertAPINameValue('nICARTFAmountLumpsum', Format(RF."NICA RTF Amount (Lumpsum)"));
        InsertAPINameValue('cITAmountLumpsum', Format(RF."CIT Amount( Lumpsum)"));
        InsertAPINameValue('totalCommittedContribution', Format(RF."Total Committed Contribution"));
        InsertAPINameValue('totalDeduction', Format(RF."Total Deduction"));
        InsertAPINameValue('difference', Format(RF.Difference));
        InsertAPINameValue('approvalStatus', Format(RF."Approval Status"));
        InsertAPINameValue('lumpsumCommittedContribution', Format(RF."Lumpsum Committed Contribution")); //Min
        InsertAPINameValue('lumpsumSpaceMaxBenefit', Format(RF."Lumpsum Space Max Benefit")); //Min
        //InsertAPINameValue('requestedDate',getDateinFormat(TODAY));
        CloseReturnApiValue();
        exit(ReturnAPIValue);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure calculateRetirementFund(nICARTFAmount: Decimal; cITAmount: Decimal; nICARTFAmountLumpsum: Decimal; cITAmountLumpsum: Decimal): Text
    var
        RF: Record "Retirement Fund" temporary;
    begin
        HrMgt.OpenRFRequest(HrMgt.GetEmployeeNo(), RF);
        RF."NICA RTF Amount (Month)" := nICARTFAmount;
        RF."NICA RTF Amount (Lumpsum)" := nICARTFAmountLumpsum;
        RF."CIT Amount (Month)" := cITAmount;
        RF."CIT Amount( Lumpsum)" := cITAmountLumpsum;
        HrMgt.CalculateRetirementFund(RF, RF."Projection Month");
        InitReturnApiValue;
        InsertAPINameValue('totalCommittedContribution', Format(RF."Total Committed Contribution"));
        InsertAPINameValue('lumpsumCommittedContribution', Format(RF."Lumpsum Committed Contribution")); //Min
        InsertAPINameValue('lumpsumSpaceMaxBenefit', Format(RF."Lumpsum Space Max Benefit")); //Min
        InsertAPINameValue('totalDeduction', Format(RF."Total Deduction"));
        InsertAPINameValue('difference', Format(RF.Difference));
        CloseReturnApiValue;
        exit(ReturnAPIValue);
    end;

    local procedure InitReturnApiValue()
    begin
        Clear(ReturnAPIValue);
        ReturnAPIValue := '{';
    end;

    local procedure InsertAPINameValue(Name: Text; Value: Text)
    begin
        Value := DelChr(Value, '=', ',');

        if ReturnAPIValue = '{' then
            ReturnAPIValue += StrSubstNo('"%1" : "%2"', Name, Value)
        else
            ReturnAPIValue += StrSubstNo(',"%1" : "%2"', Name, Value);
    end;

    local procedure CloseReturnApiValue()
    begin
        ReturnAPIValue += '}';
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure exitDeputationValue(): Text
    begin
        Employee.Get(HrMgt.GetEmployeeNo);
        exit(HrMgt.ExitTransferDeputationWiseValue(Employee."Deputation on", Employee."No."));
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure exitFiscalYear(): Text
    begin
        PGSetup.Get; //Min -- For Exit previous fiscal year (Staff Declaration Form)
        exit(HrMgt.ReturnFiscalYear(PGSetup."Payroll Fiscal Year Start Date" - 1));
        //EXIT(HrMgt.ReturnFiscalYear(TODAY)); //Min -- Commented
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnRFData(): Text
    var
        PRAttributesUsage: Record "Payroll Attributes Usage";
        CITAmt: Decimal;
        NICAAmt: Decimal;
    begin
        Employee.Get(HrMgt.GetEmployeeNo());
        PGSetup.Get();
        InitReturnApiValue();
        InsertAPINameValue('citNo', Employee."CIT No.");
        InsertAPINameValue('cITAmountLumpsum', Format(Employee."Lumpsum CIT (Not Actual)"));
        InsertAPINameValue('nICARTFAmountLumpsum', Format(Employee."Lumpsum RF (Not Actual)"));
        if PRAttributesUsage.Get(PGSetup."CIT (Monthly)", Employee."No.") then
            CITAmt := PRAttributesUsage.Amount;
        InsertAPINameValue('cITAmount', Format(CITAmt));
        if PRAttributesUsage.Get(PGSetup."NICA RTF (Monthly)", Employee."No.") then
            NICAAmt := PRAttributesUsage.Amount;
        InsertAPINameValue('nICARTFAmount', Format(NICAAmt));
        CloseReturnApiValue;
        exit(ReturnAPIValue);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure exitLumpSumpRF(): Boolean
    begin
        PGSetup.Get; //Min -- actual RF plan enable for portal
        if PGSetup."Enable RF Lumpsump Plan" then
            exit(true)
        else
            exit(false);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure downloadPaySlipMobileApp(year: Integer; month: Text; EmployeeNo: Code[20]) exitText: Text
    var
        PaySlip: Report "Payroll Payslip";
        MonthOption: Enum "Nepali Month";
        FileName: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        recRef: RecordRef;
        OutStr: OutStream;
        format: ReportFormat;
    begin
        Employee.Get(EmployeeNo);//Min -- Parameter (EmployeeNo) Add.
        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange("Nepali Year", year);
        PostedPayrollHeader.SetFilter("Nepali Month", month);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Contract)
        else
            PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Regular);
        PostedPayrollHeader.FindFirst;
        case month of
            Format(MonthOption::Baisakh):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Baisakh);
                end;
            Format(MonthOption::Jestha):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Jestha);
                end;
            Format(MonthOption::Asar):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Asar);
                end;
            Format(MonthOption::Shrawn):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Shrawn);
                end;
            Format(MonthOption::Bhadra):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Bhadra);
                end;
            Format(MonthOption::Ashoj):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Ashoj);
                end;
            Format(MonthOption::Kartik):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Kartik);
                end;
            Format(MonthOption::Mangsir):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Mangsir);
                end;
            Format(MonthOption::Poush):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Poush);
                end;
            Format(MonthOption::Margh):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Margh);
                end;
            Format(MonthOption::Falgun):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Falgun);
                end;
            Format(MonthOption::Chaitra):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Chaitra);
                end;
            else
                Error('Please select a month');
        end;
        FileName := StrSubstNo('%1\temp\%2.pdf', HRSetup."Attachment Storage Location", Employee."No.");
        recRef.SetTable(PostedPayrollHeader);
        Report.SaveAs(Report::"Payroll Payslip", '', format::Pdf, OutStr, recRef);
        exitText := downloadFeedbackAttachment(FileName);

        Clear(FileName);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure downloadTaxDeductionInfoMobileApp(year: Integer; month: Text; EmployeeNo: Code[20]) exitText: Text
    var
        TaxDeductionInfo: Report "Tax Deduction Info Mob App";
        MonthOption: Enum "Nepali Month";
        FileName: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        recRef: RecordRef;
        OutStr: OutStream;
        format: ReportFormat;
    begin
        Employee.Reset;
        Employee.SetRange("No.", EmployeeNo); //Min -- Parameter (EmployeeNo) Add.
        if Employee.FindFirst then begin
            PostedPayrollHeader.Reset;
            PostedPayrollHeader.SetRange("Nepali Year", year);
            PostedPayrollHeader.SetFilter("Nepali Month", month);
            PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
            if Employee."Employment Type" = Employee."Employment Type"::Contract then
                PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Contract)
            else
                PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Regular);
            PostedPayrollHeader.FindFirst;
            case month of
                Format(MonthOption::Baisakh):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Baisakh);
                Format(MonthOption::Jestha):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Jestha);
                Format(MonthOption::Asar):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Asar);
                Format(MonthOption::Shrawn):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Shrawn);
                Format(MonthOption::Bhadra):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Bhadra);
                Format(MonthOption::Ashoj):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Ashoj);
                Format(MonthOption::Kartik):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Kartik);
                Format(MonthOption::Mangsir):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Mangsir);
                Format(MonthOption::Poush):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Poush);
                Format(MonthOption::Margh):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Margh);
                Format(MonthOption::Falgun):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Falgun);
                Format(MonthOption::Chaitra):
                    TaxDeductionInfo.PassParPortal(PostedPayrollHeader."No.", year, MonthOption::Chaitra);
                else
                    Error('Please select a month');
            end;
        end;
        FileName := StrSubstNo('%1\temp\%2.pdf', HRSetup."Attachment Storage Location", Employee."No.");
        // TaxDeductionInfo.SetTableView(Employee);
        // TaxDeductionInfo.SaveAsPdf(FileName);
        // exitText := downloadFeedbackAttachment(FileName);

        recRef.SetTable(Employee);
        Report.SaveAs(Report::"Tax Deduction Information", '', format::Pdf, OutStr, recRef);
        exitText := downloadFeedbackAttachment(FileName);
        Clear(FileName);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure exitCurrentFiscalYear(): Text
    begin
        exit(HrMgt.ReturnFiscalYear(Today)); //Min -- For Exit Current fiscal year (Extra Milage Module)
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure trainingempInoutTimeUpdate(empNo: Code[20]; trainingDate: Date; checkinTime: Time; checkoutTime: Time): Text
    var
        AttendanceLineRec: Record "Attendance Line";
        EmpAttendanceAct: Record "Employee Attendance & Activity";
    begin
        AttendanceLineRec.Reset;
        AttendanceLineRec.SetRange("Employee No.", empNo);
        AttendanceLineRec.SetRange("Attendance Date", trainingDate);
        if AttendanceLineRec.FindFirst then begin
            AttendanceLineRec."Training Check In Time" := checkinTime;
            AttendanceLineRec."Training Check Out Time" := checkoutTime;
            AttendanceLineRec."Entry Type" := AttendanceLineRec."Entry Type"::Present;
            AttendanceLineRec."Present Day" := 1;
            AttendanceLineRec.Modify;
        end;
        if EmpAttendanceAct.Get(empNo, trainingDate) then begin
            EmpAttendanceAct."Training Check In Time" := checkinTime;
            EmpAttendanceAct."Training Check Out Time" := checkoutTime;
            EmpAttendanceAct."Absent Day" := 0;
            EmpAttendanceAct."Present Day" := 1;
            EmpAttendanceAct.Modify;
            exit('Attendance Updated');
        end else
            Error('Record not found');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure downloadSalarysheetDocMonthWise(year: Integer; month: Text) exitText: Text
    var
        SalarysheetDocMonthWise: Report "Salary Sheet Doc Portal";
        MonthOption: Enum "Nepali Month";
        FileName: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        PayCycleTerm: Code[10];
        PayCyclePeriod: Record "Pay Cycle Period";
        recRef: RecordRef;
        tmpBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        format: ReportFormat;
        InStr: InStream;
    begin
        Employee.Get(HrMgt.GetEmployeeNo);
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Nepali Year", year);
        PayCyclePeriod.SetFilter("Nepali Month", month);
        if PayCyclePeriod.FindFirst then
            PayCycleTerm := PayCyclePeriod."Pay Cycle Term";
        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange("Pay Cycle Term", PayCycleTerm);
        PostedPayrollHeader.SetFilter("Nepali Month", month);
        PostedPayrollHeader.SetFilter(Type, '%1|%2', PostedPayrollHeader.Type::Payroll, PostedPayrollHeader.Type::Adjustment);
        PostedPayrollHeader.FindFirst;
        case month of
            Format(MonthOption::Baisakh):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Baisakh);
                end;
            Format(MonthOption::Jestha):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Jestha);
                end;
            Format(MonthOption::Asar):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Asar);
                end;
            Format(MonthOption::Shrawn):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Shrawn);
                end;
            Format(MonthOption::Bhadra):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Bhadra);
                end;
            Format(MonthOption::Ashoj):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Ashoj);
                end;
            Format(MonthOption::Kartik):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Kartik);
                end;
            Format(MonthOption::Mangsir):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Mangsir);
                end;
            Format(MonthOption::Poush):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Poush);
                end;
            Format(MonthOption::Margh):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Margh);
                end;
            Format(MonthOption::Falgun):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Falgun);
                end;
            Format(MonthOption::Chaitra):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Chaitra);
                end;
            else
                Error('Please select a month');
        end;
        FileName := StrSubstNo('%1\temp\%2.pdf', HRSetup."Attachment Storage Location", Employee."No.");
        recRef.GetTable(PostedPayrollHeader);
        tmpBlob.CreateOutStream(OutStr);
        Report.SaveAs(Report::"Interviewer Email", '', format::Pdf, OutStr, recRef);
        tmpBlob.CreateInStream(InStr);
        // SalarysheetDocMonthWise.SetTableView(PostedPayrollHeader);
        // SalarysheetDocMonthWise.SaveAsPdf(FileName);
        exitText := downloadFeedbackAttachment(FileName);
        Clear(FileName);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure modifyprobempscore(appcode: Code[20])
    var
        KPIMgt: Codeunit "KPI Mgt.";
    begin
        KPIMgt.calculatefinalscoreforprobatation(appcode);//Min -- For Exit Current fiscal year (Extra Milage Module)
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure checkIfTargetExceeds(empcode: Code[20]; kpicode: Code[20]; startdate: Date; enddate: Date)
    var
        KPIMgt: Codeunit "KPI Mgt.";
    begin
        KPIMgt.checkIfTargetExceeds(empcode, kpicode, startdate, enddate)//Min -- For Exit Current fiscal year (Extra Milage Module)
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure myTask(employeeNo: Code[20]) HRCue: Record "HR Cue"
    var
        myTasks: Record "HR Cue";
    begin
        myTasks.SetRange("Employee Filter", employeeNo);
        exit(myTasks);
    end;
}
