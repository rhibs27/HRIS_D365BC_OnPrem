page 50108 "Portal Functions"
{
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
        ApprovalMgt: Codeunit "Approver Mgt";
        OverTimeMgt: Codeunit "OverTime Mgt";
        ResignationMgt: Codeunit "Resignation Mgt";
        AppraisalMgt: Codeunit "AppraisalMgt.";
        FileManagement: Codeunit "File Management";
        AttachmentMgt: Codeunit "Attachment Mgt.";
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
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
    procedure checkLogin(): Text
    var
        Employee: Record Employee;
        counter: Integer;
        FirstLogin, AllowAllowanceAssignment, AllowShiftAssignment : Text;
        user: Record User;
        WebServiceKey: text;
        IdentityManagement: Codeunit "Identity Management";
        PayrollGenSetup: Record "Payroll General Setup";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        functionalTitle: Record "Functional Title";
    begin
        PayrollGenSetup.Get();
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.SetRange(Status, Employee.Status::Active);
        if not Employee.FindFirst then
            Error(NoEmployeeMappingErr + SystemAdminTxt);
        counter := 0;
        EmployeeAttendanceActivity.Reset();
        EmployeeAttendanceActivity.SetRange("Employee No.", Employee."No.");
        EmployeeAttendanceActivity.SetRange("Attendance Date", PayrollGenSetup."Payroll Fiscal Year Start Date", CalcDate('<-1D>', Today));
        if EmployeeAttendanceActivity.FindSet() then
            repeat
                if (EmployeeAttendanceActivity."Present Day" = 1) and ((EmployeeAttendanceActivity."Check In Time" = 0T) or (EmployeeAttendanceActivity."Check Out Time" = 0T)) then
                    counter := counter + 1
                else if EmployeeAttendanceActivity."Absent Day" = 1 then
                    counter := counter + 1;
            until EmployeeAttendanceActivity.Next() = 0;
        // user.Reset();
        // user.SetRange("User Name", UserId);
        // user.FindFirst();
        // WebServiceKey := IdentityManagement.GetWebServicesKey(user."User Security ID");
        if Employee.Login then
            FirstLogin := 'false'
        else
            FirstLogin := 'true';
        if FunctionalTitle.get(Employee."Functional Title") then begin
            if functionalTitle."Allow AllowanceAssignment" then
                AllowAllowanceAssignment := 'true'
            else
                AllowAllowanceAssignment := 'false';
            if functionalTitle."Allow ShiftAssignment" then
                AllowShiftAssignment := 'true'
            else
                AllowShiftAssignment := 'false';
        end;
        exit('{"empno" : "' + Employee."No." +
              '",' + '"count" : "' + Format(counter) +
              '","firstLogin": "' + FirstLogin +
              '","employeeName": "' + Employee."Full Name" +
              '","allowAllowanceAssignment": "' + AllowAllowanceAssignment +
              '","allowShiftAssignment": "' + AllowShiftAssignment +
              '","id" :"' + DelChr(Format(Employee."No."), '=', '{}') + '"}');
    end;

    [ServiceEnabled]
    procedure loginSuccess(): Integer
    var
        Employee: Record Employee;
        user: Record User;
    begin
        Employee.Reset();
        if Employee.Get(HrMgt.GetEmployeeNo()) then begin
            Employee.Login := true;
            Employee.Modify();
            user.Reset();
            user.SetRange("User Name", UserId);
            user.FindFirst();
            exit(200);
        end;
    end;

    // Api for getting Approval from setup << Santosh << 11-3-25
    [ServiceEnabled]
    procedure getEmployeeApproval(empActType: Code[30]): text
    var
        ApprovalSetupLine: Record "Approval Setup line";
        Approval: Record "Approval HRMS";
        Employee: Record Employee;
        EmpRequest: Record Employee;
        Approval1: Record "Approval HRMS";
        ApprovalCode: Text;
        ApproverName: Text;
        ApprovalRole: Text;
    begin
        Clear(ApprovalCode);
        Clear(ApproverName);
        Clear(ApprovalRole);
        EmpRequest.Reset();
        EmpRequest.Get(HrMgt.GetEmployeeNo());
        // Get approval from employee table based on deputation type and approval role << santosh>> 11-3-25
        ApprovalSetupLine.Reset();
        ApprovalSetupLine.Setfilter("Request Type", EmpActType);
        ApprovalSetupLine.SetRange("Deputation On", EmpRequest."Deputation On");
        ApprovalSetupLine.SetRange("Employee Role", EmpRequest."Approver Role");
        if ApprovalSetupLine.Findset() then
            repeat
                Employee.Reset();
                if ApprovalSetupLine."From Deputation" then begin
                    Employee.SetRange("Deputation On", EmpRequest."Deputation On");
                    if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Branch then
                        Employee.SetRange("Global Dimension 1 Code", EmpRequest."Global Dimension 1 Code")
                    else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Department then
                        Employee.SetRange("Department Code", EmpRequest."Department Code")
                    else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Province then
                        Employee.SetRange("Province Code", EmpRequest."Province Code");
                end;
                Employee.SetRange("Approver Role", ApprovalSetupLine."Approver Role");
                if Employee.FindFirst() then begin
                    ApprovalCode += Employee."No." + '/';
                    ApproverName += Employee."Full Name" + '/';
                    ApprovalRole += ApprovalSetupLine."Approval Role" + '/';
                end;
            until ApprovalSetupLine.Next() = 0
        else
            Error('Approval Setup Not found');
        exit('{' + '"approvalCode" : "' + (Format(ApprovalCode)) + '",' +
                '"approvalRole" : "' + (Format(ApprovalRole)) + '",' +
                '"approverName" : "' + (Format(ApproverName)) + '"}');
    end;

    local procedure "------Attendance Missed API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure submitAttendanceMissed(startDate: Date; checkInTime: Time; checkOutTime: time; remarks: Text; reasonCode: Code[20]; type: Text)
    var
        AttendanceMissed, AttendanceMissed2 : Record "Attendance Missed";
        Employee: Record Employee;
        AttendanceMissedMgt: Codeunit "AttendanceMiss Mgt";
        PayrollSetup: Record "Payroll General Setup";
        EmployeeAct: Enum "Employee Activity Type";
    begin
        EmployeeAct := Enum::"Employee Activity Type".FromInteger(EmployeeAct.Ordinals.Get(EmployeeAct.Names.IndexOf(Type)));
        PayrollSetup.Get();
        // Attendance Missed check 
        AttendanceMissed2.Reset();
        AttendanceMissed2.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        AttendanceMissed2.SetRange("Start Date", startDate);
        AttendanceMissed2.Setfilter("Approval Status", '<>%1', AttendanceMissed2."Approval Status"::Rejected);
        if AttendanceMissed2.FindFirst then
            Error('%1 already applied on %2', AttendanceMissed2.Type, AttendanceMissed2."Start Date");
        // Check Already Present
        if EmployeeAct = AttendanceMissed.Type::"Attendance Missed" then
            AttendanceMissedMgt.CheckForLeaveOnAttendanceMissed(startDate, startDate, HrMgt.GetEmployeeNo());
        AttendanceMissed.Init;
        AttendanceMissed.Validate("Employee No.", HrMgt.GetEmployeeNo());
        if EmployeeAct = EmployeeAct::"Attendance Missed" then begin
            AttendanceMissed.Validate(Type, AttendanceMissed.Type::"Attendance Missed")
        end else if EmployeeAct = EmployeeAct::"Late Attendance" then
                AttendanceMissed.Validate(Type, AttendanceMissed.Type::"Late Attendance");
        AttendanceMissed.Validate("Check In Time", checkInTime);
        AttendanceMissed.Validate("Check Out Time", checkOutTime);
        AttendanceMissed.Validate("Requested Date", Today);
        AttendanceMissed.Validate("Reason Code", reasonCode);
        AttendanceMissed.Validate("Approval Status", AttendanceMissed."Approval Status"::Pending);
        AttendanceMissed.Validate("Start Date", startDate);
        AttendanceMissed.Validate(Remarks, remarks);
        if (AttendanceMissed."Start Date" >= Today) then
            Error('Cannot apply for future date.Please check the date.');
        if AttendanceMissed."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date" then
            Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
        AttendanceMissed.TestField("Start Date");
        AttendanceMissed.TestField(Remarks);
        AttendanceMissed.Insert(true);
    end;

    [ServiceEnabled]
    procedure approveRejectMissedAttendance(missedAttendanceNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text)
    var
        RecRef: RecordRef;
        AttendanceMissed: Record "Attendance Missed";
    begin
        AttendanceMissed.Get(missedAttendanceNo);
        if not isApproved then begin
            if rejectionRemarks = '' then
                Error('Rejection Remarks is empty');
            AttendanceMissed.Validate("Rejection Remarks", rejectionRemarks);
            AttendanceMissed.Modify;
        end;
        RecRef.GetTable(AttendanceMissed);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);

    end;

    local procedure "------Leave API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure approveEmployeeLeave(empLeaveNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text)
    var
        Leave: Record Leave;
        RecRef: RecordRef;
    begin
        Leave.Get(empLeaveNo);
        if not Leave.Cancelled then begin
            if not isApproved then begin
                if rejectionRemarks = '' then
                    Error('Rejection Remarks is empty');
                Leave.Validate("Rejection Remarks", rejectionRemarks);
                Leave.Modify;
            end;
            RecRef.GetTable(Leave);
            ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
        end;
    end;

    [ServiceEnabled]
    procedure withDrawRequest(documentNo: Code[20]; documentType: text)
    begin
        ApprovalMgt.WithDrawRequestAPI(documentNo, documentType);
    end;

    [ServiceEnabled]
    procedure submitLeaveCancelRequest(leaveNo: Code[20]; remarks: Text): text
    var
        TempCancelDocument: Record "Cancel Document" temporary;
        docNo: text;
        Leave: Record "Leave";
        AttendanceMissMgt: Codeunit "AttendanceMiss Mgt";
    begin
        HRSetup.Get();
        Leave.Get(LeaveNo);
        if leave.Cancelled then
            Error('Leave request no. %1 is already cancelled.', Leave."No.");
        if Leave."Approved Date" + HRSetup."Cancel Document Upto (Days)" < Today then
            Error('Leave request no. %1 cannot be cancelled after %2', Leave."No.", Leave."Approved Date" + HRSetup."Cancel Document Upto (Days)");
        Leave.TestField("Approval Status", Leave."Approval Status"::Approved);
        Leave.TestField("Cancelled Document No.", '');
        // Clear Approval line 
        TempCancelDocument.Init;
        TempCancelDocument.Validate(Cancelled, true);
        TempCancelDocument.Validate("Employee No.", Leave."Employee No.");
        TempCancelDocument.Validate("Employee Name", Leave."Employee Name");
        TempCancelDocument.Validate("Approval Status", TempCancelDocument."Approval Status"::Open);
        TempCancelDocument.Validate(Type, Leave.Type);
        TempCancelDocument.Validate("Leave Code", Leave."Leave Code");
        TempCancelDocument.Validate("Requested Date", Today);
        TempCancelDocument.Validate("Start Date", Leave."Start Date");
        TempCancelDocument.Validate("End Date", Leave."End Date");
        TempCancelDocument.Validate("No. of Days", Leave."No. of Days");
        TempCancelDocument.Validate(Remarks, remarks);
        TempCancelDocument."Cancelled Document No." := Leave."No.";
        TempCancelDocument."No." := '';
        TempCancelDocument.Insert;
        docNo := AttendanceMissMgt.ApplyCancelEmployeeActivity(TempCancelDocument);
        if docNo <> '' then
            exit(docNo);
    end;

    [ServiceEnabled]
    procedure approveRejectCancelledDoc(cancelledDocNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text)
    var
        RecRef: RecordRef;
        CancelDocument: Record "Cancel Document";
    begin
        CancelDocument.Get(CancelledDocNo);
        if not isApproved then begin
            if rejectionRemarks = '' then
                Error('Rejection Remarks is empty');
            CancelDocument.Validate("Rejection Remarks", rejectionRemarks);
            CancelDocument.Modify;
        end;
        RecRef.GetTable(CancelDocument);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
    end;

    [ServiceEnabled]
    procedure getAttachmentAPI(docNo: Code[20]): text
    var
        TempIncomingDoc: Record "Incoming Document";
        NoOfDays: Integer;
        LeaveType: Record "Leave Type Setup";
        AttachmentSetup: Record "Attachment Setup";
        Filename: Text;
        JsonObject: JsonObject;
        JsonText: text;
        JsonArray: JsonArray;
    begin
        TempIncomingDoc.Reset;
        TempIncomingDoc.SETRANGE("No.", docNo);
        If TempIncomingDoc.Findset() then begin
            repeat
                Filename := AttachmentMgt.SanitizeFileAttachment(TempIncomingDoc."File Name");
                Clear(JsonObject);
                JsonObject.Add('ShowDelete', false);
                JsonObject.Add('ShowDownload', true);
                JsonObject.Add('ShowUpload', false);
                JsonObject.Add('attachmentCode', TempIncomingDoc."Attachment Code");
                JsonObject.Add('empActivityType', format(TempIncomingDoc."Employee Activity Type"));
                JsonObject.Add('empCode', TempIncomingDoc."Employee Code");
                JsonObject.Add('entryNo', TempIncomingDoc."Entry No.");
                JsonObject.Add('fileName', Filename);
                JsonObject.Add('leaveCode', TempIncomingDoc."Leave Type Code");
                JsonObject.Add('number', TempIncomingDoc."No.");
                JsonArray.Add(JsonObject);
            until TempIncomingDoc.Next() = 0;
        end else
            Error('Attachment not available for this Document');
        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;

    [ServiceEnabled]
    procedure noOfDays(startDate: date; endDate: Date; leaveCode: Code[20]; Type: text; leaveType: text): Decimal
    var
        EmployeeActivitiesType: Enum "Employee Activity Type";
        LeaveTypeEnum: Enum "Leave Type";
        LeaveTypeSetup: Record "Leave Type Setup";
    begin
        Evaluate(EmployeeActivitiesType, Type);
        Evaluate(LeaveTypeEnum, leaveType);
        if LeaveTypeEnum <> LeaveTypeEnum::"Full Day" then
            if startDate <> endDate then
                Error('Full and half leave cannot be applied together');
        if LeaveTypeSetup.Get(leaveCode) then begin
            If LeaveTypeEnum <> LeaveTypeEnum::"Full Day" then
                if LeaveTypeSetup."Half Leave Allowed" then begin
                    If HrMgt.IsFriday(startDate) then
                        Error('Half Leave is not allowed on Fridays')
                end else
                    Error('Half Leave is not allowed in %1', LeaveTypeSetup.Description);
        end;
        exit(leaveMgt.CalculateNoOfDays(startDate, endDate, LeaveCode, EmployeeActivitiesType, LeaveTypeEnum, HrMgt.GetEmployeeNo()))
    end;

    local procedure "------Travel API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure submitTravelRequest(
    "startDate": date;
    "endDate": date;
    "requestedDate": Date;
    "purposeOfTravel": text;
    "typeOfVisit": text;
    "modeOfTravel": text;
    "travelType": text;
    "travelWith": Code[20];
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
    advanceCash: Decimal): Integer
    var
        TravelRequest: Record "Travel Request";
        TravelMgt: Codeunit "Travel Mgt.";
        TypeOfVisitEnum: Enum "Type Of Visit";
        ModeOfTravelEnum: Enum "Mode Of Travel";
        TravelTypeEnum: Enum "Travel Countries";
    begin
        typeOfVisitEnum := Enum::"Type Of Visit".FromInteger(typeOfVisitEnum.Ordinals.Get(typeOfVisitEnum.Names.IndexOf(typeOfVisit)));
        ModeOfTravelEnum := Enum::"Mode Of Travel".FromInteger(ModeOfTravelEnum.Ordinals.Get(ModeOfTravelEnum.Names.IndexOf(modeOfTravel)));
        TravelTypeEnum := Enum::"Travel Countries".FromInteger(TravelTypeEnum.Ordinals.Get(TravelTypeEnum.Names.IndexOf(TravelType)));
        TravelRequest.Reset;
        TravelRequest.Init;
        TravelRequest.Validate(Type, TravelRequest.Type::"Travel Request");
        TravelRequest.Validate("Employee No.", HrMgt.GetEmployeeNo());
        TravelRequest.Validate("Travel Order No.", travelOrderNo);
        TravelRequest.Validate("Travel With", travelWith);
        TravelRequest.Validate("Travel Countries", TravelTypeEnum);
        TravelRequest.Validate("Start Date", startDate);
        TravelRequest.Validate("End Date", endDate);
        TravelRequest.Validate("Requested Date", requestedDate);
        TravelRequest.Validate("Purpose of Travel", purposeOfTravel);
        TravelRequest.Validate("Type Of Visit", typeOfVisitEnum);
        TravelRequest.Validate("Mode Of Travel", ModeOfTravelEnum);
        TravelRequest.Validate("Departure From", departureFrom);
        TravelRequest.Validate(Destination, destination);
        TravelRequest.Validate(Description, description);
        TravelRequest.Validate("Advance Cash Required", advanceCashRequired);
        TravelRequest.Validate("Estimated Transportation Cost", estimatedTransportCost);
        TravelRequest.Validate("Estimated Conveyance Expense", estimatedConveyanceExpense);
        TravelRequest.Validate("Other Estimated Cost", otherEstimatedCost);
        TravelRequest.Validate("Advance Cash", advanceCash);
        TravelRequest.Validate("Departure Time", departureTime);
        TravelRequest.Validate("Arrival Time", arrivalTime);
        TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Open);
        TravelRequest.Insert(true);
        if TravelMgt.ApplyForTravel(TravelRequest) then
            exit(200);
    end;

    [ServiceEnabled]
    procedure submitTravelClaim(
   "startDate": date;
   "endDate": date;
   "startTime": Time;
   "endTime": Time;
   "requestedDate": Date;
   "purposeOfTravel": text;
   "modeOfTravel": text;
   "travelType": text;
   "travelWith": Code[20];
   "description": text;
    claimType: text;
   "estimatedConveyanceExpense": Decimal;
   "otherEstimatedCost": Decimal;
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
        TravelRequest: Record "Travel Request";
        TravelMgt: Codeunit "Travel Mgt.";
        TypeOfVisitEnum: Enum "Type Of Visit";
        ModeOfTravelEnum: Enum "Mode Of Travel";
        TravelTypeEnum: Enum "Travel Countries";
        typeEnum: Enum "Employee Activity Type";
        claimTypeEnum: Enum "Claim Type";
    begin
        claimTypeEnum := Enum::"Claim Type".FromInteger(claimTypeEnum.Ordinals.Get(claimTypeEnum.Names.IndexOf(claimType)));
        ModeOfTravelEnum := Enum::"Mode Of Travel".FromInteger(ModeOfTravelEnum.Ordinals.Get(ModeOfTravelEnum.Names.IndexOf(modeOfTravel)));
        TravelTypeEnum := Enum::"Travel Countries".FromInteger(TravelTypeEnum.Ordinals.Get(TravelTypeEnum.Names.IndexOf(TravelType)));
        TravelRequest.Reset;
        TravelRequest.Init;
        TravelRequest.Validate(Type, TravelRequest.Type::"Travel Claim");
        TravelRequest.Validate("Employee No.", HrMgt.GetEmployeeNo());
        TravelRequest.Validate("Start Date", TravelMgt.GetTravelStartDate(travelOrderNo));
        TravelRequest.Validate("End Date", endDate);
        TravelRequest.Validate("Actual Travel Start Date", startDate);
        TravelRequest.Validate("Actual Travel End Date", endDate);
        TravelRequest.Validate("Requested Date", requestedDate);
        TravelRequest.Validate("Purpose of Travel", purposeOfTravel);
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
        TravelRequest.Validate("Travel Order No.", travelOrderNo);
        TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Open);
        TravelRequest.Insert(true);
        if TravelMgt.ApplyForTravelClaim(TravelRequest) then
            exit(200);
    end;

    [ServiceEnabled]
    procedure exitEstimationCosts(withEmpNo: Code[20]; travelCountry: Text): Text
    var
        EmpVar: Record Employee;
        WithEmpVar: Record Employee;
        SalLevel: Record "Salary Level";
        WithSalLevel: Record "Salary Level";
        EstLodgCost: Decimal;
        EstFoodCost: Decimal;
        EmpTravel: Record "Travel Request";
        approverCode: Code[20];
    begin
        EmpVar.Get(HrMgt.GetEmployeeNo());
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
        end
        else if travelCountry = Format(EmpTravel."Travel Countries"::"Other Countries") then begin
            if not ((SalLevel."Others Fooding Allowance" > WithSalLevel."Others Fooding Allowance")
              and (SalLevel."Others Lodging Allowance" > WithSalLevel."Others Lodging Allowance")) then begin
                EstFoodCost := WithSalLevel."Others Fooding Allowance";
                EstLodgCost := WithSalLevel."Others Lodging Allowance";
            end else begin
                EstFoodCost := SalLevel."Others Fooding Allowance";
                EstLodgCost := SalLevel."Others Lodging Allowance";
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
    procedure approveTravelActivity(empTravelNo: Code[20]; isApproved: Boolean; rejectionRemarks: text): Text
    var
        EmpTravel: Record "Travel Request";
        RecRef: RecordRef;
    begin
        EmpTravel.Get(empTravelNo);
        if not isApproved then begin
            if rejectionRemarks = '' then
                Error('Rejection Remarks is empty');
            EmpTravel.Validate("Rejection Remarks", rejectionRemarks);
            EmpTravel.Modify;
        end;
        RecRef.GetTable(EmpTravel);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
    end;

    [ServiceEnabled]
    procedure approveEmployeeTravelClaim(empTravelNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text)
    var
        TravelClaim: Record "Travel Request";
        RecRef: RecordRef;
    begin
        TravelClaim.Get(empTravelNo);
        if not isApproved then begin
            if rejectionRemarks = '' then
                Error('Rejection Remarks is empty');
            TravelClaim.Validate("Rejection Remarks", rejectionRemarks);
            TravelClaim.Modify;
        end;
        RecRef.GetTable(TravelClaim);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
    end;

    //not used currently handled by company Specific
    [ServiceEnabled]
    procedure getOutofPocket(depatureTime: Time; arrivalTime: Time; startDate: Date; endDate: Date; empTravelNo: Code[20]): Text
    var
        allType: Enum "Allowance Type";
        travelRequest: Record "Travel Request";
        StartDates: date;
        AdvanceCash: Decimal;
    begin
        travelRequest.Get(empTravelNo);
        StartDate := TravelMgt.GetTravelStartDate(empTravelNo);
        AdvanceCash := TravelMgt.CalculateTotalAdvance(empTravelNo);
        exit('{' +
        '"totalFooding" : "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodging(travelRequest, allType::Fooding, endDate - StartDate + 1)), '=', ',') + '",' +
          '"totalLodging" :"' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodging(travelRequest, allType::Lodging, endDate - StartDate + 1)), '=', ',') + '",' +
          '"foodingLimit" : "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodingLimit(travelRequest, allType::Fooding, false, endDate - StartDate + 1)), '=', ',') + '",' +
          '"lodgingLimit" : "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodingLimit(travelRequest, allType::Lodging, false, endDate - StartDate + 1)), '=', ',') + '",' +
        '"AdvanceCash" : "' + DelChr(Format(AdvanceCash), '=', ',') + '",' +
          '"outOfPocket": "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodging(travelRequest, allType::Lodging, TravelMgt.GetOutofExpenseDuration(depatureTime, arrivalTime, StartDate, endDate))), '=', ',') + '"' +
          '}');
    end;

    [ServiceEnabled]
    procedure exitForTravelClaims(empTravelNo: Code[20]): Text
    var
        EmpTravel: Record "Travel Request";
        allType: Enum "Allowance Type";
    begin
        EmpTravel.Get(empTravelNo);
        exit(
        '{' +
          '"totalNoOfDays" : "' + DelChr(Format(TravelMgt.CalculateTotalNoDays(empTravelNo)), '=', ',') + '",' +
          '"totalEstimatedConv" : "' + DelChr(Format(TravelMgt.CalculateTotalEstimatedConv(empTravelNo)), '=', ',') + '",' +
          '"totalFooding" : "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodging(EmpTravel, allType::Fooding, EmpTravel."Total No. of Days")), '=', ',') + '",' +
          '"totalLodging" :"' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodging(EmpTravel, allType::Lodging, EmpTravel."Total No. of Days")), '=', ',') + '",' +
          '"totalAdvance" : "' + DelChr(Format(TravelMgt.CalculateTotalAdvance(empTravelNo)), '=', ',') + '",' +
          '"totalTransport" : "' + DelChr(Format(TravelMgt.CalculateTotalTransport(empTravelNo)), '=', ',') + '",' +
          '"totalEstmiatedCost" : "' + DelChr(Format(TravelMgt.CalculateTotalEstimatedCost(empTravelNo)), '=', ',') + '",' +
          '"travelStartDate": "' + getDateinFormat(TravelMgt.GetTravelStartDate(empTravelNo)) + '",' +
          '"travelEndDate": "' + getDateinFormat(TravelMgt.GetTravelEndDate(empTravelNo)) + '",' +
          '"foodingPerDayLimit" : "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodingLimit(EmpTravel, allType::Fooding, true, 1)), '=', ',') + '",' +
          '"foodingLimit" : "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodingLimit(EmpTravel, allType::Fooding, false, EmpTravel."Total No. of Days")), '=', ',') + '",' +
          '"lodgingPerDayLimit" : "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodingLimit(EmpTravel, allType::Lodging, true, 1)), '=', ',') + '",' +
          '"lodgingLimit" : "' + DelChr(Format(TravelMgt.GetAllowanceFoodingLodingLimit(EmpTravel, allType::Lodging, false, EmpTravel."Total No. of Days")), '=', ',') + '",' +
          '"depatureTime": "' + Hrmgt.getTimeinFormat(TravelMgt.GetDepatureTime(empTravelNo)) + '",' +
          '"arrivalTime" : "' + Hrmgt.getTimeinFormat(TravelMgt.GetArrivalTime(empTravelNo)) + '"' +
        '}'
        )
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

    local procedure "Loan API"()
    begin

    end;

    [ServiceEnabled]
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
    //[Scope('Personalization')]
    procedure sendEmploanSalAdvForApproval(empLoanNo: Code[20]; isApproved: Boolean)
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
    begin
        EmpSalaryAdv.Get(empLoanNo);
        LoanMgt.SendApprovaLoan(EmpSalaryAdv, isApproved);
    end;

    [ServiceEnabled]
    //[Scope('Personalization')]
    procedure approveEmpLoanSalAdv(empLoanNo: Code[20]; isApproved: Boolean; remark: Text; approverNo: Code[20])
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
        RecRef: RecordRef;
    begin
        EmpSalaryAdv.Get(empLoanNo);
        if isApproved then begin
            if EmpSalaryAdv."Approval Status" = EmpSalaryAdv."Approval Status"::"Pending" then
                EmpSalaryAdv.Validate("Recommendation Remarks", remark);
        end else begin
            if remark = '' then
                Error('Rejection Remarks is Empty');
            EmpSalaryAdv.Validate("Rejection Remark", remark);
        end;
        EmpSalaryAdv.Modify;
        RecRef.GetTable(EmpSalaryAdv);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
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
    procedure returnAttachmentBase64(docNo: Code[20]; entryNo: Integer): Text
    var
        IncomingDoc: Record "Incoming Document";
        FilePath: Text;
        FileName: text;
        File: File;
        FileMgt: Codeunit "File Management";
        Base64: Codeunit "Base64 Convert";
        IncomingDocAttachment: Record "Incoming Document Attachment";
        instream: InStream;
        Extension: text;
        LargeText: text;
    begin
        IncomingDoc.Reset;
        if docNo <> '' then
            IncomingDoc.SetRange("No.", docNo);
        IncomingDoc.SetRange("Entry No.", entryNo);
        if IncomingDoc.FindFirst then begin
            IncomingDocAttachment.Reset();
            IncomingDocAttachment.SetRange("Incoming Document Entry No.", entryNo);
            if IncomingDocAttachment.FindFirst() then begin
                Extension := IncomingDocAttachment."File Extension";
                IncomingDocAttachment.CalcFields(Content);
                IncomingDocAttachment.Content.CreateInStream(instream, TextEncoding::UTF8);
                LargeText := Base64.ToBase64(instream, false);
                exit('{' + '"extension": "' + Extension + '",' + '"attachBase64":"' + LargeText + '"}');
            end;
        end;
    end;

    [ServiceEnabled]
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
    procedure uploadAttachment(docNo: Code[20]; entryNo: Integer; fname: Text; ext: Text): Text
    var
        IncomingDoc, IncomingDoc1 : Record "Incoming Document";
        IncomingDocAttachment: Record "Incoming Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        DocFoundEmpActivity, DocFoundEmpLoan, DocFoundEmpLeave, DocFoundInsurance : Boolean;
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        Leave: record leave;
        LoanType: Enum "Loan Type";
        ActivityType: Enum "Employee Activity Type";
        EmpInsurance: Record "Employee Insurance Information";
        AppraisalDocFound: Boolean;
        AppraisalEmp: Record Appraisal;
        base64: Codeunit "Base64 Convert";
        Outstream: OutStream;
        instream: InStream;
        CleanedFileName: text;
        AttachmentMgt: Codeunit "Attachment Mgt.";
    begin
        IncomingDoc.Get(entryNo);
        if IncomingDoc."File Name" <> '' then
            Error('File already exist. Please remove the file first.');
        DocFoundEmpActivity := false;
        DocFoundEmpLoan := false;
        AppraisalDocFound := false;
        DocFoundEmpLeave := false; //Min
        if EmployeeLoanAdvance.Get(IncomingDoc."No.") then begin
            DocFoundEmpLoan := true;
            LoanType := EmployeeLoanAdvance."Loan Type";
            if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Pending, EmployeeLoanAdvance."Approval Status"::Approved])
               and (IncomingDoc."File Name" <> '') then
                Error('Attachment already exist.');
        end;

        if not DocFoundEmpLoan then begin
            if EmployeeLoanAdvance.Get(IncomingDoc."No.") then begin
                DocFoundEmpActivity := true;
                // ActivityType := EmployeeLoanAdvance.Type;
                if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Pending, EmployeeLoanAdvance."Approval Status"::Approved])
                 and (IncomingDoc."File Name" <> '') then
                    Error('Attachment already exist.');
            end;
        end;
        if not (DocFoundEmpActivity or DocFoundEmpLoan) then begin
            if EmpInsurance.Get(IncomingDoc."No.") then begin
                DocFoundInsurance := true;
                if EmpInsurance."Approval Status" = EmpInsurance."Approval Status"::Approved then
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
                    if (Leave."Approval Status" in [Leave."Approval Status"::open, Leave."Approval Status"::Approved])
                     and (IncomingDoc."File Name" <> '') then
                        Error('Attachment already exist.');
                end;
            end;
        end;
        CleanedFileName := AttachmentMgt.SanitizeFileName(FORMAT(IncomingDoc."Entry No.") + '_' + IncomingDoc."No." + '.' + ext);
        tempblob.CreateOutStream(outStream);
        base64.FromBase64(fname, Outstream);
        TempBlob.CreateInStream(InStream); // Get the data back from TempBlob
        IncomingDoc.AddAttachmentFromStream(IncomingDocAttachment, CleanedFileName, ext, instream);
        Commit();
        IncomingDoc1.get(entryNo);
        IncomingDoc1."File Name" := CleanedFileName;
        IncomingDoc1.MODIFY;
    end;

    [ServiceEnabled]
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
            if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Pending, EmployeeLoanAdvance."Approval Status"::Approved])
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
            end;
        end;
        if not (DocFoundEmpActivity or DocFoundEmpLoan) then begin
            if EmpInsurance.Get(IncomingDocument."No.") then begin
                if EmpInsurance."Approval Status" = EmpInsurance."Approval Status"::Approved then
                    Error('Cannot delete screened document.');
            end;
        end;
        AttachmentMgt.DeleteAttachment(IncomingDocument);
        IncomingDocument."File Name" := '';
        IncomingDocument.Modify;
    end;

    local procedure "Allowance Assignment API"()
    begin
    end;

    [ServiceEnabled]
    procedure substituteAllowanceAssignment(entryNo: Code[20]; lineNo: Integer; fromDate: Date; empCode: Code[20]): Text
    var
        AllowanceLine, NewAllowanceLine : Record "Allowance Assignment Line";
        AllowanceAssignmentMgt: Codeunit "Allowance Assignment Mgt";
    begin
        AllowanceLine.Get(entryNo, lineNo);
        If AllowanceLine."Substitute Type" <> AllowanceLine."Substitute Type"::" " then
            Error('This Document is already Substituted');
        AllowanceLine.TestField("Approval Status", AllowanceLine."Approval Status"::Approved);
        NewAllowanceLine.Reset;
        NewAllowanceLine.SetRange("No.", AllowanceLine."No.");
        NewAllowanceLine.SetRange("Substitute of Line No.", AllowanceLine."Line No.");
        NewAllowanceLine.SetRange("Substitute Type", NewAllowanceLine."Substitute Type"::"Added as Substitute");
        NewAllowanceLine.SetRange("Employee Code", '');
        if not NewAllowanceLine.FindFirst then begin
            NewAllowanceLine.Reset;
            NewAllowanceLine.Init;
            NewAllowanceLine."No." := AllowanceLine."No.";
            NewAllowanceLine."Substitute Type" := NewAllowanceLine."Substitute Type"::"Added as Substitute";
            NewAllowanceLine."Substitute of Line No." := AllowanceLine."Line No.";
            NewAllowanceLine."Allowance Type" := AllowanceLine."Allowance Type";
            NewAllowanceLine.Type := AllowanceLine.Type;
            NewAllowanceLine.Code := AllowanceLine.code;
            NewAllowanceLine.Panel := AllowanceLine.Panel;
            NewAllowanceLine.Validate("Employee Code", empCode);
            NewAllowanceLine.Validate("To Date", fromDate);
            NewAllowanceLine.Validate("From Date", fromDate);
            NewAllowanceLine."Approval Status" := NewAllowanceLine."Approval Status"::"Pending";
            AllowanceAssignmentMgt.GetLineNo(NewAllowanceLine);
            NewAllowanceLine.Insert();
        end;
        AllowanceAssignmentMgt.InsertAllowanceAssignmentDayInAttendance(NewAllowanceLine);
        AllowanceAssignmentMgt.RemoveAllowanceAssignmentDayInAttendance(AllowanceLine."No.", AllowanceLine."Line No.");
        AllowanceLine."Substitute Type" := AllowanceLine."Substitute Type"::Substituted;
        AllowanceLine.Modify();
    end;

    [ServiceEnabled]
    procedure createAllowanceClaim()
    var
    begin
        AllowanceMgt.OpenAllowanceClaimRequest(HrMgt.GetEmployeeNo());
    end;

    [ServiceEnabled]
    procedure rejectAllowanceClaim(allowanceAssignNo: Code[20]; lineNo: Integer)
    var
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        ApproverHrms: Record "Approval HRMS";
    begin
        AllowanceAssignmentLine.Get(allowanceAssignNo, LineNo);
        ApproverHrms.Reset();
        ApproverHrms.SetRange("Document No.", allowanceAssignNo);
        ApproverHrms.SetRange("Approval Status", ApproverHrms."Approval Status"::Open);
        ApproverHrms.FindFirst();
        if ApproverHrms."Approver No" = HrMgt.GetEmployeeNo() then begin
            AllowanceAssignmentLine.TestField("Approval Status", AllowanceAssignmentLine."Approval Status"::"Pending");
            AllowanceAssignmentLine.Validate("Approval Status", AllowanceAssignmentLine."Approval Status"::Rejected);
            AllowanceAssignmentLine.Modify();
        end
        else
            Error('You are not allowed To reject.');
    end;

    [ServiceEnabled]
    procedure sendAllowanceForApproval(no: Code[20])
    var
        AllowanceLine: Record "Allowance Assignment Line";
        AllowanceHead: Record "Allowance Assignment Header";
    begin
        AllowanceHead.Get(No);
        AllowanceLine.Reset;
        AllowanceLine.SetRange("No.", No);
        AllowanceMgt.SendApprovalAllowanceAssignment(AllowanceHead, AllowanceLine);
    end;

    [ServiceEnabled]
    procedure insertAllowanceInRange(documentNo: Code[20]; allowanceType: Code[20]; panel: Text; employeeNo: Code[20]; fromDate: date; toDate: date)
    var
        PanelENum: Enum Panel;
    begin
        if panel <> '' then
            PanelEnum := Enum::Panel.FromInteger(PanelENum.Ordinals.Get(PanelENum.Names.IndexOf(panel)));
        AllowanceMgt.InsertAllowanceLine(DocumentNo, AllowanceType, PanelENum, EmployeeNo, FromDate, ToDate);
    end;


    [ServiceEnabled]
    procedure approveAllowanceAssignment(allowanceAssignNo: Code[20]; rejectionRemarks: text; isApproved: Boolean)
    var
        AllowanceAssignment: Record "Allowance Assignment Header";
        RecRef: RecordRef;
    begin
        if AllowanceAssignment.Get(allowanceAssignNo) then
            if not isApproved then begin
                if rejectionRemarks = '' then
                    Error('Rejection Remarks is empty');
                AllowanceAssignment.Validate("Rejection Remarks", rejectionRemarks);
                if AllowanceAssignment."Activity Type" = AllowanceAssignment."Activity Type"::"Allowance Assignment" then
                    AllowanceAssignment.Return := true;
                AllowanceAssignment.Modify;
            end;
        RecRef.GetTable(AllowanceAssignment);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
    end;

    [ServiceEnabled]
    procedure downloadAllowanceAssignmentSummary(documentNo: Code[20]): Text
    var
        AllowanceAssignmentReport: Report "Allowance Assignment Summary";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStream: InStream;
        Base64: Codeunit "Base64 Convert";
        ext, exitText : Text;
        format: ReportFormat;
        RecRef: RecordRef;
        AllowaceAssignmentHeader: Record "Allowance Assignment Header";
    begin
        ext := 'pdf';
        AllowaceAssignmentHeader.Get(DocumentNo);
        if (ApprovalMgt.CheckApproverBoolean(documentNo)) or (AllowaceAssignmentHeader."Employee No." = HrMgt.GetEmployeeNo()) then begin
            AllowanceAssignmentReport.PassParPortal(documentNo);
            TempBlob.CreateOutStream(OutStr);
            recRef.Get(AllowaceAssignmentHeader.RecordId);
            recRef.SetTable(AllowaceAssignmentHeader);
            AllowanceAssignmentReport.SaveAs('', format::Pdf, OutStr, recRef);
            TempBlob.CreateInStream(instream);
            exitText := base64.ToBase64(InStream);
            exit('{"extension":"' + ext + '","attachBase64":"' + exitText + '"}');
        end;
        exit('401')
    end;

    [ServiceEnabled]
    procedure checkAllowanceApproval(branchExtensionCode: Code[20]; empCode: Code[20])
    var
        FunctionalTitle: Record "Functional Title";
    begin
        Employee.Get(empCode);
        if (branchExtensionCode = Employee."Global Dimension 1 Code") or (branchExtensionCode = Employee."Extension Counter Code") then begin
            Employee.TestField("Functional Title");
            FunctionalTitle.Get(Employee."Functional Title");
            if not FunctionalTitle."Allow AllowanceAssignment" then
                Error('Employee not eligible for approva');
        end else
            Error('Employee not eligible for approval');
    end;

    local procedure "------Resignation API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure submitResignation(proposedDateOfResignation: Date; reasonCode: Code[20]; reasonForResignation: text; applyForWaiver: Boolean): Integer
    var
        Resignation: Record Resignation temporary;
        ResignationMgt: codeUnit "Resignation Mgt";
    begin
        Resignation.Reset;
        Resignation.Init;
        Resignation.Validate("Employee No.", HrMgt.GetEmployeeNo());
        Resignation.Validate(Type, Resignation.Type::Resignation);
        Resignation.Validate("Requested Date", Today);
        Resignation.Validate("Proposed Date of Resignation", proposedDateOfResignation); //Min 11.29.2022
        Resignation.Validate("Reason Code", reasonCode);
        Resignation.Validate("Reason for Resignation", reasonForResignation);
        // Resignation.Validate("Recommender Code", recommenderCode);
        Resignation.Validate("Apply for Waiver", applyForWaiver);
        Resignation.Insert;
        if ResignationMgt.SendResignationApproval(Resignation) then
            exit(200);
    end;

    [ServiceEnabled]
    procedure approveResignationDoc(docNo: Code[20]; remarks: Text; isApproved: Boolean)
    var
        //EmpActivity: Record "Employee Activity";
        // Resignation: Record Resignation;
        DocumentApprover: Record "Document Approver";
    begin
        // Resignation.Get(docNo);
        //Resignation.TestField("Approval Status", Resignation."Approval Status"::Recommended);
        DocumentApprover.Reset;
        DocumentApprover.SetRange("Document No.", docNo);
        DocumentApprover.SetRange("Employee No.", HrMgt.GetEmployeeNo());
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
    //[Scope('Personalization')]
    procedure approveEmployeeResignation(empResignNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text)
    var
        //EmpActivity: Record "Employee Activity";
        Resignation: Record Resignation;
        RecRef: RecordRef;
    begin
        Resignation.Get(empResignNo);
        if not isApproved then begin
            if rejectionRemarks = '' then
                Error('Rejection Remarks is empty');
            Resignation.Validate("Rejection Remarks", rejectionRemarks);
            Resignation.Modify;
        end;
        RecRef.GetTable(Resignation);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
        // if Resignation.Type = Resignation.Type::Resignation then begin
        //     if isApproved then begin
        //         Resignation.Validate(Remarks, rejectionRemarks);
        //         Resignation.Modify;
        //         ResignationMgt.ApproveRejectResignationAPI(isApproved, Resignation, employeeNo);
        //     end else begin
        //         Resignation.Validate("Rejection Remarks", rejectionRemarks);
        //         Resignation.Modify;
        //         ResignationMgt.ApproveRejectResignationAPI(isApproved, Resignation, employeeNo);
        //     end;
        //     exit;
        // end;
    end;

    [ServiceEnabled]
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
    procedure submitOvertime(OTDate: Date; reasonforOT: Text; actualOTHrs: Decimal; morningOTHrs: Decimal; eveningOTHrs: Decimal; OTAmount: Decimal; overTimeClaimType: text; encashmentCode: Code[20]; totalOTHrs: Decimal): Integer
    var
        Overtime: Record OverTime temporary;
        OverTimeMgt: codeUnit "OverTime Mgt";
        OverTimeType: enum "Overtime Claim Type";
    begin
        OverTimeType := Enum::"Overtime Claim Type".FromInteger(OverTimeType.Ordinals.Get(OverTimeType.Names.IndexOf(OverTimeClaimType)));
        Employee.Get(HrMgt.GetEmployeeNo());
        Overtime.Reset;
        Overtime.Init;
        Overtime.Validate(Type, Overtime.Type::Overtime);
        Overtime.Validate("Employee No.", HrMgt.GetEmployeeNo());
        Overtime.Validate("Start Date", OTDate);
        Overtime.Validate("Encashment Code", encashmentCode); //Min 11.29.2022
        Overtime.Validate("Overtime Claim Type", OverTimeType);
        Overtime.Validate("Total OT Hours", totalOTHrs);
        Overtime.Validate("Actual OT Hours", actualOTHrs);
        Overtime.Validate("Morning OT Hours", morningOThrs);
        Overtime.Validate("Evening OT Hours", eveningOTHrs);
        Overtime.Validate("OT Amount", OTAmount);
        Overtime.Validate("Requested Date", Today);
        Overtime.Validate(Remarks, reasonforOT);
        Overtime.Insert;
        if OverTimeMgt.ApplyForOverTimeApprovalForms(Overtime) then
            exit(200);
    end;

    [ServiceEnabled]
    procedure employeeOverTimeLine(OverTimeNo: Code[20])
    var
        OverTime: Record OverTime;
    begin
        OverTime.Get(OverTimeNo);
        OverTimeMgt.GetEmployee(OverTime);
    end;

    [ServiceEnabled]
    procedure employeeOverTimeAmount(OverTimeNo: Code[20])
    begin
        OverTimeMgt.GetOvertimeLineDetails(OverTimeNo);
    end;

    [ServiceEnabled]
    procedure sendOvertimeLineApproval(OvertimeNo: Code[20])
    var
        OverTime: Record OverTime;
        OverTimeLine: Record "Overtime Line";
    begin
        OverTime.Get(OvertimeNo);
        OverTimeLine.Reset;
        OverTimeLine.SetRange("No.", OvertimeNo);
        OverTimeMgt.SendApprovalOvertimeBulk(OverTime, OverTimeLine);
    end;

    [ServiceEnabled]
    procedure approveEmployeeOverTime(empOverTimeNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text)
    var
        OverTime: Record OverTime;
        RecRef: RecordRef;
    begin
        OverTime.Get(empOverTimeNo);
        if not isApproved then begin
            if rejectionRemarks = '' then
                Error('Rejection Remarks is empty');
            OverTime.Validate("Rejection Remarks", rejectionRemarks);
            if OverTime.Type = OverTime.Type::"Overtime Bulk" then
                OverTime.Return := true;
            OverTime.Modify;
        end;
        RecRef.GetTable(OverTime);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);

    end;

    [ServiceEnabled]
    procedure checkOverTimedetails(overTimeDate: date; encashmentCode: Code[20]): text
    var
        WorkShift: Record "Employee Work Shift";
        StartTime: Time;
        EndTime: Time;
        StandardWorkingHrs: Decimal;
        ActualOTHrs: Decimal;
        RejectionRemarks: Text;
        MorningOTHrs: Decimal;
        EveningOTHrs: Decimal;
        TotalOTHrs: Decimal;
        CheckInDifference: Decimal;
        EmployeeAttendance: Record "Employee Attendance & Activity";
        OTAmount: Decimal;
    begin
        if overTimeDate >= Today then
            Error('You cannot apply OverTime in current and future date.');
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
        OTAmount := 0;
        StandardWorkingHrs := 0;
        StartTime := WorkShift."Start Time";
        if HRMgt.IsWinter(overTimeDate, Workshift) then begin
            if HRMgt.IsFriday(overTimeDate) then
                EndTime := WorkShift."Friday End Time"
            else
                EndTime := WorkShift."Winter End Time";
        end else begin
            if HRMgt.IsFriday(overTimeDate) then
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
        EmployeeAttendance.Reset;

        if EmployeeAttendance.get(HrMgt.GetEmployeeNo(), overTimeDate) then begin
            if (EmployeeAttendance."Check In Time" = 0T) or (EmployeeAttendance."Check Out Time" = 0T) then begin
                Error('Check in or Check out not found.');
            end;
            if LeaveMgt.GetNonWorkingDays(overTimeDate, overTimeDate, HrMgt.GetEmployeeNo()) = 0 then begin
                // if AttendanceLog."Check Out Time" >= EndTime then begin
                if (EmployeeAttendance."Check Out Time" - EmployeeAttendance."Check In Time") < StandardWorkingHrs then begin
                    Error(StrSubstNo('Working hrs %1 hrs is less than Standard Working Hrs .', StandardWorkingHrs));
                end;
                if (EmployeeAttendance."Check In Time" <> 0T) and (EmployeeAttendance."Check In Time" <= StartTime) then
                    MorningOTHrs := Round((StartTime - EmployeeAttendance."Check In Time") / 3600000, 1, '<');

                if MorningOTHrs < HRSetup."OT eligible hour" then
                    MorningOTHrs := 0;

                if (EmployeeAttendance."Check Out Time" <> 0T) and (EmployeeAttendance."Check Out Time" > EndTime) then
                    EveningOTHrs := Round((EmployeeAttendance."Check Out Time" - EndTime) / 3600000, 1, '<');

                if EmployeeAttendance."Check In Time" > StartTime then begin
                    CheckInDifference := Round((EmployeeAttendance."Check In Time" - StartTime) / 3600000, 1, '<');
                    EveningOTHrs -= CheckInDifference;
                end;
                if EveningOTHrs < HRSetup."OT eligible hour" then
                    EveningOTHrs := 0;
                TotalOTHrs := MorningOTHrs + EveningOTHrs;

            end else begin
                TotalOTHrs := Round((EmployeeAttendance."Check Out Time" - EmployeeAttendance."Check In Time") / 3600000, 1, '<');
                if TotalOTHrs < HRSetup."OT eligible hour" then
                    Error('Total OT hour %1 is less than OT eligible hour %2"', TotalOTHrs, HRSetup."OT eligible hour");
            end;
        end else
            Error('Attendance Log not found.');
        if TotalOTHrs <> 0 then
            OTAmount := OverTimeMgt.OTAmountCalculate(HrMgt.GetEmployeeNo(), overTimeDate, encashmentCode, TotalOTHrs);
        exit(
       '{' +
         '"totalOTHrs" : "' + DelChr(Format(TotalOTHrs)) + '",' +
         '"checkInTime" : "' + DelChr(Hrmgt.getTimeinFormat(EmployeeAttendance."Check In Time"), '=', ',') + '",' +
         '"checkOutTime" : "' + delchr(Hrmgt.getTimeinFormat(EmployeeAttendance."Check Out Time"), '=', ',') + '",' +
         '"MorningOTHrs" : "' + DelChr(Format(MorningOTHrs)) + '",' +
         '"EveningOTHrs" : "' + Format(EveningOTHrs) + '",' +
         '"OTAmount" : "' + DelChr(Format(OTAmount), '=', '{}') + '"}');
    end;

    local procedure "---Appointment API----"()
    begin
    end;


    [ServiceEnabled]
    procedure approveSelectionCommittee(vacancyNo: Code[20])
    begin
        HrMgt.SelectionCommitteeApproval(vacancyNo);
    end;

    [ServiceEnabled]
    procedure generateInterviewEntries(vacancyCode: Code[20]; candidateCode: Code[20]; employeeCode: Code[20])
    begin
        HrMgt.GenerateInterviewerEntriesAPI(vacancyCode, candidateCode, employeeCode);
    end;

    [ServiceEnabled]
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
        // CreateNewDir(HRSetup."Feedback Attach. Location", '', DirectoryName);
        DirectoryName += '\';
        FileName := FileManagement.GetDirectoryName(DirectoryName) + '\' + fname + '.' + ext;
        base64.FromBase64(basestring);
        tempInstream.Read(base64);
        FileManagement.BLOBExport(TempBlob, FileName, false);
        exit(FileName);
    end;

    [ServiceEnabled]
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

    local procedure "------Transfer API---------"()
    begin

    end;

    [ServiceEnabled]
    procedure submitTransferRequest(
    "proposedTransferDate": Date;
    "reasonForTransfer": text;
    "description": text;
    "requestedProvince": text): Integer;
    var
        TransferRequest: Record "Employee Transfer" temporary;
    begin
        TransferRequest.Reset;
        TransferRequest.Init;
        TransferRequest.Validate(Type, TransferRequest.Type::"Employee Transfer");
        TransferRequest.Validate("Employee No.", HrMgt.GetEmployeeNo());
        TransferRequest.Validate("Transfer Propose Date", ProposedTransferDate);
        TransferRequest.Validate(Description, description);
        TransferRequest.Validate("Reason for Transfer", reasonForTransfer);
        TransferRequest.Validate("Requested Province", requestedProvince);
        TransferRequest.Insert;
        if TransferMgt.SendTransferApproval(TransferRequest) then
            exit(200);
    end;


    [ServiceEnabled]
    procedure approveRejectTransfer(empActivityNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text)
    var
        EmpHrTransfer: Record "Employee Transfer";
        RecRef: RecordRef;
    begin
        EmpHrTransfer.Get(empActivityNo);
        if not isApproved then begin
            if rejectionRemarks = '' then
                Error('Rejection Remarks is empty');
            EmpHrTransfer.Validate("Rejection Remarks", rejectionRemarks);
            EmpHrTransfer.Modify;
        end;
        RecRef.GetTable(EmpHrTransfer);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
    end;

    [ServiceEnabled]
    procedure ackonwledgeTransfer(empActivityNo: Code[20]; dateOfJoining: Date; transferRemarks: Text)
    var
        EmployeeTransfer: Record "Employee Transfer";
        TransferMgt: Codeunit "Transfer Mgt.";
    begin
        EmployeeTransfer.Get(empActivityNo);
        EmployeeTransfer.Validate("Date of Joining Of Transfer", dateOfJoining);
        EmployeeTransfer."Transfer Remarks" := transferRemarks;
        TransferMgt.AcknowledgeTransfer(EmployeeTransfer);
    end;

    [ServiceEnabled]
    procedure handoverTransfer(empActivityNo: Code[20])
    var
        EmployeeTransfer: Record "Employee Transfer";
        TransferMgt: Codeunit "Transfer Mgt.";
    begin
        EmployeeTransfer.Get(empActivityNo);
        TransferMgt.HandoverApprove(EmployeeTransfer);
    end;

    [ServiceEnabled]
    procedure takeoverTransfer(empActivityNo: Code[20])
    var
        EmployeeTransfer: Record "Employee Transfer";
        TransferMgt: Codeunit "Transfer Mgt.";
    begin
        EmployeeTransfer.Get(empActivityNo);
        TransferMgt.TakeoverApprove(EmployeeTransfer);
    end;

    [ServiceEnabled]
    procedure RequestTransferClaim(empActivityNo: Code[20]; relocationDistance: Decimal; BMAFDistance: Decimal; outstationDistance: Decimal)
    var
        BMandOutStationError: Label 'You cannot apply for both BM Accomodation Allowance and Outstation/Discomfort Allowance.';
        UnauthorizedApprover: Label 'You are not authorized to approve.';
        EmployeeTransfer1: Record "Employee Transfer";
        EmployeeTransfer: Record "Employee Transfer";
        TransferMgt: Codeunit "Transfer Mgt.";
    begin
        EmployeeTransfer1.Get(empActivityNo);
        EmployeeTransfer1.TestField("Approval Status", EmployeeTransfer1."Approval Status"::Acknowledged);
        EmployeeTransfer1."Transfer Claim" := true;
        EmployeeTransfer1.Modify();
        EmployeeTransfer.Init;
        EmployeeTransfer.TransferFields(EmployeeTransfer1);
        EmployeeTransfer."No." := '';
        EmployeeTransfer.Status := '';
        EmployeeTransfer."Approved Date" := 0D;
        EmployeeTransfer.Validate("Transfer Request No", EmployeeTransfer1."No.");
        EmployeeTransfer.Validate(Type, EmployeeTransfer.Type::"Transfer Claim");
        EmployeeTransfer.Validate("Approval Status", EmployeeTransfer."Approval Status"::Pending);
        EmployeeTransfer.Validate("Requested Date", Today);
        EmployeeTransfer.Insert(true);
        EmployeeTransfer.Validate("Relocation Distance", relocationDistance);
        EmployeeTransfer.Validate("BMAF Distance", BMAFDistance);
        EmployeeTransfer.Validate("Outstation Distance", outstationDistance);
        if (EmployeeTransfer."Outstation/Discomfort Allow." <> 0) and (EmployeeTransfer."BM Accomodation Allow." <> 0) then
            Error(BMandOutStationError)
    end;

    local procedure "------Employee Edit API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure employeeEditAttachment(employeeEditNo: Code[20]): Text;
    var
        EmployeeEdit: Record "Employee Edit";
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
        ext: text;
    begin

        if EmployeeEdit.Get(employeeEditNo) then
            if EmployeeEdit.Attachment.HasValue then begin
                if ItemTenantMedia.Get(EmployeeEdit.Attachment.MediaId) then begin
                    ext := FileManagement.GetExtension(ItemTenantMedia.Description);
                    ItemTenantMedia.CalcFields(Content);
                    TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                    TempBlob.CreateInStream(InStr);
                    exit('{' + '"extension" : "' + ext + '",' +
                         '"attachBase64" : "' + base64.ToBase64(InStr) + '"}');
                end;
            end;
    end;

    [ServiceEnabled]
    procedure approveRejectEmployeeEdit(employeeEditNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text)
    var
        RecRef: RecordRef;
        EmployeeEdit: Record "Employee Edit";
    begin
        EmployeeEdit.Get(EmployeeEditNo);
        if not isApproved then begin
            if rejectionRemarks = '' then
                Error('Rejection Remarks is empty');
            EmployeeEdit.Validate("Rejection Remarks", rejectionRemarks);
            EmployeeEdit.Modify;
        end;
        RecRef.GetTable(EmployeeEdit);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
    end;

    local procedure "------Payroll API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure downloadPaySlip(year: Integer; month: Text): Text
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
        Employee.Get(HrMgt.GetEmployeeNo());
        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange("Nepali Year", year);
        PostedPayrollHeader.SetFilter("Nepali Month", month);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
        // if Employee."Employment Type" = Employee."Employment Type"::Contract then
        //     PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Contract)
        // else
        //     PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Permanent);
        PostedPayrollHeader.SetFilter("Employee Type", '%1|%2', PostedPayrollHeader."Employee Type"::" ", Employee."Employment Type");
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
            Format(MonthOption::Shrawan):
                begin
                    PaySlip.PassParPortal(Employee."No.", year, MonthOption::Shrawan);
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
    procedure downloadTaxDeductionInfoReport(year: Integer; month: Text) exitText: Text
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
        EmployeeNo: Code[20];
    begin
        HRSetup.Get();
        EmployeeNo := HrMgt.GetEmployeeNo();
        Employee.get(EmployeeNo);
        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange("Nepali Year", year);
        PostedPayrollHeader.SetFilter("Nepali Month", month);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
        // if Employee."Employment Type" = Employee."Employment Type"::Contract then
        //     PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Contract)
        // else
        //     PostedPayrollHeader.SetRange("Employee Type", PostedPayrollHeader."Employee Type"::Permanent);
        PostedPayrollHeader.SetFilter("Employee Type", '%1|%2', PostedPayrollHeader."Employee Type"::" ", Employee."Employment Type");

        PostedPayrollHeader.FindFirst;
        case month of
            Format(MonthOption::Baisakh):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Baisakh);
            Format(MonthOption::Jestha):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Jestha);
            Format(MonthOption::Asar):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Asar);
            Format(MonthOption::Shrawan):
                TaxDeductionInfo.PassParPortal(employeeNo, PostedPayrollHeader."No.", year, MonthOption::Shrawan);
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

    local procedure "------Appraisal API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure onValidateKRACategory(AppraisalCode: Code[20])
    var
        AppraisalRec: Record Appraisal;
    begin
        if AppraisalRec.Get(AppraisalCode) then begin
            AppraisalMgt.OnValidateKRACategory(AppraisalRec);
        end;
    end;

    [ServiceEnabled]
    procedure approveRejectAppraisal(appraisalCode: Code[20])
    var
        AppraisalRec: Record Appraisal;
    begin
        if AppraisalRec.Get(appraisalCode) then
            AppraisalMgt.ApproveRejectAppraisal(true, AppraisalRec);
    end;

    [ServiceEnabled]
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
    procedure recommendInternalCandidate(candidateCode: Code[20]; vacancyCode: Code[20]; remarksVar: Text; isApproved: Boolean)
    var
        CandidateVar: Record Candidate;
    begin
        CandidateVar.Get(candidateCode, vacancyCode);
        CandidateVar.Validate("Recommender Remarks", remarksVar);
        HrMgt.RecommendCandidate(CandidateVar, isApproved);
    end;

    [ServiceEnabled]
    procedure applyForPromotion(candidateCode: Code[20]; vacancyCode: Code[20]; recommenderCode: Code[20]; candidateRemarks: Text)
    var
        Candidate: Record Candidate;
    begin
        Candidate.Get(candidateCode, vacancyCode);
        Candidate.Validate("Recommender Code", recommenderCode);
        Candidate.Validate("Candidate Remarks", candidateRemarks);
        HrMgt.ApplyForPromoiton(Candidate);
    end;



    local procedure "------RetirementFund API---------"()
    begin
    end;

    [ServiceEnabled]
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
    //[Scope('Personalization')]
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

    // [ServiceEnabled]
    // procedure exitDeputationValue(): Text
    // begin
    //     Employee.Get(HrMgt.GetEmployeeNo);
    //     exit(ServiceHistoryMgt.ExitTransferDeputationWiseValue(Employee."Deputation on", Employee."No."));
    // end;

    [ServiceEnabled]
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
    procedure exitLumpSumpRF(): Boolean
    begin
        PGSetup.Get; //Min -- actual RF plan enable for portal
        if PGSetup."Enable RF Lumpsump Plan" then
            exit(true)
        else
            exit(false);
    end;

    [ServiceEnabled]
    procedure exitNepaliStartDate(engStartDate: Date): Text
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", engStartDate);
        if EngNepDate.FindFirst then
            Exit(EngNepDate."Nepali Date");
    end;

    [ServiceEnabled]
    procedure exitNepaliEndDate(engEndDate: Date): Text
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", engEndDate);
        if EngNepDate.FindFirst then
            Exit(EngNepDate."Nepali Date");
    end;

    [ServiceEnabled]
    procedure downloadSalarysheetDocMonthWise(year: Integer; month: Text) exitText: Text
    var
        SalarysheetDocMonthWise: Report "Salary Sheet Doc Portal";
        MonthOption: Enum "Nepali Month";
        FileName: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        PayCycleTerm: Code[20];
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
            Format(MonthOption::Shrawan):
                begin
                    SalarysheetDocMonthWise.PassParHrmsPortal(Employee."No.", PayCycleTerm, MonthOption::Shrawan);
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

    local procedure "------Promotion API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure modifyprobempscore(appcode: Code[20])
    var
        KPIMgt: Codeunit "KPI Mgt.";
    begin
        KPIMgt.calculatefinalscoreforprobatation(appcode);//Min -- For Exit Current fiscal year (Extra Milage Module)
    end;

    [ServiceEnabled]
    procedure checkIfTargetExceeds(empcode: Code[20]; kpicode: Code[20]; startdate: Date; enddate: Date)
    var
        KPIMgt: Codeunit "KPI Mgt.";
    begin
        KPIMgt.checkIfTargetExceeds(empcode, kpicode, startdate, enddate)//Min -- For Exit Current fiscal year (Extra Milage Module)
    end;

    local procedure "------DashBoard API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure countForDashBoard(): text
    var
        leaveForApprove: Integer;
        PersonalLoanForApprove: Integer;
        VehicleLoanForApprove: Integer;
        HomeLoanForApprove: Integer;
        TravelReqForApprove: Integer;
        TravelClaimApprove: Integer;
        ResignForApprove: Integer;
        OverTimeForApprove: Integer;
        Appraisal: Record Appraisal;
        AppraisalForRecommendation: Integer;
        AppraisalForApprove: Integer;
        TotalCount: Integer;
        SalaryAdvanceForApprove: Integer;
        AttendanceMissedForApprove: Integer;
        EmployeeTransferForApprove: Integer;
        TransferAcknowledgeForApprove: Integer;
        TransferHandoverForApprove: Integer;
        TransferClaimForApprove: Integer;
        EmployeeTransfer: Record "Employee Transfer";
        DocumentApprover: Record "Document Approver";
        ResignClearanceForApprove: Integer;
        EmployeeEditForApprove: Integer;
        AllowanceAssignment: Record "Allowance Assignment Header";
        AllowanceAssignmentForApprove: Integer;
        LeaveCancelledForApprove: Integer;
        LateAttendanceForApprove: Integer;
        InsuranceForApprove: Integer;
        MedicalInsuranceClaimForApprove: Integer;
        OvertimeBulkForApprove: Integer;
        AllowanceAssignmentClaimForApprove: Integer;
        ShiftAssignmentForApprove: Integer;
        Approval: Record "Approval HRMS";
        RetirementFundForApprove: Integer;
    begin
        Clear(leaveForApprove);
        Clear(TravelReqForApprove);
        Clear(TravelClaimApprove);
        Clear(PersonalLoanForApprove);
        Clear(HomeLoanForApprove);
        Clear(SalaryAdvanceForApprove);
        Clear(VehicleLoanForApprove);
        Clear(AttendanceMissedForApprove);
        Clear(ResignClearanceForApprove);
        Clear(EmployeeEditForApprove);
        Clear(LeaveCancelledForApprove);
        Clear(OvertimeBulkForApprove);
        Clear(ShiftAssignmentForApprove);

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Leave Request");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetRange(Cancelled, false);
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        leaveForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Leave Request");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetRange(Cancelled, true);
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        LeaveCancelledForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Travel Request");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        TravelReqForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Travel Claim");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        TravelClaimApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::Loan);
        Approval.SetRange("Loan Type", Approval."Loan Type"::"Personal Loan");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        PersonalLoanForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::Loan);
        Approval.SetRange("Loan Type", Approval."Loan Type"::"Home Loan");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        HomeLoanForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::Loan);
        Approval.SetRange("Loan Type", Approval."Loan Type"::"Vehicle Loan");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        VehicleLoanForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::Loan);
        Approval.SetRange("Loan Type", Approval."Loan Type"::"Salary Advance");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        SalaryAdvanceForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Attendance Missed");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        AttendanceMissedForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Employee Transfer");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        EmployeeTransferForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::Overtime);
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        OverTimeForApprove := Approval.Count();

        EmployeeTransfer.Reset();
        EmployeeTransfer.SetRange("Outgoing Branch Rep. Person", HrMgt.GetEmployeeNo());
        EmployeeTransfer.SetRange("Approval Status", EmployeeTransfer."Approval Status"::Approved);
        EmployeeTransfer.SetRange(Handover, true);
        EmployeeTransfer.SetRange(Takeover, false);
        TransferHandoverForApprove := EmployeeTransfer.Count();

        EmployeeTransfer.Reset();
        EmployeeTransfer.SetRange("Incoming Supervisior", HrMgt.GetEmployeeNo());
        EmployeeTransfer.SetRange("Approval Status", EmployeeTransfer."Approval Status"::Approved);
        EmployeeTransfer.SetRange(Takeover, true);
        TransferAcknowledgeForApprove := EmployeeTransfer.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Transfer Claim");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        TransferClaimForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::Resignation);
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        ResignForApprove := Approval.Count();

        DocumentApprover.Reset();
        DocumentApprover.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        DocumentApprover.SetRange("Document Type", DocumentApprover."Document Type"::Resignation);
        DocumentApprover.SetRange("Approval Status", DocumentApprover."Approval Status"::Open);
        ResignClearanceForApprove := DocumentApprover.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Employee Edit");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::Open);
        EmployeeEditForApprove := Approval.Count();

        Appraisal.Reset();
        Appraisal.SetRange("Approver Code", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Appraisal.SetRange(Status, Appraisal."Status"::Reviewed);
        AppraisalForApprove := Appraisal.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Allowance Assignment");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Open");
        AllowanceAssignmentForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Allowance Assignment Claim");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Open");
        AllowanceAssignmentClaimForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Late Attendance");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Open");
        LateAttendanceForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::Insurance);
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Open");
        InsuranceForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Medical Insurance Claim");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Open");
        MedicalInsuranceClaimForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Overtime Bulk");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Open");
        OvertimeBulkForApprove := Approval.Count();

        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::"Shift Assignment");
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Open");
        ShiftAssignmentForApprove := Approval.Count();


        Approval.Reset();
        Approval.SetRange("Document Type", Approval."Document Type"::Retirement);
        Approval.SetRange("Approver No", HrMgt.GetEmployeeNo());
        Approval.SetFilter("Document No.", '<>%1', '');
        Approval.SetRange("Approval Status", Approval."Approval Status"::"Open");
        RetirementFundForApprove := Approval.Count();

        TotalCount := leaveForApprove + LeaveCancelledForApprove + PersonalLoanForApprove + VehicleLoanForApprove + HomeLoanForApprove + TravelReqForApprove + EmployeeTransferForApprove + AllowanceAssignmentForApprove + TransferAcknowledgeForApprove + TransferHandoverForApprove + TravelClaimApprove
          + ResignForApprove + ResignClearanceForApprove + OverTimeForApprove + EmployeeEditForApprove + AppraisalForRecommendation + AppraisalForApprove + SalaryAdvanceForApprove + AttendanceMissedForApprove + LateAttendanceForApprove + InsuranceForApprove + MedicalInsuranceClaimForApprove
          + TransferClaimForApprove + OvertimeBulkForApprove + AllowanceAssignmentClaimForApprove + ShiftAssignmentForApprove + RetirementFundForApprove;

        exit('{"leaveForApprove" : "' + Format(leaveForApprove) + '"' +
        ',"PersonalLoanForApprove": "' + format(PersonalLoanForApprove) + '"' +
        ',"HomeLoanForApprove": "' + format(HomeLoanForApprove) + '"' +
        ',"SalaryAdvanceForApprove": "' + format(SalaryAdvanceForApprove) + '"' +
        ',"VehicleLoanForApprove": "' + format(VehicleLoanForApprove) + '"' +
        ',"TravelReqForApprove": "' + format(TravelReqForApprove) + '"' +
        ',"TravelClaimApprove": "' + format(TravelClaimApprove) + '"' +
        ',"TransferClaimForApprove": "' + format(TransferClaimForApprove) + '"' +
        ',"ResignForApprove": "' + format(ResignForApprove) + '"' +
        ',"ResignClearanceForApprove": "' + format(ResignClearanceForApprove) + '"' +
        ',"OverTimeForApprove": "' + format(OverTimeForApprove) + '"' +
        ',"AppraisalForApprove": "' + format(AppraisalForApprove) + '"' +
        ',"EmployeeTransferForApprove": "' + format(EmployeeTransferForApprove) + '"' +
        ',"AttendanceMissedForApprove": "' + format(AttendanceMissedForApprove) + '"' +
        ',"TransferHandoverForApprove": "' + format(TransferHandoverForApprove) + '"' +
        ',"TransferAcknowledgeForApprove": "' + format(TransferAcknowledgeForApprove) + '"' +
        ',"EmployeeEditForApprove": "' + format(EmployeeEditForApprove) + '"' +
        ',"LeaveCancelledForApprove": "' + format(LeaveCancelledForApprove) + '"' +
        ',"AllowanceAssignmentForApprove": "' + format(AllowanceAssignmentForApprove) + '"' +
        ',"AllowanceAssignmentClaimForApprove": "' + format(AllowanceAssignmentClaimForApprove) + '"' +
        ',"LateAttendanceForApprove": "' + format(LateAttendanceForApprove) + '"' +
        ',"InsuranceForApprove": "' + format(InsuranceForApprove) + '"' +
        ',"MedicalInsuranceClaimForApprove": "' + format(MedicalInsuranceClaimForApprove) + '"' +
        ',"OvertimeBulkForApprove": "' + format(OvertimeBulkForApprove) + '"' +
        ',"ShiftAssignmentForApprove": "' + format(ShiftAssignmentForApprove) + '"' +
        ',"RetirementFundForApprove": "' + format(RetirementFundForApprove) + '"' +
        ',"TotalCount" :"' + DelChr(Format(TotalCount), '=', '{}') + '"}');
    end;

    [ServiceEnabled]
    procedure countEmployeeAttendance(): text
    var
        EmployeeAttendace: Record "Employee Attendance & Activity";
        AbsentDayCount: Integer;
        PresentDayCount: Integer;
        WeekOffDayCount: Integer;
        LeaveDayCount: Integer;
        TourDayCount: Integer;
        EnglishNepalidate: Record "English-Nepali Date";
        StartofYear: date;
        EmployeeNo: Code[20];
    begin
        Clear(StartofYear);
        Clear(AbsentDayCount);
        Clear(WeekOffDayCount);
        Clear(PresentDayCount);
        Clear(LeaveDayCount);
        EmployeeNo := HrMgt.GetEmployeeNo();
        EnglishNepalidate.Reset();
        EnglishNepalidate.SetRange("Fiscal Year", HrMgt.ReturnFiscalYear(Today));
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
    procedure employeeProfilePicture(empCode: Code[20]): text
    var
        Employee: Record Employee;
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
    begin
        Employee.Get(EmpCode);
        if Employee.Image.HasValue then begin
            if ItemTenantMedia.Get(Employee.Image.MediaId) then begin
                ItemTenantMedia.CalcFields(Content);
                TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                TempBlob.CreateInStream(InStr);
                exit(base64.ToBase64(InStr));
            end;
        end;
    end;

    local procedure "------Insurance and Medical API---------"()
    begin
    end;
    //API for Insurance and Medical Insurance Claim Approval --santosh 5/27/2025--
    [ServiceEnabled]
    procedure approveInsurance(empInsuranceNo: Code[20]; isApproved: Boolean; rejectionRemarks: Text; empActType: text)
    var
        EmployeeInsurance: Record "Employee Insurance Information";
        EmployeeMedicalInsurance: Record "Medical Insurance Claim";
        EmployeeActType: Enum "Employee Activity Type";
        RecRef: RecordRef;
    begin
        case empActType of
            Format(EmployeeActType::"Medical Insurance Claim"):
                begin
                    EmployeeMedicalInsurance.Get(empInsuranceNo);
                    if not isApproved then begin
                        if rejectionRemarks = '' then
                            Error('Rejection Remarks is empty');
                        EmployeeMedicalInsurance.Validate("Rejection Remarks", rejectionRemarks);
                        EmployeeMedicalInsurance.Modify;
                    end;
                    RecRef.GetTable(EmployeeMedicalInsurance);
                    ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
                end;
            Format(EmployeeActType::Insurance):
                begin
                    EmployeeInsurance.Get(empInsuranceNo);
                    if not isApproved then begin
                        if rejectionRemarks = '' then
                            Error('Rejection Remarks is empty');
                        EmployeeInsurance.Validate("Rejection Remarks", rejectionRemarks);
                        EmployeeInsurance.Modify;
                    end;
                    RecRef.GetTable(EmployeeInsurance);
                    ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
                end;
        end;
    end;

    local procedure "------Shift Assignment API---------"()
    begin
    end;

    [ServiceEnabled]
    procedure sendShiftLineApproval(ShiftNo: Code[20])
    var
        ShiftHeader: Record "Shift Assignment Header";
        ShiftLine: Record "Shift Line";
    begin
        ShiftHeader.Get(ShiftNo);
        ShiftLine.Reset;
        ShiftLine.SetRange("No.", ShiftNo);
        ShiftAssignmentMgt.SendApprovalShiftAssignment(ShiftHeader, ShiftLine);
    end;

    [ServiceEnabled]
    procedure insertShiftInRange(documentNo: Code[20]; employeeNo: Code[20]; employeeWorkShift: Code[20]; fromDate: date; toDate: date)
    begin
        ShiftAssignmentMgt.InsertShiftLine(DocumentNo, EmployeeNo, EmployeeWorkShift, FromDate, ToDate);
    end;

    [ServiceEnabled]
    procedure cancelRequest(documentNo: Code[20]; documentType: text)
    begin
        ApprovalMgt.CancelRequestAPI(documentNo, documentType);
    end;

    [ServiceEnabled]
    procedure approveShiftAssignment(shiftAssignNo: Code[20]; rejectionRemarks: text; isApproved: Boolean)
    var
        ShiftAssignment: Record "Shift Assignment Header";
        RecRef: RecordRef;
    begin
        if ShiftAssignment.Get(shiftAssignNo) then
            if not isApproved then begin
                if rejectionRemarks = '' then
                    Error('Rejection Remarks is empty');
                ShiftAssignment.Validate("Rejection Remarks", rejectionRemarks);
                if ShiftAssignment."Type" = ShiftAssignment."Type"::"Shift Assignment" then
                    ShiftAssignment.Return := true;
                ShiftAssignment.Modify;
            end;
        RecRef.GetTable(ShiftAssignment);
        ApprovalMgt.ApproveRejectDocument(RecRef, isApproved);
    end;

    [ServiceEnabled]
    procedure substituteShiftAssignment(entryNo: Code[20]; lineNo: Integer; remarks: Text; empCode: Code[20]): Text
    var
        ShiftLine, NewShiftLine : Record "Shift Line";
        ShiftAssignmentHeader: Record "Shift Assignment Header";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";
    begin
        ShiftAssignmentHeader.Get(EntryNo);
        if ShiftAssignmentHeader."Employee No." <> HrMgt.GetEmployeeNo() then
            Error('You are not authorized to substitute this Shift Line');
        ShiftLine.Get(entryNo, lineNo);
        If ShiftLine."Substitute Type" <> ShiftLine."Substitute Type"::" " then
            Error('This Document is already Substituted');
        ShiftLine.TestField("Approval Status", ShiftLine."Approval Status"::Approved);
        if ShiftLine."Employee No" = empCode then
            Error('You cannot substitute Same Employee');
        ShiftAssignmentMgt.SubstituteShiftLine(ShiftLine, empCode, Remarks);
    end;
}
