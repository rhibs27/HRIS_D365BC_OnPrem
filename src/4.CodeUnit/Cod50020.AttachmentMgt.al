codeunit 50020 "Attachment Mgt."
{
    var
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        Employee: Record Employee;
        FileMgt: Codeunit "File Management";

    procedure UploadAttachment(IncomingDocument: Record "Incoming Document")
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        Extension: Text;
        DocFoundEmpActivity: Boolean;
        DocFoundEmpLoan: Boolean;
        AppraisalDocFound: Boolean;
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        AppraisalEmp: Record Appraisal;
        EmployeeActivityFolder: Text;
        CleanedFileName: text;
        IncomingDocumentAttachment: Record "Incoming Document Attachment";

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
    begin
        // Define maximum allowed file size 
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
        // File: File;
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
    begin
        if EmpLoan.Get(IncomingDocument."No.") then begin
            if (EmpLoan."Approval Status" in [EmpLoan."Approval Status"::Pending, EmpLoan."Approval Status"::Approved])
               and (IncomingDocument."File Name" <> '') then
                Error('Cannot delete attachment.');
        end else if EmpInsurance.Get(IncomingDocument."No.") then begin
            if EmpInsurance."Approval Status" = EmpInsurance."Approval Status"::Approved then
                Error('Cannot delete attachment.');
        end else if AppraisalEmp.Get(IncomingDocument."No.") then begin //Min
            if AppraisalEmp.Status = AppraisalEmp.Status::"Check Reviewed" then
                Error('Cannot delete attachment.');
        end else if leave.Get(IncomingDocument."No.") then begin //Min
            if leave."Approval Status" = leave."Approval Status"::Approved then
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
    begin
        if EmpLoan.Get(IncomingDocument."No.") then begin
            if (EmpLoan."Approval Status" in [EmpLoan."Approval Status"::Open, EmpLoan."Approval Status"::" "]) then
                ERROR('Approval status must be Open.');
        end else if EmpInsurance.Get(IncomingDocument."No.") then begin
            if EmpInsurance."Approval Status" <> EmpInsurance."Approval Status"::Approved then
                ERROR('Approval status must be Open.');
        end else if AppraisalEmp.Get(IncomingDocument."No.") then begin //Min
            if AppraisalEmp.Status = AppraisalEmp.Status::"Check Reviewed" then
                Error('Attachment already exist.');
        end else if leave.Get(IncomingDocument."No.") then begin //Min
            if leave."Approval Status" <> leave."Approval Status"::Open then
                ERROR('Approval status must be Open.')
        end else if EmployeeTransfer.get(IncomingDocument."No.") then begin
            if EmployeeTransfer.Type in [EmployeeTransfer.Type::"Employee Transfer", EmployeeTransfer.Type::"HR Transfer"] then begin
                if not ((EmployeeTransfer."Is Transfer Details Added") and (EmployeeTransfer."Approval Status" = EmployeeTransfer."Approval Status"::Approved)) then
                    Error('You are not allowed to Upload attachment');
            end else if EmployeeTransfer."Approval Status" <> EmployeeTransfer."Approval Status"::Open then
                    ERROR('Approval status must be Open.')
        end;
    end;
}