page 50006 "Employee Edit Subform"
{
    ApplicationArea = All;
    Caption = 'Employee Edit Subform';
    PageType = ListPart;
    SourceTable = "Employee Edit Line";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Attacment; Rec.Attachment)
                {
                    ToolTip = 'Specifies the value of the Attacment field.', Comment = '%';
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ToolTip = 'Specifies the value of the Birth Date field.', Comment = '%';
                }
                field(CGPA; Rec.CGPA)
                {
                    ToolTip = 'Specifies the value of the CGPA field.', Comment = '%';
                }
                field("Change in Emp Type"; Rec."Change in Emp Type")
                {
                    ToolTip = 'Specifies the value of the Change in Emp Type field.', Comment = '%';
                }
                field("Contact Number"; Rec."Contact Number")
                {
                    ToolTip = 'Specifies the value of the Contact Number field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Designation; Rec.Designation)
                {
                    ToolTip = 'Specifies the value of the Designation field.', Comment = '%';
                }
                field("Employee Document Type"; Rec."Employee Document Type")
                {
                    ToolTip = 'Specifies the value of the Employee Document Type field.', Comment = '%';
                }
                field("Employee Relative In Bank"; Rec."Employee Relative In Bank")
                {
                    ToolTip = 'Specifies the value of the Employee Relative In Bank field.', Comment = '%';
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.', Comment = '%';
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                    ToolTip = 'Specifies the value of the Institution/Company field.', Comment = '%';
                }
                field(Language; Rec.Language)
                {
                    ToolTip = 'Specifies the value of the Language field.', Comment = '%';
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.', Comment = '%';
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ToolTip = 'Specifies the value of the Qualification Code field.', Comment = '%';
                }
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ToolTip = 'Specifies the value of the Qualification Type field.', Comment = '%';
                }
                field(Rank; Rec.Rank)
                {
                    ToolTip = 'Specifies the value of the Rank field.', Comment = '%';
                }
                field(Reading; Rec.Reading)
                {
                    ToolTip = 'Specifies the value of the Reading field.', Comment = '%';
                }
                field("Relative CitizenShip No."; Rec."Relative CitizenShip No.")
                {
                    ToolTip = 'Specifies the value of the Relative CitizenShip No. field.', Comment = '%';
                }
                field("Relative Code"; Rec."Relative Code")
                {
                    ToolTip = 'Specifies the value of the Relative Code field.', Comment = '%';
                }
                field("Relative District"; Rec."Relative District")
                {
                    ToolTip = 'Specifies the value of the Relative District field.', Comment = '%';
                }
                field("Relative Phone No."; Rec."Relative Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.', Comment = '%';
                }
                field("Relative VDC/Municipality"; Rec."Relative VDC/Municipality")
                {
                    ToolTip = 'Specifies the value of the Relative VDC/Municipality field.', Comment = '%';
                }
                field("Relative's Employee No."; Rec."Relative's Employee No.")
                {
                    ToolTip = 'Specifies the value of the Relative Employee No. field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(Remuneration; Rec.Remuneration)
                {
                    ToolTip = 'Specifies the value of the Remuneration field.', Comment = '%';
                }
                field(Speaking; Rec.Speaking)
                {
                    ToolTip = 'Specifies the value of the Speaking field.', Comment = '%';
                }
                field(Stream; Rec.Stream)
                {
                    ToolTip = 'Specifies the value of the Stream field.', Comment = '%';
                }
                field("Time Period"; Rec."Time Period")
                {
                    ToolTip = 'Specifies the value of the Time Period field.', Comment = '%';
                }
                field(Typing; Rec.Typing)
                {
                    ToolTip = 'Specifies the value of the Typing field.', Comment = '%';
                }
                field("Ward No."; Rec."Ward No.")
                {
                    ToolTip = 'Specifies the value of the Relative Ward No. field.', Comment = '%';
                }
                field(Writing; Rec.Writing)
                {
                    ToolTip = 'Specifies the value of the Writing field.', Comment = '%';
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.', Comment = '%';
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
