page 50375 "Attribute Adjustment Card"
{
    PageType = Card;
    SourceTable = "Attribute Adjustment Header";
    ApplicationArea = All;
    Caption = 'Attribute Adjustment Card';
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = IsOpen;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ApplicationArea = All;
                    Visible = IsPending;
                }
                field("Adjustment Type"; Rec."Adjustment Type")
                {
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("Approval Status"; Rec."Approval Status") { ApplicationArea = All; }
            }

            part(AdjustLines; "Attribute Adjustment Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("Document No.");
                Editable = IsOpen or IsReleased;
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                SubPageLink = "Document No." = field("Document No.");
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(Release; "Release Document") { }
            actionref(SubmitForApproval; "Submit for Approval") { }
            actionref(ReOpen; "ReOpen Document") { }
            actionref(ApproveDocument; "Approve Document") { }
            actionref(RejectDocument; "Reject Document") { }
        }
        area(processing)
        {
            action(Validate)
            {
                Caption = 'Validate';
                ApplicationArea = All;
            }

            action("Release Document")
            {
                Caption = 'Release';
                ApplicationArea = All;
                Image = GetLines;
                Visible = IsOpen;
                trigger OnAction()
                var
                    AttributeAdjustmentMgt: Codeunit "Attribute Adjustment Mgt";
                begin
                    if not (Rec."Adjustment Type" in [Rec."Adjustment Type"::Promotion, Rec."Adjustment Type"::Confirmation]) then
                        Error('Adjustment Type must be %1 and %2', Rec."Adjustment Type"::Promotion, Rec."Adjustment Type"::Confirmation);
                    AttributeAdjustmentMgt.UpdatePayrollAttributesInAttributeAdjustmentLine(Rec);
                    "Approval Status" := "Approval Status"::Released;
                    CurrPage.Update();
                    Message('Additional Attributes have been fetched successfully.');
                end;
            }
            action("Submit for Approval")
            {
                Caption = 'Submit for Approval';
                Image = Suggest;
                ApplicationArea = All;
                Visible = IsReleased;
                ToolTip = 'Executes the Approve Request action.';
                trigger OnAction()
                begin
                    Rec.ApplyForAttributeAdj(Rec);
                    CurrPage.Update(true);
                end;
            }

            action("ReOpen Document")
            {
                Caption = 'Re-Open';
                ApplicationArea = All;
                Visible = IsPending or IsReleased;
                Image = ReOpen;
                trigger OnAction()
                begin
                    RecRef.GetTable(Rec);
                    ApproverMgt.ReopenDocument(RecRef);
                    CurrPage.Update(true);
                end;
            }

            action("Approve Document")
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                ToolTip = 'Approve the requested changes.';
                Visible = OpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        RecRef.GetTable(Rec);
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Rec."Rejection Remarks" := '';
                        Message('Attribute Adjustment is approved by %1', HRMgt.GetEmpName());
                    end;
                    CurrPage.Close();
                end;
            }
            action("Reject Document")
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                ToolTip = 'Reject the approval request.';
                Visible = OpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to reject the request?', false) then
                        exit;
                    if Rec."Rejection Remarks" = '' then
                        Error('Please enter rejection remarks.');
                    RecRef.GetTable(Rec);
                    ApproverMgt.ApproveRejectDocument(RecRef, false);
                    Message('Attribute Adjustment is rejected by %1', HRMgt.GetEmpName());
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExist := ApproverMgt.HasOpenApprovalEntries(Rec."Document No.");
        OpenApprovalEntriesExistForCurrUser := ApproverMgt.HasOpenApprovalEntriesForCurrentUser(Rec."Document No.", HRMgt.GetEmployeeNo());
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsReleased := Rec."Approval Status" = Rec."Approval Status"::Released;
    end;

    trigger OnOpenPage()
    begin
        // IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        // IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
    end;

    protected var
        IsOpen: Boolean;
        IsReleased: Boolean;
        IsPending: Boolean;
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;

    var
        ApproverMgt: Codeunit "Approver Mgt";

        HRMgt: Codeunit "HR Mgt.";
        RecRef: RecordRef;
}
