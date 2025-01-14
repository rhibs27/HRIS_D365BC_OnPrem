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
            field(Notice; Rec.Notice)
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
                    ClientFileName: Text;
                begin
                    Rec.TestField("Entry No.");

                    if Rec.Notice.HasValue() then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    if FileName = '' then
                        exit;

                    Clear(Rec.Notice);
                    Rec.Notice.ImportFile(FileName, ClientFileName);
                    Rec.Modify(true);
                    if FileManagement.DeleteServerFile(FileName) then;
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

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec.Notice.HasValue();
        if rec."Notice End Date" >= Today then
            EditableField := true;
    end;
}
