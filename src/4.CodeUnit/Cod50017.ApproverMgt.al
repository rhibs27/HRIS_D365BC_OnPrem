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
        ApprovalSetup: Record "Approval Setup";
        ApprovalSetupLine: Record "Approval Setup line";
        Employee: Record Employee;
        EmpRequest: Record Employee;
        Approval1: Record "Approval HRMS";
        SequenceOneCount, ApprovalEntryCount : Integer;
        isHandled, SkipError : Boolean;
        PerSequenceCount: array[10] of Integer;
    begin
        EmpRequest.Get(EmployeeNo);
        //if employee is a manual approver
        if EmpRequest."Manual Approver User" then begin
            IsManualApproverWorkflow(EmployeeNo, EmpActNo, EmpActType, ApprovalStatus, IsHandled);
            if IsHandled then
                exit;
        end;
        //if employee is not manual approver
        if not isHandled then begin
            ApprovalSetupLine.Reset();
            ApprovalSetupLine.SetRange("Request Type", EmpActType);
            ApprovalSetupLine.SetFilter("Deputation On", '%1|%2', EmpRequest."Deputation on"::" ", EmpRequest."Deputation On");
            ApprovalSetupLine.SetRange("Employee Role", EmpRequest."Approver Role");
            OnInsertApprovalOnFilterApprovalSetupLine(ApprovalSetupLine, EmpActType, EmpActNo, EmployeeNo);
            OnSkipEmployeeError(SkipError);
            SequenceOneCount := 0;
            GetPerSequenceApproval(ApprovalSetupLine, PerSequenceCount);
            if ApprovalSetupLine.Findset() then begin
                repeat
                    ApprovalSetup.Get(ApprovalSetupLine."Request Type", ApprovalSetupLine."Deputation On");
                    Employee.Reset();
                    Employee.SetRange(Status, Employee.Status::Active);
                    Employee.SetFilter("NAV Login ID", '<>%1', '');
                    OnInsertApprovalOnBeforeSelectApprover(ApprovalSetupLine, Employee, EmpRequest, IsHandled);
                    if not isHandled then begin
                        if ApprovalSetupLine."Deputation type" = ApprovalSetupLine."Deputation On" then begin
                            Employee.SetRange("Deputation On", EmpRequest."Deputation On");
                            if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Branch then
                                Employee.SetRange("Branch Code", EmpRequest."Branch Code")
                            else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Department then
                                Employee.SetRange("Department Code", EmpRequest."Department Code")
                            else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Province then
                                Employee.SetRange("Province Code", EmpRequest."Province Code");
                        end else begin
                            if ApprovalSetupLine."Deputation Type" = ApprovalSetupLine."Deputation Type"::Province then
                                Employee.SetRange("Province Code", EmpRequest."Province Code")
                            else if ApprovalSetupLine."Deputation Type" = ApprovalSetupLine."Deputation Type"::Unit then
                                Employee.SetRange("Unit Code", EmpRequest."Unit Code");
                        end;
                    end;
                    Employee.SetRange("Approver Role", ApprovalSetupLine."Approver Role");
                    if Employee.FindSet() then begin
                        if ApprovalSetup."Approval Entry Creation Policy" = ApprovalSetup."Approval Entry Creation Policy"::"Everyone in Role" then
                            ApprovalEntryCount := Employee.Count
                        else
                            ApprovalEntryCount := 1;
                        repeat
                            SequenceOneCount := SequenceOneCount + GenerateApprovalEntry(
                                 EmpActType,
                                 EmpActNo,
                                 Employee."No.",
                                 ApprovalSetupLine."Approval Sequence",
                                 ApprovalSetupLine."Approval Status",
                                 ApprovalSetupLine."Approver Role",
                                 ApprovalStatus,
                                 EmployeeNo,
                                 Enum::"Loan Type"::" ",
                                 false,
                                 ApprovalSetupLine
                             );
                            ApprovalEntryCount -= 1;
                        until (Employee.Next() = 0) or (ApprovalEntryCount = 0);
                    end
                    else
                        if ApprovalSetup."Approval Sending Policy" = ApprovalSetup."Approval Sending Policy"::"All Approver Role Mandatory" then
                            Error('Approvers not found for %1 Role', ApprovalSetupLine."Approver Role");

                until ApprovalSetupLine.Next() = 0;

                if ApprovalSetup."Approval Sending Policy" = ApprovalSetup."Approval Sending Policy"::"At Least One Role Per Sequence Mandatory" then
                    CheckAndValidatePerSequenceApproval(EmpActNo, PerSequenceCount);
            end
            else
                Error('Approval Setup not found');
            if SequenceOneCount = 0 then
                Error('There is no approver setup for sequence 1');
            Approval1.Reset();
            Approval1.SetRange("Document No.", EmpActNo);
            if not Approval1.FindFirst() then
                Error('Approval Not Found');
        end;
    end;
    // >> Insert Approval for Loan >> Santosh 2025-03-04 >>
    procedure InsertApprovalLoan(EmployeeNo: Code[20];
                                    EmpActNo: Code[20];
                                    EmpActType: enum "Employee Activity Type";
        LoanType: Enum "Loan Type")
    var
        ApprovalSetup: Record "Approval Setup";
        ApprovalSetupLine: Record "Approval Setup line";
        Employee: Record Employee;
        EmpRequest: Record Employee;
        Approval1: Record "Approval HRMS";
        SequenceOneCount, ApprovalEntryCount : Integer;
        PerSequenceCount: array[10] of Integer;
    begin
        EmpRequest.Reset();
        EmpRequest.Get(EmployeeNo);
        ApprovalSetupLine.Reset();
        ApprovalSetupLine.SetRange("Request Type", EmpActType);
        ApprovalSetupLine.SetFilter("Deputation On", '%1|%2', EmpRequest."Deputation on"::" ", EmpRequest."Deputation On");
        ApprovalSetupLine.SetRange("Employee Role", EmpRequest."Approver Role");
        SequenceOneCount := 0;
        GetPerSequenceApproval(ApprovalSetupLine, PerSequenceCount);
        if ApprovalSetupLine.Findset() then begin
            repeat
                ApprovalSetup.Get(ApprovalSetupLine."Request Type", ApprovalSetupLine."Deputation On");
                Employee.Reset();
                Employee.SetRange(Status, Employee.Status::Active);
                Employee.SetFilter("NAV Login ID", '<>%1', '');
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
                if Employee.FindSet() then begin
                    if ApprovalSetup."Approval Entry Creation Policy" = ApprovalSetup."Approval Entry Creation Policy"::"Everyone in Role" then
                        ApprovalEntryCount := Employee.Count
                    else
                        ApprovalEntryCount := 1;
                    repeat
                        SequenceOneCount := SequenceOneCount + GenerateApprovalEntry(
                             EmpActType,
                             EmpActNo,
                             Employee."No.",
                             ApprovalSetupLine."Approval Sequence",
                             ApprovalSetupLine."Approval Status",
                             ApprovalSetupLine."Approver Role",
                             Enum::"Approval Status"::" ",
                             EmployeeNo,
                             LoanType,
                             false,
                             ApprovalSetupLine
                         );
                        ApprovalEntryCount -= 1;
                    until (Employee.Next() = 0) or (ApprovalEntryCount = 0);
                end
                else
                    if ApprovalSetup."Approval Sending Policy" = ApprovalSetup."Approval Sending Policy"::"All Approver Role Mandatory" then
                        Error('Approvers not found for %1 Role', ApprovalSetupLine."Approver Role");

            until ApprovalSetupLine.Next() = 0;

            if ApprovalSetup."Approval Sending Policy" = ApprovalSetup."Approval Sending Policy"::"At Least One Role Per Sequence Mandatory" then
                CheckAndValidatePerSequenceApproval(EmpActNo, PerSequenceCount);
        end
        else
            Error('Approval Setup not found');
        if SequenceOneCount = 0 then
            Error('There is no approver setup for sequence 1');
        Approval1.Reset();
        Approval1.SetRange("Document No.", EmpActNo);
        if not Approval1.FindFirst() then
            Error('Approval Not Found');
    end;
    // << Insert Approval in temporary table <<
    procedure InsertApprovalCancelled(EmployeeNo: Code[20]; EmpActNo: Code[20]; EmpActType: enum "Employee Activity Type"; Cancelled: Boolean)
    var
        ApprovalSetup: Record "Approval Setup";
        ApprovalSetupLine: Record "Approval Setup line";
        Employee: Record Employee;
        EmpRequest: Record Employee;
        SequenceOneCount, ApprovalEntryCount : Integer;
        IsHandled: Boolean;
        PerSequenceCount: array[10] of Integer;
    begin
        EmpRequest.Reset();
        EmpRequest.Get(EmployeeNo);
        ApprovalSetupLine.Reset();
        ApprovalSetupLine.SetRange("Request Type", EmpActType);
        ApprovalSetupLine.SetFilter("Deputation On", '%1|%2', EmpRequest."Deputation on"::" ", EmpRequest."Deputation On");
        ApprovalSetupLine.SetRange("Employee Role", EmpRequest."Approver Role");
        OnInsertApprovalCancelledOnFilterApprovalSetupLine(ApprovalSetupLine, EmpActType);
        SequenceOneCount := 0;
        GetPerSequenceApproval(ApprovalSetupLine, PerSequenceCount);
        if ApprovalSetupLine.Findset() then begin
            repeat
                ApprovalSetup.Get(ApprovalSetupLine."Request Type", ApprovalSetupLine."Deputation On");
                Employee.Reset();
                Employee.SetRange(Status, Employee.Status::Active);
                Employee.SetFilter("NAV Login ID", '<>%1', '');
                OnInsertApprovaCancelledOnSelectApprover(ApprovalSetupLine, Employee, EmpRequest, IsHandled);
                if not IsHandled then begin
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
                end;
                Employee.SetRange("Approver Role", ApprovalSetupLine."Approver Role");
                if Employee.FindSet() then begin
                    if ApprovalSetup."Approval Entry Creation Policy" = ApprovalSetup."Approval Entry Creation Policy"::"Everyone in Role" then
                        ApprovalEntryCount := Employee.Count
                    else
                        ApprovalEntryCount := 1;
                    repeat
                        SequenceOneCount := SequenceOneCount + GenerateApprovalEntry(
                             EmpActType,
                             EmpActNo,
                             Employee."No.",
                             ApprovalSetupLine."Approval Sequence",
                             ApprovalSetupLine."Approval Status",
                             ApprovalSetupLine."Approver Role",
                             Enum::"Approval Status"::" ",
                             EmployeeNo,
                             Enum::"Loan Type"::" ",
                             Cancelled,
                             ApprovalSetUpLine
                         );
                        ApprovalEntryCount -= 1;
                    until (Employee.Next() = 0) or (ApprovalEntryCount = 0);
                end
                else
                    if ApprovalSetup."Approval Sending Policy" = ApprovalSetup."Approval Sending Policy"::"All Approver Role Mandatory" then
                        Error('Approvers not found for %1 Role', ApprovalSetupLine."Approver Role");
            until ApprovalSetupLine.Next() = 0;

            if ApprovalSetup."Approval Sending Policy" = ApprovalSetup."Approval Sending Policy"::"At Least One Role Per Sequence Mandatory" then
                CheckAndValidatePerSequenceApproval(EmpActNo, PerSequenceCount);
        end
        else
            Error('Approval Setup not found');
        if SequenceOneCount = 0 then begin
            Error('There is no approver setup for sequence 1');
        end;
    end;
    // >> Check  valid Login Approver for Approve >> Santosh 2025-03-04 >>
    procedure CheckApprover(EmpActNo: Code[20])// onprem
    begin
        CheckApprover(EmpActNo, HRMgt.GetEmployeeNo());
    end;

    procedure CheckApprover(EmpActNo: Code[20]; ApproverNo: code[20]): Boolean
    var
        ApprovalLine: Record "Approval HRMS";
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document';
        HRSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        IsHRApprover: Boolean;
    begin
        IsHRApprover := false;
        if HRSetup.Get() and Employee.Get(ApproverNo) then begin
            if HRSetup."HR Department Code" <> '' then
                if HRSetup."HR Head Functional Title" = '' then begin
                    if Employee."Department Code" = HRSetup."HR Department Code" then
                        IsHRApprover := true;
                end
                else begin
                    if (Employee."Functional Title" = HRSetup."HR Head Functional Title") and
                       (Employee."Department Code" = HRSetup."HR Department Code") then
                        IsHRApprover := true;
                end;
        end;
        if not IsHRApprover then begin
            ApprovalLine.Reset();
            ApprovalLine.SetRange("Document No.", EmpActNo);
            ApprovalLine.SetRange("Approval Status", ApprovalLine."Approval Status"::Open);
            ApprovalLine.SetRange("Approver No", ApproverNo);
            if not ApprovalLine.FindFirst() then
                Error(ApproveNotEligibleError);
        end;
    end;
#if SaasFeature
    procedure CheckApproverSaas(EmpActNo: Code[20]; ApproverNo: code[20]): Boolean
    var
        ApprovalLine: Record "Approval HRMS";
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
    begin
        ApprovalLine.Reset();
        ApprovalLine.SetRange("Document No.", EmpActNo);
        ApprovalLine.SetRange("Approval Status", ApprovalLine."Approval Status"::Open);
        ApprovalLine.SetRange("Approver No", ApproverNo);
        if not ApprovalLine.Findfirst() then
            Error(ApproveNotEligibleError);
    end;
#endif

#if SaasFeature
    procedure GetApproverNoSAAS(AccessToken: Code[60]): code[60] // Saas
    var
        DecryptedEmployeeNo: Code[60];
        SaaSLoginMgmt: Codeunit SaaSLoginMgmt;
    begin
        exit(SaaSLoginMgmt.DecryptCode(AccessToken));
    end;
#endif

    procedure CheckApproverBoolean(EmpActNo: Code[20]): Boolean // onprem
    var
    begin
        exit(CheckApproverBoolean(EmpActNo, HRMgt.GetEmployeeNo()));
    end;

    procedure CheckApproverBoolean(EmpActNo: Code[20]; ApproverNo: code[20]): Boolean //saas
    var
        ApprovalLine: Record "Approval HRMS";
        HRSetup: Record "Human Resources Setup";
        Employee: Record Employee;
    begin
        ApprovalLine.SetRange("Document No.", EmpActNo);
        ApprovalLine.SetRange("Approval Status", ApprovalLine."Approval Status"::Open);
        ApprovalLine.SetRange("Approver No", ApproverNo);
        if ApprovalLine.Findfirst() then
            exit(true);
        if HRSetup.Get() and Employee.Get(ApproverNo) then begin
            if HRSetup."HR Department Code" <> '' then
                if HRSetup."HR Head Functional Title" = '' then begin
                    if Employee."Department Code" = HRSetup."HR Department Code" then
                        exit(true);
                end else begin
                    if (Employee."Functional Title" = HRSetup."HR Head Functional Title") and (Employee."Department Code" = HRSetup."HR Department Code") then
                        exit(true);
                end;
        end;
    end;
    // >> Approve Reject Document Dynamically using RecRef>> Santosh 2025-03-04 >>
    procedure ApproveRejectDocument(var RecRef: RecordRef; Approved: Boolean)
    var
        ApprovalHRMS: Record "Approval HRMS";
        ApprovalHRMS2: Record "Approval HRMS";
        ApprovalStatusField: text;
        ApprovalStatus: Enum "Approval Status";
        EmployeeActivityType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
        FieldRef: FieldRef;
        Fieldref2: FieldRef;
        Fieldref3: FieldRef;
        DocumentNo: Code[20];
        RetirementFund: Record "Retirement Fund";
        LeaveEncahRequest: Record "Encashment Request";
        AttendanceMgt: Codeunit "Attendance Mgt";
        AttributeAdjustmentMgt: Codeunit "Attribute Adjustment Mgt";
        AppraisalMgt: Codeunit "AppraisalMgt.";
        Cancelled: Boolean;
        RFContribution: Record "RF Contribution";
        AttributeAdj: Record "Attribute Adjustment Header";
        SkipRecRefModifyOnReject: Boolean;
        IsExit: Boolean;
    begin
        case RecRef.Number() of
            Database::"Retirement Fund":
                begin
                    FieldRef := RecRef.Field(RetirementFund.FieldNo("Approval Status"));
                    ApprovalStatusField := FieldRef.Value;
                    EmployeeActivityType := EmployeeActivityType::Retirement;
                    Fieldref2 := RecRef.Field(RetirementFund.FieldNo("No."));
                    DocumentNo := Fieldref2.Value();
                    Fieldref3 := RecRef.Field(RetirementFund.FieldNo("Employee No."));
                end;
            Database::"Encashment Request":
                begin
                    ApprovalStatusField := RecRef.Field(LeaveEncahRequest.FieldNo("Approval Status")).Value;
                    EmployeeActivityType := EmployeeActivityType::"Leave Encashment";
                    DocumentNo := RecRef.Field(LeaveEncahRequest.FieldNo("No.")).Value;
                end;
            Database::"Cancelled Document":
                begin
                    FieldRef := RecRef.Field(RetirementFund.FieldNo(Cancelled));
                    Cancelled := FieldRef.Value;
                end;
            Database::"Attribute Adjustment Header":
                begin
                    ApprovalStatusField := RecRef.Field(AttributeAdj.FieldNo("Approval Status")).Value;
                    EmployeeActivityType := EmployeeActivityType::"Attribute Adjustment";
                    DocumentNo := RecRef.Field(AttributeAdj.FieldNo("Document No.")).Value;
                end;
            else begin
                //old code
                ApprovalStatusField := Format((RecRef.Field(16)));
                EmployeeActivityType := RecRef.Field(2).Value;
                DocumentNo := RecRef.Field(1).Value;
            end;
        end;

        OnApproverejectDocumentOnBeforeCheckApprover(RecRef, EmployeeActivityType, DocumentNo, ApprovalStatusField);

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
                        ApprovalHRMS.Validate("Approved By Code", HRMgt.GetEmployeeNo());
                        RecRef.Field(100).Validate(ApprovalHRMS.Status);
                    end
                    else begin
                        ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Rejected);
                        ApprovalHRMS.Validate("Rejected By", HRMgt.GetEmpName());
                        ApprovalHRMS.Validate("Rejected By Code", HRMgt.GetEmployeeNo());
                        RecRef.Field(16).Validate(ApprovalStatus::Rejected);
                        case EmployeeActivityType of
                            EmployeeActivityType::"Leave Request":
                                //for leave Cancelled Reject
                                begin
                                    if RecRef.Field(39).value then
                                        leaveMgt.RejectLeaveCancel(RecRef.Field(1).Value) // For Cancelled Leave
                                end;
                            EmployeeActivityType::"Travel Request":
                                begin
                                    if RecRef.Field(39).value then
                                        TravelMgt.RejectTravelRequest(RecRef.Field(1).Value);
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
                                    // before sending approval
                                    RecRef.Field(RetirementFund.FieldNo("Approval Status")).Validate(ApprovalStatus::Rejected);
                                    RecRef.Modify();
                                    RFContribution.Reset();
                                    RFContribution.SetRange("Document No.", DocumentNo);
                                    RFContribution.ModifyAll("Approval Status", RFContribution."Approval Status"::Rejected);
                                end;
                            EmployeeActivityType::"Leave Encashment":
                                RecRef.Field(LeaveEncahRequest.FieldNo("Approval Status")).Validate(ApprovalStatus::Rejected);

                            EmployeeActivityType::"Allowance Assignment Memo", EmployeeActivityType::"Request Allowance", EmployeeActivityType::"Shift Assignment Memo":
                                begin
                                    AssignmentMemoMgt.ApproveRejectAssignmentmemo(RecRef.Field(1).Value, false);
                                end;
                            EmployeeActivityType::"Attribute Adjustment":
                                begin
                                    RecRef.Field(AttributeAdj.FieldNo("Approval Status")).Validate(ApprovalStatus::Rejected);
                                    RecRef.Modify();
                                end;
                        end;
                        OnAfterDocumentRejected(RecRef);
                        // Get the Rejected Status from Status Master
                        StatusMaster.Reset();
                        StatusMaster.SetRange(Rejected, true);
                        if StatusMaster.FindFirst() then begin
                            RecRef.Field(100).Validate(StatusMaster.Status);
                        end
                        else
                            Error('Rejected Status not Found On Status Master Setup');
                    end;

                    OnRejectDocumentOnBeforeRecRefModify(RecRef, Approved, SkipRecRefModifyOnReject, IsExit);
                    if not SkipRecRefModifyOnReject then begin
                        RecRef.Modify();
                        ApprovalHRMS.Modify();
                    end;
                    if IsExit then
                        exit;
                until ApprovalHRMS.Next() = 0;
                // Modify the record dynamically
            end;
            //Find next approval step
            if Approved then begin
                ApprovalHRMS2.Reset();
                ApprovalHRMS2.SetRange("Document No.", DocumentNo);
                ApprovalHRMS2.SetRange("Approval Sequence", ApprovalHRMS."Approval Sequence" + 1);
                if ApprovalHRMS2.FindSet() then begin
                    repeat
                        ApprovalHRMS2."Approval Status" := ApprovalHRMS2."Approval Status"::Open;
                        ApprovalHRMS2.Modify;
                    until ApprovalHRMS2.Next() = 0;
                    EmailMgt.SendMailFromTemplate(RecRef.Number(), EmployeeActivityType, ApprovalStatus::Pending, ApprovalHRMS2."Employee No", DocumentNo, Cancelled);//Email For Approver
                end
                else begin
                    // If no next approval step found then set the status to approved
                    if EmployeeActivityType = EmployeeActivityType::Retirement then
                        RecRef.Field(RetirementFund.FieldNo("Approval Status")).Validate(ApprovalStatus::Approved)
                    else if EmployeeActivityType = EmployeeActivityType::"Attribute Adjustment" then
                        RecRef.Field(AttributeAdj.FieldNo("Approval Status")).Validate(ApprovalStatus::Approved)
                    else begin
                        //old code
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
                                if RecRef.Field(39).value then
                                    TravelMgt.ApproveCancelTravelRequest(RecRef.Field(1).Value)
                                else
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
                                RetirementFund.Get(RecRef.RecordId);
                                //    HRMgt.ScreenRF(RetirementFund);
                                GetRetirementFund(RetirementFund);
                                RFContribution.SetRange("Document No.", DocumentNo);
                                RFContribution.SetRange("Employee No.", Fieldref3.Value());
                                RFContribution.ModifyAll("Approval Status", RFContribution."Approval Status"::Approved);
                            end;
                        EmployeeActivityType::"Late Attendance":
                            begin
                                AttendanceMgt.ApproveLateAttendance(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Leave Encashment":
                            begin
                                if RecRef.Field(39).value then
                                    leaveMgt.ApproveLeaveEncashRequest(RecRef.Field(LeaveEncahRequest.FieldNo("No.")).Value, true)
                                else
                                    leaveMgt.ApproveLeaveEncashRequest(RecRef.Field(LeaveEncahRequest.FieldNo("No.")).Value, false)
                            end;
                        EmployeeActivityType::"Allowance Assignment Memo", EmployeeActivityType::"Request Allowance", EmployeeActivityType::"Shift Assignment Memo":
                            begin
                                AssignmentMemoMgt.ApproveRejectAssignmentmemo(RecRef.Field(1).Value, true);
                            end;
                        EmployeeActivityType::"Attribute Adjustment":
                            begin
                                AttributeAdjustmentMgt.OnApprovalOfAttributeAdjustment(RecRef.Field(AttributeAdj.FieldNo("Document No.")).Value);
                            end;
                        EmployeeActivityType::Appraisal:
                            begin
                                AppraisalMgt.CalculateFinalMarks(RecRef.Field(1).Value);
                            end;
                    end;
                    OnAfterDocumentFinalApproved(RecRef);
                    EmailMgt.SendMailFromTemplate(RecRef.Number(), EmployeeActivityType, ApprovalStatus::Approved, '', DocumentNo, Cancelled);//Email For Requester
                end;
            end
            else begin
                //rejection case
                //reject all the approval for that document
                ApprovalHRMS.Reset();
                ApprovalHRMS.SetRange("Document No.", DocumentNo);
                ApprovalHRMS.SetRange("Document Type", EmployeeActivityType);
                if ApprovalHRMS.FindSet() then
                    repeat
                        if ApprovalHRMS."Approval Status" in [ApprovalHRMS."Approval Status"::Created, ApprovalHRMS."Approval Status"::Open, ApprovalHRMS."Approval Status"::Pending] then begin
                            ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Rejected);
                            ApprovalHRMS.Validate("Rejected By", HRMgt.GetEmpName());
                            ApprovalHRMS.Validate("Rejected By Code", HRMgt.GetEmployeeNo());
                            ApprovalHRMS.Modify();
                        end;
                    until ApprovalHRMS.Next() = 0;
                EmailMgt.SendMailFromTemplate(RecRef.Number(), EmployeeActivityType, ApprovalStatus::Rejected, '', DocumentNo, Cancelled);//Email for Requester
            end;
        end else
            Error('Document Status Must be in Pending');
    end;
#if SaasFeature
    procedure ApproveRejectDocument(var RecRef: RecordRef; Approved: Boolean; AccessToken: Code[60])//SAAS
    var
        ApprovalHRMS: Record "Approval HRMS";
        ApprovalHRMS2: Record "Approval HRMS";
        ApproveNotEligibleErrors: Label 'You are not Eligible to Approve or reject this document ';
        ApprovalStatusField: text;
        ApprovalStatus: Enum "Approval Status";
        EmployeeActivityType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
        FieldRef: FieldRef;
        Fieldref2: FieldRef;
        Fieldref3: FieldRef;
        DocumentNo: Code[20];
        RetirementFund: Record "Retirement Fund";
        LeaveEncahRequest: Record "Encashment Request";
        PayrollEngine: Codeunit "Payroll Engine";
        AttendanceMgt: Codeunit "Attendance Mgt";
        Cancelled: Boolean;
        RFContribution: Record "RF Contribution";
        SkipRecRefModifyOnReject: Boolean;
        IsExit: Boolean;
        AppraisalMgt: Codeunit "AppraisalMgt.";
    begin
        case RecRef.Number() of
            Database::"Retirement Fund":
                begin
                    FieldRef := RecRef.Field(RetirementFund.FieldNo("Approval Status"));
                    ApprovalStatusField := FieldRef.Value;
                    EmployeeActivityType := EmployeeActivityType::Retirement;
                    Fieldref2 := RecRef.Field(RetirementFund.FieldNo("No."));
                    DocumentNo := Fieldref2.Value();
                    Fieldref3 := RecRef.Field(RetirementFund.FieldNo("Employee No."));
                end;
            Database::"Encashment Request":
                begin
                    ApprovalStatusField := RecRef.Field(LeaveEncahRequest.FieldNo("Approval Status")).Value;
                    EmployeeActivityType := EmployeeActivityType::"Leave Encashment";
                    DocumentNo := RecRef.Field(LeaveEncahRequest.FieldNo("No.")).Value;
                end;
            Database::"Cancelled Document":
                begin
                    FieldRef := RecRef.Field(RetirementFund.FieldNo(Cancelled));
                    Cancelled := FieldRef.Value;
                end;
            else begin
                //old code
                ApprovalStatusField := Format((RecRef.Field(16)));
                EmployeeActivityType := RecRef.Field(2).Value;
                DocumentNo := RecRef.Field(1).Value;
            end;
        end;

        OnApproverejectDocumentOnBeforeCheckApprover(RecRef, EmployeeActivityType, DocumentNo, ApprovalStatusField);

        if ApprovalStatusField = Format(ApprovalStatus::Pending) then begin
            CheckApproverSaas(DocumentNo, GetApproverNoSAAS(AccessToken));
            ApprovalHRMS.Reset();
            ApprovalHRMS.SetRange("Document No.", DocumentNo);
            ApprovalHRMS.SetRange("Approval Status", ApprovalHRMS."Approval Status"::Open);
            if ApprovalHRMS.FindSet() then begin
                repeat
                    if Approved then begin
                        ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Approved);
                        ApprovalHRMS.Validate("Approved By", HRMgt.GetEmpNameSaas(GetApproverNoSAAS(AccessToken)));
                        RecRef.Field(100).Validate(ApprovalHRMS.Status);
                    end
                    else begin
                        ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Rejected);
                        ApprovalHRMS.Validate("Rejected By", HRMgt.GetEmpNameSaas(GetApproverNoSAAS(AccessToken)));
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
                                    // brfore sending approval
                                    RecRef.Field(RetirementFund.FieldNo("Approval Status")).Validate(ApprovalStatus::Rejected);
                                    RecRef.Modify();
                                    RFContribution.Reset();
                                    RFContribution.SetRange("Document No.", DocumentNo);
                                    RFContribution.ModifyAll("Approval Status", RFContribution."Approval Status"::Rejected);
                                end;
                            EmployeeActivityType::"Leave Encashment":
                                RecRef.Field(LeaveEncahRequest.FieldNo("Approval Status")).Validate(ApprovalStatus::Rejected);

                            EmployeeActivityType::"Allowance Assignment Memo", EmployeeActivityType::"Request Allowance", EmployeeActivityType::"Shift Assignment Memo":
                                begin
                                    AssignmentMemoMgt.ApproveRejectAssignmentmemo(RecRef.Field(1).Value, false);
                                end;
                        end;
                        OnAfterDocumentRejected(RecRef);
                        // Get the Rejected Status from Status Master
                        StatusMaster.Reset();
                        StatusMaster.SetRange(Rejected, true);
                        if StatusMaster.FindFirst() then begin
                            RecRef.Field(100).Validate(StatusMaster.Status);
                        end
                        else
                            Error('Rejected Status not Found On Status Master Setup');
                    end;

                    OnRejectDocumentOnBeforeRecRefModify(RecRef, Approved, SkipRecRefModifyOnReject, IsExit);
                    if not SkipRecRefModifyOnReject then begin
                        RecRef.Modify();
                        ApprovalHRMS.Modify();
                    end;
                    if IsExit then
                        exit;
                until ApprovalHRMS.Next() = 0;
                // Modify the record dynamically
            end;
            //Find next approval step
            if Approved then begin
                ApprovalHRMS2.Reset();
                ApprovalHRMS2.SetRange("Document No.", DocumentNo);
                ApprovalHRMS2.SetRange("Approval Sequence", ApprovalHRMS."Approval Sequence" + 1);
                if ApprovalHRMS2.FindSet() then begin
                    repeat
                        ApprovalHRMS2."Approval Status" := ApprovalHRMS2."Approval Status"::Open;
                        ApprovalHRMS2.Modify;
                    until ApprovalHRMS2.Next() = 0;
                    EmailMgt.SendMailFromTemplate(RecRef.Number(), EmployeeActivityType, ApprovalStatus::Pending, ApprovalHRMS2."Employee No", DocumentNo, Cancelled);//Email For Approver
                end
                else begin
                    // If no next approval step found then set the status to approved
                    if EmployeeActivityType = EmployeeActivityType::Retirement then begin
                        RecRef.Field(RetirementFund.FieldNo("Approval Status")).Validate(ApprovalStatus::Approved);
                        // RecRef.SetTable(RetirementFund);
                        // GetRetirementFund(RetirementFund);
                    end
                    else begin
                        //old code
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
                                RetirementFund.Get(RecRef.RecordId);
                                //    HRMgt.ScreenRF(RetirementFund);
                                GetRetirementFund(RetirementFund);
                                RFContribution.SetRange("Document No.", DocumentNo);
                                RFContribution.SetRange("Employee No.", Fieldref3.Value());
                                RFContribution.ModifyAll("Approval Status", RFContribution."Approval Status"::Approved);
                            end;
                        EmployeeActivityType::"Late Attendance":
                            begin
                                AttendanceMgt.ApproveLateAttendance(RecRef.Field(1).Value);
                            end;
                        EmployeeActivityType::"Leave Encashment":
                            begin
                                if RecRef.Field(39).value then
                                    leaveMgt.ApproveLeaveEncashRequest(RecRef.Field(LeaveEncahRequest.FieldNo("No.")).Value, true)
                                else
                                    leaveMgt.ApproveLeaveEncashRequest(RecRef.Field(LeaveEncahRequest.FieldNo("No.")).Value, false)
                            end;
                        EmployeeActivityType::"Allowance Assignment Memo", EmployeeActivityType::"Request Allowance", EmployeeActivityType::"Shift Assignment Memo":
                            begin
                                AssignmentMemoMgt.ApproveRejectAssignmentmemo(RecRef.Field(1).Value, true);
                            end;
                        EmployeeActivityType::Appraisal:
                            begin
                                AppraisalMgt.CalculateFinalMarks(RecRef.Field(1).Value);
                            end;
                    end;
                    OnAfterDocumentFinalApproved(RecRef);
                    EmailMgt.SendMailFromTemplate(RecRef.Number(), EmployeeActivityType, ApprovalStatus::Approved, '', DocumentNo, Cancelled);//Email For Requester
                end;
            end
            else begin
                //rejection case
                //reject all the approval for that document
                ApprovalHRMS.Reset();
                ApprovalHRMS.SetRange("Document No.", DocumentNo);
                ApprovalHRMS.SetRange("Document Type", EmployeeActivityType);
                if ApprovalHRMS.FindSet() then
                    repeat
                        if ApprovalHRMS."Approval Status" in [ApprovalHRMS."Approval Status"::Created, ApprovalHRMS."Approval Status"::Open, ApprovalHRMS."Approval Status"::Pending] then begin
                            ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Rejected);
                            ApprovalHRMS.Validate("Rejected By", HRMgt.GetEmpNameSaas(GetApproverNoSAAS(AccessToken)));
                            ApprovalHRMS.Modify();
                        end;
                    until ApprovalHRMS.Next() = 0;
                EmailMgt.SendMailFromTemplate(RecRef.Number(), EmployeeActivityType, ApprovalStatus::Rejected, '', DocumentNo, Cancelled);//Email for Requester
            end;
        end else
            Error('Document Status Must be in Pending');
    end;
#endif

    procedure CheckRequester(EmpActNo: Code[20])//onprem
    begin
        CheckRequester(EmpActNo, HRMgt.GetEmployeeNo());
    end;

    procedure CheckRequester(EmpActNo: Code[20]; empno: code[20])//saas
    var
        ApprovalLine: Record "Approval HRMS";
        ApproveNotEligibleError: Label 'You are not Eligible to WithDraw this document ';
    begin
        ApprovalLine.SetRange("Document No.", EmpActNo);
        ApprovalLine.SetRange("Employee No", empno);
        if not ApprovalLine.Findfirst() then
            Error(ApproveNotEligibleError);
    end;

    procedure CheckRequesterBoolean(EmpActNo: Code[20]): Boolean
    var
        ApprovalLine: Record "Approval HRMS";
    begin
        ApprovalLine.SetRange("Document No.", EmpActNo);
        ApprovalLine.SetRange("Employee No", HRMgt.GetEmployeeNo());
        if not ApprovalLine.IsEmpty() then
            exit(true);
    end;

    procedure CheckRequesterSAAS(EmpActNo: Code[20]; ApproverNo: code[20])
    var
        ApprovalLine: Record "Approval HRMS";
        ApproveNotEligibleError: Label 'You are not Eligible to WithDraw this document ';
    begin
        ApprovalLine.Reset();
        ApprovalLine.SetRange("Document No.", EmpActNo);
        ApprovalLine.SetRange("Employee No", ApproverNo);
        if not ApprovalLine.Findfirst() then
            Error(ApproveNotEligibleError);
    end;

    local procedure GetRetirementFund(RetirementFund: Record "Retirement Fund")
    var
        RFContributionLine: Record "RF Contribution";
        PayrollAttributeUsgae: Record "Payroll Attributes Usage";
        PayrollLine: Record "Payroll Line";
    begin
        RFContributionLine.SetRange("Document No.", RetirementFund."No.");
        RFContributionLine.SetRange("Employee No.", RetirementFund."Employee No.");
        if RFContributionLine.FindFirst() then
            case RFContributionLine.Type of
                RFContributionLine.Type::Manual, RFContributionLine.Type::Optimum:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end;
                    end;
                RFContributionLine.Type::Fixed:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae.Amount := RFContributionLine.Amount;
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end else begin
                            PayrollAttributeUsgae.Init();
                            PayrollAttributeUsgae.Validate("Employee Code", RetirementFund."Employee No.");
                            PayrollAttributeUsgae.Validate(Code, RFContributionLine."Attribute Code");
                            PayrollAttributeUsgae.Validate(Amount, RFContributionLine.Amount);
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            if PayrollAttributeUsgae.Insert() then;
                        end;
                    end;
                RFContributionLine.Type::Percent:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae.Amount := PayrollLine.GetAmountRFContribution(RetirementFund."Employee No.") * RFContributionLine.Amount / 100;
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end else begin
                            PayrollAttributeUsgae.Init();
                            PayrollAttributeUsgae.Validate("Employee Code", RetirementFund."Employee No.");
                            PayrollAttributeUsgae.Validate(Code, RFContributionLine."Attribute Code");
                            PayrollAttributeUsgae.Validate(Amount, PayrollLine.GetAmountRFContribution(RetirementFund."Employee No.") * RFContributionLine.Amount / 100);
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            if PayrollAttributeUsgae.Insert() then;
                        end;
                    end;
            end;
    end;

    procedure CheckDocumentForWithdraw(EmpActType: enum "Employee Activity Type"; DocNo: Code[20])
    var
        ApprovalHRMS: Record "Approval HRMS";
    begin
        ApprovalHRMS.SetLoadFields("Approval Status");
        ApprovalHRMS.SetRange("Document Type", EmpActType);
        ApprovalHRMS.SetRange("Document No.", DocNo);
        ApprovalHRMS.SetFilter("Approval Status", '<>%1|<>2', ApprovalHRMS."Approval Status"::Created, ApprovalHRMS."Approval Status"::Open);
        if ApprovalHRMS.Count > 0 then
            Error('You cannot withdraw as document already in the process of approval');
    end;
    // >>  WithDraw Document Dynamically using RecRef>> Santosh 2025-04-21 >>
    procedure WithDrawRequest(var RecRef: RecordRef) //onprem
    var
        Approver: Record "Approval HRMS";
        ApprovalStatusField: text;
        ApprovalStatusEnum: Enum "Approval Status";
        EmpActType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
        RetirementFund: Record "Retirement Fund";
        AttributeAdj: Record "Attribute Adjustment Header";
        DocNumber: code[20];
    begin
        // Get the fields dynamically using FieldRef
        case RecRef.Number() of
            Database::"Retirement Fund":
                begin
                    ApprovalStatusField := Format((RecRef.Field(RetirementFund.FieldNo("Approval Status"))));
                    EmpActType := EmpActType::Retirement;
                    DocNumber := RecRef.Field(RetirementFund.FieldNo("No.")).Value;
                end;
            Database::"Attribute Adjustment Header":
                begin
                    ApprovalStatusField := RecRef.Field(AttributeAdj.FieldNo("Approval Status")).Value;
                    EmpActType := EmpActType::"Attribute Adjustment";
                    DocNumber := RecREf.Field(AttributeAdj.FieldNo("Document No.")).Value
                end;
            else begin
                //old code
                ApprovalStatusField := Format((RecRef.Field(16)));
                EmpActType := RecRef.Field(2).Value;
                DocNumber := RecRef.Field(1).Value;
            end;
        end;
        if ApprovalStatusField = Format(ApprovalStatusEnum::Pending) then begin
            CheckRequester(DocNumber);
            CheckFirstApproverSequence(DocNumber);
            Approver.Reset();
            Approver.SetRange("Document No.", DocNumber);
            if Approver.Findset() then begin
                repeat
                    Approver.Validate("Approval Status", Approver."Approval Status"::Withdrawn);
                    Approver.Modify();
                until Approver.Next() = 0;
                // Get the withDraw Status from Status Master
                if EmpActType = EmpActType::Retirement then
                    RecRef.Field(RetirementFund.FieldNo("Approval Status")).Validate(ApprovalStatusEnum::Withdrawn)
                else
                    RecRef.Field(16).Validate(ApprovalStatusEnum::Withdrawn); // Modify the record dynamically
                RecRef.Modify();
                StatusMaster.Reset();
                StatusMaster.SetRange(withdraw, true);
                if StatusMaster.FindFirst() then begin
                    if EmpActType <> EmpActType::Retirement then
                        RecRef.Field(100).Validate(StatusMaster.Status);
                    RecRef.Modify();
                end else
                    Error('withdraw Status not Found On Status Master Setup');
            end;
        end else
            Error('Document Status Must be in Pending');
    end;

#if SaasFeature
    procedure WithDrawRequest(var RecRef: RecordRef; AccessToken: code[60]) //SAAS
    var
        Approver: Record "Approval HRMS";
        ApprovalStatusField: text;
        ApprovalStatusEnum: Enum "Approval Status";
        EmpActType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
        RetirementFund: Record "Retirement Fund";
        DocNumber: code[20];
    begin
        // Get the fields dynamically using FieldRef
        case RecRef.Number() of
            Database::"Retirement Fund":
                begin
                    ApprovalStatusField := Format((RecRef.Field(RetirementFund.FieldNo("Approval Status"))));
                    EmpActType := EmpActType::Retirement;
                    DocNumber := RecRef.Field(RetirementFund.FieldNo("No.")).Value;
                end;
            else begin
                //old code
                ApprovalStatusField := Format((RecRef.Field(16)));
                EmpActType := RecRef.Field(2).Value;
                DocNumber := RecRef.Field(1).Value;
            end;
        end;
        if ApprovalStatusField = Format(ApprovalStatusEnum::Pending) then begin
            CheckRequesterSAAS(DocNumber, GetApproverNoSAAS(AccessToken));
            CheckFirstApproverSequence(DocNumber);
            Approver.Reset();
            Approver.SetRange("Document No.", DocNumber);
            if Approver.Findset() then begin
                repeat
                    Approver.Validate("Approval Status", Approver."Approval Status"::Withdrawn);
                    Approver.Modify();
                until Approver.Next() = 0;
                // Get the withDraw Status from Status Master
                if EmpActType = EmpActType::Retirement then
                    RecRef.Field(RetirementFund.FieldNo("Approval Status")).Validate(ApprovalStatusEnum::Withdrawn)
                else
                    RecRef.Field(16).Validate(ApprovalStatusEnum::Withdrawn); // Modify the record dynamically
                RecRef.Modify();
                StatusMaster.Reset();
                StatusMaster.SetRange(withdraw, true);
                if StatusMaster.FindFirst() then begin
                    if EmpActType <> EmpActType::Retirement then
                        RecRef.Field(100).Validate(StatusMaster.Status);
                    RecRef.Modify();
                end else
                    Error('withdraw Status not Found On Status Master Setup');
            end;
        end else
            Error('Document Status Must be in Pending');
    end;
#endif

    // >>  WithDraw Document Dynamically using RecRef>> Santosh 2025-04-21 >>
    procedure WithDrawRequestAPI(documentNo: Code[20]; EmpActType: Text)//onprem
    var
        EmpActTypeEnum: Enum "Employee Activity Type";
        Leave: Record Leave;
        TravelRequest, TravelRequest2 : Record "Travel Request";
        RecRef: RecordRef;
        RetirementFund: Record "Retirement Fund";
        AttendanceMissed: Record "Attendance Missed";
        EncashmentRequest: Record "Encashment Request";
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
                    if not TravelRequest.Get(documentNo) then
                        exit;
                    RecRef.GetTable(TravelRequest);
                    WithDrawRequest(RecRef);
                    if TravelRequest."Travel Order No." <> '' then
                        if TravelRequest2.Get(TravelRequest."Travel Order No.") then begin
                            TravelRequest2.Extended := false;
                            TravelRequest2.Modify();
                        end;
                end;

            EmpActTypeEnum::Retirement:
                begin
                    if RetirementFund.Get(documentNo) then begin
                        RecRef.GetTable(RetirementFund);
                        WithDrawRequest(RecRef);
                    end;
                end;
            EmpActTypeEnum::"Attendance Missed", EmpActTypeEnum::"Late Attendance":
                begin
                    if AttendanceMissed.Get(documentNo) then begin
                        RecRef.GetTable(AttendanceMissed);
                        WithDrawRequest(RecRef);
                    end;
                end;
            EmpActTypeEnum::"Leave Encashment":
                if EncashmentRequest.Get(documentNo) then begin
                    RecRef.GetTable(EncashmentRequest);
                    WithDrawRequest(RecRef);
                end;
        end;
        OnAfterOtherDocumentType(documentNo, EmpActTypeEnum);
    end;

#if SaasFeature
    procedure WithDrawRequestAPI(documentNo: Code[20]; EmpActType: Text; AccessToken: code[60]) //SAAS
    var
        EmpActTypeEnum: Enum "Employee Activity Type";
        Leave: Record Leave;
        TravelRequest: Record "Travel Request";
        RecRef: RecordRef;
        RetirementFund: Record "Retirement Fund";
        AttendanceMissed: Record "Attendance Missed";
        EncashmentRequest: Record "Encashment Request";
        OvertimeRequest: Record OverTime;
    begin
        EmpActTypeEnum := Enum::"Employee Activity Type".FromInteger(EmpActTypeEnum.Ordinals.Get(EmpActTypeEnum.Names.IndexOf(EmpActType)));
        case EmpActTypeEnum of
            //for leave
            EmpActTypeEnum::"Leave Request":
                begin
                    if Leave.Get(documentNo) then begin
                        RecRef.GetTable(Leave);
                        WithDrawRequest(RecRef, AccessToken);
                    end;
                end;
            //Travel Request
            EmpActTypeEnum::"Travel Request":
                begin
                    if TravelRequest.Get(documentNo) then begin
                        RecRef.GetTable(TravelRequest);
                        WithDrawRequest(RecRef, AccessToken);
                    end;
                end;
            EmpActTypeEnum::Retirement:
                begin
                    if RetirementFund.Get(documentNo) then begin
                        RecRef.GetTable(RetirementFund);
                        WithDrawRequest(RecRef, AccessToken);
                    end;
                end;
            EmpActTypeEnum::"Attendance Missed", EmpActTypeEnum::"Late Attendance":
                begin
                    if AttendanceMissed.Get(documentNo) then begin
                        RecRef.GetTable(AttendanceMissed);
                        WithDrawRequest(RecRef, AccessToken);
                    end;
                end;
            EmpActTypeEnum::"Leave Encashment":
                if EncashmentRequest.Get(documentNo) then begin
                    RecRef.GetTable(EncashmentRequest);
                    WithDrawRequest(RecRef, AccessToken);
                end;
            EmpActTypeEnum::Overtime:
                if OvertimeRequest.Get(documentNo) then begin
                    RecRef.GetTable(OvertimeRequest);
                    WithDrawRequest(RecRef, AccessToken);
                end;
        end;
        OnAfterOtherDocumentTypeSAAS(documentNo, EmpActTypeEnum, AccessToken);
    end;
#endif

    // >>  Reopen Document Dynamically using RecRef>> Santosh 2025-10-29 >>
    procedure ReopenDocument(var RecRef: RecordRef)
    var
        Approver: Record "Approval HRMS";
        ApprovalStatusField: text;
        ApprovalStatusEnum: Enum "Approval Status";
        EmpActType: Enum "Employee Activity Type";
        AttributeAdj: Record "Attribute Adjustment Header";
        DocNumber: code[20];
    begin
        // Get the fields dynamically using FieldRef
        case RecRef.Number of
            Database::"Attribute Adjustment Header":
                begin
                    ApprovalStatusField := RecRef.Field(AttributeAdj.FieldNo("Approval Status")).Value;
                    EmpActType := EmpActType::"Attribute Adjustment";
                    DocNumber := RecRef.Field(AttributeAdj.FieldNo("Document No.")).Value;
                end;
            else begin
                ApprovalStatusField := Format((RecRef.Field(16)));
                EmpActType := RecRef.Field(2).Value;
                DocNumber := RecRef.Field(1).Value;
            end;
        end;

        if ApprovalStatusField in [Format(ApprovalStatusEnum::Pending), Format(ApprovalStatusEnum::Released)] then begin
            if not (CheckApproverBoolean(DocNumber) or CheckRequesterBoolean(DocNumber)) then
                Error('Not eligible to re-open the document.');
            if ApprovalStatusField = Format(ApprovalStatusEnum::Pending) then
                CheckFirstApproverSequence(DocNumber);
            Approver.Reset();
            Approver.SetRange("Document No.", DocNumber);
            Approver.SetRange("Approval Sequence", 1);
            if Approver.Findset() then begin
                repeat
                    Approver.Validate("Approval Status", Approver."Approval Status"::Created);
                    Approver.Modify();
                until Approver.Next() = 0;
                if EmpActType = EmpActType::"Attribute Adjustment" then
                    RecRef.Field(AttributeAdj.FieldNo("Approval Status")).Validate(ApprovalStatusEnum::Open)
                else
                    RecRef.Field(16).Validate(ApprovalStatusEnum::Open); // Modify the record dynamically
                RecRef.Modify();
                OnAfterReOpenDocument(RecRef);
            end;
        end else
            Error('Document status must be in Pending.');
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

    procedure CheckFirstApproverSequence(DocNo: Code[20]): Boolean
    var
        Approver: Record "Approval HRMS";
    begin
        Approver.Reset();
        Approver.SetRange("Document No.", DocNo);
        Approver.SetRange("Approval Status", Approver."Approval Status"::Open);
        Approver.SetRange("Approval Sequence", 1);
        if not Approver.FindFirst() then
            Error('Document is approved by 1 or more Approver');
    end;

    procedure UpdateFirstApproverStatus(DocNo: Code[20]): Boolean
    var
        Approver: Record "Approval HRMS";
    begin
        Approver.Reset();
        Approver.SetRange("Document No.", DocNo);
        Approver.SetRange("Approval Sequence", 1);
        if Approver.FindSet() then
            repeat
                Approver.Validate("Approval Status", Approver."Approval Status"::Open);
                Approver.Modify();
            until Approver.Next() = 0;
    end;
    //>> Approve Reject Document Dynamically using RecRef>> Santosh 2025-03-04 >>
    procedure ApproveJournalDocument(EmpActNo: Code[20]; Approved: Boolean)
    var
        EmployeeActivityJournal: Record "Employee Activity Journal";
        Approver: Record "Approval HRMS";
        Approver2: Record "Approval HRMS";
        // ApprovalStatusField: text;
        ApprovalStatusEnum: Enum "Approval Status";
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
                        Approver.Validate("Approved By Code", HRMgt.GetEmployeeNo());
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

    procedure GenerateApprovalEntry(
        EmpActType: Enum "Employee Activity Type";
                        EmpActNo: Code[20];
                        ApproverNo: Code[20];
                        ApprovalSequence: Integer;
                        StatusText: Text[20];
                        ApproverRole: Code[20];
                        ApprovalStatus: Enum "Approval Status";
                        EmployeeNo: Code[20];
                        LoanType: Enum "Loan Type";
                        Cancelled: Boolean;
                        ApprovalSetUpLine: Record "Approval Setup Line"
    ): Integer
    var
        Approval: Record "Approval HRMS";
    begin
        Approval.Init();
        Approval.Validate("Document No.", EmpActNo);
        Approval.Validate("Document Type", EmpActType);
        Approval.Validate("Approver No", ApproverNo);
        Approval.Validate("Approval Sequence", ApprovalSequence);
        Approval.Validate(Status, StatusText);
        Approval.Validate("Approval Role", ApproverRole);
        if LoanType <> LoanType::" " then
            Approval.Validate("Loan Type", LoanType);
        Approval.Validate(Cancelled, Cancelled);
        if ApprovalSequence = 1 then begin
            if ApprovalStatus <> ApprovalStatus::" " then begin
                if ApprovalStatus = ApprovalStatus::Pending then
                    Approval.Validate("Approval Status", "Approval Status"::Open);
                if ApprovalStatus = ApprovalStatus::Open then
                    Approval.Validate("Approval Status", "Approval Status"::Created);
            end
            else
                Approval.Validate("Approval Status", "Approval Status"::Open);
        end else
            Approval.Validate("Approval Status", "Approval Status"::Created);  //if sequence > 1
        Approval.Validate("Employee No", EmployeeNo);
        Approval.Validate("Alternative Approval Workflow", ApprovalSetUpLine."Alternative Approval Workflow");
        Approval.Insert(true);
        if ApprovalSequence = 1 then
            exit(1)
        else
            exit(0)
    end;

    procedure InsertApprovalWithRecordref(EmployeeNo: Code[20];
                              EmpActNo: Code[20];
                              EmpActType: enum "Employee Activity Type";
                                              ApprovalStatus: Enum "Approval Status";
                                              RecordRef: RecordRef)

    var
        ApprovalSetup: Record "Approval Setup";
        ApprovalSetupLine: Record "Approval Setup line";
        Employee: Record Employee;
        EmpRequest: Record Employee;
        Approval1: Record "Approval HRMS";
        SequenceOneCount, ApprovalEntryCount : Integer;
        isHandled, SkipError : Boolean;
        PerSequenceCount: array[10] of Integer;
    begin
        EmpRequest.Get(EmployeeNo);

        //if employee is a manual approver
        if EmpRequest."Manual Approver User" then begin
            IsManualApproverWorkflow(EmployeeNo, EmpActNo, EmpActType, ApprovalStatus, IsHandled);
            if IsHandled then
                exit;
        end;

        //if employee is not manual approver
        if not isHandled then begin
            ApprovalSetupLine.Reset();
            ApprovalSetupLine.SetRange("Request Type", EmpActType);
            ApprovalSetupLine.SetFilter("Deputation On", '%1|%2', EmpRequest."Deputation on"::" ", EmpRequest."Deputation On");
            ApprovalSetupLine.SetRange("Employee Role", EmpRequest."Approver Role");
            ApplyAllowanceFilter(ApprovalSetupLine, EmpActType, RecordRef);
            SequenceOneCount := 0;
            GetPerSequenceApproval(ApprovalSetupLine, PerSequenceCount);
            if ApprovalSetupLine.Findset() then begin
                repeat
                    IsValidApprovalSetupLine(ApprovalSetupLine, EmpRequest, RecordRef);
                    ApprovalSetup.Get(ApprovalSetupLine."Request Type", ApprovalSetupLine."Deputation On");

                    Employee.Reset();
                    Employee.SetRange(Status, Employee.Status::Active);
                    Employee.SetFilter("NAV Login ID", '<>%1', '');
                    OnInsertApprovalOnBeforeSelectApprover(ApprovalSetupLine, Employee, EmpRequest, IsHandled);
                    if not isHandled then begin
                        case ApprovalSetupLine."Deputation Type" of
                            ApprovalSetupLine."Deputation Type"::Province:
                                Employee.SetRange("Province Code", EmpRequest."Province Code");
                            ApprovalSetupLine."Deputation Type"::Branch:
                                begin
                                    Employee.SetRange("Branch Code", EmpRequest."Branch Code");
                                end;
                            ApprovalSetupLine."Deputation Type"::Department:
                                begin
                                    Employee.SetRange("Branch Code", EmpRequest."Branch Code");
                                    Employee.SetRange("Department Code", EmpRequest."Department Code");
                                end;
                            ApprovalSetupLine."Deputation Type"::Unit:
                                begin
                                    Employee.SetRange("Branch Code", EmpRequest."Branch Code");
                                    Employee.SetRange("Department Code", EmpRequest."Department Code");
                                    Employee.SetRange("Union Code", EmpRequest."Unit Code");
                                end;
                        end;
                    end;
                    Employee.SetRange("Approver Role", ApprovalSetupLine."Approver Role");
                    if Employee.FindSet() then begin
                        if ApprovalSetup."Approval Entry Creation Policy" = ApprovalSetup."Approval Entry Creation Policy"::"Everyone in Role" then
                            ApprovalEntryCount := Employee.Count
                        else
                            ApprovalEntryCount := 1;
                        repeat
                            SequenceOneCount := SequenceOneCount + GenerateApprovalEntry(
                                 EmpActType,
                                 EmpActNo,
                                 Employee."No.",
                                 ApprovalSetupLine."Approval Sequence",
                                 ApprovalSetupLine."Approval Status",
                                 ApprovalSetupLine."Approver Role",
                                 ApprovalStatus,
                                 EmployeeNo,
                                 Enum::"Loan Type"::" ",
                                 false,
                                 ApprovalSetupLine
                             );
                            ApprovalEntryCount -= 1;
                        until (Employee.Next() = 0) or (ApprovalEntryCount = 0);
                    end
                    else
                        if ApprovalSetup."Approval Sending Policy" = ApprovalSetup."Approval Sending Policy"::"All Approver Role Mandatory" then
                            Error('Approvers not found for %1 Role', ApprovalSetupLine."Approver Role");

                until ApprovalSetupLine.Next() = 0;

                if ApprovalSetup."Approval Sending Policy" = ApprovalSetup."Approval Sending Policy"::"At Least One Role Per Sequence Mandatory" then
                    CheckAndValidatePerSequenceApproval(EmpActNo, PerSequenceCount);
            end
            else
                Error('Approval Setup not found');

            if SequenceOneCount = 0 then
                Error('There is no approver setup for sequence 1');

            Approval1.Reset();
            Approval1.SetRange("Document No.", EmpActNo);
            if not Approval1.FindFirst() then
                Error('Approval Not Found');
        end;
    end;

    procedure IsValidApprovalSetupLine(ApprovalSetupLine: Record "Approval Setup Line"; EmpRequest: Record Employee; RecordRef: RecordRef): Boolean
    var
        AssignmentmemoHdr: Record "Assignment Memo Header";
        PayrollAttrCode: Code[20];
        PayrollAttribute: Record "Payroll Attributes";
    begin
        case RecordRef.Number of
            database::"Assignment Memo Header":
                begin
                    if ApprovalSetupLine."Request Type" = ApprovalSetupLine."Request Type"::"Request Allowance" then
                        if ApprovalSetupLine."Payroll Filter" = '' then
                            exit(true)
                        else if ApprovalSetupLine."Payroll Filter" <> '' then begin
                            //check for valid payroll filter
                            PayrollAttrCode := RecordRef.Field(AssignmentmemoHdr.FieldNo("Payroll Attribute Code")).Value;
                            PayrollAttribute.setloadfields(Code);
                            PayrollAttribute.SetRange(Code, PayrollAttrCode);
                            PayrollAttribute.setfilter(code, ApprovalSetupLine."Payroll Filter");
                            if not PayrollAttribute.IsEmpty() then
                                exit(true)
                            else
                                exit(false);
                        end;
                end;
            else
                exit(true)
        end;
    end;

    procedure ApplyAllowanceFilter(var ApprovalSetupLine: Record "Approval Setup Line"; var EmpActType: Enum "Employee Activity Type"; var Recordref: RecordRef)
    var
        PayrollAttrCode: Code[20];
        AssignmentmemoHdr: Record "Assignment Memo Header";
    begin
        if EmpActType = EmpActType::"Request Allowance" then begin

            PayrollAttrCode := RecordRef.Field(AssignmentmemoHdr.FieldNo("Payroll Attribute Code")).Value;
            ApplyAllowanceFilterCode(ApprovalSetupLine, EmpActType, PayrollAttrCode);
        end;
    end;

    procedure ApplyAllowanceFilterCode(var ApprovalSetupLine: Record "Approval Setup Line"; var EmpActType: Enum "Employee Activity Type"; var PayrollAttrCode: Code[20])
    begin
        if PayrollAttrCode = '' then
            exit;

        if ApprovalSetupLine.FindSet() then
            repeat
                if CheckIfValueexistInPipedValue(ApprovalSetupLine."Payroll Filter", PayrollAttrCode) or (ApprovalSetupLine."Payroll Filter" = '') then
                    ApprovalSetupLine.Mark(true);
            until ApprovalSetupLine.Next() = 0;
        ApprovalSetupLine.MarkedOnly(true);
    end;

    procedure CheckIfValueexistInPipedValue(PipedValues: Text; targetValue: text): Boolean
    var
    begin
        exit(StrPos('|' + PipedValues + '|', '|' + targetValue + '|') > 0);
    end;

    procedure HasOpenApprovalEntries(DocumentNo: Code[20]): Boolean
    var
        ApprovalEntry: Record "Approval HRMS";
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange("Approval Status", ApprovalEntry."Approval Status"::Open);
        if ApprovalEntry.IsEmpty() then
            exit(false);

        exit(true);
    end;

    procedure HasOpenApprovalEntriesForCurrentUser(DocumentNo: Code[20]; EmployeeNo: Code[20]): Boolean
    var
        ApprovalEntry: Record "Approval HRMS";
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange("Approval Status", ApprovalEntry."Approval Status"::Open);
        ApprovalEntry.SetRange("Approver No", EmployeeNo);
        if ApprovalEntry.IsEmpty then
            exit(false);
        exit(not ApprovalEntry.IsEmpty);
    end;

    procedure GetPerSequenceApproval(var ApprovalSetupLine: Record "Approval Setup Line"; var SequenceNoCount: array[10] of Integer): Integer
    begin
        ApprovalSetupLine.SetCurrentKey("Approval Sequence");
        ApprovalSetupLine.SetAscending("Approval Sequence", true);
        if ApprovalSetupLine.FindSet() then
            repeat
                case ApprovalSetupLine."Approval Sequence" of
                    1:
                        SequenceNoCount[1] += 1;
                    2:
                        SequenceNoCount[2] += 1;
                    3:
                        SequenceNoCount[3] += 1;
                    4:
                        SequenceNoCount[4] += 1;
                    5:
                        SequenceNoCount[5] += 1;
                    6:
                        SequenceNoCount[6] += 1;
                    7:
                        SequenceNoCount[7] += 1;
                    8:
                        SequenceNoCount[8] += 1;
                    9:
                        SequenceNoCount[9] += 1;
                    10:
                        SequenceNoCount[10] += 1;

                end;
            until ApprovalSetupLine.Next() = 0;
    end;

    procedure CheckAndValidatePerSequenceApproval(docNo: Code[20]; var SequenceNoCount: array[10] of Integer)
    var
        ApprovalEntry: Record "Approval HRMS";
        seqNo: Integer;
    begin
        for seqNo := 1 to ArrayLen(SequenceNoCount) do begin
            if SequenceNoCount[seqNo] = 0 then
                exit;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", docNo);
            ApprovalEntry.SetRange("Approval Sequence", seqNo);
            if ApprovalEntry.IsEmpty() then
                Error('Approver not found for sequence %1', seqNo);
        end;
    end;

    procedure ApproveResignClerance(var DocApprover: Record "Document Approver"; Approved: Boolean)
    var
        DocumentApprover, DocumentApproverCheck : Record "Document Approver";
        ApprovalStatusEnum: Enum "Approval Status";
        IsHandled: Boolean;
    begin
        if not CheckDocumentApprover(DocApprover."Document No.") then
            Error('You are not Eligible To Approve');
        if Approved then begin
            DocumentApprover.Reset();
            DocumentApprover.SetRange("Document No.", DocApprover."Document No.");
            DocumentApprover.SetRange("Approver Sequence", DocApprover."Approver Sequence");
            DocumentApprover.SetRange("Approval Status", DocApprover."Approval Status"::Open);
            if DocumentApprover.FindSet() then
                repeat
                    DocumentApprover.Validate("Approval Status", DocumentApprover."Approval Status"::Approved);
                    DocumentApprover.Validate("Approved By", HRMgt.GetEmployeeNo());
                    DocumentApprover.Validate("Approved Date", Today);
                    DocumentApprover.Modify();
                until DocumentApprover.Next() = 0;

            OnBeforeIncrementOfApproverSequence(DocumentApproverCheck, DocumentApprover, IsHandled);
            if not IsHandled then begin
                DocumentApproverCheck.SetRange("Document No.", DocApprover."Document No.");
                DocumentApproverCheck.SetRange("Approver Sequence", DocumentApprover."Approver Sequence" + 1);
                if DocumentApproverCheck.FindSet() then begin
                    repeat
                        DocumentApproverCheck."Approval Status" := DocumentApproverCheck."Approval Status"::Open;
                        DocumentApproverCheck.Modify;
                    until DocumentApproverCheck.Next() = 0;
                end;
            end;
        end
    end;

    procedure CheckDocumentApprover(DocumentNO: Code[20]): Boolean
    var
        DocumentApprover: Record "Document Approver";
    begin
        DocumentApprover.Reset;
        DocumentApprover.SetRange("Document No.", DocumentNO);
        DocumentApprover.SetRange("Employee No.", HRMgt.GetEmployeeNo());
        DocumentApprover.SetRange("Approval Status", DocumentApprover."Approval Status"::Open);
        exit(DocumentApprover.FindFirst());

    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertApprovalOnBeforeSelectApprover(var ApprovalSetupLine: Record "Approval Setup Line";
                                                var Employee: Record Employee; var EmpRequest: Record employee; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertApprovaCancelledOnSelectApprover(var ApprovalSetupLine: Record "Approval Setup Line";
                                                var Employee: Record Employee; var EmpRequest: Record employee; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertApprovalOnFilterApprovalSetupLine(var ApprovalSetupLine: Record "Approval Setup Line"; var EmpActType: Enum "Employee Activity Type"; var EmpActNo: Code[20]; var EmployeeNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertApprovalCancelledOnFilterApprovalSetupLine(var ApprovalSetupLine: Record "Approval Setup Line"; var EmpActType: Enum "Employee Activity Type")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure IsmanualApproverworkflow(EmployeeNo: Code[20]; EmpActNo: Code[20]; EmpActType: enum "Employee Activity Type"; ApprovalStatus: Enum "Approval Status"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterDocumentFinalApproved(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterDocumentRejected(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSkipEmployeeError(var SKipError: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApproverejectDocumentOnBeforeCheckApprover(var RecRef: RecordRef; var EmployeeActivityType: Enum "Employee Activity Type"; var DocumentNo: Code[20]; var ApprovalStatusField: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRejectDocumentOnBeforeRecRefModify(var RecRef: RecordRef; var Approved: Boolean; var SkipRecRefModifyOnReject: Boolean; var IsExit: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOtherDocumentType(documentNo: Code[20]; EmpActTypeEnum: Enum "Employee Activity Type")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReOpenDocument(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOtherDocumentTypeSAAS(documentNo: Code[20]; EmpActTypeEnum: Enum "Employee Activity Type"; AccessToken: Code[60])
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeIncrementOfApproverSequence(var DocApproverCheck: Record "Document Approver"; var DocApprover: Record "Document Approver"; var IsHandled: Boolean)
    begin
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        EmailMgt: Codeunit "Email Mgt";
        leaveMgt: Codeunit "Leave Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        AttendanceMissed: Codeunit "AttendanceMiss mgt";
        TransferMgt: Codeunit "Transfer Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        ResignationMgt: Codeunit "Resignation Mgt";
        ChangesInEmployeeMgt: Codeunit "Employee Edit Mgt.";
        AllowanceAssignmentMgt: Codeunit "Allowance Assignment Mgt";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";
        AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
}
