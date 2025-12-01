page 50374 "Attribute Adjustment Card"
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
                field("Approval Status"; Rec."Approval Status") { ApplicationArea = All; }
            }
            group(Filters)
            {
                field("Payroll Attribute Filter"; Rec."Payroll Attribute Filter") { ApplicationArea = All; }
                field("Employee Filter"; Rec."Employee Filter") { ApplicationArea = All; }
                field("Adjustment Type Filter"; Rec."Adjustment Type Filter") { ApplicationArea = All; }
            }

            part(AdjustLines; "Attribute Adjustment Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("Document No.");
                Editable = IsOpen;
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

            action(Release)
            {
                Caption = 'Release';
                ApplicationArea = All;
            }
            action("Submit for Approval")
            {
                Caption = 'Submit for Approval';
                Image = Suggest;
                ApplicationArea = All;
                Visible = IsOpen;
                ToolTip = 'Executes the Approve Request action.';
                trigger OnAction()
                begin
                    Rec.ApplyForAttributeAdj(Rec);
                    CurrPage.Update(true);
                end;
            }

            action("ReOpen Document")
            {
                Caption = 'Re-Open Document';
                ApplicationArea = All;
                Visible = IsPending and not OpenApprovalEntriesExistForCurrUser;
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
                var
                    AttributeAdjLine: Record "Attribute Adjustment Line";
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
    end;

    trigger OnOpenPage()
    begin
        // IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        // IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
    end;


    var
        IsOpen: Boolean;
        IsPending: Boolean;
        AttrAdjMgt: Codeunit "Excel Import";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApproverMgt: Codeunit "Approver Mgt";
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;

        HRMgt: Codeunit "HR Mgt.";
        RecRef: RecordRef;
}
