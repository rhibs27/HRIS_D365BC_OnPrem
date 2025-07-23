table 50081 "Job Desc./Spec. Entry"
{
    // version HRM1.00
    Caption = 'Job Description/Specification';
    // DrillDownPageId = "Retirement Fund Entity";
    // LookupPageId = "Retirement Fund Entity";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vacancy Code"; Code[20])
        {
            TableRelation = "Vacancy Header";
        }
        field(2; "Line No."; Integer) { }
        field(3; "Job Description Code"; Code[20]) { }
        field(4; Type; Enum "Job Desc./Spec. Entry Type ")
        {

        }
        field(5; "Job Description"; Text[250]) { }
        field(6; Rank; Integer) { }
    }

    keys
    {
        key(Key1; "Vacancy Code", Type, "Line No.") { }
    }

    fieldgroups { }
}
