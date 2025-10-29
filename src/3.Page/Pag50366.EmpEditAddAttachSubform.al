page 50366 "Emp. Edit Add. Attach. Subform"
{
    ApplicationArea = All;
    Caption = 'Emp. Edit Add. Attach. Subform';
    PageType = ListPart;
    SourceTable = "Employee Edit Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Attachment Document Type"; Rec."Attachment Document Type")
                {
                    ToolTip = 'Specifies the value of the Attachment Document Type field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Attachment; Rec.Attachment)
                {
                    ToolTip = 'Specifies the value of the Attachment field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import';

                ToolTip = 'Import a picture file.';
                trigger OnAction()
                var
                    Extension: Text;
                    FileMgt: Codeunit "File Management";
                    InStreamPic: InStream;
                    FromFileName: Text;
                    AttachmentMgt: Codeunit "Attachment Mgt.";
                begin
                    if Rec.Attachment.HasValue() then
                        if not Confirm('There is an existing attachment. Do you wish to proceed') then
                            exit;
                    if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FromFileName, InStreamPic) then begin
                        // Check File Size Limit
                        AttachmentMgt.CheckAttachmentSizeLimit(InStreamPic, Format(Rec."Change in Emp Type"));

                        // Check File Extension
                        Extension := FileMgt.GetExtension(FromFileName);
                        if Extension = '' then
                            Error('Invalid file. Please upload jpg, png or pdf files.');
                        AttachmentMgt.checkAttachmentExtensionImage(Extension);
                        Clear(Rec.Attachment);
                        Rec.Attachment.ImportStream(InStreamPic, FromFileName);
                        Rec.Modify(true);
                    end;
                end;
            }
            action(Preview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview';

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

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                    ItemTenantMedia: Record "Tenant Media";
                    Instream: InStream;
                    fileInitial: Text;
                begin
                    if ItemTenantMedia.Get(Rec.Attachment.MediaId) then begin
                        ToFile := Format(Rec."Employee No.") + '_' + format(Rec.Description) + '.' + FileManagement.GetExtension(ItemTenantMedia.Description);
                        ItemTenantMedia.CalcFields(Content);
                        ItemTenantMedia.Content.CreateInStream(Instream, TextEncoding::UTF8);
                        DownloadFromStream(Instream, '', '', '', ToFile);
                    end;
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete';

                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    Rec.TestField("Employee No.");

                    if not Confirm('Do you want to delete?') then
                        exit;
                    Clear(Rec.Attachment);
                    Rec.Modify(true);
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Change in Emp Type" := Rec."Change in Emp Type"::"Additional Documents";
    end;

    var
        PreviewAttachment: Page "Preview Attachment";

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
}
