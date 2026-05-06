table 50186 "Loan Settlement Entry"
{
    Caption = 'Loan Settlement Entry';
    DataCaptionFields = "Entry No.", "Loan No.", "Employee No.";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            TableRelation = "Employee Loan/Advance";
            Editable = false;
        }
        field(3; "Settlement Source No."; Code[20])
        {
            Caption = 'Settlement Source No.';
            TableRelation = "Loan Settlement";
            Editable = false;
        }
        field(4; "Settlement Date"; Date)
        {
            Caption = 'Settlement Date';
            Editable = false;
        }
        field(5; "Settled Amount"; Decimal)
        {
            Caption = 'Settled Amount';
            Editable = false;
            MinValue = 0;
        }
        field(6; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(7; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
            Editable = false;
        }
        field(8; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            Editable = false;
        }
        field(9; "Loan Type"; Enum "Loan Type")
        {
            Caption = 'Loan Type';
            Editable = false;
        }
        field(10; "Settlement Type"; Enum "Settlement Type")
        {
            Caption = 'Settlement Type';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.") { Clustered = true; }
        key(Key2; "Loan No.") { }
        key(Key3; "Employee No.", "Loan Type") { }
    }

    trigger OnDelete()
    begin
        Error('Loan Settlement Entries cannot be deleted after posting.');
    end;

    procedure GetNextEntryNo(): Integer
    var
        LoanSettlementEntry: Record "Loan Settlement Entry";
    begin
        LoanSettlementEntry.Reset();
        if LoanSettlementEntry.FindLast() then
            exit(LoanSettlementEntry."Entry No." + 1);
        exit(1);
    end;
}
