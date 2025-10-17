table 50031 "Emp. Act. Ledger Entry"
{
    Caption = 'Emp. Act Ledger Entries';
    DataClassification = AccountData;

    fields
    {
        field(1; "Document Type"; Enum "Employee Activity Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get("Employee No.") then
                    "Employee Name" := Emp.FullName();
            end;
        }
        field(4; "Event Date"; Date)
        {
            Caption = 'Event Date';
        }
        field(5; "Cancellation Entry"; Boolean)
        {
            Caption = 'Cancellation Entry';
        }
        field(6; "Employee Name"; Text[150])
        {
            Caption = 'Employee Name';
        }
        field(7; Day; Decimal)
        {
            Caption = 'Day';
        }
        field(8; "Leave Type"; Enum "Day Type")
        {
            Caption = 'Leave Type';
        }
        field(9; Narration; Text[150])
        {
            Caption = 'Narration';
        }
        field(11; "Leave Code"; Code[20]) { }
    }
    keys
    {
        key(PK; "Document Type", "Document No.", "Employee No.", "Event Date", "Cancellation Entry")
        {
            Clustered = true;
        }
    }
}
