tableextension 50005 "Incoming Document Ext" extends "Incoming Document"
{
    fields
    {
        field(50000; "No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Table ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "File Name"; Text[250])
        { DataClassification = CustomerContent; }
        field(50003; "Attachment Code"; Code[20])
        {
            TableRelation = "Attachment Master".Code;
            DataClassification = CustomerContent;
        }
        field(50004; "Employee Code"; Code[20])
        { DataClassification = CustomerContent; }
        field(50005; "Sub Type"; Enum "Attachment Setup SubType")
        {
            DataClassification = CustomerContent;
        }
        field(50006; "Leave Type Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";
            DataClassification = CustomerContent;
        }
        field(50007; "Employee Activity Type"; Enum "Employee Activity Type")
        {
            DataClassification = CustomerContent;
        }
        field(50008; "Transfer Claim Attributes"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code where("Activity Type" = filter("Employee Activity Type"::"Transfer Claim"));
        }
    }
    trigger OnDelete()
    begin
        if "File Name" <> '' then
            Clear("File Name");
    end;

    procedure SetEmployeeLoan(var EmployeeLoan: Record "Employee Loan/Advance");
    begin
        if EmployeeLoan."Incoming Document Entry No." = 0 then
            exit;
        Get(EmployeeLoan."Incoming Document Entry No.");
        TestReadyForProcessing();
        TestIfAlreadyExists();
        "Document Type" := "Document Type"::"Employee Loan";
        Modify(true);
        if not DocLinkExists(EmployeeLoan) then
            EmployeeLoan.AddLink(GetURL(), Description);
    end;

    procedure GetEntryNo(): Integer;
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument.Reset();
        IncomingDocument.SetCurrentKey("Entry No.");
        if IncomingDocument.FindLast() then;
        exit(IncomingDocument."Entry No." + 1);
    end;
}
