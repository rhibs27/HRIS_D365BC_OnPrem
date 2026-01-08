table 50173 "Appraisal KRA Master"
{
    DrillDownPageId = "Appraisal KRA Master";
    LookupPageId = "Appraisal KRA Master";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[50]) { }
        field(2; Description; Text[250]) { }
        field(3; Type; Enum "Key Value Master Type")
        {
            trigger OnValidate()
            begin
                if Type <> Type::"KRA Master" then begin
                    "Employment Type" := "Employment Type"::" ";
                    "Check Date From" := "Check Date From"::" ";
                    Clear("Minimum Service Period");
                end;
            end;
        }
        field(4; "Employment Type"; Enum "Employee Type") { }
        field(5; "Check Date From"; enum "Check Date From") { }
        field(6; "Minimum Service Period"; DateFormula) { }
    }

    keys
    {
        key(Key1; "Code", Type) { }
    }

    fieldgroups { }
}