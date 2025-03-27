pageextension 50009 "Document Attachment Details" extends "Document Attachment Details"
{
    layout
    {
        addafter("Document Flow Sales")
        {
            field("Qualification Doc. Type"; Rec."Qualification Doc. Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qualification Doc. Type field.';
                trigger OnValidate()

                begin
                    CurrPage.Update;
                end;
            }
            field("Qualification Level"; Rec."Qualification Level")
            {
                ApplicationArea = All;
                Editable = QualificationLevelEditable;
                ToolTip = 'Specifies the value of the Qualification Level field.';
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
        if Rec."Qualification Doc. Type" = Rec."Qualification Doc. Type"::Work then
            QualificationLevelEditable := false
        else
            QualificationLevelEditable := true;
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
