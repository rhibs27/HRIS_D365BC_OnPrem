table 50065 "KPI Actions"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Fiscal Year"; Text[30]) { }
        field(2; "Employee Code"; Code[20])
        {
            Editable = false;
            TableRelation = Appraisal."Employee Code";
        }
        field(3; "KPI Quater"; Enum Quater)
        {
            Editable = false;
        }
        field(4; "Line No."; Integer) { }
        field(5; "Action Line No."; Integer)
        {
            Editable = false;
        }
        field(6; "Action Comment"; Text[100]) { }
        field(7; "Appraisal I's Remarks"; Text[100]) { }
        field(8; "Appraisal II's Remarks"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Fiscal Year", "Employee Code", "KPI Quater", "Line No.", "Action Line No.") { }
    }

    fieldgroups { }
}
