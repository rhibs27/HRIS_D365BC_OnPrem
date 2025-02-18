page 50353 "HRMS Approval Entry"
{
    ApplicationArea = All;
    Caption = 'HRMS Approval Entry';
    PageType = ListPart;
    SourceTable = "Approval HRMS";
    SourceTableView = sorting("Approval Sequence") order(ascending);
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentNo; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Caption = 'Document No.';
                }
                field(approverNo; Rec."Approver No")
                {
                    ToolTip = 'Specifies the value of the Approver No field.', Comment = '%';
                    Caption = 'Approver No';
                }
                field(approverName; Rec."Approver Name")
                {
                    ToolTip = 'Specifies the value of the Approver Name field.', Comment = '%';
                    Caption = 'Approver Name';
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    Caption = 'Approval Status';
                }
                field(approvalRole; Rec."Approval Role")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    Caption = 'Approval Status';
                    Visible = false;
                }
                field(status; rec.Status)
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    Caption = 'Status';
                    Visible = false;
                }
                field(approvalSequence; Rec."Approval Sequence")
                {
                    Caption = 'Approval Sequence';
                    ToolTip = 'Specifies the value of the Approval Sequence field.', Comment = '%';
                }
                field(approvedBy; Rec."Approved By")
                {
                    Caption = 'Approved By';
                    ToolTip = 'Specifies the value of the Approved By field.', Comment = '%';
                }

                field(rejectedBy; Rec."Rejected By")
                {
                    Caption = 'Rejected By';
                    ToolTip = 'Specifies the value of the Rejected By field.', Comment = '%';
                }
            }
        }
    }
}