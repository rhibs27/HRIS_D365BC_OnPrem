page 50038 "Loan Journal"
{
    //this journal pages now doesnt have approval workflow. You can add it leter if needed, but with proper visibility management and controls
    ApplicationArea = All;
    Caption = 'Loan Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    SourceTableView = where("Employee Act Type" = const("Loan Journal"));
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
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the value of the Loan Type field.', Comment = '%';
                }
                field("Loan Account No."; Rec."Loan Account No.")
                {
                    ToolTip = 'Specifies the value of the Loan Account No. field.', Comment = '%';
                }
                field("Loan Account Opening Date"; Rec."Loan Account Opening Date")
                {
                    ToolTip = 'Specifies the value of the Loan Account Opening Date field.', Comment = '%';
                }
                field("Loan Interest Rate (%)"; Rec."Loan Interest Rate (%)")
                {
                    ToolTip = 'Specifies the value of the Loan Interest Rate (%) field.', Comment = '%';
                }
                field("Loan Disbursed Amount"; Rec."Loan Disbursed Amount")
                {
                    ToolTip = 'Specifies the value of the Loan Disbursed Amount field.', Comment = '%';
                }
                field("Loan Expiry Date"; Rec."Loan Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Loan Expiry Date field.', Comment = '%';
                }
                field("Loan Settlement Date"; Rec."Loan Settlement Date")
                {
                    ToolTip = 'Specifies the value of the Loan Settlement Date field.', Comment = '%';
                }
                field("Policy No"; Rec."Policy No")
                {
                    ToolTip = 'Specifies the value of the Policy No field.', Comment = '%';
                }
                field("Yearly Premium Amount"; Rec."Yearly Premium Amount")
                {
                    ToolTip = 'Specifies the value of the Yearly Premium Amount field.', Comment = '%';
                }
                field("Insurance Company"; Rec."Insurance Company")
                {
                    ToolTip = 'Specifies the value of the Insurance Company field.', Comment = '%';
                }
                field("First Premium Date"; Rec."First Premium Date")
                {
                    ToolTip = 'Specifies the value of the First Premium Date field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
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
        }
    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Post Loan?', false) then begin
                        EmpActMgt.PostLoanInBulk(rec."Emp Act. No");
                        CurrPage.Close();
                    end;
                end;
            }
            action("Import Attachment")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;
                Visible = IsOpen;
                trigger OnAction()
                begin
                    AttachmentMgt.ImportAttachmentToEmpActJnl(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec."Employee Act Type" := Rec."Employee Act Type"::"Loan Journal";
        Rec.Type := Rec.Type::"Employee Journal";
        Rec.SetUpNewLine(xRec);
        Rec."Attachment File Name" := SelectFileTxt;
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetLayout();
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
    end;

    var
        IsOpen, IsPending, IsApproved, IsRejected : Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        EmpActMgt: Codeunit EmployeeActivityMgt;
        HrSetup: Record "Human Resources Setup";
        AttachmentMgt: Codeunit "Attachment Mgt.";
        SelectFileTxt: Label 'Attach File(s)...';

    procedure SetLayout()
    begin
        HrSetup.Get();

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
