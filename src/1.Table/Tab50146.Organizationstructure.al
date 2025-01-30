table 50146 "Organization structure"
{
    Caption = 'Organization structure';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum "Organization Structure list")
        {
            Caption = 'Type';
            // TableRelation = "Organization Structure List";
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
        field(5; "Head"; Code[20])
        {
            Caption = 'Head';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Head") then begin
                    Validate("Head Name", Employee."Full Name");
                    Validate("Head Approver ID", Employee."NAV Login ID");
                end;
            end;
        }
        field(6; "Head Name"; Text[50])
        {
            Caption = 'Head Name';
            Editable = false;

        }
        field(7; "Head Approver ID"; Code[50])
        {
            Caption = 'Head Approver ID';
            Editable = false;
        }
        field(8; "Deputy Head"; Code[20])
        {
            Caption = 'Deputy Head';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Deputy Head") then begin
                    Validate("Deputy Head Name", Employee."Full Name");
                    Validate("Deputy Head Approver ID", Employee."NAV Login ID");
                end;
            end;
        }
        field(9; "Deputy Head Name"; Text[50])
        {
            Caption = 'Deputy Head Name';
            Editable = false;

        }
        field(10; "Deputy Head Approver ID"; Code[50])
        {
            Caption = 'Deputy Head Approver ID';
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
}
