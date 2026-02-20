page 50395 "Grievance Card"
{
    PageType = Card;
    SourceTable = "Grievance Header";
    ApplicationArea = All;
    Caption = 'Grievance Card';
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the grievance document number.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the employee who filed the grievance.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the name of the employee.';
                    ApplicationArea = All;
                }
                field("Grievance Date"; Rec."Grievance Date")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the date the grievance was filed.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    Editable = false;
                    ToolTip = 'Specifies the fiscal year.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the current approval status of the grievance.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Editable = IsSubmitted;
                    ToolTip = 'Specifies the reason for rejection.';
                    ApplicationArea = All;
                }
                field(Anonymous; Rec.Anonymous)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies if the grievance is filed anonymously.';
                    ApplicationArea = All;
                }
            }
            group(Placement)
            {
                Caption = 'Employee Placement';
                Editable = false;
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the department of the employee.';
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the branch of the employee.';
                    ApplicationArea = All;
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ToolTip = 'Specifies the deputation type.';
                    ApplicationArea = All;
                }
                field("Deputation On Code"; Rec."Deputation On Code")
                {
                    ToolTip = 'Specifies the deputation code.';
                    ApplicationArea = All;
                }
            }
            group("Grievance Details")
            {
                Caption = 'Grievance Details';
                field(Category; Rec.Category)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the category of the grievance.';
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the priority level of the grievance.';
                    ApplicationArea = All;
                }
                field(Severity; Rec.Severity)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the severity level of the grievance (S1=Critical, S2=High, S3=Medium, S4=Low).';
                    ApplicationArea = All;
                }
                field(Subject; Rec.Subject)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the subject of the grievance.';
                    ApplicationArea = All;
                }
                field("Against Employee No."; Rec."Against Employee No.")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the employee the grievance is filed against, if applicable.';
                    ApplicationArea = All;
                }
                field("Against Employee Name"; Rec."Against Employee Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the name of the employee the grievance is against.';
                    ApplicationArea = All;
                }
            }
            group(SLA)
            {
                Caption = 'SLA Deadlines';
                Visible = HasSLA;
                field("SLA Response Due"; Rec."SLA Response Due")
                {
                    Editable = false;
                    ToolTip = 'Specifies the deadline by which the grievance must be acknowledged, based on the SLA Matrix.';
                    ApplicationArea = All;
                    Style = Attention;
                    StyleExpr = IsSLAResponseBreached;
                }
                field("SLA Resolution Due"; Rec."SLA Resolution Due")
                {
                    Editable = false;
                    ToolTip = 'Specifies the deadline by which the grievance must be resolved, based on the SLA Matrix.';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = IsSLAResolutionBreached;
                }
                field("SLA Escalation Due"; Rec."SLA Escalation Due")
                {
                    Editable = false;
                    ToolTip = 'Specifies the deadline after which the grievance will be escalated if unresolved.';
                    ApplicationArea = All;
                }
            }
            group(Resolution)
            {
                Caption = 'Resolution';
                Visible = not IsOpen;
                field("HR Remarks"; Rec."HR Remarks")
                {
                    Editable = IsSubmitted;
                    ToolTip = 'Specifies remarks from HR regarding this grievance.';
                    ApplicationArea = All;
                }
                field("Resolution Date"; Rec."Resolution Date")
                {
                    Editable = IsSubmitted;
                    ToolTip = 'Specifies the date the grievance was resolved.';
                    ApplicationArea = All;
                }
                field("Resolved By"; Rec."Resolved By")
                {
                    Editable = IsSubmitted;
                    ToolTip = 'Specifies the employee who resolved the grievance.';
                    ApplicationArea = All;
                }
                field(CommentText; CommentText)
                {
                    Editable = IsSubmitted;
                    ToolTip = 'Specifies the employee who resolved the grievance.';
                    ApplicationArea = All;
                }
            }
            part("Grievance Comments"; "Grievance Comment Subform")
            {
                Caption = 'Comments';
                SubPageLink = "Grievance No." = field("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Submit Grievance")
            {
                Caption = 'Submit Grievance';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsOpen;
                ToolTip = 'Submits the grievance for HR review.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    GrievanceMgt.SubmitGrievance(Rec);
                    CurrPage.Close();
                end;
            }
            action("Add Comment")
            {
                Caption = 'Add Comment';
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsSubmitted;
                ToolTip = 'Adds a comment to this grievance.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if not Confirm('Add a comment to this grievance?', false) then
                        exit;
                    GrievanceMgt.AddComment(Rec."No.", CommentText);
                    CurrPage."Grievance Comments".Page.Update();
                end;
            }
            action("Approve Grievance")
            {
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsSubmitted;
                ToolTip = 'Approves and resolves the grievance.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve and resolve this grievance?', false) then begin
                        GrievanceMgt.ApproveGrievance(Rec);
                        Message('Grievance %1 has been approved and resolved.', Rec."No.");
                    end;
                end;
            }
            action("Reject Grievance")
            {
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsSubmitted;
                ToolTip = 'Rejects the grievance.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec."Rejection Remarks" = '' then
                        Error('Please enter Rejection Remarks before rejecting.');
                    if Confirm('Do you want to reject this grievance?', false) then begin
                        GrievanceMgt.RejectGrievance(Rec);
                        Message('Grievance %1 has been rejected.', Rec."No.");
                    end;
                end;
            }
            action("Withdraw Grievance")
            {
                Caption = 'Withdraw';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsOpen;
                ToolTip = 'Withdraws the grievance.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to withdraw this grievance?', false) then begin
                        GrievanceMgt.WithdrawGrievance(Rec);
                        CurrPage.Close();
                    end;
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
        SetLayout();
    end;

    var
        GrievanceMgt: Codeunit "Grievance Mgt";
        IsOpen: Boolean;
        IsSubmitted: Boolean;
        IsApproved: Boolean;
        IsRejected: Boolean;
        HasSLA: Boolean;
        IsSLAResponseBreached: Boolean;
        IsSLAResolutionBreached: Boolean;
        CommentText: Text[2000];

    local procedure SetLayout()
    begin
        IsOpen := Rec."Approval Status" in [Rec."Approval Status"::" ", Rec."Approval Status"::Open];
        IsSubmitted := Rec."Approval Status" = Rec."Approval Status"::Submitted;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsRejected := Rec."Approval Status" = Rec."Approval Status"::Rejected;
        if IsRejected then
            CurrPage.Editable := false;
        HasSLA := Rec."SLA Resolution Due" <> 0DT;
        IsSLAResponseBreached := (Rec."SLA Response Due" <> 0DT) and (CurrentDateTime > Rec."SLA Response Due");
        IsSLAResolutionBreached := (Rec."SLA Resolution Due" <> 0DT) and (CurrentDateTime > Rec."SLA Resolution Due");
    end;
}
