page 50359 "Preview Attachment"
{
    ApplicationArea = All;
    Caption = 'Preview Attachment';
    PageType = Worksheet;
    SourceTable = "Incoming Document";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            usercontrol(MyChartControl; MyControlAddIn)
            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {
    }
    trigger OnOpenPage()
    begin
        returnAttachmentBase64(rec."No.", rec."Entry No.");
        CurrPage.MyChartControl.GetAttachment(LargeText);
    end;

    var
        Base64Text: text;
        loanMgt: Codeunit "Loan Mgt.";
        LargeText: text;

    procedure returnAttachmentBase64(docNo: Code[20]; entryNo: Integer): Text
    var
        IncomingDoc: Record "Incoming Document";
        FilePath: Text;
        FileName: text;
        File: File;
        FileMgt: Codeunit "File Management";
        Base64: Codeunit "Base64 Convert";
        IncomingDocAttachment: Record "Incoming Document Attachment";
        instream: InStream;
    begin
        IncomingDoc.Reset();
        if docNo <> '' then
            IncomingDoc.SetRange("No.", docNo);
        IncomingDoc.SetRange("Entry No.", entryNo);
        IncomingDoc.FindFirst();
        FilePath := IncomingDoc."File Name"; // Ensure this stores the server file path
        if FilePath = '' then
            Error('File path not specified for this document.');
        // Open the file and read it into an InStream
        File.OPEN(FilePath);
        File.CREATEINSTREAM(InStream);
        FileName := FileMgt.GetFileName(FilePath);
        LargeText := Base64.ToBase64(instream, false);
    end;
}
