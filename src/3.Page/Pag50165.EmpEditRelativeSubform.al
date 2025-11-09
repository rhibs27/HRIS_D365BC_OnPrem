page 50165 "Emp. Edit Relative Subform"
{
    ApplicationArea = All;
    Caption = 'Emp. Edit Relative Subform';
    PageType = ListPart;
    SourceTable = "Employee Edit Line";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Relative Code"; Rec."Relative Code")
                {
                    ToolTip = 'Specifies the value of the Relative Code field.', Comment = '%';
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.', Comment = '%';
                }
                field("Relative Phone No."; Rec."Relative Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.', Comment = '%';
                }
                field("Relative Mail"; Rec."Relative Mail")
                {
                    ToolTip = 'Specifies the value of the Relative Mail field.', Comment = '%';
                }
                field("Employee Relative In Bank"; Rec."Employee Relative In Bank")
                {
                    ToolTip = 'Specifies the value of the Employee Relative In Bank field.', Comment = '%';
                }
                field("Relative's Employee No."; Rec."Relative's Employee No.")
                {
                    ToolTip = 'Specifies the value of the Relative Employee No. field.', Comment = '%';
                }
                field("Relative CitizenShip No."; Rec."Relative CitizenShip No.")
                {
                    ToolTip = 'Specifies the value of the Relative CitizenShip No. field.', Comment = '%';
                }
                field("Set Emergency Contact"; Rec."Set Emergency Contact")
                {
                    ToolTip = 'Specifies the value of the Set Emergency Contact field.', Comment = '%';
                }
                field(lt; Rec."lt.")
                {
                    ToolTip = 'Specifies the value of the lt field.', Comment = '%';
                }
                field("Set Nominee"; Rec."Set Nominee")
                {
                    ToolTip = 'Specifies the value of the Set Nominee.', Comment = '%';
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
                    // Rec.TestField("Entry No.");
                    if Rec.Attachment.HasValue() then
                        if not Confirm('There is an existing attachment. Do you wish to proceed') then
                            exit;
                    if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FromFileName, InStreamPic) then begin
                        // check file size
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
                ToolTip = 'Export the picture to a file.';
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
                        ToFile := Format(Rec."Employee No.") + '_' + format(Rec."Relative Code") + '.' + FileManagement.GetExtension(ItemTenantMedia.Description);
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
        Rec."Change in Emp Type" := Rec."Change in Emp Type"::Relative;
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
