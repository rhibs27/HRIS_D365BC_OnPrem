table 50111 "Attachment Setup"
{
    Caption = 'Attachment Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; "Attachment Code"; Code[20])
        {
            TableRelation = "Attachment Master".Code;
        }
        field(3; "Table ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(4; Type; Enum "Attachment Setup Type")
        {
            trigger OnValidate()
            begin
                if Type <> xRec.Type then begin
                    Clear("Leave Type Code");
                    Clear("Transfer Category");
                end;

                TestField("Attachment Code");

                if Type <> Type::" " then
                    SyncNewAttachmentSetup;
            end;
        }
        field(5; "Purpose of Housing Loan"; Enum "Purpose of Housing Loan")
        {
            Description = 'Home';
        }
        field(6; Mandatory; Boolean) { }
        field(7; "Qualification Type"; Enum "Qualification Type")
        {
        }
        field(8; Enhancement; Boolean) { }
        field(9; "Leave Type Code"; Code[20])
        {
            TableRelation = if (Type = const("Leave Request")) "Leave Type Setup";
        }
        field(10; "Board Approval"; Boolean)
        {
            Description = 'Home Loan';
        }
        field(11; "Transfer Category"; Enum "Transfer Category")
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if "Transfer Category" <> xRec."Transfer Category" then
                    TestField(Type, Type::Transfer);
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        GetEntryNo();
    end;

    var
        AttachmentMandatory: Record "Attachment Setup";
        PGSetup: Record "Payroll General Setup";

    local procedure GetEntryNo()
    begin
        AttachmentMandatory.Reset;
        AttachmentMandatory.SetCurrentKey("Entry No.");
        if AttachmentMandatory.FindLast then
            "Entry No." := AttachmentMandatory."Entry No." + 1
        else
            "Entry No." := 1;
    end;

    local procedure SyncNewAttachmentSetup()
    begin
        if not Confirm('Do you want to update this attachment in all existing documents?', false) then
            exit;

        case Type of
            Type::"Salary Advance":
                InsertNewAttachments(1);

            Type::"Personal Loan":
                InsertNewAttachments(2);

            Type::"Home Loan":
                InsertNewAttachments(3);

            Type::"Vehicle Loan":
                InsertNewAttachments(4);
        end;
    end;

    local procedure InsertNewAttachments(LoanType: Option " ","Salary Advance","Personal Loan","Home Loan","Vehicle Loan")
    var
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        IncomingDocument: Record "Incoming Document";
        EntryNo: Integer;
    begin
        PGSetup.Get;
        EmployeeLoanAdvance.Reset;
        EmployeeLoanAdvance.SetRange("Loan Type", LoanType);
        EmployeeLoanAdvance.SetRange("Requested Loan Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmployeeLoanAdvance.FindFirst then
            repeat
                IncomingDocument.Reset;
                IncomingDocument.SetRange("Attachment Code", "Attachment Code");
                IncomingDocument.SetRange("No.", EmployeeLoanAdvance."No.");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    if IncomingDocument.FindLast then
                        EntryNo := IncomingDocument."Entry No." + 1
                    else
                        EntryNo := 1;

                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := EntryNo;
                    IncomingDocument.Validate("Employee Code", EmployeeLoanAdvance."Employee Code");
                    IncomingDocument.Validate("No.", EmployeeLoanAdvance."No.");
                    IncomingDocument.Validate("Attachment Code", "Attachment Code");
                    IncomingDocument.Validate("Table ID", Database::"Employee Loan/Advance");
                    IncomingDocument.Insert(true);
                end;
            until EmployeeLoanAdvance.Next = 0;
    end;
}
