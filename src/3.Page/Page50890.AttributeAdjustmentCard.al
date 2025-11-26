page 50374 "Attribute Adjustment Card"
{
    PageType = Card;
    SourceTable = "Attribute Adjustment Header";
    ApplicationArea = All;
    Caption = 'Attribute Adjustment';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Pay Cycle Code"; Rec."Pay Cycle Code") { ApplicationArea = All; }
                field("Pay Cycle Term"; Rec."Pay Cycle Term") { ApplicationArea = All; }
                field("Pay Cycle Period"; Rec."Pay Cycle Period") { ApplicationArea = All; }
                field("Payroll Attribute Filter"; Rec."Payroll Attribute Filter") { ApplicationArea = All; }
                field("Employee Filter"; Rec."Employee Filter") { ApplicationArea = All; }
                field("Adjustment Type Filter"; Rec."Adjustment Type Filter") { ApplicationArea = All; }
                field("Approval Status"; Rec."Approval Status") { ApplicationArea = All; }
            }

            part(AdjustLines; "Attribute Adjustment Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Validate)
            {
                Caption = 'Validate';
                ApplicationArea = All;
            }

            action(Release)
            {
                Caption = 'Release';
                ApplicationArea = All;
            }

            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    ApplicationArea = All;
                    Enabled = not OpenApprovalEntriesExist;
                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        AttributeAdjustmentLine: Record "Attribute Adjustment Line";
                        HRMgt: Codeunit "HR Mgt.";
                    begin
                        ApproverMgt.UpdateFirstApproverStatus(Rec."Document No.");
                        AttributeAdjustmentLine.SetRange("Document No.", Rec."Document No.");
                        if AttributeAdjustmentLine.FindSet() then
                            repeat
                                HRMgt.InsertIntoAttributeUsageHistory(AttributeAdjustmentLine);
                            until AttributeAdjustmentLine.Next() = 0;

                        Message('Approval request set to Pending.');
                    end;
                }

                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    ApplicationArea = All;
                    Enabled = OpenApprovalEntriesExist;
                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        ApproverMgt.WithDrawRequest(RecRef);
                        CurrPage.Update();
                    end;
                }
            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        HRMgt: Codeunit "HR Mgt.";
                        AttributeAdjustmentLine: Record "Attribute Adjustment Line";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);

                        AttributeAdjustmentLine.SetRange("Document No.", Rec."Document No.");
                        if AttributeAdjustmentLine.FindSet() then
                            repeat
                                HRMgt.InsertIntoAttributeUsageHistory(AttributeAdjustmentLine);
                            until AttributeAdjustmentLine.Next() = 0;
                        CurrPage.Update();
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Update();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
    end;

    trigger OnOpenPage()
    var
        ApproverMgt: Codeunit "Approver Mgt";
    begin
        // if Rec."Approval Status" = Rec."Approval Status"::Created then
        //ApproverMgt.InsertApproval(Rec."Employee No.", '', Rec.Type::Resignation, Rec."Approval Status");
    end;

    var
        AttrAdjMgt: Codeunit "Excel Import";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApproverMgt: Codeunit "Approver Mgt";
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
}
