table 50057 "KRA Master Setup"
{
    // version NIC Asia 1.0,Recruitement

    DrillDownPageId = "KRA Master Setup";
    LookupPageId = "KRA Master Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "KRA No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "KRA No." <> xRec."KRA No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."KRA Setup No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Weightage; Integer) { }
        field(3; "Key Result Area"; Code[20])
        {
            TableRelation = "Key Value Master".Code where(Type = filter("Key Result Area"));
        }
        field(4; "KRA Master Name"; Text[250]) { }
        field(5; "KRA Category"; Code[50])
        {
            TableRelation = "Key Value Master".Code where(Type = filter("KRA Category"));

            trigger OnValidate()
            begin
                KeyValueMasterRec.Reset;
                KeyValueMasterRec.SetRange(Type, KeyValueMasterRec.Type::"KRA Category");
                KeyValueMasterRec.SetRange(Code, "KRA No.");
                if KeyValueMasterRec.FindFirst then
                    Validate("KRA Master Name", KeyValueMasterRec.Description);
            end;
        }
        field(6; "Deputation on"; Enum "Deputation Type")
        {

        }
        field(7; Description; Text[250]) { }
        field(8; "Weightage Percent"; Decimal) { }
        field(9; "Target Assigned"; Decimal) { }
        field(10; "Actual Achievement"; Decimal) { }
        field(11; "Sol Id"; Code[20]) { }
        field(12; "Province Code"; Code[10])
        {
            TableRelation = Province;

            trigger OnValidate()
            begin
            end;
        }
        field(13; "Sub Province Code"; Code[20])
        {
            Caption = 'Sub Province Code';
            TableRelation = "Sub Province";

            trigger OnValidate()
            begin
            end;
        }
        field(14; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; "Employee Code"; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(16; "Transfer Deputation on"; Enum "Deputation Type")
        {

        }
        field(17; "Transfer Province Code"; Code[10])
        {
            TableRelation = Province;

            trigger OnValidate()
            begin
            end;
        }
        field(18; "Transfer Sub Province Code"; Code[20])
        {
            Caption = 'Sub Province Code';
            TableRelation = "Sub Province";

            trigger OnValidate()
            begin
            end;
        }
        field(19; "Transfer Sol Id"; Code[20]) { }
    }

    keys
    {
        key(Key1; "KRA No.") { }
        key(Key2; "KRA Category") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "KRA No." = '' then begin
            HumanResSetup.get();
            HumanResSetup.TestField("KRA Setup No.");
            NoSeriesMgt.InitSeries(HumanResSetup."KRA Setup No.", xRec."No. Series", 0D, "KRA No.", "No. Series");
        end;
    end;

    var
        KeyValueMasterRec: Record "Key Value Master";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
