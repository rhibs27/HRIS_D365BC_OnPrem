page 50390 "Appraisal Form Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Appraisal;
    ApplicationArea = All;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = (Rec."Approval Status" = Rec."Approval Status"::" ") or (Rec."Approval Status" = Rec."Approval Status"::open);
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ToolTip = 'Specifies the value of the Appraisal Template field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                    //Editable = DocumentEditable;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        SetLayout;
                    end;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                    Editable = false;

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
                field("Functional Title"; Rec."Functional Title")
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

                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Editable = IsPending;
                    Visible = IsPending or IsRejected;
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
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

            part("KPI Employee"; "KPI Employee")
            {
                Caption = 'KPI Employee Score';
                ApplicationArea = All;
                SubPageLink = "Appraisal Code" = field("Appraisal Code"), "Employee Code" = field("Employee Code");
                UpdatePropagation = Both;

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
                UpdatePropagation = Both;

            }
            part("HRMS Approval Entry"; "HRMS Approval Entry")
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
                Enabled = IsPending;
                Visible = IsPending;
                trigger OnAction()
                var
                    ApprovalHRMS: Record "Approval HRMS";
                    AppraisalMgt: Codeunit "AppraisalMgt.";
                begin
                    if Confirm('Do you want to Reopen the Document?', false) then begin
                        Rec."Approval Status" := Appraisal."Approval Status"::Open;
                        Rec.Posted := false;
                        Rec."Posting Date" := 0D;
                        Rec.Validate("Total Final Score", 0);
                        Clear(Rec."Final Grading");
                        Rec.Modify(true);
                        ApprovalHRMS.Reset();
                        ApprovalHRMS.SetRange("Document No.", Rec."Appraisal Code");
                        ApprovalHRMS.SetRange("Document Type", ApprovalHRMS."Document Type"::Appraisal);
                        if ApprovalHRMS.FindSet() then
                            repeat
                                ApprovalHRMS."Approval Status" := ApprovalHRMS."Approval Status"::Created;
                                ApprovalHRMS."Approved By" := '';
                                ApprovalHRMS."Rejected By" := '';
                                ApprovalHRMS.Modify(true);
                            until ApprovalHRMS.Next() = 0;
                        CurrPage.Update();
                        Message('Document has been reopened');
                    end;
                end;
            }
            action("Request Appraisal")
            {
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                visible = Isopen;
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

            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                Visible = not IsApproved and not IsOpen;
                trigger OnAction()
                var
                    Appraisalmgt: codeunit "AppraisalMgt.";
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        Appraisalmgt.CheckScoreDetailsSubmitted(Rec."Appraisal Code");
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Message('Appraisal is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;
                Visible = IsPending and not IsOpen;
                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        ApprovalMgt.ApproveRejectDocument(RecRef, false);
                        Message('Appraisal is Rejected by %1', HRMgt.GetEmpName());
                    end;
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
                visible = not IsApproved;
                trigger OnAction()
                var
                    AppraisalMgt: Codeunit "AppraisalMgt.";
                begin
                    if not Confirm('Do you want to calculate marks?', false) then
                        exit;
                    AppraisalMgt.CheckScoreDetailsSubmitted(Rec."Appraisal Code");
                    AppraisalMgt.CalculateFinalMarks(Rec."Appraisal Code");
                end;
            }

            // action("View Key Performance Indices")
            // {
            //     Image = View;
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = process;
            //     ToolTip = 'Executes the View Key Performance indices action.';
            //     trigger OnAction()
            //     var
            //         KPIEmpRec: Record "KPI Employee";
            //         HRMgt: Codeunit "HR Mgt.";
            //     begin
            //         KPIEmpRec.Reset();
            //         KPIEmpRec.SetRange("Appraisal Code", Rec."Appraisal Code");
            //         KPIEmpRec.SetRange("Employee Code", Rec."Employee Code");
            //         if not KPIEmpRec.FindFirst() then
            //             Error('No KPI lines exist for this appraisal.');
            //         OpenKPIForKRARelated(Rec);

            //     end;
            // }

        }
    }
    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
        if IsApproved then
            CurrPage.Caption('Posted Appraisal Card');

    end;

    var
        ApprovalMgt: Codeunit "Approver Mgt";
        HRMgt: Codeunit "HR Mgt.";
        Appraisal: Record Appraisal;
        ReviewSent: Boolean;
        RecommendationSent: Boolean;
        FieldEditable1: Boolean;
        FieldEditable2: Boolean;
        RecRef: RecordRef;
        IsOpen, IsPending, IsApproved, IsRejected, IsCancelled : Boolean;
        StatusView, ApprovalStatusView : Boolean;

    local procedure SetLayout()
    begin
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsCancelled := Rec.Cancelled;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
        RecommendationSent := Rec."Approval Status" in [Rec."Approval Status"::Recommended];
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
        ReviewSent := Rec."Approval Status" in [Rec."Approval Status"::Reviewed];
        RecRef.GetTable(Rec);
    end;
}