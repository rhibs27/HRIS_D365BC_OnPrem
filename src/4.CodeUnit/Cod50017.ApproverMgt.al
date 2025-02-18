codeunit 50017 "Approver Mgt"
{
    procedure InsertApproval(EmployeeNo: Code[20]; EmpActNo: code[20]; EmpActType: enum "Employee Activity Type")
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
                Employee.SetRange("Deputation On", EmpRequest."Deputation On");
                if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Branch then
                    Employee.SetRange("Global Dimension 1 Code", EmpRequest."Global Dimension 1 Code")
                else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Department then
                    Employee.SetRange("Department Code", EmpRequest."Department Code")
                else if EmpRequest."Deputation On" = EmpRequest."Deputation On"::Province then
                    Employee.SetRange("Province Code", EmpRequest."Province Code");
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

    procedure ApproveRejectDocument(var RecRef: RecordRef; Approved: Boolean)
    var
        Approver: Record "Approval HRMS";
        Approver2: Record "Approval HRMS";
        ApproveNotEligibleError: Label 'You are not Eligible to Approve or reject this document ';
        ApprovalStatusField: text;
        ApprovalStatusEnum: Enum "Approval Status";
        EmpActType: Enum "Employee Activity Type";
        StatusMaster: Record "Status Master";
    begin
        // Get the fields dynamically using FieldRef
        ApprovalStatusField := Format((RecRef.Field(16)));
        EmpActType := RecRef.Field(2).Value;
        if ApprovalStatusField = Format(ApprovalStatusEnum::Approved) then
            Error('Document Is already approved');
        if ApprovalStatusField = Format(ApprovalStatusEnum::Rejected) then
            Error('Document is Rejected');
        if ApprovalStatusField = Format(ApprovalStatusEnum::Pending) then begin
            CheckApprover(RecRef.Field(1).Value);
            Approver.Reset();
            Approver.SetRange("Document No.", RecRef.Field(1).Value);
            Approver.SetRange("Approval Status", Approver."Approval Status"::Open);
            if Approver.FindSet() then begin
                repeat
                    if Approved then begin
                        Approver.Validate("Approval Status", Approver."Approval Status"::Approved);
                        Approver.Validate("Approved By", HRMgt.GetEmpName());
                        RecRef.Field(100).Validate(Approver.Status);
                        Message('Document is Approved by %1', HRMgt.GetEmpName());
                    end
                    else begin
                        Approver.Validate("Approval Status", Approver."Approval Status"::Rejected);
                        Approver.Validate("Rejected By", HRMgt.GetEmpName());
                        RecRef.Field(16).Validate(ApprovalStatusEnum::Rejected);
                        StatusMaster.Reset();
                        StatusMaster.SetRange(Rejected, true);
                        if StatusMaster.FindFirst() then begin
                            RecRef.Field(100).Validate(StatusMaster.Status);
                            Message('Document is Rejected by %1', HRMgt.GetEmpName());
                        end
                        else
                            Error('Rejected Status not Found On Status Master Setup');
                    end;
                    RecRef.Modify();
                    Approver.Modify();
                until Approver.Next() = 0;
                // Modify the record dynamically
            end;
            //Find next approval step
            if Approved then begin
                Approver2.Reset();
                Approver2.SetRange("Document No.", (RecRef.Field(1).Value));
                Approver2.SetRange("Approval Sequence", Approver."Approval Sequence" + 1);
                if Approver2.FindSet() then
                    repeat
                        Approver2."Approval Status" := Approver2."Approval Status"::Open;
                        Approver2.Modify;
                    until Approver2.Next() = 0
                else begin
                    RecRef.Field(16).Validate(ApprovalStatusEnum::Approved);
                    case EmpActType of
                        //for leave
                        EmpActType::"Leave Request":
                            begin
                                leaveMgt.LeaveApproved(RecRef.Field(1).Value);
                                Message('Document is Approved by %1', HRMgt.GetEmpName());
                            end;
                        EmpActType::"Travel Request":
                            begin
                                TravelMgt.ApprovedTravel(RecRef.Field(1).Value);
                                Message('Document is Approved by %1', HRMgt.GetEmpName());
                            end;
                    end;
                    RecRef.Modify();
                end;
            end;
        end;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        leaveMgt: Codeunit "Leave Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";

}
