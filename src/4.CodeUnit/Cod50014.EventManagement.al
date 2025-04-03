codeunit 50014 "Event Management"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        GLEntry."Fiscal Year" := GenJournalLine."Fiscal Year";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnTestIfAlreadyExists', '', false, false)]
    local procedure OnTestIfAlreadyExists(EntryNo: Integer; IncomingRelatedDocumentType: Enum "Incoming Related Document Type")
    var
        EmployeeLoan: Record "Employee Loan/Advance";
        AlreadyUsedInDocHdrErr: Label 'The incoming document has already been assigned to %1 %2 (%3).';
    begin
        //pram
        if IncomingRelatedDocumentType = IncomingRelatedDocumentType::"Employee Loan" then begin
            EmployeeLoan.SetRange("Incoming Document Entry No.", EntryNo);
            if EmployeeLoan.FindFirst() then
                Error(AlreadyUsedInDocHdrErr, EmployeeLoan."Loan Type", EmployeeLoan."No.", EmployeeLoan.TableCaption);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reversal-Post", 'OnRunOnAfterConfirm', '', false, false)]
    local procedure OnRunOnAfterConfirm(HideDialog: Boolean; PrintRegister: Boolean; var Handled: Boolean; var ReversalEntry: Record "Reversal Entry")
    begin
        // todo

        // IF ReversalEntry.IsPayrollEntry THEN
        //     PayrollReversalPost.RUN(TempReversalEntry) //NICASIA
        // ELSE
        //     ReversalPost.RUN(TempReversalEntry);
        // Handled := true;
    end;
    // Attachment fileSize  and type Limit While Upload << Santosh << 4-2-205
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeSaveAttachment', '', false, false)]
    local procedure OnBeforeSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var FileName: Text; var RecRef: RecordRef; var TempBlob: Codeunit "Temp Blob")
    var
        AttachmentMgt: Codeunit "Attachment Mgt.";
        AttachmentSetup: Record "Attachment Setup";
        MaxFileSize: Integer;
        FileSize: Decimal;
        FileMgt: Codeunit "File Management";
    begin
        // Define maximum allowed file size 
        AttachmentMgt.checkAttachmentExtension(FileMgt.GetExtension(FileName));
        AttachmentSetup.Reset();
        AttachmentSetup.SetRange("Attachment Code", DocumentAttachment."Attachment Document Type");
        if AttachmentSetup.FindFirst() then
            MaxFileSize := AttachmentSetup."Max File Size" * 1024 * 1024;
        if MaxFileSize = 0 then
            MaxFileSize := 2 * 1024 * 1024;
        // Get the file size in bytes
        FileSize := TempBlob.Length;
        // Check if the file size exceeds the maximum limit
        if FileSize > MaxFileSize then
            Error('The file is %1 MB. Maximum allowed size is %2 MB.', round(FileSize / 1024 / 1024, 0.01, '='), round(MaxFileSize / 1024 / 1024, 1, '='));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Employee Ledger Entry", 'OnAfterCopyEmployeeLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyEmployeeLedgerEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var EmployeeLedgerEntry: Record "Employee Ledger Entry")
    var
    begin

        EmployeeLedgerEntry."Fiscal Year" := GenJournalLine."Fiscal Year";
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Service Item Line", 'OnBeforeCalculateResponseDateTime', '', false, false)]
    // local procedure OnBeforeCalculateResponseDateTime(GenJournalLine: Record "Gen. Journal Line"; var EmployeeLedgerEntry: Record "Employee Ledger Entry")
    // var
    // begin

    //EmployeeLedgerEntry."Fiscal Year" := GenJournalLine."Fiscal Year";

    // end;

    [EventSubscriber(ObjectType::Page, Page::"Base Calendar Entries Subform", OnUpdateBaseCalendarChanges, '', false, false)]
    local procedure "Base Calendar Entries Subform_OnUpdateBaseCalendarChanges"(var BaseCalendarChange: Record "Base Calendar Change"; var CustCalendarChange: Record "Customized Calendar Change")
    begin
        BaseCalendarChange."Province Filter" := CustCalendarChange.Provinces;
        BaseCalendarChange."Gender Filter" := CustCalendarChange.Gender;
        BaseCalendarChange."Inside/Outisde Valley" := CustCalendarChange.InOutValley;
        BaseCalendarChange."Posting Region" := CustCalendarChange.PostingRegion;
        BaseCalendarChange."Shortcut Dimension 1 Code" := CustCalendarChange.Branch;
    end;
    //Add by santosh for Caption in payroll line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Caption Class", 'OnResolveCaptionClass', '', true, true)]
    local procedure MyOnResolveCaptionClass(CaptionArea: Text; CaptionExpr: Text; Language: Integer; var Caption: Text; var Resolved: Boolean)
    var
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        if CaptionArea = '8' then begin
            Caption := PayrollEngine.PayrollCaptionClassTranslate(CaptionExpr);
            Resolved := true;
        end;
    end;
}
