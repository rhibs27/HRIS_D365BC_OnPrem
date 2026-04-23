page 50254 "Shift Assignment Card"
{
    ApplicationArea = All;
    Caption = 'Shift Assignment Card';
    PageType = Card;
    SourceTable = "Shift Assignment Header";
    InsertAllowed = false;
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
                field("Deputation Type"; Rec."Deputation Type")
                {
                    ToolTip = 'Specifies the value of the Deputation Type field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Deputation Name"; Rec."Deputation Name")
                {
                    ToolTip = 'Specifies the value of the Deputation Name field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Deputation Sub Type"; Rec."Deputation Sub Type")
                {
                    ToolTip = 'Specifies the value of the Deputation Sub Type field.', Comment = '%';
                    Editable = IsOpen;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Deputation Sub Type Code"; Rec."Deputation Sub Type Code")
                {
                    ToolTip = 'Specifies the value of the Deputation Sub Type Code field.', Comment = '%';
                    Editable = IsOpen;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Deputation Sub Type Name"; Rec."Deputation Sub Type Name")
                {
                    ToolTip = 'Specifies the value of the Deputation Sub Type Name field.', Comment = '%';
                    Editable = false;
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
                SubPageLink = "No." = field("No.");
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
                    if ShiftLine.Count = 0 then
                        Error('Shift Line not Found');
                    if Confirm('Do you want to send approval request?', false) then begin
                        ShiftAssignmentMgt.SendApprovalShiftAssignment(Rec, ShiftLine);
                        Message('Shift Assignment Request send for approval by %1', HRMgt.GetEmpName());
                    end;
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
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
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
