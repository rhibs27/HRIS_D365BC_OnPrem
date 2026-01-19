page 50053 "Late Deduction Journal"
{
    ApplicationArea = All;
    Caption = 'Late Deduction Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    SourceTableView = where("Employee Act Type" = filter("Employee Activity Type"::"Late Deduction"));
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
                field("Employee Name"; Rec."Employee Name") { }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
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
                    if Confirm('Do you want to Send for Approval request?', false) then begin
                        Clear(ListOfDocNo);
                        CurrPage.SetSelectionFilter(Rec);
                        if Rec.FindSet() then
                            repeat
                                if not ListOfDocNo.Contains(Rec."Emp Act. No") then
                                    ListOfDocNo.Add(rec."Emp Act. No");
                            until rec.Next() = 0;
                        Rec.Reset();
                        Rec.SetRange("Employee Act Type", Rec."Employee Act Type"::"Late Deduction");
                        for i := 1 to ListOfDocNo.Count do begin
                            EmpActMgt.SendForApproval(ListOfDocNo.Get(i), rec."Employee Act Type"::"Late Deduction");
                        end;
                    end;
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
                    if Confirm('Do you want to Approve Late Deduction?', false) then begin
                        Clear(ListOfDocNo);
                        CurrPage.SetSelectionFilter(Rec);
                        if Rec.FindSet() then
                            repeat
                                if not ListOfDocNo.Contains(Rec."Emp Act. No") then
                                    ListOfDocNo.Add(rec."Emp Act. No");
                            until rec.Next() = 0;
                        Rec.Reset();
                        Rec.SetRange("Employee Act Type", Rec."Employee Act Type"::"Late Deduction");
                        for i := 1 to ListOfDocNo.Count do begin
                            ApproverMgt.ApproveJournalDocument(ListOfDocNo.Get(i), true);
                        end;
                    end;
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
                    if Confirm('Do you want to Post Late Deduction?', false) then begin
                        Clear(ListOfDocNo);
                        CurrPage.SetSelectionFilter(Rec);
                        if Rec.FindSet() then
                            repeat
                                if not ListOfDocNo.Contains(Rec."Emp Act. No") then
                                    ListOfDocNo.Add(rec."Emp Act. No");
                            until rec.Next() = 0;
                        for i := 1 to ListOfDocNo.Count do begin
                            EmpActMgt.PostLateDeductionJournal(ListOfDocNo.Get(i));
                        end;
                        Message('Late Deduction is posted');
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
                    if Confirm('Do you want to Reject Late Deduction?', false) then
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
                    if not Confirm('Do you want Import Late Deduction Journal From Excel?', false) then
                        exit;
                    ExcelImportMgt.ImportJournalFromExcelSheet(Rec."Employee Act Type"::"Late Deduction");
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
                    if not Confirm('Do you want Export Late Deduction From Excel?', false) then
                        exit;
                    ExcelImportMgt.ExportLateDeductionSheet(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec."Employee Act Type" := Rec."Employee Act Type"::"Late Deduction";
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
        ListOfDocNo: List of [code[20]];
        i: Integer;
}

