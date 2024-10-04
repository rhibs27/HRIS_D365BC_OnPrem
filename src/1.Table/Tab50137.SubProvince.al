table 50137 "Sub Province"
{
    Caption = 'Sub Province';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; City; Text[30])
        {
            Caption = 'City';
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                TestField(Code);
                "Search City" := City;
                if xRec."Search City" <> "Search City" then begin
                    PostCode.SetRange("Search City", "Search City");
                    PostCode.SetRange(Code, Code);
                    if not PostCode.IsEmpty() then
                        Error(Text000, FieldCaption(City), City);
                end;
            end;
        }
        field(3; "Search City"; Code[30])
        {
            Caption = 'Search City';
        }
        field(4; "Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            Caption = 'Country/Region Code';
        }
        field(5; County; Text[30])
        {
            Caption = 'County';
        }
        field(6; "Province Code"; Code[10])
        {
            TableRelation = Province;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var

                ProvinceVar: Record "Service Zone";
            begin
                if ProvinceVar.Get("Province Code") then
                    Validate("Province Name", ProvinceVar.Description)
                else
                    Clear("Province Name");
            end;
        }
        field(7; "Province Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Sol ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Posting Region"; Enum Region)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Inside/Outside Valley"; Enum "Outside/Inside Valley")
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Reporting Category"; Code[10])
        {
            // TableRelation = "Reporting Category"; todo
            DataClassification = ToBeClassified;
        }
        field(12; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }

    }
    var
        Text000: Label 'ENU=%1 %2 already exists.';
}
