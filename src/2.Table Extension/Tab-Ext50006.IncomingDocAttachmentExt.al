tableextension 50006 "Incoming Doc Attachment Ext" extends "Incoming Document Attachment"
{
    fields
    {
        modify("File Extension")
        {
            trigger OnAfterValidate()
            begin
                if "File Extension" in ['jpg', 'jpeg', 'png', 'pdf'] then
                    exit // Valid file extension, do nothing
                else
                    Error('Invalid file extension. Please upload a jpg, jpeg, png or pdf file.');
            end;
        }
    }
    var
        AttachmentMgt: Codeunit "Attachment Mgt.";
        IncomingDocument: Record "Incoming Document";

    procedure NewAttachmentFromEmployeeLoan(EmployeeLoan: Record "Employee Loan/Advance");
    begin
        NewAttachmentFromDocument(
          EmployeeLoan."Incoming Document Entry No.",
          Database::"Employee Loan/Advance",
          Type,
          Format(EmployeeLoan."No."));
    end;

    trigger OnAfterInsert()

    var
        Instream: InStream;
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        CleanedFileName: Text;
    begin
        Content.CreateInStream(InStream, TextEncoding::UTF8);
        IncomingDocument.get("Incoming Document Entry No.");
        if IncomingDocument."Employee Activity Type" = IncomingDocument."Employee Activity Type"::Loan then begin
            EmployeeLoanAdvance.Get(IncomingDocument."No.");
            AttachmentMgt.CheckAttachmentSizeLimit(InStream, format(EmployeeLoanAdvance."Loan Type"))
        end else
            AttachmentMgt.CheckAttachmentSizeLimit(InStream, format(IncomingDocument."Employee Activity Type")); //Check file size limit
        CleanedFileName := AttachmentMgt.SanitizeFileName(FORMAT(IncomingDocument."Entry No.") + '_' + IncomingDocument."No.") + '.' + "File Extension";
        IncomingDocument."File Name" := CleanedFileName;
        IncomingDocument.Modify(true);
    end;
}
