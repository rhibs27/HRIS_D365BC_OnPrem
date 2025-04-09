page 50228 "Employee Edit Picture"
{
    ApplicationArea = All;
    Caption = 'Employee Picture';
    PageType = CardPart;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    SourceTable = "Employee Edit";

    layout
    {
        area(Content)
        {
            field(Attachment; Rec.Attachment.HasValue())
            {
                ToolTip = 'Specifies the value of the Notice field.';
            }

        }
    }


    actions
    {
        area(processing)
        {
            action(Preview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview';
                Image = view;
                ToolTip = 'View the Attachment';
                Enabled = DeleteExportEnabled;

                trigger OnAction()
                begin
                    PreviewAttachment.PreviewAttachment(returnAttachmentBase64());
                    PreviewAttachment.Run();
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export';
                Image = Export;
                ToolTip = 'Export the picture to a file.';
                Enabled = DeleteExportEnabled;
                trigger OnAction()
                var
                    TenantMedia: Record "Tenant Media";
                    InStreamPic: InStream;
                    ImageLbl: Label '%1_%2.jpg';
                    FileName: Text;
                begin
                    if TenantMedia.Get(Rec.Attachment.MediaId) then begin
                        TenantMedia.CalcFields(Content);
                        if TenantMedia.Content.HasValue then begin
                            FileName := StrSubstNo(ImageLbl, Rec."No.", Rec."Changes In Employee Type");
                            TenantMedia.Content.CreateInStream(InStreamPic);
                            DownloadFromStream(InStreamPic, '', '', '', FileName);
                        end;
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions();
    end;

    var
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        EditableField: Boolean;
        PreviewAttachment: page "Preview Attachment";

    local procedure returnAttachmentBase64(): Text;
    var
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
    begin
        if Rec.Attachment.HasValue then begin
            if ItemTenantMedia.Get(Rec.Attachment.MediaId) then begin
                ItemTenantMedia.CalcFields(Content);
                TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                TempBlob.CreateInStream(InStr);
                exit(base64.ToBase64(InStr));
            end;
        end;
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec.Attachment.HasValue();
    end;
}