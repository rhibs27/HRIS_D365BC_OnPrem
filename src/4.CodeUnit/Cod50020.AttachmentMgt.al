codeunit 50020 "Attachment Mgt."
{
    var
        FileMgt: Codeunit "File Management";

    procedure UploadAttachment(IncomingDocument: Record "Incoming Document")

    begin
        // Validate Incoming Document
        IncomingDocument.TestField("Entry No.");
        if IncomingDocument."File Name" <> '' then
            Error('File already exist. Please remove the file first.');
        CheckDocumentToUploadAttachment(IncomingDocument);
        IncomingDocument.ImportAttachment(IncomingDocument);
        Message('File uploaded successfully');
    end;

    procedure CheckAttachmentSizeLimit(InStream: InStream; EmpActType: text);
    var
        FileSize: Integer;
        AttachmentSetup: Record "Attachment Setup";
        MaxFileSize: Integer;
        EmployeeActType: Enum "Employee Activity Type";
    begin
        // Define maximum allowed file size
        if EmpActType = format(EmployeeActType::"HR Transfer") then
            EmpActType := format(EmployeeActType::"Employee Transfer");
        AttachmentSetup.Reset();
        AttachmentSetup.SetFilter(Type, EmpActType);
        if AttachmentSetup.FindFirst() then
            MaxFileSize := AttachmentSetup."Max File Size" * 1024 * 1024;
        if MaxFileSize = 0 then
            MaxFileSize := 2 * 1024 * 1024;
        // Get the file size in bytes
        FileSize := InStream.Length;
        // Check if the file size exceeds the maximum limit
        if FileSize > MaxFileSize then
            Error('The file is %1 MB. Maximum allowed size is %2 MB.', round(FileSize / 1024 / 1024, 0.01, '='), round(MaxFileSize / 1024 / 1024, 1, '='));
    end;

    procedure checkAttachmentExtensionImage(Ext: text)
    begin
        if Ext in ['jpg', 'jpeg', 'png', 'pdf'] then
            exit // Valid file extension, do nothing
        else
            Error('Invalid file extension. Please upload a jpg, jpeg, png or pdf file.');
    end;

    procedure DownloadAttachment(IncomingDocument: Record "Incoming Document")
    var
        InStream: InStream;
        FilePath: Text;
        FileName: Text;
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
    begin
        // Construct the file path on the server
        FilePath := IncomingDocument."File Name"; // Ensure this stores the server file path
        if FilePath = '' then
            Error('File path not specified for this document.');
        IncomingDocumentAttachment.Reset();
        IncomingDocumentAttachment.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
        if IncomingDocumentAttachment.FindFirst() then begin
            IncomingDocumentAttachment.CalcFields(Content);
            IncomingDocumentAttachment.Content.CreateInStream(InStream, TextEncoding::UTF8);
        end;
        FileName := FileMgt.GetFileName(FilePath);
        // Prompt the user to save the file on their client computer
        DownloadFromStream(InStream, '', '', '', FileName);
        Message('File downloaded successfully: %1', FileName);
    end;

    procedure DeleteAttachment(var IncomingDocument: Record "Incoming Document")
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        FilePath: text;
    begin
        CheckDocumentToDeleteAttachment(IncomingDocument);
        FilePath := IncomingDocument."File Name"; // Ensure this field stores the full file path
        IncomingDocument."File Name" := '';
        IncomingDocument.MODIFY;
        IncomingDocumentAttachment.Reset();
        IncomingDocumentAttachment.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
        IncomingDocumentAttachment.Findset();
        IncomingDocumentAttachment.DeleteAll();
        Message('File successfully deleted.');
    end;

    procedure SanitizeFileName(FileName: Text): Text
    var
        InvalidChars: Text[20];
        CleanedFileName: Text;
        CurrentChar: Char;
        i: Integer;
    begin
        InvalidChars := '\ / : * ? " < > |';

        // Step 2: Iterate through the characters in the file name
        CleanedFileName := '';
        for i := 1 to StrLen(FileName) do begin
            CurrentChar := FileName[i];
            // If the character is not invalid, add it to the cleaned file name
            if StrPos(InvalidChars, FORMAT(CurrentChar)) = 0 then
                CleanedFileName += CurrentChar
            else
                CleanedFileName += '_'; // Replace invalid character with an underscore
        end;

        exit(CleanedFileName);
    end;

    procedure SanitizeFileAttachment(FileName: Text): Text
    var
        InvalidChars: Text[20];
        CleanedFileName: Text;
        CurrentChar: Char;
        i: Integer;
    begin
        InvalidChars := '\';
        // Step 2: Iterate through the characters in the file name
        CleanedFileName := '';
        for i := 1 to StrLen(FileName) do begin
            CurrentChar := FileName[i];
            // If the character is not invalid, add it to the cleaned file name
            if StrPos(InvalidChars, FORMAT(CurrentChar)) = 0 then
                CleanedFileName += CurrentChar
            else
                CleanedFileName += '/'; // Replace invalid character
        end;
        exit(CleanedFileName);
    end;
    // For Upload from Portal API
    procedure uploadAttachment(Var IncomingDoc: Record "Incoming Document"; fname: Text; ext: Text): Text
    var
        IncomingDocAttachment: Record "Incoming Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        base64: Codeunit "Base64 Convert";
        Outstream: OutStream;
        instream: InStream;
        CleanedFileName: text;
        AttachmentMgt: Codeunit "Attachment Mgt.";
    begin
        IncomingDoc."No." := IncomingDoc.GetFilter("No.");
        if IncomingDoc."File Name" <> '' then
            Error('File already exist. Please remove the file first.');
        CleanedFileName := AttachmentMgt.SanitizeFileName(FORMAT(IncomingDoc."Entry No.") + '_' + IncomingDoc."No." + '.' + ext);
        tempblob.CreateOutStream(outStream);
        base64.FromBase64(fname, Outstream);
        TempBlob.CreateInStream(InStream); // Get the data back from TempBlob
        IncomingDoc.AddAttachmentFromStream(IncomingDocAttachment, CleanedFileName, ext, instream);
        IncomingDoc."File Name" := CleanedFileName;
        IncomingDoc.MODIFY;
    end;

    procedure CheckDocumentToDeleteAttachment(incomingDocument: Record "Incoming Document")
    var
        EmpLoan: Record "Employee Loan/Advance";
        EmployeeTransfer: Record "Employee Transfer";
        EmpInsurance: Record "Employee Insurance Information";
        AppraisalEmp: Record Appraisal;
        leave: Record leave;
        Resign: Record Resignation;
        IsHandle: Boolean;
    begin
        OnCheckDocumentToUploadAttachment(IsHandle, incomingDocument);
        if IsHandle then
            exit;
        if EmpLoan.Get(IncomingDocument."No.") then begin
            if (EmpLoan."Approval Status" in [EmpLoan."Approval Status"::Pending, EmpLoan."Approval Status"::Approved])
               and (IncomingDocument."File Name" <> '') then
                Error('Cannot delete attachment.');
        end else if EmpInsurance.Get(IncomingDocument."No.") then begin
            if (EmpInsurance."Approval Status" in [EmpInsurance."Approval Status"::Approved, EmpInsurance."Approval Status"::Pending]) then
                Error('Cannot delete attachment.');
        end else if AppraisalEmp.Get(IncomingDocument."No.") then begin
            if AppraisalEmp."Approval Status" = AppraisalEmp."Approval Status"::Pending then
                Error('Cannot delete attachment.');
        end else if leave.Get(IncomingDocument."No.") then begin
            if leave."Approval Status" = leave."Approval Status"::Approved then
                Error('Cannot delete attachment.');
        end else if Resign.Get(IncomingDocument."No.") then begin
            if IncomingDocument."Sub Type" = incomingDocument."Sub Type"::"Resign Letter" then
                if Resign."Approval Status" <> Resign."Approval Status"::open then
                    Error('Cannot delete attachment.');
        end else if EmployeeTransfer.get(IncomingDocument."No.") then begin
            if EmployeeTransfer.Type in [EmployeeTransfer.Type::"Employee Transfer", EmployeeTransfer.Type::"HR Transfer"] then begin
                if EmployeeTransfer."Approval Status" = EmployeeTransfer."Approval Status"::Acknowledged then
                    Error('Acknowledge transfer attachment cannot be deleted.')
            end else if (EmployeeTransfer."Approval Status" = EmployeeTransfer."Approval Status"::Approved) then
                    Error('You are not allowed to Delete attachment');
        end;
    end;

    procedure CheckDocumentToUploadAttachment(incomingDocument: Record "Incoming Document")
    var
        EmpLoan: Record "Employee Loan/Advance";
        EmployeeTransfer: Record "Employee Transfer";
        EmpInsurance: Record "Employee Insurance Information";
        AppraisalEmp: Record Appraisal;
        leave: Record leave;
        Resign: Record Resignation;
        IsHandle: Boolean;
    begin
        OnCheckDocumentToUploadAttachment(IsHandle, incomingDocument);
        if IsHandle then
            exit;

        if EmpLoan.Get(IncomingDocument."No.") then begin
            if not (EmpLoan."Approval Status" in [EmpLoan."Approval Status"::Open, EmpLoan."Approval Status"::" "]) then
                ERROR('Approval status must be Open.');
        end else if EmpInsurance.Get(IncomingDocument."No.") then begin
            if EmpInsurance."Approval Status" <> EmpInsurance."Approval Status"::Open then
                ERROR('Approval status must be Open.');
        end else if AppraisalEmp.Get(IncomingDocument."No.") then begin
            if AppraisalEmp."Approval Status" = AppraisalEmp."Approval Status"::Open then
                Error('Attachment already exist.');
        end else if leave.Get(IncomingDocument."No.") then begin
            if leave."Approval Status" <> leave."Approval Status"::Open then
                ERROR('Approval status must be Open.')
        end else if Resign.Get(IncomingDocument."No.") then begin
            if IncomingDocument."Sub Type" = incomingDocument."Sub Type"::"Resign Letter" then
                if Resign."Approval Status" <> Resign."Approval Status"::open then
                    Error('Attachment already exist.')
        end else if EmployeeTransfer.get(IncomingDocument."No.") then begin
            if EmployeeTransfer.Type in [EmployeeTransfer.Type::"Employee Transfer", EmployeeTransfer.Type::"HR Transfer"] then begin
                if not ((EmployeeTransfer."Is Transfer Details Added") and (EmployeeTransfer."Approval Status" = EmployeeTransfer."Approval Status"::Approved)) then
                    Error('You are not allowed to Upload attachment');
            end else if EmployeeTransfer."Approval Status" <> EmployeeTransfer."Approval Status"::Open then
                    ERROR('Approval status must be Open.')
        end;
    end;

    procedure ImportAttachmentToEmpActJnl(EmpActJnl: Record "Employee Activity Journal")
    var
        Extension: Text;
        FileMgt: Codeunit "File Management";
        InStreamPic: InStream;
        FromFileName: Text;
        AttachmentMgt: Codeunit "Attachment Mgt.";
    begin
        if EmpActJnl.Attachment.HasValue() then
            if not Confirm('There is an existing attachment. Do you wish to replace it?') then
                exit;
        if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FromFileName, InStreamPic) then begin
            // check file size
            AttachmentMgt.CheckAttachmentSizeLimit(InStreamPic, Format(EmpActJnl."Employee Act Type"));

            // Check File Extension
            Extension := FileMgt.GetExtension(FromFileName);
            if Extension = '' then
                Error('Invalid file. Please upload jpg, png or pdf files.');

            AttachmentMgt.checkAttachmentExtensionImage(Extension);
            Clear(EmpActJnl.Attachment);
            EmpActJnl.Attachment.ImportStream(InStreamPic, FromFileName);
            EmpActJnl."Attachment File Name" := FromFileName;
            EmpActJnl.Modify(true);
        end;
    end;

    procedure ExportAttachmentFromEmpActJnl(EmpActJnl: Record "Employee Activity Journal")
    var
        InStream: InStream;
        FileManagement: Codeunit "File Management";
        ToFile: Text;
        ItemTenantMedia: Record "Tenant Media";
    begin
        if ItemTenantMedia.Get(EmpActJnl.Attachment.MediaId) then begin
            ToFile := Format(EmpActJnl."Employee No.") + '_' + format(EmpActJnl."Document No") + '.' + FileManagement.GetExtension(ItemTenantMedia.Description);
            ItemTenantMedia.CalcFields(Content);
            ItemTenantMedia.Content.CreateInStream(Instream, TextEncoding::UTF8);
            DownloadFromStream(Instream, '', '', '', ToFile);
        end;
    end;

    procedure CheckMandatoryAttachmentOnType(AttachmentType: enum "Attachment Setup Type"; AttachmentSubType: Enum "Attachment Setup SubType"; DocNo: Text): Boolean
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin
        AttachmentSetup.Reset();
        AttachmentSetup.SetRange(Type, AttachmentType);
        AttachmentSetup.SetRange("Sub Type", AttachmentSubType);
        AttachmentSetup.SetRange(Mandatory, true);
        if AttachmentSetup.Findset() then
            repeat
                IncomingDocument.Reset();
                IncomingDocument.SetRange("No.", DocNo);
                IncomingDocument.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDocument.SetRange("File Name", '');
                if IncomingDocument.FindFirst() then
                    Error('%1 attachment is missing.Please Upload.', AttachmentSetup."Attachment Code");
            until AttachmentSetup.Next() = 0;
        exit(true);
    end;

    procedure CheckMandatoryAttachment(EmpActNo: Code[20])
    var
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("No.", EmpActNo);
        if TempIncomingDoc.Findset then
            repeat
                AttachmentSetup.Reset;
                AttachmentSetup.SetRange("Attachment Code", TempIncomingDoc."Attachment Code");
                if AttachmentSetup.FindFirst then begin
                    if AttachmentSetup.Mandatory then
                        if TempIncomingDoc."File Name" = '' then
                            Error('Attachment must be uploaded');
                end;
            until TempIncomingDoc.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckDocumentToUploadAttachment(var IsHandle: Boolean; incomingDocument: Record "Incoming Document")
    begin
    end;
}