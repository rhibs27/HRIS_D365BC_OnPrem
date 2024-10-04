codeunit 33019806 "Resignation Mgt"
{
    procedure OpenResignationRequest(EmpCode3: Code[10])
    var
        EmpAct4: Record "Employee Activity" temporary;
        RequestError: Label 'You are not eligible to request for a transfer.';
        EmpAct: Record "Employee Activity";
    begin
        EmpAct.Reset;
        EmpAct.SetRange("Employee No.", EmpCode3);
        EmpAct.SetRange(Type, EmpAct.Type::Resignation);
        EmpAct.SetFilter("Approval Status", '<>%1&<>%2', EmpAct."Approval Status"::Cancelled, EmpAct."Approval Status"::Rejected);
        if EmpAct.FindLast then begin
            PAGE.Run(PAGE::"Resignation Card", EmpAct);
            exit;
        end;

        Clear(Employee);
        Employee.Get(EmpCode3);

        EmpAct4.Init;
        EmpAct4.Validate(Type, EmpAct4.Type::Resignation);
        EmpAct4.Validate("Employee No.", EmpCode3);
        EmpAct4.Insert;
        PAGE.Run(PAGE::"Resignation Card", EmpAct4);
    end;

    procedure SendResignationApproval(TempResignation: Record "Resignation" temporary): Boolean
    var
        Resignation: Record "Resignation";
        ConfirmResign: Label 'Do you want to send resignation request?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        ApprovalRequestSent: Label 'Resignation request approval has been sent.';
        NoRecommender: Label 'No %1.';
        ResignationDays: Integer;
    begin
        if GuiAllowed then
            if not Confirm(ConfirmResign, false) then
                exit;
        Resignation.Reset;
        Resignation.SetRange("Employee No.", TempResignation."Employee No.");
        Resignation.SetRange(Type, Resignation.Type::Resignation);
        Resignation.SetFilter("Approval Status", '<>%1&<>%2', Resignation."Approval Status"::Cancelled, Resignation."Approval Status"::Rejected);
        if Resignation.FindFirst then
            Error('Employee %1 has already send request for resignation', Resignation."Employee Name");

        TempResignation.TestField("Proposed Date of Resignation");
        TempResignation.TestField("Reason for Resignation");
        TempResignation.TestField("Reason Code");

        Clear(Resignation);
        Resignation.Reset;
        Resignation.Init;
        Resignation.TransferFields(TempResignation);
        Resignation.Validate("Approval Status", Resignation."Approval Status"::"Pending Approval");
        Resignation.Validate("User ID", UserId);

        Employee.Get(Resignation."Employee No.");
        //EmpAct.VALIDATE("Recommender Code", Employee."Recommender Code");
        Resignation.Validate("Approver Code", HrMgt.GetHrHead());

        if Resignation."Recommender Code" = '' then
            Error(NoRecommender, Resignation.FieldCaption("Recommender Code"));

        if Resignation."Requested Date" = 0D then
            Resignation."Requested Date" := Today;

        Resignation."Supervisor Proposed Date" := Resignation."Proposed Date of Resignation";
        Resignation."HR Proposed Date" := Resignation."Proposed Date of Resignation";

        Resignation.Insert(true);

        HrMgt.InsertAttachmentLines(Resignation."No.", Format(Resignation.Type));//attachment
        InsertResignationApprover(Resignation); //resignation approver

        HrMgt.SendMailFromTemplate(DATABASE::"Employee Activity", Resignation.Type::Resignation, Resignation."Approval Status"::Open, '', Resignation."Employee No.", Resignation."No.", 0);   //For email
        if (Resignation.Type = Resignation.Type::Resignation) and (Resignation."Approval Status" = Resignation."Approval Status"::"Pending Approval") then
            HrMgt.ResignationEmailSend(Resignation."Employee No."); //Min 4.28.2022
        Message(ApprovalRequestSent);
        exit(true);
    end;

    procedure CancelResignationApproval(var Resignation: Record "Resignation")
    var
        ConfirmCancel: Label 'Do you want to confirm cancel resignation request?';
    begin
        Resignation.TestField("Approval Status", Resignation."Approval Status"::"Pending Approval");
        if not Confirm(ConfirmCancel, false) then
            exit;
        Resignation.Validate("Approval Status", Resignation."Approval Status"::Cancelled);
        Resignation.Modify(true);
    end;

    procedure ApproveRejectResignation(Approve: Boolean; var Resignation: Record "Resignation")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
        EmailTemplate: Record "Email Template";
        ServiceHistory: Record "Employee Service History";
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
        AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    begin
        //CheckEmployeeActivityApproval(EmpAct); //check authorized user
        Employee.Get(HrMgt.GetEmployeeNo);

        if Resignation."Approval Status" = Resignation."Approval Status"::"Pending Approval" then
            if StrPos(Resignation."Recommender Code", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);

        if Resignation."Approval Status" = Resignation."Approval Status"::Recommended then begin
            if not Employee.Screener then
                Error('You are not eligible to reject this document.');
        end;
        if Resignation."Approval Status" = Resignation."Approval Status"::Screened then
            if StrPos(Resignation."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);

        if Approve then begin
            if GuiAllowed then
                if not Confirm(ConfirmApprove, false) then
                    exit;
            if Resignation."Approval Status" = Resignation."Approval Status"::"Pending Approval" then begin
                Resignation.Validate("Approval Status", Resignation."Approval Status"::Recommended);
                HrMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmailTemplate."Document Type"::Resignation, Resignation."Approval Status"::Recommended, '', '', Resignation."No.", 0);
                HrMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmailTemplate."Document Type"::Resignation, Resignation."Approval Status"::Recommended, '', '', Resignation."No.", 2);
            end else if Resignation."Approval Status" = Resignation."Approval Status"::Screened then begin
                if Resignation."Approver Code" <> HrMgt.GetEmployeeNo then
                    Error('Your are not eligible to approve this document.');
                Resignation.Validate("Approval Status", Resignation."Approval Status"::Approved);
                HrMgt.AddToServiceHistory(Resignation."Employee No.", ServiceHistory."Service Event"::Resignation, Resignation.Remarks, Resignation."HR Proposed Date");
            end else if Resignation."Approval Status" = Resignation."Approval Status"::"Forwarded To HR" then
                    Message('Document must be screened');
        end
        else begin
            if GuiAllowed then
                if not Confirm(ConfirmReject, false) then
                    exit;
            Resignation.Validate("Approval Status", Resignation."Approval Status"::Rejected);
            HrMgt.ResignationRejectEmailSend(Resignation."Employee No.");//Abhiral 12.20.2022
        end;
        Resignation.Modify;
    end;

    procedure InsertResignationApprover(var Resignation: Record "Resignation")
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
                ResignationApprover.SetRange("Document No.", Resignation."No.");
                ResignationApprover.SetRange("Employee No.", Employee."No.");
                //ResignationApprover.SETRANGE("Approver Type", ResignationApprover."Approver Type"::"Finance & Accounts");
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

    procedure SetResignationApprover(var EmpAct: Record "Employee Activity"; var Receipient: List of [Text])
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
                    // if Receipient <> '' then
                    //     Receipient += ';' + Employee."Company E-Mail"
                    // else
                    Receipient.add(Employee."Company E-Mail");
                end;

            until DocumentApprover.Next = 0;
    end;

    procedure ScreenResignationforTravel(var TravelReq: Record "Travel Request")
    var
        ConfirmScreen: Label 'Do you want to screen this document?';
        FunctionalTitle: Record "Functional Title";
    begin
        //check authorized user
        Employee.Get(HrMgt.GetEmployeeNo());
        if TravelReq.Type = TravelReq.Type::Resignation then begin
            if not Employee.Screener then           //resignation approver replaced with screener
                Error('Not authorized screener.');
            TravelReq.TestField("Approval Status", TravelReq."Approval Status"::"Forwarded To HR");
            //  EmpAct.TESTFIELD("Screener Remarks");
            HrMgt.CheckDocumentApprover(TravelReq."No.");
            CheckResignationAttachmentMandatoryforTravel(TravelReq);
            if not Confirm(ConfirmScreen, false) then
                exit;

            TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
            TravelReq.Modify;
        end
        else if TravelReq.Type = TravelReq.Type::"Travel Claim" then begin
            /*HRSetup.GET;
            Employee.RESET;
            Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
            Employee.SETRANGE("NAV Login ID", USERID);
            IF NOT Employee.FINDFIRST THEN
                ERROR('Not authorized screener.');*///AT
            if not (TravelReq."Approval Status" = TravelReq."Approval Status"::Approved) then
                Error('Approval Status must be approved before screening.');
            if not Confirm(ConfirmScreen, false) then
                exit;

            TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
            TravelReq.Modify;
        end else if TravelReq.Type = TravelReq.Type::Overtime then begin
            TravelReq.TestField("Approval Status", TravelReq."Approval Status"::Approved);
            if not Confirm(ConfirmScreen, false) then
                exit;

            TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
            TravelReq.Modify;
        end;
    end;
    procedure ScreenResignation(var EmpAcctivity: Record "Employee Activity")
    var
        ConfirmScreen: Label 'Do you want to screen this document?';
        FunctionalTitle: Record "Functional Title";
    begin
        //check authorized user
        Employee.Get(HrMgt.GetEmployeeNo());
        if EmpAcctivity.Type = EmpAcctivity.Type::Resignation then begin
            if not Employee.Screener then           //resignation approver replaced with screener
                Error('Not authorized screener.');
            EmpAcctivity.TestField("Approval Status", EmpAcctivity."Approval Status"::"Forwarded To HR");
            //  EmpAct.TESTFIELD("Screener Remarks");
            HrMgt.CheckDocumentApprover(EmpAcctivity."No.");
            CheckResignationAttachmentMandatory(EmpAcctivity);
            if not Confirm(ConfirmScreen, false) then
                exit;

            EmpAcctivity.Validate("Approval Status", EmpAcctivity."Approval Status"::Screened);
            EmpAcctivity.Modify;
        end
        else if EmpAcctivity.Type = EmpAcctivity.Type::"Travel Claim" then begin
            /*HRSetup.GET;
            Employee.RESET;
            Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
            Employee.SETRANGE("NAV Login ID", USERID);
            IF NOT Employee.FINDFIRST THEN
                ERROR('Not authorized screener.');*///AT
            if not (EmpAcctivity."Approval Status" = EmpAcctivity."Approval Status"::Approved) then
                Error('Approval Status must be approved before screening.');
            if not Confirm(ConfirmScreen, false) then
                exit;

            EmpAcctivity.Validate("Approval Status", EmpAcctivity."Approval Status"::Screened);
            EmpAcctivity.Modify;
        end else if EmpAcctivity.Type = EmpAcctivity.Type::Overtime then begin
            EmpAcctivity.TestField("Approval Status", EmpAcctivity."Approval Status"::Approved);
            if not Confirm(ConfirmScreen, false) then
                exit;

            EmpAcctivity.Validate("Approval Status", EmpAcctivity."Approval Status"::Screened);
            EmpAcctivity.Modify;
        end;

    end;

    procedure ScreenResignationFoResignation(var Resignation: Record "Resignation")
    var
        ConfirmScreen: Label 'Do you want to screen this document?';
        FunctionalTitle: Record "Functional Title";
    begin
        //check authorized user
        Employee.Get(HrMgt.GetEmployeeNo());
        if Resignation.Type = Resignation.Type::Resignation then begin
            if not Employee.Screener then           //resignation approver replaced with screener
                Error('Not authorized screener.');
            Resignation.TestField("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
            //  EmpAct.TESTFIELD("Screener Remarks");
            HrMgt.CheckDocumentApprover(Resignation."No.");
            CheckResignationAttachmentMandatoryForResignation(Resignation);
            if not Confirm(ConfirmScreen, false) then
                exit;

            Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
            Resignation.Modify;
        end
        else if Resignation.Type = Resignation.Type::"Travel Claim" then begin
            /*HRSetup.GET;
            Employee.RESET;
            Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
            Employee.SETRANGE("NAV Login ID", USERID);
            IF NOT Employee.FINDFIRST THEN
                ERROR('Not authorized screener.');*///AT
            if not (Resignation."Approval Status" = Resignation."Approval Status"::Approved) then
                Error('Approval Status must be approved before screening.');
            if not Confirm(ConfirmScreen, false) then
                exit;

            Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
            Resignation.Modify;
        end else if Resignation.Type = Resignation.Type::Overtime then begin
            Resignation.TestField("Approval Status", Resignation."Approval Status"::Approved);
            if not Confirm(ConfirmScreen, false) then
                exit;

            Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
            Resignation.Modify;
        end;

    end;

 procedure ScreenResignationForOvertime(var Overtime: Record "OverTime")
    var
        ConfirmScreen: Label 'Do you want to screen this document?';
        FunctionalTitle: Record "Functional Title";
    begin
        //check authorized user
        Employee.Get(HrMgt.GetEmployeeNo());
        if Overtime.Type = Overtime.Type::Resignation then begin
            if not Employee.Screener then           //resignation approver replaced with screener
                Error('Not authorized screener.');
            Overtime.TestField("Approval Status", Overtime."Approval Status"::"Forwarded To HR");
            //  EmpAct.TESTFIELD("Screener Remarks");
            HrMgt.CheckDocumentApprover(Overtime."No.");
            CheckResignationAttachmentMandatoryForOvertime(Overtime);
            if not Confirm(ConfirmScreen, false) then
                exit;

            Overtime.Validate("Approval Status", Overtime."Approval Status"::Screened);
            Overtime.Modify;
        end
        else if Overtime.Type = Overtime.Type::"Travel Claim" then begin
            /*HRSetup.GET;
            Employee.RESET;
            Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
            Employee.SETRANGE("NAV Login ID", USERID);
            IF NOT Employee.FINDFIRST THEN
                ERROR('Not authorized screener.');*///AT
            if not (Overtime."Approval Status" = Overtime."Approval Status"::Approved) then
                Error('Approval Status must be approved before screening.');
            if not Confirm(ConfirmScreen, false) then
                exit;

            Overtime.Validate("Approval Status", Overtime."Approval Status"::Screened);
            Overtime.Modify;
        end else if Overtime.Type = Overtime.Type::Overtime then begin
            Overtime.TestField("Approval Status", Overtime."Approval Status"::Approved);
            if not Confirm(ConfirmScreen, false) then
                exit;

            Overtime.Validate("Approval Status", Overtime."Approval Status"::Screened);
            Overtime.Modify;
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
        CheckResignationAttachmentMandatoryForResignation(Resignation);
        if GuiAllowed then
            if not Confirm(ConfirmScreen, false) then
                exit;

        Resignation.Validate("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
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

    procedure CheckResignationAttachmentMandatoryforTravel(var TravelReq: Record "Travel Request")
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin

        IncomingDocument.Reset;
        IncomingDocument.SetRange("No.", TravelReq."No.");
        IncomingDocument.SetRange("File Name", '');
        if IncomingDocument.FindFirst then
            repeat
                AttachmentSetup.Reset;
                AttachmentSetup.SetRange(Mandatory, true);
                AttachmentSetup.SetFilter(Type, Format(TravelReq.Type));
                AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
                if AttachmentSetup.FindFirst then
                    Error('Upload attachment for %1', IncomingDocument."Attachment Code");

            until IncomingDocument.Next = 0;
    end;

    procedure CheckResignationAttachmentMandatory(var EmpAct: Record "Employee Activity")
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin

        IncomingDocument.Reset;
        IncomingDocument.SetRange("No.", EmpAct."No.");
        IncomingDocument.SetRange("File Name", '');
        if IncomingDocument.FindFirst then
            repeat
                AttachmentSetup.Reset;
                AttachmentSetup.SetRange(Mandatory, true);
                AttachmentSetup.SetFilter(Type, Format(EmpAct.Type));
                AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
                if AttachmentSetup.FindFirst then
                    Error('Upload attachment for %1', IncomingDocument."Attachment Code");

            until IncomingDocument.Next = 0;
    end;

local procedure CheckResignationAttachmentMandatoryForResignation(var Resignation: Record "Resignation")
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

 local procedure CheckResignationAttachmentMandatoryForOvertime(var OverTime: Record "OverTime")
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin

        IncomingDocument.Reset;
        IncomingDocument.SetRange("No.", OverTime."No.");
        IncomingDocument.SetRange("File Name", '');
        if IncomingDocument.FindFirst then
            repeat
                AttachmentSetup.Reset;
                AttachmentSetup.SetRange(Mandatory, true);
                AttachmentSetup.SetFilter(Type, Format(OverTime.Type));
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
        Resignation.TestField("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
        if Confirm('Do you want to return resignation?', false) then begin
            Resignation.Validate("Approval Status", Resignation."Approval Status"::Open);
            Resignation.Modify;
            Message('Resignation Returned.');
        end;
    end;
    var
        Employee: Record Employee;
        Employee1:Record Employee;
        HRSetup:Record "Human Resources Setup";
        HrMgt: Codeunit "HR Mgt.";
}
