codeunit 50007 "Insurance Mgt"
{
    procedure OpenMedicalInsurancePage(EmployeeCode: Code[20])
    var
        MedicalInsurance: Record "Medical Insurance Claim";
    begin
        Employee.Get(EmployeeCode);
        if Employee.Status <> Employee.Status::Active then
            Error('Employee is not active.');
        MedicalInsurance.Reset;
        MedicalInsurance.SetRange("Employee No.", EmployeeCode);
        MedicalInsurance.SetRange(Type, MedicalInsurance.Type::"Medical Insurance Claim");
        MedicalInsurance.SetRange("Approval Status", MedicalInsurance."Approval Status"::Open);
        if MedicalInsurance.FindFirst then begin
            Message('This Employee Already has open Medical Insurance Claim Request.Click Ok to Open');
            PAGE.Run(PAGE::"Medical Insurance Claim", MedicalInsurance);
        end
        else begin
            MedicalInsurance.Init;
            MedicalInsurance.Validate(Type, MedicalInsurance.Type::"Medical Insurance Claim");
            MedicalInsurance.Validate("Employee No.", EmployeeCode);
            MedicalInsurance.Validate("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
            MedicalInsurance.Validate("Approval Status", MedicalInsurance."Approval Status"::Open);
            MedicalInsurance.Insert(true);
            PAGE.Run(PAGE::"Medical Insurance Claim", MedicalInsurance);
        end;
    end;

    procedure SendMedicalInsuranceApproval(var medicalInsuranceClaim: Record "Medical Insurance Claim")
    var
        MedicalInsurance: Record "Medical Insurance Claim";
        IncomingDoc: Record "Incoming Document";
        HRSetup: Record "Human Resources Setup";
        InsuranceMgt: Codeunit "Insurance Mgt";
        DuplicateClaimErr: Label 'This employee already has a pending medical insurance claim request.';
    begin
        HRSetup.Get();
        medicalInsuranceClaim.TestField("Insurance Claim");
        medicalInsuranceClaim.TestField("Medical Prescription Date");
        medicalInsuranceClaim.TestField("Discharge Date");
        medicalInsuranceClaim.TestField("Total Insurance Claim Amount");
        medicalInsuranceClaim.TestField(Remarks);
        medicalInsuranceClaim.TestField("Insured Name");

        if HasPendingClaim(medicalInsuranceClaim) then
            Error(DuplicateClaimErr);

        if GuiAllowed then
            AttachmentMgt.CheckMandatoryAttachmentOnType(Enum::"Attachment Setup Type"::"Medical Insurance Claim", Enum::"Attachment Setup SubType"::" ", MedicalInsurance."No.");
        if not GuiAllowed then begin
            medicalInsuranceClaim.Validate("Insurance Status", medicalInsuranceClaim."Insurance Status"::"Submitted to HRD");
            medicalInsuranceClaim.Validate("Approval Status", medicalInsuranceClaim."Approval Status"::"Pending");
            medicalInsuranceClaim."HR Remarks" := '';
        end;
        if GuiAllowed then begin
            if not HRSetup."Skip Medical Approval Setup" then
                ApproverMgt.UpdateFirstApproverStatus(medicalInsuranceClaim."No.")
            else
                medicalInsuranceClaim.Validate("Insurance Status", medicalInsuranceClaim."Insurance Status"::"Submitted to HRD");
            medicalInsuranceClaim.Validate("Approval Status", medicalInsuranceClaim."Approval Status"::"Pending");
            medicalInsuranceClaim."HR Remarks" := '';
            medicalInsuranceClaim.Modify();
        end;
    end;

    procedure ApproveRejectMedicalInsurance(Approve: Boolean; var MedicalInsurance: Record "Medical Insurance Claim")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        if Approve then begin
            if not Confirm(ConfirmApprove, false) then
                exit;
            if MedicalInsurance."Insurance Status" = MedicalInsurance."Insurance Status"::"Forwarded to Insurance Co." then begin
                MedicalInsurance.Validate("Insurance Status", MedicalInsurance."Insurance Status"::Reimbursed);
                // HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", MedicalInsurance.Type::"Medical Insurance Claim", MedicalInsurance."Approval Status"::Open, '', MedicalInsurance."Employee No.", MedicalInsurance."No.", 0);   //For email
                Message('Insurance Claim reimbursement has been sent.');
            end;
        end
        else begin
            if not Confirm(ConfirmReject, false) then
                exit;
            MedicalInsurance.Validate("Insurance Status", MedicalInsurance."Insurance Status"::Rejected);
        end;
        MedicalInsurance.Modify;
    end;

    procedure ScreenMedicalInsurance(var Medicalinsurance: Record "Medical Insurance Claim")
    var
        ConfirmScreen: Label 'Do you want to confirm screen this document?';
    begin
        //check authorized user
        if Medicalinsurance."Insurance Status" = Medicalinsurance."Insurance Status"::"Request to DTMD" then begin
            if not HrMgt.IsSaaS() then
                Employee.Get(HRMgt.GetEmployeeNo());
            if not Confirm(ConfirmScreen, false) then
                exit;
            Medicalinsurance.Validate("Insurance Status", Medicalinsurance."Insurance Status"::"Forwarded to Insurance Co.");
            Medicalinsurance.Modify;
        end;
    end;

    procedure OpenEmployeeInsurance(EmployeeCode: Code[20])
    var
        Approval: Record "Approval HRMS";
        EmployeeInsurance, EmployeeInsurance1 : Record "Employee Insurance Information";
    begin
        Clear(Employee);
        // Clear Approval line
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::Insurance);
        Approval.SetRange("Employee No", EmployeeCode);
        Approval.DeleteAll();
        Employee.Get(EmployeeCode);
        EmployeeInsurance.Reset();
        EmployeeInsurance.SetRange("Employee No.", EmployeeCode);
        EmployeeInsurance.SetRange("Approval Status", EmployeeInsurance."Approval Status"::open);
        if EmployeeInsurance.Findfirst() then begin
            Message('This Employee Already has open Insurance Request.Click Ok to Open');
            PAGE.Run(PAGE::"Employee Insurance Card", EmployeeInsurance)
        end else begin
            EmployeeInsurance1.Init;
            EmployeeInsurance1.Validate("Employee No.", EmployeeCode);
            EmployeeInsurance1.Validate(Type, EmployeeInsurance1.Type::Insurance);
            EmployeeInsurance1.Validate("Approval Status", EmployeeInsurance1."Approval Status"::Open);
            EmployeeInsurance1.Validate("Requested Date", Today);
            EmployeeInsurance1.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Employee Insurance Card", EmployeeInsurance1);
        end;
    end;

    procedure CheckInsuranceAttachment(InsuranceNo: Code[20]; EmpNo: Code[20])
    var
        IncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        IsHandled: Boolean;
    begin
        OnBeforeCheckInsuranceAttachment(InsuranceNo, IsHandled);
        if IsHandled then
            exit;
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Insurance);
        AttachmentSetup.SetRange(Mandatory, true);
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Reset;
                IncomingDoc.SetRange("No.", InsuranceNo);
                IncomingDoc.SetRange("Employee Code", EmpNo);
                IncomingDoc.SetRange("File Name", '');
                if IncomingDoc.FindFirst then
                    Error('Please upload mandatory attachments.');
            until AttachmentSetup.Next = 0;
    end;

    procedure GenerateAttachmentLine(InsuranceNo: Code[20]; EmployeeNo: Code[20])
    begin
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Insurance);
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Init;
                IncomingDoc.Validate("No.", InsuranceNo);
                IncomingDoc.Validate("Table ID", Database::"Employee Insurance Information");
                IncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDoc.Validate("Employee Code", EmployeeNo);
                IncomingDoc.Validate("Employee Activity Type", IncomingDoc."Employee Activity Type"::Insurance);
                IncomingDoc."Entry No." := IncomingDoc.GetEntryNo();
                IncomingDoc.Insert;
            until AttachmentSetup.Next = 0;
    end;

    procedure GenerateAttachmentLine(No: Code[20]; EmployeeNo: Code[20]; ActivityType: Enum "Employee Activity Type")
    var
        SetupType: Enum "Attachment Setup Type";
        TableId: Integer;
    begin
        case ActivityType of
            ActivityType::Insurance:
                begin
                    SetupType := SetupType::Insurance;
                    TableId := Database::"Employee Insurance Information";
                end;
            ActivityType::"Medical Insurance Claim":
                begin
                    SetupType := SetupType::"Medical Insurance Claim";
                    TableId := Database::"Medical Insurance Claim";
                end;
        end;

        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, SetupType);
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Init;
                IncomingDoc.Validate("No.", No);
                IncomingDoc.Validate("Table ID", TableId);
                IncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDoc.Validate("Employee Code", EmployeeNo);
                IncomingDoc.Validate("Employee Activity Type", ActivityType);
                IncomingDoc."Entry No." := IncomingDoc.GetEntryNo();
                IncomingDoc.Insert;
            until AttachmentSetup.Next = 0;
    end;

    procedure HasPendingClaim(MedicalInsuranceClaim: Record "Medical Insurance Claim"): Boolean
    var
        ExistingClaim: Record "Medical Insurance Claim";
    begin
        ExistingClaim.SetRange("Employee No.", MedicalInsuranceClaim."Employee No.");
        ExistingClaim.SetRange(Type, ExistingClaim.Type::"Medical Insurance Claim");
        ExistingClaim.SetRange("Approval Status", ExistingClaim."Approval Status"::Pending);
        ExistingClaim.SetRange("Insurance Status", ExistingClaim."Insurance Status"::"Submitted to HRD");

        if MedicalInsuranceClaim."Insurance Claim" = MedicalInsuranceClaim."Insurance Claim"::Self then
            ExistingClaim.SetRange("Insurance Claim", MedicalInsuranceClaim."Insurance Claim")
        else
            ExistingClaim.SetRange(Relation, MedicalInsuranceClaim.Relation);

        exit(not ExistingClaim.IsEmpty());
    end;

    procedure TestfieldReturnRequest(var MedicalInsuranceClaim: Record "Medical Insurance Claim")
    begin
        MedicalInsuranceClaim.TestField("HR Remarks");
        MedicalInsuranceClaim.Validate("Approval Status", MedicalInsuranceClaim."Approval Status"::Open);
        MedicalInsuranceClaim.Validate("Insurance Status", MedicalInsuranceClaim."Insurance Status"::" ");
        MedicalInsuranceClaim.Validate("Medical Prescription Date", 0D);
        MedicalInsuranceClaim.Validate("Discharge Date", 0D);
        MedicalInsuranceClaim.Modify(true);
    end;

    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        AttachmentSetup: Record "Attachment Setup";
        IncomingDoc: Record "Incoming Document";
        AttachmentMgt: Codeunit "Attachment Mgt.";


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckInsuranceAttachment(InsuranceNo: Code[20]; var IsHandled: Boolean)
    begin
    end;
}
