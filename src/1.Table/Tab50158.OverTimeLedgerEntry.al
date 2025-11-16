table 50158 "OverTime Ledger Entry"
{
    Caption = 'OverTime Ledger Entry';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "No"; Code[20])
        {
        }
        field(2; Type; Enum "Employee Activity Type")
        {
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            var
                EmpVar: Record Employee;
            begin
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
        }
        field(5; Posted; Boolean)
        {
        }
        field(7; "Start Date"; Date)
        {
        }
        field(8; "End Date"; Date)
        {
        }
        field(9; "No. of Days"; Decimal)
        {
            Editable = false;

        }
        field(10; "Requested Date"; Date)
        {
        }
        field(11; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(12; "Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(13; "End Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(14; Remarks; Text[100])
        {
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
        }
        field(22; "Line No"; Integer)
        {
            Editable = false;
        }
        field(23; "Employee Work Shift"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(26; "Posting Date"; Date)
        {
            Editable = false;
        }

        field(32; "Compensatory Days"; Decimal)
        {
        }
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
        }
        field(39; Cancelled; Boolean) //Used in all Employee activity
        {
        }

        // OverTime 

        field(82; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(83; "Encashment Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(84; "OT Disbursed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85; "Payroll No."; Code[20])
        {
        }
        field(86; "CheckIn Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(87; "CheckOut Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(89; "CheckOut OverNight"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90; "Overtime Claim Type"; Enum "Overtime Claim Type")
        {
            DataClassification = ToBeClassified;
        }
        field(91; "Estimated Hours"; Decimal)
        {
        }
        field(92; "Actual OT Hours"; Decimal)
        {
        }
        field(93; "OT Amount"; Decimal)
        {
            Editable = false;
        }
        field(94; "OT Eligible Hours"; Decimal)
        {
            Editable = false;
        }
        field(95; "Morning OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(96; "Evening OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(97; "Total OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(98; "Adjustment Type"; Enum "Leave Earn Type")
        {
            ValuesAllowed = Used, Adjustment;
        }
        field(101; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        GetEntryNo;
        if "Posting Date" = 0D then
            "Posting Date" := Today;
    end;

    trigger OnDelete()
    begin
        Error('Cannot delete');
    end;

    local procedure GetEntryNo()
    var
        OverTimeLedgerEntry: Record "OverTime Ledger Entry";

    begin
        if OverTimeLedgerEntry.FindLast() then
            "Entry No" := OverTimeLedgerEntry."Entry No" + 1
        else
            "Entry No" := 1;
    end;
}