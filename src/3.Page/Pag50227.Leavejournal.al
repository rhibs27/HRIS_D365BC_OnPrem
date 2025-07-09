page 50227 "Leave Journal"
{
    ApplicationArea = All;
    Caption = 'Leave Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    UsageCategory = Tasks;
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.';
                    ApplicationArea = All;
                }
                field("Adjustment Type"; Rec."Adjustment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Speicifies the value of the Adjustment Type field';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                    Editable = Rec."Adjustment Type" = Rec."Adjustment Type"::Used;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                    Editable = Rec."Adjustment Type" = Rec."Adjustment Type"::Used;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                    Editable = Rec."Adjustment Type" = Rec."Adjustment Type"::Adjustment;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("Emp Act. No");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Send For Approval")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = SendApprovalRequest;
                trigger OnAction()

                begin
                    if Confirm('Do you want to Send for Approval request?', false) then
                        EmpActMgt.SendForApproval(Rec."Emp Act. No");
                end;
            }
            action("Approve")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Approve;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Approve request?', false) then
                        ApproverMgt.ApproveJournalDocument(Rec."Emp Act. No", true);
                end;
            }

            action(Post)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Post Leave?', false) then
                        EmpActMgt.PostLeaveJournal(rec."Emp Act. No");
                end;
            }
            action(Reject)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Reject;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Reject Leave?', false) then
                        EmpActMgt.RejectJournal(Rec, true);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec."Employee Act Type" := Rec."Employee Act Type"::"Leave Request";
        Rec.Type := Rec.Type::"Employee Journal";
        Rec.SetUpNewLine(xRec);
    end;

    var
        UnitEdit: Boolean;
        DepartmentEdit: Boolean;
        ExtensionCounterEdit: Boolean;
        BranchEdit: Boolean;
        ProvinceEdit: Boolean;
        LeaveMgt: Codeunit "Leave Mgt.";
        EmpActMgt: Codeunit EmployeeActivityMgt;
        ApproverMgt: Codeunit "Approver Mgt";
}
