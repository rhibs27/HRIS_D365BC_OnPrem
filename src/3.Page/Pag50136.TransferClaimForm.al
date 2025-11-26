page 50136 "Transfer Claim Form"
{
    PageType = Card;
    SourceTable = "Employee Transfer";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                    Visible = StatusView;
                }
                field("Transfer Request No"; Rec."Transfer Request No")
                {
                    ToolTip = 'Specifies the value of the Transfer Request No field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                }
            }
            group(Distance)
            {
                Editable = IsOpen;
                field("Relocation Distance"; Rec."Relocation Distance")
                {
                    ToolTip = 'Specifies the value of the Relocation Distance field.';
                    ApplicationArea = All;
                }
                field("Outstation Distance"; Rec."Outstation Distance")
                {
                    ToolTip = 'Specifies the value of the Outstation Distance field.';
                    ApplicationArea = All;
                }
                field("BMAF Distance"; Rec."BMAF Distance")
                {
                    ToolTip = 'Specifies the value of the BMAF Distance field.';
                    ApplicationArea = All;
                }
            }

            part("transfer claim details attachment"; "Transfer Claim Details Subform")
            {
                SubPageLink = "Transfer No" = field("No.");
                ApplicationArea = All;
                Editable = IsOpen;
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
                Editable = IsOpen;
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                                "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Allowance")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Update Allowance action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    TransferMgt.CalculateAllowance(Rec);
                end;
            }
            action("Request Allowance Claim")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsOpen;
                ToolTip = 'Executes the Request Allowance Claim action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    TransferMgt.RequestTransferAllowanceClaim(Rec);
                    IsApplied := true;
                    CurrPage.Close;
                end;
            }
            action("Approve Allowance Claim")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsPending;
                ToolTip = 'Executes the Approve Allowance Claim action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Message('Transfer Allowance is Approved by %1', HRMgt.GetEmpName());
                    end;
                    // end;
                end;
            }
            action("Reject Allowance Claim")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsPending;
                ToolTip = 'Executes the Reject Allowance Claim action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApproverMgt.ApproveRejectDocument(RecRef, false);
                            Message('Transfer Claim is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        SetLayout();
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";

        IsOpen: Boolean;
        ReasonCode: Record "Reason Code";
        ApproverMgt: Codeunit "Approver Mgt";
        IsApplied: Boolean;
        Approval: Record "Approval HRMS";
        ApprovalStatusView: Boolean;
        StatusView: Boolean;
        RecRef: RecordRef;
        IsPending: Boolean;

    local procedure SetLayout()
    begin
        IsOpen := rec."Approval Status" = rec."Approval Status"::Open;
        IsPending := Rec."Approval Status" = rec."Approval Status"::Pending;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        RecRef.GetTable(Rec);
    end;
}
