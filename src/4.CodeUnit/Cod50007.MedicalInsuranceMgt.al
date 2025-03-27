codeunit 50007 "MedicalInsurance Mgt"
{
    procedure OpenMedicalInsuranePage(EmployeeCode: Code[20])
    var
        //EmployeeAct: Record "Employee Activity";
        MedicalInsurance: Record "Medical Insurance Claim";
    begin
        MedicalInsurance.Reset;
        MedicalInsurance.SetRange("Employee No.", EmployeeCode);
        MedicalInsurance.SetRange(Type, MedicalInsurance.Type::"Medical Insurance Claim");
        MedicalInsurance.SetFilter("Approval Status", '<>%1', MedicalInsurance."Approval Status"::"Pending Approval");
        if not MedicalInsurance.FindFirst then begin
            MedicalInsurance.Init;
            MedicalInsurance.Validate(Type, MedicalInsurance.Type::"Medical Insurance Claim");
            MedicalInsurance.Validate("Employee No.", EmployeeCode);
            MedicalInsurance.Insert(true);
            PAGE.Run(PAGE::"Medical Insurance Claim", MedicalInsurance);
        end
        else
            PAGE.Run(PAGE::"Medical Insurance Claim", MedicalInsurance);
    end;

    procedure SendMedicalInsuranceApproval(TempEmpAct: Record "Employee Activity" temporary): Boolean
    var
        EmpAct: Record "Employee Activity";
        ConfirmResign: Label 'Do you want to send resignation request?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        ApprovalRequestSent: Label 'Resignation request approval has been sent.';
        NoRecommender: Label 'No Recommender Code.';
        NoApprover: Label 'No Approver Code.';
        ResignationDays: Integer;
    begin
        if not Confirm(ConfirmResign, false) then
            exit;


        EmpAct.Reset;
        EmpAct.Init;
        EmpAct.TransferFields(TempEmpAct);
        EmpAct.Validate("Approval Status", EmpAct."Approval Status"::"Pending Approval");
        EmpAct.Validate("User ID", UserId);
        Employee.Get(EmpAct."Employee No.");
        // EmpAct.Validate("Recommender Code", Employee."Approver Code");
        EmpAct.Validate("Approver Code", HRMgt.GetHrHead());

        if EmpAct."Recommender Code" = '' then
            Error(NoRecommender);
        if EmpAct."Approver Code" = '' then
            Error(NoApprover);

        if EmpAct."Requested Date" = 0D then
            EmpAct."Requested Date" := Today;




        EmpAct.Insert(true);

        HRMgt.InsertAttachmentLines(EmpAct."No.", EmpAct.Type, EmpAct."Employee No.");//attachment
        // ResignationMgt.InsertResignationApprover(EmpAct); //resignation approver

        HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::Resignation, EmpAct."Approval Status"::Open, '', EmpAct."Employee No.", EmpAct."No.", 0);   //For email
        Message(ApprovalRequestSent);
        exit(true);
    end;

    procedure CancelMedicalInsuranceApproval(var EmpAct: Record "Employee Activity")
    var
        ConfirmCancel: Label 'Do you want to confirm cancel resignation request?';
    begin
        EmpAct.TestField("Approval Status", EmpAct."Approval Status"::"Pending Approval");
        if not Confirm(ConfirmCancel, false) then
            exit;
        EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Cancelled);
        EmpAct.Modify(true);
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
                HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", MedicalInsurance.Type::"Medical Insurance Claim", MedicalInsurance."Approval Status"::Open, '', MedicalInsurance."Employee No.", MedicalInsurance."No.", 0);   //For email
                Message('Insurance Claim reimbursement email has been sent.');
            end;
        end
        else begin
            if not Confirm(ConfirmReject, false) then
                exit;
            MedicalInsurance.Validate("Insurance Status", MedicalInsurance."Insurance Status"::Rejected);
        end;

        MedicalInsurance.Modify;
    end;

    local procedure InsertAttachmentLinesMedicalInsurance(var EmpAct: Record "Employee Activity")
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    begin
        AttachmentMandatory.Reset;
        //AttachmentMandatory.SETRANGE("Table ID", DATABASE::"Employee Activity");
        AttachmentMandatory.SetFilter(Type, Format(EmpAct.Type));
        if AttachmentMandatory.FindFirst then
            repeat
                IncomingDocument.Reset;
                IncomingDocument.SetRange("Table ID", DATABASE::"Employee Activity");
                IncomingDocument.SetRange("Order No.", EmpAct."No.");
                IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument.Description := EmpAct.TableName;
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    IncomingDocument."No." := EmpAct."No.";
                    IncomingDocument."Order No." := EmpAct."Employee No.";
                    IncomingDocument."Table ID" := DATABASE::"Employee Activity";
                    IncomingDocument.Insert(true);

                end;
            until AttachmentMandatory.Next = 0;
    end;

    local procedure InsertMedicalInsuranceApprover(var EmpAct: Record "Employee Activity")
    var
        ResignationApprover: Record "Document Approver";
        Employee: Record Employee;
        EmpFieldRef: FieldRef;
        EmpRecordRef: RecordRef;
    begin
        Employee.Reset;
        Employee.SetRange("Resignation Approver", true);
        if Employee.FindFirst then
            repeat
                ResignationApprover.Reset;
                ResignationApprover.SetRange("Document No.", EmpAct."No.");
                ResignationApprover.SetRange("Employee No.", Employee."No.");
                //ResignationApprover.SETRANGE("Approver Type", ResignationApprover."Approver Type"::"Finance & Accounts");
                if not ResignationApprover.FindFirst then begin
                    ResignationApprover.Init;
                    ResignationApprover."Document No." := EmpAct."No.";
                    ResignationApprover.Validate("Employee No.", Employee."No.");
                    ResignationApprover."Approval Status" := ResignationApprover."Approval Status"::Open;
                    ResignationApprover.Validate("Functional Title", Employee."Functional Title");
                    ResignationApprover.Insert(true);
                end;

            until Employee.Next = 0;
    end;

    local procedure SetMedicalInsuranceApprover(var EmpAct: Record "Employee Activity"; var Receipient: Text)
    var
        DocumentApprover: Record "Document Approver";
    begin
        DocumentApprover.Reset;
        DocumentApprover.SetRange("Document No.", EmpAct."No.");
        DocumentApprover.SetFilter("Employee No.", '<>%1', '');
        if DocumentApprover.FindFirst then
            repeat
                Employee.Get(DocumentApprover."Employee No.");
                if Employee."Company E-Mail" <> '' then begin
                    if Receipient <> '' then
                        Receipient += ';' + Employee."Company E-Mail"
                    else
                        Receipient := Employee."Company E-Mail";
                end;

            until DocumentApprover.Next = 0;
    end;

    procedure ScreenMedicalInsurance(var Medicalinsurance: Record "Medical Insurance Claim")
    var
        ConfirmScreen: Label 'Do you want to confirm screen this document?';
    begin
        //check authorized user
        if Medicalinsurance."Insurance Status" = Medicalinsurance."Insurance Status"::"Request to DTMD" then begin
            Employee.Get(HRMgt.GetEmployeeNo());
            if not Confirm(ConfirmScreen, false) then
                exit;
            Medicalinsurance.Validate("Insurance Status", Medicalinsurance."Insurance Status"::"Forwarded to Insurance Co.");
            Medicalinsurance.Modify;
        end;
    end;

    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";


}
