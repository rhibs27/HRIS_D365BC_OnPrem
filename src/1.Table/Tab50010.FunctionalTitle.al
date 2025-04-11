table 50010 "Functional Title"
{
    DrillDownPageId = "Functional Title List";
    LookupPageId = "Functional Title List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(3; "COPO/COSPO Allowance"; Decimal) { }
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
        field(15; "Is Allowance Approval"; Boolean) { }
        field(16; "EM/ECM Identifier"; Boolean) { }
        field(17; "BM/OBM"; Boolean) { }
        field(18; Blocked; Boolean) { }
        field(19; "KPI Incentive %"; Decimal) { }
        field(20; "Is Specific Functional"; Boolean) { }
        field(21; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Organization Structure list"::Department), Blocked = filter(false));
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
