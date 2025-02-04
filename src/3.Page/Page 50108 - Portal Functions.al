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
        leaveMgt: Codeunit "Leave Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        ResignationMgt: Codeunit "Resignation Mgt";
        AppraisalMgt: Codeunit "AppraisalMgt.";
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
        EngNepDate: Record "English-Nepali Date";

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
        FirstLogin: Text;
        user: Record User;
        WebServiceKey: text;
        IdentityManagement: Codeunit "Identity Management";
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.SetRange(Status, Employee.Status::Active);
        if not Employee.FindFirst then
            Error(NoEmployeeMappingErr + SystemAdminTxt);

        isAdmin := 'False';
        if UserSetup.Get(UserId) then;
        if UserSetup."Is Admin" then
            isAdmin := 'True';
        if Employee."Disable Punch in" then
            disableLogin := true;

        user.Reset();
        user.SetRange("User Name", UserId);
        user.FindFirst();
        WebServiceKey := IdentityManagement.GetWebServicesKey(user."User Security ID");
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
        if Employee.Login then
            FirstLogin := 'false'
        else
            FirstLogin := 'true';

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
              '","firstLogin": "' + FirstLogin +
              '","WebServiceKey": "' + WebServiceKey +
              '","functionalTitle": "' + Employee."Functional Title Desc" +
              '","employeeName": "' + Employee."Full Name" +
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
    procedure approveLateAttendance(empNo: Code[20]; lateAttendanceDate: Date; isApproved: Boolean; remarks: Text; approverCode: Code[20]): Text
    var
        AttendanceLog: Record "Attendance Log";
    begin
        AttendanceLog.Reset;
        AttendanceLog.SetRange("Employee ID", empNo);
        AttendanceLog.SetRange(Date, lateAttendanceDate);
        if AttendanceLog.FindFirst then begin
            Employee.Reset;
            Employee.SetRange("No.", approverCode);
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
    procedure approveCancelAndAttendanceEmployeeActivity(empActNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text; approverCode: Code[20])
    var
        EmpActivity: Record "Employee Activity";
    begin
        EmpActivity.Get(empActNo);
        EmpActivity.Validate("Rejection Remarks", rejectionRemarks);
        EmpActivity.Modify;
        HrMgt.ApproveRejectCancelAttendanceMissedAPI(EmpActivity, isApproved, approverCode);
    end;

    local procedure "------Leave API---------"()
    begin
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitLeaveRequest(employeeNo: Code[20]; leaveCode: Code[20]; startDate: Date; endDate: Date; remarks: Text; recommenderCode: Code[20]; approverCode: Code[20]; childGender: Text; forDeathof: Text; contactNo: Text): text
    var
        //TempEmpAct: Record "Employee Activity" temporary;
        LeaveMgt: Codeunit "Leave Mgt.";
        tempLeave: Record Leave;
        docNo: text;
        Approval: record "Approval HRMS";
        Count: Integer;
    begin
        tempLeave.Reset;
        tempLeave.Init;
        tempLeave.Validate("Employee No.", employeeNo);
        tempLeave.Validate("Leave Code", leaveCode);
        tempLeave.Validate(Type, tempLeave.Type::"Leave Request");
        tempLeave.Validate("Approval Status", tempLeave."Approval Status"::Open);
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
        tempLeave.Insert(true);
        //For Approver Line Generate
        if (recommenderCode = '') and (approverCode <> '') then begin
            tempLeave."Approver Type" := tempLeave."Approver Type"::Direct;
            tempLeave."Approval Status" := tempLeave."Approval Status"::Recommended;
            Approval.Init();
            Approval.validate("Document No.", Templeave."No.");
            Approval.Validate("Approver No", approverCode);
            Approval.Validate("Document Type", tempLeave.type);
            Approval.validate("Employee No", tempLeave."Employee No.");
            Approval.validate("Approval Sequence", 2);
            Approval.validate("approval Status", tempLeave."Approval Status"::Recommended);
            Approval.insert(true);
        end else if (approverCode <> '') and (recommenderCode <> '') then begin
            tempLeave."Approver Type" := tempLeave."Approver Type"::"With Recommendation";
            tempLeave."Approval Status" := tempLeave."Approval Status"::"Pending Approval";
            //for Recommendation
            Approval.Init();
            Approval.validate("Document No.", Templeave."No.");
            Approval.Validate("Approver No", recommenderCode);
            Approval.Validate("Document Type", tempLeave.type);
            Approval.validate("Employee No", tempLeave."Employee No.");
            Approval.validate("Approval Sequence", 1);
            Approval.validate("approval Status", tempLeave."Approval Status"::"Pending Approval");
            Approval.insert(true);
            // For Approval
            Approval.Init();
            Approval.validate("Document No.", Templeave."No.");
            Approval.Validate("Approver No", approverCode);
            Approval.Validate("Document Type", tempLeave.type);
            Approval.validate("Employee No", tempLeave."Employee No.");
            Approval.validate("Approval Sequence", 2);
            Approval.validate("approval Status", tempLeave."Approval Status"::"Pending Approval");
            Approval.insert(true);
        end else if approverCode = '' then
                Error('Approver Code must have value');
        //     tempLeave."Approver Type" := tempLeave."Approver Type"::"With Recommendation";
        //     tempLeave."Approval Status" := tempLeave."Approval Status"::"Pending Approval";
        //     Approval.Init();
        //     Approval.validate("Document No.", Templeave."No.");
        //     Approval.Validate("Approver No", recommenderCode);
        //     Approval.Validate("Document Type", tempLeave.type);
        //     Approval.validate("Employee No", tempLeave."Employee No.");
        //     Approval.validate("Approval Sequence", 2);
        //     Approval.validate("approval Status", tempLeave."Approval Status"::"Pending Approval");
        //     Approval.insert(true);
        // end
        //else
        docNo := LeaveMgt.ApplyForLeave(tempLeave);
        if docNo <> '' then
            exit(docNo);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveEmployeeLeave(empLeaveNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text; approverCode: Code[20])
    var
        //EmpActivity: Record "Employee Activity";
        Leave: Record Leave;
    begin
        Leave.Get(empLeaveNo);
        if not Leave.Cancelled then begin
            if isApproved and (Leave."Approval Status" = Leave."Approval Status"::"Pending Approval") then
                leaveMgt.RecommendEmployeeLeaveAPI(empLeaveNo, approverCode)
            else begin
                if not isApproved then begin
                    Leave.Validate("Rejection Remarks", rejectionRemarks);
                    Leave.Modify;
                end;
                leaveMgt.ApprovedRejectLeaveApprovalAPI(isApproved, empLeaveNo, approverCode);
            end;
        end;
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
        TempIncomingDoc.SETRANGE("Leave Type Code", leavecode);
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.FindSet() then
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
                TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::"Leave Request");
                TempIncomingDoc.Insert(true);
            until AttachmentSetup.Next = 0;
        //END;
        exit('sucess');
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure getLeaveAttachmentAPI(leaveNo: Code[20]): Text
    var
        TempIncomingDoc: Record "Incoming Document";
        leave: Record leave;
        NoOfDays: Integer;
        LeaveType: Record "Leave Type Setup";
        AttachmentSetup: Record "Attachment Setup";
        Filename: Text;

    begin
        leave.Get(leaveNo);
        TempIncomingDoc.Reset;
        TempIncomingDoc.SETRANGE("No.", leaveNo);
        If not TempIncomingDoc.FindFirst() then
            Error('Document Not Found');
        Filename := LoanMgt.SanitizeFileAttachment(TempIncomingDoc."File Name");
        exit('{' +
        '"Attachment_Code" : "' + DelChr(Format(TempIncomingDoc."Attachment Code"), '=', ',') + '",' +
          '"ShowDelete" :"' + DelChr(Format('false'), '=', ',') + '",' +
          '"ShowDownload" : "' + DelChr(Format('true'), '=', ',') + '",' +
          '"ShowUpload" : "' + DelChr(Format('false'), '=', ',') + '",' +
        '"empActivityType" : "' + DelChr(Format(TempIncomingDoc."Employee Activity Type"), '=', ',') + '",' +
        '"empCode" : "' + DelChr(Format(TempIncomingDoc."Employee Code"), '=', ',') + '",' +
        '"entryNo" : "' + DelChr(Format(TempIncomingDoc."Entry No."), '=', ',') + '",' +
        '"fileName" : "' + DelChr(Format(Filename), '=', ',') + '",' +
        '"leaveCode" : "' + DelChr(Format(TempIncomingDoc."Leave Type Code"), '=', ',') + '",' +
        '"number" : "' + DelChr(Format(TempIncomingDoc."No."), '=', '{}') + '"}');
    end;
    // '","id" :"' + DelChr(Format(Employee."No."), '=', '{}') + '"}');
    // '"arrivalTime" : "' + getTimeinFormat(TravelMgt.GetArrivalTime(empTravelNo)) + '"' +
    //     '}'

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


    local procedure "------Travel API---------"()
    begin

    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitTravelRequest(
    "type": Text;
    "employeeNo": Code[20];
    "startDate": date;
    "endDate": date;
    "requestedDate": Date;
    "purposeOfTravel": text;
    "typeOfVisit": text;
    "modeOfTravel": text;
    "travelType": text;
    "travelWith": code[20];
    "departureFrom": text;
    "destination": text;
    "description": text;
    extended: Boolean;
    "advanceCashRequired": Boolean;
    "estimatedTransportCost": Decimal;
    "estimatedConveyanceExpense": Decimal;
    "otherEstimatedCost": Decimal;
    "departureTime": Time;
    "arrivalTime": Time;
    "travelOrderNo": Code[20];
    advanceCash: Decimal;
    "recommenderCode": Code[20];
    "approverCode": code[20]): Integer
    var
        TravelRequest: Record "Travel Request" temporary;
        TravelMgt: Codeunit "Travel Mgt.";
        TypeOfVisitEnum: Enum "Type Of Visit";
        ModeOfTravelEnum: Enum "Mode Of Travel";
        TravelTypeEnum: Enum "Travel Countries";
        typeEnum: Enum "Employee Activity Type";
        TravelRequest1: Record "Travel Request";
    begin
        Employee.Get(employeeNo);
        /*SalaryLevel.GET(Employee."Salary Level");
        IF NOT SalaryLevel."OT Eligible" THEN
          ERROR(OTEligibleError,Employee.FullName);*/
        typeOfVisitEnum := Enum::"Type Of Visit".FromInteger(typeOfVisitEnum.Ordinals.Get(typeOfVisitEnum.Names.IndexOf(typeOfVisit)));
        ModeOfTravelEnum := Enum::"Mode Of Travel".FromInteger(ModeOfTravelEnum.Ordinals.Get(ModeOfTravelEnum.Names.IndexOf(modeOfTravel)));
        TravelTypeEnum := Enum::"Travel Countries".FromInteger(TravelTypeEnum.Ordinals.Get(TravelTypeEnum.Names.IndexOf(TravelType)));
        typeEnum := Enum::"Employee Activity Type".FromInteger(typeEnum.Ordinals.Get(typeEnum.Names.IndexOf(Type)));
        TravelRequest.Reset;
        TravelRequest.Init;
        TravelRequest.Validate(Type, typeEnum);
        TravelRequest.Validate("Employee No.", employeeNo);
        TravelRequest.Validate("Travel Order No.", travelOrderNo);
        TravelRequest.Validate("Travel With", travelWith);
        TravelRequest.Validate("Travel Countries", TravelTypeEnum);
        TravelRequest.Validate("Start Date", startDate);
        TravelRequest.Validate("End Date", endDate);
        TravelRequest.Validate("Requested Date", requestedDate);
        TravelRequest.Validate("Purpose of Travel", purposeOfTravel); //Min 11.29.2022
        TravelRequest.Validate("Type Of Visit", typeOfVisitEnum);
        TravelRequest.Validate("Mode Of Travel", ModeOfTravelEnum);
        TravelRequest.Validate("Depature From", departureFrom);
        TravelRequest.Validate(Destination, destination);
        TravelRequest.Validate(Description, description);
        TravelRequest.Validate("Advance Cash Required", advanceCashRequired);
        TravelRequest.Validate("Estimated Transportation Cost", estimatedTransportCost);
        TravelRequest.Validate("Estimated Conveyance Expense", estimatedConveyanceExpense);
        TravelRequest.Validate("Other Estimated Cost", otherEstimatedCost);
        TravelRequest.Validate("Advance Cash", advanceCash);
        TravelRequest.Validate("Depature Time", departureTime);
        TravelRequest.Validate("Arrival Time", arrivalTime);
        TravelRequest.Validate("Recommender Code", recommenderCode);
        TravelRequest.Validate("Approver Code", approverCode);
        TravelRequest.Insert;
        if TravelMgt.ApplyForTravel(TravelRequest) then
            exit(200);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitTravelClaim(
   "employeeNo": Code[20];
   "startDate": date;
   "endDate": date;
   "startTime": Time;
   "endTime": Time;
   "requestedDate": Date;
   "purposeOfTravel": text;
   "modeOfTravel": text;
   "travelType": text;
   "travelWith": code[20];
   "description": text;
    claimType: text;
   "estimatedConveyanceExpense": Decimal;
   "otherEstimatedCost": Decimal;
   "recommenderCode": Code[20];
   "approverCode": code[20];
   foodingAllowance: decimal;
   lodgingAllowance: decimal;
   outOfPocketExpense: decimal;
   travelOrderNo: Code[20];
   conveyanceExpense: Decimal;
   otherExpense: Decimal;
   roadAndAirFare: Decimal;
   claimedCountry: text;
   reimbursable: Boolean;
   totalAllowanceClaim: decimal
   ): Integer;
    var
        TravelRequest: Record "Travel Request" temporary;
        TravelMgt: Codeunit "Travel Mgt.";
        TypeOfVisitEnum: Enum "Type Of Visit";
        ModeOfTravelEnum: Enum "Mode Of Travel";
        TravelTypeEnum: Enum "Travel Countries";
        typeEnum: Enum "Employee Activity Type";
        claimTypeEnum: Enum "Claim Type";
    begin
        Employee.Get(employeeNo);
        /*SalaryLevel.GET(Employee."Salary Level");
        IF NOT SalaryLevel."OT Eligible" THEN
          ERROR(OTEligibleError,Employee.FullName);*/
        claimTypeEnum := Enum::"Claim Type".FromInteger(claimTypeEnum.Ordinals.Get(claimTypeEnum.Names.IndexOf(claimType)));
        ModeOfTravelEnum := Enum::"Mode Of Travel".FromInteger(ModeOfTravelEnum.Ordinals.Get(ModeOfTravelEnum.Names.IndexOf(modeOfTravel)));
        TravelTypeEnum := Enum::"Travel Countries".FromInteger(TravelTypeEnum.Ordinals.Get(TravelTypeEnum.Names.IndexOf(TravelType)));
        // typeEnum := Enum::"Employee Activity Type".FromInteger(typeEnum.Ordinals.Get(typeEnum.Names.IndexOf(Type)));

        TravelRequest.Reset;
        TravelRequest.Init;
        TravelRequest.Validate(Type, TravelRequest.Type::"Travel Claim");
        TravelRequest.Validate("Employee No.", employeeNo);
        TravelRequest.Validate("Start Date", TravelMgt.GetTravelStartDate(travelOrderNo));
        TravelRequest.Validate("End Date", endDate);
        TravelRequest.Validate("Actual Travel Start Date", startDate);
        TravelRequest.Validate("Actual Travel End Date", endDate);
        TravelRequest.Validate("Requested Date", requestedDate);
        TravelRequest.Validate("Purpose of Travel", purposeOfTravel); //Min 11.29.2022
        TravelRequest.Validate("Type Of Visit", typeOfVisitEnum);
        TravelRequest.Validate("Mode Of Travel", ModeOfTravelEnum);
        TravelRequest.Validate("Travel Countries", TravelTypeEnum);
        TravelRequest.Validate("Travel With", travelWith);
        TravelRequest.Validate("Estimated Conveyance Expense", estimatedConveyanceExpense);
        TravelRequest.Validate("Other Estimated Cost", otherEstimatedCost);
        TravelRequest.Validate("Travel With", travelWith);
        TravelRequest.Validate(Description, description);
        TravelRequest.Validate("Claim Type", claimTypeEnum);
        TravelRequest.Validate("Fooding Allowance", foodingAllowance);
        TravelRequest.Validate("Lodging Allowance", lodgingAllowance);
        TravelRequest.Validate("Conveyance Expense", conveyanceExpense);
        TravelRequest.Validate("Other Expense", otherExpense);
        TravelRequest.Validate("Road/Air Fare", roadAndAirFare);
        TravelRequest.Validate("Claimed Country", claimedCountry);
        TravelRequest.Validate("Actual Travel Start Time", startTime);
        TravelRequest.Validate("Actual Travel End Time", EndTime);
        TravelRequest.Validate("Total Claimed Amount", totalAllowanceClaim);
        TravelRequest.Validate(Reimbursable, reimbursable);
        TravelRequest.Validate("Out of Pocket Expense", outOfPocketExpense);
        TravelRequest.Validate("Recommender Code", recommenderCode);
        TravelRequest.Validate("Approver Code", approverCode);
        TravelRequest.Validate("Travel Order No.", travelOrderNo);
        TravelRequest.Insert;
        if TravelMgt.ApplyForTravelClaim(TravelRequest) then
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
        //EmpAct: Record "Employee Activity";
        EmpTravel: Record "Travel Request";
        approverCode: Code[10];
    begin
        EmpVar.Get(empNo);
        SalLevel.Get(EmpVar."Salary Level");
        if WithEmpVar.Get(withEmpNo) then;
        if not SalLevel."Travel With Not Eligible" then
            if WithSalLevel.Get(WithEmpVar."Salary Level") then;
        Clear(EstFoodCost);
        Clear(EstLodgCost);
        if travelCountry = Format(EmpTravel."Travel Countries"::Nepal) then begin
            if not ((SalLevel."Nepal Fooding Allowance" > WithSalLevel."Nepal Fooding Allowance")
              and (SalLevel."Nepal Lodging Allowance" > WithSalLevel."Nepal Lodging Allowance")) then begin
                EstFoodCost := WithSalLevel."Nepal Fooding Allowance";
                EstLodgCost := WithSalLevel."Nepal Lodging Allowance";
            end else begin
                EstFoodCost := SalLevel."Nepal Fooding Allowance";
                EstLodgCost := SalLevel."Nepal Lodging Allowance";
            end;
        end
        else if travelCountry = Format(EmpTravel."Travel Countries"::India) then begin
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
    procedure approveTravelActivity(empTravelNo: Code[20]; isApprove: Boolean; rejectionRemarks: text; approverCode: Code[20]): Text
    var
        //EmpActivity: Record "Employee Activity";
        EmpTravel: Record "Travel Request";
    begin
        EmpTravel.Get(empTravelNo);
        // EmpTravel.Validate("Start Date", startDate);
        // EmpTravel.Validate("End Date", endDate);
        // if EmpTravel."Advance Cash Required" then
        //     EmpTravel.Validate("Advance Cash", advanceCash);
        // EmpTravel.Modify;
        if isApprove and (EmpTravel."Approval Status" = EmpTravel."Approval Status"::"Pending Approval") then
            TravelMgt.RecommendEmployeeTravelAPI(empTravelNo, approverCode)
        else begin
            if not isApprove then begin
                EmpTravel.Validate("Rejection Remarks", rejectionRemarks);
                EmpTravel.Modify;
            end;
            TravelMgt.ApprovedRejectTravelApprovalAPI(isApprove, empTravelNo, approverCode);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveEmployeeTravelClaim(empTravelNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text; approverCode: Code[20])
    var
        //EmpActivity: Record "Employee Activity";
        Travel: Record "Travel Request";
    begin
        Travel.Get(empTravelNo);
        if isApproved and (Travel."Approval Status" = Travel."Approval Status"::"Pending Approval") then
            TravelMgt.RecommendEmployeeTravelAPI(empTravelNo, approverCode)
        else begin
            if not isApproved then begin
                Travel.Validate("Rejection Remarks", rejectionRemarks);
                Travel.Modify;
                TravelMgt.ApprovedRejectTravelApprovalAPI(isApproved, empTravelNo, approverCode);
            end
            else
                TravelMgt.FinalApproveForTravelAPI(Travel, approverCode);
        end;

    end;


    [ServiceEnabled]
    [Scope('Personalization')]
    procedure getOutofPocket(empNo: Code[20]; depatureTime: Time; arrivalTime: Time; startDate: Date; endDate: Date; empTravelNo: Code[20]): Text
    var
        allType: Option " ",Fooding,Lodging,OutofExpense;
        travelRequest: Record "Travel Request";
        StartDates: date;
        AdvanceCash: Decimal;
    begin
        Employee.Get(empNo);
        SalaryLevel.Get(Employee."Salary Level");
        travelRequest.Get(empTravelNo);
        // if travelRequest."Travel Order No." <> '' then begin
        StartDate := TravelMgt.GetTravelStartDate(empTravelNo);
        AdvanceCash := TravelMgt.CalculateTotalAdvance(empTravelNo);
        // end;
        exit('{' +
        '"totalFooding" : "' + DelChr(Format(GetAllowanceFoodingLoding(travelRequest, allType::Fooding, endDate - StartDate + 1)), '=', ',') + '",' +
          '"totalLodging" :"' + DelChr(Format(GetAllowanceFoodingLoding(travelRequest, allType::Lodging, endDate - StartDate + 1)), '=', ',') + '",' +
          '"foodingLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(travelRequest, allType::Fooding, false, endDate - StartDate + 1)), '=', ',') + '",' +
          '"lodgingLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(travelRequest, allType::Lodging, false, endDate - StartDate + 1)), '=', ',') + '",' +
        '"AdvanceCash" : "' + DelChr(Format(AdvanceCash), '=', ',') + '",' +
          '"outOfPocket": "' + DelChr(Format(SalaryLevel."Out of Pocket Expense" *
                                TravelMgt.GetOutofExpneseDuration(depatureTime, arrivalTime, StartDate, endDate)), '=', ',') + '"' +
          '}');
        //EXIT( SalaryLevel."Out of Pocket Expense" * HrMgt.GetOutofExpneseDuration(depatureTime,arrivalTime,startDate,endDate));
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure exitForTravelClaims(empTravelNo: Code[20]): Text
    var
        //EmpActivity: Record "Employee Activity";
        EmpTravel: Record "Travel Request";
        allType: Option " ",Fooding,Lodging,OutofExpense;
    begin
        EmpTravel.Get(empTravelNo);

        exit(
        '{' +
          '"totalNoOfDays" : "' + DelChr(Format(TravelMgt.CalculateTotalNoDays(empTravelNo)), '=', ',') + '",' +
          '"totalEstimatedConv" : "' + DelChr(Format(TravelMgt.CalculateTotalEstimatedConv(empTravelNo)), '=', ',') + '",' +
          '"totalFooding" : "' + DelChr(Format(GetAllowanceFoodingLoding(EmpTravel, allType::Fooding, EmpTravel."Total No. of Days")), '=', ',') + '",' +
          '"totalLodging" :"' + DelChr(Format(GetAllowanceFoodingLoding(EmpTravel, allType::Lodging, EmpTravel."Total No. of Days")), '=', ',') + '",' +
          '"totalAdvance" : "' + DelChr(Format(TravelMgt.CalculateTotalAdvance(empTravelNo)), '=', ',') + '",' +
          '"totalTransport" : "' + DelChr(Format(TravelMgt.CalculateTotalTransport(empTravelNo)), '=', ',') + '",' +
          '"totalEstmiatedCost" : "' + DelChr(Format(TravelMgt.CalculateTotalEstimatedCost(empTravelNo)), '=', ',') + '",' +
          '"travelStartDate": "' + getDateinFormat(TravelMgt.GetTravelStartDate(empTravelNo)) + '",' +
          '"travelEndDate": "' + getDateinFormat(TravelMgt.GetTravelEndDate(empTravelNo)) + '",' +
          '"foodingPerDayLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpTravel, allType::Fooding, true, 1)), '=', ',') + '",' +
          '"foodingLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpTravel, allType::Fooding, false, EmpTravel."Total No. of Days")), '=', ',') + '",' +
          '"lodgingPerDayLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpTravel, allType::Lodging, true, 1)), '=', ',') + '",' +
          '"lodgingLimit" : "' + DelChr(Format(GetAllowanceFoodingLodingLimit(EmpTravel, allType::Lodging, false, EmpTravel."Total No. of Days")), '=', ',') + '",' +
          '"depatureTime": "' + getTimeinFormat(TravelMgt.GetDepatureTime(empTravelNo)) + '",' +
          '"arrivalTime" : "' + getTimeinFormat(TravelMgt.GetArrivalTime(empTravelNo)) + '"' +
        '}'
        )
    end;

    local procedure GetAllowanceFoodingLoding(EmpTravel: Record "Travel Request"; allType: Option " ",Fooding,Lodging,OutofExpense; NoofDays: Decimal): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        EmpVar: Record Employee;
    begin
        EmpVar.Get(EmpTravel."Employee No.");
        SalaryLevel.Get(EmpVar."Salary Level");
        if EmpTravel."Travel With" <> '' then begin//AT
            if Employee.Get(EmpTravel."Travel With") then;
            if not SalaryLevel."Travel With Not Eligible" then
                if SalaryLevel1.Get(Employee."Salary Level") then;
        end;

        case EmpTravel."Travel Countries" of
            EmpTravel."Travel Countries"::Nepal:
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
                            exit(SalaryLevel."Out of Pocket Expense" * EmpTravel."Total No. of Days");
                end;

            EmpTravel."Travel Countries"::India:
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
                            exit(SalaryLevel."Out of Pocket Expense" * EmpTravel."Total No. of Days");
                end;

            EmpTravel."Travel Countries"::"Other Countries":
                begin
                    if allType = allType::OutofExpense then
                        exit(SalaryLevel."Out of Pocket Expense" * EmpTravel."Total No. of Days");
                end;
        end;
    end;

    local procedure GetAllowanceFoodingLodingLimit(EmpTravel: Record "Travel Request"; allType: Option " ",Fooding,Lodging,OutofExpense; perDay: Boolean; NoOfDays: Decimal): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        EmpVar: Record Employee;
        Days: Integer;
    begin
        EmpVar.Get(EmpTravel."Employee No.");
        SalaryLevel.Get(EmpVar."Salary Level");
        if EmpTravel."Travel With" <> '' then begin//AT
            if Employee.Get(EmpTravel."Travel With") then;
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
        case EmpTravel."Travel Countries" of
            EmpTravel."Travel Countries"::Nepal:
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

            EmpTravel."Travel Countries"::India:
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

            EmpTravel."Travel Countries"::"Other Countries":
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

    local procedure "Loan API"()
    begin

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
    procedure approveEmpLoanSalAdv(empLoanNo: Code[20]; isApproved: Boolean; remark: Text; approverNo: Code[20])
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
        LoanMgt.ApproveRejectLoanAPI(EmpSalaryAdv, isApproved, approverNo);
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
    procedure retrunAttachmentBase64(docNo: Code[20]; entryNo: Integer): Text
    var
        IncomingDoc: Record "Incoming Document";
        //TempBlob: Codeunit "Temp Blob";
        FilePath: Text;
        FileName: text;
        File: File;
        FileMgt: Codeunit "File Management";
        // ext: Text;
        Base64: Codeunit "Base64 Convert";
        IncomingDocAttachment: Record "Incoming Document Attachment";
        instream: InStream;
        Extension: text;
        LargeText: text;
    begin
        // IncomingDoc.Reset;
        // if docNo <> '' then
        //     IncomingDoc.SetRange("No.", docNo);
        // IncomingDoc.SetRange("Entry No.", entryNo);
        // if IncomingDoc.FindFirst then begin
        // IncomingDocAttachment.Reset();
        // IncomingDocAttachment.SetRange("Incoming Document Entry No.", entryNo);
        // if IncomingDocAttachment.FindFirst() then begin
        //     Extension := IncomingDocAttachment."File Extension";
        //     IncomingDocAttachment.CalcFields(Content);
        //     IncomingDocAttachment.Content.CreateInStream(instr, TextEncoding::UTF8);
        //     LargeText := Base64.ToBase64(instr, false);
        //     // FileName := IncomingDoc."File Name";
        //     // FileManagement.BLOBImport(TempBlob, FileName);
        //     // ext := CopyStr(FileName, StrPos(FileName, '.') + 1, StrLen(FileName));
        //     exit('{' + '"extension": "' + Extension + '",' + '"attachBase64":"' + LargeText + '"}');
        //     // exit(
        //     // '{' +
        //     // '"extension" : "' + ext + '",' +
        //     // '"attachBase64" : "' + Base64.ToBase64(TempBlob.CreateInStream()) + '"}');
        // end else
        //     exit('not found');
        IncomingDoc.Reset();
        if docNo <> '' then
            IncomingDoc.SetRange("No.", docNo);
        IncomingDoc.SetRange("Entry No.", entryNo);
        IncomingDoc.FindFirst();
        FilePath := IncomingDoc."File Name"; // Ensure this stores the server file path
        if FilePath = '' then
            Error('File path not specified for this document.');

        // Validate that the file exists
        // if not File.Exists(FilePath) then
        //     Error('The file does not exist on the server: %1', FilePath);

        // Open the file and read it into an InStream
        File.OPEN(FilePath);
        File.CREATEINSTREAM(InStream);

        // Extract the file name (e.g., "51.jpg" from "D:\HRFiles\51.jpg")
        FileName := FileMgt.GetFileName(FilePath);
        Extension := FileMgt.GetExtension(FileName);
        LargeText := Base64.ToBase64(instream, false);
        exit('{' + '"extension": "' + Extension + '",' + '"attachBase64":"' + LargeText + '"}');


        // Prompt the user to save the file on their client computer
        // DownloadFromStream(InStream, '', '', '', FileName);

        // // Close the file
        // File.CLOSE;

        // Message('File downloaded successfully: %1', FileName);
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
        TempBlob: Codeunit "Temp Blob";
        DocFoundEmpActivity: Boolean;
        DocFoundEmpLoan: Boolean;
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        Leave: record leave;
        DocFoundEmpLeave: Boolean;
        //EmployeeActivity: Record "Employee Activity";
        //LoanType: Option " ","Salary Advance","Personal Loan","Home Loan","Vehicle Loan";
        LoanType: Enum "Loan Type";
        //ActivityType: Option " ","Leave Request","Travel Request","Travel Claim",Transfer,Overtime,"Out of Office","Bulk Cash",Resignation,"Medical Insurance Claim",Promotion,"Attendance Missed","Access Control","Changes in employee";
        ActivityType: Enum "Employee Activity Type";
        DocFoundInsurance: Boolean;
        EmpInsurance: Record "Employee Insurance Information";
        AppraisalDocFound: Boolean;
        AppraisalEmp: Record Appraisal;
        base64: Codeunit "Base64 Convert";
        Outstream: OutStream;
        instream: InStream;
        TargetDirectory: Text;
        ServerFilePath: text;
        ServerFolderPath: text;
        File: File;
        CleanedFileName: text;
        LoanMgt: Codeunit "Loan Mgt.";


    begin
        IncomingDoc.Get(entryNo);
        HRSetup.Get;
        DocFoundEmpActivity := false;
        DocFoundEmpLoan := false;
        AppraisalDocFound := false;
        DocFoundEmpLeave := false; //Min
        if EmployeeLoanAdvance.Get(IncomingDoc."No.") then begin
            DocFoundEmpLoan := true;
            LoanType := EmployeeLoanAdvance."Loan Type";
            if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Screened, EmployeeLoanAdvance."Approval Status"::Approved])
               and (IncomingDoc."File Name" <> '') then
                Error('Attachment already exist.');
        end;

        if not DocFoundEmpLoan then begin
            if EmployeeLoanAdvance.Get(IncomingDoc."No.") then begin
                DocFoundEmpActivity := true;
                // ActivityType := EmployeeLoanAdvance.Type;
                if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Screened, EmployeeLoanAdvance."Approval Status"::Approved])
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
        if not DocFoundEmpLeave then begin //Min
            if docNo <> '' then begin
                if Leave.Get(docNo) then begin
                    DocFoundEmpLeave := true;
                    IncomingDoc."No." := docNo;
                    if (Leave."Approval Status" in [Leave."Approval Status"::"Pending Approval", Leave."Approval Status"::Approved])
                     and (IncomingDoc."File Name" <> '') then
                        Error('Attachment already exist.');
                end;
            end;
        end;


        if IncomingDoc."File Name" <> '' then
            Error('File already exist. Please remove the file first.');

        // CreateNewDir(HRSetup."Attachment Storage Location", IncomingDoc."Employee Code", DirectoryName);
        // DirectoryName += '\';
        // if DocFoundEmpLoan then
        //     CreateNewDir(DirectoryName, Format(LoanType), DirectoryName)
        // else if DocFoundEmpActivity then
        //     CreateNewDir(DirectoryName, Format(ActivityType), DirectoryName)
        // else if DocFoundInsurance then
        //     CreateNewDir(DirectoryName, 'Insurance', DirectoryName)
        // else if AppraisalDocFound then //Min
        //     CreateNewDir(DirectoryName, 'Appraisal', DirectoryName);

        // DirectoryName += '\';
        // // TempBlob.Reset;

        TargetDirectory := HRSetup."Attachment Storage Location";

        if TargetDirectory = '' then
            Error('Attachment Storage Location is not configured.');

        if not TargetDirectory.EndsWith('\') then
            TargetDirectory := TargetDirectory + '\';

        CleanedFileName := LoanMgt.SanitizeFileName(FORMAT(IncomingDoc."Entry No.") + '_' + IncomingDoc."No.");

        // Construct server file path with unique name
        ServerFilePath := TargetDirectory + CleanedFileName + '.' + ext;
        // Construct server file path with unique name
        tempblob.CreateOutStream(outStream);
        base64.FromBase64(fname, Outstream);
        TempBlob.CreateInStream(InStream); // Get the data back from TempBlob
        File.CREATE(ServerFilePath);       // Create the file on the server
        File.CREATEOUTSTREAM(OutStream);  // Prepare to write to the file
        CopyStream(OutStream, InStream);  // Write the data
        File.CLOSE;
        IncomingDoc."File Name" := ServerFilePath;
        IncomingDoc.MODIFY;
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

    local procedure "Allowance Assignment API"()
    begin
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
        LoanMgt.ApproveRejectAllowanceAssignmentAPI(isApproved, entryNo, EmpNo);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnAllowanceAssignment(entryNo: Integer; EmpNo: Code[20]): Text
    begin
        LoanMgt.ReturnAllowanceAssignment(entryNo);
    end;

    local procedure "------Resignation API---------"()
    begin
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitResignation(employeeNo: Code[20]; requestedDate: Date; proposedDateOfResignation: Date; reasonCode: Code[20]; reasonForResignation: text; recommenderCode: Code[20]; applyForWaiver: Boolean): Integer
    var
        // TempEmpAct: Record "Employee Activity" temporary;
        Resignation: Record Resignation temporary;
        ResignationMgt: codeUnit "Resignation Mgt";
    begin
        Resignation.Reset;
        Resignation.Init;
        Resignation.Validate("Employee No.", employeeNo);
        Resignation.Validate(Type, Resignation.Type::Resignation);
        Resignation.Validate("Requested Date", requestedDate);
        Resignation.Validate("Proposed Date of Resignation", proposedDateOfResignation); //Min 11.29.2022
        Resignation.Validate("Reason Code", reasonCode);
        Resignation.Validate("Reason for Resignation", reasonForResignation);
        Resignation.Validate("Recommender Code", recommenderCode);
        Resignation.Validate("Apply for Waiver", applyForWaiver);
        Resignation.Insert;
        if ResignationMgt.SendResignationApproval(Resignation) then
            exit(200);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveResignationDoc(docNo: Code[20]; remarks: Text; isApproved: Boolean; employeeNo: code[20])
    var
        //EmpActivity: Record "Employee Activity";
        Resignation: Record Resignation;
        DocumentApprover: Record "Document Approver";
    begin
        Resignation.Get(docNo);
        Resignation.TestField("Approval Status", Resignation."Approval Status"::Recommended);
        DocumentApprover.Reset;
        DocumentApprover.SetRange("Document No.", Resignation."No.");
        DocumentApprover.SetRange("Employee No.", employeeNo);
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
    procedure approveEmployeeResignation(empResignNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text; employeeNo: Code[20])
    var
        //EmpActivity: Record "Employee Activity";
        Resignation: Record Resignation;
    begin
        Resignation.Get(empResignNo);
        if Resignation.Type = Resignation.Type::Resignation then begin
            if isApproved then begin
                Resignation.Validate(Remarks, rejectionRemarks);
                Resignation.Modify;
                ResignationMgt.ApproveRejectResignationAPI(isApproved, Resignation, employeeNo);
            end else begin
                Resignation.Validate("Rejection Remarks", rejectionRemarks);
                Resignation.Modify;
                ResignationMgt.ApproveRejectResignationAPI(isApproved, Resignation, employeeNo);
            end;
            exit;
        end;
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
        //EmpActivity: Record "Employee Activity";
        Resignation: Record Resignation;
    begin
        Resignation.Get(resignNo);
        Resignation.TestField(Type, Resignation.Type::Resignation);
        HrMgt.ForwardToHR(Resignation);
        exit('success');
    end;

    local procedure "------OverTime API---------"()
    begin
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitOvertime(employeeNo: Code[20]; OTDate: Date; reasonforOT: Text; recommenderCode: Code[20]; approverCode: Code[20]; estimatedHrs: Decimal; encashmentCode: Code[20]): Integer
    var
        // TempEmpAct: Record "Employee Activity" temporary;
        Overtime: Record OverTime temporary;
        OverTimeMgt: codeUnit "OverTime Mgt";
    begin
        Employee.Get(employeeNo);
        /*SalaryLevel.GET(Employee."Salary Level");
        IF NOT SalaryLevel."OT Eligible" THEN
          ERROR(OTEligibleError,Employee.FullName);*/
        Overtime.Reset;
        Overtime.Init;
        Overtime.Validate(Type, Overtime.Type::Overtime);
        Overtime.Validate("Employee No.", employeeNo);
        Overtime.Validate("Start Date", OTDate);
        Overtime.Validate("Encashment Code", encashmentCode); //Min 11.29.2022
        Overtime.Validate("Estimated Hours", estimatedHrs);
        Overtime.Validate("Requested Date", Today);
        Overtime.Validate(Remarks, reasonforOT);
        Overtime.Validate("Recommender Code", recommenderCode);
        Overtime.Validate("Approver Code", approverCode);
        Overtime.Insert;
        if OverTimeMgt.ApplyForOverTimeApprovalForms(Overtime) then
            exit(200);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveEmployeeOverTimeActivity(empOverTimeNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text; approvalCode: Code[20])
    var
        //EmpActivity: Record "Employee Activity";
        OverTime: Record OverTime;
    begin
        OverTime.Get(empOverTimeNo);
        if isApproved and (OverTime."Approval Status" = OverTime."Approval Status"::"Pending Approval") then
            OverTimeMgt.RecommendEmployeeOverTimeAPI(empOverTimeNo, approvalCode)
        else begin
            if not isApproved then begin
                OverTime.Validate("Rejection Remarks", rejectionRemarks);
                OverTime.Modify;
            end;
            OverTimeMgt.ApprovedRejectOverTimeApprovalAPI(isApproved, empOverTimeNo, approvalCode);
        end;
    end;

    local procedure "---API1.00 END"()
    begin
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


    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveSelectionCommittee(vacancyNo: Code[20])
    begin
        HrMgt.SelectionCommitteeApproval(vacancyNo);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure generateInterviewEntries(vacancyCode: Code[20]; candidateCode: Code[20]; employeeCode: Code[20])
    begin
        HrMgt.GenerateInterviewerEntriesAPI(vacancyCode, candidateCode, employeeCode);
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

    local procedure "------Transfer API---------"()
    begin

    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure submitTransferRequest(
    "employeeNo": Code[20];
    "proposedTransferDate": Date;
    "reasonForTransfer": text;
    "description": text;
    "recommenderCode": Code[20];
    "reviewer": text): Integer
    var
        // TravelRequest: Record "Travel Request" temporary;
        TransferRequest: Record "Employee/HR Transfer" temporary;
    begin
        //Employee.Get(employeeNo);
        /*SalaryLevel.GET(Employee."Salary Level");
        IF NOT SalaryLevel."OT Eligible" THEN
          ERROR(OTEligibleError,Employee.FullName);*/
        TransferRequest.Reset;
        TransferRequest.Init;
        TransferRequest.Validate(Type, TransferRequest.Type::"Employee Transfer");
        TransferRequest.Validate("Employee No.", employeeNo);
        TransferRequest.Validate("Transfer Effective Date", ProposedTransferDate);
        TransferRequest.Validate(Description, description);
        TransferRequest.Validate("Reason for Resignation", reasonForTransfer);
        TransferRequest.Validate("Recommender Code", recommenderCode);
        TransferRequest.Validate(Reviewer, reviewer);
        TransferRequest.Insert;
        if TransferMgt.SendTransferApproval(TransferRequest) then
            exit(200);
    end;


    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveRejectTransfer(empActivityNo: Code[20]; isApproved: Boolean; remark: Text; employeeNo: Code[20])
    var
        //EmpActivity: Record "Employee Activity";
        EmpHrTransfer: Record "Employee/HR Transfer";
    begin
        EmpHrTransfer.Get(empActivityNo);
        if isApproved then begin
            case EmpHrTransfer."Approval Status" of
                EmpHrTransfer."Approval Status"::"Pending Approval":
                    begin
                        EmpHrTransfer.Remarks := remark;
                        TransferMgt.RecommendTransferAPI(EmpHrTransfer, employeeNo);
                    end;

                EmpHrTransfer."Approval Status"::Recommended:
                    begin
                        EmpHrTransfer."Reviewer Remarks" := remark;
                        TransferMgt.ReviewTransferAPI(EmpHrTransfer, employeeNo);
                    end;

                EmpHrTransfer."Approval Status"::Reviewed:
                    begin
                        EmpHrTransfer."Screener Remarks" := remark;
                        TransferMgt.ScreenTransferAPI(EmpHrTransfer, employeeNo);
                    end;

                EmpHrTransfer."Approval Status"::Screened:
                    begin
                        TransferMgt.ApproveTransferAPI(EmpHrTransfer, employeeNo);
                    end;
            end;
        end else begin
            EmpHrTransfer."Rejection Remarks" := remark;
            TransferMgt.RejectTransferAPI(EmpHrTransfer, employeeNo);
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
    procedure approveRejectTransferClaim(empActivityNo: Code[20]; isApproved: Boolean; remarks: Text; employeeNo: Code[20])
    var
        //EmpActivity: Record "Employee Activity";
        EmployeeTransfer: Record "Employee/HR Transfer";
        TransferMgt: Codeunit "Transfer Mgt.";
    begin
        EmployeeTransfer.Get(empActivityNo);
        TransferMgt.ApproveRejectTransferClaimAPI(isApproved, EmployeeTransfer, remarks, employeeNo);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure returnTrasferClaim(empTransferNo: Code[20]; relocationDis: Decimal; oustationDis: Decimal; bMAFDis: Decimal): Text
    var
        // EmpActivity: Record "Employee Activity";
        EmployeeTransfer: Record "Employee/HR Transfer";
    begin
        HRSetup.Get;
        EmployeeTransfer.Get(empTransferNo);
        exit('{' +
        '"relocationAllowance" : "' + Format(CalculateRelocationAllowance(EmployeeTransfer, relocationDis)) + '",' +
        '"outstationAllowance" : "' + Format(CalculateOutstationAllowance(EmployeeTransfer, oustationDis)) + '",' +
        '"bMAFAllowance" : "' + Format(CalculateBMAccomodationAllowance(EmployeeTransfer, bMAFDis)) + '",' +
        '"officiatingAllowance" : "' + Format(CalculateOfficiatingAllowance(EmployeeTransfer)) + '",' +
        '"officiatingAllowance" : "' + Format(CalculateOfficiatingAllowance(EmployeeTransfer)) + '",' +
        '"remoteAreaAllownce" : "' + Format(CalculateRemoteAreaAllowance(EmployeeTransfer)) + '"' +
        '}');
    end;

    local procedure CalculateRelocationAllowance(EmployeeTransfer: Record "Employee/HR Transfer"; relocationDistance: Decimal): Decimal
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

        if DimensionValueCurrent.Get('BRANCH', EmployeeTransfer."Shortcut Dimension 1 Code") then;
        if not DimensionValue.Get('BRANCH', EmployeeTransfer."Shortcut Dimension 1 Code (To)") then
            exit;
        if DimensionValueCurrent."Inside/Outisde Valley" = DimensionValueCurrent."Inside/Outisde Valley"::Inside then
            if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Inside then
                exit;

        HRSetup.TestField("Relocation Dist. Criteria (H)");
        HRSetup.TestField("Relocation Dist. Criteria (T)");
        Employee.Get(EmployeeTransfer."Employee No.");
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

    local procedure CalculateOutstationAllowance(EmployeeTransfer: Record "Employee/HR Transfer"; outstationDistance: Decimal): Decimal
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
        Employee.Get(EmployeeTransfer."Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            exit;
        if DimensionValueCurrent.Get('BRANCH', EmployeeTransfer."Shortcut Dimension 1 Code") then;
        if not DimensionValue.Get('BRANCH', EmployeeTransfer."Shortcut Dimension 1 Code (To)") then
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

    local procedure CalculateBMAccomodationAllowance(EmployeeTransfer: Record "Employee/HR Transfer"; BMAFDistance: Decimal): Decimal
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
        if EmployeeTransfer."Functional Title (To)" <> PGSetup."BM Functional Title" then
            exit;
        if DimensionValueCurrent.Get('BRANCH', EmployeeTransfer."Shortcut Dimension 1 Code") then
            if not DimensionValue.Get('BRANCH', EmployeeTransfer."Shortcut Dimension 1 Code (To)") then
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

    local procedure CalculateOfficiatingAllowance(EmployeeTransfer: Record "Employee/HR Transfer"): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        GrossSalary: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        OfficiatingAllow: Decimal;
    begin
        Employee.Get(EmployeeTransfer."Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            exit;
        if EmployeeTransfer."Transfer Type" <> EmployeeTransfer."Transfer Type"::"Intra Provincial" then
            exit;
        Employee.Get(EmployeeTransfer."Employee No.");
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

    local procedure CalculateRemoteAreaAllowance(EmployeeTransfer: Record "Employee/HR Transfer"): Decimal
    var
        GrossSalary: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        RemoteArea: Record "Remote Area Category";
        DimensionValue: Record "Dimension Value";
        RemoteAreaAllow: Decimal;
    begin
        if DimensionValue.Get('BRANCH', EmployeeTransfer."Shortcut Dimension 1 Code (To)") then begin
            if RemoteArea.Get(DimensionValue."Remote Area Category") then begin
                Employee.Get(EmployeeTransfer."Employee No.");
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
        TargetDirectory: text;
        ServerFolderPath: text;
        ServerFilePath: text;
        CleanedFileName: text;
        // FileManagement: Codeunit "File Management";
        // FileName: Text;
        // ClientFileName: Text;
        // DirectoryName: Text;
        TempBlob: Codeunit "Temp Blob";
        Instream: InStream;
        base64: Codeunit "Base64 Convert";
        // tempinstream: InStream;
        Outstream: OutStream;
        File: file;
    begin
        Employee.Get(empNo);
        HRSetup.Get;
        // CreateNewDir(HRSetup."Attachment Storage Location", empNo, DirectoryName);
        // DirectoryName += '\';
        // FileName := FileManagement.GetDirectoryName(DirectoryName) + '\' + Employee."First Name" + '_image' + '.' + ext;
        // base64.FromBase64(fileBaseText);
        // Instream.Read(base64);
        // FileManagement.BLOBExport(TempBlob, FileName, false);



        TargetDirectory := HRSetup."Attachment Storage Location";
        // Step 2: Construct the server folder path

        if TargetDirectory = '' then
            Error('Attachment Storage Location is not configured.');

        if not TargetDirectory.EndsWith('\') then
            TargetDirectory := TargetDirectory + '\';

        // CleanedFileName := LoanMgt.SanitizeFileName(FORMAT(IncomingDoc."Entry No.") + '_' + IncomingDoc."No.");

        // Construct server file path with unique name
        ServerFilePath := TargetDirectory + Employee."First Name" + '_image' + '.' + ext;
        // Construct server file path with unique name
        tempblob.CreateOutStream(outStream);
        base64.FromBase64(fileBaseText, Outstream);
        TempBlob.CreateInStream(InStream); // Get the data back from TempBlob
        File.CREATE(ServerFilePath);       // Create the file on the server
        File.CREATEOUTSTREAM(OutStream);  // Prepare to write to the file
        CopyStream(OutStream, InStream);  // Write the data
        File.CLOSE;
        // IncomingDoc."File Name" := ServerFilePath;
        // IncomingDoc.MODIFY;

        Clear(Employee.Image);
        Instream.Read(ServerFilePath);
        Employee.Image.ImportStream(Instream, ServerFilePath);
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
    procedure downloadPaySlip(year: Integer; month: Text; employeeNo: Code[20]): Text
    var
        PaySlip: Report "Payroll Payslip";
        MonthOption: Enum "Nepali Month";
        FileName: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        recRef: RecordRef;
        OutStr: OutStream;
        format: ReportFormat;
        TempBolb: Codeunit "Temp Blob";
        instream: instream;
        base64: Codeunit "Base64 Convert";
        ext: text;
        exitText: text;

    begin
        HRSetup.get();

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
        TempBolb.CreateOutStream(OutStr);
        FileName := StrSubstNo('%1\temp\%2.pdf', HRSetup."Attachment Storage Location", Employee."No.");
        recRef.Get(PostedPayrollHeader.RecordId);
        recRef.SetTable(PostedPayrollHeader);
        PaySlip.SaveAs('', format::Pdf, OutStr, recRef);
        TempBolb.CreateInStream(instream);
        exitText := base64.ToBase64(InStream);
        Clear(FileName);
        exit('{' + '"extension": "' + 'Pdf' + '",' + '"attachBase64":"' + exitText + '"}');
        //exitText := downloadFeedbackAttachment(FileName);
        Clear(FileName);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure onValidateKRACategory(AppraisalCode: Code[20])
    var
        AppraisalRec: Record Appraisal;
    begin
        if AppraisalRec.Get(AppraisalCode) then begin
            AppraisalMgt.OnValidateKRACategory(AppraisalRec);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure approveRejectAppraisal(appraisalCode: Code[20])
    var
        AppraisalRec: Record Appraisal;
    begin
        if AppraisalRec.Get(appraisalCode) then
            AppraisalMgt.ApproveRejectAppraisal(true, AppraisalRec);
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
                //EvaluationEntry.SetRange("Attribute Code", 'APTITUDE');
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
        tempbolb: Codeunit "Temp Blob";
        instream: InStream;
        base64: Codeunit "Base64 Convert";

    begin
        HRSetup.Get();
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
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Baisakh);
            Format(MonthOption::Jestha):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Jestha);
            Format(MonthOption::Asar):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Asar);
            Format(MonthOption::Shrawn):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Shrawn);
            Format(MonthOption::Bhadra):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Bhadra);
            Format(MonthOption::Ashoj):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Ashoj);
            Format(MonthOption::Kartik):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Kartik);
            Format(MonthOption::Mangsir):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Mangsir);
            Format(MonthOption::Poush):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Poush);
            Format(MonthOption::Margh):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Margh);
            Format(MonthOption::Falgun):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Falgun);
            Format(MonthOption::Chaitra):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Chaitra);
            else
                Error('Please select a month');
        end;
        TempBolb.CreateOutStream(OutStr);
        FileName := StrSubstNo('%1\temp\%2.pdf', HRSetup."Attachment Storage Location", Employee."No.");
        recRef.Get(Employee.RecordId);
        recRef.SetTable(Employee);
        TaxDeductionInfo.SaveAs('', format::Pdf, OutStr, recRef);
        TempBolb.CreateInStream(instream);
        exitText := base64.ToBase64(InStream);
        Clear(FileName);
        exit('{' + '"extension": "' + 'Pdf' + '",' + '"attachBase64":"' + exitText + '"}');

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
    procedure onOpenRetirementFund(empNo: Code[20]): Text
    var
        RF: Record "Retirement Fund" temporary;
    begin
        HrMgt.OpenRFRequest(empNo, RF);
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
        InsertAPINameValue('nICARTFAmount', Format(RF."RTF Amount (Month)"));
        InsertAPINameValue('cITAmount', Format(RF."CIT Amount (Month)"));
        InsertAPINameValue('nICARTFAmountLumpsum', Format(RF."RTF Amount (Lumpsum)"));
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
    procedure calculateRetirementFund(nICARTFAmount: Decimal; cITAmount: Decimal; nICARTFAmountLumpsum: Decimal; cITAmountLumpsum: Decimal; empNo: Code[20]): Text
    var
        RF: Record "Retirement Fund" temporary;
    begin
        HrMgt.OpenRFRequest(empNo, RF);
        RF."RTF Amount (Month)" := nICARTFAmount;
        RF."RTF Amount (Lumpsum)" := nICARTFAmountLumpsum;
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
    procedure returnRFData(empNo: Code[20]): Text
    var
        PRAttributesUsage: Record "Payroll Attributes Usage";
        CITAmt: Decimal;
        NICAAmt: Decimal;
    begin
        Employee.Get(empNo);
        PGSetup.Get();
        InitReturnApiValue();
        InsertAPINameValue('citNo', Employee."CIT No.");
        InsertAPINameValue('cITAmountLumpsum', Format(Employee."Lumpsum CIT (Not Actual)"));
        InsertAPINameValue('nICARTFAmountLumpsum', Format(Employee."Lumpsum RF (Not Actual)"));
        if PRAttributesUsage.Get(PGSetup."CIT (Monthly)", Employee."No.") then
            CITAmt := PRAttributesUsage.Amount;
        InsertAPINameValue('cITAmount', Format(CITAmt));
        if PRAttributesUsage.Get(PGSetup."RTF (Monthly)", Employee."No.") then
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
    procedure exitNepaliStartDate(engStartDate: Date): Text
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", engStartDate);
        if EngNepDate.FindFirst then
            Exit(EngNepDate."Nepali Date");
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure exitNepaliEndDate(engEndDate: Date): Text
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", engEndDate);
        if EngNepDate.FindFirst then
            Exit(EngNepDate."Nepali Date");
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
    procedure countForDashBoard(empcode: Code[20]): text
    var
        Leave: Record Leave;
        Loan: Record "Employee Loan/Advance";
        leaveForRecommendation: Integer;
        leaveForApprove: Integer;
        LoanForRecommendation: Integer;
        LoanForApprove: Integer;
        TravelRequest: Record "Travel Request";
        TravelReqForRecommendation: Integer;
        TravelReqForApprove: Integer;
        TravelClaimRecommendation: Integer;
        TravelClaimApprove: Integer;
        Resign: Record Resignation;
        ResignForRecommendation: Integer;
        ResignForApprove: Integer;
        OverTime: Record OverTime;
        OverTimeForRecommendation: Integer;
        OverTimeForApprove: Integer;
        Appraisal: Record Appraisal;
        AppraisalForRecommendation: Integer;
        AppraisalForApprove: Integer;
        TotalCount: Integer;
        EmpTransfer: Record "Employee/HR Transfer";
        SalaryAdvanceForRecommemdation: Integer;
        SalaryAdvanceForApprove: Integer;
        AttendanceMissed: Record "Employee Activity";
        AttendanceMissedForRecommendation: Integer;
        AttendanceMissedForApprove: Integer;
        EmployeeTransfer: Record "Employee/HR Transfer";
        EmployeeTransferForRecommendation: Integer;
        EmployeeTransferForApprove: Integer;
        AllowanceAssignment: Record "Allowance Assignment Header";
        AllowanceAssignmentForApprove: Integer;
        Approval: Record "Approval HRMS";
    begin
        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Leave Request");
        Approval.SetRange("Approver No", empcode);
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Pending Approval");
        Approval.SetRange("Approval Sequence", 1);
        leaveForRecommendation := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Leave Request");
        Approval.SetRange("Approver No", empcode);
        Approval.SetRange("Approval Status", Approval."Approval Status"::Recommended);
        Approval.SetRange("Approval Sequence", 2);
        leaveForApprove := Approval.Count();

        Loan.Reset();
        Loan.SetRange(Recommender, empcode);
        Loan.SetRange("Approval Status", Loan."Approval Status"::"Pending Approval");
        Loan.SetFilter("Loan Type", '<>%1', loan."Loan Type"::"Salary Advance");
        LoanForRecommendation := Loan.Count();
        Loan.Reset();
        Loan.SetRange(Approver, empcode);
        Loan.SetRange("Approval Status", Loan."Approval Status"::Recommended);
        Loan.SetFilter("Loan Type", '<>%1', loan."Loan Type"::"Salary Advance");
        LoanForApprove := Loan.Count();

        Loan.Reset();
        Loan.SetRange(Recommender, empcode);
        Loan.SetRange("Approval Status", Loan."Approval Status"::"Pending Approval");
        Loan.SetRange("Loan Type", loan."Loan Type"::"Salary Advance");
        SalaryAdvanceForRecommemdation := Loan.Count();

        TravelRequest.Reset();
        TravelRequest.SetRange("Recommender Code", empcode);
        TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Request");
        TravelRequest.SetRange("Approval Status", TravelRequest."Approval Status"::"Pending Approval");
        TravelReqForRecommendation := TravelRequest.Count();
        TravelRequest.Reset();
        TravelRequest.SetRange("Approver Code", empcode);
        TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Request");
        TravelRequest.SetRange("Approval Status", TravelRequest."Approval Status"::Recommended);
        TravelReqForApprove := TravelRequest.Count();

        TravelRequest.Reset();
        TravelRequest.SetRange("Recommender Code", empcode);
        TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Claim");
        TravelRequest.SetRange("Approval Status", TravelRequest."Approval Status"::"Pending Approval");
        TravelClaimRecommendation := TravelRequest.Count();
        TravelRequest.Reset();
        TravelRequest.SetRange("Approver Code", empcode);
        TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Claim");
        TravelRequest.SetRange("Approval Status", TravelRequest."Approval Status"::Recommended);
        TravelClaimApprove := TravelRequest.Count();

        Resign.Reset();
        Resign.SetRange("Recommender Code", empcode);
        Resign.SetRange("Approval Status", Resign."Approval Status"::"Pending Approval");
        ResignForRecommendation := Resign.Count();
        Resign.Reset();
        Resign.SetRange("Approver Code", empcode);
        Resign.SetRange("Approval Status", Resign."Approval Status"::Recommended);
        ResignForApprove := Resign.Count();

        OverTime.Reset();
        OverTime.SetRange("Recommender Code", empcode);
        OverTime.SetRange("Approval Status", OverTime."Approval Status"::"Pending Approval");
        OverTimeForRecommendation := OverTime.Count();
        OverTime.Reset();
        OverTime.SetRange("Approver Code", empcode);
        OverTime.SetRange("Approval Status", OverTime."Approval Status"::Recommended);
        OverTimeForApprove := OverTime.Count();

        EmployeeTransfer.Reset();
        EmployeeTransfer.SetRange("Recommender Code", empcode);
        EmployeeTransfer.SetRange(Type, EmployeeTransfer.Type::"Employee Transfer");
        EmployeeTransfer.SetRange("Approval Status", EmployeeTransfer."Approval Status"::"Pending Approval");
        EmployeeTransferForRecommendation := EmployeeTransfer.Count();
        EmployeeTransfer.Reset();
        EmployeeTransfer.SetRange("Approver Code", empcode);
        EmployeeTransfer.SetRange(Type, EmployeeTransfer.Type::"Employee Transfer");
        EmployeeTransfer.SetRange("Approval Status", EmployeeTransfer."Approval Status"::Recommended);
        EmployeeTransferForApprove := EmployeeTransfer.Count();

        AttendanceMissed.Reset();
        AttendanceMissed.SetRange("Recommender Code", empcode);
        AttendanceMissed.SetRange(Type, AttendanceMissed.Type::"Attendance Missed");
        AttendanceMissed.SetRange("Approval Status", AttendanceMissed."Approval Status"::"Pending Approval");
        AttendanceMissedForRecommendation := AttendanceMissed.Count();
        AttendanceMissed.Reset();
        AttendanceMissed.SetRange("Approver Code", empcode);
        AttendanceMissed.SetRange(Type, AttendanceMissed.Type::"Attendance Missed");
        AttendanceMissed.SetRange("Approval Status", AttendanceMissed."Approval Status"::Recommended);
        AttendanceMissedForApprove := AttendanceMissed.Count();

        Appraisal.Reset();
        Appraisal.SetRange(Reviewer, empcode);
        Appraisal.SetRange(Status, Appraisal.Status::Submitted);
        AppraisalForRecommendation := Appraisal.Count();
        Appraisal.Reset();
        Appraisal.SetRange("Approver Code", empcode);
        Appraisal.SetRange(Status, Appraisal."Status"::Reviewed);
        AppraisalForApprove := Appraisal.Count();

        AllowanceAssignment.Reset();
        AllowanceAssignment.SetRange("Approver ID", empcode);
        AllowanceAssignment.SetRange("Approval Status", AllowanceAssignment."Approval Status"::"Pending Approval");
        AllowanceAssignmentForApprove := AllowanceAssignment.Count();

        TotalCount := leaveForRecommendation + leaveForApprove + LoanForRecommendation + LoanForApprove + TravelReqForRecommendation + TravelReqForApprove + EmployeeTransferForRecommendation + EmployeeTransferForApprove + AllowanceAssignmentForApprove +
                        ResignForRecommendation + ResignForApprove + OverTimeForRecommendation + OverTimeForApprove + AppraisalForRecommendation + AppraisalForApprove + SalaryAdvanceForApprove + SalaryAdvanceForRecommemdation + AttendanceMissedForRecommendation + AttendanceMissedForApprove;

        exit('{"leaveForRecommendation" : "' + Format(leaveForRecommendation) + '"' +
        ',"leaveForApprove" :"' + Format(leaveForApprove) + '"' +
        ',"LoanForRecommendation": "' + format(LoanForRecommendation) + '"' +
        ',"LoanForApprove": "' + format(LoanForApprove) + '"' +
        ',"TravelReqForRecommendation": "' + format(TravelReqForRecommendation) + '"' +
        ',"TravelReqForApprove": "' + format(TravelReqForApprove) + '"' +
        ',"TravelClaimRecommendation": "' + format(TravelClaimRecommendation) + '"' +
        ',"TravelClaimApprove": "' + format(TravelClaimApprove) + '"' +
        ',"ResignForRecommendation": "' + format(ResignForRecommendation) + '"' +
        ',"ResignForApprove": "' + format(ResignForApprove) + '"' +
        ',"OverTimeForRecommendation": "' + format(OverTimeForRecommendation) + '"' +
        ',"OverTimeForApprove": "' + format(OverTimeForApprove) + '"' +
        ',"AppraisalForRecommendation": "' + format(AppraisalForRecommendation) + '"' +
        ',"AppraisalForApprove": "' + format(AppraisalForApprove) + '"' +
        ',"SalaryAdvanceForRecommemdation": "' + format(SalaryAdvanceForRecommemdation) + '"' +
        ',"EmployeeTransferForRecommendation": "' + format(EmployeeTransferForRecommendation) + '"' +
        ',"EmployeeTransferForApprove": "' + format(EmployeeTransferForApprove) + '"' +
        ',"AttendanceMissedForRecommendation": "' + format(AttendanceMissedForRecommendation) + '"' +
        ',"AttendanceMissedForApprove": "' + format(AttendanceMissedForApprove) + '"' +
        ',"AllowanceAssignmentForApprove": "' + format(AllowanceAssignmentForApprove) + '"' +
        ',"TotalCount" :"' + DelChr(Format(TotalCount), '=', '{}') + '"}');

    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure CountEmployeeAttendance(employeeNo: Code[20]): text
    var
        EmployeeAttendace: Record "Employee Attendance & Activity";
        AbsentDayCount: Integer;
        PresentDayCount: Integer;
        WeekOffDayCount: Integer;
        LeaveDayCount: Integer;
        TourDayCount: Integer;
        EnglishNepalidate: Record "English-Nepali Date";
        StartofYear: date;
    begin
        Clear(StartofYear);
        Clear(AbsentDayCount);
        Clear(WeekOffDayCount);
        Clear(PresentDayCount);
        Clear(LeaveDayCount);
        EnglishNepalidate.Reset();
        EnglishNepalidate.SetRange("Fiscal Year", exitCurrentFiscalYear);
        EnglishNepalidate.SetRange("Opening Fiscal Year", true);
        EnglishNepalidate.FindFirst();
        StartofYear := EnglishNepalidate."English Date";

        EmployeeAttendace.Reset();
        EmployeeAttendace.SetRange("Employee No.", employeeNo);
        EmployeeAttendace.SetRange("Attendance Date", StartofYear, Today);
        EmployeeAttendace.SetFilter("Absent Day", '=%1', 1);
        AbsentDayCount := EmployeeAttendace.Count();

        EmployeeAttendace.Reset();
        EmployeeAttendace.SetRange("Employee No.", employeeNo);
        EmployeeAttendace.SetRange("Attendance Date", StartofYear, Today);
        EmployeeAttendace.SetFilter("Week Off Day", '=%1', 1);
        WeekOffDayCount := EmployeeAttendace.Count();

        EmployeeAttendace.Reset();
        EmployeeAttendace.SetRange("Employee No.", employeeNo);
        EmployeeAttendace.SetRange("Attendance Date", StartofYear, Today);
        EmployeeAttendace.SetFilter("Present Day", '=%1', 1);
        PresentDayCount := EmployeeAttendace.Count();

        EmployeeAttendace.Reset();
        EmployeeAttendace.SetRange("Employee No.", employeeNo);
        EmployeeAttendace.SetRange("Attendance Date", StartofYear, Today);
        EmployeeAttendace.SetFilter("Leave Day", '=%1', 1);
        LeaveDayCount := EmployeeAttendace.Count();

        EmployeeAttendace.Reset();
        EmployeeAttendace.SetRange("Employee No.", employeeNo);
        EmployeeAttendace.SetRange("Attendance Date", StartofYear, Today);
        EmployeeAttendace.SetFilter("Tour Day", '=%1', 1);
        TourDayCount := EmployeeAttendace.Count();

        exit('{"AbsentDayCount" : "' + Format(AbsentDayCount) + '"' +
       ',"WeekOffDayCount" :"' + Format(WeekOffDayCount) + '"' +
       ',"PresentDayCount": "' + format(PresentDayCount) + '"' +
       ',"TourDayCount": "' + format(TourDayCount) + '"' +
       ',"LeaveDayCount" :"' + DelChr(Format(LeaveDayCount), '=', '{}') + '"}');

    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure totalLeaveCount() leavecount: Record Leave
    var
        leave: Record Leave;
    begin
        leave.Reset();
        leave.SetFilter("Start Date", '>=%1', Today);
        leave.Setfilter("End Date", '<=%1', Today);
        leave.FindSet();
        exit(leave);
    end;

    // procedure GetFilteredSalesOrders(Filter: Text): List of [Record Leave]
    // var
    //     SalesHeaderRec: Record "Sales Header";
    //     FilteredSalesOrders: List of [Record "Sales Header"];
    // begin
    //     // Apply the filter criteria to the SalesHeaderRec
    //     if Filter <> '' then
    //         SalesHeaderRec.SetRange("Status", Filter);

    //     // Loop through and collect filtered records
    //     if SalesHeaderRec.FindSet() then
    //         repeat
    //             FilteredSalesOrders.Add(SalesHeaderRec);
    //         until SalesHeaderRec.Next() = 0;

    //     exit(FilteredSalesOrders);
    // end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure getChanges(since: DateTime): JsonArray
    var
        Leave: Record Leave; // Replace with your table name
        ResponseArray: JsonArray;
        RecordObject: JsonObject;
    begin
        // Filter records modified after the given timestamp
        Leave.SetRange("SystemModifiedAt", Since, CurrentDateTime);
        if Leave.FindSet() then begin
            repeat
                // Prepare each record as a JSON object
                RecordObject.Add('Name', Leave.Type);
                RecordObject.Add('LastModifiedDateTime', Leave.SystemModifiedAt);

                // Add the JSON object to the array
                ResponseArray.Add(RecordObject);

            // Clear the object for the next record
            // RecordObject.Clear();
            until Leave.Next() = 0;
        end;
        exit(ResponseArray);
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

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure loginSuccess(employeeNo: Code[20]): Integer
    var
        Employee: Record Employee;
    begin
        Employee.Reset();
        if Employee.Get(employeeNo) then begin
            Employee.Login := true;
            exit(200);
        end;
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    procedure noticeCount() NoticeCount: Integer
    var
        Notice: Record "Notice Bulletin";
    begin
        Notice.Reset();
        Notice.SetFilter("Notice Create Date", '<=%1', Today);
        Notice.Setfilter("Notice End Date", '>=%1', Today);
        NoticeCount := Notice.Count;
        exit(NoticeCount);
    end;

    [ServiceEnabled]
    [Scope('Personalization')]
    PROCEDURE InsertEmployeeAttachmentLines(empCode: Code[20]);
    VAR
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
        Employee: Record Employee;
    BEGIN
        Employee.get(empCode);
        AttachmentMandatory.RESET;
        AttachmentMandatory.SETFILTER(Type, '%1|%2|%3|%4', AttachmentMandatory.Type::Education,
                  AttachmentMandatory.Type::"Employee Profile", AttachmentMandatory.Type::"Work Experience",
                  AttachmentMandatory.Type::"Complaince Requirement Forms");
        IF AttachmentMandatory.FINDFIRST THEN
            REPEAT
                IncomingDocument.RESET;
                IncomingDocument.SETRANGE("Order No.", Employee."No.");
                IncomingDocument.SETRANGE("Attachment Code", AttachmentMandatory."Attachment Code");
                IF NOT IncomingDocument.FINDFIRST THEN BEGIN
                    IncomingDocument.RESET;
                    IncomingDocument.INIT;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument.Description := Employee.TABLENAME;
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    IncomingDocument."No." := Employee."No." + AttachmentMandatory."Attachment Code";
                    IncomingDocument."Order No." := FORMAT(Employee."No.");
                    IncomingDocument."Employee Code" := FORMAT(Employee."No.");
                    IncomingDocument.INSERT(TRUE);
                END;
            UNTIL AttachmentMandatory.NEXT = 0;
    END;
}
