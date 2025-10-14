codeunit 50006 "Resignation Mgt"
{
    procedure OpenResignationRequest(EmpCode: Code[20])
    var
        //EmpAct4: Record "Employee Activity" temporary;
        Resignation2: Record Resignation temporary;
        RequestError: Label 'You are not eligible to request for a transfer.';
        //EmpAct: Record "Employee Activity";
        Resignation: Record Resignation;
        Approval: Record "Approval HRMS";
    begin
        Clear(Employee);
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::Resignation);
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        Employee.Get(EmpCode);
        Resignation.Reset;
        Resignation.SetRange("Employee No.", EmpCode);
        Resignation.SetRange(Type, Resignation.Type::Resignation);
        Resignation.SetFilter("Approval Status", '<>%1&<>%2', Resignation."Approval Status"::Canceled, Resignation."Approval Status"::Rejected);
        // Resignation.SetFilter("Approval Status", '<>%1', Resignation."Approval Status"::Rejected);
        if Resignation.FindLast then begin
            PAGE.Run(PAGE::"Resignation Card", Resignation);
            exit;
        end;
        Employee.Get(EmpCode);
        Resignation2.Init;
        Resignation2.Validate("Employee No.", EmpCode);
        Resignation2.Validate(Type, Resignation2.Type::Resignation);
        Resignation2.Validate("Approval Status", Resignation2."Approval Status"::Open);
        Resignation2.Validate("Requested Date", Today);
        Resignation2.Insert;
        PAGE.Run(PAGE::"Resignation Card", Resignation2);
    end;

    procedure SendResignationApproval(TempResignation: Record "Resignation" temporary): Boolean
    var
        Resignation: Record "Resignation";
        ConfirmResign: Label 'Do you want to send resignation request?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        ApprovalRequestSent: Label 'Resignation request approval has been sent.';
        NoRecommender: Label 'No %1.';
        ResignationDays: Integer;
        EmailTemplate: Record "Email Template";
    begin
        if GuiAllowed then
            if not Confirm(ConfirmResign, false) then
                exit;
        Resignation.Reset;
        Resignation.SetRange("Employee No.", TempResignation."Employee No.");
        Resignation.SetRange(Type, Resignation.Type::Resignation);
        Resignation.SetFilter("Approval Status", '<>%1&<>%2', Resignation."Approval Status"::Canceled, Resignation."Approval Status"::Rejected);
        if Resignation.FindFirst then
            Error('Employee %1 has already send request for resignation', Resignation."Employee Name");

        TempResignation.TestField("Proposed Date of Resignation");
        TempResignation.TestField("Reason for Resignation");
        TempResignation.TestField("Reason Code");

        Clear(Resignation);
        Resignation.Reset;
        Resignation.Init;
        Resignation.TransferFields(TempResignation);
        Resignation.Validate("Approval Status", Resignation."Approval Status"::"Pending");
        Resignation.Validate("User ID", UserId);

        Employee.Get(Resignation."Employee No.");
        //EmpAct.VALIDATE("Recommender Code", Employee."Recommender Code");
        // Resignation.Validate("Approver Code", HrMgt.GetHrHead());

        // if Resignation."Recommender Code" = '' then
        //     Error(NoRecommender, Resignation.FieldCaption("Recommender Code"));

        if Resignation."Requested Date" = 0D then
            Resignation."Requested Date" := Today;

        //Resignation."Supervisor Proposed Date" := Resignation."Proposed Date of Resignation";
        Resignation."HR Proposed Date" := Resignation."Proposed Date of Resignation";

        Resignation.Insert(true);

        //HrMgt.InsertAttachmentLines(Resignation."No.", Format(Resignation.Type), Resignation."Employee No.");//attachment
        // InsertResignationApprover(Resignation); //resignation approver

        HrMgt.SendMailFromTemplate(DATABASE::Resignation, EmailTemplate."Document Type"::Resignation, Resignation."Approval Status"::Open, Resignation."Employee No.", Resignation."No.", false);   //For email
        // if (Resignation.Type = Resignation.Type::Resignation) and (Resignation."Approval Status" = Resignation."Approval Status"::Pending) then
        //     HrMgt.ResignationEmailSend(Resignation."Employee No."); 
        Message(ApprovalRequestSent);
        exit(true);
    end;

    procedure CancelResignationApproval(var Resignation: Record "Resignation")
    var
        ConfirmCancel: Label 'Do you want to confirm cancel resignation request?';
    begin
        Resignation.TestField("Approval Status", Resignation."Approval Status"::"Pending");
        if not Confirm(ConfirmCancel, false) then
            exit;
        //Resignation.Validate("Approval Status", Resignation."Approval Status"::Cancelled);
        Resignation.Modify(true);
    end;

    procedure InsertResignationApprover(var Resignation: Record "Resignation")
    var
        ResignationApprover: Record "Document Approver";
        Employee: Record Employee;
    // EmpFieldRef: FieldRef;
    // EmpRecordRef: RecordRef;
    begin
        Resignation.TestField("Approval Status", Resignation."Approval Status"::Approved);
        Employee.Reset;
        Employee.SetRange("Resignation Approver", true);
        if Employee.FindFirst then
            repeat
                ResignationApprover.Reset;
                ResignationApprover.SetRange("Document No.", Resignation."No.");
                ResignationApprover.SetRange("Employee No.", Employee."No.");
                //ResignationApprover.SetRange("Approver Type", ResignationApprover."Approver Type"::"Finance & Accounts");
                if not ResignationApprover.FindFirst then begin
                    ResignationApprover.Init;
                    ResignationApprover."Document Type" := ResignationApprover."Document Type"::Resignation;
                    ResignationApprover."Document No." := Resignation."No.";
                    ResignationApprover.Validate("Employee No.", Employee."No.");
                    ResignationApprover."Approval Status" := ResignationApprover."Approval Status"::Open;
                    ResignationApprover.Validate("Functional Title", Employee."Functional Title");
                    ResignationApprover.Insert(true);
                end;
            until Employee.Next = 0;
    end;

    procedure ScreenResignation(var Resignation: Record Resignation)
    var
        ConfirmScreen: Label 'Do you want to screen this document?';
        FunctionalTitle: Record "Functional Title";
    begin
        //check authorized user
        Employee.Get(HrMgt.GetEmployeeNo());
        if Resignation.Type = Resignation.Type::Resignation then begin
            // if not Employee.Screener then           //resignation approver replaced with screener
            //     Error('Not authorized screener.');
            // Resignation.TestField("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
            //  EmpAct.TestField("Screener Remarks");
            HrMgt.CheckDocumentApprover(Resignation."No.");
            CheckResignationAttachmentMandatory(Resignation);
            if not Confirm(ConfirmScreen, false) then
                exit;

            // Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
            Resignation.Modify;
        end
        else if Resignation.Type = Resignation.Type::"Travel Claim" then begin
            /*HRSetup.GET;
            Employee.Reset();
            Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
            Employee.SetRange("NAV Login ID", USERID);
            IF NOT Employee.FindFirst() THEN
                ERROR('Not authorized screener.');*///AT
            if not (Resignation."Approval Status" = Resignation."Approval Status"::Approved) then
                Error('Approval Status must be approved before screening.');
            if not Confirm(ConfirmScreen, false) then
                exit;

            // Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
            Resignation.Modify;
        end else if Resignation.Type = Resignation.Type::Overtime then begin
            Resignation.TestField("Approval Status", Resignation."Approval Status"::Approved);
            if not Confirm(ConfirmScreen, false) then
                exit;

            // Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
            Resignation.Modify;
        end;

    end;

    procedure ForwardToHRForResignation(var Resignation: Record "Resignation")
    var
        ConfirmScreen: Label 'Do you want to confirm screen this document?';
    begin
        //check authorized user
        Employee.Get(HrMgt.GetEmployeeNo());
        if not (Employee."No." = Resignation."Employee No.") then
            Error('Only employee %1 can forward this document to HR.', Resignation."Employee Name");
        HrMgt.CheckDocumentApprover(Resignation."No.");
        CheckResignationAttachmentMandatory(Resignation);
        if GuiAllowed then
            if not Confirm(ConfirmScreen, false) then
                exit;
        // Resignation.Validate("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
        Resignation.Modify;
    end;

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

        if (Resignation."Proposed Date of Resignation" - Resignation."Requested Date" + 1) >= ResignationDays then
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

    procedure UpdateResign(EmpCode: Code[20])
    var
        ResignPageBuilder: FilterPageBuilder;
        ResignDate: Date;
    begin
        Employee1.Get(EmpCode);
        if Employee1.Status <> Employee1.Status::Active then
            Error('Employee %1 status must be active', Employee1."Full Name");
        ResignPageBuilder.AddRecord('Update to Employee Resignation', Employee);
        ResignPageBuilder.ADdField('Update to Employee Resignation', Employee."Termination Date");
        ResignPageBuilder.RunModal;
        Employee.SetView(ResignPageBuilder.GetView('Update to Employee Resignation'));
        Evaluate(ResignDate, Employee.GetFilter("Termination Date"));
        Employee1.Status := Employee1.Status::Inactive;
        Employee1."Termination Date" := ResignDate;
        Employee1."Resignation Date" := ResignDate;
        Employee1.Modify;
        Message('Employee has been terminated.');
    end;

    procedure ReturnResignation(Resignation: Record "Resignation")
    begin
        // Resignation.TestField("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
        if Confirm('Do you want to return resignation?', false) then begin
            Resignation.Validate("Approval Status", Resignation."Approval Status"::Open);
            Resignation.Modify;
            Message('Resignation Returned.');
        end;
    end;


    procedure ApproveResignation(resignationCode: Code[100])
    var
        Resignation: Record Resignation;
        ServiceEvent: Enum "Service Event";
    begin
        Resignation.Get(resignationCode);
        InsertResignationApprover(Resignation); //resignation clearance approver
        HrMgt.InsertAttachmentLines(Resignation."No.", Resignation.Type, Resignation."Employee No.");
        ServiceHistoryMgt.AddToServiceHistory(Resignation."Employee No.", ServiceEvent::Resignation, Resignation.Remarks, Resignation."HR Proposed Date");

    end;

    var
        Employee: Record Employee;
        Employee1: Record Employee;
        HRSetup: Record "Human Resources Setup";
        HrMgt: Codeunit "HR Mgt.";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
}
