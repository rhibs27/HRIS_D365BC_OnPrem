table 50084 "Rolewise Job Description"
{
    // version HRM1.00
    DataCaptionFields = "Role Code", "Job Description Code";
    DrillDownPageId = "Leave Earn";
    LookupPageId = "Leave Earn";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Role Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Job Title";
        }
        field(2; "Job Description Code"; Code[20]) { }
        field(3; "Job Description"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Role Code", "Job Description Code") { }
    }

    fieldgroups { }
}
