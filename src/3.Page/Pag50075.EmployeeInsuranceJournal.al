page 50075 "Employee Insurance Journal"
{
    ApplicationArea = All;
    Caption = 'Employee Insurance Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    SourceTableView = where("Employee Act Type" = filter("Employee Activity Type"::"Insurance"));
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
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Insurance Type"; rec."Insurance Type")
                {
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field("Policy No"; rec."Policy No")
                {
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field("Insurance Company Code"; rec."Insurance Company Code")
                {
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field("Insurance Company Name"; rec."Insurance Company Name")
                {
                    ApplicationArea = all;
                }
                field("Insurance Start Date (AD)"; rec."Start Date")
                {
                    Caption = 'Insurance Start Date (AD)';
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field("Insurance Start Date (BS)"; rec."Start Date (BS)")
                {
                    Caption = 'Insurance Start Date (BS)';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Insurance Expiry Date (AD)"; rec."End Date")
                {
                    Caption = 'Insurance Expiry Date (AD)';
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field("Insurance Expiry Date (BS)"; rec."End Date (BS)")
                {
                    Caption = 'Insurance Expiry Date (BS)';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Insurance Amount"; rec."Insurance Amount")
                {
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field("Premium Paid By"; rec."Premium Paid By")
                {
                    ApplicationArea = all;
                    Editable = IsOpen;
                }

                field("Monthly Premium Amount"; rec."Premium Amount")
                {
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field("Premium Payment Frequency"; Rec."Premium Payment Frequency")
                {
                    ApplicationArea = all;
                }
                field("Annual Premium Amount"; rec."Annual Premium Amount")
                {
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field(Remarks; rec.Remarks)
                {
                    ApplicationArea = all;
                    Editable = IsOpen;
                }
                field("Attachment File Name"; Rec."Attachment File Name")
                {
                    ToolTip = 'Specifies the value of the Attachment File Name field.', Comment = '%';
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        if Rec.Attachment.HasValue() then
                            //export the attachment
                            AttachmentMgt.ExportAttachmentFromEmpActJnl(Rec)
                        else
                            //import the attachment
                            begin
                            Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                            AttachmentMgt.ImportAttachmentToEmpActJnl(Rec);
                        end;
                        CurrPage.Update();
                    end;
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
                        Rec.SetRange("Employee Act Type", Rec."Employee Act Type"::"Insurance");
                        for i := 1 to ListOfDocNo.Count do begin
                            EmpActMgt.SendForApproval(ListOfDocNo.Get(i), Rec."Employee Act Type"::Insurance);
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
                    if Confirm('Do you want to Approve request?', false) then begin
                        Clear(ListOfDocNo);
                        CurrPage.SetSelectionFilter(Rec);
                        if Rec.FindSet() then
                            repeat
                                if not ListOfDocNo.Contains(Rec."Emp Act. No") then
                                    ListOfDocNo.Add(rec."Emp Act. No");
                            until rec.Next() = 0;
                        Rec.Reset();
                        Rec.SetRange("Employee Act Type", Rec."Employee Act Type"::"Insurance");
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
                    if Confirm('Do you want to Post Document?', false) then begin
                        Clear(ListOfDocNo);
                        CurrPage.SetSelectionFilter(Rec);
                        if Rec.FindSet() then
                            repeat
                                if not ListOfDocNo.Contains(Rec."Emp Act. No") then
                                    ListOfDocNo.Add(rec."Emp Act. No");
                            until rec.Next() = 0;
                        for i := 1 to ListOfDocNo.Count do begin
                            EmpActMgt.PostEmployeeInsuranceJournal(ListOfDocNo.Get(i));
                        end;
                        Message('Employee Insurance Journal is posted');
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
                    if not Confirm('Do you want to Reject Employee Insurance Journal?', false) then
                        exit;
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
                    if not Confirm('Do you want Employee Insurance From Excel?', false) then
                        exit;
                    ExcelImportMgt.ImportJournalFromExcelSheet(Rec."Employee Act Type"::Insurance);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec."Employee Act Type" := Rec."Employee Act Type"::"Insurance";
        Rec.Type := Rec.Type::"Employee Journal";
        Rec.SetUpNewLine(xRec);
        CurrPage.Update(false);
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

    protected var
        StatusView, ApprovalStatusView : Boolean;
        IsOpen, IsPending, IsApproved, IsRejected : Boolean;

    var

        ExcelImportMgt: Codeunit "Excel Import";
        ListOfDocNo: List of [code[20]];
        i: Integer;
        AttachmentMgt: Codeunit "Attachment Mgt.";
        EmpActMgt: Codeunit EmployeeActivityMgt;
        ApproverMgt: Codeunit "Approver Mgt";
}
