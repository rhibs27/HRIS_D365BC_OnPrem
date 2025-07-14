page 50314 "Attendance Journal"
{
    ApplicationArea = All;
    Caption = 'Attendance Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    SourceTableView = where("Employee Act Type" = const("Attendance Journal"));
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
                    Editable = IsOpen;
                }

                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    Caption = 'Late Days';
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                    Editable = IsOpen;

                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                }
                field(Status; Rec.Status)
                {
                    Visible = StatusView;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                    Editable = IsOpen or IsPending;
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
                Visible = IsOpen;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Send for Approval request?', false) then
                        exit;

                    EmpActMgt.SendForApproval(Rec."Emp Act. No", Rec."Employee Act Type"::"Attendance Journal");


                end;
            }
            action("Approve")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Approve;
                Visible = IsPending;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Approve request?', false) then
                        exit;

                    ApproverMgt.ApproveJournalDocument(Rec."Emp Act. No", true);


                end;
            }

            action(Post)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                Visible = IsApproved;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Post Attendance Journal?', false) then
                        exit;


                    EmpActMgt.PostLeaveJournal(Rec."Emp Act. No");

                    CurrPage.Close();

                end;
            }
            action(Reject)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Reject;
                Visible = IsPending;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Reject Attendance Journal?', false) then
                        exit;


                    EmpActMgt.RejectJournal(Rec, true);


                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec."Employee Act Type" := Rec."Employee Act Type"::"Attendance Journal";
        Rec.Type := Rec.Type::"Attendance Journal";
        Rec.SetUpNewLine(xRec);
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
    end;

    procedure SetLayout()
    begin
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
    end;

    var
        StatusView, ApprovalStatusView : Boolean;
        IsOpen, IsPending, IsApproved, IsRejected : Boolean;
        UnitEdit: Boolean;
        DepartmentEdit: Boolean;
        ExtensionCounterEdit: Boolean;
        BranchEdit: Boolean;
        ProvinceEdit: Boolean;
        LeaveMgt: Codeunit "Leave Mgt.";
        EmpActMgt: Codeunit EmployeeActivityMgt;
        ApproverMgt: Codeunit "Approver Mgt";
}
