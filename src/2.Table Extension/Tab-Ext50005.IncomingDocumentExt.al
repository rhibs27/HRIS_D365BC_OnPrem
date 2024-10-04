tableextension 50005 "Incoming Document Ext" extends "Incoming Document"
{
    fields
    {
        field(50000; "No."; Code[20])
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
            trigger OnValidate()
            begin
                CheckSampleAttachment;
            end;
        }
        field(50004; "Employee Code"; Code[20])
        { DataClassification = CustomerContent; }
        field(50005; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Sample;
            OptionCaption = ' ,Sample';
            trigger OnValidate()
            begin
                CheckSampleAttachment;
            end;
        }
        field(50006; "Leave Type Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";
            DataClassification = CustomerContent;
        }
        field(50007; "Employee Activity Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Leave Request","Travel Request","Travel Claim",Transfer,Overtime,"Out of Office","Bulk Cash",Resignation,"Medical Insurance Claim",Promotion,"Attendance Missed","Access Control","Changes in employee",,,Insurance;
            OptionCaption = ' ,Leave Request,Travel Request,Travel Claim,Transfer,Overtime,Out of Office,Bulk Cash,Resignation,Medical Insurance Claim,Promotion,Attendance Missed,Access Control,Changes in employee,,,Insurance';
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

    local procedure CheckSampleAttachment();
    var
        IncomingDoc: Record "Incoming Document";
    begin
        if Type = Type::Sample then begin
            IncomingDoc.Reset();
            IncomingDoc.SetRange("Attachment Code", "Attachment Code");
            IncomingDoc.SetRange(Type, IncomingDoc.Type::Sample);
            if IncomingDoc.FindFirst() then
                Error('Sample attachment already exist for attachment %1', "Attachment Code");
        end;
    end;
}
