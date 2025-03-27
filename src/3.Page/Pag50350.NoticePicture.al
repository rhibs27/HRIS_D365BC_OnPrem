page 50350 "Notice Picture"
{
    ApplicationArea = All;
    Caption = 'Notice Picture';
    PageType = CardPart;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    SourceTable = "Notice Bulletin";

    layout
    {
        area(Content)
        {
            field(Attachment; Rec.Notice.HasValue())
            {
                ToolTip = 'Specifies the value of the Notice field.';
            }

        }
    }


    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';
                Enabled = EditableField;

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    InStream: InStream;
                    AttachmentMgt: Codeunit "Attachment Mgt.";
                    Extension: Text;
                begin
                    Rec.TestField("Entry No.");

                    if Rec.Notice.HasValue() then
                        if not Confirm(OverrideImageQst) then
                            exit;
                    if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FileName, InStream) then begin
                        // check file size 
                        AttachmentMgt.CheckAttachmentSizeLimit(InStream, RecordId.TableNo);
                        // Check File Extension
                        Extension := FileManagement.GetExtension(FileName);
                        if Extension = '' then
                            Error('Invalid file. Please upload jpg, png or pdf files.');
                        case LowerCase(Extension) of
                            'jpg', 'jpeg', 'png', 'pdf':
                                begin
                                end;
                            else
                                Error('Invalid file extension. Please upload jpg, png or pdf files.');
                        end;
                        Clear(Rec.Notice);
                        Rec.Notice.ImportStream(InStream, FileName);
                        Rec.Modify(true);
                    end;
                end;
            }
            action(Preview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview';
                Enabled = DeleteExportEnabled;
                Image = view;
                ToolTip = 'View the Attachment';

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
                Enabled = DeleteExportEnabled and EditableField;
                Image = Export;
                ToolTip = 'Export the picture to a file.';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                    ItemTenantMedia: Record "Tenant Media";
                begin
                    Rec.TestField("Entry No.");
                    if ItemTenantMedia.Get(Rec.Notice.MediaId) then
                        ToFile := Format(Rec."Entry No.") + '.' + FileManagement.GetExtension(ItemTenantMedia."File Name");
                    ExportPath := TemporaryPath + Format(Rec."Entry No.") + Format(Rec.Notice.MediaId);
                    Rec.Notice.ExportFile(ExportPath);

                    FileManagement.ExportImage(ExportPath, ToFile);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled and EditableField;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    Rec.TestField("Entry No.");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec.Notice);
                    Rec.Modify(true);
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
        if Rec.Notice.HasValue then begin
            if ItemTenantMedia.Get(Rec.Notice.MediaId) then begin
                ItemTenantMedia.CalcFields(Content);
                TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                TempBlob.CreateInStream(InStr);
                exit(base64.ToBase64(InStr));
            end;
        end;
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec.Notice.HasValue();
        if rec."Notice End Date" >= Today then
            EditableField := true;
    end;
}
