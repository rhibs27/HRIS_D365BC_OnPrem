table 50019 "Salary Grade"
{
    DrillDownPageId = "Salary Grades";
    LookupPageId = "Salary Grades";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[50]) { }
        field(3; "Standard Step"; Code[20]) { }
        field(4; "Grade Percentage"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
