codeunit 50006 "Resignation Mgt"
{
    procedure OpenResignationRequest(EmpCode: Code[20])
    var
        Resignation, Resignation2 : Record Resignation;
        Approval: Record "Approval HRMS";
    begin
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::Resignation);
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        Resignation.Reset;
        Resignation.SetRange("Employee No.", EmpCode);
        Resignation.SetRange(Type, Resignation.Type::Resignation);
        Resignation.SetFilter("Approval Status", '<>%1&<>%2', Resignation."Approval Status"::Canceled, Resignation."Approval Status"::Rejected);
        if Resignation.Findfirst then begin
            Message('This Employee Already has open Leave Request.Click Ok to Open');
            PAGE.Run(PAGE::"Resignation Card", Resignation);
            exit;
        end;
        Resignation2.Init;
        Resignation2.Validate("Employee No.", EmpCode);
        Resignation2.Validate(Type, Resignation2.Type::Resignation);
        Resignation2.Validate("Approval Status", Resignation2."Approval Status"::Open);
        Resignation2.Validate("Requested Date", Today);
        Resignation2.Insert(true);
        InsertResignAttachmentLetter(Resignation2."No.", Resignation2.Type, Resignation2."Employee No.");
        PAGE.Run(PAGE::"Resignation Card", Resignation2);
    end;

    procedure SendResignationApproval(var Resignation: Record "Resignation"): Boolean
    var
        ConfirmResign: Label 'Do you want to send resignation request?';
        ApprovalRequestSent: Label 'Resignation request approval has been sent.';
        EmailTemplate: Record "Email Template";
    begin
        if GuiAllowed then
            if not Confirm(ConfirmResign, false) then
                exit;
        Resignation.TestField("Requested Last Working Day");
        Resignation.TestField("Reason for Resignation");
        if GuiAllowed then begin
            AttachmentMgt.CheckMandatoryAttachment(Resignation."No.");
            Resignation.Validate("Approval Status", "Approval Status"::Pending);
        end;
        CheckAlreadyExitRetirementRequest(Resignation);
        ApproverMgt.UpdateFirstApproverStatus(Resignation."No.");
        EmailMgt.SendResignEmailFromTemplate(Resignation.Type, Resignation."Approval Status", Resignation."Employee No.", Resignation."No.", Resignation);
        Message(ApprovalRequestSent);
        exit(true);
    end;

    procedure CheckAlreadyExitRetirementRequest(Resignation: Record Resignation)
    begin
        Resignation.Reset;
        Resignation.SetRange("Employee No.", Resignation."Employee No.");
        Resignation.SetRange(Type, Resignation.Type::Resignation);
        Resignation.SetFilter("Approval Status", '<>%1&<>%2&<>%3', Resignation."Approval Status"::Canceled, Resignation."Approval Status"::Rejected, Resignation."Approval Status"::Open);
        if Resignation.Findfirst then
            Error('%1 Already has %2 Resignation Request No %3', Resignation."Employee Name", Resignation."Approval Status", Resignation."No.");
    end;

    procedure InsertResignationApprover(EmployeeNo: Code[20];
                                EmpActNo: Code[20];
                                EmpActType: enum "Employee Activity Type")
    var
        ResignDocApproverSetup: Record "Resign Doc Approver Setup";
        EmpRequest, EmployeeApprover : Record Employee;
        ResignationApprover: Record "Document Approver";
        Count, ApproverSequence : Integer;
    begin
        EmpRequest.Get(EmployeeNo);
        Count := 0;
        ResignDocApproverSetup.Reset();
        ResignDocApproverSetup.SetRange("Emp Act Type", EmpActType);
        ResignDocApproverSetup.SetRange("Deputation Type", EmpRequest."Deputation on");
        ResignDocApproverSetup.SetCurrentKey("Approver Sequence");
        ResignDocApproverSetup.SetAscending("Approver Sequence", true);
        if ResignDocApproverSetup.FindFirst() then
            repeat
                EmployeeApprover.Reset();
                EmployeeApprover.SetRange(Status, EmployeeApprover.Status::Active);
                if ResignDocApproverSetup."Same Deputation Approver" then begin
                    EmployeeApprover.SetRange("Deputation on", EmpRequest."Deputation On");
                    EmployeeApprover.SetRange("Deputation On Code", EmpRequest."Deputation On Code");
                end else begin
                    EmployeeApprover.SetRange("Deputation on", ResignDocApproverSetup."Approver Deputation Type");
                    EmployeeApprover.SetRange("Deputation On Code", ResignDocApproverSetup."Approver Deputation Code");
                end;
                if ResignDocApproverSetup."Approver Role" <> '' then
                    EmployeeApprover.SetRange("Approver Role", ResignDocApproverSetup."Approver Role");
                if ResignDocApproverSetup."Employee No" <> '' then
                    EmployeeApprover.SetRange("No.", ResignDocApproverSetup."Employee No");
                if EmployeeApprover.Findfirst then begin
                    if ApproverSequence <> ResignDocApproverSetup."Approver Sequence" then begin
                        ApproverSequence := ResignDocApproverSetup."Approver Sequence";
                        Count := Count + 1;
                    end;
                    ResignationApprover.Init;
                    ResignationApprover."Document Type" := ResignationApprover."Document Type"::Resignation;
                    ResignationApprover."Document No." := EmpActNo;
                    ResignationApprover.Validate("Employee No.", EmployeeApprover."No.");
                    ResignationApprover.Validate("Deputation Type", EmployeeApprover."Deputation on");
                    ResignationApprover.Validate("Deputation Code", EmployeeApprover."Deputation On Code");
                    ResignationApprover.Validate("Approver Role", ResignDocApproverSetup."Approver Role");
                    ResignationApprover.Validate("Approver Sequence", Count);
                    ResignationApprover.Insert(true);
                end;
            until ResignDocApproverSetup.Next() = 0
        else
            Error('Approval Setup not found');
    end;

    procedure resignClearanceAttachmentImport(var DocumentApprover: Record "Document Approver"; textBase64: text; extension: text)
    var
        InStr: InStream;
        outStream: OutStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
        CleanedFileName: text;

    begin
        CleanedFileName := DocumentApprover."Document No." + '_' + Format(DocumentApprover."Line No.") + '.' + extension;
        TempBlob.CreateOutStream(outStream);
        base64.FromBase64(textBase64, Outstream);
        TempBlob.CreateInStream(InStr);
        AttachmentMgt.CheckAttachmentSizeLimit(InStr, Format(DocumentApprover."Document Type"::Resignation));
        AttachmentMgt.checkAttachmentExtensionImage(Extension);
        Clear(DocumentApprover.Attachment);
        DocumentApprover.Attachment.ImportStream(InStr, CleanedFileName);
        DocumentApprover.Modify(true);
    end;

    // procedure ForwardToHRForResignation(var Resignation: Record "Resignation")
    // var
    //     ConfirmScreen: Label 'Do you want to confirm screen this document?';
    // begin
    //     //check authorized user
    //     if not HrMgt.IsSaaS() then// garima
    //         Employee.Get(HrMgt.GetEmployeeNo());
    //     if not (Employee."No." = Resignation."Employee No.") then
    //         Error('Only employee %1 can forward this document to HR.', Resignation."Employee Name");
    //     CheckDocumentApprover(Resignation."No.");
    //     CheckResignationAttachmentMandatory(Resignation);
    //     if GuiAllowed then
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;
    //     // Resignation.Validate("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
    //     Resignation.Modify;
    // end;

    procedure UpdateResignationWaiver(var Resignation: Record "Resignation")
    var
        ResignationDays: Integer;
    begin
        HRSetup.Get;
        Employee.Get(Resignation."Employee No.");
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
        if Resignation."Requested Date" = 0D then
            Resignation."Requested Date" := Today;
        if (Resignation."Requested Last Working Day" - Resignation."Requested Date" + 1) >= ResignationDays then
            Resignation.Validate("Waiver Case", Resignation."Waiver Case"::Normal)
        else
            Resignation.Validate("Waiver Case", Resignation."Waiver Case"::Recovery);
    end;

    procedure CheckResignationAttachmentMandatory(var Resignation: Record Resignation)
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument.Reset;
        IncomingDocument.SetRange("No.", Resignation."No.");
        IncomingDocument.SetRange("File Name", '');
        if IncomingDocument.FindFirst then
            repeat
                AttachmentSetup.Reset;
                AttachmentSetup.SetRange(Mandatory, true);
                AttachmentSetup.SetFilter(Type, Format(Resignation.Type));
                AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
                if AttachmentSetup.FindFirst then
                    Error('Upload attachment for %1', IncomingDocument."Attachment Code");
            until IncomingDocument.Next = 0;
    end;

    procedure ApproveResignation(resignationCode: Code[100])
    var
        Resignation: Record Resignation;
        ServiceEvent: Enum "Service Event";
    begin
        Resignation.Get(resignationCode);
        HRSetup.Get();
        Resignation.TestField("Approved Last Working Day");
        if not HRSetup."Hide Clearance Approver" then
            InsertResignationApprover(Resignation."Employee No.", Resignation."No.", Resignation.Type::Resignation); //resignation clearance approver
        HrMgt.InsertAttachmentLines(Resignation."No.", Resignation.Type, Resignation."Employee No.");
        ServiceHistoryMgt.AddToServiceHistory(Resignation."Employee No.", ServiceEvent::Resignation, Resignation.Remarks, Resignation."Approved Last Working Day");
    end;

    procedure InsertResignAttachmentLetter(DocumentNo: Code[20]; employeeAct: Enum "Employee Activity Type"; employeeNo: Code[20])
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    begin
        AttachmentMandatory.Reset;
        AttachmentMandatory.Setfilter("Type", Format(AttachmentMandatory.Type::Resignation));
        AttachmentMandatory.SetRange("Sub Type", AttachmentMandatory."Sub Type"::"Resign Letter");
        if AttachmentMandatory.FindFirst then
            repeat
                IncomingDocument.Reset;
                IncomingDocument.SetRange("No.", DocumentNo);
                IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    IncomingDocument."No." := DocumentNo;
                    IncomingDocument."Sub Type" := AttachmentMandatory."Sub Type";
                    IncomingDocument."Employee Activity Type" := employeeAct;
                    IncomingDocument."Employee Code" := employeeNo;
                    IncomingDocument.Insert(true);
                end;
            until AttachmentMandatory.Next = 0;
    end;

    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        HrMgt: Codeunit "HR Mgt.";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        EmailMgt: Codeunit "Email Mgt";
        ApproverMgt: Codeunit "Approver Mgt";
        AttachmentMgt: Codeunit "Attachment Mgt.";
}
