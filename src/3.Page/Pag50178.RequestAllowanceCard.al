page 50178 "Request Allowance Card"
{
    ApplicationArea = All;
    Caption = 'Request Allowance Card';
    PageType = Card;
    SourceTable = "Assignment Memo Header";
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    Editable = false;
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ToolTip = 'Specifies the value of the Nepali Month field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                    Editable = IsOpen and not AllowanceClaim;
                }
                field("To date"; Rec."To date")
                {
                    ToolTip = 'Specifies the value of the To date field.';
                    ApplicationArea = All;
                    Editable = IsOpen and not AllowanceClaim;
                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field("Total Line Amount"; Rec."Total Line Amount")
                {
                    ToolTip = 'Specifies the value of the Total Line Amount field.', Comment = '%';
                }
                field("No of Lines"; Rec."No of Lines")
                {
                    ToolTip = 'Specifies the value of the No of Lines field.', Comment = '%';
                }
                field("Fuel Limit (ltr)"; Rec."Fuel Limit (ltr)")
                {
                    ToolTip = 'Specifies the value of the Fuel Limit (ltr) field.', Comment = '%';
                    Editable = false;
                }
                field("Fuel Limit (amt)"; Rec."Fuel Limit (amt)")
                {
                    ToolTip = 'Specifies the value of the Fuel Limit (amt) field.', Comment = '%';
                    Editable = false;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type field.', Comment = '%';
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle No. field.', Comment = '%';
                }
                field("Vehicle Owner Name"; Rec."Vehicle Owner Name")
                {
                    ToolTip = 'Specifies the value of the Vehicle Owner Name field.', Comment = '%';
                }
                field("Ownership Start/End Date"; Rec."Ownership Start/End Date")
                {
                    ToolTip = 'Specifies the value of the Ownership Start/End Date field.', Comment = '%';
                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ToolTip = 'Specifies the value of the Fuel Type field.', Comment = '%';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    Caption = 'OutStation Effective Date';
                }
            }
            group(Approvals)
            {
                Visible = IsPending or IsReject;
                Editable = IsPending;
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.', Comment = '%';
                }
            }
            part(line1; "Request Allowance Subform Copy")
            {
                SubPageLink = "Document No." = field("No."), "Emp Act Type" = field("Activity Type");
                UpdatePropagation = Both;
                ApplicationArea = All;
                Editable = IsOpen;
                Visible = reimbursementView;
            }

            part(line; "Request Allowance Subform")
            {
                SubPageLink = "Document No." = field("No."), "Emp Act Type" = field("Activity Type");
                UpdatePropagation = Both;
                ApplicationArea = All;
                Editable = IsOpen;
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
                Visible = IsOpen;
                trigger OnAction()
                begin
                    if Confirm('Do you want to send approval request?', false) then
                        AllowanceMgt.SendApprovalAssignmentMemo(Rec);
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
                Visible = IsPending;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the document?', false) then
                        ApproverMgt.ApproveRejectDocument(RecRef, true)
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
                Visible = IsPending;
                trigger OnAction()
                begin
                    if Confirm('Do you want to reject the document?', false) then begin
                        if Rec."Rejection Remarks" = '' then
                            Error('Rejection Remarks must be filled before rejecting the document.');
                        ApproverMgt.ApproveRejectDocument(RecRef, false);
                    end;
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

    // trigger OnDeleteRecord(): Boolean
    // var
    //     LeaveEarn: Record "Leave Earn";
    // begin
    //     LeaveEarn.SetRange("Claimed Document No.", Rec."No.");
    //     if LeaveEarn.FindSet() then begin
    //         repeat
    //             LeaveEarn."Claimed Document No." := '';
    //             LeaveEarn.Claimed := false;
    //             LeaveEarn.Modify();
    //         until LeaveEarn.Next() = 0;
    //     end;
    // end;

    var
        FormEditable: Boolean;
        AllowanceMgt: Codeunit "Assignment Memo Mgt";
        ApproverMgt: Codeunit "Approver Mgt";
        IsOpen, IsPending, IsApprove, IsReject, IsSubstituteOpen, IsSubstitutepending : Boolean;
        RecRef: RecordRef;
        AllowanceClaim: Boolean;
        reimbursementView: Boolean;

    local procedure SetLayout()
    var
        Payrollattributes: Record "Payroll Attributes";
    begin
        FormEditable := rec."Approval Status" = rec."Approval Status"::Open;
        IsPending := Rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApprove := Rec."Approval Status" = rec."Approval Status"::Approved;
        IsReject := Rec."Approval Status" = rec."Approval Status"::Rejected;
        RecRef.GetTable(Rec);

        if Payrollattributes.Get(Rec."Payroll Attribute Code") then begin
            reimbursementView := Payrollattributes."Specific Attributes" = Payrollattributes."Specific Attributes"::Reimbursement;
        end
    end;
}
