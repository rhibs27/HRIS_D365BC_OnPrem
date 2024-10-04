table 50015 "Employee Hierarchy Master"
{
    // version NIC Asia1.00

    Caption = 'Employee Hierarchy Master';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            trigger OnValidate()
            begin
                CodeMandetory;
            end;
        }
        field(2; Description; Text[100])
        {
            trigger OnValidate()
            begin
                CodeMandetory;
            end;
        }
        field(3; "Sub-Province"; Code[20])
        {
            TableRelation = "Sub Province".Code;
        }
        field(4; Type; Enum "Employee Hierarchy Type")
        {

        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(6; "Sol ID"; Code[10]) { }
        field(7; "Department Code"; Code[10])
        {
            TableRelation = Department;
        }
        field(8; "Reporting Category"; Code[10])
        {
            TableRelation = "Reporting Category";
        }
        field(9; Blocked; Boolean) { }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }

    local procedure CodeMandetory()
    begin
        if Code = '' then //Min
            Error('Code must have a value.');
    end;
}
