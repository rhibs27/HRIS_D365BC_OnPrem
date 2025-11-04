table 50162 "Assignment Memo Ledger Entry"
{
    //data in this table will be created only after approval of assignment memo documents.
    Caption = 'Assignment Memo Ledger Entry';
    DataClassification = ToBeClassified;
    LookupPageId = "Assignment Memo Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
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
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then
                    "Employee Name" := Employee.FullName()
                else
                    "Employee Name" := '';
            end;
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
        field(8; "Substituted Employee No."; Code[20])
        {
            Caption = 'Substituted Employee No.';
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
        field(12; "Valid From Date"; Date)
        {
            Caption = 'Valid From Date';
        }
        field(13; "Valid To Date"; Date)
        {
            Caption = 'Valid To Date';
        }
        field(14; Claimed; Boolean)
        {
            Caption = 'Claimed';
        }
        field(15; "Claimed Doc No."; Code[20])
        {
            Caption = 'Claimed Doc No.';
        }
        field(16; Panel; Enum Panel) { }
        field(17; "ATM Site"; Enum "ATM Site") { }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Employee No.", "Document No.", "Posting Date", "Employee Activity Type")
        {
        }
        key(key3; "Applied Document No.", "Substituted Employee No.", Open)
        {
        }
    }

    procedure GetNextEntryNo(): Integer
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if AssignmentMemoLedgerEntry.FindLast() then
            exit(AssignmentMemoLedgerEntry."Entry No." + 1)
        else
            exit(1);
    end;
}
