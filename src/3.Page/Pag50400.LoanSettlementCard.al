page 50400 "Loan Settlement Card"
{
    Caption = 'Loan Settlement Card';
    PageType = Card;
    SourceTable = "Loan Settlement";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group("General")
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the employee number.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the employee name.';
                    ApplicationArea = All;
                }
                field("Functional Title Code"; rec."Functional Title Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the branch.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the department.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the unit.';
                    ApplicationArea = All;
                }
                field("Settlement Request Date"; Rec."Settlement Request Date")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the date this settlement was requested.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    Editable = false;
                    ToolTip = 'Specifies the fiscal year of this settlement request.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the current approval status.';
                    ApplicationArea = All;
                }
            }
            group("Settlement Details")
            {
                field("Loan No."; Rec."Loan No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the source loan document number.';
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    Editable = false;
                    ToolTip = 'Specifies the type of loan being settled.';
                    ApplicationArea = All;
                }
                field("Salary Account Number"; rec."Salary Account Number")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Approved Amount"; Rec."Total Approved Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Disbursed Amount"; Rec."Disbursed Amount")
                {
                    Caption = 'Total Disbursed Amount';
                    Editable = false;
                    ToolTip = 'Specifies the originally disbursed loan amount.';
                    ApplicationArea = All;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    Editable = false;
                    ToolTip = 'Specifies the current outstanding loan balance.';
                    ApplicationArea = All;
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies whether this is a Full or Partial settlement.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Settlement Amount"; Rec."Settlement Amount")
                {
                    Caption = 'Requested Settlement Amount';
                    Editable = IsOpen;
                    ToolTip = 'Specifies the amount to be settled.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
            }
            group("&Remarks")
            {
                field(Remarks; Rec.Remarks)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies remarks for this settlement request.';
                    ApplicationArea = All;
                }
                field("Rejection Remark"; Rec."Rejection Remark")
                {
                    Editable = IsPending;
                    ToolTip = 'Specifies the rejection remark.';
                    ApplicationArea = All;
                }
            }
            group("Settlement Completion")
            {
                Visible = IsApproved;
                field("Settled Date"; Rec."Settled Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the date the loan was marked as settled.';
                    ApplicationArea = All;
                }
                field("Settler User ID"; Rec."Settler User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies who marked the loan as settled.';
                    ApplicationArea = All;
                }
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
                ApplicationArea = All;
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
                Visible = IsOpen;
                ToolTip = 'Send the settlement request for approval.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    loanMgt.SendSettlementApproval(Rec, true);
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsPending;
                ToolTip = 'Cancel the sent approval request and return to Open status.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    loanMgt.SendSettlementApproval(Rec, false);
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
                ToolTip = 'Approve this settlement request.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the settlement request?', false) then begin
                        RecRef.GetTable(Rec);
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Message('Loan Settlement is Approved by %1', HRMgt.GetEmpName());
                        Clear(Rec."Rejection Remark");
                        CurrPage.Update(false);
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
                Visible = IsPending;
                ToolTip = 'Reject this settlement request.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to reject the settlement request?', false) then begin
                        if Rec."Rejection Remark" = '' then
                            Error('Rejection Remark is Empty.')
                        else begin
                            RecRef.GetTable(Rec);
                            ApproverMgt.ApproveRejectDocument(RecRef, false);
                            Message('Loan Settlement is Rejected by %1', HRMgt.GetEmpName());
                            CurrPage.Update(false);
                        end;
                    end;
                end;
            }
            // action("Mark as Settled")
            // {
            //     Image = Completed;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Visible = IsApproved;
            //     ToolTip = 'Mark the loan as fully settled after the settlement is approved.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     var
            //         EmpLoan: Record "Employee Loan/Advance";
            //     begin
            //         if not Confirm('Do you want to mark this loan as settled?', false) then
            //             exit;
            //         Rec.TestField("Loan No.");
            //         if EmpLoan.Get(Rec."Loan No.") then begin
            //             EmpLoan.Settled := true;
            //             EmpLoan."Settlement Date" := Today;
            //             EmpLoan."Settler User ID" := UserId;
            //             EmpLoan.Modify(true);
            //         end;
            //         Rec."Settled Date" := Today;
            //         Rec."Settler User ID" := UserId;
            //         Rec.Modify(true);
            //         Message('Loan has been marked as settled.');
            //         CurrPage.Update(false);
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
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetLayout();
    end;

    var
        IsOpen, IsPending, IsApproved : Boolean;
        RecRef: RecordRef;
        ApproverMgt: Codeunit "Approver Mgt";
        HRMgt: Codeunit "HR Mgt.";
        loanMgt: Codeunit "Loan Mgt.";

    local procedure SetLayout()
    begin
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        RecRef.GetTable(Rec);
    end;
}
