table 50162 "Assignment Memo Ledger Entry"
{
    //data in this table will be created only after approval of assignment memo documents.
    Caption = 'Assignment Memo Ledger Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Enrty No."; Integer)
        {
            Caption = 'Enrty No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(7; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(8; "Applied Employee No."; Code[20])
        {
            Caption = 'Applied Employee No.';
        }
        field(9; "Applied Document No."; Code[20])
        {
            Caption = 'Applied Document No.';
        }
        field(10; "Employee Activity Type"; Enum "Employee Activity Type")
        {
            Caption = 'Employee Activity Type';
        }
        field(11; "Payroll Attribute Code"; Code[20])
        {
            Caption = 'Payroll Attribute Code';
        }
    }
    keys
    {
        key(PK; "Enrty No.")
        {
            Clustered = true;
        }
        key(key2; "Employee No.", "Document No.", "Posting Date", "Employee Activity Type")
        {
        }
        key(key3; "Applied Document No.", "Applied Employee No.", Open)
        {
        }
    }

    procedure GetNextEntryNo(): Integer
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if AssignmentMemoLedgerEntry.FindLast() then
            exit(AssignmentMemoLedgerEntry."Enrty No." + 1)
        else
            exit(1);
    end;
}
