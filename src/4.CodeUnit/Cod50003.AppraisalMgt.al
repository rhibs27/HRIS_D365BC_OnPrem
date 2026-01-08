codeunit 50003 "AppraisalMgt."
{
    var
        HRMgt: Codeunit "HR Mgt.";
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

    procedure ValidateKRAInEmployeeQuestionnaire(AppraisalRec: Record Appraisal)
    var
        AppraisalQuestionnaireMaster: Record "Appraisal Questionnaire Master";
        EmployeeAppraisalQuestion: Record "Employee Appraisal Question";
        LineNo: Integer;
    begin
        EmployeeAppraisalQuestion.Reset();
        EmployeeAppraisalQuestion.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        EmployeeAppraisalQuestion.SetRange("Employee Code", AppraisalRec."Employee Code");
        if not EmployeeAppraisalQuestion.IsEmpty then
            EmployeeAppraisalQuestion.DeleteAll();
        AppraisalQuestionnaireMaster.Reset();
        AppraisalQuestionnaireMaster.SetRange("KRA Master", AppraisalRec."KRA Category");
        if AppraisalQuestionnaireMaster.FindSet() then begin
            LineNo := 10000;
            repeat
                EmployeeAppraisalQuestion.Init();
                EmployeeAppraisalQuestion."Appraisal Code" := AppraisalRec."Appraisal Code";
                EmployeeAppraisalQuestion."Employee Code" := AppraisalRec."Employee Code";
                EmployeeAppraisalQuestion."Employee Name" := AppraisalRec."Employee Name";
                EmployeeAppraisalQuestion."Line No." := LineNo;
                EmployeeAppraisalQuestion."Question" := AppraisalQuestionnaireMaster."Question";
                EmployeeAppraisalQuestion."Question Type" := AppraisalQuestionnaireMaster."Question Type";
                EmployeeAppraisalQuestion.Insert();
                LineNo := LineNo + 10000;
            until AppraisalQuestionnaireMaster.Next() = 0;
        end;
    end;

    procedure OnValidateKRACategory(AppraisalRec: Record Appraisal)
    var
        KPIEmployee: Record "KPI Employee";
    begin
        ValidateKRACategoryRules(AppraisalRec);
        KPIEmployee.Reset;
        KPIEmployee.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KPIEmployee.SetRange("Employee Code", AppraisalRec."Employee Code");
        KPIEmployee.DeleteAll;
        ValidateKRAInEmployeeKPIAnnually(AppraisalRec);
    end;

    procedure ValidateKRACategoryRules(AppraisalRec: Record Appraisal)
    var
        ApprisalKRAMaster: Record "Appraisal KRA Master";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        FiscalYearEndDate: Date;
        ServiceStartDate: Date;
        ServiceEndDate: Date;
    begin
        Employee.get(AppraisalRec."Employee Code");
        ApprisalKRAMaster.Reset;
        ApprisalKRAMaster.SetRange(Code, AppraisalRec."KRA Category");
        ApprisalKRAMaster.SetRange(Type, ApprisalKRAMaster.Type::"KRA Master");
        ApprisalKRAMaster.SetRange("Employment Type", Employee."Employment Type");
        if not ApprisalKRAMaster.FindFirst then
            Error('Selected KRA Category is not applicable for this employee.');
        case ApprisalKRAMaster."Check Date From" of
            ApprisalKRAMaster."Check Date From"::"Date of Employment":
                begin
                    if AppraisalRec."Date of Employement" = 0D then
                        Error('Date of Employment is not set.');
                    ServiceStartDate := AppraisalRec."Date of Employement";
                end;
            ApprisalKRAMaster."Check Date From"::"Confirmation Date":
                begin
                    if AppraisalRec."Confirmation Date" = 0D then
                        Error('Confirmation Date is not set.');
                    ServiceStartDate := AppraisalRec."Confirmation Date";
                end;
            else
                exit;
        end;
        if Format(ApprisalKRAMaster."Minimum Service Period") = '' then
            exit;
        ServiceEndDate := CalcDate(ApprisalKRAMaster."Minimum Service Period", ServiceStartDate);
        FiscalYearEndDate := HRMgt.ReturnEndDateFY(AppraisalRec."Fiscal Year");
        if FiscalYearEndDate = 0D then
            Error('Fiscal Year End Date not found.');
        if ServiceEndDate > FiscalYearEndDate then
            Error('Employee does not meet the minimum service period for this fiscal year.');
    end;

    procedure CalculateFinalScore(AppraisalRec: Record Appraisal)
    var
        WeightageSetup: Record "Appraisal Weightage Setup";
        RatingSetup: Record "Rating Setup";
        TotalWeightedScore: Decimal;
    begin
        WeightageSetup.Reset();
        WeightageSetup.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
        WeightageSetup.SetRange("Appraisal Type", AppraisalRec."Appraisal Type");
        WeightageSetup.SetRange("KRA Master", AppraisalRec."KRA Category");
        if not WeightageSetup.FindFirst() then
            Error('Weightage setup not found for Fiscal Year: %1, Appraisal Type: %2, KRA Category: %3',
      AppraisalRec."Fiscal Year", Format(AppraisalRec."Appraisal Type"), AppraisalRec."KRA Category");
        if WeightageSetup."Total Weightage" <> 100 then
            Error('Total weightage must be exactly 100%. Current total: %1%',
                  WeightageSetup."Total Weightage");
        TotalWeightedScore :=
            (AppraisalRec."Total Self Score" * WeightageSetup."Self Score" / 100) +
            (AppraisalRec."Total Immediate Supv Score" * WeightageSetup."Immediate Supervisor" / 100) +
            (AppraisalRec."Total Reviewer Score" * WeightageSetup."Reviewer" / 100) +
            (AppraisalRec."Total Group Performance Score" * WeightageSetup."Group Performance" / 100) +
            (AppraisalRec."Total HR Committee Score" * WeightageSetup."HR Committee" / 100);
        AppraisalRec."Total Final Score" := Round(TotalWeightedScore, 0.01, '=');
        //For rating
        RatingSetup.Reset();
        RatingSetup.SetRange(Type, RatingSetup.Type::Appraisal);
        RatingSetup.SetFilter(From, '<=%1', AppraisalRec."Total Final Score");
        RatingSetup.SetFilter("To", '>=%1', AppraisalRec."Total Final Score");
        if RatingSetup.FindFirst() then
            AppraisalRec."Final Grading" := RatingSetup.Rating;
        AppraisalRec.Modify(true);
    end;

    local procedure ValidateKRAInEmployeeKPIAnnually(AppraisalRec: Record Appraisal)
    var
        KPIMaster: Record "Appraisal KPI Master";
        EmployeeKPI: Record "KPI Employee";
        HRSetup: Record "Human Resources Setup";
        LineNo: Integer;
        TotalWeightageScoring: Decimal;
        TotalWeightageGroupBased: Decimal;
        MaxWeightage: Decimal;
        HasScoringKPIs: Boolean;
        HasGroupBasedKPIs: Boolean;
        ErrorMessage: Text;
    begin
        HRSetup.Get();
        MaxWeightage := HRSetup."Max Weightage";
        if MaxWeightage = 0 then
            Error('Max Weightage is not configured in Human Resources Setup. Please configure it before proceeding.');
        LineNo := 10000;
        KPIMaster.Reset;
        KPIMaster.SetRange("KRA Master", AppraisalRec."KRA Category");
        KPIMaster.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");

        case AppraisalRec."Appraisal Type" of
            AppraisalRec."Appraisal Type"::Annually:
                KPIMaster.SetRange("Appraisal Type", KPIMaster."Appraisal Type"::Annually);
            AppraisalRec."Appraisal Type"::Monthly:
                begin
                    KPIMaster.SetRange("Appraisal Type", KPIMaster."Appraisal Type"::Monthly);
                    KPIMaster.SetRange("Appraisal Subtype Monthly", AppraisalRec."Appraisal Subtype Monthly");
                end;
            AppraisalRec."Appraisal Type"::Quarterly:
                begin
                    KPIMaster.SetRange("Appraisal Type", KPIMaster."Appraisal Type"::Quarterly);
                    KPIMaster.SetRange("Appraisal Subtype Quarterly", AppraisalRec."Appraisal Subtype Quarterly");
                end;
        end;
        TotalWeightageScoring := 0;
        TotalWeightageGroupBased := 0;
        HasScoringKPIs := false;
        HasGroupBasedKPIs := false;

        if KPIMaster.FindSet() then
            repeat
                if ShouldIncludeKPI(KPIMaster, AppraisalRec) then begin
                    case KPIMaster."KPI Rating Type" of
                        KPIMaster."KPI Rating Type"::Scoring:
                            begin
                                TotalWeightageScoring += KPIMaster."Weightage";
                                HasScoringKPIs := true;
                            end;
                        KPIMaster."KPI Rating Type"::"Group Based":
                            begin
                                TotalWeightageGroupBased += KPIMaster."Weightage";
                                HasGroupBasedKPIs := true;
                            end;
                    end;
                end;
            until KPIMaster.Next() = 0;
        ErrorMessage := '';
        if HasScoringKPIs and (TotalWeightageScoring <> MaxWeightage) then begin
            if ErrorMessage <> '' then
                ErrorMessage += '\\';
            ErrorMessage += StrSubstNo('Scoring Weightage = %1', TotalWeightageScoring);
        end;
        if HasGroupBasedKPIs and (TotalWeightageGroupBased <> MaxWeightage) then begin
            if ErrorMessage <> '' then
                ErrorMessage += ' and ';
            ErrorMessage += StrSubstNo('Group Based Weightage = %1', TotalWeightageGroupBased);
        end;
        if ErrorMessage <> '' then
            Error('Max Weightage = %1 is not equal to %2', MaxWeightage, ErrorMessage);
        KPIMaster.Reset;
        KPIMaster.SetRange("KRA Master", AppraisalRec."KRA Category");
        KPIMaster.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");

        case AppraisalRec."Appraisal Type" of
            AppraisalRec."Appraisal Type"::Annually:
                KPIMaster.SetRange("Appraisal Type", KPIMaster."Appraisal Type"::Annually);
            AppraisalRec."Appraisal Type"::Monthly:
                begin
                    KPIMaster.SetRange("Appraisal Type", KPIMaster."Appraisal Type"::Monthly);
                    KPIMaster.SetRange("Appraisal Subtype Monthly", AppraisalRec."Appraisal Subtype Monthly");
                end;
            AppraisalRec."Appraisal Type"::Quarterly:
                begin
                    KPIMaster.SetRange("Appraisal Type", KPIMaster."Appraisal Type"::Quarterly);
                    KPIMaster.SetRange("Appraisal Subtype Quarterly", AppraisalRec."Appraisal Subtype Quarterly");
                end;
        end;
        if KPIMaster.FindFirst() then
            repeat
                if ShouldIncludeKPI(KPIMaster, AppraisalRec) then begin
                    EmployeeKPI.Init;
                    EmployeeKPI."Appraisal Code" := AppraisalRec."Appraisal Code";
                    EmployeeKPI."KPI No." := KPIMaster."KPI No.";
                    EmployeeKPI."Fiscal Year" := AppraisalRec."Fiscal Year";
                    EmployeeKPI."Line No." := LineNo;
                    EmployeeKPI."Employee Code" := AppraisalRec."Employee Code";
                    EmployeeKPI."Employee Name" := AppraisalRec."Employee Name";
                    EmployeeKPI."KRA Master" := KPIMaster."KRA Master";
                    EmployeeKPI."KRA Subtype" := KPIMaster."KRA Subtype";
                    EmployeeKPI."Appraisal Type" := KPIMaster."Appraisal Type";
                    EmployeeKPI."Appraisal Subtype Monthly" := KPIMaster."Appraisal Subtype Monthly";
                    EmployeeKPI."Appraisal Subtype Quarterly" := KPIMaster."Appraisal Subtype Quarterly";
                    EmployeeKPI."Questionnaire/Description" := KPIMaster."Questionnaire/Description";
                    EmployeeKPI."KPI Rating Type" := KPIMaster."KPI Rating Type";
                    EmployeeKPI."Weightage" := KPIMaster."Weightage";
                    EmployeeKPI."Self Rating Applicable" := KPIMaster."Self Rating Applicable";
                    EmployeeKPI."Group Performance Based Score" := KPIMaster."Group Performance Based Score";
                    EmployeeKPI."KPI Master Remarks" := KPIMaster."KPI Master Remarks";
                    EmployeeKPI."From Setup" := true;
                    EmployeeKPI.Insert();
                    LineNo := LineNo + 10000;
                end;
            until KPIMaster.Next() = 0;
    end;

    local procedure ValidateKRAInEmployeeKRAAnnually(AppraisalRec: Record Appraisal)
    var
        KPIMaster: Record "Appraisal KPI Master";
        KpiEmployee: Record "KPI Employee";
        TotalWeightage: Decimal;
        Counter: Integer;
    begin
        KpiEmployee.Reset;
        KpiEmployee.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KpiEmployee.DeleteAll();
        KPIMaster.Reset;
        KPIMaster.SetRange("KRA Master", AppraisalRec."KRA Category");
        KPIMaster.SetRange("Appraisal Type", KPIMaster."Appraisal Type"::Annually);
        if not KPIMaster.FindFirst() then
            Error('No Appraisal KPI Master records found for KRA Category: %1 with Appraisal Type = Annually. Please create KPI Master records.',
                  AppraisalRec."KRA Category");
        Counter := 0;
        TotalWeightage := 0;
        if KPIMaster.FindSet() then
            repeat
                Counter += 1;
                TotalWeightage += KPIMaster."Weightage";
                // Insert into KPI Employee
                KpiEmployee.Init;
                KpiEmployee."Appraisal Code" := AppraisalRec."Appraisal Code";
                KpiEmployee."Fiscal Year" := AppraisalRec."Fiscal Year";
                KpiEmployee."Employee Code" := AppraisalRec."Employee Code";
                KpiEmployee."Employee Name" := AppraisalRec."Employee Name";
                KpiEmployee."KRA Master" := KPIMaster."KRA Master";
                KpiEmployee."KRA Subtype" := KPIMaster."KRA Subtype";
                KpiEmployee."Appraisal Type" := KPIMaster."Appraisal Type";
                KpiEmployee."Appraisal Subtype Monthly" := KPIMaster."Appraisal Subtype Monthly";
                KpiEmployee."Appraisal Subtype Quarterly" := KPIMaster."Appraisal Subtype Quarterly";
                KpiEmployee."Questionnaire/Description" := KPIMaster."Questionnaire/Description";
                KpiEmployee."KPI Rating Type" := KPIMaster."KPI Rating Type";
                KpiEmployee."Weightage" := KPIMaster."Weightage";
                KpiEmployee."Self Rating Applicable" := KPIMaster."Self Rating Applicable";
                KpiEmployee."Group Performance Based Score" := KPIMaster."Group Performance Based Score";
                KpiEmployee."KPI Master Remarks" := KPIMaster."KPI Master Remarks";
                KpiEmployee."From Setup" := true;
                KpiEmployee.Insert();

            until KPIMaster.Next() = 0;

        Message('Total records found: %1, Total weightage: %2', Counter, TotalWeightage);

        // Optional: Check if total weightage = 100
        if TotalWeightage <> 100 then
            Message('Note: Sum of KRA (%1) weightage is %2 (should be 100).',
                    AppraisalRec."KRA Category", TotalWeightage);
    end;
    // procedure InsertEmployeeKPIAnnually(AppraisalRec: Record Appraisal)
    // var
    //     KPIMaster: Record "Appraisal KPI Master";
    //     KPIEmpRec: Record "KPI Employee";
    //     KRASubform: Record "KRA Subform List";
    //     KPIWeightage: Decimal;
    // begin
    //     AppraisalRec.TestField("KRA Category");
    //     KPIMaster.Reset;
    //     KPIMaster.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
    //     KPIMaster.SetRange("KRA Master", AppraisalRec."KRA Category");
    //     KPIMaster.SetRange("Appraisal Type", AppraisalRec."Appraisal Type");
    //     //Commented by Santosh
    //     // if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Monthly then
    //     //     KPIMaster.SetRange("Appraisal Subtype Monthly", AppraisalRec."Appraisal Subtype Monthly")
    //     // else if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Quarterly then
    //     //     KPIMaster.SetRange("Appraisal Subtype Quarterly", AppraisalRec."Appraisal Subtype Quarterly");

    //     KPIEmpRec.Reset;
    //     KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //     KPIEmpRec.SetRange("Employee Code", AppraisalRec."Employee Code");
    //     if KPIEmpRec.Find('-') then
    //         repeat
    //         begin
    //             KPIEmpRec.Validate("Employee Code", AppraisalRec."Employee Code");
    //             KPIEmpRec.Validate("Fiscal Year", AppraisalRec."Fiscal Year");
    //             KPIEmpRec.Validate("Appraisal Type", KPIMaster."Appraisal Type");
    //             //Commented by Santosh
    //             // KPIEmpRec.Validate("Appraisal Subtype Monthly", KPIMaster."Appraisal Subtype Monthly");
    //             // KPIEmpRec.Validate("Appraisal Subtype Quarterly", KPIMaster."Appraisal Subtype Quarterly");
    //             KPIEmpRec.Validate("KPI No.", KPIMaster."KPI No.");
    //             // KPIEmpRec.Validate("Target Assigned", KPIMaster."Target Assigned");
    //             KPIEmpRec.Validate("From Setup", true);
    //             KPIEmpRec.Modify;
    //         end;
    //         until KPIEmpRec.Next = 0;
    // end;
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

    local procedure ShouldIncludeKPI(KPIMaster: Record "Appraisal KPI Master"; AppraisalRec: Record Appraisal): Boolean
    var
        ShouldInclude: Boolean;
    begin
        if (KPIMaster."Employee No." = '') and
           (KPIMaster.Designation = '') and
           (KPIMaster."Province Code" = '') and
           (KPIMaster."Branch Code" = '') and
           (KPIMaster."Extension Counter Code" = '') and
           (KPIMaster."Department Code" = '') and
           (KPIMaster."Unit Code" = '') and
           (KPIMaster."Sub-Unit Code" = '') then begin
            ShouldInclude := true;
        end
        else begin
            ShouldInclude := true;
            if (KPIMaster."Employee No." <> '') and
               (KPIMaster."Employee No." <> AppraisalRec."Employee Code") then
                ShouldInclude := false;
            if (KPIMaster.Designation <> '') and
               (KPIMaster.Designation <> AppraisalRec.Designation) then
                ShouldInclude := false;
            if (KPIMaster."Province Code" <> '') and
               (KPIMaster."Province Code" <> AppraisalRec.Province) then
                ShouldInclude := false;
            if (KPIMaster."Branch Code" <> '') and
               (KPIMaster."Branch Code" <> AppraisalRec.Branch) then
                ShouldInclude := false;
            if (KPIMaster."Extension Counter Code" <> '') and
   (KPIMaster."Extension Counter Code" <> AppraisalRec."Extension Counter") then
                ShouldInclude := false;

            if (KPIMaster."Department Code" <> '') and
               (KPIMaster."Department Code" <> AppraisalRec."Department") then
                ShouldInclude := false;

            if (KPIMaster."Unit Code" <> '') and
               (KPIMaster."Unit Code" <> AppraisalRec."Unit") then
                ShouldInclude := false;

            if (KPIMaster."Sub-Unit Code" <> '') and
               (KPIMaster."Sub-Unit Code" <> AppraisalRec."Sub-unit") then
                ShouldInclude := false;
        end;
        exit(ShouldInclude);
    end;

    //Appraisal Changes
    procedure OpenAppraisalRequest(EmpCode: Code[20])
    var
        AppraisalRec: Record Appraisal;
        Employee: Record Employee;
        Approval: Record "Approval HRMS";
    begin
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::Appraisal);
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        Employee.Get(EmpCode);
        AppraisalRec.Reset();
        AppraisalRec.SetRange("Employee Code", EmpCode);
        AppraisalRec.SetRange("Approval Status", AppraisalRec."Approval Status"::Open);
        AppraisalRec.SetRange(Cancelled, false);
        if AppraisalRec.FindFirst() then begin
            Message('This Employee Already has open Appraisal Request. Click Ok to Open');
            PAGE.Run(PAGE::"Appraisal Form Card", AppraisalRec)
        end else begin
            AppraisalRec.Init;
            AppraisalRec.Validate("Employee Code", EmpCode);
            AppraisalRec.Validate("Approval Status", AppraisalRec."Approval Status"::Open);
            AppraisalRec.Validate("Requested Date", Today);
            AppraisalRec.Validate("Document Type", AppraisalRec."Document Type"::Appraisal);
            AppraisalRec.Insert(true);

            if GuiAllowed then
                PAGE.Run(PAGE::"Appraisal Form Card", AppraisalRec);
        end;
    end;

    procedure ApplyForAppraisal(var Appraisal: Record Appraisal): Code[20]
    var
        ConfirmAppraisal: Label 'Do you want to send appraisal request?';
        ApprovalHRMS: Record "Approval HRMS";
    begin
        Appraisal.TestField("Approval Status", Appraisal."Approval Status"::Open);
        Appraisal.TestField("Appraisal Type");
        if Appraisal."Appraisal Type" = Appraisal."Appraisal Type"::Monthly then
            Appraisal.TestField("Appraisal Subtype Monthly")
        else if Appraisal."Appraisal Type" = Appraisal."Appraisal Type"::Quarterly then
            Appraisal.TestField("Appraisal Subtype Quarterly");
        Appraisal.TestField("KRA Category");
        Appraisal.TestField("Immediate Supervisor");
        Appraisal.TestField("Reviewer");
        // Check for existing open appraisal
        CheckPendingAppraisal(Appraisal."Appraisal Code", Appraisal."Employee Code");
        if GuiAllowed then
            if not Confirm(ConfirmAppraisal, false) then
                exit('');
        CheckAppraisalAttachmentMandatory(Appraisal);
        //check Approval entries should already exist from KRA Category validation
        ApprovalHRMS.Reset();
        ApprovalHRMS.SetRange("Document No.", Appraisal."Appraisal Code");
        ApprovalHRMS.SetRange("Document Type", ApprovalHRMS."Document Type"::Appraisal);
        if ApprovalHRMS.IsEmpty then
            Error('Approval entries not found. Please reselect KRA Category.');
        //Change status of sequence 1 approvers from "Created" to "Open"
        ApprovalHRMS.SetRange("Approval Sequence", 1);
        ApprovalHRMS.SetRange("Approval Status", ApprovalHRMS."Approval Status"::Created);
        if ApprovalHRMS.FindSet() then
            repeat
                ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Open);
                ApprovalHRMS.Modify(true);
            until ApprovalHRMS.Next() = 0;

        // Update appraisal status to Pending
        Appraisal.Validate("Approval Status", Appraisal."Approval Status"::Pending);
        Appraisal.Validate(Status, Appraisal.Status::Submitted);
        Appraisal.Modify(true);

        // Send email notification
        if GuiAllowed then
            HRMgt.SendMailFromTemplate(
                DATABASE::Appraisal,
                Enum::"Employee Activity Type"::Appraisal,
                Enum::"Approval Status"::Pending,
                Appraisal."Immediate Supervisor",
                Appraisal."Appraisal Code",
                false
            );
        exit(Appraisal."Appraisal Code");
    end;

    procedure CheckPendingAppraisal(AppraisalCode: Code[20]; EmployeeNo: Code[20])
    var
        AppraisalTable: Record Appraisal;
        AppraisalError: Label 'Your appraisal request no. %1 has not been approved. Please make sure it is approved';
        IsHandled: Boolean;
    begin
        if IsHandled then
            exit;
        AppraisalTable.Reset;
        AppraisalTable.SetFilter("Appraisal Code", '<>%1', AppraisalCode);
        AppraisalTable.SetRange("Employee Code", EmployeeNo);
        AppraisalTable.SetRange("Approval Status", AppraisalTable."Approval Status"::Pending);
        AppraisalTable.SetRange(Cancelled, false);
        if AppraisalTable.FindFirst then
            Error(AppraisalError, AppraisalTable."Appraisal Code");
    end;

    procedure OpenCancelAppraisal(AppraisalRec: Record Appraisal)
    var
        TempCancelDocument: Record "Cancel Document" temporary;
        Approval: Record "Approval HRMS";
        HRSetup: Record "Human Resources Setup";
        IsHandled: Boolean;
    begin
        HRSetup.Get();
        if not IsHandled then begin
            if AppraisalRec.Cancelled then
                Error('Appraisal request no. %1 is already cancelled.', AppraisalRec."Appraisal Code");

            if AppraisalRec."Approved Date" + HRSetup."Cancel Document Upto (Days)" < Today then
                Error('Appraisal request no. %1 cannot be cancelled after %2',
                      AppraisalRec."Appraisal Code",
                      AppraisalRec."Approved Date" + HRSetup."Cancel Document Upto (Days)");
            AppraisalRec.TestField("Approval Status", AppraisalRec."Approval Status"::Approved);
            AppraisalRec.TestField("Cancelled Document No.", '');
            Approval.Reset();
            Approval.SetRange("Document No.", '');
            Approval.setRange("Document Type", Approval."Document Type"::Appraisal);
            Approval.SetRange("Employee No", AppraisalRec."Employee Code");
            Approval.DeleteAll();
            TempCancelDocument.Init;
            TempCancelDocument.Validate(Cancelled, true);
            TempCancelDocument.Validate("Employee No.", AppraisalRec."Employee Code");
            TempCancelDocument.Validate("Employee Name", AppraisalRec."Employee Name");
            TempCancelDocument.Validate("Approval Status", TempCancelDocument."Approval Status"::Open);
            TempCancelDocument.Validate(Type, Enum::"Employee Activity Type"::Appraisal);
            TempCancelDocument."Cancelled Document No." := AppraisalRec."Appraisal Code";
            TempCancelDocument."No." := '';
            TempCancelDocument.Insert;
            PAGE.Run(PAGE::"Cancel Document", TempCancelDocument);
        end;
    end;
}