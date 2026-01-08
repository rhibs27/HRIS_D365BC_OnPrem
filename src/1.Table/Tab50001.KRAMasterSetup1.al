table 50001 "KRA Master Setup1"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "KRA No."; Code[20]) { }
        field(2; "KRA Category"; Code[50])
        {
            TableRelation = "Appraisal KRA Master".Code where(Type = filter("KRA Master"));

            trigger OnValidate()
            begin
                /*KeyValueMasterRec.Reset();
                KeyValueMasterRec.SetRange(Type, KeyValueMasterRec.Type::"KRA Category");
                KeyValueMasterRec.SetRange(Code, "KRA Category");
                IF KeyValueMasterRec.FindFirst() THEN
                  VALIDATE("KRA Master Name", KeyValueMasterRec.Description);*/
            end;
        }
        field(3; Weightage; Integer) { }
        field(4; "Key Result Area"; Code[20])
        {
            TableRelation = "Appraisal KRA Master".Code where(Type = filter("KRA Subtype"));
        }
        field(5; "Deputation on"; Enum "Deputation Type") { }
        field(6; Description; Text[250]) { }
        field(7; "Weightage(%)"; Decimal) { }
        field(8; "Target Assigned"; Decimal) { }
        field(9; "Actual Achievement"; Decimal) { }
        field(10; "Sol Id"; Code[20]) { }
        field(11; "Province Code"; Code[20])
        {
            TableRelation = Province;
        }
    }

    keys
    {
        key(Key1; "KRA No.") { }
    }

    fieldgroups { }
}
