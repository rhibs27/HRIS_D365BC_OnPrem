table 50120 "Access Control Details"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Type; Option)
        {
            OptionMembers = " ","Funtional Title",Employee;
        }
        field(2; "Code"; Code[20])
        {
            TableRelation = if (Type = const("Funtional Title")) "Functional Title"
            else if (Type = const(Employee)) Employee;
        }
        field(3; Description; Text[50]) { }
        field(4; "System Type Code"; Code[20])
        {
            TableRelation = "System Access Control".Code where("Type of Masters" = const("System Control Setup"));

            trigger OnValidate()
            begin
                SystemAccessControl.Reset;
                SystemAccessControl.SetRange("Type of Masters", SystemAccessControl."Type of Masters"::"System Type");
                SystemAccessControl.SetRange(Code, "System Type Code");
                if SystemAccessControl.FindFirst then begin
                    Validate("System Type Name", SystemAccessControl.Name);
                    Validate("System Category Code", SystemAccessControl."System Category Code");
                    Validate("System Category Name", SystemAccessControl."System Category Name");
                end else begin
                    Clear("System Category Name");
                    Clear("System Category Code");
                    Clear("System Type Name");
                end;
            end;
        }
        field(5; "System Type Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "System Category Code"; Code[20])
        {
            Editable = false;
        }
        field(7; "System Category Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "Line No."; Integer) { }
        field(9; "Granted Date"; Date) { }
    }

    keys
    {
        key(Key1; Type, "Code", "Line No.") { }
    }

    fieldgroups { }

    var
        SystemAccessControl: Record "System Access Control";
}
