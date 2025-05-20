codeunit 50020 "Attachment Mgt."
{
    var
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        Employee: Record Employee;
        FileMgt: Codeunit "File Management";

    // procedure UploadFileToServer(var IncomingDocument: Record "Incoming Document")
    // var
    //     ClientFileName: Text;
    //     FileName: Text;
    //     Extention: Text;
    //     IncomingDocumentAttachment: Record "Incoming Document Attachment";
    //     DirectoryName: Text;
    //     DocFoundEmpActivity: Boolean;
    //     DocFoundEmpLoan: Boolean;
    //     EmployeeLoanAdvance: Record "Employee Loan/Advance";
    //     EmployeeActivity: Record "Employee Activity";
    //     LoanType: Option " ","Salary Advance","Personal Loan","Home Loan","Vehicle Loan";
    //     ActivityType: Option " ","Leave Request","Travel Request","Travel Claim",Transfer,Overtime,"Out of Office","Bulk Cash",Resignation,"Medical Insurance Claim",Promotion,"Attendance Missed","Access Control","Changes in employee";
    //     DocFoundInsurance: Boolean;
    //     EmpInsurance: Record "Employee Insurance Information";
    //     AppraisalDocFound: Boolean;
    //     AppraisalEmp: Record Appraisal;
    //     instream: InStream;
    //     Outstream: OutStream;
    //     FullFileName: text;
    //     File: File;
    //     bool: Boolean;
    //     txt: Text;
    //     TempBlob: Codeunit "Temp Blob";
    // begin
    //     IncomingDocument.TestField("Entry No.");
    //     HRSetup.Get;
    //     HRSetup.TestField("Attachment Storage Location");
    //     DocFoundEmpActivity := false;
    //     DocFoundEmpLoan := false;
    //     AppraisalDocFound := false; //Min
    //     ClientFileName := HRSetup."Attachment Storage Location" + 'temp\';
    //     Employee.reset;
    //     Employee.Get(HRMgt.GetEmployeeNo);
    //     // if not Employee.Screener then begin
    //     if EmployeeLoanAdvance.Get(IncomingDocument."No.") then begin
    //         DocFoundEmpLoan := true;
    //         LoanType := EmployeeLoanAdvance."Loan Type";
    //         if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Pending, EmployeeLoanAdvance."Approval Status"::Approved])
    //            and (IncomingDocument."File Name" <> '') then
    //             Error('Attachment already exist.');
    //     end;

    //     // if not DocFoundEmpLoan then begin
    //     //     if EmployeeActivity.Get(IncomingDocument."No.") then begin
    //     //         DocFoundEmpActivity := true;
    //     //         ActivityType := EmployeeActivity.Type;
    //     //         if (EmployeeActivity."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Screened, EmployeeActivity."Approval Status"::Approved])
    //     //          and (IncomingDocument."File Name" <> '') then
    //     //             Error('Attachment already exist.');
    //     //     end;
    //     // end; commented by santosh

    //     if not (DocFoundEmpActivity or DocFoundEmpLoan) then begin
    //         if EmpInsurance.Get(IncomingDocument."No.") then begin
    //             DocFoundInsurance := true;
    //             if EmpInsurance.Status = EmpInsurance.Status::Screened then
    //                 Error('Cannot upload in screened insurance.');
    //             if IncomingDocument."File Name" <> '' then
    //                 Error('Attachment already exist.');
    //         end;
    //     end;
    //     if not AppraisalDocFound then begin //Min
    //         if AppraisalEmp.Get(IncomingDocument."No.") then begin
    //             AppraisalDocFound := true;
    //             if (AppraisalEmp.Status = AppraisalEmp.Status::"Check Reviewed")
    //              and (IncomingDocument."File Name" <> '') then
    //                 Error('Attachment already exist.');
    //         end;
    //     end;
    //     // end;
    //     if IncomingDocument."File Name" <> '' then
    //         Error('File already exist.Please remove the file first.');
    //     if IncomingDocument.Type = IncomingDocument.Type::Sample then
    //         CreateNewDir(HRSetup."Attachment Storage Location", 'Sample Document', DirectoryName)
    //     else begin
    //         CreateNewDir(HRSetup."Attachment Storage Location", IncomingDocument."Employee Code", DirectoryName);
    //         DirectoryName += '\';
    //         if DocFoundEmpLoan then
    //             CreateNewDir(DirectoryName, Format(LoanType), DirectoryName)
    //         else if DocFoundEmpActivity then
    //             CreateNewDir(DirectoryName, Format(ActivityType), DirectoryName)
    //         else if DocFoundInsurance then
    //             CreateNewDir(DirectoryName, 'Insurance', DirectoryName)
    //         else if AppraisalDocFound then  //Min
    //             CreateNewDir(DirectoryName, 'Appraisal', DirectoryName)
    //     end;
    //     ClientFileName := FileMgt.GetDirectoryName(DirectoryName) + '\' + Format(IncomingDocument."Entry No.") + '_' + IncomingDocument."No." + '.' + Extention;
    //     //File.Upload('', '', '', '', ClientFileName);
    //     //DirectoryName += '\';
    //     //instream.Read(DirectoryName);
    //     IncomingDocument.ImportAttachment(IncomingDocument);
    //     IncomingDocumentAttachment.Reset();
    //     IncomingDocumentAttachment.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
    //     IncomingDocumentAttachment.FindFirst();

    //     // if UploadIntoStream('Select file', '', '', txt, instream) then begin
    //     //Extention := FileMgt.GetExtension(DirectoryName);
    //     //     if Extention = '' then
    //     //         Error('Invalid file.');


    //     ClientFileName := FileMgt.GetDirectoryName(DirectoryName) + '\' + Format(IncomingDocument."Entry No.") + '_' + IncomingDocument."No." + '.' + Extention;
    //     // Rename(DirectoryName, ClientFileName);
    //     DirectoryName := ClientFileName;
    //     FileName := ClientFileName;
    //     IncomingDocument."File Name" := FileName + IncomingDocumentAttachment."File Extension";
    //     IncomingDocument.Modify;

    //     Message('Uploaded.');
    //     IncomingDocumentAttachment.CalcFields(Content);
    //     IncomingDocumentAttachment.Content.CreateInStream(instream, TextEncoding::UTF8);
    //     TempBlob.CreateInStream(instream);
    //     // "Document Reference ID".EXPORTSTREAM(DocumentStream);
    //     FileMgt.BLOBExport(TempBlob, FullFileName, false);



    //     // TempBlob.CREATEOUTSTREAM(DocumentStream);
    //     // "Document Reference ID".EXPORTSTREAM(DocumentStream);
    //     // EXIT(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    //     // SaveAttachment2(FromRecRef, FileName, TempBlob, TRUE, Recs."No.");
    //     // CurrPage.UPDATE(FALSE);

    // end;
    // end;
    procedure UploadAttachment(IncomingDocument: Record "Incoming Document")
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        FileName: Text;
        Extension: Text;
        ServerFilePath: Text;
        TargetDirectory: Text;
        File: file;
        DocFoundEmpActivity: Boolean;
        DocFoundEmpLoan: Boolean;
        AppraisalDocFound: Boolean;
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        AppraisalEmp: Record Appraisal;
        EmployeeActivityFolder: Text;
        CleanedFileName: text;
        ServerFolderPath: text;

    begin
        // Validate Incoming Document
        IncomingDocument.TestField("Entry No.");
        HRSetup.Get;
        HRSetup.TestField("Attachment Storage Location");
        DocFoundEmpActivity := false;
        DocFoundEmpLoan := false;
        AppraisalDocFound := false;
        //Employee.Get(HRMgt.GetEmployeeNo);
        // if not Employee.Screener then begin
        if EmployeeLoanAdvance.Get(IncomingDocument."No.") then begin
            DocFoundEmpLoan := true;
            //LoanType := EmployeeLoanAdvance."Loan Type";
            if (EmployeeLoanAdvance."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Pending, EmployeeLoanAdvance."Approval Status"::Approved])
               and (IncomingDocument."File Name" <> '') then
                Error('Attachment already exist.');
        end;

        // if not DocFoundEmpLoan then begin
        //     if EmployeeActivity.Get(IncomingDocument."No.") then begin
        //         DocFoundEmpActivity := true;
        //         ActivityType := EmployeeActivity.Type;
        //         if (EmployeeActivity."Approval Status" in [EmployeeLoanAdvance."Approval Status"::Screened, EmployeeActivity."Approval Status"::Approved])
        //          and (IncomingDocument."File Name" <> '') then
        //             Error('Attachment already exist.');
        //     end;
        // end;

        // if not (DocFoundEmpActivity or DocFoundEmpLoan) then begin
        //     if EmpInsurance.Get(IncomingDocument."No.") then begin
        //         DocFoundInsurance := true;
        //         if EmpInsurance.Status = EmpInsurance.Status::Screened then
        //             Error('Cannot upload in screened insurance.');
        //         if IncomingDocument."File Name" <> '' then
        //             Error('Attachment already exist.');
        //     end;
        // end;
        if not AppraisalDocFound then begin //Min
            if AppraisalEmp.Get(IncomingDocument."No.") then begin
                AppraisalDocFound := true;
                if (AppraisalEmp.Status = AppraisalEmp.Status::"Check Reviewed")
                 and (IncomingDocument."File Name" <> '') then
                    Error('Attachment already exist.');
            end;
        end;
        // case IncomingDocument."Employee Activity Type" of
        //     IncomingDocument."Employee Activity Type"::"Employee Transfer", IncomingDocument."Employee Activity Type"::"HR Transfer":
        //         EmployeeActivityFolder := 'Transfer';
        //     else
        // // Error('Invalid activity type: %1', EmployeeActivityFolder);
        // end;


        // Prompt the user to select a file and upload into TempBlob
        if UploadIntoStream('Select a file to upload', '', '', FileName, InStream) then begin
            CheckAttachmentSizeLimit(InStream, IncomingDocument."Table ID"); //Check file size limit
            // Check File Extension
            Extension := FileMgt.GetExtension(FileName);
            if Extension = '' then
                Error('Invalid file. Please upload jpg, png or pdf files.');
            checkAttachmentExtension(Extension);
            // Define the server directory (ensure it is configured in your setup)
            TargetDirectory := HRSetup."Attachment Storage Location";
            ServerFolderPath := TargetDirectory + EmployeeActivityFolder;
            if TargetDirectory = '' then
                Error('Attachment Storage Location is not configured.');

            if not TargetDirectory.EndsWith('\') then
                TargetDirectory := TargetDirectory + '\';

            CleanedFileName := SanitizeFileName(FORMAT(IncomingDocument."Entry No.") + '_' + IncomingDocument."No.");

            // Construct server file path with unique name
            ServerFilePath := TargetDirectory + CleanedFileName + '.' + Extension;

            // Save the uploaded content to the server file path
            // TempBlob.CreateOutStream(OutStream);

            // CopyStream(OutStream, InStream);
            // TempBlob.ToFile(ServerFilePath); // Write the content directly to the server location
            // Write TempBlob content to server file location
            // TempBlob.CreateInStream(InStream); // Get the data back from TempBlob

            File.CREATE(ServerFilePath);       // Create the file on the server
            File.CREATEOUTSTREAM(OutStream);  // Prepare to write to the file
            CopyStream(OutStream, InStream);  // Write the data
            File.CLOSE;                       // Close the file
            // Update the Incoming Document record with the file path
            IncomingDocument."File Name" := ServerFilePath;
            IncomingDocument.MODIFY(TRUE);
            Message('File uploaded successfully to server location: %1', ServerFilePath);
        end else
            Error('File upload canceled.');
    end;

    procedure CheckAttachmentSizeLimit(InStream: InStream; TableID: Integer);
    var
        FileSize: Integer;
        AttachmentSetup: Record "Attachment Setup";
        MaxFileSize: Integer;
    begin
        // Define maximum allowed file size 
        AttachmentSetup.Reset();
        // if TableID = 0 then
        //     AttachmentSetup.SetRange(Type, AttachmentSetupType)
        // else
        AttachmentSetup.SetRange("Table ID", TableID);
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

    procedure checkAttachmentExtension(Ext: text)
    begin
        case LowerCase(ext) of
            'jpg', 'jpeg', 'png', 'pdf':
                begin
                end;
            else
                Error('Invalid file extension. Please upload a jpg, jpeg, png or pdf file.');
        end;
    end;

    procedure DownloadAttachment(IncomingDocument: Record "Incoming Document")
    var
        File: File;
        InStream: InStream;
        FilePath: Text;
        FileName: Text;
    begin
        // Construct the file path on the server
        FilePath := IncomingDocument."File Name"; // Ensure this stores the server file path
        if FilePath = '' then
            Error('File path not specified for this document.');

        // Validate that the file exists
        // if not File.Exists(FilePath) then
        //     Error('The file does not exist on the server: %1', FilePath);

        // Open the file and read it into an InStream
        File.OPEN(FilePath);
        File.CREATEINSTREAM(InStream);

        // Extract the file name (e.g., "51.jpg" from "D:\HRFiles\51.jpg")
        FileName := FileMgt.GetFileName(FilePath);

        // Prompt the user to save the file on their client computer
        DownloadFromStream(InStream, '', '', '', FileName);

        // Close the file
        File.CLOSE;

        Message('File downloaded successfully: %1', FileName);
    end;


    // procedure DownloadFileFromServer(var IncomingDocument: Record "Incoming Document")
    // var
    //     TestFile: File;
    //     TempFileName: Text;
    //     EmpLoan: Record "Employee Loan/Advance";
    //     // FileSystem: Automation;
    //     Foldername: Text;
    //     instream: InStream;
    //     IncomingDocumentAttachment: Record "Incoming Document Attachment";
    //     Extension: text;
    // // WindowsShell: Automation;
    // // SelectedFolder: Automation;
    // // FolderItem: Automation;
    // begin
    //     if IncomingDocument."File Name" <> '' then begin

    //         //FileMgt.DownloadToFile(IncomingDocument."File Name", IncomingDocument."File Name");
    //         //FileMgt.DownloadTempFile(IncomingDocument."File Name");
    //         //FileMgt.MoveFile
    //         //TempFileName := IncomingDocument."File Name";
    //         //instream.Read(IncomingDocument."File Name");
    //         IncomingDocumentAttachment.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
    //         IncomingDocumentAttachment.FindFirst();
    //         IncomingDocumentAttachment.CalcFields(Content);
    //         IncomingDocumentAttachment.Content.CreateInStream(InStream);
    //         Extension := IncomingDocumentAttachment."File Extension";
    //         //Download(IncomingDocument."File Name", 'Save To', '', '', TempFileName);
    //         TempFileName := IncomingDocument."File Name" + Extension;
    //         DownloadFromStream(instream, 'Save To', '', '', TempFileName);

    //     end;
    // end;

    procedure DeleteAttachment(var IncomingDocument: Record "Incoming Document")
    var
        TestFile: File;
        EmpLoan: Record "Employee Loan/Advance";
        EmpAct: Record "Employee Activity";
        EmpInsurance: Record "Employee Insurance Information";
        AppraisalEmp: Record Appraisal;
        fileMgt: Codeunit "File Management";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        FilePath: text;
        leave: Record leave;
    begin
        //Employee.Get(HRMgt.GetEmployeeNo);
        Employee.Get(IncomingDocument."Employee Code");
        // if not Employee.Screener then begin
        if EmpLoan.Get(IncomingDocument."No.") then begin
            EmpLoan.TestField("Approval Status", EmpLoan."Approval Status"::Open);
            if (EmpLoan."Approval Status" in [EmpLoan."Approval Status"::Pending, EmpLoan."Approval Status"::Approved])
               and (IncomingDocument."File Name" <> '') then
                Error('Cannot delete attachment.');
        end else if EmpAct.Get(IncomingDocument."No.") then begin
            if (EmpAct."Approval Status" in [EmpAct."Approval Status"::Screened, EmpAct."Approval Status"::Approved])
               and (IncomingDocument."File Name" <> '') then
                Error('Cannot delete attachment..');
        end else if EmpInsurance.Get(IncomingDocument."No.") then begin
            if EmpInsurance."Approval Status" = EmpInsurance."Approval Status"::Approved then
                Error('Cannot delete attachment.');
        end else if AppraisalEmp.Get(IncomingDocument."No.") then begin //Min
            if AppraisalEmp.Status = AppraisalEmp.Status::"Check Reviewed" then
                Error('Cannot delete attachment.');
        end else if leave.Get(IncomingDocument."No.") then begin //Min
            if leave."Approval Status" = leave."Approval Status"::Approved then
                Error('Cannot delete attachment.');
        end;
        // end;

        FilePath := IncomingDocument."File Name"; // Ensure this field stores the full file path
        // if FilePath = '' then
        //     Error('File path not specified for this document.');

        // Delete the file from the server
        fileMgt.DeleteServerFile(FilePath);

        // Clear the file name in the Incoming Document record
        IncomingDocument."File Name" := '';
        IncomingDocument.MODIFY;

        Message('File successfully deleted from the server: %1', FilePath);

        // if Employee.Get(IncomingDocument."Order No.") then;

        // if IncomingDocument."File Name" <> '' then begin
        //     // if Erase(IncomingDocument."File Name") then begin
        //     IncomingDocument."File Name" := '';
        //     IncomingDocument.Modify;
        //     if GuiAllowed then
        //         Message('Attachment Removed.');
        //     // end;
        //     IncomingDocumentAttachment.Reset();
        //     IncomingDocumentAttachment.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
        //     IncomingDocumentAttachment.Findset();
        //     IncomingDocumentAttachment.DeleteAll();
        // end;
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

    procedure CreateNewDir(OldPathFile: Text; NewDirectoryName: Text; var AttrDir: Text)
    var
    // DirectoryHelper: DotNet Directory;
    // Directory: Text;
    // FileMgt: Codeunit "File Management";
    // PathHelper: DotNet Path;
    // SystemDirectoryServer: DotNet Directory;
    begin
        // Directory := FileMgt.GetDirectoryName(OldPathFile);
        // NewDirectoryName := DelChr(NewDirectoryName, '=', '#%&*:<>?\/{|}~');
        // if NewDirectoryName <> '' then begin
        //     Directory := PathHelper.Combine(Directory, NewDirectoryName);
        //     if not SystemDirectoryServer.Exists(Directory) then
        //         DirectoryHelper.CreateDirectory(Directory);
        // end;
        // AttrDir := Directory;
    end;

    procedure UploadDeclaration(TypofDoc: Text; base64text: Text; ext: Text): Text
    var
        ClientFileName: Text;
        FileName: Text;
        DirectoryName: Text;
        TempBlob: Codeunit "Temp Blob";
        base64: Codeunit "Base64 Convert";
        instream: InStream;
    begin
        HRSetup.Get;
        HRSetup.TestField("Attachment Storage Location");

        ClientFileName := HRSetup."Attachment Storage Location";
        Employee.Get(HRMgt.GetEmployeeNo);

        CreateNewDir(HRSetup."Attachment Storage Location", Employee."No." + '\EmployeeDeclaration', DirectoryName);
        DirectoryName += '\';

        if ext = '' then
            Error('Invalid file.');

        ClientFileName := FileMgt.GetDirectoryName(DirectoryName) + '\' + TypofDoc + '.' + ext;
        // if SystemDirectoryServer.Exists(ClientFileName) then
        //     Clear(ClientFileName);
        base64.FromBase64(base64text);
        instream.Read(base64);
        TempBlob.CreateInStream(instream);
        FileMgt.BLOBExport(TempBlob, ClientFileName, false);
        FileName := ClientFileName;
        exit(FileName);
    end;

    procedure UploadAppraisal(TypofDoc: Text; base64text: Text; ext: Text): Text
    var
        ClientFileName: Text;
        FileName: Text;
        DirectoryName: Text;
        TempBlob: Codeunit "Temp Blob";
        base64: Codeunit "Base64 Convert";
        instream: InStream;
        outStream: OutStream;
    // TempBlob: Record TempBlob;
    // SystemDirectoryServer: DotNet Directory;
    begin
        HRSetup.Get;
        HRSetup.TestField("Attachment Storage Location");

        ClientFileName := HRSetup."Attachment Storage Location";
        Employee.Get(HRMgt.GetEmployeeNo);

        CreateNewDir(HRSetup."Attachment Storage Location", Employee."No." + '\EmployeeAppraisal', DirectoryName);
        DirectoryName += '\';

        if ext = '' then
            Error('Invalid file.');

        //ClientFileName := ClientFileName + '\' + TypofDoc + '.' + ext;
        FileName := ClientFileName + TypofDoc + '.' + ext;
        tempblob.CreateOutStream(outStream);
        //base64.FromBase64(base64text);
        base64.FromBase64(base64text, Outstream);
        // instream.Read(base64);
        //FileMgt.BLOBExport(TempBlob, ClientFileName, false);
        FileMgt.BLOBExportToServerFile(TempBlob, ClientFileName);
        // FileName := ClientFileName;
        exit(FileName);

        //TempBlob.FromBase64String(base64text);
        // FileMgt.BLOBExportToServerFile(TempBlob, ClientFileName);
        // FileName := ClientFileName;
        // exit(FileName);
    end;

    procedure uploadAttachment(Var IncomingDoc: Record "Incoming Document"; fname: Text; ext: Text): Text
    var
        // IncomingDoc: Record "Incoming Document";
        TempBlob: Codeunit "Temp Blob";
        DocFoundEmpActivity: Boolean;
        DocFoundEmpLoan: Boolean;
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        Leave: record leave;
        DocFoundEmpLeave: Boolean;
        //EmployeeActivity: Record "Employee Activity";
        //LoanType: Option " ","Salary Advance","Personal Loan","Home Loan","Vehicle Loan";
        LoanType: Enum "Loan Type";
        //ActivityType: Option " ","Leave Request","Travel Request","Travel Claim",Transfer,Overtime,"Out of Office","Bulk Cash",Resignation,"Medical Insurance Claim",Promotion,"Attendance Missed","Access Control","Changes in employee";
        ActivityType: Enum "Employee Activity Type";
        DocFoundInsurance: Boolean;
        EmpInsurance: Record "Employee Insurance Information";
        AppraisalDocFound: Boolean;
        AppraisalEmp: Record Appraisal;
        base64: Codeunit "Base64 Convert";
        Outstream: OutStream;
        instream: InStream;
        TargetDirectory: Text;
        ServerFilePath: text;
        ServerFolderPath: text;
        File: File;
        CleanedFileName: text;
        AttachmentMgt: Codeunit "Attachment Mgt.";
    begin
        // IncomingDoc.Get(entryNo);
        IncomingDoc."No." := IncomingDoc.GetFilter("No.");
        HRSetup.Get;
        DocFoundEmpActivity := false;
        DocFoundEmpLoan := false;
        AppraisalDocFound := false;
        DocFoundEmpLeave := false; //Min
        if IncomingDoc."File Name" <> '' then
            Error('File already exist. Please remove the file first.');


        TargetDirectory := HRSetup."Attachment Storage Location";

        if TargetDirectory = '' then
            Error('Attachment Storage Location is not configured.');

        if not TargetDirectory.EndsWith('\') then
            TargetDirectory := TargetDirectory + '\';

        CleanedFileName := AttachmentMgt.SanitizeFileName(FORMAT(IncomingDoc."Entry No.") + '_' + IncomingDoc."No.");

        // Construct server file path with unique name
        ServerFilePath := TargetDirectory + CleanedFileName + '.' + ext;
        // Construct server file path with unique name
        tempblob.CreateOutStream(outStream);
        base64.FromBase64(fname, Outstream);
        TempBlob.CreateInStream(InStream); // Get the data back from TempBlob
        File.CREATE(ServerFilePath);       // Create the file on the server
        File.CREATEOUTSTREAM(OutStream);  // Prepare to write to the file
        CopyStream(OutStream, InStream);  // Write the data
        File.CLOSE;
        IncomingDoc."File Name" := ServerFilePath;
        IncomingDoc.MODIFY;
    end;

}