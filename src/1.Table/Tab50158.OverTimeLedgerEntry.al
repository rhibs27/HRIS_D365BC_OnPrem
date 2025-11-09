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
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Branch Code", EmpVar."Branch Code");
                    Validate("Department Code", EmpVar."Department Code");
                    Validate("Deputation On", EmpVar."Deputation on");
                    validate("Deputation On Code", EmpVar."Deputation on code");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate("Department Name", EmpVar."Department Name");
                    Validate("Province Name", EmpVar."Province Name");
                end;
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
        }
        field(5; Posted; Boolean)
        {
        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
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
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
        }
        field(18; "Department Code"; Code[20])
        {
            Editable = false;
        }
        field(19; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(21; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
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
        field(24; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(26; "Posting Date"; Date)
        {
            Editable = false;
        }

        field(28; "Extension Counter Code"; Code[20])
        {
        }
        field(30; "Province Code"; Code[20])
        {
        }
        field(31; "Unit Code"; Code[20])
        {
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
        field(40; "Branch Code"; Code[20]) //Used in all Employee activity
        {
        }

        field(61; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(62; "Deputation On Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(63; "Province Name"; Code[50])
        {
            DataClassification = ToBeClassified;
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