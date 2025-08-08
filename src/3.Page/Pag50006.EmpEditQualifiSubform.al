page 50006 "Emp. Edit Qualifi Subform"
{
    ApplicationArea = All;
    Caption = 'Emp. Edit Qualifi Subform';
    PageType = ListPart;
    SourceTable = "Employee Edit Line";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ToolTip = 'Specifies the value of the Qualification Type field.', Comment = '%';
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ToolTip = 'Specifies the value of the Qualification Code field.', Comment = '%';
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                    ToolTip = 'Specifies the value of the Institution/Company field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }


                field(CGPA; Rec.CGPA)
                {
                    ToolTip = 'Specifies the value of the CGPA field.', Comment = '%';
                }

                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.', Comment = '%';
                }

                field(Stream; Rec.Stream)
                {
                    ToolTip = 'Specifies the value of the Stream field.', Comment = '%';
                }

                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.', Comment = '%';
                }
                field(Running; Rec.Running)
                {
                    ToolTip = 'Specifies the value of the Running field.', Comment = '%';
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
                        if Rec."Change in Emp Type" = Rec."Change in Emp Type"::Qualification then
                            AttachmentMgt.CheckAttachmentSizeLimit(InStreamPic, Format(Rec."Employee Document Type"::Education))
                        else if Rec."Change in Emp Type" = Rec."Change in Emp Type"::"Work Experience" then
                            AttachmentMgt.CheckAttachmentSizeLimit(InStreamPic, Format(Rec."Change in Emp Type"))
                        else
                            Error('Invali');

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
                    // Rec.TestField("Entry No.");
                    if ItemTenantMedia.Get(Rec.Attachment.MediaId) then begin
                        if Rec."Change in Emp Type" = Rec."Change in Emp Type"::"Work Experience" then
                            fileInitial := Rec.Designation
                        else
                            fileInitial := Rec."Qualification Code";

                        ToFile := Format(Rec."Employee No.") + '_' + format(fileInitial) + '.' + FileManagement.GetExtension(ItemTenantMedia.Description);
                        ItemTenantMedia.CalcFields(Content);
                        ItemTenantMedia.Content.CreateInStream(Instream, TextEncoding::UTF8);
                        DownloadFromStream(Instream, '', '', '', ToFile);
                    end;
                    // ExportPath := TemporaryPath + Format(Rec."Employee No.") + Format(Rec.Attachment.MediaId);
                    // Rec.Attachment.ExportFile(ExportPath);
                    // FileManagement.ExportImage(ExportPath, ToFile);
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

                    if not Confirm('Do you want to delete/') then
                        exit;
                    Clear(Rec.Attachment);
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Change in Emp Type" := Rec."Change in Emp Type"::Qualification;
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
