codeunit 50017 "Approver Mgt"
{
    // >> Fixed Field  ID used on ALL Table For RECRef >> Santosh 2025-03-04
    // >>RecRef.Field(1) = Document No.
    // >>RecRef.Field(2) = Document Type    
    // >>RecRef.Field(16) = Approval Status
    // >>RecRef.Field(37) = Approved Date
    // >>RecRef.Field(39) = Cancelled 
    // >>RecRef.Field(100) = Status 
    // >> warning: don't Change the Field ID on the Table>>
    // >> Insert Approval for Employee Activity from Approval Setup Line >> Santosh 2025-03-04 >>
    procedure InsertApproval(EmployeeNo: Code[20];
                                EmpActNo: Code[20];
                                EmpActType: enum "Employee Activity Type";
                                ApprovalStatus: Enum "Approval Status")

    var
        ApprovalSetupLine: Record "Approval Setup line";
        Approval: Record "Approval HRMS";
        Employee: Record Employee;
        EmpRequest: Record Employee;
        Approval1: Record "Approval HRMS";
        count: Integer;
    begin
        EmpRequest.Get(EmployeeNo);
        ApprovalSetupLine.Reset();
        ApprovalSetupLine.SetRange("Request Type", EmpActType);
        ApprovalSetupLine.SetFilter("Deputation On", '%1|%2', EmpRequest."Deputation on"::" ", EmpRequest."Deputation On");
        ApprovalSetupLine.SetRange("Employee Role", EmpRequest."Approver Role");
        count := 0;
        if ApprovalSetupLine.Findset() then
            repeat
                Employee.Reset();
                if ApprovalSetupLine."Deputation type" = ApprovalSetupLine."Deputation On" then begin
                    Employee.SetRange("Deputation On", EmpRequest."Deputation On");
                    if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Branch then
                        Employee.SetRange("Global Dimension 1 Code", EmpRequest."Global Dimension 1 Code")
                    else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Department then
                        Employee.SetRange("Department Code", EmpRequest."Department Code")
                    else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Province then
                        Employee.SetRange("Province Code", EmpRequest."Province Code");
                end else begin
                    if ApprovalSetupLine."Deputation Type" = ApprovalSetupLine."Deputation Type"::Province then
                        Employee.SetRange("Province Code", EmpRequest."Province Code");
                end;
                Employee.SetRange("Approver Role", ApprovalSetupLine."Approver Role");
                if Employee.FindFirst() then begin
                    Approval.Init();
                    Approval.Validate("Document No.", EmpActNo);
                    Approval.Validate("Document Type", EmpActType);
                    Approval.Validate("Approver No", Employee."No.");
                    Approval.Validate("Approval Sequence", ApprovalSetupLine."Approval Sequence");
                    Approval.Validate(Status, ApprovalSetupLine."Approval Status");
                    Approval.Validate("Approval Role", ApprovalSetupLine."Approval Role");
                    if ApprovalSetupLine."Approval Sequence" = 1 then begin
                        if ApprovalStatus = ApprovalStatus::Pending then
                            Approval.Validate("Approval Status", "Approval Status"::Open);
                        if ApprovalStatus = ApprovalStatus::Open then
                            Approval.Validate("Approval Status", "Approval Status"::Created);
                        count := count + 1;
                    end else
                        Approval.Validate("Approval Status", "Approval Status"::Created);
                    Approval.Validate("Employee No", EmployeeNo);
                    Approval.Insert(true);
                end;
            until ApprovalSetupLine.Next() = 0
        else
            Error('Approval Setup not found');
        if count = 0 then begin
            Error('There is no approver setup for sequence 1');
        end;
        Approval1.Reset();
        Approval1.SetRange("Document No.", EmpActNo);
        if not Approval1.FindFirst() then
            Error('Approval Not Found');
    end;

    // >> Insert Approval for Loan >> Santosh 2025-03-04 >>
    procedure InsertApprovalLoan(EmployeeNo: Code[20];
                                    EmpActNo: Code[20];
                                    EmpActType: enum "Employee Activity Type";
        LoanType: Enum "Loan Type")
    var
        ApprovalSetupLine: Record "Approval Setup line";
        Approval: Record "Approval HRMS";
        Employee: Record Employee;
        EmpRequest: Record Employee;
        Approval1: Record "Approval HRMS";
        count: Integer;
    begin
        EmpRequest.Reset();
        EmpRequest.Get(EmployeeNo);
        ApprovalSetupLine.Reset();
        ApprovalSetupLine.SetRange("Request Type", EmpActType);
        ApprovalSetupLine.SetRange("Deputation On", EmpRequest."Deputation On");
        ApprovalSetupLine.SetRange("Employee Role", EmpRequest."Approver Role");
        count := 0;
        if ApprovalSetupLine.Findset() then
            repeat
                Employee.Reset();
                if ApprovalSetupLine."Deputation type" = ApprovalSetupLine."Deputation On" then begin
                    Employee.SetRange("Deputation On", EmpRequest."Deputation On");
                    if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Branch then
                        Employee.SetRange("Global Dimension 1 Code", EmpRequest."Global Dimension 1 Code")
                    else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Department then
                        Employee.SetRange("Department Code", EmpRequest."Department Code")
                    else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Province then
                        Employee.SetRange("Province Code", EmpRequest."Province Code");
                end else begin
                    if ApprovalSetupLine."Deputation Type" = ApprovalSetupLine."Deputation Type"::Province then
                        Employee.SetRange("Province Code", EmpRequest."Province Code");
                end;
                Employee.SetRange("Approver Role", ApprovalSetupLine."Approver Role");
                if Employee.FindFirst() then begin
                    Approval.Init();
                    Approval.Validate("Document No.", EmpActNo);
                    Approval.Validate("Document Type", EmpActType);
                    Approval.Validate("Approver No", Employee."No.");
                    Approval.Validate("Approval Sequence", ApprovalSetupLine."Approval Sequence");
                    Approval.Validate(Status, ApprovalSetupLine."Approval Status");
                    Approval.Validate("Approval Role", ApprovalSetupLine."Approval Role");
                    Approval.Validate("Loan Type", LoanType);
                    if ApprovalSetupLine."Approval Sequence" = 1 then begin
                        Approval.Validate("Approval Status", "Approval Status"::Open);
                        count := count + 1;
                    end else
                        Approval.Validate("Approval Status", "Approval Status"::Created);
                    Approval.Validate("Employee No", EmployeeNo);
                    Approval.Insert(true);
                end;
            until ApprovalSetupLine.Next() = 0
        else
            Error('Approval Setup not found');
        if count = 0 then begin
            Error('There is no approver setup for sequence 1');
        end;
        Approval1.Reset();
        Approval1.SetRange("Document No.", EmpActNo);
        if not Approval1.FindFirst() then
            Error('Approval Not Found');
    end;

    // << Insert Approval in temporary table <<
    procedure InsertApprovalCancelled(EmployeeNo: Code[20]; EmpActNo: Code[20]; EmpActType: enum "Employee Activity Type"; Cancelled: Boolean)
    var
        ApprovalSetupLine: Record "Approval Setup line";
        Approval: Record "Approval HRMS";
        Employee: Record Employee;
        EmpRequest: Record Employee;
        count: Integer;
    begin
        EmpRequest.Reset();
        EmpRequest.Get(EmployeeNo);
        ApprovalSetupLine.Reset();
        ApprovalSetupLine.SetRange("Request Type", EmpActType);
        ApprovalSetupLine.SetRange("Deputation On", EmpRequest."Deputation On");
        ApprovalSetupLine.SetRange("Employee Role", EmpRequest."Approver Role");
        count := 0;
        if ApprovalSetupLine.Findset() then
            repeat
                Employee.Reset();
                if ApprovalSetupLine."Deputation type" = ApprovalSetupLine."Deputation On" then begin
                    Employee.SetRange("Deputation On", EmpRequest."Deputation On");
                    if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Branch then
                        Employee.SetRange("Global Dimension 1 Code", EmpRequest."Global Dimension 1 Code")
                    else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Department then
                        Employee.SetRange("Department Code", EmpRequest."Department Code")
                    else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Province then
                        Employee.SetRange("Province Code", EmpRequest."Province Code");
                end else begin
                    if ApprovalSetupLine."Deputation Type" = ApprovalSetupLine."Deputation Type"::Province then
                        Employee.SetRange("Province Code", EmpRequest."Province Code");
                end;
                Employee.SetRange("Approver Role", ApprovalSetupLine."Approver Role");
                if Employee.FindFirst() then begin
                    Approval.Init();
                    Approval.Validate("Document No.", EmpActNo);
                    Approval.Validate("Document Type", EmpActType);
                    Approval.Validate("Approver No", Employee."No.");
                    Approval.Validate("Approval Sequence", ApprovalSetupLine."Approval Sequence");
                    Approval.Validate(Status, ApprovalSetupLine."Approval Status");
                    Approval.Validate(Cancelled, Cancelled);
                    Approval.Validate("Approval Role", ApprovalSetupLine."Approval Role");
                    if ApprovalSetupLine."Approval Sequence" = 1 then begin
                        Approval.Validate("Approval Status", "Approval Status"::Open);
                        count := count + 1;
                    end else
                        Approval.Validate("Approval Status", "Approval Status"::Created);
                    Approval.Validate("Employee No", EmployeeNo);
                    Approval.Insert();
                end;
            until ApprovalSetupLine.Next() = 0
        else
            Error('Approval Setup not found');
        if count = 0 then begin
            Error('There is no approver setup for sequence 1');
        end;
    end;

    // >> Check  valid Login Approver for Approve >> Santosh 2025-03-04 >>
    procedure CheckApprover(EmpActNo: Code[20])
    var
        CheckApprover: Boolean;
        ApprovalLine: Record "Approval HRMS";
        Employee: Record Employee;
        ApprovalSetupLine: Record "Approval Setup line";
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
    begin
        Employee.Reset();
        Employee.Get(HRMgt.GetEmployeeNo());
        ApprovalLine.Reset();
        ApprovalLine.SetRange("Document No.", EmpActNo);
        ApprovalLine.SetRange("Approval Status", ApprovalLine."Approval Status"::Open);
        ApprovalLine.SetRange("Approver No", HRMgt.GetEmployeeNo());
        if not ApprovalLine.Findfirst() then
            Error(ApproveNotEligibleError);
    end;

    procedure CheckApproverBoolean(EmpActNo: Code[20]): Boolean
    var
        ApprovalLine: Record "Approval HRMS";
        Employee: Record Employee;
    begin
        Employee.Reset();
        Employee.Get(HRMgt.GetEmployeeNo());
        ApprovalLine.Reset();
        ApprovalLine.SetRange("Document No.", EmpActNo);
        ApprovalLine.SetRange("Approval Status", ApprovalLine."Approval Status"::Open);
        ApprovalLine.SetRange("Approver No", HRMgt.GetEmployeeNo());
        if ApprovalLine.Findfirst() then
            exit(true);
    end;

    // >> Approve Reject Document Dynamically using RecRef>> Santosh 2025-03-04 >>
    procedure ApproveRejectDocument(var RecRef: RecordRef; Approved: Boolean)
    var
        ApprovalHRMS: Record "Approval HRMS";
        ApprovalHRMS2: Record "Approval HRMS";
        ApproveNotEligibleError: Label 'You are not Eligible to Approve or reject this document ';
        ApprovalStatusField: text;
        ApprovalStatus: Enum "Approval Status";
        EmployeeActivityType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
        FieldRef: FieldRef;
        Fieldref2: FieldRef;
        DocumentNo: Code[20];
        RetirementFund: Record "Retirement Fund";
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        case RecRef.Number() of
            Database::"Retirement Fund":
                begin
                    FieldRef := RecRef.Field(RetirementFund.FieldNo("Approval Status"));
                    ApprovalStatusField := FieldRef.Value;
                    EmployeeActivityType := EmployeeActivityType::Retirement;
                    Fieldref2 := RecRef.Field(RetirementFund.FieldNo("No."));
                    DocumentNo := Fieldref2.Value();
                end;
            else begin
                //old code
                ApprovalStatusField := Format((RecRef.Field(16)));
                EmployeeActivityType := RecRef.Field(2).Value;
                DocumentNo := RecRef.Field(1).Value;
            end;
        end;
        if ApprovalStatusField = Format(ApprovalStatus::Pending) then begin
            CheckApprover(DocumentNo);
            ApprovalHRMS.Reset();
            ApprovalHRMS.SetRange("Document No.", DocumentNo);
            ApprovalHRMS.SetRange("Approval Status", ApprovalHRMS."Approval Status"::Open);
            if ApprovalHRMS.FindSet() then begin
                repeat
                    if Approved then begin
                        ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Approved);
                        ApprovalHRMS.Validate("Approved By", HRMgt.GetEmpName());
                        RecRef.Field(100).Validate(ApprovalHRMS.Status);
                    end
                    else begin
                        ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Rejected);
                        ApprovalHRMS.Validate("Rejected By", HRMgt.GetEmpName());
                        RecRef.Field(16).Validate(ApprovalStatus::Rejected);
                        case EmployeeActivityType of
                            EmployeeActivityType::"Leave Request":
                                //for leave Cancelled Reject
                                begin
                                    if RecRef.Field(39).value then
                                        leaveMgt.RejectLeaveCancel(RecRef.Field(1).Value) // For Cancelled Leave
                                end;
                            //for travel claim Reject
                            EmployeeActivityType::"Travel Claim":
                                begin
                                    TravelMgt.TravelClaimReject(RecRef.Field(1).Value);

                                end;
                            EmployeeActivityType::"Transfer Claim":
                                begin
                                    TransferMgt.RejectTransferClaim(RecRef.Field(1).Value);
                                end;
                            //for Allowance claim return
                            EmployeeActivityType::"Allowance Assignment":
                                begin
                                    RecRef.Field(16).Validate(ApprovalStatus::Open);
                                    RecRef.Field(100).Validate('');
                                    RecRef.Modify();
                                    AllowanceAssignmentMgt.ApproveRejectAllowanceAssignment(false, RecRef.Field(1).Value);
                                    exit;
                                end;
                            EmployeeActivityType::"Overtime Bulk":
                                begin
                                    RecRef.Field(16).Validate(ApprovalStatus::Open);
                                    RecRef.Field(100).Validate('');
                                    RecRef.Modify();
                                    OverTimeMgt.ApproveRejectOvertimeLine(false, RecRef.Field(1).Value);
                                    exit;
                                end;
                            //for Allowance claim Reject
                            EmployeeActivityType::"Allowance Assignment Claim":
                                begin
                                    AllowanceAssignmentMgt.ApproveRejectAllowanceAssignment(false, RecRef.Field(1).Value);
                                end;
                            EmployeeActivityType::"Shift Assignment":
                                begin
                                    RecRef.Field(16).Validate(ApprovalStatus::Open);
                                    RecRef.Field(100).Validate('');
                                    RecRef.Modify();
                                    ShiftAssignmentMgt.ApproveRejectShiftLine(false, RecRef.Field(1).Value);
                                    exit;
                                end;
                            EmployeeActivityType::Retirement:
                                begin
                                    RecRef.Field(22).Validate(ApprovalStatus::Rejected);
                                    RecRef.Modify();
                                end;
                        end;
                        // Get the Rejected Status from Status Master
                        StatusMaster.Reset();
                        StatusMaster.SetRange(Rejected, true);
                        if StatusMaster.FindFirst() then begin
                            RecRef.Field(100).Validate(StatusMaster.Status);
                        end
                        else
                            Error('Rejected Status not Found On Status Master Setup');
                    end;
                    RecRef.Modify();
                    ApprovalHRMS.Modify();
                until ApprovalHRMS.Next() = 0;
                // Modify the record dynamically
            end;
            //Find next approval step
            if Approved then begin
                ApprovalHRMS2.Reset();
                ApprovalHRMS2.SetRange("Document No.", DocumentNo);
                ApprovalHRMS2.SetRange("Approval Sequence", ApprovalHRMS."Approval Sequence" + 1);
                if ApprovalHRMS2.FindSet() then
                    repeat
                        ApprovalHRMS2."Approval Status" := ApprovalHRMS2."Approval Status"::Open;
                        ApprovalHRMS2.Modify;
                    until ApprovalHRMS2.Next() = 0
                else begin
                    // If no next approval step found then set the status to approved
                    if EmployeeActivityType = EmployeeActivityType::Retirement then begin
                        RecRef.Field(RetirementFund.FieldNo("Approval Status")).Validate(ApprovalStatus::Approved);

                    end
                    else begin
                        //old code
                        RecRef.Field(16).Validate(ApprovalStatus::Approved);
                        RecRef.Field(16).Validate(ApprovalStatus::Approved);
                        RecRef.Field(37).Validate(Today);
                    end;
                    RecRef.Modify();
                    case EmployeeActivityType of
                        //for leave
                        EmployeeActivityType::"Leave Request":
                            begin
                                if RecRef.Field(39).value then
                                    leaveMgt.ApproveCancelledLeave(RecRef.Field(1).Value) // For Cancelled Leave
                                else
                                    leaveMgt.LeaveApproved(RecRef.Field(1).Value); // For leave Approved
                            end;
                        EmployeeActivityType::"Travel Request":
                            begin
                                TravelMgt.TravelApproved(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Travel Claim":
                            begin
                                TravelMgt.TravelClaimApproved(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Attendance Missed":
                            begin
                                AttendanceMissed.AttendanceMissedApproved(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Transfer Claim":
                            begin
                                TransferMgt.ApproveTransferClaim(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::Overtime:
                            begin
                                OverTimeMgt.ApproveOverTime(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::Resignation:
                            begin
                                ResignationMgt.ApproveResignation(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Employee Edit":
                            begin
                                ChangesInEmployeeMgt.ApproveChangesInEmployee(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Allowance Assignment", EmployeeActivityType::"Allowance Assignment Claim":
                            begin
                                AllowanceAssignmentMgt.ApproveRejectAllowanceAssignment(true, RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Overtime Bulk":
                            begin
                                OverTimeMgt.ApproveRejectOvertimeLine(true, RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Shift Assignment":
                            begin
                                ShiftAssignmentMgt.ApproveRejectShiftLine(true, RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::Retirement:
                            begin
                                //update payroll attribute uses
                                RetirementFund.Get(RecRef.RecordId);
                                HRMgt.ScreenRF(RetirementFund);
                            end;
                    end;
                end;
            end;
        end else
            Error('Document Status Must be in Pending');
    end;

    procedure CheckRequester(EmpActNo: Code[20])
    var
        ApprovalLine: Record "Approval HRMS";
        Employee: Record Employee;
        ApproveNotEligibleError: Label 'You are not Eligible to WithDraw this document ';
    begin
        Employee.Reset();
        Employee.Get(HRMgt.GetEmployeeNo());
        ApprovalLine.Reset();
        ApprovalLine.SetRange("Document No.", EmpActNo);
        ApprovalLine.SetRange("Employee No", HRMgt.GetEmployeeNo());
        if not ApprovalLine.Findfirst() then
            Error(ApproveNotEligibleError);
    end;
    // >>  WithDraw Document Dynamically using RecRef>> Santosh 2025-04-21 >>
    procedure WithDrawRequest(var RecRef: RecordRef)
    var
        Approver: Record "Approval HRMS";
        ApprovalStatusField: text;
        ApprovalStatusEnum: Enum "Approval Status";
        EmpActType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
        RetirementFund: Record "Retirement Fund";
    begin
        // Get the fields dynamically using FieldRef
        case RecRef.Number() of
            Database::"Retirement Fund":
                begin
                    ApprovalStatusField := Format((RecRef.Field(RetirementFund.FieldNo("Approval Status"))));
                    EmpActType := EmpActType::Retirement;
                end;
            else begin
                //old code
                ApprovalStatusField := Format((RecRef.Field(16)));
                EmpActType := RecRef.Field(2).Value;

            end;
        end;
        if ApprovalStatusField = Format(ApprovalStatusEnum::Pending) then begin
            CheckRequester(RecRef.Field(1).Value);
            Approver.Reset();
            Approver.SetRange("Document No.", RecRef.Field(1).Value);
            Approver.SetRange("Approval Status", Approver."Approval Status"::Open);
            Approver.SetRange("Approval Sequence", 1);
            if Approver.Findfirst() then begin
                if EmpActType = EmpActType::Retirement then
                    RecRef.Field(RetirementFund.FieldNo("Approval Status")).Validate(ApprovalStatusEnum::Withdrawn)
                else
                    RecRef.Field(16).Validate(ApprovalStatusEnum::Withdrawn); // Modify the record dynamically
                RecRef.Modify();
                Approver.Validate("Approval Status", Approver."Approval Status"::Withdrawn);
                Approver.Modify();

                // Get the withDraw Status from Status Master
                StatusMaster.Reset();
                StatusMaster.SetRange(withdraw, true);
                if StatusMaster.FindFirst() then begin
                    if EmpActType <> EmpActType::Retirement then
                        RecRef.Field(100).Validate(StatusMaster.Status);
                    RecRef.Modify();
                end
                else
                    Error('withdraw Status not Found On Status Master Setup');
            end else
                Error('Document is approved by 1 or more Approver');
        end else
            Error('Document Status Must be in Pending');
    end;
    // >>  WithDraw Document Dynamically using RecRef>> Santosh 2025-04-21 >>
    procedure WithDrawRequestAPI(documentNo: Code[20]; EmpActType: Text)
    var
        EmpActTypeEnum: Enum "Employee Activity Type";
        Leave: Record Leave;
        TravelRequest: Record "Travel Request";
        RecRef: RecordRef;
        RetirementFund: Record "Retirement Fund";
    begin
        EmpActTypeEnum := Enum::"Employee Activity Type".FromInteger(EmpActTypeEnum.Ordinals.Get(EmpActTypeEnum.Names.IndexOf(EmpActType)));
        case EmpActTypeEnum of
            //for leave
            EmpActTypeEnum::"Leave Request":
                begin
                    if Leave.Get(documentNo) then begin
                        RecRef.GetTable(Leave);
                        WithDrawRequest(RecRef);
                    end;
                end;
            //Travel Request
            EmpActTypeEnum::"Travel Request":
                begin
                    if TravelRequest.Get(documentNo) then begin
                        RecRef.GetTable(TravelRequest);
                        WithDrawRequest(RecRef);
                    end;
                end;
            EmpActTypeEnum::Retirement:
                begin
                    if RetirementFund.Get(documentNo) then begin
                        RecRef.GetTable(RetirementFund);
                        WithDrawRequest(RecRef);
                    end;

                end;
        end;
    end;

    procedure IsFinalApprover(DocNo: Code[20]): Boolean
    var
        Approver: Record "Approval HRMS";
        approver1: Record "Approval HRMS";
    begin
        Approver.Reset();
        Approver.SetRange("Document No.", DocNo);
        Approver.SetRange("Approval Status", Approver."Approval Status"::Open);
        if Approver.FindFirst() then begin
            Approver1.SetRange("Document No.", DocNo);
            Approver1.SetRange("Approval Sequence", Approver."Approval Sequence" + 1);
            if Approver1.FindFirst() then
                exit(false)
            else
                exit(true)
        end;
    end;

    procedure UpdateFirstApproverStatus(DocNo: Code[20]): Boolean
    var
        Approver: Record "Approval HRMS";
    begin
        Approver.Reset();
        Approver.SetRange("Document No.", DocNo);
        Approver.SetRange("Approval Sequence", 1);
        if Approver.FindFirst() then begin
            Approver.Validate("Approval Status", Approver."Approval Status"::Open);
            Approver.Modify();
        end;
    end;

    //>> Approve Reject Document Dynamically using RecRef>> Santosh 2025-03-04 >>
    procedure ApproveJournalDocument(EmpActNo: Code[20]; Approved: Boolean)
    var
        EmployeeActivityJournal: Record "Employee Activity Journal";
        Approver: Record "Approval HRMS";
        Approver2: Record "Approval HRMS";
        ApproveNotEligibleError: Label 'You are not Eligible to Approve or reject this document ';
        // ApprovalStatusField: text;
        ApprovalStatusEnum: Enum "Approval Status";
        // EmpActType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
    begin
        // Get the fields dynamically using FieldRef
        EmployeeActivityJournal.SetRange("Emp Act. No", EmpActNo);
        EmployeeActivityJournal.SetRange("Approval Status", EmployeeActivityJournal."Approval Status"::Pending);
        if EmployeeActivityJournal.FindSet() then begin
            CheckApprover(EmpActNo);
            Approver.Reset();
            Approver.SetRange("Document No.", EmpActNo);
            Approver.SetRange("Approval Status", Approver."Approval Status"::Open);
            if Approver.FindSet() then begin
                repeat
                    if Approved then begin
                        Approver.Validate("Approval Status", Approver."Approval Status"::Approved);
                        Approver.Validate("Approved By", HRMgt.GetEmpName());
                        EmployeeActivityJournal.ModifyAll(Status, Approver.Status);
                    end;
                    Approver.Modify();
                until Approver.Next() = 0;
                // Modify the record dynamically
            end;
            //Find next approval step
            if Approved then begin
                Approver2.Reset();
                Approver2.SetRange("Document No.", EmpActNo);
                Approver2.SetRange("Approval Sequence", Approver."Approval Sequence" + 1);
                if Approver2.FindSet() then
                    repeat
                        Approver2."Approval Status" := Approver2."Approval Status"::Open;
                        Approver2.Modify;
                    until Approver2.Next() = 0
                else begin
                    // If no next approval step found then set the status to approved
                    EmployeeActivityJournal.ModifyAll("Approval Status", ApprovalStatusEnum::Approved);
                    EmployeeActivityJournal.ModifyAll("Approved Date", Today);
                end;
            end;
        end else
            Error('Document Status Must be in Pending');
    end;
    // >>  Cancel Document Dynamically using RecRef>> Santosh 2025-04-21 >>
    procedure CancelRequest(var RecRef: RecordRef)
    var
        Approver: Record "Approval HRMS";
        ApprovalStatusField: text;
        ApprovalStatusEnum: Enum "Approval Status";
        EmpActType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
        OvertimeLine: Record "Overtime Line";
    begin
        // Get the fields dynamically using FieldRef
        ApprovalStatusField := Format((RecRef.Field(16)));
        EmpActType := RecRef.Field(2).Value;
        if ApprovalStatusField = Format(ApprovalStatusEnum::Open) then begin
            CheckRequester(RecRef.Field(1).Value);
            Approver.Reset();
            Approver.SetRange("Document No.", RecRef.Field(1).Value);
            Approver.SetRange("Approval Status", Approver."Approval Status"::Created);
            Approver.SetRange("Approval Sequence", 1);
            if Approver.Findfirst() then begin
                RecRef.Field(16).Validate(ApprovalStatusEnum::Canceled); // Modify the record dynamically
                RecRef.Modify();
                Approver.Validate("Approval Status", Approver."Approval Status"::Canceled);
                Approver.Modify();
                case EmpActType of
                    //for leave
                    EmpActType::"Overtime Bulk":
                        begin
                            OvertimeLine.Reset();
                            OvertimeLine.SetRange("No.", RecRef.Field(1).Value);
                            OvertimeLine.ModifyAll("Approval Status", ApprovalStatusEnum::Canceled);
                        end;
                end;
            end;
        end else
            Error('Document Status Must be in Open');
    end;

    procedure CancelRequestAPI(documentNo: Code[20]; EmpActType: Text)
    var
        EmpActTypeEnum: Enum "Employee Activity Type";
        Overtime: Record OverTime;
        RecRef: RecordRef;
    begin
        case EmpActType of
            //for Overtime Bulk
            format(EmpActTypeEnum::"Overtime Bulk"):
                begin
                    if Overtime.Get(documentNo) then begin
                        RecRef.GetTable(Overtime);
                        CancelRequest(RecRef);
                    end;
                end;
            else
                Error('Employee Activity Type not Found');
        end;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        leaveMgt: Codeunit "Leave Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        AttendanceMissed: Codeunit "AttendanceMiss mgt";
        TransferMgt: Codeunit "Transfer Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        ResignationMgt: Codeunit "Resignation Mgt";
        ChangesInEmployeeMgt: Codeunit "Employee Edit Mgt.";
        AllowanceAssignmentMgt: Codeunit "Allowance Assignment Mgt";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";

}
