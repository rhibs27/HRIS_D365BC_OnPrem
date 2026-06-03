table 50010 "Functional Title"
{
    DrillDownPageId = "Functional Title List";
    LookupPageId = "Functional Title List";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(4; Locationwise; Boolean) { }
        field(5; "Communication Rein."; Decimal) { }
        field(6; "Rank Value"; Decimal) { }
        field(7; "Rank Check Range"; Text[30]) { }
        field(8; "Check Branchwise Only"; Boolean) { }
        field(9; "Risk Title"; Boolean) { }
        field(10; "Written Exam"; Boolean) { }
        field(11; "Group Discussion"; Boolean) { }
        field(12; "Evening Counter Eligible"; Boolean) { }
        field(13; "Holiday Counter Eligible"; Boolean) { }
        field(14; "Allowance Reminder Mail"; Boolean) { }
        field(15; "Allow AllowanceAssignment"; Boolean) { }
        field(16; "EM/ECM Identifier"; Boolean) { }
        field(17; "BM/OBM"; Boolean) { }
        field(18; Blocked; Boolean) { }
        field(20; "Is Specific Functional"; Boolean) { }
        field(21; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));
        }
        field(22; "BM Allowance"; Decimal) { }
        field(23; "Allow ShiftAssignment"; Boolean) { }
        field(24; "Attendance View"; Boolean) { }
        field(25; "Functional Title Role"; Enum "Functional Title Role")
        {
            Caption = 'Functional Title Role';
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
