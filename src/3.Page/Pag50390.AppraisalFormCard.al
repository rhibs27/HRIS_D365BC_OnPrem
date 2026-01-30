page 50390 "Appraisal Form Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Appraisal;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = (Rec.Status = Rec.Status::" ") or (Rec.Status = Rec.Status::open);
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                    ApplicationArea = All;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ToolTip = 'Specifies the value of the Appraisal Template field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                    Editable = DocumentEditable;
                    trigger OnValidate()
                    begin
                        SetLayout;
                    end;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }

                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;

                }
                field("Date of Employement"; Rec."Date of Employement")
                {
                    ToolTip = 'Specifies the value of the Date of Employement field.';
                    ApplicationArea = All;
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    ApplicationArea = All;
                }
                Field("KPI Rating Type"; Rec."KPI Rating Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        SetLayout;
                    end;
                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    Editable = FieldEditable1;
                    ToolTip = 'Specifies the value of the Appraisal Subtype Monthly field.';
                    ApplicationArea = All;

                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    Editable = FieldEditable2;
                    ToolTip = 'Specifies the value of the Appraisal Subtype Quarterly field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Extension Counter Name"; Rec."Extension Counter Name")
                {
                    ToolTip = 'Specifies the value of the Extension Counter Name field.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ToolTip = 'Specifies the value of the Unit Name field.';
                    ApplicationArea = All;
                }
                field("Sub-Unit Name"; Rec."Sub-Unit Name")
                {
                    ApplicationArea = All;
                }
                field("Designation"; Rec.Designation)
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Total Final Score"; Rec."Total Final Score")
                {
                    ToolTip = 'Specifies the value of the Total Final Score field.';
                    ApplicationArea = All;
                }
                field("Final Grading"; Rec."Final Grading")
                {
                    ToolTip = 'Specifies the value of the Final Grading field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
            }
            group("Appraisal's Details")
            {
                Visible = false;
                field("Reviewer III"; Rec."Reviewer III")
                {
                    ToolTip = 'Specifies the value of the Reviewer III field.';
                    ApplicationArea = All;
                }
                field("Submission Date"; Rec."Submission Date")
                {
                    Caption = 'Initiator Performance Appraisal Submission Date';
                    ToolTip = 'Specifies the value of the Initiator Performance Appraisal Submission Date field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
            }

            part("KPI Employee Score"; "KPI Employee")
            {
                Caption = 'KPI Employee Score';
                ApplicationArea = All;
                SubPageLink = "Appraisal Code" = field("Appraisal Code"), "Employee Code" = field("Employee Code");
            }
            part("Employee Appraisal Questions"; "Employee Appraisal Questions")
            {
                Caption = 'Employee Appraisal Questions';
                ApplicationArea = All;
                SubPageLink = "Appraisal Code" = field("Appraisal Code"), "Employee Code" = field("Employee Code");
            }
            part("Score Detail Subform"; "Score Detail Subform")
            {
                Caption = 'Score Details';
                ApplicationArea = All;
                SubPageLink = "Appraisal Code" = field("Appraisal Code"), "Appraisal Template" = field("Appraisal Template"), "Fiscal Year" = field("Fiscal Year");

            }

            group("Reportee's Comments")
            {
                Caption = 'Reportee''s Comments';
                Visible = FieldVisible;
                field("Reportees Comments"; Rec."Reportees Comments")
                {
                    Caption = 'Whether the reportee considers this report a fair performance assessment.';
                    ToolTip = 'Specifies the value of the Whether the reportee considers this report a fair performance assessment. field.';
                    ApplicationArea = All;
                }
            }
            group("Reviewer's Comments")
            {
                Caption = 'Reviewer''s Comments';
                Visible = FieldVisible;
                field("Reviewer Comments"; Rec."Reviewer Comments")
                {
                    Caption = 'Comments of Report Officers Reviewer';
                    ToolTip = 'Specifies the value of the Comments of Report Officers Reviewer field.';
                    ApplicationArea = All;
                }
            }
            group("Check Reviewer's Comments")
            {
                Caption = 'Check Reviewer''s Comments';
                Visible = FieldVisible;
                field("Check Reviewers Comments"; Rec."Check Reviewers Comments")
                {
                    Caption = 'Comments of Report Officers Check Review';
                    ToolTip = 'Specifies the value of the Comments of Report Officers Check Review field.';
                    ApplicationArea = All;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                SubPageLink = "Document No." = field("Appraisal Code");
                ApplicationArea = all;
                Editable = false;
            }
            // part(Attachment; "Attachment Subform")
            // {
            //     SubPageLink = "No." = field("Appraisal Code"), "Employee Code" = field("Employee Code");
            //     ApplicationArea = All;
            // }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ReOpen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the ReOpen action.';
                ApplicationArea = All;
                Enabled = not Rec.Posted;
                trigger OnAction()
                begin
                    //HRMgt.CalcExtendDays(Rec,FALSE);
                    Appraisal.Reset;
                    Appraisal.SetRange("Appraisal Code", Rec."Appraisal Code");
                    if Appraisal.FindFirst then
                        repeat
                            Appraisal.Status := Appraisal.Status::Open;
                            Appraisal.Posted := false;
                            Appraisal."Posting Date" := 0D;
                            Appraisal.Validate("Total Final Score", 0);
                            Clear(Rec."Final Grading");
                            Appraisal.Modify(true);
                        until Appraisal.Next = 0;
                    CurrPage.Close;
                end;
            }
            action("Request Appraisal")
            {
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                visible = (Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::Rejected);
                ToolTip = 'Executes the Request Appraisal action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    AppraisalMgt: Codeunit "AppraisalMgt.";
                begin
                    if AppraisalMgt.ApplyForAppraisal(Rec) <> '' then begin
                        Message('Appraisal has been sent for approval.');
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("Cancel Appraisal Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Appraisal Request action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    AppraisalMgt: Codeunit "AppraisalMgt.";
                begin
                    AppraisalMgt.OpenCancelAppraisal(Rec);
                end;
            }
            action("Send Review Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Submitted;
                ToolTip = 'Executes the Send Review Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
            action("Approve Review")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec.Status = Rec.Status::Requested;
                ToolTip = 'Executes the Approve Review action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    AppraisalMgt.ApproveRejectAppraisal(true, Rec);
                end;
            }
            action("Send Check Review Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ReviewSent;
                ToolTip = 'Executes the Send Check Review Request action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                begin
                    //AppraisalMgt.AppraisalEmail(Rec."Appraisal Code", Rec."Reviewer");
                    CurrPage.Close();
                end;
            }
            action("Approve Check Review")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec.Status = Rec.Status::Reviewed;
                ToolTip = 'Executes the Approve Check Review action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    AppraisalMgt.ApproveRejectAppraisal(true, Rec);
                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ApprovalSent;
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                begin
                    KRASubFormRec.Reset;
                    KRASubFormRec.SetRange("Appraisal Code", Rec."Appraisal Code");
                    KRASubFormRec.SetRange("Employee Code", Rec."Employee Code");
                    if KRASubFormRec.FindFirst then
                        repeat
                            KRASubFormRec.TestField(Remarks);
                        until KRASubFormRec.Next = 0;
                    CurrPage.Close();
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CheckReviewSent;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    RatingSetup: Record "Rating Setup";
                begin
                    AppraisalMgt.ApproveRejectAppraisal(true, Rec);
                    RatingSetup.Reset;
                    RatingSetup.SetRange(Type, RatingSetup.Type::Appraisal);
                    RatingSetup.SetFilter(From, '<=%1', Rec."Total Final Score");
                    RatingSetup.SetFilter("To", '>=%1', Rec."Total Final Score");
                    if RatingSetup.FindFirst then
                        Rec.Validate("Final Grading", RatingSetup.Rating);
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CheckReviewSent;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    AppraisalMgt.ApproveRejectAppraisal(false, Rec);
                end;
            }
            action("Calculate Final Marks")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Calculate Final Marks action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ScoreDetail: Record "Score Detail";
                    TotalFinalScore: Decimal;
                begin
                    if Confirm('Do you want to calculate marks?', false) then begin
                        Rec.Validate("Total Final Score", 0);
                        //TotalFinalScore := 0;
                        ScoreDetail.Reset();
                        ScoreDetail.SetRange("Appraisal Code", Rec."Appraisal Code");
                        ScoreDetail.SetRange("Appraisal Template", Rec."Appraisal Template");
                        ScoreDetail.SetRange("Fiscal Year", Rec."Fiscal Year");
                        if ScoreDetail.FindSet() then begin
                            repeat
                                ScoreDetail.CalcFields(Total);
                                if ScoreDetail.Total <> 0 then
                                    TotalFinalScore += Round((ScoreDetail.Weightage * ScoreDetail.Total) / 100, 0.01);
                            until ScoreDetail.Next() = 0;
                            Rec.Validate("Total Final Score", TotalFinalScore);

                            Rec.Modify(true);
                            Message('Total Final Score calculated successfully');
                        end else begin
                            Message('No score details found for this appraisal');
                        end;
                    end;
                end;
            }
            action("Approve")
            {
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Approves the appraisal and posts it if conditions are met.';
                ApplicationArea = All;
                Enabled = not Rec.Posted;
                trigger OnAction()
                var
                    AppraisalRec: Record Appraisal;
                begin
                    AppraisalRec.Get(Rec."Appraisal Code");
                    if AppraisalRec.Status <> AppraisalRec.Status::Pending then
                        Error('Approval cannot proceed. Appraisal status must be Pending.');
                    AppraisalRec.Validate(Status, AppraisalRec.Status::Approved);
                    AppraisalRec.Posted := true;
                    AppraisalRec."Posting Date" := WorkDate;
                    AppraisalRec.Modify(true);
                    CurrPage.Update();
                    Message('Appraisal approved and posted successfully.');
                end;
            }
            action("View Key Performance Indices")
            {
                Image = View;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the View Key Performance indices action.';
                trigger OnAction()
                var
                    KPIEmpRec: Record "KPI Employee";
                    HRMgt: Codeunit "HR Mgt.";
                begin
                    KPIEmpRec.Reset();
                    KPIEmpRec.SetRange("Appraisal Code", Rec."Appraisal Code");
                    KPIEmpRec.SetRange("Employee Code", Rec."Employee Code");
                    if not KPIEmpRec.FindFirst() then
                        Error('No KPI lines exist for this appraisal.');
                    OpenKPIForKRARelated(Rec);

                end;
            }
            action("KPI Assigned")
            {
                Image = Confirm;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    ChangeAppraisalStatus(Rec.Status::"KPI Assigned");
                end;
            }
            action("KPI Submitted")
            {
                Image = Confirm;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    ChangeAppraisalStatus(Rec.Status::Submitted);
                end;
            }
            action("KPI Reviewed")
            {
                Image = Confirm;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    ChangeAppraisalStatus(Rec.Status::Reviewed);
                end;
            }
            action("Check Reviewed")
            {
                Image = Confirm;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    ChangeAppraisalStatus(Rec.Status::"Check Reviewed");
                end;
            }
            // action("Change Reviewer / Check Reviewer")
            // {
            //     Image = ReOpen;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the Change Reviewer / Check Reviewer action.';
            //     ApplicationArea = All;
            //     trigger OnAction()
            //     begin
            //         Rec.ChangeReviewerCheckReviewerAppraisal;
            //     end;
            // }
            action("HR Reviewed")
            {
                Image = Confirm;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                trigger OnAction()
                begin
                    ChangeAppraisalStatus(Rec.Status::Pending);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        if not (Rec.Status = Rec.Status::Open) then
            FieldVisible := true
        else
            FieldVisible := false;
        SetLayout();
    end;

    var
        AppraisalMgt: Codeunit "AppraisalMgt.";
        KRASubFormRec: Record "KRA Subform List";
        Appraisal: Record Appraisal;
        FieldVisible: Boolean;
        Submitted: Boolean;
        DocumentEditable: Boolean;
        CheckReviewSent: Boolean;
        ReviewSent: Boolean;
        ApprovalSent: Boolean;
        RecommendationSent: Boolean;
        FieldEditable1: Boolean;
        FieldEditable2: Boolean;

    local procedure SetLayout()
    begin
        Submitted := Rec.Status in [Rec.Status::Submitted];
        ReviewSent := Rec.Status in [Rec.Status::Reviewed];
        CheckReviewSent := Rec.Status in [Rec.Status::"Check Reviewed"];
        ApprovalSent := Rec.Status in [Rec.Status::Approved];
        DocumentEditable := Rec.Status in [Rec.Status::Requested, Rec.Status::Open];
        RecommendationSent := Rec.Status in [Rec.Status::Recommended];
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
    end;

    local procedure ChangeAppraisalStatus(NewStatus: Enum "Appraisal Status")
    var
        AppraisalRec: Record Appraisal;
        ApprovalHRMS: Record "Approval HRMS";
    begin
        AppraisalRec.Get(Rec."Appraisal Code");
        if NewStatus = NewStatus::Pending then begin
            AppraisalRec.Validate(Status, NewStatus);
            AppraisalRec."Approval Status" := AppraisalRec."Approval Status"::Open;
            AppraisalRec.Modify(true);
            ApprovalHRMS.Reset();
            ApprovalHRMS.SetRange("Document No.", AppraisalRec."Appraisal Code");
            ApprovalHRMS.SetRange("Document Type", ApprovalHRMS."Document Type"::Appraisal);
            if ApprovalHRMS.FindSet() then begin
                repeat
                    if ApprovalHRMS."Approval Status" = ApprovalHRMS."Approval Status"::Created then begin
                        ApprovalHRMS."Approval Status" := ApprovalHRMS."Approval Status"::Open;
                        ApprovalHRMS.Modify();
                    end;
                until ApprovalHRMS.Next() = 0;
            end;
        end else begin
            AppraisalRec.Validate(Status, NewStatus);
            AppraisalRec.Modify(true);
        end;
        CurrPage.Update();
    end;

    local procedure OpenKPIForKRARelated(AppraisalRec: Record Appraisal)
    var
        KPIEmpRec: Record "KPI Employee";
    begin
        KPIEmpRec.Reset();
        KPIEmpRec.SetRange("Appraisal Template", AppraisalRec."Appraisal Template");
        KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
        KPIEmpRec.SetRange("Employee Code", AppraisalRec."Employee Code");
        Page.Run(Page::"KPI Employee", KPIEmpRec);
    end;
}