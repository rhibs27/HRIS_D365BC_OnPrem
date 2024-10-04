page 33019983 "Sample Attachments"
{
    PageType = List;
    SourceTable = "Incoming Document";
    SourceTableView = where(Type = const(Sample));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Attachment Code"; Rec."Attachment Code")
                {
                    ToolTip = 'Specifies the value of the Attachment Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("File Name"; Rec."File Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the File Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Upload)
            {
                Image = MoveUp;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Upload action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LoanMgt.UploadAttachment(Rec);
                    CurrPage.Update;
                end;
            }
            action(Download)
            {
                Image = MoveDown;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Download action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LoanMgt.DownloadAttachment(Rec);
                end;
            }
            action(Remove)
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Remove action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LoanMgt.DeleteAttachment(Rec);
                    CurrPage.Update;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Sample;
    end;

    var
        LoanMgt: Codeunit "Loan Mgt.";
}
