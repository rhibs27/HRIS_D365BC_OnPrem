codeunit 50003 "AppraisalMgt."
{
    var
        CodeunitEmailMessage: Codeunit "Email Message";
        Employee: Record Employee;
        Colon: Label ' : ';
        Email: Codeunit Email;

    local procedure "------Appraisal---------"()
    begin
    end;

    procedure AppraisalEmail(AppraisalCode: Code[20]; EmployeeCode: Code[20])
    var
        AppraisalRec: Record Appraisal;
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Counter: Integer;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        HRSetup.TestField("Email Appraisal");
        AppraisalRec.Reset;
        Counter := 0;
        AppraisalRec.SetRange("Appraisal Code", AppraisalCode);
        if AppraisalRec.FindFirst then
            repeat
                if EmailTemplate.Get(HRSetup."Email Appraisal") then begin
                    Clear(Footer);
                    Clear(Header);
                    Clear(Body);
                    Employee.Get(EmployeeCode);
                    // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Employee."E-Mail(Personal)", EmailTemplate.Subject, '', true);
                    CodeunitEmailMessage.Create(Employee."E-Mail", EmailTemplate.Subject, '');
                    EmailMessage.SetRange("Template Code", EmailTemplate.Code);
                    if EmailMessage.FindFirst then
                        repeat
                            case EmailMessage.Type of
                                EmailMessage.Type::Header:
                                    Header := Header + EmailMessage."Body Message";

                                EmailMessage.Type::Body:
                                    Body := Body + EmailMessage."Body Message";

                                EmailMessage.Type::Footer:
                                    Footer := Footer + EmailMessage."Body Message";
                            end;
                        until EmailMessage.Next = 0;
                    CodeunitEmailMessage.AppendToBody(Header);
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                    CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("Appraisal Code") + Colon + Format(AppraisalRec."Appraisal Code"));
                    CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("Employee Name") + Colon + Format(AppraisalRec."Employee Name"));
                    CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("Appraisal Type") + Colon + Format(AppraisalRec."Appraisal Type"));
                    CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("KRA Category") + Colon + Format(AppraisalRec."KRA Category"));
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                    CodeunitEmailMessage.AppendToBody(Footer);
                    if Email.Send(CodeunitEmailMessage) then
                        Counter += 1;
                end;
            until AppraisalRec.Next = 0;
        if Counter <> 0 then
            Message('Mail Sent');
    end;

    procedure CancelAppraisalApproval(var Appraisal: Record Appraisal)
    var
        ConfirmCancel: Label 'Do you want to confirm cancel appraisal request?';
    begin
        Appraisal.TestField(Status, Appraisal.Status::Submitted);
        if not Confirm(ConfirmCancel, false) then
            exit;
        Appraisal.Validate(Status, Appraisal.Status::Cancelled);
        Appraisal.Modify(true);
    end;

    procedure ApproveRejectAppraisal(Approve: Boolean; var Appraisal: Record Appraisal)
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        CheckAppraisalApproval(Appraisal); //check authorized
        if Approve then begin
            if not Confirm(ConfirmApprove, false) then
                exit;
            if Appraisal.Status = Appraisal.Status::Requested then
                Appraisal.Validate(Status, Appraisal.Status::Reviewed)
            else if Appraisal.Status = Appraisal.Status::Reviewed then
                Appraisal.Validate(Status, Appraisal.Status::"Check Reviewed")
            else if Appraisal.Status = Appraisal.Status::"Check Reviewed" then
                Appraisal.Validate(Status, Appraisal.Status::Approved);
        end
        else begin
            if not Confirm(ConfirmReject, false) then
                exit;
            Appraisal.Validate(Status, Appraisal.Status::Requested);
        end;

        Appraisal.Modify;
    end;

    local procedure CheckAppraisalApproval(Appraisal: Record Appraisal)
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        ReviewNotEligibleError: Label 'You are not Eligible to review this document.';
        CheckReviewNotEligibleError: Label 'You are not Eligible to check review this document.';
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        if Appraisal.Status = Appraisal.Status::Requested then
            if StrPos(Appraisal.Reviewer, Employee."No.") = 0 then
                Error(ReviewNotEligibleError);
        if Appraisal.Status = Appraisal.Status::Reviewed then
            if StrPos(Appraisal."Check Reviewer", Employee."No.") = 0 then
                Error(CheckReviewNotEligibleError);
        if Appraisal.Status = Appraisal.Status::"Check Reviewed" then
            if StrPos(Appraisal."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);
    end;

    procedure OnValidateKRACategory(AppraisalRec: Record Appraisal)
    var
        KRASubform: Record "KRA Subform List";
    begin
        KRASubform.Reset;
        KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KRASubform.SetRange("Employee Code", AppraisalRec."Employee Code");
        KRASubform.DeleteAll;

        if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Annually then begin
            ValidateKRAInEmployeeKRAAnnually(AppraisalRec);
            ValidateKRAInEmployeeKPIAnnually(AppraisalRec);
            ValidateKRAInEmployeeSATKPIAnnually(AppraisalRec);
            InsertEmployeeKPIAnnually(AppraisalRec);
        end else begin
            ValidateKRAInEmployeeKRA(AppraisalRec);
            InsertEmployeeKPI(AppraisalRec);
        end;
    end;

    local procedure ValidateKRAInEmployeeKRA(AppraisalRec: Record Appraisal)
    var
        KRAMaster: Record "KRA Master Setup";
        KRASubform: Record "KRA Subform List";
    begin
        KRAMaster.Reset;
        KRAMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
        KRAMaster.SetRange("Deputation on", KRAMaster."Deputation on"::" ");
        KRAMaster.SetFilter(Weightage, '>%1', 0);
        if KRAMaster.FindFirst then
            repeat
                KRASubform.Reset;
                KRASubform.Init;
                KRASubform.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
                KRASubform.Validate("KRA Category", KRAMaster."KRA Category");
                KRASubform.Validate(Description, KRAMaster."KRA Master Name");
                KRASubform.Validate("Key Result Area", KRAMaster."Key Result Area");
                KRASubform.Validate("Weightage (%)", KRAMaster.Weightage);
                KRASubform.Validate("Employee Code", AppraisalRec."Employee Code");
                KRASubform.Insert;
            until KRAMaster.Next = 0;
        KRASubform.Reset;
        KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KRASubform.CalcSums("Weightage (%)");
        if KRASubform."Weightage (%)" <> 100 then
            Error('Sum of KRA (%1)weightage must be 100. Please contact admin.', AppraisalRec."KRA Category");
    end;

    procedure InsertEmployeeKPI(AppraisalRec: Record Appraisal)
    var
        KPIMaster: Record "KPI Master";
        KPIEmpRec: Record "KPI Employee";
        KRASubform: Record "KRA Subform List";
        KPIWeightage: Decimal;
    begin
        AppraisalRec.TestField("KRA Category");
        KPIMaster.Reset;
        KPIMaster.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
        KPIMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
        KPIMaster.SetRange("Appraisal Type", AppraisalRec."Appraisal Type");
        if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Monthly then
            KPIMaster.SetRange("Appraisal Subtype Monthly", AppraisalRec."Appraisal Subtype Monthly")
        else if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Quarterly then
            KPIMaster.SetRange("Appraisal Subtype Quarterly", AppraisalRec."Appraisal Subtype Quarterly");

        KPIEmpRec.Reset;
        KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KPIEmpRec.SetRange("Employee Code", AppraisalRec."Employee Code");
        KPIEmpRec.DeleteAll;
        if KPIMaster.Find('-') then
            repeat
            begin
                KPIEmpRec.Init;
                KPIEmpRec.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
                KPIEmpRec.Validate("Employee Code", AppraisalRec."Employee Code");
                KPIEmpRec.Validate("KRA Category", KPIMaster."KRA Category");
                KPIEmpRec.Validate("Fiscal Year", AppraisalRec."Fiscal Year");
                KPIEmpRec.Validate("Appraisal Type", KPIMaster."Appraisal Type");
                KPIEmpRec.Validate("Appraisal Subtype Monthly", KPIMaster."Appraisal Subtype Monthly");
                KPIEmpRec.Validate("Appraisal Subtype Quarterly", KPIMaster."Appraisal Subtype Quarterly");
                KPIEmpRec.Validate(Description, KPIMaster.Description);
                KPIEmpRec.Validate("KPI No.", KPIMaster."KPI No.");
                KPIEmpRec.Validate(Description, KPIMaster.Description);
                KPIEmpRec.Validate("Key Result Area", KPIMaster."Key Result Area");
                KPIEmpRec.Validate("Weightage(%)", KPIMaster."Weightage (%)");
                KPIEmpRec.Validate("Target Assigned", KPIMaster."Target Assigned");
                KPIEmpRec.Validate("From Setup", true);
                KPIEmpRec.Insert(true);
            end;
            until KPIMaster.Next = 0;
        KRASubform.Reset;
        KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        if KRASubform.Find('-') then
            repeat
                Clear(KPIWeightage);
                KPIEmpRec.Reset;
                KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
                KPIEmpRec.SetRange("Key Result Area", KRASubform."Key Result Area");
                KPIEmpRec.CalcSums("Weightage(%)");
                KPIWeightage := KPIEmpRec."Weightage(%)";
                if (KPIEmpRec.FindFirst) and (KPIWeightage <> 100) then
                    Error('Total weightage of KPIs in KRA (%1) must be 100', KRASubform.Description);
            until KRASubform.Next = 0;
    end;

    procedure CalculateKPIMarks(AppraisalRec: Record Appraisal)
    var
        KRASubform: Record "KRA Subform List";
        TotalWeight: Decimal;
        TotalMarks: Decimal;
        KPIRec: Record "KPI Employee";
        KRAWeight: Decimal;
    begin
        Clear(KRAWeight);
        KRASubform.Reset;
        KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KRASubform.CalcSums("Weightage (%)");
        KRAWeight := KRASubform."Weightage (%)";
        if KRASubform.Find('-') then
            repeat
                KPIRec.Reset;
                KPIRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
                KPIRec.SetRange("Employee Code", AppraisalRec."Employee Code");
                KPIRec.SetRange("Key Result Area", KRASubform."Key Result Area");
                if KPIRec.Find('-') then
                    repeat
                        TotalWeight += KPIRec."Weightage(%)";
                        TotalMarks += (KPIRec."Weightage(%)" * KPIRec.Score);
                    until KPIRec.Next = 0;
                KRASubform.Validate(Score, Round(TotalMarks / TotalWeight, 0.01, '='));
                if KRAWeight <> 0 then
                    KRASubform.Validate("Final Score", Round(TotalMarks * KRASubform."Weightage (%)" / KRAWeight));
                KRASubform.Modify;
            until KRASubform.Next = 0;
    end;

    procedure CalculateFinalScore(AppraisalRec: Record Appraisal)
    var
        KRASubform: Record "KRA Subform List";
        TotalWeight: Decimal;
        TotalMarks: Decimal;
    begin
        Clear(TotalMarks);
        Clear(TotalWeight);
        KRASubform.Reset;
        KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        if KRASubform.Find('-') then
            repeat
                TotalWeight += KRASubform."Weightage (%)";
                TotalMarks += (KRASubform."Weightage (%)" * KRASubform."HR Score");
            until KRASubform.Next = 0;
        if TotalWeight > 0 then
            AppraisalRec.Validate("Final Score", Round(TotalMarks / TotalWeight, 0.01, '='));
        AppraisalRec.Modify;
    end;

    local procedure ValidateKRAInEmployeeKPIAnnually(AppraisalRec: Record Appraisal)
    var
        KRAMaster: Record "KRA Master Setup";
        EmployeeKPI: Record "KPI Employee";
        LineNo: Integer;
    begin

        KRAMaster.Reset;
        KRAMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
        KRAMaster.SetRange("Deputation on", AppraisalRec."Deputation on");
        KRAMaster.SetFilter(Description, '<>%1', '');
        KRAMaster.SetFilter("Key Result Area", '<>%1', 'CAPACITY');
        if AppraisalRec."Deputation on" in [AppraisalRec."Deputation on"::Branch, AppraisalRec."Deputation on"::"Extension Counter"] then
            KRAMaster.SetRange("Sol Id", AppraisalRec."Sol Id")
        else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::Province then
            KRAMaster.SetRange("Province Code", AppraisalRec.Province);
        // else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::"Sub Province" then
        // KRAMaster.SetRange("Sub Province Code", AppraisalRec."Sub-Province");
        if KRAMaster.FindFirst then
            repeat
                EmployeeKPI.Reset;
                LineNo += 10000;
                EmployeeKPI.Init;
                EmployeeKPI.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
                EmployeeKPI."Line No." := LineNo;
                EmployeeKPI.Validate("Key Result Area", KRAMaster."Key Result Area");
                EmployeeKPI.Validate("KRA Category", KRAMaster."KRA Category");
                EmployeeKPI.Validate(Description, KRAMaster.Description);
                EmployeeKPI.Validate("Weightage(%)", KRAMaster."Weightage Percent");
                EmployeeKPI.Validate("Target Assigned", KRAMaster."Target Assigned");
                //EmployeeKPI.Validate("Actual Achievement", KRAMaster."Actual Achievement");
                EmployeeKPI.Validate("Employee Code", AppraisalRec."Employee Code");
                EmployeeKPI.Validate("Deputation on", KRAMaster."Deputation on");
                EmployeeKPI."From Setup" := true;
                EmployeeKPI.Insert;
            until KRAMaster.Next = 0;
    end;

    local procedure ValidateKRAInEmployeeSATKPIAnnually(AppraisalRec: Record Appraisal)
    var
        KRAMaster: Record "KRA Master Setup";
        EmployeeKPI: Record "KPI Employee";
        LineNo: Integer;
    begin

        KRAMaster.Reset;
        KRAMaster.SetRange("Employee Code", AppraisalRec."Employee Code");
        KRAMaster.SetFilter("Key Result Area", 'CAPACITY');
        if KRAMaster.FindFirst then
            repeat
                EmployeeKPI.Reset;
                LineNo += 10000;
                EmployeeKPI.Init;
                EmployeeKPI.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
                EmployeeKPI."Line No." := LineNo;
                EmployeeKPI.Validate("Key Result Area", KRAMaster."Key Result Area");
                EmployeeKPI.Validate("KRA Category", KRAMaster."KRA Category");
                EmployeeKPI.Validate(Description, KRAMaster.Description);
                EmployeeKPI.Validate("Weightage(%)", KRAMaster."Weightage Percent");
                EmployeeKPI.Validate("Target Assigned", KRAMaster."Target Assigned");
                // EmployeeKPI.Validate("Actual Achievement", KRAMaster."Actual Achievement");
                EmployeeKPI.Validate("Employee Code", AppraisalRec."Employee Code");
                EmployeeKPI.Validate("Deputation on", AppraisalRec."Deputation on");
                EmployeeKPI."From Setup" := true;
                EmployeeKPI.Insert;
            until KRAMaster.Next = 0;
    end;

    local procedure ValidateKRAInEmployeeKRAAnnually(AppraisalRec: Record Appraisal)
    var
        KRAMaster: Record "KRA Master Setup";
        KRASubform: Record "KRA Subform List";
    begin
        KRAMaster.Reset;
        KRAMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
        //Commented by Santosh
        // KRAMaster.SetRange("Deputation on", AppraisalRec."Deputation on");
        // if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::Branch then
        //     KRAMaster.SetRange("Sol Id", AppraisalRec."Sol Id")
        // else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::"Extension Counter" then
        //     KRAMaster.SetRange("Sol Id", AppraisalRec."Sol Id")
        // else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::Province then
        //     KRAMaster.SetRange("Province Code", AppraisalRec.Province)
        // else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::"Sub Province" then
        //     KRAMaster.SetRange("Sub Province Code", AppraisalRec."Sub-Province");
        if KRAMaster.FindFirst then
            repeat
                KRASubform.Reset;
                KRASubform.Init;
                KRASubform.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
                KRASubform.Validate("KRA Category", KRAMaster."KRA Category");
                KRASubform.Validate(Description, KRAMaster."KRA Master Name");
                KRASubform.Validate("Key Result Area", KRAMaster."Key Result Area");
                KRASubform.Validate("Weightage (%)", KRAMaster.Weightage);
                KRASubform.Validate("Employee Code", AppraisalRec."Employee Code");
                KRASubform.Insert;
            until KRAMaster.Next = 0;
        KRASubform.Reset;
        KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KRASubform.CalcSums("Weightage (%)");
        if KRASubform."Weightage (%)" <> 100 then
            Error('Sum of KRA (%1)weightage must be 100. Please contact admin.', AppraisalRec."KRA Category");
    end;

    procedure InsertEmployeeKPIAnnually(AppraisalRec: Record Appraisal)
    var
        KPIMaster: Record "KPI Master";
        KPIEmpRec: Record "KPI Employee";
    begin
        AppraisalRec.TestField("KRA Category");
        KPIMaster.Reset;
        KPIMaster.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
        KPIMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
        KPIMaster.SetRange("Appraisal Type", AppraisalRec."Appraisal Type");
        //Commented by Santosh
        // if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Monthly then
        //     KPIMaster.SetRange("Appraisal Subtype Monthly", AppraisalRec."Appraisal Subtype Monthly")
        // else if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Quarterly then
        //     KPIMaster.SetRange("Appraisal Subtype Quarterly", AppraisalRec."Appraisal Subtype Quarterly");

        KPIEmpRec.Reset;
        KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KPIEmpRec.SetRange("Employee Code", AppraisalRec."Employee Code");
        if KPIMaster.Find('-') then
            repeat
            begin
                KPIEmpRec.Validate("Employee Code", AppraisalRec."Employee Code");
                KPIEmpRec.Validate("Fiscal Year", AppraisalRec."Fiscal Year");
                KPIEmpRec.Validate("Appraisal Type", KPIMaster."Appraisal Type");
                //Commented by Santosh
                // KPIEmpRec.Validate("Appraisal Subtype Monthly", KPIMaster."Appraisal Subtype Monthly");
                // KPIEmpRec.Validate("Appraisal Subtype Quarterly", KPIMaster."Appraisal Subtype Quarterly");
                KPIEmpRec.Validate("KPI No.", KPIMaster."KPI No.");
                KPIEmpRec.Validate("Target Assigned", KPIMaster."Target Assigned");
                KPIEmpRec.Validate("From Setup", true);
                KPIEmpRec.Modify;
            end;
            until KPIMaster.Next = 0;
    end;

    procedure CheckAppraisalAttachmentMandatory(Var Appraisal: Record Appraisal)
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDoc: Record "Incoming Document";
    begin
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Appraisal);
        AttachmentSetup.SetRange(Mandatory, true);
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Reset;
                IncomingDoc.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDoc.SetRange("No.", Appraisal."Appraisal Code");
                IncomingDoc.SetRange("File Name", '');
                if IncomingDoc.FindFirst then
                    Error('Attachment filenot Uploaded for attachment %1', AttachmentSetup."Attachment Code");
            until AttachmentSetup.Next = 0;
    end;
}
