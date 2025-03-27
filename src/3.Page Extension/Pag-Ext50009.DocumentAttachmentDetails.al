pageextension 50009 "Document Attachment Details" extends "Document Attachment Details"
{

    layout
    {
        addafter("Document Flow Sales")
        {
            field("Attachment Document Type"; Rec."Attachment Document Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Attachment Document Type field.';
                trigger OnValidate()
                begin
                    CurrPage.Update;
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    AttachmentSetup: Record "Attachment Setup";
                begin
                    AttachmentSetup.Reset();
                    AttachmentSetup.SetRange(Type, AttachmentSetup.type::"Employee Profile");
                    if Page.RunModal(Page::"Attachment Setup", AttachmentSetup) = Action::LookupOK then
                        Rec."Attachment Document Type" := AttachmentSetup."Attachment Code";
                end;
            }
        }
    }
    actions
    {
        addafter(Preview)
        {
            action("Preview Attachment")
            {
                Caption = 'Preview';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Preview action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PreviewAttachment.PreviewAttachment(returnAttachmentBase64());
                    PreviewAttachment.Run();
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean

    begin
        QualificationLevelEditable := true //Qualification Level Editable on condition
    end;

    trigger OnAfterGetRecord()

    begin
        //>>Qualification Level Editable on condition
    end;

    local procedure returnAttachmentBase64(): Text;
    var
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
    begin
        if Rec."Document Reference ID".HasValue then begin
            if ItemTenantMedia.Get(Rec."Document Reference ID".MediaId) then begin
                ItemTenantMedia.CalcFields(Content);
                TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                TempBlob.CreateInStream(InStr);
                exit(base64.ToBase64(InStr));
            end;
        end;
    end;

    var
        QualificationLevelEditable: Boolean;
        PreviewAttachment: page "Preview Attachment";
}
