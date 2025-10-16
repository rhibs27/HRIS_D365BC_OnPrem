page 50222 "Transfer Journal"
{
    ApplicationArea = All;
    Caption = 'Transfer Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    SourceTableView = where("Employee Act Type" = filter("Employee Activity Type"::"HR Transfer"));
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
                field("Transfer Type"; Rec."Transfer Type")
                {
                    ToolTip = 'Specifies the value of the Transfer Type field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Transfer Category"; Rec."Transfer Category")
                {
                    ToolTip = 'Specifies the value of the Transfer Category field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Deputation On (To)"; Rec."Deputation On (To)")
                {
                    ToolTip = 'Specifies the value of the Deputation On (To) field.', Comment = '%';
                    Editable = IsOpen;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Province Code (To)"; Rec."Province Code (To)")
                {
                    ToolTip = 'Specifies the value of the Province Code (To) field.', Comment = '%';
                    Editable = ProvinceEdit and IsOpen;
                }
                field("To Branch"; Rec."To Branch")
                {
                    ToolTip = 'Specifies the value of the To Branch field.', Comment = '%';
                    Editable = BranchEdit and IsOpen;
                }
                field("Department Code (To)"; Rec."Department Code (To)")
                {
                    ToolTip = 'Specifies the value of the Department Code (To) field.', Comment = '%';
                    Editable = DepartmentEdit and IsOpen;
                }
                field("Extension Counter (To)"; Rec."Extension Counter (To)")
                {
                    ToolTip = 'Specifies the value of the Extension Counter (To) field.', Comment = '%';
                    Editable = ExtensionCounterEdit and IsOpen;
                }
                field("Unit (To)"; Rec."Unit (To)")
                {
                    ToolTip = 'Specifies the value of the Unit (To) field.', Comment = '%';
                    Editable = UnitEdit and IsOpen;
                }
                field("Approval Role (To)"; Rec."Approver Role (TO)")
                {
                    ToolTip = 'Specifies the value of the Approver Role (TO) field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    Visible = ApprovalStatusView;
                }
                field(Status; Rec.Status)
                {
                    Visible = StatusView;
                }
                field("Functional Title (To)"; Rec."Functional Title (To)")
                {
                    ToolTip = 'Specifies the value of the Functional Title (To) field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Transfer Effective Date"; Rec."Transfer Effective Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Effective Date field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Incoming Supervisor"; Rec."Incoming Supervisor")
                {
                    ToolTip = 'Specifies the value of the Incoming Supervisor field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Incoming Supervisor Name"; Rec."Incoming Supervisor Name")
                {
                    ToolTip = 'Specifies the value of the Incoming Supervisor Name field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Outgoing Branch Rep. Person"; Rec."Outgoing Branch Rep. Person")
                {
                    ToolTip = 'Specifies the value of the Outgoing Branch Rep. Person to field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Outgoing Reporting Person Name"; Rec."Outgoing Reporting Person Name")
                {
                    ToolTip = 'Specifies the value of the OOutgoing Reporting Person Name to field.', Comment = '%';
                    Editable = IsOpen;
                }

                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    Editable = IsOpen;
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
                Visible = IsOpen;
                Image = SendApprovalRequest;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Send for Approval request?', false) then
                        EmpActMgt.SendForApproval(Rec."Emp Act. No", Rec."Employee Act Type"::"HR Transfer");
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
                    if Confirm('Do you want to Post Transfer?', false) then begin
                        EmpActMgt.PostTransferInBulk(rec."Emp Act. No");
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
                    if Confirm('Do you want to Reject Transfer?', false) then
                        EmpActMgt.RejectJournal(Rec, true);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec."Employee Act Type" := Rec."Employee Act Type"::"HR Transfer";
        Rec.Type := Rec.Type::"Employee Journal";
        Rec.SetUpNewLine(xRec);
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetFieldEnable;
        SetLayout();
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        SetFieldEnable;
        SetLayout();
    end;

    var
        IsOpen, IsPending, IsApproved, IsRejected : Boolean;
        UnitEdit: Boolean;
        DepartmentEdit: Boolean;
        ExtensionCounterEdit: Boolean;
        BranchEdit: Boolean;
        ProvinceEdit: Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;

        TransferMgt: Codeunit "Transfer Mgt.";
        EmpActMgt: Codeunit EmployeeActivityMgt;
        ApproverMgt: Codeunit "Approver Mgt";

    local procedure SetFieldEnable();
    begin
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        CASE Rec."Deputation on (To)" OF
            Rec."Deputation on (To)"::Branch:
                begin
                    ProvinceEdit := true;
                    BranchEdit := true;
                    ExtensionCounterEdit := true;
                    DepartmentEdit := FALSE;
                    UnitEdit := FALSE;
                end;
            Rec."Deputation on (To)"::Province:
                begin
                    ProvinceEdit := true;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := FALSE;
                    UnitEdit := FALSE;
                end;
            Rec."Deputation on (To)"::Department:
                begin
                    ProvinceEdit := false;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := true;
                    UnitEdit := true;
                end;
            Rec."Deputation on (To)"::Unit:
                begin
                    ProvinceEdit := false;
                    BranchEdit := false;
                    ExtensionCounterEdit := false;
                    DepartmentEdit := true;
                    UnitEdit := true;
                end;
            Rec."Deputation on (To)"::"Extension Counter":
                begin
                    ProvinceEdit := true;
                    BranchEdit := true;
                    ExtensionCounterEdit := TRUE;
                    DepartmentEdit := FALSE;
                    UnitEdit := FALSE;
                end;
        end;
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
}
