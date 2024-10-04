tableextension 33019805 "Incoming Document Ext" extends "Incoming Document"
{
    fields
    {
        field(33019800; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(33019801; "Table ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33019802; "File Name"; Text[250])
        { DataClassification = CustomerContent; }
        field(33019803; "Attachment Code"; Code[20])
        {
            TableRelation = "Attachment Master".Code;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckSampleAttachment;
            end;
        }
        field(33019804; "Employee Code"; Code[20])
        { DataClassification = CustomerContent; }
        field(33019805; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Sample;
            OptionCaption = ' ,Sample';
            trigger OnValidate()
            begin
                CheckSampleAttachment;
            end;
        }
        field(33019806; "Leave Type Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";
            DataClassification = CustomerContent;
        }
        field(33019807; "Employee Activity Type"; Option)
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
