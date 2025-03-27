table 50100 "Attendance Ledger Entry"
{
    DataClassification = CustomerContent;
    // version AMS6.1.0

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            TableRelation = "Employee Service History";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            TableRelation = "HR Budget Plan";
        }
        field(3; "Journal Line No."; Integer) { }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(7; "Attendance Date"; Date)
        {
            Editable = false;
        }
        field(8; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(9; "Day Type"; Enum "Day Type")
        {
            Editable = false;

        }
        field(10; "Entry Type"; Enum "Attendance Entry Type")
        {
        }
        field(11; "Entry Subtype"; Enum "Leave Pay Type")
        {
        }
        field(12; Days; Decimal)
        {
            Description = '+ve means Present Qty. & -ve means Absent Qty.';
            Editable = false;
        }
        field(13; "Login frequency"; Integer) { }
        field(14; "Logout frequency"; Integer) { }
        field(15; "Presence Minutes"; Decimal) { }
        field(16; "Absense Minutes"; Decimal) { }
        field(17; "Adjustment Type"; Enum "Adjustment Type")
        {
        }
        field(18; "Adjustment Minutes"; Decimal) { }
        field(19; "Conflict Exists"; Boolean)
        {
            Editable = true;
        }
        field(20; "Conflict Description"; Text[250])
        {
            Editable = false;
        }
        field(21; Correction; Boolean) { }
        field(22; "Corrected By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(23; "Correction Reason"; Text[200]) { }
        field(24; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(25; "System Remarks"; Text[250]) { }
        field(26; "Source No."; Code[100]) { }
        field(27; "Unpaid Days"; Decimal)
        {
            Description = 'RL, added as HR requirement';
            Editable = false;
        }
        field(28; "Late Ded"; Decimal)
        {
            Description = 'RL, added as HR requirement';
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.", "Attendance Date") { }
        key(Key2; "Employee No.", "Attendance Date") { }
    }

    fieldgroups { }
}
