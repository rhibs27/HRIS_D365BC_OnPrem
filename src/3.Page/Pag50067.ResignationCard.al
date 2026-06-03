page 50067 "Resignation Card"
{
    InsertAllowed = false;
    SourceTable = "Resignation";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Visible = ApprovalStatusView;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                    Visible = StatusView;
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
            }
            group(Placements)
            {
                group("Current Placement")
                {
                    Editable = false;
                    field("Province Code"; Rec."Province Code")
                    {
                        ToolTip = 'Specifies the value of the Province Code field.';
                        ApplicationArea = All;
                    }
                    field("Department Code"; Rec."Department Code")
                    {
                        ToolTip = 'Specifies the value of the Department field.';
                        ApplicationArea = All;
                    }
                    field("Branch Code"; Rec."Branch Code")
                    {
                        ToolTip = 'Specifies the value of the Branch Code field.';
                        ApplicationArea = All;
                    }
                    field("Extension Counter Code"; Rec."Extension Counter Code")
                    {
                        ToolTip = 'Specifies the value of the Extension Counter Code field.';
                        ApplicationArea = All;
                    }
                    field("Unit Code"; Rec."Unit Code")
                    {
                        ToolTip = 'Specifies the value of the Unit Code field.';
                        ApplicationArea = All;
                    }
                    field("Functional Title"; Rec."Functional Title")
                    {
                        ToolTip = 'Specifies the value of the Functional Title field.';
                        ApplicationArea = All;
                    }
                    field("Payroll No."; Rec."Payroll No.")
                    {
                        ToolTip = 'Specifies the value of the Payroll No. field.';
                        ApplicationArea = All;
                    }
                }
                group("Resignation Details")
                {
                    Caption = 'Resignation Details';
                    field("Requested Last Working Day"; Rec."Requested Last Working Day")
                    {
                        ToolTip = 'Specifies the value of the Proposed Date of Closed of Business Hour field.';
                        ApplicationArea = All;
                        Editable = IsOpen;
                    }
                    field("Recommended Last Working Day"; Rec."Recommended Last Working Day")
                    {
                        Editable = IsPending;
                        ToolTip = 'Specifies the value of the Supervisor Proposed Date field.';
                        ApplicationArea = All;
                    }
                    field("Approved Last Working Day"; Rec."Approved Last Working Day")
                    {
                        Editable = IsPending;
                        ToolTip = 'Specifies the value of the HR Proposed Date field.';
                        ApplicationArea = All;
                    }
                    field("Reason Code"; Rec."Reason Code")
                    {
                        ToolTip = 'Specifies the value of the Reason Code field.';
                        ApplicationArea = All;
                        Editable = IsOpen;
                        Visible = false;
                    }

                    field("Reason for Resignation"; Rec."Reason for Resignation")
                    {
                        ToolTip = 'Specifies the value of the Reason for Resignation field.';
                        ApplicationArea = All;
                        Editable = IsOpen;
                    }
                }
                group("Resign Waiver")
                {
                    Visible = ApplyWaiverCase;
                    field("Waiver Case"; Rec."Waiver Case")
                    {
                        Editable = IsOpen;
                        ToolTip = 'Specifies the value of the Waiver Case field.';
                        ApplicationArea = All;
                    }
                    field("Apply for Waiver"; Rec."Apply for Waiver")
                    {
                        Editable = Rec."Waiver Case" = Rec."Waiver Case"::Recovery;
                        ToolTip = 'Specifies the value of the Apply for Waiver field.';
                        ApplicationArea = All;
                    }
                    field("Reason for Waiver"; Rec."Reason for Waiver")
                    {
                        Editable = Rec."Waiver Case" = Rec."Waiver Case"::Recovery;
                        ToolTip = 'Specifies the value of the Reason for Waiver field.';
                        ApplicationArea = All;
                    }
                }
            }
            part("Resign Clearance Verifier"; "Document Approver Resignation")
            {
                Caption = 'Resign Clearance Verifier';
                SubPageLink = "Document No." = field("No.");
                Visible = IsApproved;
                ApplicationArea = All;
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No."),
                                "Employee Code" = field("Employee No.");
                ApplicationArea = All;
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
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsOpen;
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    ResignationMgt.SendResignationApproval(Rec);
                    IsApplied := true;
                    CurrPage.Close();
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
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Message('Resignation is Approved by %1', HRMgt.GetEmpName());
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
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
                            Message('Resignation is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action(Settlement)
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Settlement action.';
                ApplicationArea = All;
                Visible = false;
                // trigger OnAction()
                // var
                //     Resignation: Record Resignation;
                // begin
                //     Resignation.Reset();
                //     Resignation.SetRange("Employee No.", Rec."Employee No.");
                //     if Resignation.FindFirst then
                //         Report.Run(Report::Settlement, true, true, Resignation);
                // end;
            }
            action("Return Resignation")
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Return Resignation action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want Withdraw the request?', false) then begin
                        ApprovalMgt.WithDrawRequest(RecRef);
                        Message('Resignation isWithdrawn');
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

    protected var
        IsRejected: Boolean;
        IsPending: Boolean;
        IsApproved: Boolean;
        IsOpen: Boolean;
        HrSetup: Record "Human Resources Setup";
        ApplyWaiverCase: Boolean;

    var
        HRMgt: Codeunit "HR Mgt.";
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        ResignationMgt: Codeunit "Resignation Mgt";
        ApprovalSent: Boolean;
        RecRef: RecordRef;
        ApprovalMgt: Codeunit "Approver Mgt";
        Approval: Record "Approval HRMS";
        IsApplied: Boolean;

    local procedure SetLayout()
    begin
        HrSetup.Get();
        ApprovalSent := not (Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "]);
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
        ApplyWaiverCase := HrSetup."Apply Resign Waiver";
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        RecRef.GetTable(Rec);
        if IsRejected then
            CurrPage.Editable := false;
    end;
}
