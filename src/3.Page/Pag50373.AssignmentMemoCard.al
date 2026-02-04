page 50373 "Assignment Memo Card"
{
    ApplicationArea = All;
    Caption = 'Memo Card';
    PageType = Card;
    SourceTable = "Assignment Memo Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = IsOpen;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ToolTip = 'Specifies the value of the Nepali Month field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To date"; Rec."To date")
                {
                    ToolTip = 'Specifies the value of the To date field.', Comment = '%';
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.', Comment = '%';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ToolTip = 'Specifies the value of the Unit Code field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
            group(Approvals)
            {
                Visible = IsPending or Isreject;
                Editable = IsPending;
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.', Comment = '%';
                }
            }
            group(SubstituteDetails)
            {
                Caption = 'Substitute Details';
                Visible = IsApprove;
                Editable = false;
                field("Substitute Approval Status"; Rec."Substitute Approval Status")
                {
                    ToolTip = 'Specifies the value of the Substitute Approval Status field.', Comment = '%';
                }
            }
            group("Substitute Approvals")
            {
                Visible = IsSubstitutePending;
                Editable = IsSubstitutePending;
                field("Rejection Remarks1"; Rec."Rejection Remarks")
                {
                    Caption = 'Substitute Rejection Remarks';
                    ToolTip = 'Specifies the value of the Rejection Remarks field.', Comment = '%';
                }
            }
            part(AssignmentMemoLines; "Assignment Memo Subform")
            {
                Visible = Rec."Activity Type" = Rec."Activity Type"::"Allowance Assignment Memo";
                Editable = IsOpen;
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            part("Shift Assignment Memo Subform"; "Shift Assignment Memo Subform")
            {
                Visible = Rec."Activity Type" = Rec."Activity Type"::"Shift Assignment Memo";
                Editable = IsOpen;
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No.");
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                "Employee No" = field("Employee No."),
                                "Document Type" = field("Activity Type");
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;
                Visible = IsOpen or IsSubstituteOpen;
                trigger OnAction()
                var
                    AllowanceLine: Record "Assignment Memo Line";
                    AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
                begin
                    AllowanceLine.Reset;
                    AllowanceLine.SetRange("Document No.", Rec."No.");
                    if Confirm('Do you want to send approval request?', false) then
                        AssignmentMemoMgt.SendApprovalAssignmentMemo(Rec);
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
                Visible = IsPending or IsSubstitutepending;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the document?', false) then
                        ApproverMgt.ApproveRejectDocument(RecRef, true);

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
                Visible = IsPending or IsSubstitutepending;
                trigger OnAction()
                var
                    AssignmentMmemoline: Record "Assignment Memo Line";
                begin
                    if Confirm('Do you want to reject the document?', false) then begin
                        if Rec."Rejection Remarks" = '' then
                            if not IsSubstitutepending then
                                Error('Rejection Remarks must be filled before rejecting the document.')
                            else
                                Error('Substitute Rejection Remarks must be filled before rejecting the document.');

                        AssignmentMmemoline.SetRange("Document No.", Rec."No.");
                        AssignmentMmemoline.SetRange("Approval Status", AssignmentMmemoline."Approval Status"::Pending);
                        if AssignmentMmemoline.FindSet() then
                            AssignmentMmemoline.ModifyAll("Rejection Remarks", Rec."Rejection Remarks");

                        Rec."Rejection Remarks" := '';
                        Rec.Modify();

                        ApproverMgt.ApproveRejectDocument(RecRef, false);
                    end;
                end;
            }
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }

            action(Reverse)
            {
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reverse action.';
                ApplicationArea = All;
                Visible = IsApprove;
                trigger OnAction()
                var
                    AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
                begin
                    if Confirm('Do you want to reverse the document?', false) then
                        AssignmentMemoMgt.ReverseAssignmentMemos(Rec."No.");
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
        FormEditable: Boolean;
        ApproverMgt: Codeunit "Approver Mgt";
        IsOpen, IsPending, IsApprove, IsReject, IsSubstituteOpen, IsSubstitutepending : Boolean;
        RecRef: RecordRef;

    local procedure SetLayout()
    begin
        FormEditable := rec."Approval Status" = rec."Approval Status"::Open;
        IsPending := Rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApprove := Rec."Approval Status" = rec."Approval Status"::Approved;
        IsReject := Rec."Approval Status" = rec."Approval Status"::Rejected;
        IsSubstituteOpen := Rec."Substitute Approval Status" = Rec."Substitute Approval Status"::Open;
        IsSubstitutepending := Rec."Substitute Approval Status" = Rec."Substitute Approval Status"::Pending;
        RecRef.GetTable(Rec);
    end;
}
