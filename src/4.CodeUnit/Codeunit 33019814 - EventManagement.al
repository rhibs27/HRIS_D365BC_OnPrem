codeunit 33019814 "Event Management"
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

    // [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeSaveAttachment', '', false, false)]
    // local procedure OnBeforeSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var FileName: Text; var RecRef: RecordRef; var TempBlob: Codeunit "Temp Blob")
    // var
    // begin

    //     //   Pradhan Modification for NIC Asisa
    //     //     Field added No. 50000, 50001 and 50002 (1st Dec 2019)
    //     //     clearing the related field on validation (1st Dec 2019)
    // end;

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

    //     EmployeeLedgerEntry."Fiscal Year" := GenJournalLine."Fiscal Year";

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
}
