table 50147 "Organization Structure List"
{
    Caption = 'Organization Structure List';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum "Deputation Type")
        {
            Caption = 'Type';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(4; "Province Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Province Code"; text[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(6; "Region"; Enum Region)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(7; "InsideOutside Valley"; Enum "Outside/Inside Valley")
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(8; "District code"; Code[20])
        {
            TableRelation = District."District Code";
            trigger OnValidate()
            var
                District: Record District;
            begin
                if District.Get("District code") then begin
                    Validate("District Name", District."District Name");
                    Validate("Province Code", District.Province);
                    Validate("Province Name", District."Province Name");
                    Validate("Region", District.Region);
                    Validate("InsideOutside Valley", District."InsideOutside Valley");
                end else begin
                    Clear("Province Name");
                    Clear("Province Code");
                    Clear("Region");
                    Clear("InsideOutside Valley");
                end;
            end;
        }
        field(9; "Municipality Code"; Code[20])
        {
            TableRelation = "Municipality" where("District Name" = field("District Name"));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Municipality: Record "Municipality";
            begin
                if Municipality.Get("Municipality Code") then begin
                    Validate("Municipality Name", Municipality."Municipality Name");
                end else begin
                    Clear("Municipality Name");
                end;
            end;
        }
        field(10; "Remote Area Category"; Code[20])
        {
            TableRelation = "Remote Area Category";
            DataClassification = CustomerContent;
        }
        field(11; "Remote Area Reduction"; Code[20])
        {
            TableRelation = "Remote Area Category";
            DataClassification = CustomerContent;
        }
        field(12; "Blocked"; Boolean)
        {
        }
        field(13; "District Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Municipality Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Sol ID"; Code[20])
        {
            Caption = 'Sol ID';
            DataClassification = CustomerContent;
        }
        field(17; "Dimension Value Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Deputation On Type" = field(Type));
        }
        field(30; "No. of Vault Key"; Integer)
        {

        }
        field(31; "No. of Off-Site ATM"; Integer) { }
        field(32; "No. of On-Side ATM"; Integer) { }

    }
    keys
    {
        key(PK; "Type", Code)
        {
            Clustered = true;
        }
    }
}
