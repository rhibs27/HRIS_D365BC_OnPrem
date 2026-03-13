page 50070 "Document Approver Resignation"
{
    Caption = 'Document Approver Resignation';
    PageType = ListPart;
    SourceTable = "Document Approver";
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(documentNo; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Editable = false;
                    Visible = false;
                }
                field(lineNo; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Editable = false;
                    Visible = false;
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                    Caption = 'Employee No.';
                }
                field(employeeName; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                    Caption = 'Employee Name';
                    Editable = false;
                }
                field(approvedDate; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                    Caption = 'Approved Date';
                    Editable = false;
                }
                field(approverSequence; Rec."Approver Sequence")
                {
                    ToolTip = 'Specifies the value of the Approver Sequence field.';
                    ApplicationArea = All;
                    Caption = 'Approver Sequence';
                    Editable = false;
                }
                field(remarks; Rec.Remarks)
                {
                    Caption = 'Resign Clearance Remarks';
                    ToolTip = 'Specifies the value of the Resign Clearance Remarks field.';
                    ApplicationArea = All;
                }
                field(rejectionRemarks; Rec."Rejection Remarks")
                {
                    Caption = 'Resign Clearance Rejection Remarks';
                    ToolTip = 'Specifies the value of the Resign Clearance Rejection Remarks field.';
                    ApplicationArea = All;
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Caption = 'Approval Status';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Approve")
            {
                Image = Approval;
                ToolTip = 'Executes the Return Rejected action.';
                ApplicationArea = All;
                Enabled = EditableField;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Approve record?', false) then begin
                        ApproverMgt.ApproveResignClerance(Rec, true);
                    end;
                end;
            }
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
                    AttachmentType: Enum "Attachment Setup Type";
                begin
                    if Rec.Attachment.HasValue() then
                        if not Confirm(OverrideImageQst) then
                            exit;
                    if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FileName, InStream) then begin
                        // check file size
                        AttachmentMgt.CheckAttachmentSizeLimit(InStream, Format(AttachmentType::Resignation));
                        // Check File Extension
                        Extension := FileManagement.GetExtension(FileName);
                        if Extension = '' then
                            Error('Invalid file. Please upload jpg, png or pdf files.');
                        AttachmentMgt.checkAttachmentExtensionImage(Extension);
                        Clear(Rec.Attachment);
                        Rec.Attachment.ImportStream(InStream, FileName);
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
                    ItemTenantMedia: Record "Tenant Media";
                    Instream: InStream;
                begin
                    if ItemTenantMedia.Get(Rec.Attachment.MediaId) then begin
                        ToFile := Format(Rec."Document No.") + '_' + Format(Rec."Line No.") + '.' + FileManagement.GetExtension(ItemTenantMedia.Description);
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
                Enabled = DeleteExportEnabled and EditableField;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    if not Confirm(DeleteImageQst) then
                        exit;
                    Clear(Rec.Attachment);
                    Rec.Modify(true);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Resignation);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Resignation);
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
    end;

    trigger OnAfterGetRecord()
    begin
        DeleteExportEnabled := Rec.Attachment.HasValue();
        EditableField := Rec."Approval Status" = Rec."Approval Status"::Open;
    end;

    var
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteExportEnabled: Boolean;
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        EditableField: Boolean;
        PreviewAttachment: page "Preview Attachment";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        IsOpen: Boolean;

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
