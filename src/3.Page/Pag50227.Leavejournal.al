page 50227 "Leave Journal"
{
    ApplicationArea = All;
    Caption = 'Leave Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    SourceTableView = where("Employee Act Type" = filter("Employee Activity Type"::"Leave Request"));
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
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
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
                    Editable = IsOpen;
                }
                field("Adjustment Type"; Rec."Adjustment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Adjustment Type field';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                    Editable = (Rec."Adjustment Type" = Rec."Adjustment Type"::Used) and IsOpen;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                    Editable = (Rec."Adjustment Type" = Rec."Adjustment Type"::Used) and IsOpen;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                    Editable = Rec."Adjustment Type" = Rec."Adjustment Type"::Adjustment;
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

                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                    Editable = IsOpen or IsPending;
                }
                field("Substitute Person Code"; Rec."Substitute Person Code")
                {
                    ApplicationArea = All;
                }
                field("Substitute Person Name"; Rec."Substitute Person Name")
                {
                    ApplicationArea = All;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("Emp Act. No"), "Document Type" = field(Type);
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
                    if Confirm('Do you want to Send for Approval request?', false) then
                        EmpActMgt.SendForApproval(Rec."Emp Act. No", rec."Employee Act Type"::"Leave Request");
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
                Visible = IsApproved;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Post Leave?', false) then begin
                        EmpActMgt.PostLeaveJournal(rec."Emp Act. No");
                        CurrPage.Close();
                    end;
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
                    if Confirm('Do you want to Reject Leave?', false) then
                        EmpActMgt.RejectJournal(Rec, true);
                end;
            }
            action("Import From Excel")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportExcel;
                trigger OnAction()
                begin
                    if not Confirm('Do you want Import Leave Journal From Excel?', false) then
                        exit;
                    ExcelImportMgt.ImportJournalFromExcelSheet(Rec."Employee Act Type"::"Leave Request");
                end;
            }
            action("Export Format for Excel")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;
                trigger OnAction()
                begin
                    if not Confirm('Do you want Import Leave Journal From Excel?', false) then
                        exit;
                    ExcelImportMgt.ExportLeaveSheet(Rec);
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
        CurrPage.Update(false);
        SetLayout();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
        CurrPage.Update();
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
        EmpActMgt: Codeunit EmployeeActivityMgt;
        ApproverMgt: Codeunit "Approver Mgt";
        ExcelImportMgt: Codeunit "Excel Import";
}
