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
            // group(Allowance)
            // {
            //     Editable = false;
            //     field("Outstation/Discomfort Allow."; Rec."Outstation/Discomfort Allow.")
            //     {
            //         ToolTip = 'Specifies the value of the Outstation/Discomfort Allow. field.';
            //         ApplicationArea = All;
            //     }
            //     field("BM Accomodation Allow."; Rec."BM Accomodation Allow.")
            //     {
            //         ToolTip = 'Specifies the value of the BM Accomodation Allow. field.';
            //         ApplicationArea = All;
            //     }
            //     field("Remote Area Allow."; Rec."Remote Area Allow.")
            //     {
            //         ToolTip = 'Specifies the value of the Remote Area Allow. field.';
            //         ApplicationArea = All;
            //     }
            //     field("Relocation Allow."; Rec."Relocation Allow.")
            //     {
            //         ToolTip = 'Specifies the value of the Relocation Allow. field.';
            //         ApplicationArea = All;
            //     }
            //     field("Officiating Allow."; Rec."Officiating Allow.")
            //     {
            //         ToolTip = 'Specifies the value of the Officiating Allow. field.';
            //         ApplicationArea = All;
            //     }
            // }
            //anupam
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
            // group(Approval)
            // {
            //     field("Transfer Claim Recommender"; Rec."Transfer Claim Recommender")
            //     {
            //         ToolTip = 'Specifies the value of the Transfer Claim Recommender field.';
            //         ApplicationArea = All;

            //         trigger OnValidate()
            //         begin
            //             if Employee.Get(Rec."Transfer Claim Recommender") then
            //                 RecommederName := Employee."Full Name"
            //             else
            //                 RecommederName := '';
            //         end;
            //     }
            //     field("Recommender Name"; RecommederName)
            //     {
            //         Editable = false;
            //         ToolTip = 'Specifies the value of the RecommederName field.';
            //         ApplicationArea = All;
            //     }
            //     field("Transfer Claim Reviewer"; Rec."Transfer Claim Reviewer")
            //     {
            //         ToolTip = 'Specifies the value of the Transfer Claim Reviewer field.';
            //         ApplicationArea = All;
            //     }
            //     field("Transfer Claim Reviewer Name"; Rec."Transfer Claim Reviewer Name")
            //     {
            //         ToolTip = 'Specifies the value of the Transfer Claim Reviewer Name field.';
            //         ApplicationArea = All;
            //     }
            //     field("Transfer Claim Apporver Remarks"; TransferClaimApproverRemarks)
            //     {
            //         ToolTip = 'Specifies the value of the TransferClaimApproverRemarks field.';
            //         ApplicationArea = All;

            //         trigger OnValidate()
            //         begin
            //             if ReasonCode.Get(Rec."No.") then begin
            //                 ReasonCode."Transf. Claim Apporver Remarks" := TransferClaimApproverRemarks;
            //                 ReasonCode.Modify;
            //             end else begin
            //                 ReasonCode.Init;
            //                 ReasonCode.Validate(Code, Rec."No.");
            //                 ReasonCode."Transf. Claim Apporver Remarks" := TransferClaimApproverRemarks;
            //                 ReasonCode.Insert;
            //             end;
            //         end;
            //     }
            //     field("Trasnfer Cl. Recommender Remarks"; TransferClaimRecommenderRemarks)
            //     {
            //         ToolTip = 'Specifies the value of the TransferClaimRecommenderRemarks field.';
            //         ApplicationArea = All;

            //         trigger OnValidate()
            //         begin
            //             if ReasonCode.Get(Rec."No.") then begin
            //                 ReasonCode."Transf. Claim Recomm. Remarks" := TransferClaimRecommenderRemarks;
            //                 ReasonCode.Modify;
            //             end else begin
            //                 ReasonCode.Init;
            //                 ReasonCode.Validate(Code, Rec."No.");
            //                 ReasonCode."Transf. Claim Recomm. Remarks" := TransferClaimRecommenderRemarks;
            //                 ReasonCode.Insert;
            //             end;
            //         end;
            //     }
            //     field("Transfer Claim Reviewer Remarks"; TransferClaimReviewerRemarks)
            //     {
            //         ToolTip = 'Specifies the value of the TransferClaimReviewerRemarks field.';
            //         ApplicationArea = All;

            //         trigger OnValidate()
            //         begin
            //             if ReasonCode.Get(Rec."No.") then begin
            //                 ReasonCode."Transf. Claim Reviewer Remarks" := TransferClaimReviewerRemarks;
            //                 ReasonCode.Modify;
            //             end else begin
            //                 ReasonCode.Init;
            //                 ReasonCode.Validate(Code, Rec."No.");
            //                 ReasonCode."Transf. Claim Reviewer Remarks" := TransferClaimReviewerRemarks;
            //                 ReasonCode.Insert;
            //             end;
            //         end;
            //     }
            // }
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
                    // if Confirm('Approve this document?', false) then begin
                    // if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::"Pending Approval" then
                    //     TransferMgt.ApproveRejectTransferClaim(true, Rec, TransferClaimRecommenderRemarks)
                    // else if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::Recommended then
                    //     TransferMgt.ApproveRejectTransferClaim(true, Rec, TransferClaimReviewerRemarks)
                    // else if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::Reviewed then
                    //     TransferMgt.ApproveRejectTransferClaim(true, Rec, TransferClaimApproverRemarks)
                    // else
                    //     Error('Cannot approve this document.');
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
                    // if Confirm('Approve this document?', false) then begin
                    //     if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::"Pending Approval" then
                    //         TransferMgt.ApproveRejectTransferClaim(false, Rec, TransferClaimRecommenderRemarks)
                    //     else if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::Recommended then
                    //         TransferMgt.ApproveRejectTransferClaim(false, Rec, TransferClaimReviewerRemarks)
                    //     else if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::Reviewed then
                    //         TransferMgt.ApproveRejectTransferClaim(false, Rec, TransferClaimApproverRemarks);

                    // end;
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
        // if IsOpen then
        //     ApproverMgt.InsertApproval(Rec."Employee No.", '', Rec.Type::"Transfer Claim", Rec."Approval Status");
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
        // Rec.CalcFields("Transfer Claim Reviewer Name");
        // if Employee.Get(Rec."Transfer Claim Recommender") then
        //     RecommederName := Employee."Full Name"
        // else
        //     RecommederName := '';
        //HRMgt.CalculateAllowance(Rec);
        // if not (Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "]) then begin
        //     CurrPage.Editable(false);
        //     IsOpen := false;
        // end else
        //     IsOpen := true;

        // if ReasonCode.Get(Rec."No.") then begin
        //     TransferClaimReviewerRemarks := ReasonCode."Transf. Claim Reviewer Remarks";
        //     TransferClaimRecommenderRemarks := ReasonCode."Transf. Claim Recomm. Remarks";
        //     TransferClaimApproverRemarks := ReasonCode."Transf. Claim Apporver Remarks";
        // end;
    end;

    // trigger OnQueryClosePage(CloseAction: Action): Boolean
    // begin
    //     if not IsApplied and IsOpen then
    //         if not Confirm('The data will be erased. Do you want to continue?', true) then
    //             Error('')
    //         else begin
    //             Approval.Reset();
    //             Approval.setRange("Document Type", Approval."Document Type"::"Transfer Claim");
    //             Approval.SetRange("Document No.", '');
    //             Approval.SetRange("Employee No", Rec."Employee No.");
    //             Approval.DeleteAll();
    //         end;
    // end;

    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        [InDataSet]
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
