table 50119 "System Access Control"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Type of Masters"; Option)
        {
            OptionCaption = ' ,System Category,System Type,System Control Setup';
            OptionMembers = " ","System Category","System Type","System Control Setup";
        }
        field(2; "Code"; Code[20])
        {
            TableRelation = if ("Type of Masters" = const("System Control Setup")) "System Access Control".Code where("Type of Masters" = const("System Type"));

            trigger OnValidate()
            begin
                if "Type of Masters" = "Type of Masters"::"System Control Setup" then begin
                    SystemAccessControl.Reset;
                    SystemAccessControl.SetRange(Code, Code);
                    if SystemAccessControl.FindFirst then begin
                        Validate(Name, SystemAccessControl.Name);
                        Validate("System Category Code", SystemAccessControl."System Category Code");
                    end else
                        Clear(Name);
                end else
                    Clear(Name);
            end;
        }
        field(3; Name; Text[50]) { }
        field(4; "System Category Code"; Code[20])
        {
            TableRelation = if ("Type of Masters" = filter("System Control Setup" | "System Type")) "System Access Control".Code where("Type of Masters" = const("System Category"));

            trigger OnValidate()
            begin
                if "Type of Masters" in ["Type of Masters"::"System Type", "Type of Masters"::"System Control Setup"] then begin
                    SystemAccessControl.Reset;
                    SystemAccessControl.SetRange(Code, "System Category Code");
                    if SystemAccessControl.FindFirst then
                        Validate("System Category Name", SystemAccessControl.Name)
                    else
                        Clear("System Category Name");
                end else
                    Clear("System Category Name");
            end;
        }
        field(5; "System Category Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "System Department Owner"; Code[20])
        {
            TableRelation = Department;

            trigger OnValidate()
            begin
                if Department.Get("System Department Owner") then
                    Validate("Department Name", Department.Name)
                else
                    Clear("Department Name");
            end;
        }
        field(7; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "System Owner Email ID"; Text[30]) { }
    }

    keys
    {
        key(Key1; "Type of Masters", "Code", "System Department Owner") { }
    }

    fieldgroups { }

    var
        SystemAccessControl: Record "System Access Control";
        Department: Record Department;
}
