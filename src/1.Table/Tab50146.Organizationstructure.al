table 50146 "Organization structure"
{
    Caption = 'Organization structure';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum "Organization Structure list")
        {
            Caption = 'Type';
            trigger OnValidate()
            var
            begin
                if Type <> xRec.Type then
                    Clear(code);
            end;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Organization Structure List".Code where(Type = field(Type));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if OrganizationStructureList.Get(Type, "Code") then
                    Validate("Name", OrganizationStructureList.Name);
            end;
        }
        field(3; Name; Text[100])
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Type", Code)
        {
            Clustered = true;
        }
    }
    trigger OnDelete()

    begin
        OrganizationStructureList.Reset();
        OrganizationStructureList.SetRange(Type, Type);
        OrganizationStructureList.SetRange(Code, Code);
        OrganizationStructureList.DeleteAll();
    end;

    var
        OrganizationStructureList: Record "Organization Structure Line";
}
