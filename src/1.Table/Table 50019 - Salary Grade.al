table 50019 "Salary Grade"
{
    // version PRM19.01.01

    DrillDownPageId = "Salary Grades";
    LookupPageId = "Salary Grades";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Description; Text[50]) { }
        field(3; "Standard Step"; Code[10]) { }
        field(4; "Grade Percentage"; Decimal) { }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
