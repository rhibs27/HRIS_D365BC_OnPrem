page 50246 "Overtime Bulk Card"
{
    ApplicationArea = All;
    Caption = 'Overtime Bulk Card';
    PageType = Card;
    SourceTable = OverTime;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Deputation Type"; Rec."Deputation Type")
                {
                    ToolTip = 'Specifies the value of the Branch Type field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Deputation Code"; Rec."Deputation Code")
                {
                    Editable = Rec."Deputation Type" = Rec."Deputation Type"::"Extension Counter";
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Deputation Name"; Rec."Deputation Name")
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the OT Date field.';
                    Editable = IsOpen;
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    Editable = IsOpen;
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Visible = ApprovalStatusView;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
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
            part(OvertimeSubform; "Overtime Subform")
            {
                SubPageLink = "No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
                Editable = IsOpen;
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                "Employee No" = field("Employee No."),
                                "Document Type" = field("Type");
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Get Employee")
            {
                ApplicationArea = All;
                Caption = 'Get Employee';
                Image = GetEntries;
                ToolTip = 'Get Employee for the overtime request.';
                Visible = IsOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    OvertimeMgt.GetEmployee(Rec);
                end;
            }
            action("Calculate Overtime")
            {
                ApplicationArea = All;
                Caption = 'Calculate Overtime';
                Image = Calculate;
                ToolTip = 'Calculate overtime for the overtime request.';
                Visible = IsOpen and rec."Get Employee";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    OvertimeMgt.GetOvertimeLineDetails(Rec."No.")
                end;
            }
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
                    OvertimeLine.Reset;
                    OvertimeLine.SetRange("No.", Rec."No.");
                    if Confirm('Do you want to send approval request?', false) then
                        OvertimeMgt.SendApprovalOvertimeBulk(Rec, OvertimeLine);
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
            action("Cancel Request")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Cancel Request action.';
                ApplicationArea = All;
                Visible = IsOpen;
                trigger OnAction()
                begin
                    if Confirm('Do you want cancel the request?', false) then begin
                        ApproverMgt.CancelRequest(RecRef);
                        Message('Overtime has been Cancelled.');
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

    protected var
        IsOpen: Boolean;
        IsPending: Boolean;
        IsApprove: Boolean;
        RecRef: RecordRef;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;

    var
        OvertimeMgt: Codeunit "OverTime Mgt";
        OvertimeLine: Record "Overtime Line";
        ApproverMgt: Codeunit "Approver Mgt";
        HRMgt: Codeunit "HR Mgt.";

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
