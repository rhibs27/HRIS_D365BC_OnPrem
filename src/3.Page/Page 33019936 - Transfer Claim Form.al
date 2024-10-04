page 33019936 "Transfer Claim Form"
{
    PageType = Card;
    SourceTable = "Employee/HR Transfer";
    SourceTableView = WHERE(Type = FILTER("Employee Transfer" | "HR Transfer"));
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
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Transfer Allowance Approval"; Rec."Transfer Allowance Approval")
                {
                    ToolTip = 'Specifies the value of the Transfer Allowance Approval field.';
                    ApplicationArea = All;
                }
            }
            group(Distance)
            {
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
            group(Allowance)
            {
                Editable = false;
                field("Outstation/Discomfort Allow."; Rec."Outstation/Discomfort Allow.")
                {
                    ToolTip = 'Specifies the value of the Outstation/Discomfort Allow. field.';
                    ApplicationArea = All;
                }
                field("BM Accomodation Allow."; Rec."BM Accomodation Allow.")
                {
                    ToolTip = 'Specifies the value of the BM Accomodation Allow. field.';
                    ApplicationArea = All;
                }
                field("Remote Area Allow."; Rec."Remote Area Allow.")
                {
                    ToolTip = 'Specifies the value of the Remote Area Allow. field.';
                    ApplicationArea = All;
                }
                field("Relocation Allow."; Rec."Relocation Allow.")
                {
                    ToolTip = 'Specifies the value of the Relocation Allow. field.';
                    ApplicationArea = All;
                }
                field("Officiating Allow."; Rec."Officiating Allow.")
                {
                    ToolTip = 'Specifies the value of the Officiating Allow. field.';
                    ApplicationArea = All;
                }
            }
            group(Approval)
            {
                field("Transfer Claim Recommender"; Rec."Transfer Claim Recommender")
                {
                    ToolTip = 'Specifies the value of the Transfer Claim Recommender field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Employee.Get(Rec."Transfer Claim Recommender") then
                            RecommederName := Employee."Full Name"
                        else
                            RecommederName := '';
                    end;
                }
                field("Recommender Name"; RecommederName)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the RecommederName field.';
                    ApplicationArea = All;
                }
                field("Transfer Claim Reviewer"; Rec."Transfer Claim Reviewer")
                {
                    ToolTip = 'Specifies the value of the Transfer Claim Reviewer field.';
                    ApplicationArea = All;
                }
                field("Transfer Claim Reviewer Name"; Rec."Transfer Claim Reviewer Name")
                {
                    ToolTip = 'Specifies the value of the Transfer Claim Reviewer Name field.';
                    ApplicationArea = All;
                }
                field("Transfer Claim Apporver Remarks"; TransferClaimApproverRemarks)
                {
                    ToolTip = 'Specifies the value of the TransferClaimApproverRemarks field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if ReasonCode.Get(Rec."No.") then begin
                            ReasonCode."Transf. Claim Apporver Remarks" := TransferClaimApproverRemarks;
                            ReasonCode.Modify;
                        end else begin
                            ReasonCode.Init;
                            ReasonCode.Validate(Code, Rec."No.");
                            ReasonCode."Transf. Claim Apporver Remarks" := TransferClaimApproverRemarks;
                            ReasonCode.Insert;
                        end;
                    end;
                }
                field("Trasnfer Cl. Recommender Remarks"; TransferClaimRecommenderRemarks)
                {
                    ToolTip = 'Specifies the value of the TransferClaimRecommenderRemarks field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if ReasonCode.Get(Rec."No.") then begin
                            ReasonCode."Transf. Claim Recomm. Remarks" := TransferClaimRecommenderRemarks;
                            ReasonCode.Modify;
                        end else begin
                            ReasonCode.Init;
                            ReasonCode.Validate(Code, Rec."No.");
                            ReasonCode."Transf. Claim Recomm. Remarks" := TransferClaimRecommenderRemarks;
                            ReasonCode.Insert;
                        end;
                    end;
                }
                field("Transfer Claim Reviewer Remarks"; TransferClaimReviewerRemarks)
                {
                    ToolTip = 'Specifies the value of the TransferClaimReviewerRemarks field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if ReasonCode.Get(Rec."No.") then begin
                            ReasonCode."Transf. Claim Reviewer Remarks" := TransferClaimReviewerRemarks;
                            ReasonCode.Modify;
                        end else begin
                            ReasonCode.Init;
                            ReasonCode.Validate(Code, Rec."No.");
                            ReasonCode."Transf. Claim Reviewer Remarks" := TransferClaimReviewerRemarks;
                            ReasonCode.Insert;
                        end;
                    end;
                }
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
                    if Confirm('Do you want to send document for approval?', false) then
                        TransferMgt.RequestTransferAllowanceClaim(Rec);
                end;
            }
            action("Approve Allowance Claim")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = not IsOpen;
                ToolTip = 'Executes the Approve Allowance Claim action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Approve this document?', false) then begin
                        if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::"Pending Approval" then
                            TransferMgt.ApproveRejectTransferClaim(true, Rec, TransferClaimRecommenderRemarks)
                        else if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::Recommended then
                            TransferMgt.ApproveRejectTransferClaim(true, Rec, TransferClaimReviewerRemarks)
                        else if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::Reviewed then
                            TransferMgt.ApproveRejectTransferClaim(true, Rec, TransferClaimApproverRemarks)
                        else
                            Error('Cannot approve this document.');
                    end;
                end;
            }
            action("Reject Allowance Claim")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = not IsOpen;
                ToolTip = 'Executes the Reject Allowance Claim action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Approve this document?', false) then begin
                        if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::"Pending Approval" then
                            TransferMgt.ApproveRejectTransferClaim(false, Rec, TransferClaimRecommenderRemarks)
                        else if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::Recommended then
                            TransferMgt.ApproveRejectTransferClaim(false, Rec, TransferClaimReviewerRemarks)
                        else if Rec."Transfer Allowance Approval" = Rec."Transfer Allowance Approval"::Reviewed then
                            TransferMgt.ApproveRejectTransferClaim(false, Rec, TransferClaimApproverRemarks);

                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Transfer Claim Reviewer Name");
        if Employee.Get(Rec."Transfer Claim Recommender") then
            RecommederName := Employee."Full Name"
        else
            RecommederName := '';
        //HRMgt.CalculateAllowance(Rec);
        if not (Rec."Transfer Allowance Approval" in [Rec."Transfer Allowance Approval"::Open, Rec."Transfer Allowance Approval"::" "]) then begin
            CurrPage.Editable(false);
            IsOpen := false;
        end else
            IsOpen := true;

        if ReasonCode.Get(Rec."No.") then begin
            TransferClaimReviewerRemarks := ReasonCode."Transf. Claim Reviewer Remarks";
            TransferClaimRecommenderRemarks := ReasonCode."Transf. Claim Recomm. Remarks";
            TransferClaimApproverRemarks := ReasonCode."Transf. Claim Apporver Remarks";
        end;
    end;

    var
        RecommederName: Text;
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        [InDataSet]
        IsOpen: Boolean;
        TransferClaimApproverRemarks: Text;
        TransferClaimRecommenderRemarks: Text;
        TransferClaimReviewerRemarks: Text;
        ReasonCode: Record "Reason Code";
}
