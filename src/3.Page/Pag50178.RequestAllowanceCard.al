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
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }

            }
            part(line; "Request Allowance Subform")
            {
                SubPageLink = "Document No." = field("No."), "Emp Act Type" = field("Activity Type");
                UpdatePropagation = Both;
                ApplicationArea = All;
                Editable = IsOpen;
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
                    if Confirm('Do you want to reject the document?', false) then
                        ApproverMgt.ApproveRejectDocument(RecRef, false)
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

    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        FormEditable: Boolean;
        AllowanceMgt: Codeunit "Assignment Memo Mgt";
        Employee: Record Employee;
        ApproverMgt: Codeunit "Approver Mgt";
        IsOpen, IsPending, IsApprove : Boolean;
        RecRef: RecordRef;
        AllowanceClaim: Boolean;

    local procedure SetLayout()
    begin
        FormEditable := rec."Approval Status" = rec."Approval Status"::Open;
        IsPending := Rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApprove := Rec."Approval Status" = rec."Approval Status"::Approved;
        RecRef.GetTable(Rec);
    end;
}
