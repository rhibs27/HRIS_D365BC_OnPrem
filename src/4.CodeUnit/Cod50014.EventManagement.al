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
        // AttachmentMgt.checkAttachmentExtension(FileMgt.GetExtension(FileName));
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

    [EventSubscriber(ObjectType::Page, Page::"Base Calendar Entries Subform", OnUpdateBaseCalendarChanges, '', false, false)]
    local procedure "Base Calendar Entries Subform_OnUpdateBaseCalendarChanges"(var BaseCalendarChange: Record "Base Calendar Change"; var CustCalendarChange: Record "Customized Calendar Change")
    begin
        BaseCalendarChange."Province Filter" := CustCalendarChange.Provinces;
        BaseCalendarChange."Gender Filter" := CustCalendarChange.Gender;
        BaseCalendarChange."Inside/Outside Valley" := CustCalendarChange.InOutValley;
        BaseCalendarChange."Posting Region" := CustCalendarChange.PostingRegion;
        BaseCalendarChange."Branch Code" := CustCalendarChange.Branch;
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

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", OnAfterLogin, '', false, false)]
    // local procedure "System Initialization_OnAfterLogin"()
    // var
    //     ActiveSession: Record "Active Session";
    // begin
    //     ActiveSession.SetRange("User ID", UserId);
    //     ActiveSession.Setfilter("Session ID", '<>%1', SessionId());
    //     if ActiveSession.FindSet() then
    //         repeat
    //             StopSession(ActiveSession."Session ID");
    //         until ActiveSession.Next() = 0;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', true, true)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; var CardPageID: Integer)
    var
        ActType: Enum "Employee Activity Type";
        TravelRequest: Record "Travel Request";
        EmployeeTransfer: Record "Employee Transfer";
        CancelDoc: Record "Cancel Document";
        LoanType: Enum "Loan Type";
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        EmpActJournal: Record "Employee Activity Journal";
    begin
        case RecordRef.Number of
            Database::Leave:
                CardPageID := Page::"Posted Leave Card";
            Database::"Payroll Header":
                CardPageID := Page::"Payroll Plan";
            Database::"Employee Edit":
                CardPageID := Page::"Employee Edit Card";
            Database::"Travel Request":
                begin
                    ActType := RecordRef.Field(TravelRequest.FieldNo(Type)).Value;
                    if ActType = ActType::"Travel Request" then
                        CardPageID := Page::"Travel Request Form"
                    else if ActType = ActType::"Travel Claim" then
                        CardPageID := Page::"Travel Claim"
                end;

            Database::"Employee Transfer":
                begin
                    ActType := RecordRef.Field(EmployeeTransfer.FieldNo(Type)).Value;
                    if ActType = ActType::"Employee Transfer" then
                        CardPageID := Page::"Transfer Card"
                    else if ActType = ActType::"Transfer Claim" then
                        CardPageID := Page::"Transfer Claim Form"
                end;
            Database::OverTime:
                CardPageID := Page::"Overtime Card";
            Database::"Allowance Assignment Header":
                CardPageID := Page::"Allowance Assignment Card";
            Database::"Retirement Fund":
                CardPageID := Page::"Retirement Fund Card";
            Database::"Cancel Document":
                begin
                    ActType := RecordRef.Field(CancelDoc.FieldNo(Type)).Value;
                    case ActType of
                        ActType::"Leave Request":
                            CardPageID := Page::"Leave Request";
                        ActType::"Attendance Missed":
                            CardPageID := Page::"Attendance missed Card";
                    end;
                end;
            Database::"Employee Loan/Advance":
                begin
                    LoanType := RecordRef.Field(EmployeeLoanAdvance.FieldNo("Loan Type")).Value;
                    case LoanType of
                        LoanType::"Salary Advance":
                            CardPageID := Page::"Employee Salary Advance Card";
                        LoanType::"Home Loan":
                            CardPageID := Page::"Employee Home Loan Card";
                        LoanType::"Personal Loan":
                            CardPageID := Page::"Employee Personal Loan Card";
                        LoanType::"Vehicle Loan":
                            CardPageID := Page::"Employee Vehicle Loan Card";

                    end;
                end;
            Database::"Employee Activity Journal":
                begin
                    ActType := RecordRef.Field(EmpActJournal.FieldNo("Employee act type")).Value;
                    case ActType of
                        ActType::"Attendance Missed":
                            CardPageID := Page::"Attendance Journal";
                        ActType::"Leave Request":
                            CardPageID := Page::"Leave Journal";
                        ActType::"HR Transfer":
                            CardPageID := Page::"Transfer Journal";
                    end;
                end;
            Database::"Attendance Missed":
                CardPageID := Page::"Attendance missed Card";
        end;
    end;

}
