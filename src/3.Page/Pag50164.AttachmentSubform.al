page 50164 "Attachment Subform"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Incoming Document";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(attachmentCode; Rec."Attachment Code")
                {
                    ToolTip = 'Specifies the value of the Attachment Code field.';
                    ApplicationArea = All;
                    Caption = 'Attachment Code';
                }
                field(number; Rec."No.")
                {
                    Editable = not isGUIAllowed;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field(fileName; Rec."File Name")
                {
                    Editable = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the File Name field.';
                    ApplicationArea = All;
                    Caption = 'File Name';
                    trigger OnDrillDown()
                    begin
                        PreviewAttachment.PreviewAttachment(returnAttachmentBase64(Rec."No.", Rec."Entry No."));
                        PreviewAttachment.Run();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PreviewAttachment.PreviewAttachment(returnAttachmentBase64(Rec."No.", Rec."Entry No."));
                        PreviewAttachment.Run();
                    end;
                }
                field(type; Rec.Type)
                {
                    Editable = not isGUIAllowed;
                    Visible = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(empCode; Rec."Employee Code")
                {
                    Visible = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field(leaveCode; Rec."Leave Type Code")
                {
                    Visible = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the Leave Type Code field.';
                    ApplicationArea = All;
                }
                field(empActivityType; Rec."Employee Activity Type")
                {
                    Visible = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the Employee Activity Type field.';
                    ApplicationArea = All;
                }
                field(ext; Extension)
                {
                    Visible = not isGUIAllowed;
                }
                field(ShowUpload; ShowUpload)
                { Visible = not isGUIAllowed; }
                field(ShowDownload; ShowDownload)
                { Visible = not isGUIAllowed; }
                field(ShowDelete; ShowDelete)
                { Visible = not isGUIAllowed; }
                field(importAttachment; ImportAttachmentDocument)
                {
                    Visible = not isGUIAllowed;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Upload)
            {
                Image = MoveUp;
                ToolTip = 'Executes the Upload action.';
                ApplicationArea = All;
                Visible = true;

                trigger OnAction()
                begin
                    if Confirm('Do You Want to Upload Attachment?', false) then
                        AttachmentMgt.UploadAttachment(Rec);

                end;
            }
            action(Download)
            {
                Image = MoveDown;
                ToolTip = 'Executes the Download action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do You Want to Download Attachment?', false) then
                        AttachmentMgt.DownloadAttachment(Rec);
                end;
            }
            action(Preview)
            {
                Image = View;
                ToolTip = 'Executes the Preview action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PreviewAttachment.PreviewAttachment(returnAttachmentBase64(Rec."No.", Rec."Entry No."));
                    PreviewAttachment.Run();
                end;
            }
            action(Remove)
            {
                Image = Delete;
                ToolTip = 'Executes the Remove action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    Employee: Record Employee;

                begin
                    if not Confirm('Do You Want to Delete Attachment?', false) then
                        exit;
                    AttachmentMgt.DeleteAttachment(Rec);
                end;
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    begin
        if not GuiAllowed then // Attachment Upload from API
            if ImportAttachmentDocument <> '' then
                AttachmentMgt.uploadAttachment(Rec, ImportAttachmentDocument, Extension);//Import Attachment for insurance
    end;

    trigger OnOpenPage()
    begin
        if GuiAllowed then
            isGUIAllowed := true
        else
            isGUIAllowed := false;
    end;

    local procedure returnAttachmentBase64(docNo: Code[20]; entryNo: Integer): Text
    var
        Base64: Codeunit "Base64 Convert";
        IncomingDocAttachment: Record "Incoming Document Attachment";
        instream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        IncomingDocAttachment.SetRange("Incoming Document Entry No.", entryNo);
        if IncomingDocAttachment.FindFirst() then begin
            // Load the BLOB into an InStream
            IncomingDocAttachment.CalcFields("Content");
            TempBlob.FromRecord(IncomingDocAttachment, IncomingDocAttachment.FieldNo("Content"));
            TempBlob.CreateInStream(instream);
            exit(Base64.ToBase64(instream, false));
        end else
            Error('No attachment found for the specified Incoming Document.');
    end;

    var
        AttachmentMgt: Codeunit "Attachment Mgt.";
        EmpLoan: Record "Employee Loan/Advance";
        Leave: Record Leave;
        TravelRequest: Record "Travel Request";
        EmployeeTransfer: Record "Employee Transfer";
        isGUIAllowed: Boolean;
        PreviewAttachment: Page "Preview Attachment";
        ImportAttachmentDocument: text;
        ShowUpload: Boolean;
        ShowDownload: Boolean;
        ShowDelete: Boolean;
        Extension: text;
        RecRef: RecordRef;

}
