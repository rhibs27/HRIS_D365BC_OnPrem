tableextension 50006 "Incoming Doc Attachment Ext" extends "Incoming Document Attachment"
{
    procedure NewAttachmentFromEmployeeLoan(EmployeeLoan: Record "Employee Loan/Advance");
    begin
        NewAttachmentFromDocument(
          EmployeeLoan."Incoming Document Entry No.",
          Database::"Employee Loan/Advance",
          Type,
          Format(EmployeeLoan."No."));
    end;
}
