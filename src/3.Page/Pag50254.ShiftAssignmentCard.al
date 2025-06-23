page 50254 "Shift Assignment Card"
{
    ApplicationArea = All;
    Caption = 'Shift Assignment Card';
    PageType = Card;
    SourceTable = "Shift Assignment Header";
    layout
    {
        area(Content)
        {
            Group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Deputation Name"; Rec."Deputation Name")
                {
                    ToolTip = 'Specifies the value of the Deputation Name field.', Comment = '%';
                }
                field("Deputation Type"; Rec."Deputation Type")
                {
                    ToolTip = 'Specifies the value of the Deputation Type field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    Editable = false;
                    Visible = ApprovalStatusView;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Visible = StatusView;
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Editable = IsPending;
                    ApplicationArea = All;
                }
            }
            part(shiftSubForm; "shift subform")
            {
                SubPageLink = "No." = field("No."),
                            "Deputation Type" = field("Deputation Type"),
                            "Deputation Code" = field("Deputation Code");
                UpdatePropagation = Both;
                ApplicationArea = all;
                Editable = IsOpen;

            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No.");
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
                    ShiftLine.Reset;
                    ShiftLine.SetRange("No.", Rec."No.");
                    if Confirm('Do you want to send approval request?', false) then
                        ShiftAssignmentMgt.SendApprovalShiftAssignment(Rec, ShiftLine);
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
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApproverMgt.ApproveRejectDocument(RecRef, false);
                            Message('Overtime is Rejected by %1', HRMgt.GetEmpName());
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
        IsOpen: Boolean; // Used to determine if the page is open for editing
        IsPending: Boolean; // Used to determine if the approval status is pending
        IsApprove: Boolean; // Used to determine if the approval status is approved
        RecRef: RecordRef; // Used to reference the current record
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";
        ApproverMgt: Codeunit "Approver Mgt";
        ShiftLine: Record "Shift Line";
        HRMgt: Codeunit "HR Mgt.";
        StatusView: Boolean; // Used to determine if the status view is visible
        ApprovalStatusView: Boolean; // Used to determine if the approval status view is visible

    procedure SetLayout()
    begin
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApprove := Rec."Approval Status" = rec."Approval Status"::Approved;
        RecRef.GetTable(Rec);
    end;
}
