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
                    // CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("KRA Category") + Colon + Format(AppraisalRec."KRA Category"));
                    CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("Appraisal Template") + Colon + Format(AppraisalRec."Appraisal Template"));
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
        Appraisal.TestField("Approval Status", Appraisal."Approval Status"::Pending);
        if not Confirm(ConfirmCancel, false) then
            exit;
        Appraisal.Validate("Approval Status", Appraisal."Approval Status"::Canceled);
        Appraisal.Modify(true);
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
        AppraisalQuestionnaireMaster.SetRange("Appraisal Template", AppraisalRec."Appraisal Template");
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
        InsertKPIReviewerType(AppraisalRec);
        InsertScoreDetail(AppraisalRec);
    end;

    procedure ValidateKRACategoryRules(AppraisalRec: Record Appraisal)
    var
        AppraisalTemplate: Record "Appraisal Template";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        FiscalYearEndDate: Date;
        ServiceStartDate: Date;
        ServiceEndDate: Date;
    begin
        Employee.get(AppraisalRec."Employee Code");
        AppraisalTemplate.Reset;
        AppraisalTemplate.SetRange("Template Master No.", AppraisalRec."Appraisal Template");
        AppraisalTemplate.SetRange("Employment Type", Employee."Employment Type");
        if not AppraisalTemplate.FindFirst then
            Error('Selected Appraisal Template is not applicable for this employee.');
        case AppraisalTemplate."Check Date From" of
            AppraisalTemplate."Check Date From"::"Date of Employment":
                begin
                    if AppraisalRec."Date of Employement" = 0D then
                        Error('Date of Employment is not set.');
                    ServiceStartDate := AppraisalRec."Date of Employement";
                end;
            AppraisalTemplate."Check Date From"::"Confirmation Date":
                begin
                    if AppraisalRec."Confirmation Date" = 0D then
                        Error('Confirmation Date is not set.');
                    ServiceStartDate := AppraisalRec."Confirmation Date";
                end;
            else
                exit;
        end;
        if Format(AppraisalTemplate."Minimum Service Period") = '' then
            exit;
        ServiceEndDate := CalcDate(AppraisalTemplate."Minimum Service Period", ServiceStartDate);
        FiscalYearEndDate := HRMgt.ReturnEndDateFY(AppraisalRec."Fiscal Year");
        if FiscalYearEndDate = 0D then
            Error('Fiscal Year End Date not found.');
        if ServiceEndDate > FiscalYearEndDate then
            Error('Employee does not meet the minimum service period for this fiscal year.');
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

    local procedure ShouldIncludeKPI(KPIMaster: Record "Appraisal KPI Master"; AppraisalRec: Record Appraisal): Boolean
    var
        ShouldInclude: Boolean;
        AppraisalTemplate: Record "Appraisal Template";
        TemplateKpiRatingType: Enum "KPI Rating Type";
    begin
        if not AppraisalTemplate.Get(AppraisalRec."Appraisal Template") then
            exit(false);
        TemplateKpiRatingType := AppraisalTemplate."KPI Rating Type";
        if KPIMaster."KPI Rating Type" <> TemplateKpiRatingType then
            exit(false);
        if (KPIMaster."Employee No." = '') and
           (KPIMaster."Functional Title" = '') and
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
            if (KPIMaster."Functional Title" <> '') and
               (KPIMaster."Functional Title" <> AppraisalRec."Functional Title") then
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
        ApproverMgt: Codeunit "Approver Mgt";
    begin
        Appraisal.TestField("Approval Status", Appraisal."Approval Status"::Open);
        Appraisal.TestField("Appraisal Type");
        if Appraisal."Appraisal Type" = Appraisal."Appraisal Type"::Monthly then
            Appraisal.TestField("Appraisal Subtype Monthly")
        else if Appraisal."Appraisal Type" = Appraisal."Appraisal Type"::Quarterly then
            Appraisal.TestField("Appraisal Subtype Quarterly");
        Appraisal.TestField("Appraisal Template");
        // Check for existing open appraisal
        CheckPendingAppraisal(Appraisal."Appraisal Code", Appraisal."Employee Code");
        if GuiAllowed then
            if not Confirm(ConfirmAppraisal, false) then
                exit('');
        CheckAppraisalAttachmentMandatory(Appraisal);
        //Change status of sequence 1 approvers from "Created" to "Open"
        ApproverMgt.UpdateFirstApproverStatus(Appraisal."Appraisal Code");
        // Update appraisal status to Pending
        Appraisal.Validate("Approval Status", Appraisal."Approval Status"::Pending);
        Appraisal.Modify(true);
        // Send email notification
        // if GuiAllowed then
        //     HRMgt.SendMailFromTemplate(
        //         DATABASE::Appraisal,
        //         Enum::"Employee Activity Type"::Appraisal,
        //         Enum::"Approval Status"::Pending,
        //         Appraisal."Immediate Supervisor",
        //         Appraisal."Appraisal Code",
        //         false
        //     );
        // exit(Appraisal."Appraisal Code");
    end;

    procedure CheckPendingAppraisal(AppraisalCode: Code[20]; EmployeeNo: Code[20])
    var
        AppraisalTable: Record Appraisal;
        AppraisalError: Label 'Your appraisal request no. %1 has not been approved. Please make sure it is approved';
        IsHandled: Boolean;
    begin
        AppraisalTable.Reset;
        AppraisalTable.SetFilter("Appraisal Code", '<>%1', AppraisalCode);
        AppraisalTable.SetRange("Employee Code", EmployeeNo);
        AppraisalTable.SetRange("Approval Status", AppraisalTable."Approval Status"::Pending);
        AppraisalTable.SetRange(Cancelled, false);
        if AppraisalTable.FindFirst then
            Error(AppraisalError, AppraisalTable."Appraisal Code");
    end;

    local procedure ShouldIncludeKPIForReviewerType(KPIMaster: Record "Appraisal KPI Master"; AppraisalRec: Record Appraisal; ReviewerSetup: Record "Reviewer Setup"; TemplateKpiRatingType: Enum "KPI Rating Type"): Boolean
    var
        ShouldInclude: Boolean;
        Employee: Record Employee;
    begin
        ShouldInclude := false;
        if not ShouldIncludeKPI(KPIMaster, AppraisalRec) then
            exit(false);
        if KPIMaster."KPI Rating Type" <> TemplateKpiRatingType then
            exit(false);
        if ReviewerSetup."Is Self Review" then begin
            ShouldInclude := KPIMaster."Self Rating Applicable";
        end
        else if ReviewerSetup."Is Group Based" then begin
            ShouldInclude := KPIMaster."Group Based";
            if ShouldInclude and (KPIMaster."Branch Code" <> '') then begin
                Employee.Get(AppraisalRec."Employee Code");
                ShouldInclude := (KPIMaster."Branch Code" = Employee."Branch Code");
            end;
        end
        else begin
            // other than Rating type/Group Based Rating type and Group Based FALSE
            ShouldInclude := (not KPIMaster."Group Based");
        end;
        exit(ShouldInclude);
    end;

    local procedure InsertKPIReviewerType(AppraisalRec: Record Appraisal)
    var
        KPIMaster: Record "Appraisal KPI Master";
        EmployeeKPI: Record "KPI Employee";
        ReviewerWeightageSetup: Record "Reviewer Weightage Setup";
        ReviewerSetup: Record "Reviewer Setup";
        AppraisalTemplate: Record "Appraisal Template";
        LineNo: Integer;
        MaxWeightage: Decimal;
        TotalWeightageScoring: Decimal;
        TotalWeightageRating: Decimal;
        TotalWeightageGroupBased: Decimal;
        HasScoringKPIs: Boolean;
        HasRatingKPIs: Boolean;
        HasGroupBasedKPIs: Boolean;
    begin
        MaxWeightage := 100;
        if not AppraisalTemplate.Get(AppraisalRec."Appraisal Template") then
            exit;
        EmployeeKPI.Reset();
        EmployeeKPI.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        if EmployeeKPI.FindLast() then
            LineNo := EmployeeKPI."Line No." + 10000
        else
            LineNo := 10000;
        ReviewerWeightageSetup.Reset();
        ReviewerWeightageSetup.SetRange("Appraisal Template", AppraisalRec."Appraisal Template");
        ReviewerWeightageSetup.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
        if ReviewerWeightageSetup.FindSet() then
            repeat
                if ReviewerSetup.Get(ReviewerWeightageSetup."Reviewer Type") then begin
                    TotalWeightageScoring := 0;
                    TotalWeightageRating := 0;
                    TotalWeightageGroupBased := 0;
                    HasScoringKPIs := false;
                    HasRatingKPIs := false;
                    HasGroupBasedKPIs := false;
                    KPIMaster.Reset();
                    KPIMaster.SetRange("Appraisal Template", AppraisalRec."Appraisal Template");
                    KPIMaster.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
                    if KPIMaster.FindSet() then
                        repeat
                            if ShouldIncludeKPIForReviewerType(KPIMaster, AppraisalRec, ReviewerSetup, AppraisalTemplate."KPI Rating Type")
                            then begin
                                case KPIMaster."KPI Rating Type" of
                                    KPIMaster."KPI Rating Type"::Scoring:
                                        if KPIMaster."Group Based" then begin
                                            TotalWeightageGroupBased += KPIMaster."Weightage";
                                            HasGroupBasedKPIs := true;
                                        end else begin
                                            TotalWeightageScoring += KPIMaster."Weightage";
                                            HasScoringKPIs := true;
                                        end;
                                    KPIMaster."KPI Rating Type"::Rating:
                                        if not KPIMaster."Group Based" then begin
                                            TotalWeightageRating += KPIMaster."Weightage";
                                            HasRatingKPIs := true;
                                        end;
                                end;

                            end;
                        until KPIMaster.Next() = 0;
                    if HasScoringKPIs and (TotalWeightageScoring <> MaxWeightage) then
                        Error('Reviewer Type %1: Individual Scoring Weightage must be %2.', ReviewerWeightageSetup."Reviewer Type", MaxWeightage);
                    if HasRatingKPIs and (TotalWeightageRating <> MaxWeightage) then
                        Error('Reviewer Type %1: Individual Rating Weightage must be %2.', ReviewerWeightageSetup."Reviewer Type", MaxWeightage);
                    if HasGroupBasedKPIs and (TotalWeightageGroupBased <> MaxWeightage) then
                        Error('Reviewer Type %1: Group Based Scoring Weightage must be %2.', ReviewerWeightageSetup."Reviewer Type", MaxWeightage);
                    // Insert KPIs
                    KPIMaster.Reset();
                    KPIMaster.SetRange("Appraisal Template", AppraisalRec."Appraisal Template");
                    KPIMaster.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
                    if KPIMaster.FindSet() then
                        repeat
                            if ShouldIncludeKPIForReviewerType(KPIMaster, AppraisalRec, ReviewerSetup, AppraisalTemplate."KPI Rating Type")
                            then begin
                                EmployeeKPI.Init();
                                EmployeeKPI."Appraisal Template" := KPIMaster."Appraisal Template";
                                EmployeeKPI."Appraisal Code" := AppraisalRec."Appraisal Code";
                                EmployeeKPI."KPI No." := KPIMaster."KPI No.";
                                EmployeeKPI."Fiscal Year" := AppraisalRec."Fiscal Year";
                                EmployeeKPI."Line No." := LineNo;
                                EmployeeKPI."Employee Code" := AppraisalRec."Employee Code";
                                EmployeeKPI."Employee Name" := AppraisalRec."Employee Name";
                                EmployeeKPI."KRA" := KPIMaster."KRA";
                                EmployeeKPI."KPI" := KPIMaster."KPI";
                                EmployeeKPI."Appraisal Type" := KPIMaster."Appraisal Type";
                                EmployeeKPI."Appraisal Subtype Monthly" := KPIMaster."Appraisal Subtype Monthly";
                                EmployeeKPI."Appraisal Subtype Quarterly" := KPIMaster."Appraisal Subtype Quarterly";
                                EmployeeKPI."Questionnaire/Description" := KPIMaster."Questionnaire/Description";
                                EmployeeKPI."KPI Rating Type" := KPIMaster."KPI Rating Type";
                                EmployeeKPI."Weightage" := KPIMaster."Weightage";
                                EmployeeKPI."Max Score" := KPIMaster."Max Score";
                                EmployeeKPI."Self Rating Applicable" := KPIMaster."Self Rating Applicable";
                                EmployeeKPI."Group Based" := KPIMaster."Group Based";
                                EmployeeKPI."KPI Master Remarks" := KPIMaster."KPI Master Remarks";
                                EmployeeKPI."Reviewer Type" := ReviewerWeightageSetup."Reviewer Type";
                                if ReviewerSetup."Is Group Based" and KPIMaster."Group Based" then begin
                                    EmployeeKPI.Score := KPIMaster."Group Performance Based Score";
                                    EmployeeKPI."Score Total" := ((EmployeeKPI.Score / EmployeeKPI."Max Score") * 100) * (EmployeeKPI.Weightage / 100);
                                end else begin
                                    EmployeeKPI.Score := 0;
                                    EmployeeKPI."Score Total" := 0;
                                end;
                                EmployeeKPI.Insert();
                                LineNo += 10000;
                            end;
                        until KPIMaster.Next() = 0;
                end;
            until ReviewerWeightageSetup.Next() = 0;
    end;

    procedure InsertScoreDetail(AppraisalRec: Record Appraisal)
    var
        ScoreDetail: Record "Score Detail";
        ReviewerWeightageSetup: Record "Reviewer Weightage Setup";
        EmployeeKPI: Record "KPI Employee";
        ReviewerSetup: Record "Reviewer Setup";
        Employee: Record Employee;
    begin
        ScoreDetail.Reset();
        ScoreDetail.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        if not ScoreDetail.IsEmpty then
            ScoreDetail.DeleteAll();
        ReviewerWeightageSetup.Reset();
        ReviewerWeightageSetup.SetRange("Appraisal Template", AppraisalRec."Appraisal Template");
        ReviewerWeightageSetup.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
        if not ReviewerWeightageSetup.FindSet() then
            Error('Reviewer Weightage Setup not found.');
        repeat
            EmployeeKPI.Reset();
            EmployeeKPI.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
            EmployeeKPI.SetRange("Reviewer Type", ReviewerWeightageSetup."Reviewer Type");
            if not EmployeeKPI.IsEmpty() then begin
                ScoreDetail.Init();
                ScoreDetail.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
                ScoreDetail.Validate("Appraisal Template", AppraisalRec."Appraisal Template");
                ScoreDetail.Validate("Fiscal Year", AppraisalRec."Fiscal Year");
                ScoreDetail.Validate("Reviewer Type", ReviewerWeightageSetup."Reviewer Type");
                ScoreDetail.Sequence := ReviewerWeightageSetup.Sequence;
                ScoreDetail.Weightage := ReviewerWeightageSetup.Weightage;
                ScoreDetail.Submitted := false;
                if ReviewerSetup.Get(ReviewerWeightageSetup."Reviewer Type") then begin
                    if ReviewerSetup."Is Self Review" then begin
                        if AppraisalRec."Employee Code" <> '' then
                            ScoreDetail.Validate("Score/Rating By", AppraisalRec."Employee Code");
                    end
                    else if ReviewerSetup."Is Group Based" then begin
                        ScoreDetail."Score/Rating By" := '';
                    end
                    else begin
                        Employee.Reset();
                        case ReviewerWeightageSetup."Deputation Type" of
                            ReviewerWeightageSetup."Deputation Type"::Province:
                                Employee.SetRange("Province Code", AppraisalRec.Province);
                            ReviewerWeightageSetup."Deputation Type"::Branch:
                                begin
                                    Employee.SetRange("Province Code", AppraisalRec.Province);
                                    Employee.SetRange("Branch Code", AppraisalRec.Branch);
                                end;
                            ReviewerWeightageSetup."Deputation Type"::Department:
                                begin
                                    Employee.SetRange("Province Code", AppraisalRec.Province);
                                    Employee.SetRange("Branch Code", AppraisalRec.Branch);
                                    Employee.SetRange("Department Code", AppraisalRec.Department);
                                end;
                            ReviewerWeightageSetup."Deputation Type"::"Extension Counter":
                                begin
                                    Employee.SetRange("Province Code", AppraisalRec.Province);
                                    Employee.SetRange("Branch Code", AppraisalRec.Branch);
                                    Employee.SetRange("Extension Counter Code", AppraisalRec."Extension Counter");
                                end;
                            ReviewerWeightageSetup."Deputation Type"::Unit:
                                begin
                                    Employee.SetRange("Province Code", AppraisalRec.Province);
                                    Employee.SetRange("Branch Code", AppraisalRec.Branch);
                                    Employee.SetRange("Department Code", AppraisalRec.Department);
                                    Employee.SetRange("Unit Code", AppraisalRec.Unit);
                                end;
                        end;
                        Employee.SetRange("Approver Role", ReviewerWeightageSetup."Approver Role");
                        if Employee.FindFirst() then
                            ScoreDetail.validate(ScoreDetail."Score/Rating By", Employee."No.")
                        else
                            Error('Approver Not found');
                    end;
                end;
                ScoreDetail.Insert(true);
            end;
        until ReviewerWeightageSetup.Next() = 0;
    end;

    procedure CalculateFinalMarks(Appraisal: Record Appraisal)
    var
        ScoreDetail: Record "Score Detail";
        TotalFinalScore: Decimal;
    begin
        // Appraisal.Validate("Total Final Score", 0);
        if appraisal."Total Final Score" = 0 then begin
            Clear(TotalFinalScore);
            ScoreDetail.Reset();
            ScoreDetail.SetRange("Appraisal Code", Appraisal."Appraisal Code");
            ScoreDetail.SetRange("Appraisal Template", Appraisal."Appraisal Template");
            ScoreDetail.SetRange("Fiscal Year", Appraisal."Fiscal Year");
            if ScoreDetail.FindSet() then begin
                repeat
                    ScoreDetail.CalcFields(Total);
                    if ScoreDetail.Total <> 0 then
                        TotalFinalScore += Round((ScoreDetail.Weightage * ScoreDetail.Total) / 100, 0.01);
                until ScoreDetail.Next() = 0;
                Appraisal.Validate("Total Final Score", TotalFinalScore);
                Appraisal.Modify(true);
                Message('Total Final Score calculated successfully');
            end else
                Message('No score details found for this appraisal');
        end;
    end;

    procedure CheckScoreDetailsSubmitted(AppraisalCode: Code[20])
    var
        ScoreDetail: Record "Score Detail";
    begin
        scoredetail.Reset;
        ScoreDetail.SetRange("Appraisal Code", AppraisalCode);
        ScoreDetail.SetRange(Submitted, false);
        if not ScoreDetail.IsEmpty() then
            Error('Cannot proceed. first Submit Score Detail');
    end;
}