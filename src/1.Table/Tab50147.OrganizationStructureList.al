table 50147 "Organization Structure List"
{
    Caption = 'Organization Structure List';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum "Organization Structure list")
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
        field(5; "Province Code"; text[10])
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
        field(8; "District Name"; Text[50])
        {
            TableRelation = District."District Name";
            trigger OnValidate()
            var
                District: Record District;
            begin
                District.Reset();
                District.SetRange("District Name", "District Name");
                if District.FindFirst() then begin
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
        field(9; "Municipality"; text[50])
        {
            TableRelation = "Municipality"."Municipality Name" where("District Name" = field("District Name"));
            DataClassification = ToBeClassified;
        }
        field(10; "Remote Area Category"; Code[20])
        {
            TableRelation = "Remote Area Category";
            DataClassification = CustomerContent;
        }
        field(11; "Remote Area Reduction"; Code[10])
        {
            TableRelation = "Remote Area Category";
            DataClassification = CustomerContent;
        }
        field(12; "Blocked"; Boolean)
        {
        }
    }
    keys
    {
        key(PK; "Type", Code)
        {
            Clustered = true;
        }
    }
}
