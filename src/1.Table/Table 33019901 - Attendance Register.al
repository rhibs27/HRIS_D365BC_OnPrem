table 33019901 "Attendance Register"
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
        field(3; "Line No."; Integer) { }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
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
        field(7; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "Attendance From"; Date)
        {
            Editable = false;
        }
        field(9; "Attendance To"; Date)
        {
            Editable = false;
        }
        field(10; "Present Days"; Integer)
        {
            Editable = false;
        }
        field(11; "Absent Days"; Integer)
        {
            Editable = true;
        }
        field(12; "Paid Days"; Decimal)
        {
            trigger OnValidate()
            begin
                "Actual PaidDays" := "Paid Days" - "Late Ded";
            end;
        }
        field(13; "Attendance Month"; Enum "Nepali Month")
        {
            CalcFormula = lookup("English-Nepali Date"."Nepali Month" where("English Date" = field("Attendance From")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Attendance Year"; Integer)
        {
            CalcFormula = lookup("English-Nepali Date"."Nepali Year" where("English Date" = field("Attendance From")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Leave Earn"; Boolean) { }
        field(16; "Leave Earn Date"; Date) { }
        field(17; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(18; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(19; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(20; "Source No."; Code[20]) { }
        field(21; "Total Holidays"; Integer)
        {
            CalcFormula = count("Attendance Ledger Entry" where("Journal Template Name" = field("Journal Template Name"),
                                                                 "Journal Batch Name" = field("Journal Batch Name"),
                                                                 "No." = field("No."),
                                                                 "Journal Line No." = field("Line No."),
                                                                 "Employee No." = field("Employee No."),
                                                                 "Day Type" = filter(Holiday)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Late Ded"; Decimal)
        {
            Description = 'RL,added as per HR requirement';

            trigger OnValidate()
            begin
                "Actual PaidDays" := "Paid Days" - "Late Ded";
            end;
        }
        field(23; "Unpaid Days"; Decimal)
        {
            CalcFormula = sum("Attendance Ledger Entry"."Unpaid Days" where("Journal Template Name" = field("Journal Template Name"),
                                                                             "Journal Batch Name" = field("Journal Batch Name"),
                                                                             "No." = field("No."),
                                                                             "Journal Line No." = field("Line No."),
                                                                             "Employee No." = field("Employee No."),
                                                                             "Entry Subtype" = const(Unpaid)));
            Description = 'RL,added as per HR requirement';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Actual PaidDays"; Decimal)
        {
            Description = 'RL,added as per HR requirement';

            trigger OnValidate()
            begin
                "Actual PaidDays" := "Paid Days" - "Late Ded";
            end;
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.", "Attendance From", "Attendance To") { }
        key(Key2; "Employee No.", "Attendance From", "Attendance To") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        AttLedgEntry.Reset;
        AttLedgEntry.SetRange("No.", "No.");
        AttLedgEntry.SetRange("Journal Template Name", "Journal Template Name");
        AttLedgEntry.SetRange("Journal Batch Name", "Journal Batch Name");
        AttLedgEntry.SetRange("Journal Line No.", "Line No.");
        AttLedgEntry.SetRange("Employee No.", "Employee No.");
        if AttLedgEntry.FindSet then
            AttLedgEntry.DeleteAll;
    end;

    var
        AttLedgEntry: Record "Attendance Ledger Entry";
}
